@IsTest
private class PricingWkstControllerTests {
    
    private final static Account topLevelParent;
    private final static Map<Id, Account> topLevelParentMap;
    private static final Mock.ofIApexPages mockApexPages;
    private static final Mock.ofIParentRelationshipSvc mockParentRelationshipSvc;
    private static final Mock.ofIPricingWkstDataProv mockDataProvider;
    private static final MockofIPricingWkstSvcProxy mockPricingSvcProxy;
    private static final Mock.ofIAttachmentHandler mockAttachmentHandler;
    private static final Mock.ofIConfigurations mockConfigs;
    private static final PricingWkstController sut;

    static {
        topLevelParent = new Account(Id=ObjectFactory.getFakeId(Account.SObjectType,'1'));
        topLevelParentMap = new Map<Id, Account>{topLevelParent.Id=>topLevelParent};
        mockApexPages = new Mock.ofIApexPages();
        mockParentRelationshipSvc = new Mock.ofIParentRelationshipSvc();
        mockDataProvider = new Mock.ofIPricingWkstDataProv();
        mockPricingSvcProxy = new MockofIPricingWkstSvcProxy();
        mockAttachmentHandler = new Mock.ofIAttachmentHandler();
        mockConfigs = new Mock.ofIConfigurations();

        mockApexPages.setup('getParameter', new List<Object>{'EntityId'}).returns(topLevelParent.Id);       
        mockParentRelationshipSvc.setup('getTopLevelParent', new List<Object>{topLevelParent.Id}).returns(topLevelParent);
        mockParentRelationshipSvc.setup('getAllRelatedEntitiesForParent', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(topLevelParentMap);
        mockDataProvider.setup('getEBAccountsForEntities', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<EB_Account__c>());    
        mockDataProvider.setup('getPricingProposedDepositsForWorksheet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new Map<Id, Pricing_Proposed_Deposit__c>()); 
        mockDataProvider.setup('getPricingProposedLoansForWorksheet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new Map<Id, Pricing_Proposed_Loan__c>());   
        mockDataProvider.setup('getPricingProposedNonIntIncomeForWorksheet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new Map<Id, Pricing_Proposed_Non_Interest_Income__c>()); 
        mockDataProvider.setup('getPricingProposedAcctRemovalsForWorksheet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new Map<Id, Pricing_Proposed_Account_Removal__c>()); 
        mockDataProvider.setup('getLoanPacketsForEntities', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<EB_Loan_Packet__c>()); 
        mockPricingSvcProxy.setup('getPricingInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new PricingWkstResults()); 

        sut = new PricingWkstController(mockApexPages, mockParentRelationshipSvc, mockDataProvider, mockPricingSvcProxy, mockAttachmentHandler, mockConfigs);
    }

    @IsTest
    static void it_should_call_the_default_constructor_without_error() {
        PricingWkstController sutDef = new PricingWkstController();
    }

    @IsTest
    static void it_should_get_the_worksheet_id_from_the_apex_wrapper() {
        sut.initialize();

        mockApexPages.verify('getParameter', new List<Object>{'Id'});
    }

    @IsTest
    static void it_should_get_the_worksheet_object_and_existing_details_from_the_data_provider_when_the_worksheet_id_is_given() {
        Pricing_Worksheet__c workSheet = new Pricing_Worksheet__c(Id=ObjectFactory.getFakeId(Pricing_Worksheet__c.SObjectType, '1'));
        workSheet.Entity__c = topLevelParent.Id;

        String applicationCodes = 'ValidForPricingWkstAppCodes';
        String codes = '2,4,6';
        Set<Integer> codesSet = new Set<Integer>{2,4,6};

        mockApexPages.setup('getParameter', new List<Object>{'Id'}).returns(workSheet.Id);
        mockDataProvider.setup('getPricingWorksheet', new List<Object>{workSheet.Id}).returns(workSheet);
        mockDataProvider.setup('getPricingWorksheet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(workSheet);
        mockConfigs.setup('get', new List<Object>{applicationCodes}).returns(codes);

        sut.initialize();

        mockDataProvider.verify('getPricingWorksheet', new List<Object>{workSheet.Id});
        mockDataProvider.verify('getPricingProposedDepositsForWorksheet', new List<Object>{workSheet.Id});   
        mockDataProvider.verify('getPricingProposedLoansForWorksheet', new List<Object>{workSheet.Id});  
        mockDataProvider.verify('getPricingProposedNonIntIncomeForWorksheet', new List<Object>{workSheet.Id});   
        mockDataProvider.verify('getPricingProposedAcctRemovalsForWorksheet', new List<Object>{workSheet.Id});   
        System.assertEquals(workSheet, sut.currentWorksheet);
    }

    @IsTest
    static void it_should_add_an_error_when_the_worksheet_id_is_empty() {
        mockApexPages.setup('getParameter', new List<Object>{'Id'}).returns('');

        sut.initialize();

        mockApexPages.verify('addMessage', ApexMoq.Arguments.HAVE_ANY_VALUE);
    }

    @IsTest
    static void it_should_get_existing_accounts_for_all_related_entities_when_id_is_not_empty() {
        Pricing_Worksheet__c workSheet = new Pricing_Worksheet__c(Id=ObjectFactory.getFakeId(Pricing_Worksheet__c.SObjectType, '1'));
        workSheet.Entity__c = topLevelParent.Id;
        
        Account parent1         = new Account(Id=ObjectFactory.getFakeId(Account.SObjectType,'2'), ParentId=topLevelParent.Id);
        Account parent2         = new Account(Id=ObjectFactory.getFakeId(Account.SObjectType,'3'), ParentId=topLevelParent.Id);
        Account childOfParent1  = new Account(Id=ObjectFactory.getFakeId(Account.SObjectType,'4'), ParentId=parent1.Id);
        Account childOfParent2  = new Account(Id=ObjectFactory.getFakeId(Account.SObjectType,'5'), ParentId=parent2.Id);
        Map<Id, Account> allRelatedEntities = new Map<Id, Account> {
            topLevelParent.Id => topLevelParent,
            parent1.Id => parent1,
            parent2.Id => parent2,
            childOfParent1.Id => childOfParent1,
            childOfParent2.Id => childOfParent2
        };
        String applicationCodes = 'ValidForPricingWkstAppCodes';
        String codes = '2,4,6';
        Set<Integer> codesSet = new Set<Integer>{2,4,6};
        
        mockApexPages.setup('getParameter', new List<Object>{'Id'}).returns(workSheet.Id);
        mockDataProvider.setup('getPricingWorksheet', new List<Object>{workSheet.Id}).returns(workSheet);
        mockParentRelationshipSvc.setup('getAllRelatedEntitiesForParent', new List<Object>{topLevelParent.Id}).returns(allRelatedEntities);
        mockDataProvider.setup('getPricingWorksheet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(workSheet); 
        mockConfigs.setup('get', new List<Object>{applicationCodes}).returns(codes);
        
        sut.initialize();

        mockParentRelationshipSvc.verify('getAllRelatedEntitiesForParent', new List<Object>{topLevelParent.Id});
        mockDataProvider.verify('getEBAccountsForEntities', new List<Object>{allRelatedEntities.keySet(), codesSet});
    }

    @IsTest
    static void it_should_get_pricing_results_from_the_pricing_service_when_worksheet_id_is_not_empty() {
        Pricing_Worksheet__c workSheet = new Pricing_Worksheet__c(Id=ObjectFactory.getFakeId(Pricing_Worksheet__c.SObjectType, '1'));
        workSheet.Entity__c = topLevelParent.Id;
        
        EB_Account__c acct = new EB_Account__c(Id=ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1'), Name='123');
        Map<Id, EB_Account__c> accountsMap = new Map<Id, EB_Account__c>{acct.Id => acct};
        List<EB_Account__c> accountsList = new List<EB_Account__c>{acct};
        
        String applicationCodes = 'ValidForPricingWkstAppCodes';
        String codes = '2,4,6';
        Set<Integer> codesSet = new Set<Integer>{2,4,6};
        
        mockApexPages.setup('getParameter', new List<Object>{'Id'}).returns(workSheet.Id);
        mockDataProvider.setup('getPricingWorksheet', new List<Object>{workSheet.Id}).returns(workSheet);
        mockDataProvider.setup('getEBAccountsForEntities',new List<Object>{topLevelParentMap.keySet(), codesSet}).returns(accountsList);
        mockParentRelationshipSvc.setup('getAllRelatedEntitiesForParent', new List<Object>{topLevelParentMap.keySet()}).returns(accountsMap);
        mockConfigs.setup('get', new List<Object>{applicationCodes}).returns(codes);

        sut.initialize();

        List<Object> rawRequest = mockPricingSvcProxy.getArgumentsFromCall('getPricingInformation');
        PricingWkstRequest req = (PricingWkstRequest) (rawRequest.get(0));

        System.assertEquals(1, req.existingAccounts.size());
        System.assertEquals('123', req.existingAccounts[0].Name);
    }

    @IsTest
    static void it_should_send_the_current_worksheet_id_to_pdf_generator_to_save_as_pdf() {
        Pricing_Worksheet__c workSheet = new Pricing_Worksheet__c(Id=ObjectFactory.getFakeId(Pricing_Worksheet__c.SObjectType, '1'));
        workSheet.Entity__c = topLevelParent.Id;

        String applicationCodes = 'ValidForPricingWkstAppCodes';
        String codes = '2,4,6';
        Set<Integer> codesSet = new Set<Integer>{2,4,6};

        mockApexPages.setup('getParameter', new List<Object>{'Id'}).returns(workSheet.Id);
        mockDataProvider.setup('getPricingWorksheet', new List<Object>{workSheet.Id}).returns(workSheet);
        mockConfigs.setup('get', new List<Object>{applicationCodes}).returns(codes);
        
        sut.initialize();
        sut.saveWorksheetAsAttachment();

        List<Object> rawRequest = mockAttachmentHandler.getArgumentsFromCall('generateAttachmentFromPageRef');
        PageReference pdfArgument = (PageReference) (rawRequest.get(0));
        String idArgument = (String) (rawRequest.get(2));
        System.assertEquals(workSheet.Id, idArgument);
        System.assertEquals(workSheet.Id, pdfArgument.getParameters().get('id'));
        System.assertEquals('pdf', pdfArgument.getParameters().get('renderAs'));
    }

    @IsTest
    static void it_should_send_the_selected_loan_packet_to_pdf_generator_to_save_as_pdf() {
        Id fakeLoanPacketId = ObjectFactory.getFakeId(EB_Loan_Packet__c.SObjectType, '1');
        Pricing_Worksheet__c workSheet = new Pricing_Worksheet__c(Id=ObjectFactory.getFakeId(Pricing_Worksheet__c.SObjectType, '1'));
        workSheet.Entity__c = topLevelParent.Id;

        String applicationCodes = 'ValidForPricingWkstAppCodes';
        String codes = '2,4,6';
        Set<Integer> codesSet = new Set<Integer>{2,4,6};

        mockApexPages.setup('getParameter', new List<Object>{'Id'}).returns(workSheet.Id);
        mockDataProvider.setup('getPricingWorksheet', new List<Object>{workSheet.Id}).returns(workSheet);
        mockConfigs.setup('get', new List<Object>{applicationCodes}).returns(codes);

        sut.initialize();
        sut.selectedLoanPacket = fakeLoanPacketId;

        sut.saveWorksheetAsAttachmentOnLoanPacket();

        List<Object> rawRequest = mockAttachmentHandler.getArgumentsFromCall('generateAttachmentFromPageRef');
        String idArgument = (String) (rawRequest.get(2));
        System.assertEquals(fakeLoanPacketId, idArgument);
    }  

    @IsTest
    static void it_should_make_a_call_to_save_pricing_worksheet() {
        sut.initialize();

        sut.savePricingWorksheet();

        mockDataProvider.verify('updatePricingWorksheet', new List<Object>{sut.currentWorksheet});
    }

    @IsTest
    static void it_should_set_displayRelationshipTree_to_false_on_load() {
        sut.initialize();

        Boolean results = sut.displayRelationshipTree;

        System.assertEquals(false, results);
    }

    @IsTest
    static void it_should_set_displayRelationshipTree_to_true_when_existing_value_is_false() {
        sut.initialize();
        sut.showRelationshipTree();

        Boolean results = sut.displayRelationshipTree;

        System.assertEquals(true, results);
    }

    @IsTest
    static void it_should_set_displayRelationshipTree_to_false_when_existing_value_is_true() {
        sut.initialize();
        sut.showRelationshipTree();
        sut.hideRelationshipTree();

        Boolean results = sut.displayRelationshipTree;

        System.assertEquals(false, results);
    }

   private class MockofIPricingWkstSvcProxy extends ApexMoq implements PricingWkst.IPricingWkstSvcProxy {
        public PricingWkstResults getPricingInformation(PricingWkstRequest request){
            return (PricingWkstResults)handleMethodInvocation('getPricingInformation', new List<Object>{request});
        }
    }
}