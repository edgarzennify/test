@IsTest
private class LoanArchiveControllerTests {

    private final static LoanArchiveController sut;
    private final static Mock.ofIStandardController mockStandardController;
    private final static Mock.ofIApexPages mockApexPages;
    private final static LoanArchiveMock.ofIPresenter mockPresenter;
    private final static Mock.ofIUserInfoService mockUserInfoService;

    static {
        mockStandardController = new Mock.ofIStandardController();
        mockApexPages = new Mock.ofIApexPages();
        mockPresenter = new LoanArchiveMock.ofIPresenter();
        mockUserInfoService = new Mock.ofIUserInfoService();
        sut = new LoanArchiveController(mockStandardController, mockApexPages, mockPresenter, mockUserInfoService);
    }

    @IsTest
    static void it_should_build_the_form_vm_when_initialized() {
        Id id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        mockStandardController.setup('getId').returns(id);

        sut.initialize();

        mockPresenter.verify('buildFormVm', new List<Object>{ id }, Times.Once);
    }

    @IsTest
    static void it_should_return_the_form_vm_components() {
        Id id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LoanArchive.FormVm formVm = new LoanArchive.FormVm();
        LoanArchive.MergeObjectVm evm = new LoanArchive.MergeObjectVm();
        evm.description = 'evm';
        LoanArchive.MergeObjectVm cvm = new LoanArchive.MergeObjectVm();
        cvm.description = 'cvm';
        SelectOption eso = new SelectOption('0', 'eso');
        SelectOption cso =  new SelectOption('1', 'cso');
        formVm.entityMergeList = new List<LoanArchive.MergeObjectVm>{evm};
        formVm.collateralMergeList = new List<LoanArchive.MergeObjectVm>{cvm};
        formVm.coreEntityOptions = new List<SelectOption>{eso};
        formVm.coreCollateralOptions = new List<SelectOption>{cso};
        mockStandardController.setup('getId').returns(id);
        mockPresenter.setup('buildFormVm', new List<Object>{ id }).returns(formVm);

        sut.initialize();

        Object result;
        result = sut.entityMergeList;
        System.assertEquals(formVm.entityMergeList, result);
        result = sut.collateralMergeList;
        System.assertEquals(formVm.collateralMergeList, result);
        result = sut.coreEntityOptions;
        System.assertEquals(formVm.coreEntityOptions, result);
        result = sut.coreCollateralOptions;
        System.assertEquals(formVm.coreCollateralOptions, result);
    }

    @IsTest
    static void it_should_get_the_validation_errors_when_save_is_clicked() {
        Id id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LoanArchive.FormVm formVm = new LoanArchive.FormVm();
        LoanArchive.MergeObjectVm evm = new LoanArchive.MergeObjectVm();
        evm.description = 'evm';
        LoanArchive.MergeObjectVm cvm = new LoanArchive.MergeObjectVm();
        cvm.description = 'cvm';
        SelectOption eso = new SelectOption('0', 'eso');
        SelectOption cso =  new SelectOption('1', 'cso');
        formVm.entityMergeList = new List<LoanArchive.MergeObjectVm>{evm};
        formVm.collateralMergeList = new List<LoanArchive.MergeObjectVm>{cvm};
        formVm.coreEntityOptions = new List<SelectOption>{eso};
        formVm.coreCollateralOptions = new List<SelectOption>{cso};
        mockStandardController.setup('getId').returns(id);
        mockPresenter.setup('buildFormVm', new List<Object>{ id }).returns(formVm);
        mockPresenter.setup('getValidationErrors', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<String>());

        sut.initialize();
        sut.saveClicked();

        mockPresenter.verify('getValidationErrors', new List<Object>{ formVm }, Times.Once);
    }

    @IsTest
    static void it_should_add_the_validation_errors_as_page_messages_if_there_are_any() {
        Id id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LoanArchive.FormVm formVm = new LoanArchive.FormVm();
        LoanArchive.MergeObjectVm evm = new LoanArchive.MergeObjectVm();
        evm.description = 'evm';
        LoanArchive.MergeObjectVm cvm = new LoanArchive.MergeObjectVm();
        cvm.description = 'cvm';
        SelectOption eso = new SelectOption('0', 'eso');
        SelectOption cso =  new SelectOption('1', 'cso');
        formVm.entityMergeList = new List<LoanArchive.MergeObjectVm>{evm};
        formVm.collateralMergeList = new List<LoanArchive.MergeObjectVm>{cvm};
        formVm.coreEntityOptions = new List<SelectOption>{eso};
        formVm.coreCollateralOptions = new List<SelectOption>{cso};
        List<String> errors = new List<String>{ 'error1', 'error2' };
        mockStandardController.setup('getId').returns(id);
        mockPresenter.setup('buildFormVm', new List<Object>{ id }).returns(formVm);
        mockPresenter.setup('getValidationErrors', new List<Object>{ formVm }).returns(errors);

        sut.initialize();
        sut.saveClicked();

        mockApexPages.verify('addMessage', new List<Object>{ApexPages.Severity.ERROR, 'error1'}, Times.Once);
        mockApexPages.verify('addMessage', new List<Object>{ApexPages.Severity.ERROR, 'error2'}, Times.Once);
    }

    @IsTest
    static void it_should_save_the_vm_if_there_are_no_validation_errors() {
        Id id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LoanArchive.FormVm formVm = new LoanArchive.FormVm();
        LoanArchive.MergeObjectVm evm = new LoanArchive.MergeObjectVm();
        evm.description = 'evm';
        LoanArchive.MergeObjectVm cvm = new LoanArchive.MergeObjectVm();
        cvm.description = 'cvm';
        SelectOption eso = new SelectOption('0', 'eso');
        SelectOption cso =  new SelectOption('1', 'cso');
        formVm.entityMergeList = new List<LoanArchive.MergeObjectVm>{evm};
        formVm.collateralMergeList = new List<LoanArchive.MergeObjectVm>{cvm};
        formVm.coreEntityOptions = new List<SelectOption>{eso};
        formVm.coreCollateralOptions = new List<SelectOption>{cso};
        mockStandardController.setup('getId').returns(id);
        mockPresenter.setup('buildFormVm', new List<Object>{ id }).returns(formVm);
        mockPresenter.setup('getValidationErrors', new List<Object>{ formVm }).returns(new List<String>());

        sut.initialize();
        sut.saveClicked();

        mockPresenter.verify('save', new List<Object>{formVm}, Times.Once);
    }

    @IsTest
    static void it_should_return_the_correct_page_reference_if_save_is_successful() {
        Id id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LoanArchive.FormVm formVm = new LoanArchive.FormVm();
        LoanArchive.MergeObjectVm evm = new LoanArchive.MergeObjectVm();
        evm.description = 'evm';
        LoanArchive.MergeObjectVm cvm = new LoanArchive.MergeObjectVm();
        cvm.description = 'cvm';
        SelectOption eso = new SelectOption('0', 'eso');
        SelectOption cso =  new SelectOption('1', 'cso');
        formVm.entityMergeList = new List<LoanArchive.MergeObjectVm>{evm};
        formVm.collateralMergeList = new List<LoanArchive.MergeObjectVm>{cvm};
        formVm.coreEntityOptions = new List<SelectOption>{eso};
        formVm.coreCollateralOptions = new List<SelectOption>{cso};
        mockStandardController.setup('getId').returns(id);
        mockPresenter.setup('buildFormVm', new List<Object>{ id }).returns(formVm);
        mockPresenter.setup('getValidationErrors', new List<Object>{ formVm }).returns(new List<String>());

        sut.initialize();

        PageReference result = sut.saveClicked();

        System.assertEquals('/' + id, result.getUrl());
    }

    @IsTest
    static void it_should_add_a_page_message_and_return_null_if_save_is_unsuccessful() {
        Id id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LoanArchive.FormVm formVm = new LoanArchive.FormVm();
        LoanArchive.MergeObjectVm evm = new LoanArchive.MergeObjectVm();
        evm.description = 'evm';
        LoanArchive.MergeObjectVm cvm = new LoanArchive.MergeObjectVm();
        cvm.description = 'cvm';
        SelectOption eso = new SelectOption('0', 'eso');
        SelectOption cso =  new SelectOption('1', 'cso');
        formVm.entityMergeList = new List<LoanArchive.MergeObjectVm>{evm};
        formVm.collateralMergeList = new List<LoanArchive.MergeObjectVm>{cvm};
        formVm.coreEntityOptions = new List<SelectOption>{eso};
        formVm.coreCollateralOptions = new List<SelectOption>{cso};
        mockStandardController.setup('getId').returns(id);
        mockPresenter.setup('buildFormVm', new List<Object>{ id }).returns(formVm);
        mockPresenter.setup('getValidationErrors', new List<Object>{ formVm }).returns(new List<String>());
        mockPresenter.setup('save', new List<Object>{formVm}).throws(new LoanArchive.SaveException('test-message'));

        sut.initialize();

        PageReference result = sut.saveClicked();

        mockApexPages.verify('addMessage', new List<Object>{ApexPages.Severity.ERROR, 'test-message'}, Times.Once);
        System.assert(result == null);
    }

    @IsTest
    static void it_should_return_the_correct_page_reference_when_cancel_is_clicked() {
        Id id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LoanArchive.FormVm formVm = new LoanArchive.FormVm();
        LoanArchive.MergeObjectVm evm = new LoanArchive.MergeObjectVm();
        evm.description = 'evm';
        LoanArchive.MergeObjectVm cvm = new LoanArchive.MergeObjectVm();
        cvm.description = 'cvm';
        SelectOption eso = new SelectOption('0', 'eso');
        SelectOption cso =  new SelectOption('1', 'cso');
        formVm.entityMergeList = new List<LoanArchive.MergeObjectVm>{evm};
        formVm.collateralMergeList = new List<LoanArchive.MergeObjectVm>{cvm};
        formVm.coreEntityOptions = new List<SelectOption>{eso};
        formVm.coreCollateralOptions = new List<SelectOption>{cso};
        mockStandardController.setup('getId').returns(id);
        mockPresenter.setup('buildFormVm', new List<Object>{ id }).returns(formVm);

        sut.initialize();

        PageReference result = sut.cancelClicked();

        System.assertEquals('/' + id, result.getUrl());
    }

    @IsTest
    static void it_should_call_the_presenter_to_save_partial_collateral_merge() {
        Id id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LoanArchive.FormVm formVm = new LoanArchive.FormVm();
        LoanArchive.MergeObjectVm evm = new LoanArchive.MergeObjectVm();
        evm.description = 'evm';
        LoanArchive.MergeObjectVm cvm = new LoanArchive.MergeObjectVm();
        cvm.description = 'cvm';
        SelectOption eso = new SelectOption('0', 'eso');
        SelectOption cso =  new SelectOption('1', 'cso');
        formVm.entityMergeList = new List<LoanArchive.MergeObjectVm>{evm};
        formVm.collateralMergeList = new List<LoanArchive.MergeObjectVm>{cvm};
        formVm.coreEntityOptions = new List<SelectOption>{eso};
        formVm.coreCollateralOptions = new List<SelectOption>{cso};
        mockStandardController.setup('getId').returns(id);
        mockPresenter.setup('buildFormVm', new List<Object>{ id }).returns(formVm);
        mockPresenter.setup('getValidationErrors', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<String>());

        sut.initialize();

        PageReference result = sut.saveCollateralClicked();

        System.assertEquals(true, result.getUrl().contains('/apex/LoanArchive?id=' +id));
        mockPresenter.verify('saveCollateral', new List<Object>{ formVm }, Times.Once);

    }

    @IsTest
    static void it_should_call_user_info_to_verify_user_as_admin() {
        Boolean result = sut.isAdmin;

        mockUserInfoService.verify('isSystemAdministrator', Times.Once);
    }

    @IsTest
    static void code_coverage_construct_with_standard_controller() {
        Id id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Id=id);
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(loan);
        LoanArchiveController xsut = new LoanArchiveController(standardController);

        System.assert(sut != null);
    }
}