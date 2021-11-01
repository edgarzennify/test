public with sharing class PricingWkstControllerPDF {

	private IApexPages m_apexPages;
	private ParentRelationshipSvc.IParentRelationshipSvc m_parentRelationshipSvc;
	private PricingWkst.IPricingWkstDataProv m_dataProvider;
	private PricingWkst.IPricingWkstSvcProxy m_pricingService;
	//private AttachmentHandler.IAttachmentHandler m_attachmentHandler;
	private Configurations.IConfigurations m_configs;

	public Pricing_Worksheet__c currentWorksheet {get;set;}
	public PricingWkstRequest pricingRequest {get;set;}
	public PricingWkstResults pricingResults {get;set;}

	public PricingWkstControllerPDF() {
		ApexPagesWrapper apexPages = new ApexPagesWrapper();
		ParentRelationshipSvc parentRelationshipSvc = new ParentRelationshipSvc();
		PricingWkstDataProv dataProvider = new PricingWkstDataProv();
		PricingWkstSvcProxy pricingService = new PricingWkstSvcProxy();
		AttachmentHandler attachmentHandler = new AttachmentHandler();
		Configurations.IConfigurations configs = Configurations.bootstrap();	
		setDependencies(apexPages, parentRelationshipSvc, dataProvider, pricingService, attachmentHandler, configs);
	}

	public PricingWkstControllerPDF(IApexPages apexPages, ParentRelationshipSvc.IParentRelationshipSvc parentRelationshipSvc, 
										PricingWkst.IPricingWkstDataProv dataProvider, PricingWkst.IPricingWkstSvcProxy pricingService,
										AttachmentHandler.IAttachmentHandler attachmentHandler, Configurations.IConfigurations configs) {
		setDependencies(apexPages, parentRelationshipSvc, dataProvider, pricingService, attachmentHandler, configs);
	}

	private void setDependencies(IApexPages apexPages, ParentRelationshipSvc.IParentRelationshipSvc parentRelationshipSvc, 
										PricingWkst.IPricingWkstDataProv dataProvider, PricingWkst.IPricingWkstSvcProxy pricingService,
										AttachmentHandler.IAttachmentHandler attachmentHandler, Configurations.IConfigurations configs) {
		m_apexPages = apexPages;
		m_parentRelationshipSvc = parentRelationshipSvc;
		m_dataProvider = dataProvider;
		m_pricingService = pricingService;
		//m_attachmentHandler = attachmentHandler;
		m_configs = configs;
	}

	public void initialize() {
		String worksheetId = m_apexPages.getParameter('Id');
		pricingRequest = new PricingWkstRequest();
		if(!String.isBlank(worksheetId)) {
			currentWorksheet = m_dataProvider.getPricingWorksheet(worksheetId);
			pricingRequest.proposedDeposits = m_dataProvider.getPricingProposedDepositsForWorksheet(worksheetId);
			pricingRequest.proposedLoans = m_dataProvider.getPricingProposedLoansForWorksheet(worksheetId);
			pricingRequest.proposedNonInterestIncome = m_dataProvider.getPricingProposedNonIntIncomeForWorksheet(worksheetId);
			pricingRequest.proposedAccountRemovals = m_dataProvider.getPricingProposedAcctRemovalsForWorksheet(worksheetId);
		} 
		pricingRequest.existingAccounts = getExistingAccounts();
		updatePricingResults();
	}

	private List<EB_Account__c> getExistingAccounts() {
		Map<Id, Account> relatedEntities = m_parentRelationshipSvc.getAllRelatedEntitiesForParent(currentWorksheet.Entity__c);
		Set<Integer> applicationCodes = getApplicationCodes();
		return m_dataProvider.getEBAccountsForEntities(relatedEntities.keySet(), applicationCodes);
	}

	private void updatePricingResults() {
		pricingResults = m_pricingService.getPricingInformation(pricingRequest);
	}

	private Set<Integer> getApplicationCodes() {
		String codes = m_configs.get('ValidForPricingWkstAppCodes');
		Set<Integer> codesSet = new Set<Integer>();
		for (String s : codes.split(',')) {
			codesSet.add(Integer.valueOf(s));
		}
		return codesSet;
	}
}