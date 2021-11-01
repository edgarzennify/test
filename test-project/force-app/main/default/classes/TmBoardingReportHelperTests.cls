@IsTest
private class TmBoardingReportHelperTests {
    
    private static final TmConfigurationMock.ofIRepository mockRepository;
    private static final TmBoardingMock.ofIDataMapBuilder mockDataMapBuilder;
    private static Mock.ofIEbDocRepoProvider mockEbDocRepoProvider;
    private static TmBoardingReportHelper sut;
    
    static {
        mockRepository = new TmConfigurationMock.ofIRepository();
        mockDataMapBuilder = new TmBoardingMock.ofIDataMapBuilder();
        mockEbDocRepoProvider = new Mock.ofIEbDocRepoProvider();
        sut = new TmBoardingReportHelper(mockRepository, mockDataMapBuilder, mockEbDocRepoProvider);
    }
    
    @IsTest
    static void it_should_call_the_repository_to_get_json_data() {
        Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
        String productName = 'online';

        TmBoarding.BoardingData result = sut.buildJsonData( record, productName);

        mockRepository.verify('getDetailSections', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
        mockRepository.verify('getScheduleSections', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
        mockRepository.verify('getContactSections', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
        mockRepository.verify('getAccountSections', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
        mockRepository.verify('getContactAccountSections', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_repository_to_get_json_bulk_data() {
        string productName = 'online';
        Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c req = new Tm_Service_Request__c(Id = requestId);
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        pm.requestPm = new Tm_Service_Request__c();
        Map<Id, TmBoarding.RequestPm> pms = new Map<Id, TmBoarding.RequestPm>{req.Id => pm};

        Map<string, Tm_Service_Request__c> jsonRequest = new Map<string, Tm_Service_Request__c>{productName => req};

        DmField fieldDm = new DmField();
        fieldDm.name = 'name';
        fieldDm.objectName = 'object-name';
        DmSection sectionDm = new DmSection();
        sectionDm.name = 'section-name';
        sectionDm.fields = new List<DmField>{fieldDm};
        List<DmSection> sectionDms = new List<DmSection>{sectionDm};

        mockRepository.setup('getAllRequests', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(pms);

        mockRepository.setup('getRecordTypeName', new List<Object>{req}).returns(productName);
        mockRepository.setup('getDetailSections2', new List<Object>{productName, TmConfiguration.Placement.All}).returns(sectionDms);
        mockRepository.setup('getScheduleSections2', new List<Object>{productName, TmConfiguration.Placement.All}).returns(sectionDms);
        mockRepository.setup('getContactSections', new List<Object>{productName, TmConfiguration.Placement.All}).returns(sectionDms);
        mockRepository.setup('getAccountSections', new List<Object>{productName, TmConfiguration.Placement.All}).returns(sectionDms);
        mockRepository.setup('getContactAccountSections', new List<Object>{productName, TmConfiguration.Placement.All}).returns(sectionDms);

        TmBoarding.ReportDataHolder result =  sut.buildJsonDataBulk(jsonRequest);

        mockRepository.verify('getDetailSections2', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
        mockRepository.verify('getScheduleSections2', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
        mockRepository.verify('getContactSections', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
        mockRepository.verify('getAccountSections', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
        mockRepository.verify('getContactAccountSections', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
    }

    @IsTest
    static void it_should_build_data_by_call_the_data_mapper() {
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        DmField fldDm = new DmField();
        fldDm.name = 'fld-name';
        fldDm.objectName = 'obj-name';
        List<DmField> requestFields = new List<DmField>{fldDm};
        List<DmField> scheduleFields = new List<DmField>{fldDm};
        List<DmField> contactFields = new List<DmField>{fldDm};
        List<DmField> accountFields = new List<DmField>{fldDm};
        List<DmField> contactAccountFields = new List<DmField>{fldDm};

        TmBoarding.BoardingData result = sut.buildData(pm, requestFields, scheduleFields, contactFields, accountFields, contactAccountFields);
    
        mockDataMapBuilder.verify('buildPacket', new List<OBject>{pm}, Times.Once);
        mockDataMapBuilder.verify('buildDetails', new List<Object>{pm, requestfields, scheduleFields}, Times.Once);
        mockDataMapBuilder.verify('buildContacts', new List<Object>{pm, contactFields}, Times.Once);
        mockDataMapBuilder.verify('buildAccounts', new List<Object>{pm, accountFields}, Times.Once);
        mockDataMapBuilder.verify('buildContactAccounts', new List<Object>{pm, contactAccountFields}, Times.Once);
    }
}