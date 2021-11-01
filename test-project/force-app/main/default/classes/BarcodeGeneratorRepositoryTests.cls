@IsTest
private class BarcodeGeneratorRepositoryTests {
	
	private final static BarcodeGeneratorRepository sut;
	private final static BarcodeGeneratorMock.ofIDataProvider mockDataProvider;
	private final static BarcodeGeneratorMock.ofIPmBuilder mockPmBuilder;
	private final static BarcodeGeneratorMock.ofIDmBuilder mockDmBuilder;

	static {
		mockDataProvider = new BarcodeGeneratorMock.ofIDataProvider();
		mockPmBuilder = new BarcodeGeneratorMock.ofIPmBuilder();
		mockDmBuilder = new BarcodeGeneratorMock.ofIDmBuilder();
		sut = new BarcodeGeneratorRepository(mockDataProvider, mockPmBuilder, mockDmBuilder);
	}

	@IsTest
    static void it_should_call_the_dm_builder_to_build_context() {
		BarcodeGeneratorCfgJunction__c jx = new BarcodeGeneratorCfgJunction__c();
		List<BarcodeGeneratorCfgJunction__c> junctions = new List<BarcodeGeneratorCfgJunction__c>{jx};
		BarcodeGeneratorCfgDocType__c docType = new BarcodeGeneratorCfgDocType__c();
		List<BarcodeGeneratorCfgDocType__c> docTypes = new List<BarcodeGeneratorCfgDocType__c>{docType};
		mockDataProvider.setup('getJunctions').returns(junctions);
		mockDataProvider.setup('getDocTypes').returns(docTypes);

        List<DmBgContext> result =  sut.getContexts();

		mockDmBuilder.verify('buildDmContext', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_call_the_data_provider_to_get_junctions() {
		BarcodeGeneratorCfgJunction__c jx = new BarcodeGeneratorCfgJunction__c();
		List<BarcodeGeneratorCfgJunction__c> junctions = new List<BarcodeGeneratorCfgJunction__c>{jx};
		BarcodeGeneratorCfgDocType__c docType = new BarcodeGeneratorCfgDocType__c();
		List<BarcodeGeneratorCfgDocType__c> docTypes = new List<BarcodeGeneratorCfgDocType__c>{docType};
		DmBgContext context = new DmBgContext();
		mockDataProvider.setup('getJunctions').returns(junctions);
		mockDataProvider.setup('getDocTypes').returns(docTypes);
		mockDmBuilder.setup('buildDmContext', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(context);

        List<DmBgContext> result =  sut.getContexts();

		mockDataProvider.verify('getJunctions', Times.Once);
	}

	@IsTest
    static void it_should_call_the_data_provider_to_get_doctypes() {
		BarcodeGeneratorCfgJunction__c jx = new BarcodeGeneratorCfgJunction__c();
		List<BarcodeGeneratorCfgJunction__c> junctions = new List<BarcodeGeneratorCfgJunction__c>{jx};
		BarcodeGeneratorCfgDocType__c docType = new BarcodeGeneratorCfgDocType__c();
		List<BarcodeGeneratorCfgDocType__c> docTypes = new List<BarcodeGeneratorCfgDocType__c>{docType};
		DmBgContext context = new DmBgContext();
		mockDataProvider.setup('getJunctions').returns(junctions);
		mockDataProvider.setup('getDocTypes').returns(docTypes);
		mockDmBuilder.setup('buildDmContext', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(context);

        List<DmBgContext> result =  sut.getContexts();

		mockDataProvider.verify('getDocTypes', Times.Once);
	}

	@IsTest
    static void it_should_call_the_pmbuilder_to_build_batch() {
		BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
		formSm.contextId = '123';
		BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c();
		BarcodeGenerator.BarcodeConfig config = new BarcodeGenerator.BarcodeConfig();
		mockPmBuilder.setup('buildBatch', new List<Object>{formSm.contextId}).returns(batch);
		mockPmBuilder.setup('buildChildrenAndSiblings', new List<Object>{batch, formSm}).returns(config);
		mockPmBuilder.setup('updateSiblingsWithChildKeys', new List<Object>{config}).returns(config);

		DmBgBatch result = sut.createBatch(formSm);

		mockPmBuilder.verify('buildBatch', new List<Object>{formSm.contextId}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_pmbuilder_to_build_children_and_siblings_object() {
		BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
		formSm.contextId = '123';
		BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c();
		BarcodeGenerator.BarcodeConfig config = new BarcodeGenerator.BarcodeConfig();
		mockPmBuilder.setup('buildBatch', new List<Object>{formSm.contextId}).returns(batch);
		mockPmBuilder.setup('buildChildrenAndSiblings', new List<Object>{batch, formSm}).returns(config);
		mockPmBuilder.setup('updateSiblingsWithChildKeys', new List<Object>{config}).returns(config);

		DmBgBatch result = sut.createBatch(formSm);

		mockPmBuilder.verify('buildChildrenAndSiblings', new List<Object>{batch, formSm}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_pmbuilder_to_update_child_key_on_siblings_object() {
		BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
		formSm.contextId = '123';
		BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c();
		BarcodeGenerator.BarcodeConfig config = new BarcodeGenerator.BarcodeConfig();
		mockPmBuilder.setup('buildBatch', new List<Object>{formSm.contextId}).returns(batch);
		mockPmBuilder.setup('buildChildrenAndSiblings', new List<Object>{batch, formSm}).returns(config);
		mockPmBuilder.setup('updateSiblingsWithChildKeys', new List<Object>{config}).returns(config);

		DmBgBatch result = sut.createBatch(formSm);

		mockPmBuilder.verify('updateSiblingsWithChildKeys', new List<Object>{config}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_dm_builder_to_build_a_batch_from_batch_id() {
		Id batchId = ObjectFactory.getFakeId(BarcodeGeneratorBatch__c.SObjectType, '1');
		BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
		formSm.contextId = '123';
		BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c(Id = batchId);
		BarcodeGenerator.BarcodeConfig config = new BarcodeGenerator.BarcodeConfig();
		mockPmBuilder.setup('buildBatch', new List<Object>{formSm.contextId}).returns(batch);
		mockPmBuilder.setup('buildChildrenAndSiblings', new List<Object>{batch, formSm}).returns(config);
		mockPmBuilder.setup('updateSiblingsWithChildKeys', new List<Object>{config}).returns(config);

		DmBgBatch result = sut.createBatch(formSm);

		mockDmBuilder.verify('buildBatch', new List<Object>{batch.Id}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_data_provider_three_times_to_save_objects() {
		Id batchId = ObjectFactory.getFakeId(BarcodeGeneratorBatch__c.SObjectType, '1');
		BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
		formSm.contextId = '123';
		BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c(Id = batchId);
		BarcodeGenerator.BarcodeConfig config = new BarcodeGenerator.BarcodeConfig();
		mockPmBuilder.setup('buildBatch', new List<Object>{formSm.contextId}).returns(batch);
		mockPmBuilder.setup('buildChildrenAndSiblings', new List<Object>{batch, formSm}).returns(config);
		mockPmBuilder.setup('updateSiblingsWithChildKeys', new List<Object>{config}).returns(config);

		DmBgBatch result = sut.createBatch(formSm);

		mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Thrice);
	}

	@IsTest
    static void it_should_call_the_data_provider_to_save_batch() {
		Id batchId = ObjectFactory.getFakeId(BarcodeGeneratorBatch__c.SObjectType, '1');
		BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
		formSm.contextId = '123';
		BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c(Id = batchId);
		BarcodeGenerator.BarcodeConfig config = new BarcodeGenerator.BarcodeConfig();
		mockPmBuilder.setup('buildBatch', new List<Object>{formSm.contextId}).returns(batch);
		mockPmBuilder.setup('buildChildrenAndSiblings', new List<Object>{batch, formSm}).returns(config);
		mockPmBuilder.setup('updateSiblingsWithChildKeys', new List<Object>{config}).returns(config);

		DmBgBatch result = sut.createBatch(formSm);

		List<Object> arguments = mockDataProvider.getArgumentsFromCall('save', 1);
		List<SObject> objects = (List<SObject>)arguments[0];
		BarcodeGeneratorBatch__c argBatch = (BarcodeGeneratorBatch__c)objects[0];
		System.assertEquals(batch, argBatch);
	}

	@IsTest
    static void it_should_call_the_data_provider_to_save_children() {
		Id batchId = ObjectFactory.getFakeId(BarcodeGeneratorBatch__c.SObjectType, '1');
		BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
		formSm.contextId = '123';
		BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c(Id = batchId);
		BarcodeGenerator.BarcodeConfig config = new BarcodeGenerator.BarcodeConfig();
		mockPmBuilder.setup('buildBatch', new List<Object>{formSm.contextId}).returns(batch);
		mockPmBuilder.setup('buildChildrenAndSiblings', new List<Object>{batch, formSm}).returns(config);
		mockPmBuilder.setup('updateSiblingsWithChildKeys', new List<Object>{config}).returns(config);

		DmBgBatch result = sut.createBatch(formSm);

		List<Object> arguments = mockDataProvider.getArgumentsFromCall('save', 2);
		List<BarcodeGeneratorChildKey__c> objects = (List<BarcodeGeneratorChildKey__c>)arguments[0];
		System.assertEquals(config.children ,objects);
	}

	@IsTest
    static void it_should_call_the_data_provider_to_save_siblings() {
		Id batchId = ObjectFactory.getFakeId(BarcodeGeneratorBatch__c.SObjectType, '1');
		BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
		formSm.contextId = '123';
		BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c(Id = batchId);
		BarcodeGenerator.BarcodeConfig config = new BarcodeGenerator.BarcodeConfig();
		mockPmBuilder.setup('buildBatch', new List<Object>{formSm.contextId}).returns(batch);
		mockPmBuilder.setup('buildChildrenAndSiblings', new List<Object>{batch, formSm}).returns(config);
		mockPmBuilder.setup('updateSiblingsWithChildKeys', new List<Object>{config}).returns(config);

		DmBgBatch result = sut.createBatch(formSm);

		List<Object> arguments = mockDataProvider.getArgumentsFromCall('save', 3);
		List<BarcodeGeneratorSibling__c> objects = (List<BarcodeGeneratorSibling__c>)arguments[0];
		System.assertEquals(config.siblings ,objects);
	}
}