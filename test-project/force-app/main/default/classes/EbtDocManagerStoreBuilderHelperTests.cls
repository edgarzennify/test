@IsTest
private class EbtDocManagerStoreBuilderHelperTests {
    
    private final static EbtDocManagerStoreBuilderHelper sut;
    private final static EbtDocManagerMock.ofIDataProvider mockDataProvider;
    
    static {
        mockDataProvider = new EbtDocManagerMock.ofIDataProvider();
        sut = new EbtDocManagerStoreBuilderHelper(mockDataProvider);
    }

    @IsTest
    static void it_should_create_a_build_request() {
    	ImagingServiceProxy.DocumentMetadata xdoc = new ImagingServiceProxy.DocumentMetadata();
    	String docManName = 'test-doc-man';
    	Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType,'1');
    	Id docManId = ObjectFactory.getFakeId(LLC_BI__DocManager__c.SObjectType, '1');
    	LLC_BI__DocManager__c docMan = new LLC_BI__DocManager__c(Id = docManId, Name = docManName);
    	List<LLC_BI__DocManager__c> docManList = new List<LLC_BI__DocManager__c> { docMan };
    	mockDataProvider.setup('getDocumentManagers').returns(docManList);

    	EbtDocManager.InternalDocumentBuildRequest result = sut.createInternalDocumentBuildRequest(xdoc, docManName, objectId);

    	System.assertEquals(xdoc, result.externalDoc);
    	System.assertEquals(objectId, result.objectId);
    	System.assertEquals(docManId, result.documentManagerId);
    }

    @IsTest
    static void it_should_only_query_the_data_provider_once_on_subsequent_calls_to_create_build_request() {
    	ImagingServiceProxy.DocumentMetadata xdoc = new ImagingServiceProxy.DocumentMetadata();
    	String docManName = 'test-doc-man';
    	Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType,'1');
    	Id docManId = ObjectFactory.getFakeId(LLC_BI__DocManager__c.SObjectType, '1');
    	LLC_BI__DocManager__c docMan = new LLC_BI__DocManager__c(Id = docManId, Name = docManName);
    	List<LLC_BI__DocManager__c> docManList = new List<LLC_BI__DocManager__c> { docMan };
    	mockDataProvider.setup('getDocumentManagers').returns(docManList);

    	EbtDocManager.InternalDocumentBuildRequest result1 = sut.createInternalDocumentBuildRequest(xdoc, docManName, objectId);
    	EbtDocManager.InternalDocumentBuildRequest result2 = sut.createInternalDocumentBuildRequest(xdoc, docManName, objectId);

    	mockDataProvider.verify('getDocumentManagers', Times.Once);
    }

    @IsTest
    static void it_should_get_the_doc_man_class() {
    	String docManName = 'test-doc-man';
    	String docTypeName = 'test-doc-type';
    	Id docManId = ObjectFactory.getFakeId(LLC_BI__DocManager__c.SObjectType, '1');
    	LLC_BI__DocManager__c docMan = new LLC_BI__DocManager__c(Id = docManId, Name = docManName);
    	List<LLC_BI__DocManager__c> docManList = new List<LLC_BI__DocManager__c> { docMan };    	
    	LLC_BI__DocClass__c docClass = new LLC_BI__DocClass__c(Name = docTypeName, LLC_BI__docManager__c = docManId);
    	List<LLC_BI__DocClass__c> docClassList = new List<LLC_BI__DocClass__c>{ docClass };
    	mockDataProvider.setup('getDocumentManagers').returns(docManList);
    	mockDataProvider.setup('getDocumentManagerClasses').returns(docClassList);

    	LLC_BI__DocClass__c result = sut.getDocumentManagerClass(docManName, docTypeName);

    	System.assertEquals(docClass, result);
    }

    @IsTest
    static void it_should_only_query_the_data_provider_once_on_subsequent_calls_to_get_doc_man_class() {
    	String docManName = 'test-doc-man';
    	String docTypeName = 'test-doc-type';
    	Id docManId = ObjectFactory.getFakeId(LLC_BI__DocManager__c.SObjectType, '1');
    	LLC_BI__DocManager__c docMan = new LLC_BI__DocManager__c(Id = docManId, Name = docManName);
    	List<LLC_BI__DocManager__c> docManList = new List<LLC_BI__DocManager__c> { docMan };    	
    	LLC_BI__DocClass__c docClass = new LLC_BI__DocClass__c(Name = docTypeName, LLC_BI__docManager__c = docManId);
    	List<LLC_BI__DocClass__c> docClassList = new List<LLC_BI__DocClass__c>{ docClass };
    	mockDataProvider.setup('getDocumentManagers').returns(docManList);
    	mockDataProvider.setup('getDocumentManagerClasses').returns(docClassList);

    	LLC_BI__DocClass__c result1 = sut.getDocumentManagerClass(docManName, docTypeName);
    	LLC_BI__DocClass__c result2 = sut.getDocumentManagerClass(docManName, docTypeName);

    	mockDataProvider.verify('getDocumentManagers', Times.Once);
    	mockDataProvider.verify('getDocumentManagerClasses', Times.Once);
    }

    @IsTest
    static void it_should_return_null_if_the_doc_man_class_cannot_be_found() {
    	String docManName = 'test-doc-man';
    	String docTypeName = 'test-doc-type';
    	Id docManId = ObjectFactory.getFakeId(LLC_BI__DocManager__c.SObjectType, '1');
    	LLC_BI__DocManager__c docMan = new LLC_BI__DocManager__c(Id = docManId, Name = docManName);
    	List<LLC_BI__DocManager__c> docManList = new List<LLC_BI__DocManager__c> { docMan };    	
    	LLC_BI__DocClass__c docClass = new LLC_BI__DocClass__c(Name = docTypeName, LLC_BI__docManager__c = docManId);
    	List<LLC_BI__DocClass__c> docClassList = new List<LLC_BI__DocClass__c>{ docClass };
    	mockDataProvider.setup('getDocumentManagers').returns(docManList);
    	mockDataProvider.setup('getDocumentManagerClasses').returns(docClassList);

    	LLC_BI__DocClass__c result = sut.getDocumentManagerClass(docManName, 'bogus-doc-type');

    	System.assertEquals(null, result);
    }
}