@IsTest
private class TmArchivingLnInvstmtSweepMapperTests {
	
	private static final TmArchivingLnInvstmtSweepMapper sut;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfiguration;

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfiguration = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingLnInvstmtSweepMapper(mockHelper,mockConfiguration);
	}

	@IsTest
    static void it_should_return_true_when_calling_handle() {
		String productName = 'Loan Investment Sweep';
		mockConfiguration.setup('RECORDTYPE_LOAN_INVESTMENT_SWEEP').returns(productName);

		String result = sut.handle();

		mockConfiguration.verify('RECORDTYPE_LOAN_INVESTMENT_SWEEP', Times.Once);
		System.assertEquals(productName, result);
	}

	@IsTest
    static void it_should_map_all_fields_for_tm_service() {
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.entityPm = new Account();
		pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		pm.requestPm = new Tm_Service_Request__c();
		String recordTypeName = 'Loan Investment Sweep';
		RecordType r = new RecordType(Name = recordTypeName);
		pm.requestPm.RecordType = r;
		pm.requestPm.LoanInvestment_Sweep__c = true;
		List<RecordType> recordTypes = new List<RecordType> {r};
		Treasury_Management__c tm = new Treasury_Management__c();
		tm.Account__c = pm.entityPm.Id;
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		container.RecordTypes = recordTypes;
		Date mdt= Date.newInstance(2011, 7, 26);
		String accountNumber = '1122-2';
		Eb_Account__c a = new Eb_Account__c(Name='800000', Account_Number__c = accountNumber, Maturity_Date__c = mdt);
		mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tm);
		mockHelper.setup('getLoanAccount', new List<Object>{container.Pm}).returns(a);
		mockConfiguration.setup('RECORDTYPE_LOAN_INVESTMENT_SWEEP').returns(recordTypeName);

		Treasury_Management__c result = sut.buildTmService(container);

		List<Object> arguments = (List<Object>)mockHelper.getArgumentsFromCall('buildTMObject');
		mockHelper.verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);		
		System.assertNotEquals(null, result);
		System.assertEquals((TmArchiving.MapperRequestContainer)arguments[0], container);
		System.assertEquals((String)arguments[1], recordTypeName);
		System.assertEquals(pm.entityPm.Id, result.Account__c);
		System.assertEquals(accountNumber ,result.LOC_Number__c);
		System.assertEquals(mdt ,result.LOC_Maturity_Date__c);
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
		ar.Sweep_Investment_Account_Number__c = true;
		Tmboarding.RequestPm pm = new Tmboarding.RequestPm();
		pm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{ar};
		Treasury_Management__c tm = new Treasury_Management__c();

		List<EB_Account_Service__c> result = sut.buildAccounts(pm, tm);

		System.assertEquals(1, result.size());
		System.assertEquals(tm.id, result[0].TM_Service__c);
		System.assertEquals(ar.Sweep_Investment_Account_Number__c, result[0].Sweep_Investment_Account__c);
	}
	
	@IsTest
    static void INTEGRATION_Soql_Test() {
		List<String> result = TmArchivingMock.getErrorsOnRunningSoql(sut);		
		System.assertEquals(0, result.size());
	}
}