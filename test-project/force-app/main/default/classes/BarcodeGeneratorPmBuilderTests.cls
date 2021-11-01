@IsTest
private class BarcodeGeneratorPmBuilderTests {
    
    private final static BarcodeGeneratorPmBuilder sut;
    private final static Mock.ofIUtility mockUtility;

    static {
        mockUtility = new Mock.ofIUtility();
        sut = new BarcodeGeneratorPmBuilder(mockUtility);
    }

    @IsTest
    static void it_should_call_the_utility_to_convert_id_to_id18() {
    	String contextId = '123';

    	sut.buildBatch(contextId);

    	mockUtility.verify('convertid15ToId18', new List<Object>{contextId}, Times.Once);
    }

    @IsTest
    static void it_should_create_a_batch_when_contextid_is_provided() {
    	String contextId = '123';
    	String id18 = '12345';
    	String url = '/'+ id18;
        String serverUrl = 'http://www.salesforce.com';
        mockUtility.setup('getServerUrl').returns(serverUrl);
    	mockUtility.setup('convertid15ToId18', new List<Object>{contextId}).returns(id18);

    	BarcodeGeneratorBatch__c result = sut.buildBatch(contextId);

    	System.assertEquals(serverUrl + url, result.Object_URL__c);
    	System.assertEquals('Create Barcode Batch ID', result.Description__c);
    }

    @IsTest
    static void it_should_build_children_objects_when_context_and_form_sm_is_provided() {
    	String identity = '123';
    	String title = 'batch title';

    	Id batchId = ObjectFactory.getFakeId(BarcodeGeneratorBatch__c.SObjectType, '1');
    	BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c();
    	batch.Id = batchId;
    	BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
    	BarcodeGenerator.RowSm row = new BarcodeGenerator.RowSm();
    	row.documentType = 'docType';
    	row.rowIndex = 0;
    	row.Objects = new List<String>{identity};
    	formSm.rows = new List<BarcodeGenerator.RowSm>{row};
    	formSm.batchTitle = title;

    	BarcodeGenerator.BarcodeConfig result =  sut.buildChildrenAndSiblings(batch, formSm);

    	System.assertEquals(1, result.children.size());
    	System.assertEquals(title, result.children[0].BatchTitle__c);
    	System.assertEquals(1, result.children[0].SequenceNumber__c);
    }

    @IsTest
    static void it_should_build_sibling_objects_when_context_and_form_sm_is_provided() {
    	String identity1 = '123';
        String identity2 = '345';
    	String title = 'batch title';
    	Id batchId = ObjectFactory.getFakeId(BarcodeGeneratorBatch__c.SObjectType, '1');
    	BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c();
    	batch.Id = batchId;
    	BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
    	BarcodeGenerator.RowSm row = new BarcodeGenerator.RowSm();
    	row.documentType = 'docType';
    	row.rowIndex = 0;
    	row.Objects = new List<String>{identity1, identity2};
    	formSm.rows = new List<BarcodeGenerator.RowSm>{row};
    	formSm.batchTitle = title;

    	BarcodeGenerator.BarcodeConfig result =  sut.buildChildrenAndSiblings(batch, formSm);

    	System.assertEquals(2, result.siblings.size());
    	System.assertEquals(1, result.siblings[0].ChildKeySequenceNumber__c);
    	System.assertEquals(1, result.siblings[0].SequenceNumber__c);
        System.assertEquals(1, result.siblings[1].ChildKeySequenceNumber__c);
        System.assertEquals(2, result.siblings[1].SequenceNumber__c);
    }

    @IsTest
    static void it_should_update_siblings_when_child_object_is_provided() {
    	Integer sequenceNumber = 1;
    	Id childId = ObjectFactory.getFakeId(BarcodeGeneratorChildKey__c.SObjectType, '1');
    	BarcodeGeneratorChildKey__c child = new BarcodeGeneratorChildKey__c();
    	child.Id = childId;
    	child.SequenceNumber__c = sequenceNumber;
    	BarcodeGeneratorSibling__c sibling = new BarcodeGeneratorSibling__c();
    	sibling.ChildKeySequenceNumber__c = sequenceNumber;
    	List<BarcodeGeneratorChildKey__c> children = new List<BarcodeGeneratorChildKey__c>{child};
    	List<BarcodeGeneratorSibling__c> siblings = new List<BarcodeGeneratorSibling__c>{sibling};
    	BarcodeGenerator.BarcodeConfig config = new BarcodeGenerator.BarcodeConfig();
    	config.children = children;
    	config.siblings = siblings;

    	BarcodeGenerator.BarcodeConfig result = sut.updateSiblingsWithChildKeys(config);

    	System.assertEquals(1, result.siblings.size());
    	System.assertEquals(sequenceNumber, result.siblings[0].ChildKeySequenceNumber__c);
    	System.assertEquals(childId, result.siblings[0].BarcodeGeneratorChildKey__c);
    }
}