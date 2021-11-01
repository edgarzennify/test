public class AgreementApprovalInfo implements Agreements.IAgreementApprovalInfo{
    private Agreement__c m_Agreement;
    
    private void setAgreementId(Id agmtId){
        m_Agreement = [SELECT Id, RecordTypeId, Independently_Approved_Approval_Process__c FROM Agreement__c WHERE Id =: agmtId];
    }
    
    private List<Agreement_Loan_Application_Relationship__c> m_loanAppRels{
        get{
            if(m_loanAppRels == null){
                m_loanAppRels = [SELECT Id, Loan_Application__c FROM Agreement_Loan_Application_Relationship__c WHERE Agreement__c =: m_Agreement.Id];
            }
            return m_loanAppRels;
        }
        set;
    }
    
    private List<Agreement_EB_Account_Relationship__c> m_loanAcctRels{
        get{
            if(m_loanAcctRels == null){
                m_loanAcctRels = [SELECT Id, Loan_Account__c FROM Agreement_EB_Account_Relationship__c WHERE Agreement__c =: m_Agreement.Id];
            }
            return m_loanAcctRels;
        }
        set;
    }
    
    private List<ProcessInstance>m_approvals{
        get{
            if(m_approvals == null){
                m_approvals = [SELECT Id FROM ProcessInstance WHERE TargetObjectId =: m_Agreement.Id ORDER BY CreatedDate DESC];
            }
            return m_approvals;
        }
        set;
    }
    
    private RecordType pendingRecordType{
        get{
            return utility.RecordTypeObject('Agreement__c', 'Pending');
        }
    }
    
    public Boolean wasIndependentlyApproved(Id agmtId){
    	setAgreementId(agmtId);
    	return m_agreement.Independently_Approved_Approval_Process__c;
    }
    
    public Boolean hasApprovalInformation(Id agmtId){
        setAgreementId(agmtId);
        
        if(m_approvals != null && m_approvals.size() > 0){
            return true;
        }
        
        return false;
    }
    
    public EB_Loan_App_Minute__c getApprovalMinute(Id agmtId){
        setAgreementId(agmtId);
                
        if(m_Agreement.RecordTypeId != pendingRecordType.Id){
            return getLoanAccountApproval();
        }
        
        return getLoanApplicationApproval();
    }
    
    private EB_Loan_App_Minute__c getLoanApplicationApproval(){
        List<Id> loanApps = new List<Id>();
        for(Agreement_Loan_Application_Relationship__c rel : m_loanAppRels){
            loanApps.Add(rel.Loan_Application__c);
        }
        List<EB_Loan_App_Minute__c> loanAppMinutes = [SELECT Id, Name, Decision__c, Decision_Date__c, Approval_Path__c, Signers__c FROM EB_Loan_App_Minute__c WHERE EB_Loan_Application__c in: loanApps AND Type_of_Snapshot__c = 'Approval Minute' ORDER BY CreatedDate DESC LIMIT 1];
        
        if(loanAppMinutes != null && loanAppMinutes.size()==1){
            return loanAppMinutes[0];
        }
        return null;
    }
    
    private EB_Loan_App_Minute__c getLoanAccountApproval(){
        List<Id> loanAccts = new List<Id>();
        for(Agreement_EB_Account_Relationship__c rel : m_loanAcctRels){
            loanAccts.Add(rel.Loan_Account__c);
        }        
        List<EB_Loan_App_Minute__c> loanAcctMinutes = [SELECT Id, Name, Decision__c, Decision_Date__c, Approval_Path__c, Signers__c FROM EB_Loan_App_Minute__c WHERE Booked_Loan_Application__r.Account__c in: loanAccts AND Type_of_Snapshot__c = 'Approval Minute' ORDER BY CreatedDate DESC LIMIT 1];
        
        if(loanAcctMinutes != null && loanAcctMinutes.size()==1){
            return loanAcctMinutes[0];
        }
        return null;
    }
}