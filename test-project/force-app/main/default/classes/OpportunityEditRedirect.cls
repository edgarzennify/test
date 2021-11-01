public with sharing class OpportunityEditRedirect {
	public Interface IOpportunityEditRedirectDataProv{
		Opportunity getOpportunityById(Id oppId);
	}

	private IOpportunityEditRedirectDataProv m_dataProvider;

	private Opportunity oppFromController;

	public OpportunityEditRedirect(ApexPages.StandardController stdController) {
		m_dataProvider = new OpportunityEditRedirectDataProv();
		oppFromController = (Opportunity)stdController.getRecord();
	}

	public OpportunityEditRedirect(IOpportunityEditRedirectDataProv dataProvider, Opportunity testOpp) {
		m_dataProvider = dataProvider;	
		oppFromController = testOpp;
	}

	public PageReference determineDestination() {
		Opportunity opp = m_dataProvider.getOpportunityById(oppFromController.Id);
		if(opp.Entity_Relationship_Review_Required__c != null){
			return new PageReference('/apex/ParentRelationshipManagerView?id=' + opp.AccountId + '&msg=reqOpp&retURL=%2F' + opp.Id + '%2Fe?retURL=%2F' + opp.Id + '%26nooverride=1');
		}else{
			return new PageReference('/' + opp.Id + '/e?retURL=%2F' + opp.Id + '&nooverride=1');
		}
	}
}