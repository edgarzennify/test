@IsTest
private class LoanArchiveHandlerLoanTests {
    
    private final static LoanArchiveHandlerLoan sut;
    private final static LoanArchiveMock.ofIDataProvider mockDataProvider;
    private final static LoanArchiveMock.ofIHandlerLoanHelper mockHelper;

    static {
        mockDataProvider = new LoanArchiveMock.ofIDataprovider();
        mockHelper = new LoanArchiveMock.ofIHandlerLoanHelper();
        sut = new LoanArchiveHandlerLoan(mockDataProvider, mockHelper);
    }

    @IsTest
    static void it_should_get_get_the_sobject_type_for_loan() {
        SObjectType result = sut.getSObjectTypeHandled();

        System.assertEquals(LLC_BI__Loan__c.SObjectType ,result);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_get_loans_for_provided_ids() {
        Id loanId = Objectfactory.getFakeId(LLC_BI__Loan__c.SobjectType, '1');
        List<Id> loanIds = new List<Id>{ loanId };
            
        List<LLC_BI__Loan__c> result = sut.getSObjectsForMerging(loanIds);
        
        mockDataProvider.verify('getSObjectsForLoanMerge', new List<Object>{ loanIds }, Times.Once);
    }

    @IsTest
    static void it_should_call_the_data_provider_and_helper_to_build_map_when_map_is_null() {
        Id coreId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType,'1');
        LLC_BI__Loan__c coreObj = new LLC_BI__Loan__c(Id=coreId, LLC_BI__lookupKey__c='22');
        coreObj.Archive__c = false;
        coreObj.Ready_for_Checkback__c = false;

        Map<Id, SObject> loanObjects = new Map<Id,SObject>{ coreObj.Id => coreObj};

        Id ebAcctId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');
        EB_Account__c ebAcct = new EB_Account__c(Id = ebAcctId);
        List<EB_Account__c> ebAccts = new List<EB_Account__c>{ebAcct};

        sut.mergeObjects(null, coreObj.Id, loanobjects);

        mockDataProvider.verify('findEbAcctTwins', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('buildCachedMap', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_not_call_the_data_provider_or_helper_to_build_map_when_map_is_not_null() {
        Id coreId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType,'1');
        LLC_BI__Loan__c coreObj = new LLC_BI__Loan__c(Id=coreId, LLC_BI__lookupKey__c='22');
        coreObj.Archive__c = false;
        coreObj.Ready_for_Checkback__c = false;

        Map<Id, SObject> loanObjects = new Map<Id,SObject>{ coreObj.Id => coreObj};

        Id ebAcctId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');
        EB_Account__c ebAcct = new EB_Account__c(Id = ebAcctId);
        List<EB_Account__c> ebAccts = new List<EB_Account__c>{ebAcct};

        LoanArchiveHandlerLoanHelper.cachedMap = new Map<Id, Id>();
        LoanArchiveHandlerLoanHelper.cachedMap.put(coreObj.Id, ebAcct.Id);

        sut.mergeObjects(null, coreObj.Id, loanobjects);

        mockDataProvider.verify('findEbAcctTwins', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        mockHelper.verify('buildCachedMap', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
    }

    @IsTest
    static void INTEGRATION_it_should_build_a_merge_result_from_coreid_and_objects() {
        LLC_BI__Loan__c coreObj = new LLC_BI__Loan__c(LLC_BI__lookupKey__c='22');
        coreObj.Archive__c = false;
        coreObj.Ready_for_Checkback__c = false;
        insert coreObj;
        Agreement__c agmt = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt');
        Agreement_LLC_BI_Loan_Relationship__c llcBiRel1 = new Agreement_LLC_BI_Loan_Relationship__c(Agreement__c=agmt.Id, LLCBI_Loan__c=coreObj.Id);
        insert llcBiRel1;
        LLC_BI__Loan__c reQueriedLoan = reQueryLoan(coreObj.Id);
        Map<Id, SObject> loanObjects = new Map<Id,SObject>{ coreObj.Id => reQueriedLoan};
        Id ebAcctId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');
        EB_Account__c ebAcct = new EB_Account__c(Id = ebAcctId);

        LoanArchiveHandlerLoanHelper.cachedMap = new Map<Id, Id>();
        LoanArchiveHandlerLoanHelper.cachedMap.put(coreObj.Id, ebAcct.Id);

        LoanArchive.MergeResult result = sut.mergeObjects(null, coreObj.Id, loanobjects);

        System.assertEquals(1, result.deleteRecords.size());
        System.assertEquals(2, result.saveRecords.size());
        System.assertEquals(1, result.keyUpdates.size());
        LLC_BI__Loan__c savedLoan = (LLC_BI__Loan__c)result.saveRecords[0];
        System.assertEquals(coreObj.Id, savedLoan.Id);
        System.assertEquals(true, savedLoan.Archive__c);
        System.assertEquals(true, savedLoan.Ready_for_Checkback__c);
        Agreement_LLC_BI_Loan_Relationship__c llcBiRelToDelete = (Agreement_LLC_BI_Loan_Relationship__c)result.deleteRecords[0];
        System.assertEquals(agmt.Id, llcBiRelToDelete.Agreement__c);
        System.assertEquals(coreObj.Id, result.keyUpdates[0].oldExternalKey);
        System.assertEquals(coreObj.LLC_BI__lookupKey__c, result.keyUpdates[0].newExternalKey);
    }

    private static LLC_BI__Loan__c reQueryLoan(Id loanId) {
        return [
            SELECT
                Id,
                Name,
                LLC_BI__lookupKey__c,
                (
                    SELECT
                        Id,
                        Agreement__c,
                        LLCBI_Loan__c
                    FROM
                        Agreement_LLC_BI_Loan_Relationships__r
                )
            FROM
                LLC_BI__Loan__c
            WHERE
                Id =: loanId
            LIMIT 1    
        ];
    }
}