@IsTest
private class TmArchivingPositivePayMapperTests {
	
	private static final TmArchivingPositivePayMapper sut;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfiguration;

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfiguration = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingPositivePayMapper(mockHelper,mockConfiguration);
	}

	@IsTest
    static void it_should_handle_positive_pay() {
		String productName = 'Positive Pay';
		mockConfiguration.setup('RECORDTYPE_POSITIVE_PAY').returns(productName);

		String result = sut.handle();

		mockConfiguration.verify('RECORDTYPE_POSITIVE_PAY', Times.Once);
		System.assertEquals(productName ,result);
	}

	@IsTest
    static void it_should_map_fields_for_creating_service_obj() {
		String productName = 'Positive Pay';
		String CONVENTIONAL = 'Conventional';
		String OTHER = 'Other';
		Id ebAccountId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');
		EB_Account__c acct = new EB_Account__c(Id = ebAccountId);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		RecordType r = Utility.recordTypeObject('Treasury_Management__c', 'Positive Pay');
		List<RecordType> recordTypes = new List<RecordType> {r};
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		pm.requestPm = new Tm_Service_Request__c(Positive_Pay_Type__c = CONVENTIONAL, Accounting_Software_Type__c = Other, Other_Software__c='test');
		container.RecordTypes = recordTypes;
		Treasury_Management__c tsv = new Treasury_Management__c();

		mockConfiguration.setup('RECORDTYPE_POSITIVE_PAY').returns(productName);
		mockConfiguration.setup('CONVENTIONAL').returns(CONVENTIONAL);
		mockConfiguration.setup('OTHER').returns(OTHER);
		mockConfiguration.setup('POSITIVE_PAY_CONVENTIONAL').returns(CONVENTIONAL);
		mockHelper.setup('compare', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(true);
		mockHelper.setup('buildTMObject', new List<Object>{container, productName}).returns(tsv);
		mockHelper.setup('getFeeAccount', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(acct.Id);
		
		Treasury_Management__c result = sut.buildTmService(container);

		System.assertEquals(CONVENTIONAL, result.Product_PL__c);
	}

	@IsTest
    static void it_should_build_service_contacts() {
		Contact c = new Contact();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		Treasury_Management__c tm = new Treasury_Management__c();
		Tm_Service_Request_Contact__c cr = new Tm_Service_Request_Contact__c(Contact__r = c, Contact__c = c.Id);

		pm.serviceContactPms = new List<Tm_Service_Request_Contact__c>{cr};

		List<TM_Service_Contact__c> result = sut.buildContacts(pm, tm);

		System.assertEquals(1, result.size());
		System.assertEquals(c.Id, result[0].Contact__c);
	}

	@IsTest
    static void it_should_build_service_accounts() {
		Eb_Account__c a = new Eb_Account__c(Fee_Master_Account__c = true);
		Tm_Service_Request_Account__c ar = new Tm_Service_Request_Account__c();
		ar.Eb_Account__r = a;
		ar.Eb_Account__c = a.id;
		ar.Product_Fee_Account__c = true;
		Tmboarding.RequestPm pm = new Tmboarding.RequestPm();
		pm.requestPm = new Tm_Service_Request__c();
		pm.requestPm.Conventional_Positive_Pay_Fee__c = 30.00;
		pm.requestPm.TM_Fee__c = true;
		pm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{ar};
		Treasury_Management__c tm = new Treasury_Management__c(Positive_Pay_Actual__c = 30.00);

		List<EB_Account_Service__c> result = sut.buildAccounts(pm, tm);

		System.assertEquals(1, result.size());
		System.assertEquals(30.00, result[0].Service_Charge__c);
	}

	@IsTest
    static void INTEGRATION_Soql_Test(){
		List<string> result = TmArchivingMock.getErrorsOnRunningSoql(sut);
		
		System.assertEquals(0, result.size()); 
	}
}