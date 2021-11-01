@IsTest
private class EbtDocManagerPluginLoanTests {
    
    private final static EbtDocManagerPluginLoan sut;
    private final static EbtDocManagerMock.ofIDataProvider mockDataProvider;
    
    static{
        mockDataProvider = new EbtDocManagerMock.ofIDataProvider();        
        sut = new EbtDocManagerPluginLoan(mockDataProvider);
    }
    
    @IsTest
    static void it_should_return_the_ncino_loan_type() {
        SObjectType result = sut.getSObjectTypeHandled();
		
        System.assertEquals(LLC_BI__Loan__c.SObjectType, result);
    }

    @IsTest
    static void it_should_return_the_document_manager_name() {
        String result = sut.getDocumentManagerName();
        
        System.assertEquals('LLC_Loan', result);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_get_the_loan_and_return_correct_lookup_when_the_lookup_key_is_empty() {
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = objectId;
        loan.LLC_BI__lookupKey__c = null;
        mockDataProvider.setup('getLoan', new List<Object>{objectId}).returns(loan);
        
        EbtDocManager.ExternalDocumentLookup result = sut.getExternalDocumentLookup(objectId);
        
        mockDataProvider.verify('getLoan', new List<Object>{objectId}, Times.Once);
        System.assertEquals(1, result.keys.size());
        System.assertEquals(objectId, result.keys[0]);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_get_the_loan_and_return_correct_lookup_when_the_lookup_key_is_not_empty() {
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = objectId;
        loan.LLC_BI__lookupKey__c = '123abc';
        mockDataProvider.setup('getLoan', new List<Object>{objectId}).returns(loan);
        
        EbtDocManager.ExternalDocumentLookup result = sut.getExternalDocumentLookup(objectId);
        
        mockDataProvider.verify('getLoan', new List<Object>{objectId}, Times.Once);
        System.assertEquals(2, result.keys.size());
        System.assertEquals(objectId, result.keys[0]);
        System.assertEquals('123abc', result.keys[1]);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_get_list_of_document_ids() {
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        
        sut.getDocumentManagerStoreIndexes(objectId);
        
        mockDataProvider.verify('getDocumentManagerLoanDocuments', new List<Object>{objectId}, Times.Once);
    }
    
    @IsTest
    static void it_should_return_the_store_indexes_returned_by_the_data_provider() {
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<LLC_BI__Document_Store_Index__c> storeIndexes = new List<LLC_BI__Document_Store_Index__c>();
        storeIndexes.add(new LLC_BI__Document_Store_Index__c());
        mockDataProvider.setup('getDocumentManagerLoanDocuments', new List<Object>{objectId}).returns(storeIndexes);
        
        List<LLC_BI__Document_Store_Index__c> result = sut.getDocumentManagerStoreIndexes(objectId);
        
    	System.assertEquals(storeIndexes, result);
    }
       
    @IsTest
    static void it_should_build_the_correct_document_manager_document() {
        ImagingServiceProxy.DocumentMetadata externalDoc = new ImagingServiceProxy.DocumentMetadata();
        externalDoc.extension = 'tst';
        externalDoc.docTypeName = 'Test Document';
        externalDoc.isStaged = false;
        externalDoc.documentDate = '2016-03-09';
        externalDoc.comments = 'test-comments';
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id docManId = ObjectFactory.getFakeId(LLC_BI__DocManager__c.SObjectType, '1');
        EbtDocManager.InternalDocumentBuildRequest request = new EbtDocManager.InternalDocumentBuildRequest();
        request.objectId = objectId;
        request.externalDoc = externalDoc;
        request.documentManagerId = docManId;
        
        SObject result = sut.buildDocumentManagerDocument(request);
        
        LLC_BI__LLC_LoanDocument__c doc = (LLC_BI__LLC_LoanDocument__c)result;
        System.assertEquals(externalDoc.extension, doc.LLC_BI__mimeType__c);
        System.assertEquals(objectId, doc.LLC_BI__Loan__c);
        System.assertEquals('In-File', doc.LLC_BI__reviewStatus__c);
        System.assertEquals(externalDoc.docTypeName, doc.Name);
        System.assertEquals(null, doc.LLC_BI__fileSize__c);
        System.assertEquals(externalDoc.docTypeName, doc.NDOC__fileName__c);        
        System.assertEquals(docManId, doc.LLC_BI__docManager__c);
        System.assertEquals(externalDoc.documentDate, String.valueOf(doc.LLC_BI__date__c));
        System.assertEquals(externalDoc.comments, doc.LLC_BI__comments__c);
    }

    @IsTest
    static void it_should_update_the_given_document_with_the_given_doc_class() {
        LLC_BI__LLC_LoanDocument__c document = new LLC_BI__LLC_LoanDocument__c();
        Id docClassId = ObjectFactory.getFakeId(LLC_BI__DocClass__c.SObjectType, '1');
        Id docTypeId = ObjectFactory.getFakeId(LLC_BI__DocType__c.SObjectType, '1');
        Id docTabId = ObjectFactory.getFakeId(LLC_BI__DocTab__c.SObjectType, '1');
        LLC_BI__DocTab__c docTab = new LLC_BI__DocTab__c(Id = docTabId);
        LLC_BI__DocType__c docType = new LLC_BI__DocType__c(Id = docTypeId);
        docType.LLC_BI__docTab__c = docTab.Id;
        LLC_BI__DocClass__c docClass = new LLC_BI__DocClass__c(Id = docClassId, LLC_BI__DocType__c = docType.Id);
        docClass.LLC_BI__DocType__r = docType;    
        
        sut.updateDocumentManagerDocument(document, docClass);
        
        System.assertEquals(docClassId, document.LLC_BI__docClass__c);
        System.assertEquals(docTypeId, document.LLC_BI__docType__c);
        System.assertEquals(docTabId, document.LLC_BI__docTab__c);
    }
    
    @IsTest
    static void it_should_update_the_given_document_with_the_given_index_id() {
        LLC_BI__LLC_LoanDocument__c document = new LLC_BI__LLC_LoanDocument__c();
        Id indexId = ObjectFactory.getFakeId(LLC_BI__Document_Store_Index__c.SObjectType, '1');
        LLC_BI__Document_Store_Index__c storeIndex = new LLC_BI__Document_Store_Index__c(Id = indexId);        
        
        sut.updateDocumentManagerDocument(document, storeIndex);
        
        System.assertEquals(indexId, document.LLC_BI__Document_Store_Index__c);
    }
}