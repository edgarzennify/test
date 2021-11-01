@IsTest
private class TmBoardingReportManagerTests {

    private static final TmConfigurationMock.ofIRepository mockConfigRepository;
    private static final TmBoardingMock.ofIDataMapBuilder m_mockDataMapBuilder;
    private static final TmBoardingMock.ofIRepository m_mockTmRepository;
    private static final Mock.ofIHtmlReportingService m_mockReportingService;
    private static final Mock.ofIJson m_mockJsonSerializer;
    private static final Mock.ofIEncodingUtil m_mockEncoding;
    private static final TmBoardingMock.ofIReportHelper m_mockReportHelper;
    private static final Mock.ofIEbDocRepoProvider m_EbtDocProvider;
    private static final TmBoardingReportManager sut;

    static {
        mockConfigRepository = new TmConfigurationMock.ofIRepository();
        m_mockDataMapBuilder = new TmBoardingMock.ofIDataMapBuilder();
        m_mockReportingService = new Mock.ofIHtmlReportingService();
        m_mockTmRepository = new TmBoardingMock.ofIRepository();
        m_mockJsonSerializer = new Mock.ofIJson();
        m_mockEncoding = new Mock.ofIEncodingUtil();
        m_mockReportHelper = new TmBoardingMock.ofIReportHelper();
        m_EbtDocProvider = new Mock.ofIEbDocRepoProvider();
        sut = new TmBoardingReportManager(mockConfigRepository, m_mockDataMapBuilder, m_mockReportingService, m_mockJsonSerializer, m_mockTmRepository, m_mockEncoding, m_mockReportHelper, m_EbtDocProvider);
    }

    @IsTest
    static void it_should_call_the_json_serializer_serialize_data_from_datamapbuilder() {
        String productName = 'Online Banking';
        Tm_Service_Request__c record = new Tm_Service_Request__c();
        RecordType rType = new RecordType(Name = productName);
        record.RecordType = rType;
        record.RecordType.Name = rType.Name;
        Blob testBytes = Blob.valueOf('test');
        Blob templateBytes = Blob.valueof('template-bytes');
        TmBoarding.requestPm pm = new TmBoarding.requestPm();
        TmBoarding.ProductConfig testProduct = new TmBoarding.ProductConfig();
        testProduct.ProductId = 'abcd1234';
        testProduct.Product = productName;
        testProduct.TemplateFolderName = 'Folder';
        testProduct.TemplateFileName = 'File';
        TmBoarding.BoardingData data = new TmBoarding.BoardingData();
        TmBoarding.LayoutComponent2 packet = new TmBoarding.LayoutComponent2();
        data.packet = packet;
        data.Details = new TmBoarding.DataComponent();
        data.contacts = new TmBoarding.DataComponent(); 
        data.accounts = new TmBoarding.DataComponent();
        data.contactAccounts = new TmBoarding.DataComponent();

        TmBoarding.BoardingData bdata = new TmBoarding.BoardingData();
        m_mockDataMapBuilder.setup('buildPacket', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(data.packet);

        mockConfigRepository.setup('getRecordTypeName', new List<Object>{record}).returns(productName);
        mockConfigRepository.setup('getProduct', new List<Object>{productName}).returns(testProduct);
        m_mockReportingService.setup('getPdf', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(testBytes);
        m_mockReportHelper.setup('buildJsonData', new List<Object>{record, productName}).returns(bdata);

        TmBoarding.ReportDetails result = sut.getReport(record);

        m_mockJsonSerializer.verify('serialize', new List<Object>{bdata}, Times.Once);
    }

    @IsTest
    static void it_should_get_contact_summary_details() {
        Id packet = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        Id requestPm1Id = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '2');
        Id requestPm2Id = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '3');
        Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '4');

        RecordType r = new RecordType();
        r.Name = 'rname';
        RecordType r2 = new RecordType();
        r2.Name = 'r2name';
        Tm_Service_Request__c requestPm1 = new Tm_Service_Request__c();
        requestPm1.Id = requestPm1Id;
        requestPm1.recordType = r;
        Tm_Service_Request__c requestPm2 = new Tm_Service_Request__c();
        requestpm2.id= requestPm2Id;
        requestPm2.recordType = r2;
        Contact c = new Contact();
        c.firstname = 'test';
        c.lastname = 'user';
        insert c;
        c = [select name from contact where id =: c.id limit 1];

        TM_Service_Request_Contact__c serviceContact = new TM_Service_Request_Contact__c();
        servicecontact.contact__c = c.Id;

        TmBoarding.RequestPm request = new TmBoarding.RequestPm();
        request.serviceContactPms = new List<TM_Service_Request_Contact__c>{serviceContact};
        request.requestPm = requestPm1;
        request.contactPms = new List<Contact>{c};

        TmBoarding.RequestPm request2 = new TmBoarding.RequestPm();
        request2.serviceContactPms = new List<TM_Service_Request_Contact__c>();
        request2.requestPm = requestPm2;
        request2.contactPms = new List<Contact>{c};

        List<TM_Service_Request__c> requestPms = new List<Tm_Service_Request__c>{requestPm1, requestPm2};

        TmBoarding.ProductConfig config = new TmBoarding.ProductConfig();
        config.ContactSummaryReportTemplateName = 'sdfwe';
        config.ProductId = 'wersdf';

        TmBoarding.ProductConfig config2 = new TmBoarding.ProductConfig();
        config.ContactSummaryReportTemplateName = 'sdfwe2';
        config.ProductId = 'wersdf2';

        String productName = 'sfdsdfer';

        Blob templateBytes = Blob.valueOf('rer');
        String jsonData = 'fsewr';
        
        Blob returnBytes2 = Blob.valueOf('rerwe');
        String returnData;

        TmConfiguration.ProductInfo productInfo = new TmConfiguration.ProductInfo();
        productInfo.configId = 'abc11';
        DmRecordType recDm = new DmRecordType();
        recDm.Name = productName;
        productInfo.productType = recDm;
        productInfo.templateFileName = 'x.pdf';

        TmBoarding.BoardingData bData = new TmBoarding.BoardingData();

        Map<string, TmConfiguration.ProductInfo> productInfos = new Map<string, TmConfiguration.ProductInfo>{productName => productInfo};
        Map<string, TmBoarding.BoardingData> allData = new Map<string, TmBoarding.BoardingData>();

        m_mockEncoding.setup('toBase64', new List<Object>{returnBytes2}).returns(returnData); // do something here
        mockConfigRepository.setup('getProductInfos', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(productInfos);
        m_mockTmRepository.setupSequence('getData', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(request).returns(request2);  
              
        mockConfigRepository.setup('getRecordTypeName', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestPm1.recordType.name);
        mockConfigRepository.setup('getProduct', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(config);
        mockConfigRepository.setup('getTemplateFromAttachment', new List<Object>{config.ContactSummaryReportTemplateName, config.ProductId}).returns(templateBytes);
        m_mockJsonSerializer.setup('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(jsonData);
        m_mockReportingService.setup('getPdf', new List<Object>{templateBytes, jsonData}).returns(returnBytes2);

        TmBoarding.ContactSummaryDetails results = sut.getContactSummaryDetails(packet);

        m_mockJsonSerializer.verify('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        m_mockReportingService.verify('getPdf', new List<Object>{templateBytes, jsonData}, Times.Once);
    }

    @IsTest
    static void it_should_call_reporting_proxy_to_build_packet_report() {
        Id packetId = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '1');
        Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c request= new Tm_Service_Request__c(Id = requestId);
        List<Tm_Service_Request__c> requestPms = new List<Tm_Service_Request__c>{request};
        String recordTypeName = 'tesdf';

        TmConfiguration.ProductInfo productInfo = new TmConfiguration.ProductInfo();
        productInfo.configId = 'abc11';
        DmRecordType recDm = new DmRecordType();
        recDm.Name = recordTypeName;
        productInfo.productType = recDm;
        productInfo.templateFileName = 'x.pdf';
        productInfo.footerTemplateId = null;

        TmBoarding.BoardingData bData = new TmBoarding.BoardingData();

        Map<string, TmConfiguration.ProductInfo> productInfos = new Map<string, TmConfiguration.ProductInfo>{requestId => productInfo};
        TmBoarding.ReportDataHolder dataHolder = new TmBoarding.ReportDataHolder();
        dataHolder.allBoardingData = new Map<string, TmBoarding.BoardingData>();

        Blob b = Blob.valueOf('tes');
        DmDocument doc = new DmDocument();
        doc.body = b;
        mockConfigRepository.setup('getTemplateFromAttachment', new List<Object>{productInfo.TemplateFileName, productInfo.configId}).returns(b);
        mockConfigRepository.setup('getProductInfosByRequestId' , new List<Object>{packetId}).returns(productInfos);
        m_mockReportHelper.setup('buildJsonDataBulk', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dataHolder);
        m_EbtDocProvider.setup('getFileByEbDocId', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(doc);

        sut.getPacketReport(packetId, true);

        m_mockJsonSerializer.verify('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        m_mockReportingService.verify('getMergedPdfs', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_get_tm_operations_report() {
        String productName = 'sdfewr';
        Tm_Service_Request__c request = new Tm_Service_Request__c();
        TmBoarding.ProductConfig productConfig = new TmBoarding.ProductConfig();
        productConfig.TmScreenTemplateFileName = 'sdfwer';
        productConfig.ProductId = 'sfwer';
        Blob b = Blob.valueOf('fsdf');

        DmField field = new DmField();
        field.Name = 'sdfwer';
        field.ObjectName = 'CORE_CONTACT';
        DmSection section = new DmSection();
        section.Fields = new List<DmField>{field};
        List<DmSection> dmSections = new List<DmSection>{section};

        TmBoarding.BoardingData data = new TmBoarding.BoardingData();

        mockConfigRepository.setup('getRecordTypeName', new List<Object>{request}).returns(productName);
        mockConfigRepository.setup('getProduct', new LIst<Object>{productName}).returns(productConfig);
        mockConfigRepository.setup('getTemplateFromAttachment', new List<Object>{productConfig.TmScreenTemplateFileName, productConfig.ProductId}).returns(b);
        mockConfigRepository.setup('getDetailSections', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dmSections);
        m_mockReportHelper.setup('buildJsonData', new List<Object>{request, productName}).returns(data);

        sut.getTmOperationsReport(request);

        mockConfigRepository.verify('getRecordTypeName', new List<Object>{request}, Times.Once);
        mockConfigRepository.verify('getProduct', new LIst<Object>{productName}, Times.Once);
        mockConfigRepository.verify('getTemplateFromAttachment', new List<Object>{productConfig.TmScreenTemplateFileName, productConfig.ProductId}, Times.Once);
        m_mockReportingService.verify('getHtml', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_config_repository_to_get_template_details_when_product_name_is_provided() {
        string product = 'Online Banking';
        TmBoarding.ProductConfig cfg = new TmBoarding.ProductConfig();
        cfg.TemplateFileName = 'test-file';
        mockConfigRepository.setup('getProduct', new List<Object>{product}).returns(cfg);
        mockConfigRepository.setup('getTemplateFromAttachment', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(null);

        TmBoarding.ProductConfig result =  sut.getTemplatesForProduct(product);

        System.assertEquals('', result.TemplateFileName);
    }

    @IsTest
    static void it_should_build_user_boarding_Details() {
        String packetId = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '1');
        List<TmBoarding.RequestPm> requestPms = new List<TmBoarding.RequestPm>();
        Map<string, TmConfiguration.ProductInfo> productInfos =  new Map<string, TmConfiguration.ProductInfo>(); 
        m_mockTmRepository.setup('getRequestPmsForPacket', new List<Object>{packetId}).returns(requestPms);
        mockConfigRepository.setup('getProductInfos', new List<Object>{packetId}).returns(productInfos);

        TmBoarding.UserBoardingDetails result =  sut.getBoardingUserInfo(packetId);

        m_mockTmRepository.verify('getRequestPmsForPacket', new List<Object>{packetId}, Times.Once);
        mockConfigRepository.verify('getProductInfos', new List<Object>{packetId}, Times.Once);
    }

    @IsTest
    static void it_should_call_json_serializer_two_times_when_two_products_requested_on_getEmptyReports() {
        List<string> products =new List<string>{'ZBA', 'TEST'};
        TmBoarding.ProductConfig zbaProduct = new TmBoarding.ProductConfig();
        zbaProduct.TemplateFileName = 'zba';
        zbaProduct.ProductId = 'zbaid';
        TmBoarding.ProductConfig testProduct = new TmBoarding.ProductConfig();
        testProduct.TemplateFileName = 'test';
        testProduct.ProductId = 'testid';
        mockConfigRepository.setup('getProduct', new List<object>{'ZBA'}).returns(zbaProduct);
        mockConfigRepository.setup('getProduct', new List<object>{'TEST'}).returns(testProduct);
        Blob zbaBlob = Blob.valueOf('1');
        Blob testBlob = Blob.valueOf('10');

        mockConfigRepository.setup('getTemplateFromAttachment', new List<object>{'zba', 'zbaid'}).returns(zbaBlob);
        mockConfigRepository.setup('getTemplateFromAttachment', new List<Object>{'test', 'testid'}).returns(testBlob);

        TmBoarding.ReportDetails results = sut.getEmptyReports(products);
        
        mockConfigRepository.verify('getProduct', new List<Object>{'ZBA'}, Times.Once);
        mockConfigRepository.verify('getProduct', new List<Object>{'TEST'}, Times.Once);
        m_mockJsonSerializer.verify('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Twice);
        m_mockReportingService.verify('getMergedPdfs', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_not_fail_when_no_template_exists_on_getEmptyReports() {
        List<string> products =new List<string>{'ZBA', 'TEST'};
        TmBoarding.ProductConfig zbaProduct = new TmBoarding.ProductConfig();
        zbaProduct.TemplateFileName = 'zba';
        zbaProduct.ProductId = 'zbaid';
        TmBoarding.ProductConfig testProduct = new TmBoarding.ProductConfig();
        testProduct.TemplateFileName = 'test';
        testProduct.ProductId = 'testid';
        mockConfigRepository.setup('getProduct', new List<object>{'ZBA'}).returns(zbaProduct);
        mockConfigRepository.setup('getProduct', new List<object>{'TEST'}).returns(testProduct);
        Blob zbaBlob = Blob.valueOf('1');
        Blob testBlob = Blob.valueOf('10');

        mockConfigRepository.setup('getTemplateFromAttachment', new List<object>{'zba', 'zbaid'}).returns(zbaBlob);
        mockConfigRepository.setup('getTemplateFromAttachment', new List<Object>{'test', 'testid'}).returns(null);

        TmBoarding.ReportDetails results = sut.getEmptyReports(products);
        
        mockConfigRepository.verify('getProduct', new List<Object>{'ZBA'}, Times.Once);
        mockConfigRepository.verify('getProduct', new List<Object>{'TEST'}, Times.Once);
        m_mockJsonSerializer.verify('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_get_master_service_agreement() {
        String content = 'test-content';
        String productId = 'product-id';
        Id ebDocId = ObjectFactory.getFakeID(EBDocRepo__c.SObjectType, '1');                
        Blob b = Blob.valueOf(content);
        DmDocument dmDoc = new DmDocument();
        dmDoc.Body = b;
        string packetId = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '1');
        TmConfiguration.ProductInfo productInfo = new TmConfiguration.ProductInfo();
        productInfo.requestId = productId;
        productInfo.masterAgreementTemplateName = ebDocId;
        Map<string, TmConfiguration.ProductInfo> productInfos = new Map<string, TmConfiguration.ProductInfo>{productId => productInfo};
        m_EbtDocProvider.setup('GetFileByEbDocId', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dmDoc);
        mockConfigRepository.setup('getProductInfos', new List<Object>{packetId}).returns(productInfos);
        m_mockReportHelper.setup('getMasterServiceAgreement', new List<object>{packetId}).returns(b);

        Blob result = sut.getMasterServiceAgreement(packetId);

        System.assertEquals(b, result); 
    }
}