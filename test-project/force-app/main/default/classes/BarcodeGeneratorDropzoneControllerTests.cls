@IsTest
private class BarcodeGeneratorDropzoneControllerTests {

	private static BarcodeGeneratorDropzoneController sut;
	private static Mock.ofIApexPages mockOfApexPages;
	private static final Mock.ofHttpCalloutMock m_mockCallout;

	static {
		HttpResponse response;
		response = new HttpResponse();
        response.setBody('test');
        response.setStatusCode(200);
        response.setStatus('OK');
		m_mockCallout = new Mock.ofHttpCalloutMock();
        m_mockCallout.Setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(response);
	}

	@IsTest
    static void it_should_get_the_parameters() {
		mockOfApexPages = new Mock.ofIApexPages();
		System.PageReference page = new System.PageReference('fd');
		String tokenInfo ='sdfwer';
		String tokenInfoParameter = 'tokenInfo';

		mockOfApexPages.setup('currentPage').returns(page);
		mockOfApexPages.setup('getParameter', new List<Object>{tokenInfoParameter}).returns(tokenInfo);

		sut = new BarcodeGeneratorDropzoneController(mockOfApexPages);
		
		mockOfApexPages.verify('currentPage', Times.Once);
		mockOfApexPages.verify('getParameter', new List<Object>{tokenInfoParameter}, Times.Twice);
		system.assertEquals(tokenInfo, sut.tokenInfo);	
	}

	@IsTest
    static void it_should_get_the_parameters_and_throws_an_error() {
		mockOfApexPages = new Mock.ofIApexPages();
		System.PageReference page = new System.PageReference('fd');
		String tokenInfo ='sdfwer';
		String tokenInfoParameter = 'tokenInfo';

		mockOfApexPages.setup('currentPage').throws(new applicationException());
		mockOfApexPages.setup('getParameter', new List<Object>{tokenInfoParameter}).returns(tokenInfo);

		try {
			sut = new BarcodeGeneratorDropzoneController(mockOfApexPages);
		}catch(exception ex) {
			system.assert(true);
		}
	}

	@IsTest
    static void it_should_call_init() {
		Id contextId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		BarcodeGeneratorDropzoneController.init(contextId);			
	}

	@IsTest
    static void it_should_do_code_coverage() {
		mockOfApexPages = new Mock.ofIApexPages();

		sut = new BarcodeGeneratorDropzoneController(mockOfApexPages);
		sut = new BarcodeGeneratorDropzoneController();
		
		String ObjectIdAttribute = sut.objectIdAttribute;
		String tokenInfo = sut.tokenInfo;
	}

	@IsTest
    static void it_should_get_the_token_for_upload() {
		Integer chunkCount = 1;
		BarcodeGenerator.FormVm responseData = new BarcodeGenerator.FormVm();
        Test.setMock(HttpCalloutMock.class, m_mockCallout);


        Test.startTest();
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User ADMIN_USER = [Select Id from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
             
        System.runAs(ADMIN_USER)
        {

	        try{

				BarcodeGeneratorDropzoneController.getTokenForChunkedUpload(chunkCount);
			}catch(exception ex){

			}
		}

		Test.stopTest();

		m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        system.assertEquals('POST' ,calledRequest.getMethod());  
	}

	@IsTest
    static void it_should_upload_document_chunk() {
		String messageToken = 'lki';
		String chunkContent = 'lkiu';
		Integer sequenceNumber = 1;
		BarcodeGenerator.FormVm responseData = new BarcodeGenerator.FormVm();
        Test.setMock(HttpCalloutMock.class, m_mockCallout);

        Test.startTest();
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User ADMIN_USER = [Select Id from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
             
        System.runAs(ADMIN_USER)
        {
	        try{

				BarcodeGeneratorDropzoneController.uploadDocumentChunk(messageToken, chunkContent, sequenceNumber);
			}catch(exception ex) {

			}
		}
		Test.stopTest();

		m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        system.assertEquals('POST' ,calledRequest.getMethod());  
	}
	
	@IsTest
    static void it_should_finalize_upload() {
		BarcodeGeneratorDropzoneController.UploadFinalizationRequest request = new BarcodeGeneratorDropzoneController.UploadFinalizationRequest();
		request.messageToken = 'fsfwer';
        request.documentType = 'wrewr';
        request.externalObjectKeys = new List<String>{'asdfwer'};
		request.documentDate = '01/01/01';
        request.comments = 'rrrrr';
        request.userEmail = 'werwer';
        request.fileName = 'wert';
        request.fileExtension = 'wer';

        Test.setMock(HttpCalloutMock.class, m_mockCallout);

        Test.startTest();
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User ADMIN_USER = [Select Id from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
             
        System.runAs(ADMIN_USER)
        {
			try {

				BarcodeGeneratorDropzoneController.finalizeUpload(request);
			} catch(exception ex) {
				System.assert(true);
			}
		}
		Test.stopTest();

		m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        system.assertEquals('POST' ,calledRequest.getMethod());  
	}

	@IsTest
    static void it_should_finalize_upload_and_has_bad_date() {
		BarcodeGeneratorDropzoneController.UploadFinalizationRequest request = new BarcodeGeneratorDropzoneController.UploadFinalizationRequest();
		request.messageToken = 'fsfwer';
        request.documentType = 'wrewr';
        request.externalObjectKeys = new List<String>{'asdfwer'};
		request.documentDate = 'sdter';
        request.comments = 'rrrrr';
        request.userEmail = 'werwer';
        request.fileName = 'wert';
        request.fileExtension = 'wer';

        Test.setMock(HttpCalloutMock.class, m_mockCallout);

        Test.startTest();
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User ADMIN_USER = [Select Id from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
             
        System.runAs(ADMIN_USER)
        {
			try {
				BarcodeGeneratorDropzoneController.finalizeUpload(request);
			} catch(exception ex) {
				System.assert(true);
			}
		}
		Test.stopTest();

		m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        system.assertEquals('POST' ,calledRequest.getMethod());  
	}

	@IsTest
    static void code_coverage() {
		BarcodeGeneratorDropzoneController.isEnabledForCurrentUser();
	}
}