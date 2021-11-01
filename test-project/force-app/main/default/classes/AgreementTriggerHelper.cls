public with sharing class AgreementTriggerHelper {

    private Agreements.IAgreementStatusManager m_agmtStatusManager;

    public AgreementTriggerHelper(){
        m_agmtStatusManager = new AgreementStatusManager(new UserInfoService(Configurations.bootstrap(), new UserInfoServiceDataProv()), new AgreementEntityManager(new AgreementEntityManagerDataProvider()), new AgreementStatusManagerDataProvider());
    }
	
    public static Map<Id,Id> cacheRecordedStageIdsAfterUpdate{
        get{
            if(cacheRecordedStageIdsAfterUpdate == null){
                cacheRecordedStageIdsAfterUpdate = new Map<Id,Id>();
            }
            return cacheRecordedStageIdsAfterUpdate;
        }
        set;
    }
    
    // top-level calls from trigger...
    public void doBeforeInsert(List<Agreement__c> newList){
        initializeStage(newList);
    }

    public void doAfterInsert(List<Agreement__c> newList, Map<Id, Agreement__c> newMap){
    	RecordStageLog(newList,false);
        AgreementSummaryUpdater.updateSummaries(newList);
    }

    public void doBeforeUpdate(List<Agreement__c> oldList, List<Agreement__c> newList, Map<Id, Agreement__c> newMap){
        BeforeUpdateMaintenance(newList);
    }

    public void doAfterUpdate(List<Agreement__c> oldList, List<Agreement__c> newList, Map<Id, Agreement__c> oldMap, Map<Id, Agreement__c> newMap){
        RecordStageLog(oldList, newMap, newList);
        if(!AgreementSummaryUpdater.alreadyran){
        	AgreementSummaryUpdater.updateSummaries(newList);
        }
    }
    ///////////////////////////////////////////////////////////////////////
    
    public static EB_Loan_App_Stage__c newLoanAppStage{
        get{
            if(newLoanAppStage==null){
                List<EB_Loan_App_Stage__c> stageList = [SELECT Id FROM EB_Loan_App_Stage__c WHERE Name =: 'New' limit 1 ];
                if(stageList != null && stageList.size() > 0){
                    newLoanAppStage = stageList[0];
                }
            }
            return newLoanAppStage;
        }
        set;
    }
    
    private static Map<String,EB_Loan_App_Stage__c> stageMap{
        get{
            if(stageMap == null){
                stageMap = new Map<String,EB_Loan_App_Stage__c>();
                for(EB_Loan_App_Stage__c stgs : [SELECT Id, Name, Stage_Selected_Email_Notifications__c FROM EB_Loan_App_Stage__c ORDER BY name]){
                    stageMap.put(stgs.Name , stgs);
                }
            }
            return stageMap;
        }
        set;
    }
    
    private Map<string,string> FPQIndicatorMap{
        get{
            if(FPQIndicatorMap == null){
                FPQIndicatorMap = new Map<String,String>();
                for(EB_Loan_App_Stage_Explanation__c stage : [SELECT id, name, FPQ_Type__c,Loan_App_Stage__c FROM EB_Loan_App_Stage_Explanation__c ]){
                    FPQIndicatorMap.put(stage.Loan_App_Stage__c+stage.name ,stage.FPQ_Type__c );
                    system.debug(stage.Loan_App_Stage__c+stage.name + ' : ' + stage.FPQ_Type__c);
                }
            }
            return FPQIndicatorMap;
        }
        set;
    }
    
    public void update_Agreement_RM_Email_Field (List<Agreement__c> agmts){
        Set<Id> setOfIdFromListOfAgreements = new Set<id>();
        for(Agreement__c  a : agmts) {
            setOfIdFromListOfAgreements.add( a.id );
        }
        Map<Id, Agreement__c> agmtEmails = new Map<Id, Agreement__c>([SELECT  Id, Borrower_Name__c,Borrower_Name__r.Team_Relationship_Manager__c, Borrower_Name__r.Team_Relationship_Manager__r.User__c ,Borrower_Name__r.Team_Relationship_Manager__r.User__r.Email FROM Agreement__c WHERE  Id  IN : setOfIdFromListOfAgreements]); 

        for(Agreement__c agmt : agmts ){
        	if(String.IsBlank(agmt.Borrower_Name__c)|| String.IsBlank(agmt.Borrower_Name__r.Team_Relationship_Manager__c) || String.IsBlank(agmt.Borrower_Name__r.Team_Relationship_Manager__r.User__c)){}
        	else{
            	agmt.RM_Email__c = agmtEmails.get(agmt.Id).Borrower_Name__r.Team_Relationship_Manager__r.User__r.Email;
        	}
        }  
    }
    
    private void initializeStage(List<Agreement__c> newList){
        for(Agreement__c a : newList){
            try{
                a.Stage__c = newLoanAppStage.Id;//stage[0].Id;
            }catch(exception ex){
            }
        }
    }
    
    private void RecordStageLog(Agreement__c agmt, String stageText){
        
        EB_Loan_Application_Stage_Log__c logEntry = new EB_Loan_Application_Stage_Log__c();
            logEntry.Agreement__c = agmt.Id;
            logEntry.Explanation__c = agmt.Stage_Explanation__c;
            if(agmt.Stage__c != null){
                logEntry.EB_Loan_Application_Stage__c = agmt.Stage__c;
                logEntry.stage_text__c = stageText;
                logEntry.Comment__c = agmt.Stage_Comment__c;
                insert logEntry;
            }
    }
    
    private void RecordStageLog(Agreement__c agmt, Boolean RecordStageExplaination){
        List<Agreement__c> agmtList = new List<Agreement__c>();
        agmtList.add(agmt);
        RecordStageLog(agmtList, RecordStageExplaination);
    }
    
    private void RecordStageLog(List<Agreement__c> newList , Boolean RecordStageExplaination){
        system.debug('##Recordingstagelog');
        List<EB_Loan_Application_Stage_Log__c> stagelogs = new List<EB_Loan_Application_Stage_Log__c>();
        //List<Agreement__c> updateAgmt = new List<Agreement__c>();
        for(Agreement__c agmt : newList){
            system.debug('agmt:' + string.valueOf(agmt));
            EB_Loan_Application_Stage_Log__c logEntry = new EB_Loan_Application_Stage_Log__c();
            logEntry.Agreement__c = agmt.Id;
            logEntry.Explanation__c = agmt.Stage_Explanation__c;
            if(agmt.Stage__c != null){
                logEntry.EB_Loan_Application_Stage__c = agmt.Stage__c;
                logEntry.stage_text__c = agmt.Stage_Reportable__c;
                logEntry.Comment__c = agmt.Stage_Comment__c;
                stagelogs.add(logEntry);
            }
        }
        if(stagelogs.size() > 0) insert stagelogs;
        if(RecordStageExplaination == true){
	        for(EB_Loan_Application_Stage_Log__c stageLog: stageLogs){
	            putExplanationInStageLogExplanation(stagelog.EB_Loan_Application_Stage__c, stageLog.Explanation__c, stageLog.Comment__c, stageLog.Id);
	        }
        }
    }
    
    private void RecordStageLog(List<Agreement__c> oldList, Map<Id, Agreement__c> newMap, List<Agreement__c> newList){
        
        List<EB_Loan_Application_Stage_Log__c> log = new List<EB_Loan_Application_Stage_Log__c>();
  
        for(Agreement__c dirty : oldList){
            EB_Loan_Application_Stage_Log__c logEntry = new EB_Loan_Application_Stage_Log__c();
            logEntry.Agreement__c = dirty.Id;         
            if(dirty.Stage__c != null){
                Agreement__c newAgmt = newMap.get(dirty.Id);
                if(newAgmt.Stage__c != dirty.Stage__c){
                    if(!cacheRecordedStageIdsAfterUpdate.containsKey(newAgmt.Stage__c))
                    {
                        cacheRecordedStageIdsAfterUpdate.put(newAgmt.Stage__c,newAgmt.Stage__c);
                        logEntry.EB_Loan_Application_Stage__c = newAgmt.Stage__c;
                        logEntry.stage_text__c = newAgmt.Stage_Reportable__c;
                        logEntry.Explanation__c = newAgmt.Stage_Explanation__c;
                        logEntry.Comment__c = newAgmt.Stage_Comment__c;
                        log.add(logEntry);
                    }
                }
            }
        }
        if(log.size() > 0){ 
            insert log;
        }
        
        for(EB_Loan_Application_Stage_Log__c entry : log){
            putExplanationInStageLogExplanation(entry.EB_Loan_Application_Stage__c, entry.Explanation__c, entry.Comment__c , entry.id);
        }
    }
    
    private void putExplanationInStageLogExplanation(Id AppStage, String Explanation, String comment, Id stageid){
        List<Loan_App_Stage_Explanation__c> insertlistexpl = new List<Loan_App_Stage_Explanation__c>();
            
        if(Explanation == null){}else{
           List<String>  explanations = new List<String>();//=   lg.Explanation__c.split(';');
           String explain = Explanation;
               
           if(explain.contains(';')){
                explanations = explain.split(';');
           }else{
                explanations.add(explain);
           } 
                     
            for(String s : explanations){
                //create a new stage log explanation
                //fill all the fields and insert
                //To get type parse explanation and check if it is non-first pass
                Loan_App_Stage_Explanation__c lnappstagexpl=new Loan_App_Stage_Explanation__c();
                lnappstagexpl.Loan_App_Stage_Log__c=stageid;
                lnappstagexpl.Explanation__c=s;
                lnappstagexpl.Comment__c = comment;
                String slowercase = s.toLowerCase();
                lnappstagexpl.Type__c = FPQIndicatorMap.get(AppStage + lnappstagexpl.Explanation__c);
     
                insertlistexpl.add(lnappstagexpl);
            }            
        }
         
        if(insertlistexpl.size() > 0){
            insert insertlistexpl;
        }
    }
    
    private void BeforeUpdateMaintenance(List<Agreement__c> newList){
        try{
            for(Agreement__c agmt : newList){
                
                HandleBackOfficeUpdateOnApproval(agmt);

                if(agmt.Approved_by_SFDC_Approval_Process__c == true && stageMap.containskey('Approved')){
                    
                    agmt.Stage__c = stageMap.get('Approved').Id;
                    agmt.Approved_by_SFDC_Approval_Process__c = false;                    
                    HandleApprovedEmails(agmt.Id, stageMap.get('Approved').Stage_Selected_Email_Notifications__c, 'Approved');
                }
                
                HandleBackOfficeUpdateOnDenial(agmt);
                
                if(agmt.Rejected_by_SFDC_Approval_Process__c == true && stageMap.containskey('Denied')){
                    agmt.Stage__c = stageMap.get('Denied').Id;
                    agmt.Rejected_by_SFDC_Approval_Process__c = false;
                }
                
                HandleBackOfficeUpdateOnRecall(agmt);
                
                if(agmt.Set_App_to_New__c == true && stageMap.containskey('New')){
                    agmt.Stage__c = stageMap.get('New').Id;
                    agmt.Set_App_to_New__c = false;
                    
                }
                
                //Automatically send Documentation Complete to Booking
                if(agmt.Stage__c == stageMap.get('Documentation Complete').Id ){
                    RecordStageLog(agmt, true);
                    agmt.Stage__c = stageMap.get('Booking').Id;                 
                    agmt.Stage_Explanation__c = '';
                }
                
                //Automatically send Booking Complete to Checkback
                if(agmt.Stage__c == stageMap.get('Booking Complete').Id ){
                    RecordStageLog(agmt, true);
                    agmt.Stage__c = stageMap.get('Checkback').Id;                 
                    agmt.Stage_Explanation__c = '';
                }
                
                AgreementValidator m_agreementValidator = AgreementValidator.getInstance();
                m_agreementValidator.ValidateAndSaveFromTrigger(agmt); 
            }
        }catch(exception ex){
        }
    }

    private void HandleBackOfficeUpdateOnApproval(Agreement__c agreement){
        EB_Loan_App_Stage__c bomPendingApproval = stageMap.get('Back Office Modification - Pending Approval');
        EB_Loan_App_Stage__c bomApproved = stageMap.get('Back Office Modification - Approved');
        
        if(bomPendingApproval == null || bomApproved == null){
            //agreement.addError('Required stages for Back Office Modification determination are not available.');
        }else if(agreement.Approved_by_SFDC_Approval_Process__c == true && agreement.Stage__c == bomPendingApproval.Id){   
        	agreement.Stage__c = bomApproved.Id;
            RecordStageLog(agreement, bomApproved.Name);
            agreement.Approved_by_SFDC_Approval_Process__c = false;
            m_agmtStatusManager.exitBackOfficeModification(agreement);
        }
    }
    
    private void HandleBackOfficeUpdateOnDenial(Agreement__c agreement){
        EB_Loan_App_Stage__c bom = stageMap.get('Back Office Modification');
    	EB_Loan_App_Stage__c bomPendingApproval = stageMap.get('Back Office Modification - Pending Approval');
    	if(bom == null || bomPendingApproval == null){
    		//agreement.addError('Required stages for Back Office Modification determination are not available.');
    	}else if(agreement.Rejected_by_SFDC_Approval_Process__c == true && agreement.Stage__c == bomPendingApproval.Id){
            agreement.Stage__c = bom.Id;
            agreement.RecordTypeId = Utility.recordTypeObject('Agreement__c','Pending').Id;
            agreement.Rejected_by_SFDC_Approval_Process__c = false;
        }
    }
    
    private void HandleBackOfficeUpdateOnRecall(Agreement__c agreement){
    	EB_Loan_App_Stage__c bom = stageMap.get('Back Office Modification');
    	EB_Loan_App_Stage__c bomPendingApproval = stageMap.get('Back Office Modification - Pending Approval');
    	if(bom == null || bomPendingApproval == null){
    	   //agreement.addError('Required stages for Back Office Modification determination are not available.');
    	}else if(agreement.Set_App_to_New__c == true && agreement.Stage__c == bomPendingApproval.Id){
	    	agreement.Stage__c = bom.Id;
	    	agreement.Set_App_to_New__c = false;
    	}
    }
    
    private void HandleApprovedEmails(Id appid, String roleList, String stage){
        List<Agreement__c> currentAgmt = [
                    SELECT 
                        Id, Name, Stage__c, Stage_Reportable__c, Stage_Explanation__c, Approver_One__c, Approver_Two__c, 
                        Approver_Three__c, Stage__r.Name, Stage__r.Loan_App_Stage_Action_Controller__r.Id, 
                        Actual_Approval_Process__c, Borrower_Name__r.Name, 
                        Borrower_Name__r.Team_Wealth_Management_Advisor__r.User__R.Email,
                        Borrower_Name__r.Team_Wealth_Management_Advisor__r.User__R.Name, 
                        Borrower_Name__r.Team_Treasury_Management_Representative__r.User__r.Email,
                        Borrower_Name__r.Team_Treasury_Management_Representative__r.User__r.Name, 
                        Borrower_Name__r.Team_Relationship_Manager__r.User__r.Email,
                        Borrower_Name__r.Team_Relationship_Manager__r.User__r.Name, 
                        Borrower_Name__r.Team_Relationship_Manager__r.User__r.Id, 
                        Borrower_Name__r.Team_Private_Banker__r.User__r.Email,
                        Borrower_Name__r.Team_Private_Banker__r.User__r.Name, 
                        Loan_Coordinator__r.User__r.Email, Loan_Coordinator__r.User__r.Name, 
                        Credit_Analyst__r.User__r.Email, Credit_Analyst__r.User__r.Name, 
                        DocumentationRep__r.User__r.Email, DocumentationRep__r.User__r.Name, 
                        Stage__r.Stage_Selected_Email_Notifications__c  
                   FROM Agreement__c 
                   WHERE Id =: appId 
                   LIMIT 1];
        List<String> emailAddresses = EmailNotificationList(roleList, currentAgmt[0]);
        SendEmail(emailAddresses, stage, currentAgmt[0]);
    }
    
    private void SendEmail(List<String> emailaddresses, String stage, Agreement__c agmt){
        String serverurl = utility.getServerUrl() + '/';
        if(agmt == null || emailaddresses == null) return;
        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        email.setSubject('Agreement Status Update - ' + agmt.Name + ' - ' + stage);           
        email.setReplyTo('no-reply@enterprisebank.com');
        email.setSaveAsActivity(false);     
        String SecondaryOfficer = '';
        if (agmt.Borrower_Name__r.Team_Private_Banker__r.User__r.Name == null) {} else SecondaryOfficer = agmt.Borrower_Name__r.Team_Private_Banker__r.User__r.Name; 
        String Message = 'The following agreement has moved to the ' + stage
                         + ' stage. Click on the link below to view additional details.\n\nPrimary Borrower:' 
                         + agmt.Borrower_Name__r.Name
                         + '\n'+ agmt.name
                         + '\nActual Approval Path:'+ agmt.Actual_Approval_Process__c                         
                         + '\nLink to Agreement: ' + serverurl + String.valueOf(agmt.Id)
                         + '\nRelationship Manager:' + agmt.Borrower_Name__r.Team_Relationship_Manager__r.User__r.Name
                         + '\nLoan Coordinator:' + agmt.Loan_Coordinator__r.User__r.Name
                         + '\nCredit Analyst:' + agmt.Credit_Analyst__r.User__r.Name
                         + '\nDocumentation Rep:' + agmt.DocumentationRep__r.User__r.Name;
        if(stage == 'Booked') {
            List<User> usr = [SELECT id, Name FROM User WHERE id =: agmt.LastModifiedById];
            Message += '\nBooked by:' + usr[0].Name;
        }
        email.setPlainTextBody(Message);        
        
        
        if(emailaddresses != null){                        
            email.setToAddresses(emailaddresses);
            Messaging.SendEmailResult[] sendResult; 
            try{
                sendResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }catch(exception ex){
                
            }
        }       
    }
    
    private List<String> EmailNotificationList(String roleList, Agreement__c agmt){
        if(roleList != null){
            List<String> roles = new List<String>();
            try{
                roles = roleList.split(';');
            }catch(exception ex){
                roles = null;
            }
            if(roles != null){
                if(roles.size() > 0) return EmailList(roles, agmt);
            }
        }
        return null;     
    } 
    
    private List<String> EmailList(List<String> roles, Agreement__c agmt){   
        List<String> Emails = new List<String>();
         
        for(String r : roles){
            if(r == 'Coordinator'){
                if(agmt.Loan_Coordinator__r.User__r.Email != null) Emails.add(agmt.Loan_Coordinator__r.User__r.Email);
            }else if(r == 'Credit Analyst'){
                if(agmt.Credit_Analyst__r.User__r.Email != null) Emails.add(agmt.Credit_Analyst__r.User__r.Email);
            }else if(r == 'Documentation Rep'){
                if(agmt.DocumentationRep__r.User__r.Email != null) Emails.add(agmt.DocumentationRep__r.User__r.Email);
            }else if(r == 'Relationship Manager'){
                if(agmt.Borrower_Name__r.Team_Relationship_Manager__r.User__r.Email != null) Emails.add(agmt.Borrower_Name__r.Team_Relationship_Manager__r.User__r.Email);
            }else if(r == 'WM Advisor'){
                if(agmt.Borrower_Name__r.Team_Wealth_Management_Advisor__r.User__R.Email != null) Emails.add(agmt.Borrower_Name__r.Team_Wealth_Management_Advisor__r.User__R.Email);
            }else if(r == 'TM Rep'){
                if(agmt.Borrower_Name__r.Team_Treasury_Management_Representative__r.User__r.Email != null) Emails.add(agmt.Borrower_Name__r.Team_Treasury_Management_Representative__r.User__r.Email);
            }else if(r == 'Secondary Officer'){
                if(agmt.Borrower_Name__r.Team_Private_Banker__r.User__r.Email != null) Emails.add(agmt.Borrower_Name__r.Team_Private_Banker__r.User__r.Email);
            }else{
                
            }
        }
        return Emails;       
    }

 }