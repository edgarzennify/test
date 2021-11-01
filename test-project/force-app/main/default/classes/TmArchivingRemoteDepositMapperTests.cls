@isTest
private class TmArchivingRemoteDepositMapperTests {
	
	/*private static final TmArchivingRemoteDepositDesktopMapper sut;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfiguration;

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfiguration = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingRemoteDepositDesktopMapper(mockHelper, mockConfiguration);
	}

	private static testMethod void it_should_return_handle_remote_deposit() {
		String productName = 'Remote Deposit';
		mockConfiguration.setup('RECORDTYPE_REMOTE_DEPOSIT').returns(productName);

		String result = sut.handle();

		System.assertEquals(productName, result);
	}

	private static testMethod void it_should_map_fields_for_tm_service_for_remote_desktop() {
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.entityPm = new Account();
		pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		String recordTypeName = 'Remote Deposit';
		RecordType r = Utility.recordTypeObject('Treasury_Management__c', recordTypeName);
		List<RecordType> recordTypes = new List<RecordType> {r};
		Treasury_Management__c tm = new Treasury_Management__c();
		tm.RecordTypeId = r.Id;
		tm.Product_PL__c = r.Name;
		tm.Account__c = pm.entityPm.Id;
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		container.RecordTypes = recordTypes;
		container.pm.requestPm = new Tm_service_Request__c(RemoteDeposit_Desktop__c = true);
		mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tm);
		mockConfiguration.setup('RECORDTYPE_REMOTE_DEPOSIT').returns(recordTypeName);
		mockConfiguration.setup('REMOTE_DEPOSIT_DESKTOP').returns('desktop');
		mockConfiguration.setup('REMOTE_DEPOSIT_MOBILE').returns('mobile');

		Treasury_Management__c result = sut.buildTmService(container);

		mockConfiguration.verify('RECORDTYPE_REMOTE_DEPOSIT').once();
		mockConfiguration.verify('REMOTE_DEPOSIT_DESKTOP').once();

		List<Object> arguments = (List<Object>)mockHelper.getArgumentsFromCall('buildTMObject');
		mockHelper.verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).once();		
		System.assertNotEquals(null, result);
		System.assertEquals(r.Id, result.RecordTypeId);
		System.assertEquals('desktop', result.Product_PL__c);
		System.assertEquals((TmArchiving.MapperRequestContainer)arguments[0], container);
		System.assertEquals((String)arguments[1], recordTypeName);
		System.assertEquals(pm.entityPm.Id, result.Account__c);
	}

	private static testMethod void it_should_map_fields_for_tm_service_for_remote_mobile() {
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.entityPm = new Account();
		pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		String recordTypeName = 'Remote Deposit';
		RecordType r = Utility.recordTypeObject('Treasury_Management__c', recordTypeName);
		List<RecordType> recordTypes = new List<RecordType> {r};
		Treasury_Management__c tm = new Treasury_Management__c();
		tm.RecordTypeId = r.Id;
		tm.Product_PL__c = r.Name;
		tm.Account__c = pm.entityPm.Id;
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		container.RecordTypes = recordTypes;
		container.pm.requestPm = new Tm_service_Request__c(RemoteDeposit_Mobile__c = true);
		mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tm);
		mockConfiguration.setup('RECORDTYPE_REMOTE_DEPOSIT').returns(recordTypeName);
		mockConfiguration.setup('REMOTE_DEPOSIT_DESKTOP').returns('desktop');
		mockConfiguration.setup('REMOTE_DEPOSIT_MOBILE').returns('mobile');

		Treasury_Management__c result = sut.buildTmService(container);

		mockConfiguration.verify('RECORDTYPE_REMOTE_DEPOSIT').once();
		mockConfiguration.verify('REMOTE_DEPOSIT_MOBILE').once();

		List<Object> arguments = (List<Object>)mockHelper.getArgumentsFromCall('buildTMObject');
		mockHelper.verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).once();		
		System.assertNotEquals(null, result);
		System.assertEquals(r.Id, result.RecordTypeId);
		System.assertEquals('mobile', result.Product_PL__c);
		System.assertEquals((TmArchiving.MapperRequestContainer)arguments[0], container);
		System.assertEquals((String)arguments[1], recordTypeName);
		System.assertEquals(pm.entityPm.Id, result.Account__c);
	}

	private static testMethod void it_should_build_query() {
        Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');

        TmArchiving.QueryFields result = sut.build(requestId);

        System.assertEquals(requestId, result.requestId);
        System.assertEquals(23 ,result.requestFields.size());
        System.assertEquals(12 ,result.contactFields.size());
        System.assertEquals(12 ,result.accountFields.size());
        System.assertEquals(0 ,result.contactAccountFields.size());
        System.assertEquals(10 ,result.contactCoreFields.size());
        System.assertEquals(5 ,result.accountCoreFields.size());
    }

    private static testMethod void it_should_build_service_contacts() {
        Contact c = new Contact();
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        Treasury_Management__c tm = new Treasury_Management__c();
        Tm_Service_Request_Contact__c cr = new Tm_Service_Request_Contact__c(Contact__r = c, Contact__c = c.Id);

        pm.serviceContactPms = new List<Tm_Service_Request_Contact__c>{cr};

        List<TM_Service_Contact__c> result = sut.buildContacts(pm, tm);

        System.assertEquals(1, result.size());
        System.assertEquals(c.Id, result[0].Contact__c);
    }

    private static testMethod void it_should_build_service_accounts() {
        Eb_Account__c a = new Eb_Account__c(Fee_Master_Account__c = true);
        Tm_Service_Request_Account__c ar = new Tm_Service_Request_Account__c();
        ar.Eb_Account__r = a;
        ar.Eb_Account__c = a.id;
        ar.Daily_Deposit_Limit__c = 100.00;

        Tmboarding.RequestPm pm = new Tmboarding.RequestPm();
        pm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{ar};
        Treasury_Management__c tm = new Treasury_Management__c();

        List<EB_Account_Service__c> result = sut.buildAccounts(pm, tm);

        System.assertEquals(1, result.size());
        System.assertEquals(tm.id, result[0].TM_Service__c);
    }*/
}