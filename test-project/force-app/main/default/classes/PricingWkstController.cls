public with sharing class PricingWkstController {

	private IApexPages m_apexPages;
	private ParentRelationshipSvc.IParentRelationshipSvc m_parentRelationshipSvc;
	private PricingWkst.IPricingWkstDataProv m_dataProvider;
	private PricingWkst.IPricingWkstSvcProxy m_pricingService;
	private AttachmentHandler.IAttachmentHandler m_attachmentHandler;
	private Configurations.IConfigurations m_configs;

	public Pricing_Worksheet__c currentWorksheet {get;set;}
	public PricingWkstRequest pricingRequest {get;set;}
	public PricingWkstResults pricingResults {get;set;}
	public String newpageUrl {get;set;}
	public Boolean refreshAttachments {get;set;}
	public Boolean displayRelationshipTree {get; set;}
	public String selectedLoanPacket { get; set; }
	public List<SelectOption> relatedLoanPackets { get; set; }

	private Map<Id, Account> relatedEntities;
	private Map<Id, Account> m_relatedEntities{
		get { 
				if (relatedEntities == null) {
			 		relatedEntities = m_parentRelationshipSvc.getAllRelatedEntitiesForParent(currentWorksheet.Entity__c);
				}
				return relatedEntities;
		}
	}

	public PricingWkstController() {
		ApexPagesWrapper apexPages = new ApexPagesWrapper();
		ParentRelationshipSvc parentRelationshipSvc = new ParentRelationshipSvc();
		PricingWkstDataProv dataProvider = new PricingWkstDataProv();
		PricingWkstSvcProxy pricingService = new PricingWkstSvcProxy();
		AttachmentHandler attachmentHandler = new AttachmentHandler();
		Configurations.IConfigurations configs = Configurations.bootstrap();	
		setDependencies(apexPages, parentRelationshipSvc, dataProvider, pricingService, attachmentHandler, configs);
	}

	public PricingWkstController(IApexPages apexPages, ParentRelationshipSvc.IParentRelationshipSvc parentRelationshipSvc, 
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
		m_attachmentHandler = attachmentHandler;
		m_configs = configs;
	}

	public void initialize() {
		String worksheetId = m_apexPages.getParameter('Id');
		if (!String.isBlank(worksheetId)) {
			currentWorksheet = m_dataProvider.getPricingWorksheet(worksheetId);
			pricingRequest = getPricingWorksheetRequest(worksheetId);
			updatePricingResults();
			relatedLoanPackets = getRelatedLoanPackets();
		} else {
			ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A worksheet ID is required to proceed.');
			m_apexPages.addMessage(errMsg);
		}
		refreshAttachments = false;
		displayRelationshipTree = false;
	}

    public List<SelectOption> getRelatedLoanPackets() {
        List<SelectOption> options = new List<SelectOption>();
		List<EB_Loan_Packet__c> relLoanPackets = m_dataProvider.getLoanPacketsForEntities(m_relatedEntities.keySet());
        for (EB_Loan_Packet__c loanPacket : relLoanPackets) {
            options.add(new SelectOption(loanPacket.Id,loanPacket.Name));
        }
        return options;     
    }

	private PricingWkstRequest getPricingWorksheetRequest(String worksheetId) {
		PricingWkstRequest pricingReq = new PricingWkstRequest();
		pricingReq.proposedDeposits = m_dataProvider.getPricingProposedDepositsForWorksheet(worksheetId);
		pricingReq.proposedLoans = m_dataProvider.getPricingProposedLoansForWorksheet(worksheetId);
		pricingReq.proposedNonInterestIncome = m_dataProvider.getPricingProposedNonIntIncomeForWorksheet(worksheetId);
		pricingReq.proposedAccountRemovals = m_dataProvider.getPricingProposedAcctRemovalsForWorksheet(worksheetId);
		Set<Integer> applicationCodes = getApplicationCodes();
		pricingReq.existingAccounts = m_dataProvider.getEBAccountsForEntities(m_relatedEntities.keySet(), applicationCodes);
		return pricingReq;
	}

	public void savePricingWorksheet() {
		m_dataProvider.updatePricingWorksheet(currentWorksheet);
	}

	private void updatePricingResults() {
		pricingResults = m_pricingService.getPricingInformation(pricingRequest);
	}

	public void saveWorksheetAsAttachmentOnLoanPacket() {
		if (selectedLoanPacket != null) {
			saveAttachment(selectedLoanPacket);
			saveWorksheetAsAttachment();
		} else {
			ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No Loan Packet Available.');
			m_apexPages.addMessage(errMsg);
		}
	}

	public void saveWorksheetAsAttachment() {
		saveAttachment(currentWorksheet.Id);
	}

	private void saveAttachment(ID parentId) {
        PageReference pdfRef = Page.PricingWkstPDF;
        pdfRef.getParameters().put('id',currentWorksheet.Id);
        pdfRef.getParameters().put('renderAs','pdf');
        String attachmentName = 'PRICINGWS-' + DateTime.now().format('MMddyy') + '-' + currentWorksheet.Entity__r.Name + '.pdf';
        Id attachmentID = m_attachmentHandler.generateAttachmentFromPageRef(pdfRef, attachmentName, parentId);
        newpageUrl = '/servlet/servlet.FileDownload?file=' + attachmentID;
		refreshAttachments = true;
	}

	private Set<Integer> getApplicationCodes() {
		String codes = m_configs.get('ValidForPricingWkstAppCodes');
		Set<Integer> codesSet = new Set<Integer>();
		for (String s : codes.split(',')) {
			codesSet.add(Integer.valueOf(s));
		}
		return codesSet;
	}

	public PageReference showRelationshipTree() {
		displayRelationshipTree = true;
		return null;
	}

	public PageReference hideRelationshipTree() {
		displayRelationshipTree = false;
		return null;
	}
}