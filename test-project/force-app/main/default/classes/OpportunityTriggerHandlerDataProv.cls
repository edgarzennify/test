public class OpportunityTriggerHandlerDataProv implements OpportunityTriggerHandler.IOpportunityTriggerHandlerDataProv{

	public List<Account> getAccounts(Set<Id> acctIds){
		List<Account> returnList = [SELECT Id, Relationship_Review_Last_Modified_Date__c, Relationship_Review_Required_Date__c FROM Account WHERE Id IN: acctIds];
		return (returnList != null) ? returnList : new List<Account>();
	}

	public void updateAccounts(List<Account> accts){
		update accts;
	}	
    public List<LLC_BI__Loan__c> getRelatedLoans(Set<Id> loanIds){
        return [SELECT Id, LLC_BI__Amount__c FROM LLC_BI__Loan__c WHERE Id =: loanIds];
    }
}