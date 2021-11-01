@IsTest
private class TmBoardingServiceRequestBuilderTests {

    private static final TmConfigurationMock.ofIRepository mockRepo;
    private static final TmBoardingMock.ofIReportHelper mockHelper;
    private static final Mock.ofIEncodingUtil mockEncodingUtil;
    private static final Mock.ofIUtility mockUtil;
    private static final Mock.ofIJson mockJson;
    private static final TmBoardingMock.ofIServiceClientInfoProvider mockProvider;
    private static final Mock.ofIEbDocRepoProvider mockEbDocProvider;
    private static TmBoardingServiceRequestBuilder sut;
    
    static {
        mockRepo = new  TmConfigurationMock.ofIRepository();
        mockHelper = new TmBoardingMock.ofIReportHelper();
        mockEncodingUtil = new Mock.ofIEncodingUtil();
        mockUtil = new Mock.ofIUtility();
        mockJson = new Mock.ofIJson();
        mockProvider = new TmBoardingMock.ofIServiceClientInfoProvider();
        mockEbDocProvider = new Mock.ofIEbDocRepoProvider();
        sut = new TmBoardingServiceRequestBuilder(mockRepo, mockHelper, mockEncodingUtil, mockUtil, mockJson, mockProvider, mockEbDocProvider);
    }

    @IsTest
    static void it_should_call_the_helper_to_build_bulk_requests() {
        String packetId = ObjectFactory.getFakeId(Tm_Service_Request_PAcket__c.SObjectType, '1');
        String requestId = 'req-id';
        Id request_Id = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        List<TmBoarding.SignerInfo> signers = new  List<TmBoarding.SignerInfo>();
        List<String> products = new List<String>();
        TmConfiguration.ProductInfo info = new TmConfiguration.ProductInfo();
        info.ProductType = new DmRecordType();
        Map<String, TmConfiguration.ProductInfo> infos = new Map<String, TmConfiguration.ProductInfo>{requestId => info};
        TmBoarding.ReportDataHolder dataHolder = new TmBoarding.ReportDataHolder();
        TmBoarding.BoardingData boardingData = new TmBoarding.BoardingData();
        dataHolder.allBoardingData = new Map<String, TmBoarding.BoardingData>{requestId => boardingData};
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.ContactPms = new List<Contact>();
        dataHolder.requestPms = new Map<Id,TmBoarding.RequestPm>{request_Id => requestPm};

        mockRepo.setup('getProductInfosByRequestId', new List<object>{packetId}).returns(infos);
        mockHelper.setup('buildBulkRequestPmData', new List<Object>{infos, products}).returns(dataHolder);

        List<TmBoardingServiceProxy.HtmlToSignatureRequest> result = sut.build(packetId, signers, products, true, 1);

        mockHelper.verify('buildBulkRequestPmData', new List<Object>{infos ,products}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_encoding_util() {
        String packetId = ObjectFactory.getFakeId(Tm_Service_Request_PAcket__c.SObjectType, '1');
        String requestId = 'req-id';
        Id request_Id = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        List<TmBoarding.SignerInfo> signers = new  List<TmBoarding.SignerInfo>();
        List<String> products = new List<String>();
        TmConfiguration.ProductInfo info = new TmConfiguration.ProductInfo();
        info.ProductType = new DmRecordType();
        info.TemplateFileName = 'test-template-name';
        info.ConfigId = 'some id';
        Map<String, TmConfiguration.ProductInfo> infos = new Map<String, TmConfiguration.ProductInfo>{requestId => info};
        TmBoarding.ReportDataHolder dataHolder = new TmBoarding.ReportDataHolder();
        TmBoarding.BoardingData boardingData = new TmBoarding.BoardingData();
        dataHolder.allBoardingData = new Map<String, TmBoarding.BoardingData>{requestId => boardingData};
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.ContactPms = new List<Contact>();
        dataHolder.requestPms = new Map<Id,TmBoarding.RequestPm>{request_Id => requestPm};
        String templateContents = 'some content to construct blob';
        Blob returnedTemplate = Blob.valueOf(templateContents);

        mockRepo.setup('getProductInfosByRequestId', new List<Object>{packetId}).returns(infos);
        mockRepo.setup('getTemplateFromAttachment', new List<Object>{info.templateFileName, info.configId}).returns(returnedTemplate);
        mockHelper.setup('buildBulkRequestPmData', new List<Object>{infos, products}).returns(dataHolder);

        List<TmBoardingServiceProxy.HtmlToSignatureRequest> result = sut.build(packetId, signers, products, true, 1);

        mockEncodingUtil.verify('toBase64', new List<Object>{returnedTemplate}, Times.Once);
    }

    @IsTest
    static void it_should_build_client_info_by_calling_client_provider() {
        String entityId = 'entity-id';
        String tmoEmail = 'test@test.email.com';
        String DEFAULT_PRIMARY_SIGNER = 'PS';
        TmBoarding.SignerInfo signerInfo = new TmBoarding.SignerInfo();
        signerInfo.SecurityCode = '1234';
        signerInfo.SignerId = tmoEmail;
        signerInfo.Tmo = new TmBoarding.TmoSigner();
        signerInfo.Tmo.Email = tmoEmail;
        List<String> items = new List<String>{entityId};
        Integer applicationId = 1;
        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{signerInfo};

        List<TmBoardingServiceProxy.HtmlToSignatureRequest> result = sut.buildTMSADataForEntity('', entityId, signers, items, applicationId);

        mockProvider.verify('getClientInfo', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)mockProvider.getArgumentsFromCall('getClientInfo');

        Map<String, Contact> contactsArg = (Map<String, Contact>) arguments[0];
        List<TmBoarding.SignerInfo> signersArg = (List<TmBoarding.SignerInfo>)arguments[1];
        String primarySignerArg = (String)arguments[2];

        System.assertEquals(tmoEmail, contactsArg.get(tmoEmail).Email);
        System.assertEquals(tmoEmail, signersArg[0].tmo.Email);
        System.assertEquals(DEFAULT_PRIMARY_SIGNER, primarySignerArg);
    }
}