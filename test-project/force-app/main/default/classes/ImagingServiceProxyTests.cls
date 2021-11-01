@IsTest
private class ImagingServiceProxyTests {
    
    private static final Mock.ofIRestService mockRestService;
    private static final Mock.ofIJson mockJson;
    private static final Mock.ofIUtility mockUtil;
    private static ImagingServiceProxy sut;

    static {
        mockRestService = new  Mock.ofIRestService();
        mockJson = new  Mock.ofIJson();
        mockUtil = new  Mock.ofIUtility();
        sut = new ImagingServiceProxy(mockRestService ,mockJson ,mockUtil);
    }
    
    @IsTest
    static void it_should_call_the_rest_service_when_storing_document() {
        ImagingServiceProxy.StoreDocumentRequest request = new ImagingServiceProxy.StoreDocumentRequest();
        String jsonResponse = 'test';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        ImagingServiceProxy.DocumentMetadata meta = new ImagingServiceProxy.DocumentMetadata();
        mockJson.setup('serialize', new List<Object>{request}).returns(jsonResponse);
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(meta);
        mockRestService.setup('POST', new List<Object>{'DocumentsUrl', '/documents', jsonResponse }).returns(res);
        
        sut.storeDocument(request);
        
        mockRestService.verify('POST', new List<Object>{'DocumentsUrl', '/documents', jsonResponse }, Times.Once);
    }

    @IsTest
    static void it_should_call_the_json_serializer_when_storing_document() {
        ImagingServiceProxy.StoreDocumentRequest request = new ImagingServiceProxy.StoreDocumentRequest();
        String jsonResponse = 'test';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        res.response = 'test response';
        ImagingServiceProxy.DocumentMetadata meta = new ImagingServiceProxy.DocumentMetadata();
        mockJson.setup('serialize', new List<Object>{request}).returns(jsonResponse);
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(meta);
        mockRestService.setup('POST', new List<Object>{'DocumentsUrl', '/documents', jsonResponse }).returns(res);
        
        sut.storeDocument(request);

        mockJson.verify('serialize', new List<Object>{request}, Times.Once);     
    }

    @IsTest
    static void it_should_call_the_json_deserializer_when_storing_document() {
        ImagingServiceProxy.StoreDocumentRequest request = new ImagingServiceProxy.StoreDocumentRequest();
        request.documentAsBase64 = 'aaa';
        request.documentType = 'a';
        request.drawerName = 'b';
        request.externalDocumentKey = 'c';
        request.externalObjectKey = 'd';
        request.fileExtension = 'e';
        request.fileName = 'f';
        request.userEmail = 'g';
        String jsonResponse = 'test';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        res.response = 'test response';
        ImagingServiceProxy.DocumentMetadata meta = new ImagingServiceProxy.DocumentMetadata();
        mockJson.setup('serialize', new List<Object>{request}).returns(jsonResponse);
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(meta);
        mockRestService.setup('POST', new List<Object>{'DocumentsUrl', '/documents', jsonResponse }).returns(res);
        
        sut.storeDocument(request);

        mockJson.verify('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);     
    }

    @IsTest
    static void it_should_return_null_when_the_service_call_to_store_document_response_is_not_OK() {
        ImagingServiceProxy.StoreDocumentRequest request = new ImagingServiceProxy.StoreDocumentRequest();
        String jsonResponse = 'test';
        RestUtility.result res = new RestUtility.result();
        res.status = 'ERROR';
        res.response = 'test response';
        ImagingServiceProxy.DocumentMetadata meta = new ImagingServiceProxy.DocumentMetadata();
        mockJson.setup('serialize', new List<Object>{request}).returns(jsonResponse);
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(meta);
        mockRestService.setup('POST', new List<Object>{'DocumentsUrl', '/documents', jsonResponse }).returns(res);
        
        ImagingServiceProxy.DocumentMetadata result = sut.storeDocument(request);

        System.assert(result == null);
    }

    @IsTest
    static void it_should_call_the_rest_service_when_retrieving_document() {
        string documentId = '123';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        res.response = 'test response';
        String uri = '/documents/123';
        mockRestService.setup('GET', new List<Object>{'DocumentsUrl', uri}).returns(res);
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new ImagingServiceProxy.Document());

        sut.retrieveDocument(documentId);

        mockRestService.verify('GET', new List<Object>{'DocumentsUrl', uri}, Times.Once);
    }

    @IsTest
    static void it_should_return_an_empty_list_when_service_call_fails_retrieving_document() {
        string documentId = '123';
        RestUtility.result res = new RestUtility.result();
        res.status = 'BADNESS';
        res.response = 'test response';
        String uri = '/documents/123';
        mockRestService.setup('GET', new List<Object>{'DocumentsUrl', uri}).returns(res);
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new ImagingServiceProxy.Document());

        List<String> result = sut.retrieveDocument(documentId);

        System.assertEquals(0, result.size());
    }

    @IsTest
    static void it_should_call_the_get_rest_service_when_drawer_privilege_is_retrieved() {
        String email = 'test@email.com';
        String uri = '/drawers?user=test@email.com';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        res.response = 'test response';
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<DrawerPrivilege>());
        mockRestService.setup('GET', new List<Object>{'DocumentsUrl', uri}).returns(res);

        sut.getDrawerPrivilegesByEmailAddress(email);

        mockRestService.verify('GET', new List<Object>{'DocumentsUrl', uri}, Times.Once);
    }

    @IsTest
    static void it_should_return_an_empty_list_when_service_call_fails_retrieving_drawer_privileges() {
        String email = 'test@email.com';
        String uri = '/drawers?user=test@email.com';
        RestUtility.result res = new RestUtility.result();
        res.status = 'FAILED';
        res.response = 'test response';
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<DrawerPrivilege>());
        mockRestService.setup('GET', new List<Object>{'DocumentsUrl', uri}).returns(res);

        List<DrawerPrivilege> result = sut.getDrawerPrivilegesByEmailAddress(email);

        System.assertEquals(0, result.size());
    }

    @IsTest
    static void it_should_call_the_get_on_rest_service_when_get_rel_nav_documents_is_called() {
        List<String> keys = new List<String>{'1', '2'};
        String delimitedKeys = '1,2';
        String keyType = 'testType';
        Boolean includeRelated = false;
        mockUtil.setup('ListToDelimitedString', new List<Object>{keys, ','}).returns(delimitedKeys);
        String uri = '/documents/rel_nav?key_type=testType&keys=1,2&include_related=false';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        res.response = 'test response';
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<RelNavDocument>());
        mockRestService.setup('GET', new List<Object>{'DocumentsUrl', uri}).returns(res);

        sut.getRelNavDocuments(keyType, keys, includeRelated);

        mockRestService.verify('GET', new List<Object>{'DocumentsUrl', uri}, Times.Once);
    }

    @IsTest
    static void it_should_return_an_empty_list_when_service_call_fails_retrieving_rel_nav_docs() {
        List<String> keys = new List<String>{'1', '2'};
        String delimitedKeys = '1,2';
        String keyType = 'testType';
        Boolean includeRelated = false;
        mockUtil.setup('ListToDelimitedString', new List<Object>{keys, ','}).returns(delimitedKeys);
        String uri = '/documents/rel_nav?key_type=testType&keys=1,2&include_related=false';
        RestUtility.result res = new RestUtility.result();
        res.status = 'FAILED';
        res.response = 'test response';
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<RelNavDocument>());
        mockRestService.setup('GET', new List<Object>{'DocumentsUrl', uri}).returns(res);

        List<RelNavDocument> result = sut.getRelNavDocuments(keyType, keys, includeRelated);

        System.assertEquals(0, result.size());
    }

    @IsTest
    static void it_should_get_metadata() {
        List<String> keys = new List<String>{'1', '2'};
        String delimitedKeys = '1,2';
        String keyStatus = 'testStatus';
        String keyType = 'testType';
        mockUtil.setup('ListToDelimitedString', new List<Object>{keys, ','}).returns(delimitedKeys);
        String uri = '/documents?keys=1,2';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        res.response = 'test response';
        mockJson.setup('deserialize', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<ImagingServiceProxy.DocumentMetadata>());
        mockRestService.setup('GET', new List<Object>{'DocumentsUrl', uri}).returns(res);

        List<ImagingServiceProxy.DocumentMetadata> result = sut.getDocumentMetadata(keys);

        mockRestService.verify('GET', new List<Object>{'DocumentsUrl', uri}, Times.Once);
    }

    @IsTest
    static void it_should_return_an_empty_metadata_when_service_response_is_not_OK() {
        List<String> keys = new List<String>{'1', '2'};
        String delimitedKeys = '1,2';
        String keyStatus = 'testStatus';
        String keyType = 'testType';
        mockUtil.setup('ListToDelimitedString', new List<Object>{keys, ','}).returns(delimitedKeys);
        RestUtility.result res = new RestUtility.result();
        res.status = 'FAIL';
        res.response = 'test response';
        List<ImagingServiceProxy.DocumentMetadata> docs = new List<ImagingServiceProxy.DocumentMetadata>();
        ImagingServiceProxy.DocumentMetadata doc = new ImagingServiceProxy.DocumentMetadata();
        doc.docTypeName = '1';
        doc.documentDate = '2';
        doc.documentId = '3';
        doc.drawerName = '4';
        doc.extension = '5';
        doc.isStaged = false;
        doc.comments = '6';
        docs.add(doc);
        mockJson.setup('deserialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(docs);
        mockRestService.setup('GET', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(res);

        List<ImagingServiceProxy.DocumentMetadata> result = sut.getDocumentMetadata(keys);

        System.assertEquals(0, result.size());
    }

    @IsTest
    static void it_should_make_the_correct_rest_service_call_when_update_keys_is_called() {
        List<ImagingServiceProxy.UpdateDocumentKeysRequest> requests = new List<ImagingServiceProxy.UpdateDocumentKeysRequest>();
        ImagingServiceProxy.UpdateDocumentKeysRequest singleRequest = new ImagingServiceProxy.UpdateDocumentKeysRequest();
        singleRequest.keyType = 'Test';
        singleRequest.oldExternalKey = 'old key';
        singleRequest.newExternalKey = 'new key';
        requests.add(singleRequest);
        String requestAsJson = '{json:json,test:test}';
        mockJson.setup('serialize', new List<Object>{requests}).returns(requestAsJson);

        sut.updateDocumentKeys(requests);

        mockRestService.verify('POST', new List<Object>{'DocumentsUrl', '/documents/keys', requestAsJson}, Times.Once);
    }

    @IsTest
    static void it_should_make_the_correct_rest_service_call_when_update_keys_async_is_called() {
        List<ImagingServiceProxy.UpdateDocumentKeysRequest> requests = new List<ImagingServiceProxy.UpdateDocumentKeysRequest>();
        ImagingServiceProxy.UpdateDocumentKeysRequest singleRequest = new ImagingServiceProxy.UpdateDocumentKeysRequest();
        singleRequest.keyType = 'Test';
        singleRequest.oldExternalKey = 'old key';
        singleRequest.newExternalKey = 'new key';
        requests.add(singleRequest);
        String requestAsJson = '{json:json,test:test}';
        mockJson.setup('serialize', new List<Object>{requests}).returns(requestAsJson);

        sut.updateDocumentKeys_Async(requests);

        mockRestService.verify('POST_Async', new List<Object>{'DocumentsUrl', '/documents/keys', requestAsJson}, Times.Once);
    }

    @IsTest
    static void it_should_make_the_correct_rest_service_call_when_getChunkedMessageToken_is_called() {
        ImagingServiceProxy.RequestMessageToken request = new ImagingServiceProxy.RequestMessageToken();
        request.shardCount = 1;
        String requestAsJson = '{json:json,test:test}';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        res.response = 'test response';
        mockJson.setup('serialize', new List<Object>{request}).returns(requestAsJson);
        mockRestService.setup('POST', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(res);
        mockJson.setup('deserialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new ImagingServiceProxy.MessageTokenResponse());

        sut.getChunkedMessageToken(request);

        mockRestService.verify('POST', new List<Object>{'DocumentsUrl', '/documents/chunks/initialize', requestAsJson}, Times.Once);
    }

    @IsTest
    static void it_should_fail_when_getChunkedMessageToken_is_called() {
        ImagingServiceProxy.RequestMessageToken request = new ImagingServiceProxy.RequestMessageToken();
        request.shardCount = 1;
        String requestAsJson = '{json:json,test:test}';
        RestUtility.result res = new RestUtility.result();
        res.status = 'BAD';
        res.response = 'test response';
        mockJson.setup('serialize', new List<Object>{request}).returns(requestAsJson);
        mockRestService.setup('POST', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(res);
        mockJson.setup('deserialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new ImagingServiceProxy.MessageTokenResponse());

        String response = sut.getChunkedMessageToken(request);

        mockRestService.verify('POST', new List<Object>{'DocumentsUrl', '/documents/chunks/initialize', requestAsJson}, Times.Once);
        system.assertEquals(null, response);
    }

    @IsTest
    static void it_should_make_the_correct_rest_service_call_when_storeDocumentChunked_is_called() {
        ImagingServiceProxy.RequestChunk request = new ImagingServiceProxy.RequestChunk();
        request.messageToken = '123';
        String requestAsJson = '{json:json,test:test}';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        res.response = 'test response';
        mockJson.setup('serialize', new List<Object>{request}).returns(requestAsJson);
        mockRestService.setup('POST', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(res);

        sut.storeDocumentChunked(request);

        mockRestService.verify('POST', new List<Object>{'DocumentsUrl', '/documents/chunks', requestAsJson}, Times.Once);
    }

    @IsTest
    static void it_should_fail_when_storeDocumentChunked_is_called() {
        ImagingServiceProxy.RequestChunk request = new ImagingServiceProxy.RequestChunk();
        request.messageToken = '123';
        String requestAsJson = '{json:json,test:test}';
        RestUtility.result res = new RestUtility.result();
        res.status = 'BAD';
        res.response = 'test response';
        mockJson.setup('serialize', new List<Object>{request}).returns(requestAsJson);
        mockRestService.setup('POST', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(res);

        ImagingServiceProxy.DocumentMetadata response = sut.storeDocumentChunked(request);

        mockRestService.verify('POST', new List<Object>{'DocumentsUrl', '/documents/chunks', requestAsJson}, Times.Once);
        system.assertEquals(null, response);
    }

    @IsTest
    static void it_should_initialize_a_chunked_document() {
        ImagingServiceProxy.RequestMessageToken request = new ImagingServiceProxy.RequestMessageToken();
        request.shardCount = 1;
        String requestAsJson = 'dfewr';
        String serviceApiName = 'DocumentsUrl';
        String initChunkTokenApi = '/documents/chunks/initialize';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        res.response = 'test response';
        ImagingServiceProxy.MessageTokenResponse messageResponse = new ImagingServiceProxy.MessageTokenResponse();

        mockJson.setup('serialize', new List<Object>{request}).returns(requestAsJson);
        mockJson.setup('deserialize', new List<Object>{res.response, ImagingServiceProxy.MessageTokenResponse.class}).returns(messageResponse);
        mockRestService.setup('POST', new List<Object>{serviceApiName, initChunkTokenApi, requestAsJson}).returns(res);

        String response = sut.initializeChunkedDocument(request);

        mockRestService.verify('POST', new List<Object>{serviceApiName, initChunkTokenApi, requestAsJson}, Times.Once);
    }

    @IsTest
    static void it_should_not_initialize_a_chunked_document() {
        ImagingServiceProxy.RequestMessageToken request = new ImagingServiceProxy.RequestMessageToken();
        request.shardCount = 1;
        String requestAsJson = 'dfewr';
        String serviceApiName = 'DocumentsUrl';
        String initChunkTokenApi = '/documents/chunks/initialize';
        RestUtility.result res = new RestUtility.result();
        res.status = 'NOT';
        res.response = 'test response';
        ImagingServiceProxy.MessageTokenResponse messageResponse = new ImagingServiceProxy.MessageTokenResponse();

        mockJson.setup('serialize', new List<Object>{request}).returns(requestAsJson);
        mockJson.setup('deserialize', new List<Object>{res.response, ImagingServiceProxy.MessageTokenResponse.class}).returns(messageResponse);
        mockRestService.setup('POST', new List<Object>{serviceApiName, initChunkTokenApi, requestAsJson}).returns(res);

        String response = sut.initializeChunkedDocument(request);

        mockRestService.verify('POST', new List<Object>{serviceApiName, initChunkTokenApi, requestAsJson}, Times.Once);
        system.assertEquals(null, response);
    }

    @IsTest
    static void it_should_append_chunked_document() {
        ImagingServiceProxy.RequestChunk chunk = new ImagingServiceProxy.RequestChunk();
        chunk.messageToken = 'fsfewr';
        chunk.chunk = 'ferr';
        chunk.sequence = 1;
        String requestAsJson = 'dfewr';
        String serviceApiName = 'DocumentsUrl';
        String appendDocChunk = '/documents/chunks/append';

        mockJson.setup('serialize', new List<Object>{chunk}).returns(requestAsJson);
        mockRestService.setup('POST', new List<Object>{serviceApiName, appendDocChunk, requestAsJson});

        sut.appendChunkedDocument(chunk);

        mockRestService.verify('POST', new List<Object>{serviceApiName, appendDocChunk, requestAsJson}, Times.Once);

    }

    @IsTest
    static void it_should_finalize_chunked_document() {
        ImagingServiceProxy.RequestFinalization finalRequest = new ImagingServiceProxy.RequestFinalization();
        finalRequest.messageToken = 'fer';
        finalRequest.drawerName = 'sd';
        finalRequest.documentType = 'sfdwer';
        finalRequest.documentDate = Date.today();
        finalRequest.externalObjectKeys = new List<String>{'dfdf'};
        finalRequest.externalDocumentKey = 'sdfewr';
        finalRequest.comments = 'swer';
        finalRequest.userEmail = 'swrt';
        finalRequest.fileExtension ='wett';
        finalRequest.fileName = 'wett';

        String requestAsJson = 'dfewr';
        String serviceApiName = 'DocumentsUrl';
        String finalizedDocChunk = '/documents/chunks/finalize';
        RestUtility.result res = new RestUtility.result();
        res.status = 'OK';
        res.response = 'test response';
        ImagingServiceProxy.DocumentMetadata metadata = new ImagingServiceProxy.DocumentMetadata();

        mockJson.setup('serialize', new List<Object>{finalRequest}).returns(requestAsJson);
        mockJson.setup('deserialize', new List<Object>{res.response, ImagingServiceProxy.DocumentMetadata.class}).returns(metadata);
        mockRestService.setup('POST', new List<Object>{serviceApiName, finalizedDocChunk, requestAsJson}).returns(res);

        ImagingServiceProxy.DocumentMetadata response = sut.finalizeChunkedDocument(finalRequest);

        mockRestService.verify('POST', new List<Object>{serviceApiName, finalizedDocChunk, requestAsJson}, Times.Once);
    }

    @IsTest
    static void it_should_not_finalize_chunked_document() {
        ImagingServiceProxy.RequestFinalization finalRequest = new ImagingServiceProxy.RequestFinalization();
        String requestAsJson = 'dfewr';
        String serviceApiName = 'DocumentsUrl';
        String finalizedDocChunk = '/documents/chunks/finalize';
        RestUtility.result res = new RestUtility.result();
        res.status = 'BAD';
        res.response = 'test response';
        ImagingServiceProxy.DocumentMetadata metadata = new ImagingServiceProxy.DocumentMetadata();

        mockJson.setup('serialize', new List<Object>{finalRequest}).returns(requestAsJson);
        mockJson.setup('deserialize', new List<Object>{res.response, ImagingServiceProxy.DocumentMetadata.class}).returns(metadata);
        mockRestService.setup('POST', new List<Object>{serviceApiName, finalizedDocChunk, requestAsJson}).returns(res);

        ImagingServiceProxy.DocumentMetadata response = sut.finalizeChunkedDocument(finalRequest);

        mockRestService.verify('POST', new List<Object>{serviceApiName, finalizedDocChunk, requestAsJson}, Times.Once);
        system.assertEquals(null, response);
    }
}