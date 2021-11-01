public class MoreLoanTriggerHandlerDataProvider implements MoreLoanTriggerHandler.IMoreLoanTriggerHandlerDataProvider {
    
    public List<More_Loan__c> getRelatedMoreLoanRecords(Set<Id> loanIds){
        return [SELECT Id, Loan__c FROM More_Loan__c WHERE Loan__c IN: loanIds];
    }

}