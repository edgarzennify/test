public with sharing class PricingWkstEntityController {

	private IApexPages m_apexPages;
	private PricingWkst.IPricingWkstDataProv m_dataProvider;
	private ParentRelationshipSvc.IParentRelationshipSvc m_parentRelationshipSvc;

	public PricingWkstEntityController() {
		ApexPagesWrapper apexPages = new ApexPagesWrapper();		
		PricingWkstDataProv dataProvider = new PricingWkstDataProv();
		ParentRelationshipSvc parentRelationshipSvc = new ParentRelationshipSvc();
		initialize(apexPages, dataProvider, parentRelationshipSvc);
	}

	public PricingWkstEntityController(IApexPages apexPages, PricingWkst.IPricingWkstDataProv dataProvider, 
										ParentRelationshipSvc.IParentRelationshipSvc parentRelationshipSvc) {
		initialize(apexPages, dataProvider, parentRelationshipSvc);
	}

	private void initialize(IApexPages apexPages, PricingWkst.IPricingWkstDataProv dataProvider, 
										ParentRelationshipSvc.IParentRelationshipSvc parentRelationshipSvc) {
		m_apexPages = apexPages;
		m_dataProvider = dataProvider;
		m_parentRelationshipSvc = parentRelationshipSvc;
	}

	public PageReference determineDestination() {
		String entityId = m_apexPages.getParameter('EntityId');

		if(String.isBlank(entityId)){
			ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An entity ID is required to proceed.');
			m_apexPages.addMessage(errMsg);
			return null;
		}

		Account topLevelEntity = m_parentRelationshipSvc.getTopLevelParent(entityId);
		String worksheetId = m_dataProvider.getWorksheetIdForEntity(topLevelEntity.Id);
		if(String.isBlank(worksheetId)) {
			Pricing_Worksheet__c newWkst = startNewPricingWorksheet(topLevelEntity);
			worksheetId = newWkst.Id;
		}
		return new PageReference('/apex/PricingWkst?id=' + worksheetId);
	}

	private Pricing_Worksheet__c startNewPricingWorksheet(Account entity)	{
		Pricing_Worksheet__c newWorksheet = new Pricing_Worksheet__c();
		newWorksheet.Name = entity.Name;
		newWorksheet.Entity__c = entity.Id;
		newWorksheet.Entity__r = entity;
		m_dataProvider.addPricingWorksheet(newWorksheet);
		return newWorksheet;
	}


}