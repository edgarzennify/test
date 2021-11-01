public class AgreementLoanAppLinkDataProvider implements Agreements.IAgreementLoanAppLinkDataProvider{
    public void SaveLoanAppToAgreementRelatedList(Id loanAppId, Id agmtId){
        Agreement_Loan_Application_Relationship__c loanAppRel = new Agreement_Loan_Application_Relationship__c(Agreement__c = agmtId,Loan_Application__c = loanAppId);
        if([SELECT ID FROM Agreement_Loan_Application_Relationship__c WHERE Agreement__c =:agmtId and Loan_Application__c =: loanAppId].size() == 0)
        insert loanAppRel;
    }
    
    public void DeleteLoanAppFromAgreementRelatedList(Id loanAppId, Id agmtId){
        List<Agreement_Loan_Application_Relationship__c> deleteList = [SELECT ID FROM Agreement_Loan_Application_Relationship__c WHERE Agreement__c =:agmtId and Loan_Application__c =: loanAppId];       
        if(deleteList.size() > 0) delete deleteList;
    }
    
    public void DeleteEbAccountFromAgreementRelatedList(Id ebaccountId, Id agmtId){
        List<Agreement_EB_Account_Relationship__c> deleteList = [SELECT ID FROM Agreement_EB_Account_Relationship__c WHERE Agreement__c =:agmtId and Loan_Account__c =: ebaccountId];        
        if(deleteList.size() > 0) delete deleteList;
        
    }
    public List<Agreement__c> GetListOfAgreementForEBAccount(Id ebaccountId){
        List<Agreement__c> agmtList = new List<Agreement__c>();
        for(Agreement_EB_Account_Relationship__c r: [SELECT Id, Agreement__c, Agreement__r.RecordTypeDescription__c FROM Agreement_EB_Account_Relationship__c WHERE Loan_Account__c =: ebAccountId and Agreement__r.RecordTypeDescription__c =: 'Active']){
        	Agreement__c agmt = new Agreement__c(id = r.Agreement__c);
            agmtList.add(agmt);
        }
        return agmtList;
    }
}