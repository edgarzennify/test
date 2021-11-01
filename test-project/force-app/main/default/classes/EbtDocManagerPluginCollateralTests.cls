@IsTest
private class EbtDocManagerPluginCollateralTests {
    private final static EbtDocManagerPluginCollateral sut;
    private final static EbtDocManagerMock.ofIDataProvider mockDataProvider;
    
    static {
        mockDataProvider = new EbtDocManagerMock.ofIDataProvider();        
        sut = new EbtDocManagerPluginCollateral(mockDataProvider);
    }
    
    @IsTest
    static void it_should_return_the_collateral_type() {
        SObjectType result = sut.getSObjectTypeHandled();
		
        System.assertEquals(LLC_BI__Collateral__c.SObjectType, result);
    }

    @IsTest
    static void it_should_return_the_document_manager_name() {
        String result = sut.getDocumentManagerName();
        
        System.assertEquals('Collateral', result);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_the_entity_and_return_correct_lookup_when_the_lookup_key_is_empty() {
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        collateral.Id = objectId;
        collateral.Sync_Key__c = null;
        mockDataProvider.setup('getCollateral', new List<Object>{objectId}).returns(collateral);
        
        EbtDocManager.ExternalDocumentLookup result = sut.getExternalDocumentLookup(objectId);
        
        mockDataProvider.verify('getCollateral', new List<Object>{objectId}, Times.Once);
        System.assertEquals(1, result.keys.size());
        System.assertEquals(objectId, result.keys[0]);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_get_the_entity_and_return_correct_lookup_when_the_lookup_key_is_not_empty() {
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        String lookupKey = '616-20-12345';
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        collateral.Id = objectId;
        collateral.Sync_key__c = lookupkey;
        mockDataProvider.setup('getCollateral', new List<Object>{objectId}).returns(collateral);
        
        EbtDocManager.ExternalDocumentLookup result = sut.getExternalDocumentLookup(objectId);
        
        mockDataProvider.verify('getCollateral', new List<Object>{objectId}, Times.Once);
        System.assertEquals(2, result.keys.size());
        System.assertEquals(objectId, result.keys[0]);
        System.assertEquals(lookupKey, result.keys[1]);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_get_list_of_document_ids() {
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        
        sut.getDocumentManagerStoreIndexes(objectId);
        
        mockDataProvider.verify('getDocumentManagerCollateralDocuments', new List<Object>{objectId}, Times.Once);
    }
    
    @IsTest
    static void it_should_return_the_store_indexes_returned_by_the_data_provider() {
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        List<LLC_BI__Document_Store_Index__c> storeIndexes = new List<LLC_BI__Document_Store_Index__c>();
        storeIndexes.add(new LLC_BI__Document_Store_Index__c());
        mockDataProvider.setup('getDocumentManagerCollateralDocuments', new List<Object>{objectId}).returns(storeIndexes);
        
        List<LLC_BI__Document_Store_Index__c> result = sut.getDocumentManagerStoreIndexes(objectId);
        
    	System.assertEquals(storeIndexes, result);
    }
    
    @IsTest
    static void it_should_build_the_correct_document_manager_document_when_is_staged_is_true() {
        ImagingServiceProxy.DocumentMetadata externalDoc = new ImagingServiceProxy.DocumentMetadata();
        externalDoc.extension = 'tst';
        externalDoc.docTypeName = 'Test Document';
        externalDoc.isStaged = true;
        externalDoc.documentDate = '2016-03-09';
        externalDoc.comments = 'test-comments';
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        Id docManId = ObjectFactory.getFakeId(LLC_BI__DocManager__c.SObjectType, '1');
        EbtDocManager.InternalDocumentBuildRequest request = new EbtDocManager.InternalDocumentBuildRequest();
        request.objectId = objectId;
        request.externalDoc = externalDoc;
        request.documentManagerId = docManId;
        
        SObject result = sut.buildDocumentManagerDocument(request);
        
        LLC_BI__Document_Placeholder__c doc = (LLC_BI__Document_Placeholder__c)result;
        System.assertEquals(externalDoc.extension, doc.NDOC__Mime_Type__c);
        System.assertEquals(objectId, doc.LLC_BI__External_Id__c);
        System.assertEquals('In-File', doc.LLC_BI__Review_Status__c);
        System.assertEquals(externalDoc.docTypeName, doc.Name);
        System.assertEquals(null, doc.NDOC__File_Size__c);
        System.assertEquals(externalDoc.docTypeName, doc.NDOC__File_Name__c);
        System.assertEquals(docManId, doc.LLC_BI__docManager__c);
        System.assertEquals(externalDoc.documentDate, String.valueOf(doc.LLC_BI__Date__c));
        System.assertEquals(externalDoc.comments, doc.NDOC__Comments__c);
    }

    @IsTest
    static void it_should_update_the_given_document_with_the_given_doc_class() {
        LLC_BI__Document_Placeholder__c document = new LLC_BI__Document_Placeholder__c();
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
        LLC_BI__Document_Placeholder__c document = new LLC_BI__Document_Placeholder__c();
        Id indexId = ObjectFactory.getFakeId(LLC_BI__Document_Store_Index__c.SObjectType, '1');
        LLC_BI__Document_Store_Index__c storeIndex = new LLC_BI__Document_Store_Index__c(Id = indexId);        
        
        sut.updateDocumentManagerDocument(document, storeIndex);
        
        System.assertEquals(indexId, document.LLC_BI__Document_Store_Index__c);
    }
}