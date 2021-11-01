public  class LoanAppPacketTriggerHelper {
    public void updateLoanAppPacketFromList(List<EB_Loan_Packet__c> oldList, Map<Id, EB_Loan_Packet__c> newMap){        
        RecordType archived = Utility.RecordTypeObject('EB_Loan_Packet__c', 'Archived');
                
        //List<EB_Loan_Application_Stage_Log__c> insertStages = new List<EB_Loan_Application_Stage_Log__c>();
        List<Archived_Report__c> insertReportList = new List<Archived_Report__c>();
        List<Object_Action_Log__c> insertObjectActionList = new List<Object_Action_Log__c>();
        
        for(EB_Loan_Packet__c oldLoanPacket : oldList){
            EB_Loan_Packet__c newLoanPacket = newMap.get(oldLoanPacket.Id);
            
            if((newLoanPacket.Lead_Entity__c != oldLoanPacket.Lead_Entity__c) && newLoanPacket.RecordTypeId == archived.id){
                newLoanPacket.addError('Error: Cannot change Lead Entity on an Archived Packet');
            }
            
            //TODO: why is the Packet's onAfterUpdate trigger recording it's loan apps stage changes?
            /*List<EB_Loan_Application__c> oldloans = [SELECT Id, Name, EB_Loan_Packet__c, Application_Stage__c, Application_Stage_Reportable__c FROM EB_Loan_Application__c WHERE EB_Loan_Packet__c =: oldLoanPacket.Id];
            for(EB_Loan_Application__c app : oldLoans){
                List<EB_Loan_Application_Stage_Log__c> loanstage = [SELECT  Id, Stage_Text__c FROM EB_Loan_Application_Stage_Log__c WHERE EB_Loan_Application__c =: app.Id ORDER BY createddate DESC LIMIT 1];
                if((loanstage.size() == 0) || (app.Application_Stage_Reportable__c != loanstage[0].Stage_Text__c)){
                    EB_Loan_Application_Stage_Log__c stage = new EB_Loan_Application_Stage_Log__c();
                    stage.EB_Loan_Application__c = app.Id;
                    stage.EB_Loan_Application_Stage__c = app.Application_Stage__c;
                    stage.Stage_Text__c = app.Application_Stage_Reportable__c;
                    insertStages.add(stage);
                }
            }*/
            
            //Generate minutes
            if(newLoanPacket.Create_Minute__c==true){
                Archived_Report__c report = GenerateReport(newLoanPacket);
                insertReportList.add(report);
                // objectstage log
                Object_Action_Log__c logPacket = RecordLog('EB_Loan_Packet__c',newLoanPacket.Id,'Relationship Review Complete');
                insertObjectActionList.add(logPacket);
                // loop through packet accts and record same log
                for(Relationship_Review_Account__c r : [SELECT EB_Account__c, Id, name FROM Relationship_Review_Account__c WHERE loan_packet__c =:newLoanPacket.id]){
                    Object_Action_Log__c logEBAccount = RecordLog('EB_Account__c',r.EB_Account__c,'Relationship Review Complete');
                    insertObjectActionList.add(logEBAccount);
                }
            }
        }
        
        if(insertReportList.size() > 0 ) insert insertReportList;
        for(Archived_Report__c r : insertReportList){
            CalloutForUrlUpdateOnReport(r.id);
        }

        if(insertObjectActionList.size() > 0)insert insertObjectActionList;
        //if(insertStages.size() > 0) insert insertStages;
    }
    
    public void updateBeforeLoanPacketFromList(List<EB_Loan_Packet__c> newList){   
        
    }
    
    public void validate(List<EB_Loan_Packet__c> newList){   
        validateOverrideLender(newList);
    }
    
    private static Map<Id,EB_Team_Member__c> m_teamMembers{
    	get{
    		if(m_teamMembers == null){
    			m_teamMembers = new Map<Id,EB_Team_Member__c>([SELECT Id, Name, User__c FROM EB_Team_Member__c]);
    		}
    		return m_teamMembers;
    	}
    	set;
    }
    
    private static List<Account_Team_Role__c> m_approvalRoles{
    	get{
    		if(m_approvalRoles == null){
    			m_approvalRoles = [SELECT Name FROM Account_Team_Role__c WHERE Can_Approve_Loan__c =:'Yes' order by Approval_Authority_Order__c];
    		}
    		return m_approvalRoles;
    	}
    	set;
    }
     
    private void validateOverrideLender(List<EB_Loan_Packet__c> packets){
    	List<Id> leadEntities = new List<Id>();
        for(EB_Loan_Packet__c p : packets){
            leadEntities.add(p.Lead_Entity__c);
        }
        
        List<String> approvalRoleNames = new List<String>();
        for(Account_Team_Role__c role : m_approvalRoles){
            approvalRoleNames.add(role.Name);
        }
        
        List<AccountTeamMember> accountTeams = [SELECT Id, TeamMemberRole, UserId, AccountId FROM AccountTeamMember WHERE AccountId IN:leadEntities AND TeamMemberRole IN:approvalRoleNames];
        
        Map<Id,Map<Id,Id>> accountTeamsByEntity = new Map<Id,Map<Id,Id>>();
        for(AccountTeamMember m : accountTeams){
            Map<Id,Id> teamMembers;
            if(accountTeamsByEntity.containsKey(m.AccountId)){
                teamMembers = accountTeamsByEntity.get(m.AccountId);
            }else{
                teamMembers = new Map<Id,Id>();
            }
            teamMembers.put(m.UserId,m.UserId);
            accountTeamsByEntity.put(m.AccountId, teamMembers);
        }
        
        for(EB_Loan_Packet__c packet : packets){
            if(packet.Override_Lender__c != null){
                EB_Team_Member__c overrideLender = m_teamMembers.get(packet.Override_Lender__c);//TODO: is there a way to get this information without creating a map of all team members?
                Map<Id,Id> members = accountTeamsByEntity.get(packet.Lead_Entity__c);                   
                if(!members.containsKey(overrideLender.User__c)){
                    packet.Override_Lender__c.addError('Must be a member of Lead Entity\'s account team and have lending authority');
                }
            }
        }
    }
    
    private Object_Action_Log__c RecordLog(String ObjectName, String ObjectKey, String ObjectEvent){
        Object_Action_Log__c log = new Object_Action_Log__c();
        log.Action__c = ObjectEvent;
        log.Object_API_Name__c = ObjectName;
        log.Object_Id__c = ObjectKey;
        log.Action_Date_Time__c = system.now();
        return log;
    }
    
    private Archived_Report__c GenerateReport(EB_Loan_Packet__c packet){
        Archived_Report__c report = new Archived_Report__c();
        if(packet.RecordTypeId == Utility.RecordTypeObject('EB_Loan_Packet__c', 'Prescreen Only').Id) 
            report.Name = 'Prescreen Report';
        else
            report.Name = 'Relationship Review Report';
        report.loan_packet__c = packet.id;
        return report;
    }
    
    @future(callout=true)
    private static void CalloutForUrlUpdateOnReport(string reportid){
        RestUtility.result res = new RestUtility.result();
        RestUtility.ArchiveReport(reportid);
    }
}