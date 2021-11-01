@IsTest
private class BarcodeGeneratorDmBuilderTests {
    
    private final static BarcodeGeneratorDmBuilder sut;

    static{
        sut = new BarcodeGeneratorDmBuilder();
    }

    private static testMethod void it_should_build_at_batch_when_batch_id_is_given() {
    	Id batchId = ObjectFactory.getFakeId(BarcodeGeneratorBatch__c.SObjectType, '1');

    	DmBgBatch result = sut.buildBatch(batchId);

    	System.assertEquals(batchId, result.batchId);
    }

    private static testMethod void it_should_build_a_context_dm_with_object_name() {
    	Id contextId = ObjectFactory.getFakeId(BarcodeGeneratorCfgContext__c.SObjectType, '1');
    	String objectName = 'obj name';
    	BarcodeGeneratorCfgContext__c context = new BarcodeGeneratorCfgContext__c();
    	context.ObjectName__c = objectName;
    	BarcodeGeneratorCfgJunction__c contextJx = new BarcodeGeneratorCfgJunction__c();
    	contextJx.Context__r = context;
    	List<BarcodeGeneratorCfgJunction__c> contextJxs = new List<BarcodeGeneratorCfgJunction__c>{contextJx};
    	Map<Id, List<BarcodeGeneratorCfgDocType__c>> doctypes = new Map<Id, List<BarcodeGeneratorCfgDocType__c>>();

    	DmBgContext result = sut.buildDmContext(contextId, contextJxs, doctypes);

    	System.assertEquals(objectName ,result.objectName);
    }

    private static testMethod void it_should_build_a_context_dm_with_recordtype() {
    	Id contextId =  ObjectFactory.getFakeId(BarcodeGeneratorCfgContext__c.SObjectType, '1');
    	String objectName = 'Account';
    	BarcodeGeneratorCfgContext__c context = new BarcodeGeneratorCfgContext__c();
    	context.ObjectName__c = objectName;
    	BarcodeGeneratorCfgJunction__c contextJx = new BarcodeGeneratorCfgJunction__c();
    	contextJx.Context__r = context;
    	List<BarcodeGeneratorCfgJunction__c> contextJxs = new List<BarcodeGeneratorCfgJunction__c>{contextJx}; 
    	Map<Id, List<BarcodeGeneratorCfgDocType__c>> docTypes = new Map<Id, List<BarcodeGeneratorCfgDocType__c>>();

    	DmBgContext result = sut.buildDmContext(contextId, contextJxs, doctypes);

    	System.assertEquals(objectName ,result.ObjectName);
    }

    private static testMethod void it_should_build_a_context_dm_with_one_category() {
    	String permission = 'Function - barcode';
    	Id contextId =  ObjectFactory.getFakeId(BarcodeGeneratorCfgContext__c.SObjectType, '1');
    	Id categoryId = ObjectFactory.getFakeId(BarcodeGeneratorCfgCategory__c.SObjectType, '1');
    	BarcodeGeneratorCfgContext__c context = new BarcodeGeneratorCfgContext__c();
    	context.Id = contextId;
    	BarcodeGeneratorCfgCategory__c category = new BarcodeGeneratorCfgCategory__c();
    	category.Id = categoryId;
    	category.Name = 'category name';
    	category.Required_Perrmission_Set_Name__c = permission;
    	BarcodeGeneratorCfgJunction__c contextJx = new BarcodeGeneratorCfgJunction__c();
    	contextJx.Context__r = context;
    	contextJx.Category__r = category;
    	List<BarcodeGeneratorCfgJunction__c> contextJxs = new List<BarcodeGeneratorCfgJunction__c>{contextJx};
    	BarcodeGeneratorCfgDocType__c docType = new BarcodeGeneratorCfgDocType__c();
    	docType.Category__r = category;
    	List<BarcodeGeneratorCfgDocType__c> docTypes = new List<BarcodeGeneratorCfgDocType__c>{docType};
    	Map<Id, List<BarcodeGeneratorCfgDocType__c>> doctypesMap = new Map<Id, List<BarcodeGeneratorCfgDocType__c>>{category.Id => docTypes};

    	DmBgContext result = sut.buildDmContext(contextId, contextJxs, doctypesMap);

    	System.assertEquals(1 ,result.categories.size());
    	System.assertEquals(permission ,result.categories[0].permissionSet);	
    	System.assertEquals('category name' ,result.categories[0].name);

    }

    private static testMethod void it_should_build_a_context_dm_with_two_categories() {
    	String permission1 = 'Function - barcode 1';
    	String permission2 = 'Function - barcode 2';
    	Id contextId =  ObjectFactory.getFakeId(BarcodeGeneratorCfgContext__c.SObjectType, '1');
    	Id categoryId1 = ObjectFactory.getFakeId(BarcodeGeneratorCfgCategory__c.SObjectType, '1');
    	Id categoryId2 = ObjectFactory.getFakeId(BarcodeGeneratorCfgCategory__c.SObjectType, '2');
    	BarcodeGeneratorCfgContext__c context = new BarcodeGeneratorCfgContext__c();
    	context.Id = contextId;
    	BarcodeGeneratorCfgCategory__c category1 = new BarcodeGeneratorCfgCategory__c();
    	category1.Id = categoryId1;
    	category1.Name = 'category name 1';
    	category1.Required_Perrmission_Set_Name__c = permission1;
    	BarcodeGeneratorCfgCategory__c category2 = new BarcodeGeneratorCfgCategory__c();
    	category2.Id = categoryId2;
    	category2.Name = 'category name 2';
    	category2.Required_Perrmission_Set_Name__c = permission2;
    	BarcodeGeneratorCfgJunction__c contextJx1 = new BarcodeGeneratorCfgJunction__c();
    	contextJx1.Context__r = context;
    	contextJx1.Category__r = category1;
    	BarcodeGeneratorCfgJunction__c contextJx2 = new BarcodeGeneratorCfgJunction__c();
    	contextJx2.Context__r = context;
    	contextJx2.Category__r = category2;
    	List<BarcodeGeneratorCfgJunction__c> contextJxs = new List<BarcodeGeneratorCfgJunction__c>{contextJx1, contextJx2};
    	BarcodeGeneratorCfgDocType__c docType = new BarcodeGeneratorCfgDocType__c();
    	docType.Category__r = category1;
    	List<BarcodeGeneratorCfgDocType__c> docTypes = new List<BarcodeGeneratorCfgDocType__c>{docType};
    	Map<Id, List<BarcodeGeneratorCfgDocType__c>> doctypesMap = new Map<Id, List<BarcodeGeneratorCfgDocType__c>>{category1.Id => docTypes};

    	DmBgContext result = sut.buildDmContext(contextId, contextJxs, doctypesMap);

    	System.assertEquals(2 ,result.categories.size());
    	System.assertEquals(permission1 ,result.categories[0].permissionSet);	
    	System.assertEquals('category name 1' ,result.categories[0].name);
    	System.assertEquals(permission2 ,result.categories[1].permissionSet);	
    	System.assertEquals('category name 2' ,result.categories[1].name);

    }

    private static testMethod void it_should_build_a_context_dm_with_one_doctype() {
    	Id contextId =  ObjectFactory.getFakeId(BarcodeGeneratorCfgContext__c.SObjectType, '1');
    	Id categoryId = ObjectFactory.getFakeId(BarcodeGeneratorCfgCategory__c.SObjectType, '1');
    	BarcodeGeneratorCfgContext__c context = new BarcodeGeneratorCfgContext__c();
    	context.Id = contextId;
    	BarcodeGeneratorCfgCategory__c category = new BarcodeGeneratorCfgCategory__c();
    	category.Id = categoryId;
    	BarcodeGeneratorCfgJunction__c contextJx = new BarcodeGeneratorCfgJunction__c();
    	contextJx.Context__r = context;
    	contextJx.Category__r = category;
    	List<BarcodeGeneratorCfgJunction__c> contextJxs = new List<BarcodeGeneratorCfgJunction__c>{contextJx};
    	BarcodeGeneratorCfgDocType__c docType = new BarcodeGeneratorCfgDocType__c();
    	docType.Name = 'doctype name';
    	docType.Category__r = category;
    	List<BarcodeGeneratorCfgDocType__c> docTypes = new List<BarcodeGeneratorCfgDocType__c>{docType};
    	Map<Id, List<BarcodeGeneratorCfgDocType__c>> doctypesMap = new Map<Id, List<BarcodeGeneratorCfgDocType__c>>{category.Id => docTypes};

    	DmBgContext result = sut.buildDmContext(contextId, contextJxs, doctypesMap);

    	System.assertEquals(1 ,result.categories[0].doctypes.size());
    	System.assertEquals('doctype name', result.categories[0].doctypes[0].name);
    }

    private static testMethod void it_should_build_a_context_dm_with_two_doctypes() {
    	Id contextId =  ObjectFactory.getFakeId(BarcodeGeneratorCfgContext__c.SObjectType, '1');
    	Id categoryId = ObjectFactory.getFakeId(BarcodeGeneratorCfgCategory__c.SObjectType, '1');
    	BarcodeGeneratorCfgContext__c context = new BarcodeGeneratorCfgContext__c();
    	context.Id = contextId;
    	BarcodeGeneratorCfgCategory__c category = new BarcodeGeneratorCfgCategory__c();
    	category.Id = categoryId;
    	BarcodeGeneratorCfgJunction__c contextJx = new BarcodeGeneratorCfgJunction__c();
    	contextJx.Context__r = context;
    	contextJx.Category__r = category;
    	List<BarcodeGeneratorCfgJunction__c> contextJxs = new List<BarcodeGeneratorCfgJunction__c>{contextJx};
    	BarcodeGeneratorCfgDocType__c docType1 = new BarcodeGeneratorCfgDocType__c();
    	docType1.Name = 'doctype name 1';
    	docType1.Category__r = category;
    	BarcodeGeneratorCfgDocType__c docType2 = new BarcodeGeneratorCfgDocType__c();
    	docType2.Name = 'doctype name 2';
    	docType2.Category__r = category;
    	List<BarcodeGeneratorCfgDocType__c> docTypes = new List<BarcodeGeneratorCfgDocType__c>{docType1, docType2};
    	Map<Id, List<BarcodeGeneratorCfgDocType__c>> doctypesMap = new Map<Id, List<BarcodeGeneratorCfgDocType__c>>{category.Id => docTypes};

    	DmBgContext result = sut.buildDmContext(contextId, contextJxs, doctypesMap);

    	System.assertEquals(2 ,result.categories[0].doctypes.size());
    	System.assertEquals('doctype name 1', result.categories[0].doctypes[0].name);
    	System.assertEquals('doctype name 2', result.categories[0].doctypes[1].name);
    }

    private static testMethod void it_should_build_a_context_dm_with_queries() {
    	String permission1 = 'Function - barcode 1';
    	String permission2 = 'Function - barcode 2';
    	Id contextId =  ObjectFactory.getFakeId(BarcodeGeneratorCfgContext__c.SObjectType, '1');
    	Id categoryId1 = ObjectFactory.getFakeId(BarcodeGeneratorCfgCategory__c.SObjectType, '1');
    	Id categoryId2 = ObjectFactory.getFakeId(BarcodeGeneratorCfgCategory__c.SObjectType, '2');
    	BarcodeGeneratorCfgContext__c context = new BarcodeGeneratorCfgContext__c();
    	context.Id = contextId;
    	BarcodeGeneratorCfgCategory__c category1 = new BarcodeGeneratorCfgCategory__c();
    	category1.Id = categoryId1;
    	category1.Name = 'category name 1';
    	category1.Required_Perrmission_Set_Name__c = permission1;
    	BarcodeGeneratorCfgCategory__c category2 = new BarcodeGeneratorCfgCategory__c();
    	category2.Id = categoryId2;
    	category2.Name = 'category name 2';
    	category2.Required_Perrmission_Set_Name__c = permission2;
    	BarcodeGeneratorCfgJunction__c contextJx1 = new BarcodeGeneratorCfgJunction__c();
    	contextJx1.Context__r = context;
    	contextJx1.Category__r = category1;
    	contextJx1.Query_Template__c = ' SELECT 1';
    	contextJx1.Query_Description_Field__c = 'Name1';
    	contextJx1.Query_Value_Field__c = 'Id1';
    	BarcodeGeneratorCfgJunction__c contextJx2 = new BarcodeGeneratorCfgJunction__c();
    	contextJx2.Context__r = context;
    	contextJx2.Category__r = category2;
    	contextJx2.Query_Template__c = ' SELECT 2';
    	contextJx2.Query_Description_Field__c = 'Name2';
    	contextJx2.Query_Value_Field__c = 'Id2';
    	BarcodeGeneratorCfgJunction__c contextJx3 = new BarcodeGeneratorCfgJunction__c();
    	contextJx3.Context__r = context;
    	contextJx3.Category__r = category2;
    	contextJx3.Query_Template__c = ' SELECT 3';
    	contextJx3.Query_Description_Field__c = 'Name3';
    	contextJx3.Query_Value_Field__c = 'Id3';
    	List<BarcodeGeneratorCfgJunction__c> contextJxs = new List<BarcodeGeneratorCfgJunction__c>{contextJx1, contextJx2, contextJx3};
    	BarcodeGeneratorCfgDocType__c docType1 = new BarcodeGeneratorCfgDocType__c();
    	docType1.Category__r = category1;
    	BarcodeGeneratorCfgDocType__c docType2 = new BarcodeGeneratorCfgDocType__c();
    	docType2.Category__r = category2;
    	List<BarcodeGeneratorCfgDocType__c> docTypes1 = new List<BarcodeGeneratorCfgDocType__c>{docType1};
    	List<BarcodeGeneratorCfgDocType__c> docTypes2 = new List<BarcodeGeneratorCfgDocType__c>{docType2};
    	Map<Id, List<BarcodeGeneratorCfgDocType__c>> doctypesMap = new Map<Id, List<BarcodeGeneratorCfgDocType__c>>{category1.Id => docTypes1, category2.Id => docTypes2};

    	DmBgContext result = sut.buildDmContext(contextId, contextJxs, doctypesMap);

    	System.assertEquals(2 ,result.categories.size());
    	System.assertEquals(1 ,result.categories[0].queries.size());
    	System.assertEquals(2 ,result.categories[1].queries.size());	
    	System.assertEquals(' SELECT 1' ,result.categories[0].queries[0].queryTemplate);
    	System.assertEquals('Name1' ,result.categories[0].queries[0].queryDescription);
    	System.assertEquals('Id1' ,result.categories[0].queries[0].queryValue);
    	System.assertEquals(' SELECT 2' ,result.categories[1].queries[0].queryTemplate);
    	System.assertEquals('Name2' ,result.categories[1].queries[0].queryDescription);
    	System.assertEquals('Id2' ,result.categories[1].queries[0].queryValue);
    	System.assertEquals(' SELECT 3' ,result.categories[1].queries[1].queryTemplate);
    	System.assertEquals('Name3' ,result.categories[1].queries[1].queryDescription);
    	System.assertEquals('Id3' ,result.categories[1].queries[1].queryValue);
    }
}