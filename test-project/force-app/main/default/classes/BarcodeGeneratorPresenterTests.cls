@IsTest
private class BarcodeGeneratorPresenterTests {

	private final static BarcodeGeneratorPresenter sut;
	private final static BarcodeGeneratorMock.ofIVmBuilder mockVmBuilder;
	private final static BarcodeGeneratorMock.ofIRepository mockRepository;
	private final static Mock.ofIReportUrlProvider mockReportUrlProvider;
	private final static Mock.ofIConfigurations mockConfigs;

	static {
		mockVmBuilder = new BarcodeGeneratorMock.ofIVmBuilder();
		mockRepository = new BarcodeGeneratorMock.ofIRepository();
		mockReportUrlProvider = new Mock.ofIReportUrlProvider();
		mockConfigs = new Mock.ofIConfigurations();

		sut = new BarcodeGeneratorPresenter(mockVmBuilder, mockRepository, mockReportUrlProvider, mockConfigs);
	}

	@IsTest
    static void it_should_call_the_vm_builder_to_get_form_vm() {
		Id contextId = ObjectFactory.getFakeID(Account.SObjectType, '1');
		String recordType = 'Client';
		DmBgContext context = new DmBgContext();
		context.objectName = 'Account';
		context.categories = new List<DmBgCategory>();
		List<DmBgContext> contexts = new List<DmBgContext>{context};
		BarcodeGenerator.CategoryVm categoryvm = new BarcodeGenerator.CategoryVm();

		List<BarcodeGenerator.CategoryVm> categoryvms = new List<BarcodeGenerator.CategoryVm>{categoryvm};
		mockRepository.setup('getContexts').returns(contexts);
		mockVmBuilder.setup('buildCategoryVms', new List<Object>{context.categories, contextId, recordType}).returns(categoryvms);
		mockVmBuilder.setup('buildCategoryOptions', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SelectOption>());

		BarcodeGenerator.FormVm result = sut.getFormVm(contextId);

		mockVmBuilder.verify('buildCategoryVms', new List<Object>{context.categories, contextId}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_vm_builder_to_get_category_options_with_eb_account() {
		Eb_Account__c eb = new Eb_Account__c();
		eb.Key__c = '53434';
		insert eb;
		Id contextid = eb.id;

		String recordType = 'Client';
		DmBgContext context = new DmBgContext();
		context.objectName = 'Account';
		context.categories = new List<DmBgCategory>();
		List<DmBgContext> contexts = new List<DmBgContext>{context};
		BarcodeGenerator.CategoryVm categoryvm = new BarcodeGenerator.CategoryVm();
		List<BarcodeGenerator.CategoryVm> categoryvms = new List<BarcodeGenerator.CategoryVm>{categoryvm};
		mockRepository.setup('getContexts').returns(contexts);
		mockVmBuilder.setup('buildCategoryVms', new List<Object>{context.categories, contextId, recordType}).returns(categoryvms);
		mockVmBuilder.setup('buildCategoryOptions', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SelectOption>());

		BarcodeGenerator.FormVm result = sut.getFormVm(contextId);

		mockVmBuilder.setup('buildCategoryOptions', new List<Object>{categoryvms}).returns(new List<SelectOption>());
	}

	@IsTest
    static void it_should_call_the_vm_builder_to_get_category_options_with_entity() {
		Account eb = new Account();
		eb.WM_Key__c = '53434';
		eb.Name = 'sdfewr';
		eb.EB_Customer_Number__c = 'fswer';
		insert eb;
		Id contextid = eb.id;

		String recordType = 'Client';
		DmBgContext context = new DmBgContext();
		context.objectName = 'Account';
		context.categories = new List<DmBgCategory>();
		List<DmBgContext> contexts = new List<DmBgContext>{context};
		BarcodeGenerator.CategoryVm categoryvm = new BarcodeGenerator.CategoryVm();
		List<BarcodeGenerator.CategoryVm> categoryvms = new List<BarcodeGenerator.CategoryVm>{categoryvm};
		mockRepository.setup('getContexts').returns(contexts);
		mockVmBuilder.setup('buildCategoryVms', new List<Object>{context.categories, contextId, recordType}).returns(categoryvms);
		mockVmBuilder.setup('buildCategoryOptions', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SelectOption>());

		BarcodeGenerator.FormVm result = sut.getFormVm(contextId);

		mockVmBuilder.setup('buildCategoryOptions', new List<Object>{categoryvms}).returns(new List<SelectOption>());
	}

	@IsTest
    static void it_should_call_the_vm_builder_to_get_category_options_with_eb_collateral() {
		EB_Collateral__c eb = new EB_Collateral__c();
		Collateral_Code__c cc = new Collateral_Code__c();
		cc.Collateral_Code_ID__c = 'er';
		insert cc;
		eb.Key__c = '53434';
		eb.Collateral_Code__c = cc.id;
		insert eb;
		Id contextid = eb.id;

		String recordType = 'Client';
		DmBgContext context = new DmBgContext();
		context.objectName = 'Account';
		context.categories = new List<DmBgCategory>();
		List<DmBgContext> contexts = new List<DmBgContext>{context};
		BarcodeGenerator.CategoryVm categoryvm = new BarcodeGenerator.CategoryVm();
		List<BarcodeGenerator.CategoryVm> categoryvms = new List<BarcodeGenerator.CategoryVm>{categoryvm};
		mockRepository.setup('getContexts').returns(contexts);
		mockVmBuilder.setup('buildCategoryVms', new List<Object>{context.categories, contextId, recordType}).returns(categoryvms);
		mockVmBuilder.setup('buildCategoryOptions', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SelectOption>());

		BarcodeGenerator.FormVm result = sut.getFormVm(contextId);

		mockVmBuilder.setup('buildCategoryOptions', new List<Object>{categoryvms}).returns(new List<SelectOption>());
	}

	@IsTest
    static void it_should_convert_the_vm_to_sm() {
		BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
		vm.batchTitle = 'test1';
		mockRepository.setup('createBatch', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new DmBgBatch());

		String result = sut.generateClicked(vm);

		mockVmBuilder.verify('convertToFormSm', new List<Object>{vm}, Times.Once);
	}

	@IsTest
    static void it_should_create_a_batch_from_the_returned_sm() {
		BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
		vm.batchTitle = 'test1';
		BarcodeGenerator.FormSm sm = new BarcodeGenerator.FormSm();
		sm.batchTitle = 'test11';
		mockVmBuilder.setup('convertToFormSm', new List<Object>{vm}).returns(sm);
		mockRepository.setup('createBatch', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new DmBgBatch());

		String result = sut.generateClicked(vm);

		mockRepository.verify('createBatch', new List<Object>{sm}, Times.Once);
	}

	@IsTest
    static void it_should_return_a_url_from_report_url_provider_using_configs_and_returned_batch() {
		BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
		vm.batchTitle = 'test1';
		BarcodeGenerator.FormSm sm = new BarcodeGenerator.FormSm();
		sm.batchTitle = 'test11';
		DmBgBatch batch = new DmBgBatch();
		batch.batchId = '123234';
		String reportId = 'abc-123';
		String reportUrl = 'the-report-url';
		mockVmBuilder.setup('convertToFormSm', new List<Object>{vm}).returns(sm);		
		mockRepository.setup('createBatch', new List<Object>{sm}).returns(batch);
		mockConfigs.setup('get', new List<Object>{'BarcodeGeneratorReportId'}).returns(reportId);
		mockReportUrlProvider.setup('getReportUrl', new List<Object>{reportId, new List<String>{batch.batchId}}).returns(reportUrl);

		String result = sut.generateClicked(vm);

		System.assertEquals(reportUrl, result);
	}

	@IsTest
    static void it_should_add_five_rows_to_the_provided_vm() {
		BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
		vm.rows = new List<BarcodeGenerator.RowVm>();
		Integer addRowCount = 5;
		BarcodeGenerator.RowVm row = new BarcodeGenerator.RowVm();

		List<BarcodeGenerator.RowVm> addedRows = new List<BarcodeGenerator.RowVm>{row,row,row,row,row};
		mockVmBuilder.setup('addRows', new List<Object>{vm.rows, addRowCount}).Returns(addedRows);

		BarcodeGenerator.FormVm result = sut.addRowsClicked(vm);

		System.assertEquals(5, result.rows.size());
	}

	@IsTest
    static void it_should_set_the_selected_category_in_vm_when_selected_index_is_provided() {
		BarcodeGenerator.RowVm selectedRow = new BarcodeGenerator.RowVm();
		selectedRow.rowIndex = 0;
		selectedRow.selectedCategoryValue = 'test';
		BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
		vm.rows = new List<BarcodeGenerator.RowVm>{selectedRow};
		Integer selectedRowIndex = 0;
		BarcodeGenerator.CategoryVm categoryVm = new BarcodeGenerator.CategoryVm();
		categoryVm.name = 'test';
		vm.categories = new List<BarcodeGenerator.CategoryVm>{categoryVm};

		BarcodeGenerator.FormVm result = sut.categorySelected(vm, selectedRowIndex);

		System.assertEquals(categoryVm , vm.rows[0].selectedCategory);
	}
}