@IsTest
private class TmArchivingOtherTmProductMapperTests {
	
    private static final TmArchivingOtherTmProductMapper sut;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfiguration;

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfiguration = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingOtherTmProductMapper(mockHelper, mockConfiguration);
    }
    
    @IsTest
    static void it_should_return_true_when_calling_handle() {
		String productName = 'Other TM Product';
		mockConfiguration.setup('RECORDTYPE_OTHER_TM_PRODUCT').returns(productName);

		String result = sut.handle();

		mockConfiguration.verify('RECORDTYPE_OTHER_TM_PRODUCT', Times.Once);
		System.assertEquals(productName, result);
    }
    
    @IsTest
    static void it_should_map_all_fields_for_tm_service() {
		String otherProduct = 'test-product';
		String otherProductDetails = 'test-details';
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.entityPm = new Account();
		pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		pm.serviceAccountPms = new List<Tm_Service_Request_Account__c>();
		pm.requestPm = new Tm_Service_Request__c();
		pm.requestPm.Other_Product__c = otherProduct;
		pm.requestPm.Other_Product_Details__c = otherProductDetails;
		String recordTypeName = 'Other TM Product';
		String svc_recordTypeName = 'Other';
		RecordType r = Utility.recordTypeObject('Treasury_Management__c', svc_recordTypeName);
		List<RecordType> recordTypes = new List<RecordType> {r};
		Treasury_Management__c tm = new Treasury_Management__c();
		tm.RecordTypeId = r.Id;
		tm.Account__c = pm.entityPm.Id;
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		container.RecordTypes = recordTypes;
		mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tm);
        mockConfiguration.setup('RECORDTYPE_OTHER_TM_PRODUCT').returns(recordTypeName);
        mockConfiguration.setup('SVC_PRODUCT_OTHER').returns(svc_recordTypeName);

		Treasury_Management__c result = sut.buildTmService(container);

		List<Object> arguments = (List<Object>)mockHelper.getArgumentsFromCall('buildTMObject');
		mockHelper.verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);		
		System.assertEquals(r.Id, result.RecordTypeId);
		System.assertEquals(otherProduct, result.Product_PL__c);
		System.assertEquals(otherProductDetails, result.Comments__c);
		System.assertEquals((TmArchiving.MapperRequestContainer)arguments[0], container);
		System.assertEquals((String)arguments[1], svc_recordTypeName);
		System.assertEquals(pm.entityPm.Id, result.Account__c);
    }
    
    @IsTest
    static void INTEGRATION_Soql_Test(){
		List<string> result = TmArchivingMock.getErrorsOnRunningSoql(sut);
		
		System.assertEquals(0, result.size()); 
	}
}