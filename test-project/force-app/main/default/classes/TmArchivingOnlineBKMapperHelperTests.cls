@IsTest
private class TmArchivingOnlineBKMapperHelperTests {
  
    private static final TmArchivingOnlineBKMapperHelper sut;
    private static final TmArchivingMock.ofIMapper mockAchMapper;
    private static final TmArchivingMock.ofIMapper mockWiresMapper;
    private static final TmConfigurationMock.ofIRepository mockRepository;
    private static final TmArchivingMock.ofIConfiguration mockConfiguration;

    static {
        mockAchMapper = new TmArchivingMock.ofIMapper();
        mockWiresMapper = new TmArchivingMock.ofIMapper();
        mockRepository = new TmConfigurationMock.ofIRepository();
        mockConfiguration = new TmArchivingMock.ofIConfiguration();
        sut = new TmArchivingOnlineBKMapperHelper(mockAchMapper, mockWiresMapper, mockRepository, mockConfiguration);
    }

    @IsTest
    static void it_should_return_null_when_get_ach_request_is_called_with_no_packets() {
        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();

        TmBoarding.RequestPm results = sut.getAchRequestPm(container);

        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_get_ach_when_calling_get_ach_request_pm() {
        TmArchiving.QueryFields fields = new TmArchiving.QueryFields();
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        container.Pm = new TmBoarding.RequestPm();

        Tm_Service_Request__c ach = new Tm_Service_Request__c();
        String recordTypeName = 'ACH';
        
        RecordType r = Utility.recordTypeObject('TM_Service_Request__c', recordTypeName);
        ach.RecordType = r;
        ach.RecordTypeId = r.Id;
        ach.Id = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '3');

        container.Pm.packetRequestsPm = new List<Tm_Service_Request__c>{ach};

        mockConfiguration.setup('RECORDTYPE_ACH').returns(recordTypeName);
        mockAchMapper.setup('build', new List<Object>{ach.Id}).returns(fields);
        mockRepository.setup('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(pm);

        TmBoarding.RequestPm results = sut.getAchRequestPm(container);

        System.assertNotEquals(null, results);
        mockConfiguration.verify('RECORDTYPE_ACH', Times.Once);
        mockAchMapper.verify('build', new List<Object>{ach.Id}, Times.Once);
        mockRepository.verify('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

     @IsTest
    static void it_should_return_null_when_get_wires_request_is_called_with_no_packets() {
        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();

        TmBoarding.RequestPm results = sut.getWiresRequestPm(container);

        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_get_wires_when_calling_get_wires_request_pm() {
        TmArchiving.QueryFields fields = new TmArchiving.QueryFields();
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        container.Pm = new TmBoarding.RequestPm();

        Tm_Service_Request__c ach = new Tm_Service_Request__c();
        String recordTypeName = 'ACH';
        
        RecordType r = Utility.recordTypeObject('TM_Service_Request__c', recordTypeName);
        ach.RecordType = r;
        ach.RecordTypeId = r.Id;
        ach.Id = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '3');

        container.Pm.packetRequestsPm = new List<Tm_Service_Request__c>{ach};

        mockConfiguration.setup('RECORDTYPE_WIRES').returns(recordTypeName);
        mockWiresMapper.setup('build', new List<Object>{ach.Id}).returns(fields);
        mockRepository.setup('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(pm);

        TmBoarding.RequestPm results = sut.getWiresRequestPm(container);

        System.assertNotEquals(null, results);
        mockConfiguration.verify('RECORDTYPE_WIRES', Times.Once);
        mockWiresMapper.verify('build', new List<Object>{ach.Id}, Times.Once);
        mockRepository.verify('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }
}