@IsTest
private class TmArchivingAchPositivePayMapperTests {

	private static final TmArchivingAchPositivePayMapper sut;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfiguration; 

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfiguration = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingAchPositivePayMapper(mockHelper,mockConfiguration);
	}

	@IsTest
    static void it_should_return_true_when_calling_handle() {
		String productName = 'ACH Positive Pay';
		mockConfiguration.Setup('RECORDTYPE_ACH_POSITIVE_PAY').returns(productName);

		String result = sut.handle();

		mockConfiguration.Verify('RECORDTYPE_ACH_POSITIVE_PAY', Times.Once);
		System.assertEquals(productName, result);
	}

	@IsTest
    static void it_should_map_fields_to_tm_service() {
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.entityPm = new Account();
		pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		String recordTypeName = 'ACH Positive Pay';
		pm.requestPm = new Tm_Service_Request__c();
		RecordType r = new RecordType(Name = recordTypeName);
		List<RecordType> recordTypes = new List<RecordType> {r};
		Treasury_Management__c tm = new Treasury_Management__c();
		tm.RecordTypeId = r.Id;
		tm.Product_PL__c = r.Name;
		tm.Account__c = pm.entityPm.Id;
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		container.RecordTypes = recordTypes;
		mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tm);
		mockConfiguration.Setup('RECORDTYPE_ACH_POSITIVE_PAY').returns(recordTypeName);
		
		Treasury_Management__c result = sut.buildTmService(container);

		List<Object> arguments = (List<Object>)mockHelper.getArgumentsFromCall('buildTMObject');

		mockHelper.Verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);		
		System.assertNotEquals(null, result);
		System.assertEquals(r.Id, result.RecordTypeId);
		System.assertEquals('ACH Positive Pay', result.Product_PL__c);
		System.assertEquals((TmArchiving.MapperRequestContainer)arguments[0], container);
		System.assertEquals((String)arguments[1], recordTypeName);
		System.assertEquals(pm.entityPm.Id, result.Account__c);
	}
	
	@IsTest
    static void INTEGRATION_Soql_Test(){
		List<String> result = TmArchivingMock.getErrorsOnRunningSoql(sut);
		System.assertEquals(0, result.size()); 
	}
}