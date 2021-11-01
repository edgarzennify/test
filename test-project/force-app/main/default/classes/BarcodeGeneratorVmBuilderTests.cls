@IsTest
private class BarcodeGeneratorVmBuilderTests {
	
	private final static BarcodeGeneratorVmBuilder sut;
	private final static Mock.ofIUserInfoService mockUserInfo;
	private final static Mock.ofIDataProvider mockDataProvider;

	static{
		mockUserInfo = new Mock.ofIUserInfoService();
		mockDataProvider = new Mock.ofIDataProvider();
		sut = new BarcodeGeneratorVmBuilder(mockUserInfo, mockDataProvider);
	}

	@IsTest
    static void it_should_call_the_user_info_service_when_building_category_vms() {
		String prm =  'test permission';
		Id contextId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		DmBgDocType docType = new DmBgDocType();
		docType.name = 'doc name';
		List<DmBgDocType> docTypes = new List<DmBgDocType>{docType};
		DmBgQuery query1 = new DmBgQuery();
		query1.queryTemplate = '{!contextId}1';
		DmBgQuery query2 = new DmBgQuery();
		query2.queryTemplate = '{!contextId}2';
		DmBgCategory category1 = new DmBgCategory();
		category1.name = 'category1';
		category1.queries = new List<DmBgQuery>{query1};
		category1.permissionSet = prm;
		category1.docTypes = docTypes;
		DmBgCategory category2 = new DmBgCategory();
		category2.name = 'category2';
		category2.permissionSet = prm;
		category2.queries = new List<DmBgQuery>{query2};
		category2.docTypes = docTypes;
		List<DmBgCategory> categories = new List<DmBgCategory>{category1, category2};
		mockUserInfo.setup('hasPermissionSet', new List<Object>{prm}).returns(true);
		List<DataProvider.DynamicQueryResult> dynamicResults = new List<DataProvider.DynamicQueryResult>();
		mockDataProvider.setup('executeDynamicQuery', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dynamicResults);

		sut.buildCategoryVms(categories ,contextId);

		mockUserInfo.verify('hasPermissionSet', new List<Object>{prm}, Times.Twice);
	}

	@IsTest
    static void it_should_call_the_data_provider_when_building_category_vms_and_verify_the_parameters_passed_in_it() {
		String prm =  'test permission';
		Id contextId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		DmBgDocType docType = new DmBgDocType();
		docType.name = 'doc name';
		List<DmBgDocType> docTypes = new List<DmBgDocType>{docType};
		DmBgQuery query1 = new DmBgQuery();
		query1.queryTemplate = '{!contextId}1';
		query1.queryDescription = 'Name';
		query1.queryValue = 'Id';
		DmBgCategory category1 = new DmBgCategory();
		category1.name = 'category1';
		category1.queries = new List<DmBgQuery>{query1};
		category1.permissionSet = prm;
		category1.docTypes = docTypes;
		List<DmBgCategory> categories = new List<DmBgCategory>{category1};	
		mockUserInfo.setup('hasPermissionSet', new List<Object>{prm}).returns(true);
		DataProvider.DynamicQueryResult queryResult = new DataProvider.DynamicQueryResult(); 
		queryResult.sObj = new Account();
		DataProvider.DynamicQueryFieldResult field1 = new DataProvider.DynamicQueryFieldResult();
		field1.fieldName = 'Name';
		field1.fieldValue = 'val1';
		DataProvider.DynamicQueryFieldResult field2 = new DataProvider.DynamicQueryFieldResult();
		field2.fieldName = 'Name';
		field2.fieldValue = 'val2';
		queryResult.fieldValues = new List<DataProvider.DynamicQueryFieldResult>{field1, field2};
		List<DataProvider.DynamicQueryResult> dynamicResults = new List<DataProvider.DynamicQueryResult>{queryResult};
		mockDataProvider.setup('executeDynamicQuery', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dynamicResults);

		List<BarcodeGenerator.CategoryVm> result = sut.buildCategoryVms(categories ,contextId);

		mockDataProvider.verify('executeDynamicQuery', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		List<Object> arguments = mockDataProvider.getArgumentsFromCall('executeDynamicQuery');
		String query = (String)arguments[0];
		System.assertEquals(contextId + '1', query);
		List<String> fields = (List<String>)arguments[1];
		System.assertEquals(2, fields.size());
		System.assertEquals('Name', fields[0]);
		System.assertEquals('Id', fields[1]);
		System.assert(result != null);
	}

	@IsTest
    static void it_should_call_the_data_provider_when_building_category_vms_and_remove_category_that_does_not_have_results_returned_from_query() {
		String prm =  'test permission';
		Id contextId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		DmBgDocType docType = new DmBgDocType();
		docType.name = 'doc name';
		List<DmBgDocType> docTypes = new List<DmBgDocType>{docType};
		DmBgQuery query1 = new DmBgQuery();
		query1.queryTemplate = '{!contextId}1';
		query1.queryDescription = 'Name';
		query1.queryValue = 'Id';
		DmBgQuery query2 = new DmBgQuery();
		query2.queryTemplate = '{!contextId}2';
		query2.queryDescription = 'Name';
		query2.queryValue = 'Id';
		DmBgCategory category1 = new DmBgCategory();
		category1.name = 'category1';
		category1.queries = new List<DmBgQuery>{query1};
		category1.permissionSet = prm;
		category1.docTypes = docTypes;
		DmBgCategory category2 = new DmBgCategory();
		category2.name = 'category2';
		category2.queries = new List<DmBgQuery>{query2};
		category2.permissionSet = prm;
		category2.docTypes = docTypes;
		List<DmBgCategory> categories = new List<DmBgCategory>{category1, category2};	
		mockUserInfo.setup('hasPermissionSet', new List<Object>{prm}).returns(true);
		DataProvider.DynamicQueryResult queryResult = new DataProvider.DynamicQueryResult();
		queryResult.sObj = new Account();
		DataProvider.DynamicQueryFieldResult field = new DataProvider.DynamicQueryFieldResult();
		field.fieldName = 'Name';
		field.fieldValue = 'val1';
		queryResult.fieldValues = new List<DataProvider.DynamicQueryFieldResult>{field};
		List<DataProvider.DynamicQueryResult> dynamicResults1 = new List<DataProvider.DynamicQueryResult>{queryResult};
		List<DataProvider.DynamicQueryResult> dynamicResults2 = new List<DataProvider.DynamicQueryResult>();
		mockDataProvider.setup('executeDynamicQuery', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dynamicResults2);

		List<BarcodeGenerator.CategoryVm> result = sut.buildCategoryVms(categories ,contextId);

		mockDataProvider.verify('executeDynamicQuery', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Twice);
		List<Object> arguments1 = mockDataProvider.getArgumentsFromCall('executeDynamicQuery', 1);
		String query = (String)arguments1[0];
		List<String> fields = (List<String>)arguments1[1];
		System.assertEquals(contextId + '1', query);
		System.assertEquals('Name', fields[0]);
		System.assertEquals('Id', fields[1]);
		System.assert(result.size() == 0);
	}

	@IsTest
    static void it_should_return_N_A_in_related_objects_when_query_template_is_empty() {
		String prm =  'test permission';
		Id contextId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		DmBgDocType docType = new DmBgDocType();
		docType.name = 'doc name';
		List<DmBgDocType> docTypes = new List<DmBgDocType>{docType};
		DmBgQuery query1 = new DmBgQuery();
		query1.queryTemplate = '';
		query1.queryDescription = 'Name';
		query1.queryValue = 'Id';
		DmBgCategory category1 = new DmBgCategory();
		category1.name = 'category1';
		category1.queries = new List<DmBgQuery>{query1};
		category1.permissionSet = prm;
		category1.docTypes = docTypes;
		List<DmBgCategory> categories = new List<DmBgCategory>{category1};	
		mockUserInfo.setup('hasPermissionSet', new List<Object>{prm}).returns(true);
		DataProvider.DynamicQueryResult queryResult = new DataProvider.DynamicQueryResult();
		queryResult.sObj = new Account();
		DataProvider.DynamicQueryFieldResult field1 = new DataProvider.DynamicQueryFieldResult();
		field1.fieldName = 'Name';
		field1.fieldValue = 'val1';
		DataProvider.DynamicQueryFieldResult field2 = new DataProvider.DynamicQueryFieldResult();
		field2.fieldName = 'Name';
		field2.fieldValue = 'val2';
		queryResult.fieldValues = new List<DataProvider.DynamicQueryFieldResult>{field1, field2};
		List<DataProvider.DynamicQueryResult> dynamicResults = new List<DataProvider.DynamicQueryResult>{queryResult};
		mockDataProvider.setup('executeDynamicQuery', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dynamicResults);

		List<BarcodeGenerator.CategoryVm> result = sut.buildCategoryVms(categories ,contextId);

	    System.assertEquals(1, result[0].relatedObjects.size());
	    System.assertEquals('N/A', result[0].relatedObjects[0].getLabel());
	} 

	@IsTest
    static void it_should_build_category_options_when_vm_is_provided() {
		BarcodeGenerator.CategoryVm vm = new BarcodeGenerator.CategoryVm();
		vm.name = 'category-vm';
		List<BarcodeGenerator.CategoryVm> vms = new List<BarcodeGenerator.CategoryVm>{vm};

		List<SelectOption> result = sut.buildCategoryOptions( vms );

		System.assertEquals(2, result.size());
		System.assertEquals('--None--', result[0].getLabel());
		System.assertEquals('', result[0].getValue());
		System.assertEquals('category-vm', result[1].getLabel());
		System.assertEquals('category-vm', result[1].getValue());
	}

	@IsTest
    static void it_should_build_a_row() {
		Integer count = 2;

		List<BarcodeGenerator.RowVm> result = sut.buildRows( count );

		System.assertEquals(2, result.size());
	}

	@IsTest
    static void it_should_add_a_row_to_vm_when_count_is_provided() {
		Integer count = 2;
		BarcodeGenerator.RowVm vm = new BarcodeGenerator.RowVm();
		List<BarcodeGenerator.RowVm> vms = new List<BarcodeGenerator.RowVm>{vm};

		List<BarcodeGenerator.RowVm> result = sut.addRows( vms, count );

		System.assertEquals(3,result.size());
	}

	@IsTest
    static void it_should_build_a_form_sm_when_form_vm_is_provided() {
		BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
		vm.batchTitle = 'title';
		vm.contextId = 'akdz13';
		BarcodeGenerator.RowVm row = new BarcodeGenerator.RowVm();
		row.rowIndex = 1;
		vm.rows = new List<BarcodeGenerator.RowVm>{row};

		BarcodeGenerator.FormSm  result = sut.convertToFormSm(vm);

		System.assertEquals('title',result.batchTitle);
		System.assertEquals('akdz13', result.contextId);
		System.assertEquals(1, result.rows.size());
		System.assertEquals(1, result.rows[0].rowIndex);
	}
}