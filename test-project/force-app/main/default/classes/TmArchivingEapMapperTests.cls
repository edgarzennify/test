@IsTest
private class TmArchivingEapMapperTests {

	private static final TmArchivingEapMapper sut;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfiguration;

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfiguration = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingEapMapper(mockHelper, mockConfiguration);
	}

	@IsTest
    static void it_should_handle_the_eap_recordtype() {
		String product = 'Enterprise accounts payable';
		mockConfiguration.setup('RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES').returns(product);

		String result = sut.handle();

		mockConfiguration.verify('RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES', Times.Once);
		System.assertEquals(product, result);
	}

	@IsTest
    static void it_should_map_fields_from_request_to_tm_service() {
		String product = 'Enterprise accounts payable';
		RecordType r = new RecordType(Name=product);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = new Tm_service_Request__c();
		pm.entityPm = new Account();
		pm.requestPm.RecordType = r;
		List<RecordType> recordTypes = new List<RecordType>{r};
		Treasury_Management__c tms = new Treasury_Management__c(Product_PL__c=r.Name);
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		container.RecordTypes = recordTypes;
		mockConfiguration.setup('RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES').returns(product);
		mockHelper.setup('buildTMObject', new List<Object>{container, product}).returns(tms);

		Treasury_Management__c result = sut.buildTmService(container);

		List<Object> arguments = (List<Object>)mockHelper.getArgumentsFromCall('buildTMObject');
		mockHelper.verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);		
		System.assertNotEquals(null, result);
		System.assertEquals(r.Id, result.RecordTypeId);
		System.assertEquals(product, result.Product_PL__c);
		System.assertEquals((TmArchiving.MapperRequestContainer)arguments[0], container);
		System.assertEquals((String)arguments[1], product);
		System.assertEquals(pm.entityPm.Id, result.Account__c);
	}

	@IsTest
    static void INTEGRATION_Soql_Test() {
		List<String> result = TmArchivingMock.getErrorsOnRunningSoql(sut);
		
		System.assertEquals(0, result.size()); 
	}
}