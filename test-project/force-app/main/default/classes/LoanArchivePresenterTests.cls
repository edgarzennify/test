@IsTest
private class LoanArchivePresenterTests {
    private final static LoanArchivePresenter sut;
    private final static LoanArchiveMock.ofIVmBuilder mockVmBuilder;
    private final static LoanArchiveMock.ofIDataProvider mockDataProvider;
    private final static LoanArchiveMock.ofIProcessor mockProcessor;
    private final static LoanArchiveMock.ofIValidator mockValidator;

    static {
        mockVmBuilder = new LoanArchiveMock.ofIVmBuilder();
        mockDataProvider = new LoanArchiveMock.ofIDataProvider();
        mockProcessor = new LoanArchiveMock.ofIProcessor();
        mockValidator = new LoanArchiveMock.ofIValidator();
        sut = new LoanArchivePresenter(mockVmBuilder, mockDataProvider, mockProcessor, mockValidator);
    }

    @IsTest
    static void it_should_call_the_document_provider_to_get_loan_object_for_merge() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SobjectType, '1');
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Id = loanId);
        mockDataProvider.setup('getLoanForVm', new List<Object>{loanId}).returns(loan);

        sut.buildFormVm(loanId);

        mockDataProvider.verify('getLoanForVm', new List<Object>{loanId}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_and_pass_the_involvements_to_get_merged_vm_to_get_entity_objects() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SobjectType, '1');
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Id = loanId);
        mockDataProvider.setup('getLoanForVm', new List<Object>{loanId}).returns(loan);

        sut.buildFormVm(loanId);

        mockVmBuilder.verify('buildEntityMergeList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_and_pass_the_pledged_to_get_collateral_objects() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SobjectType, '1');
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = loanId;
        mockDataProvider.setup('getLoanForVm', new List<Object>{loanId}).returns(loan);

        sut.buildFormVm(loanId);

        mockVmBuilder.verify('buildCollateralMergeList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_and_pass_the_involvements_to_get_entity_options() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SobjectType, '1');
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Id = loanId);
        mockDataProvider.setup('getLoanForVm', new List<Object>{loanId}).returns(loan);

        sut.buildFormVm(loanId);

        mockVmBuilder.verify('buildCoreEntityOptions', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_and_pass_the_pledged_to_get_collateral_options() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SobjectType, '1');
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Id = loanId);
        mockDataProvider.setup('getLoanForVm', new List<Object>{loanId}).returns(loan);

        sut.buildFormVm(loanId);

        mockVmBuilder.verify('buildCoreCollateralOptions', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_processor_to_save_the_requests() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        LoanArchive.FormVm formVm = new LoanArchive.FormVm();
        LoanArchive.MergeObjectVm mergeVm = new LoanArchive.MergeObjectVm();
        mergeVm.objectId = entityId;
        mergeVm.description = 'test';
        formVm.loanId = loanId;
        formVm.entityMergeList = new List<LoanArchive.MergeObjectVm>{mergeVm};

        sut.save(formVm);

        mockProcessor.verify('process', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = mockProcessor.getArgumentsFromCall('process');
        Id vmLoanId = (Id)arguments[0];
        List<LoanArchive.SObjectMergeRequest> requests = (List<LoanArchive.SObjectMergeRequest>)arguments[1];
        System.assertEquals(loanId, vmLoanId);
        System.assertEquals(2 ,requests.size());
        System.assertEquals(loanId ,requests[0].prospectObjectId);
        System.assertEquals(entityId ,requests[1].prospectObjectId);
    }

    @IsTest
    static void it_should_throw_when_save_exception_is_encountered() {
        LoanArchive.FormVm formVm = null;

        try {
            sut.save(formVm);
            System.assert(false);
        } catch (LoanArchive.SaveException ex) {
            System.assert(true);
        } catch (Exception defEx) {
            System.assert(false);
        }
    }

    @IsTest
    static void it_should_build_a_form_vm_and_validate_the_core_entity_created_date() {
        String objTypeEntity = 'Entity';
        String objTypeCollateral = 'Collateral';
        DateTime coreDate1 = DateTime.newInstance(2016, 11, 1);
        DateTime coreDate2 = DateTime.newInstance(2016, 12, 30);
        DateTime coreDate3 = DateTime.newInstance(2017, 1, 7);
        Id entity1Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id entity2Id = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Id entity3Id = ObjectFactory.getFakeId(Account.SObjectType, '3');
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');

        LoanArchive.MergeObjectVm entityMergeVm1 = new LoanArchive.MergeObjectVm();
        entityMergeVm1.description = 'entity 1 core';
        entityMergeVm1.objectId = entity1Id;
        entityMergeVm1.selectedOptionId = entity1Id;
        entityMergeVm1.createdDate = coreDate1;

        LoanArchive.MergeObjectVm entityMergeVm2 = new LoanArchive.MergeObjectVm();
        entityMergeVm2.description = 'entity 2 core';
        entityMergeVm2.objectId = entity2Id;
        entityMergeVm2.selectedOptionId = entity2Id;
        entityMergeVm2.createdDate = coreDate2;

        LoanArchive.MergeObjectVm entityMergeVm3 = new LoanArchive.MergeObjectVm();
        entityMergeVm3.description = 'entity 3 prospect';
        entityMergeVm3.objectId = entity3Id;
        entityMergeVm3.selectedOptionId = entity3Id;
        entityMergeVm3.createdDate = coreDate3;

        SelectOption coreEntityOption1 = new SelectOption(entityMergeVm1.objectId, entityMergeVm1.description);
        SelectOption coreEntityOption2 = new SelectOption(entityMergeVm2.objectId, entityMergeVm2.description);

        List<LoanArchive.MergeObjectVm> entityMergeList = new List<LoanArchive.MergeObjectVm>{entityMergeVm1, entityMergeVm2, entityMergeVm1};
        List<LoanArchive.MergeObjectVm> entityCoreMergeList = new List<LoanArchive.MergeObjectVm>{entityMergeVm1, entityMergeVm2};
        List<LoanArchive.MergeObjectVm> collateralMergeList = new List<LoanArchive.MergeObjectVm>();
        List<LoanArchive.MergeObjectVm> collateralCoreMergeList = new List<LoanArchive.MergeObjectVm>{new LoanArchive.MergeObjectVm()};

        List<SelectOption> buildCoreEntityOptions = new List<SelectOption>{coreEntityOption1, coreEntityOption2};
        List<SelectOption> buildCoreCollateralOptions = new List<SelectOption>{new SelectOption('',''), new SelectOption('','')};

        mockVmBuilder.setup('buildEntityMergeList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(entityMergeList);
        mockVmBuilder.setup('buildEntityCoreMergeList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(entityCoreMergeList);
        mockVmBuilder.setup('buildCollateralMergeList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(collateralMergeList);
        mockVmBuilder.setup('buildCollateralCoreMergeList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(collateralCoreMergeList);
        mockVmBuilder.setup('buildCoreCollateralOptions', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(buildCoreCollateralOptions);
        mockVmBuilder.setup('buildCoreEntityOptions', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(buildCoreEntityOptions);
        mockDataProvider.setup('getLoanForVm', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new LLC_BI__Loan__c(Id = loanId));
        mockValidator.setup('validateCoreMerge', new List<Object>{entityMergeList, 'Entity'}).returns(new List<string>{'error 1'});
        mockValidator.setup('validateCoreMerge', new List<Object>{collateralMergeList, 'Collateral'}).returns(new List<string>{''});
        mockValidator.setup('validateCoreAge', new List<Object>{entityMergeList, entityCoreMergeList, 'Entity'}).returns(new List<string>{'error core 1'});
        mockValidator.setup('validateCoreAge', new List<Object>{collateralMergeList, collateralCoreMergeList, 'Collateral'}).returns(new List<string>{''});

        LoanArchive.FormVm formVm = sut.buildFormVm(loanId);

        List<String> result = sut.getValidationErrors(formVm);

        System.assertEquals(4, result.size());
        System.assertEquals('error 1', result[0]);
        System.assertEquals('', result[1]);
        System.assertEquals('error core 1', result[2]);
        System.assertEquals('', result[3]);
    }

    @IsTest
    static void it_should_build_a_form_vm_and_validate_the_core_collateral_created_date() {
        String objTypeEntity = 'Entity';
        String objTypeCollateral = 'Collateral';
        DateTime coreDate1 = DateTime.newInstance(2016, 11, 1);
        DateTime coreDate2 = DateTime.newInstance(2016, 12, 30);
        DateTime coreDate3 = DateTime.newInstance(2017, 1, 7);
        Id collateral1Id = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        Id collateral2Id = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '2');
        Id collateral3Id = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '3');
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');

        LoanArchive.MergeObjectVm collateralMergeVm1 = new LoanArchive.MergeObjectVm();
        collateralMergeVm1.description = 'collateral 1 core';
        collateralMergeVm1.objectId = collateral1Id;
        collateralMergeVm1.selectedOptionId = collateral1Id;
        collateralMergeVm1.createdDate = coreDate1;

        LoanArchive.MergeObjectVm collateralMergeVm2 = new LoanArchive.MergeObjectVm();
        collateralMergeVm2.description = 'collateral 2 core';
        collateralMergeVm2.objectId = collateral2Id;
        collateralMergeVm2.selectedOptionId = collateral2Id;
        collateralMergeVm2.createdDate = coreDate2;

        LoanArchive.MergeObjectVm collateralMergeVm3 = new LoanArchive.MergeObjectVm();
        collateralMergeVm3.description = 'collateral 3 prospect';
        collateralMergeVm3.objectId = collateral3Id;
        collateralMergeVm3.selectedOptionId = collateral3Id;
        collateralMergeVm3.createdDate = coreDate3;

        SelectOption coreCollateralOption1 = new SelectOption(collateralMergeVm1.objectId, collateralMergeVm1.description);
        SelectOption coreCollateralOption2 = new SelectOption(collateralMergeVm2.objectId, collateralMergeVm2.description);

        List<LoanArchive.MergeObjectVm> collateralMergeList = new List<LoanArchive.MergeObjectVm>{collateralMergeVm1, collateralMergeVm2, collateralMergeVm3};
        List<LoanArchive.MergeObjectVm> collateralCoreMergeList = new List<LoanArchive.MergeObjectVm>{collateralMergeVm1, collateralMergeVm2};
        List<LoanArchive.MergeObjectVm> entityMergeList = new List<LoanArchive.MergeObjectVm>();
        List<LoanArchive.MergeObjectVm> entityCoreMergeList = new List<LoanArchive.MergeObjectVm>{new LoanArchive.MergeObjectVm()};

        List<SelectOption> buildCoreCollateralOptions = new List<SelectOption>{coreCollateralOption1, coreCollateralOption2};
        List<SelectOption> buildCoreEntityOptions = new List<SelectOption>{new SelectOption('',''), new SelectOption('','')};

        mockVmBuilder.setup('buildEntityMergeList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(entityMergeList);
        mockVmBuilder.setup('buildEntityCoreMergeList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(entityCoreMergeList);
        mockVmBuilder.setup('buildCollateralMergeList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(collateralMergeList);
        mockVmBuilder.setup('buildCollateralCoreMergeList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(collateralCoreMergeList);
        mockVmBuilder.setup('buildCoreCollateralOptions', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(buildCoreCollateralOptions);
        mockVmBuilder.setup('buildCoreEntityOptions', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(buildCoreEntityOptions);
        mockDataProvider.setup('getLoanForVm', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new LLC_BI__Loan__c(Id = loanId));
        mockValidator.setup('validateCoreMerge', new List<Object>{entityMergeList, 'Entity'}).returns(new List<string>{''});
        mockValidator.setup('validateCoreMerge', new List<Object>{collateralMergeList, 'Collateral'}).returns(new List<string>{'error collateral 1'});
        mockValidator.setup('validateCoreAge', new List<Object>{entityMergeList, entityCoreMergeList, 'Entity'}).returns(new List<string>{''});
        mockValidator.setup('validateCoreAge', new List<Object>{collateralMergeList, collateralCoreMergeList, 'Collateral'}).returns(new List<string>{'error collateral core 1'});

        LoanArchive.FormVm formVm = sut.buildFormVm(loanId);

        List<String> result = sut.getValidationErrors(formVm);

        System.assertEquals(4, result.size());
        System.assertEquals('', result[0]);
        System.assertEquals('error collateral 1', result[1]);
        System.assertEquals('', result[2]);
        System.assertEquals('error collateral core 1', result[3]);
    }

    @IsTest
    static void it_should_call_the_processor_to_save_the_collateral_requests() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id collateralId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        LoanArchive.FormVm formVm = new LoanArchive.FormVm();
        LoanArchive.MergeObjectVm mergeVm = new LoanArchive.MergeObjectVm();
        mergeVm.objectId = collateralId;
        mergeVm.description = 'test';
        formVm.loanId = loanId;
        formVm.collateralMergeList = new List<LoanArchive.MergeObjectVm>{mergeVm};

        sut.saveCollateral(formVm);

        mockProcessor.verify('process', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = mockProcessor.getArgumentsFromCall('process');
        Id vmLoanId = (Id)arguments[0];
        List<LoanArchive.SObjectMergeRequest> requests = (List<LoanArchive.SObjectMergeRequest>)arguments[1];
        System.assertEquals(loanId, vmLoanId);
        System.assertEquals(1 ,requests.size());
        System.assertEquals(collateralId, requests[0].prospectObjectId);
    }
}