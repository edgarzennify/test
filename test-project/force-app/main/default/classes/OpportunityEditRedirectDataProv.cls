public class OpportunityEditRedirectDataProv implements OpportunityEditRedirect.IOpportunityEditRedirectDataProv {
	public Opportunity getOpportunityById(Id oppId){
		return [SELECT Id, AccountId, Entity_Relationship_Review_Required__c FROM Opportunity WHERE Id =: oppId LIMIT 1];
	}
}