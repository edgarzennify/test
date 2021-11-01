@IsTest
private class EbtDocManagerControllerTests {
    private final static EbtDocManagerController sut;
    private final static Mock.ofIConfigurations mockOfConfigurations;
    private static final Mock.ofHttpCalloutMock m_mockCallout;
    private static HttpRequest request;
    
    static {
        m_mockCallout = new Mock.ofHttpCalloutMock();
  
        mockOfConfigurations = new Mock.ofIConfigurations();
        sut = new EbtDocManagerController(mockOfConfigurations); 
    }
    
    @IsTest
    static void it_should_get_the_store_name_from_configs() { 
        String result = sut.storeName;
        
        mockOfConfigurations.verify('get', new List<Object>{'EbtDocManagerStoreName'}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_the_document_url_template() {
        String result = sut.documentUrlTemplate;
        
        mockOfConfigurations.verify('get', new List<Object>{'EbtDocManagerDocUrlTemplate'}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_the_default_drawer_name() {
        String result = sut.defaultDrawerName;
        
        mockOfConfigurations.verify('get', new List<Object>{'EbtDocManagerDefaultDrawerName'}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_the_default_doc_type() {
        String result = sut.defaultDocType;
        
        mockOfConfigurations.verify('get', new List<Object>{'EbtDocManagerDefaultDocType'}, Times.Once);
    }

    @IsTest
    static void it_should_call_get_token_and_verify_that_post_was_called_out() {
        ImagingServiceProxy.DocumentMetadata responseData = new ImagingServiceProxy.DocumentMetadata();
        responseData.documentId = 'doc11223Id';
        String responseAsJson = JSON.serialize(responseData);
        HttpResponse response;
        response = new HttpResponse();
        response.setBody(responseAsJson);
        response.setStatusCode(200);
        response.setStatus('OK');
        ImagingServiceProxy.StoreDocumentRequest req = new ImagingServiceProxy.StoreDocumentRequest(); 
        req.fileName = '1.txt';
        Integer chunkCount = 1;
        m_mockCallout.Setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(response);
        Test.setMock(HttpCalloutMock.class, m_mockCallout);

        Test.startTest();        
        String result = EbtDocManagerController.getTokenForChunkedUpload(chunkCount);
        Test.stopTest();
        
        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        system.assertEquals('POST' ,calledRequest.getMethod());
        system.assertEquals('{"shardCount":1}', calledRequest.getBody());
    }
    
    //@IsTest
    static void it_should_call_get_token_and_verify_that_exception_is_raised_when_request_is_not_properly_serialized() {
    //    m_mockCallout.setup('respond', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).throws(new applicationException());
    //    Test.setMock(HttpCalloutMock.class, m_mockCallout);

    //    Test.startTest();  
    //    try{
    //        String result = EbtDocManagerController.getTokenForChunkedUpload(1);
    //        System.assert(false);
    //    }catch(EbtDocManagerController.UploadDocumentException ex1) {
    //        System.assert(true);
    //    }catch(exception ex2){
    //        System.assert(false);
    //    }
    //    Test.stopTest();
    }
    
    @IsTest
    static void it_should_call_the_upload_document_chunk_and_verify_that_post_was_called_out() {
        ImagingServiceProxy.DocumentMetadata responseData = new ImagingServiceProxy.DocumentMetadata();
        responseData.documentId = 'doc11223Id';
        String responseAsJson = JSON.serialize(responseData);
        HttpResponse response;
        response = new HttpResponse();
        response.setBody(responseAsJson);
        response.setStatusCode(200);
        response.setStatus('OK');
        ImagingServiceProxy.StoreDocumentRequest req = new ImagingServiceProxy.StoreDocumentRequest(); 
        req.fileName = '1.txt';
        String messageToken = 'abc';
        String messageChunk = 'xyz';
        Integer messageSequence = 1;
        m_mockCallout.Setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(response);
        Test.setMock(HttpCalloutMock.class, m_mockCallout);

        Test.startTest();        
        String result = EbtDocManagerController.uploadDocumentChunk(messageToken, messageChunk, messageSequence);
        Test.stopTest();
        
        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        system.assertEquals('POST' ,calledRequest.getMethod());
        system.assertEquals(true, calledRequest.getBody().contains(messageToken));
        system.assertEquals(true, calledRequest.getBody().contains(messageChunk));
    }
    
    //@IsTest
    static void it_should_call_the_upload_document_chunk_and_verify_that_exception_is_raised_when_request_is_not_properly_serialized() {
    //    m_mockCallout.setup('respond', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).throws(new applicationException());
    //    Test.setMock(HttpCalloutMock.class, m_mockCallout);

    //    Test.startTest();
    //    try{
    //        String result = EbtDocManagerController.uploadDocumentChunk('abc', 'xyz', 1);
    //        System.assert(false, 'didnt throw exception');
    //    }catch(EbtDocManagerController.UploadDocumentException ex1) {
    //        System.assert(true);
    //    }catch(exception ex2){
    //        System.assert(false, 'didnt throw correct exception');
    //    }
    //    Test.stopTest();
    }
    
    @IsTest
    static void it_should_call_the_init_by_passing_the_object_id_and_verify_that_get_was_called_out() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        insert loan;
        List<ImagingServiceProxy.DocumentMetadata> responseDataList = new List<ImagingServiceProxy.DocumentMetadata>();
        ImagingServiceProxy.DocumentMetadata responseData = new ImagingServiceProxy.DocumentMetadata();
        responseData.documentId = 'doc11223Id';
        responseData.documentDate = '2016-03-09';
        responseDataList.add(responseData);
        String responseAsJson = JSON.serialize(responseDataList);
        HttpResponse response;
        response = new HttpResponse();
        response.setBody(responseAsJson);
        response.setStatusCode(200);
        response.setStatus('OK');
        m_mockCallout.Setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(response);
        Test.setMock(HttpCalloutMock.class, m_mockCallout);
        
        Test.startTest();
        EbtDocManagerController.init(loan.Id);
        Test.stopTest();
        
        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        system.assertEquals('GET' ,calledRequest.getMethod());        
    }
    
    @IsTest
    static void it_should_call_the_init_and_verify_that_exception_is_raised_when_when_input_param_is_invalid() {
        try {
            EbtDocManagerController.init('asas12');
            System.assert(false);
        } catch (EbtDocManagerController.DocManagerInitializationException ex1) {
            System.assert(true);
        } catch (exception ex2) {
            System.assert(false);
        }
    }

    @IsTest
    static void code_coverage_instantiate_from_the_default_constructor() {
        EbtDocManagerController xsut = new EbtDocManagerController();
        System.assert(xsut != null);
    }
}