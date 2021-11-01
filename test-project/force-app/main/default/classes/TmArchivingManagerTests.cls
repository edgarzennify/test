@IsTest
private class TmArchivingManagerTests {
	
	private static final TmArchivingManager sut;
	private static final TmArchivingMock.ofIMapper mockLockBoxMapper;
	private static final Mock.ofIUtility mockUtil;
	private static final TmBoardingMock.ofIRepository mockRepository;
	private static final TmConfigurationMock.ofIRepository mockConfigRepository;
	private static final TmArchivingMock.ofISmManager mockSmManager;
	private static final TmArchivingMock.ofIConfiguration mockConfig;
	private static final TmArchiving.IRepository mockArchiveRepository;
	private static final TmArchiving.IVmBuilder mockVmBuilder;

	static {
		mockLockBoxMapper = new TmArchivingMock.ofIMapper();
		mockUtil = new Mock.ofIUtility(); 
		mockRepository = new TmBoardingMock.ofIRepository();
		mockConfigRepository = new TmConfigurationMock.ofIRepository();
		mockSmManager = new TmArchivingMock.ofISmManager();
		mockConfig = new TmArchivingMock.ofIConfiguration();
		mockArchiveRepository = new TmArchivingMock.ofIRepository();
		mockVmBuilder = new TmArchivingMock.ofIVmBuilder();
		sut = new TmArchivingManager(new List<TmArchivingMock.ofIMapper>{mockLockBoxMapper}, mockUtil, mockRepository, mockConfigRepository, mockSmManager, mockConfig, mockArchiveRepository, mockVmBuilder);
	}
	
	@IsTest
    static void it_should_do_call_the_repository_to_get_pm() {
		String TmObjName = 'Treasury_Management__c';
		String productName = 'Lockbox';
		Treasury_Management__c tmServiceObj = new Treasury_Management__c();
		tmServiceObj.Id = ObjectFactory.getFakeId(Treasury_Management__c.SObjectType, '4');
		RecordType rt = new RecordType(Name=productName);
		Tm_service_Request__c request = new Tm_service_Request__c();
		request.RecordType = rt;
		request.RecordType.Name = productName;
		TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
		requestPm.requestPm = request;
		List<TM_Service_Contact__c> contacts = new List<TM_Service_Contact__c>();
		List<EB_Account_Service__c> accounts = new List<EB_Account_Service__c>();
		TmArchiving.TreasuryManagementSm sm = new TmArchiving.TreasuryManagementSm();
		sm.contacts = contacts;
		sm.accounts = accounts;
		sm.core = new Treasury_Management__c(Id = tmServiceObj.Id);
		List<TmArchiving.TreasuryManagementSm> sms = new List<TmArchiving.TreasuryManagementSm>{sm};
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();	
		List<RecordType> recordTypes = new List<RecordType>{rt};
		container.Pm = requestPm;
		container.RecordTypes = recordTypes;
		TmArchiving.QueryFields query = new TmArchiving.QueryFields();
		query.requestId = requestPm.requestPm.id;
		query.requestFields = new List<String>();
		query.contactFields = new List<String>();
		query.accountFields = new List<String>();
		query.contactCoreFields = new List<String>();
		query.accountCoreFields = new List<String>();
		query.contactAccountFields = new List<String>();
		mockLockBoxMapper.Setup('handle').returns(productName);
		mockUtil.Setup('recordTypeObjects', new List<Object>{TmObjName}).returns(recordTypes);
		mockLockBoxMapper.Setup('buildTmService', new List<Object>{container}).returns(tmServiceObj);
		mockLockBoxMapper.Setup('build', new List<Object>{container}).returns(tmServiceObj);
		mockLockBoxMapper.Setup('build', new List<Object>{request.Id}).returns(new TmArchiving.QueryFields());
		mockLockBoxMapper.Setup('postProcess', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(sms);
		mockConfigRepository.Setup('getRecordTypeName', new List<Object>{request}).returns(productName);
		mockConfigRepository.Setup('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestPm);

		sut.buildTM(request);

		mockConfigRepository.Verify('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}
	
	@IsTest
    static void it_should_do_call_the_lockbox_mapper_to_build_tm_service_object() {
		String TmObjName = 'Treasury_Management__c';
		String productName = 'Lockbox';
		Treasury_Management__c tmServiceObj = new Treasury_Management__c();
		tmServiceObj.Id = ObjectFactory.getFakeId(Treasury_Management__c.SObjectType, '4');
		RecordType rt = new RecordType(Name=productName);
		Tm_service_Request__c request = new Tm_service_Request__c();
		request.RecordType = rt;
		request.RecordType.Name = productName;
		TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
		requestPm.requestPm = request;
		TmArchiving.TreasuryManagementSm sm = new TmArchiving.TreasuryManagementSm();
		List<TmArchiving.TreasuryManagementSm> sms = new List<TmArchiving.TreasuryManagementSm>();
		List<TM_Service_Contact__c> contacts = new List<TM_Service_Contact__c>();
		List<EB_Account_Service__c> accounts = new List<EB_Account_Service__c>();
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();	
		List<RecordType> recordTypes = new List<RecordType>{rt};
		container.Pm = requestPm;
		container.RecordTypes = recordTypes;
		mockConfig.Setup('RECORDTYPE_LOCKBOX').returns(productName);
		mockLockBoxMapper.Setup('handle').returns(productName);
		mockLockBoxMapper.Setup('build', new List<Object>{request.Id}).returns(new TmArchiving.QueryFields());
		mockLockBoxMapper.Setup('postProcess', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(sms);
		mockUtil.Setup('recordTypeObjects', new List<Object>{TmObjName}).returns(recordTypes);
		mockLockBoxMapper.Setup('buildTmService', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tmServiceObj);
		mockConfigRepository.Setup('getRecordTypeName', new List<Object>{request}).returns(productName);
		mockConfigRepository.Setup('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestPm);

		sut.buildTM(request);

		mockLockBoxMapper.Verify('buildTmService', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_do_call_the_service_mapper_and_pass_the_requestpm_to_get_servicecontacts_and_serviceaccounts() {
		String TmObjName = 'Treasury_Management__c';
		String productName = 'Lockbox';
		Id svcContactId = ObjectFactory.getFakeId(TM_Service_Contact__c.SOBjectType, '1');
		Id svcAccountId = ObjectFactory.getFakeId(EB_Account_Service__c.SOBjectType, '1');
		RecordType rt = new RecordType(Name=productName);
		Tm_service_Request__c request = new Tm_service_Request__c();
		request.RecordType = rt;
		request.RecordType.Name = productName;
		TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
		requestPm.requestPm = request;

		Tm_Service_Request_Contact__c svcContact = new Tm_Service_Request_Contact__c();
		svcContact.Contact__r = new Contact();
		Tm_Service_Request_Account__c svcAccount = new Tm_Service_Request_Account__c();
		svcAccount.Eb_Account__r = new Eb_Account__c();
		requestPm.serviceContactPms = new List<Tm_Service_Request_Contact__c>{svcContact};
		requestPm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{svcAccount};
		Treasury_Management__c tmServiceObj = new Treasury_Management__c();
		List<TM_Service_Contact__c> contacts = new List<TM_Service_Contact__c>{new TM_Service_Contact__c(Id=svcContactId)};
		List<EB_Account_Service__c> accounts = new List<EB_Account_Service__c>{new EB_Account_Service__c(Id=svcAccountId)};
		TmArchiving.TreasuryManagementSm sm = new TmArchiving.TreasuryManagementSm();
		sm.contacts = contacts;
		sm.accounts = accounts;
		sm.core = new Treasury_Management__c(Id = tmServiceObj.Id);
		List<TmArchiving.TreasuryManagementSm> sms = new List<TmArchiving.TreasuryManagementSm>{sm};
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();	
		List<RecordType> recordTypes = new List<RecordType>{rt};
		container.Pm = requestPm;
		container.RecordTypes = recordTypes;
		mockLockBoxMapper.Setup('handle').returns(productName);
		mockLockBoxMapper.Setup('build', new List<Object>{request.Id}).returns(new TmArchiving.QueryFields());
		mockLockBoxMapper.Setup('postProcess', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(sms);
		mockUtil.Setup('recordTypeObjects', new List<Object>{TmObjName}).returns(recordTypes);
		mockLockBoxMapper.Setup('buildTmService', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tmServiceObj);
		mockConfigRepository.Setup('getRecordTypeName', new List<Object>{request}).returns(productName);
		mockConfigRepository.Setup('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestPm);

		sut.buildTM(request);

		mockLockBoxMapper.Verify('buildContacts', new List<Object>{requestPm, tmServiceObj}, Times.Once);
		mockLockBoxMapper.Verify('buildAccounts', new List<Object>{requestPm, tmServiceObj}, Times.Once);
	}

	@IsTest
    static void it_should_do_call_the_repository_to_save_tm_service() {
		String TmObjName = 'Treasury_Management__c';
		String productName = 'Lockbox';
		Treasury_Management__c tmServiceObj = new Treasury_Management__c();
		RecordType rt = new RecordType(Name=productName);
		Tm_service_Request__c request = new Tm_service_Request__c();
		request.RecordType = rt;
		request.RecordType.Name = productName;
		TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
		requestPm.requestPm = request;
		requestPm.serviceAccountPms = new List<Tm_Service_Request_Account__c>();
		TmArchiving.TreasuryManagementSm sm = new TmArchiving.TreasuryManagementSm();
		
		List<TM_Service_Contact__c> contacts = new List<TM_Service_Contact__c>();
		List<EB_Account_Service__c> accounts = new List<EB_Account_Service__c>();
		sm.contacts = contacts;
		sm.accounts = accounts;
		sm.core = new Treasury_Management__c(Id = tmServiceObj.Id);
		List<TmArchiving.TreasuryManagementSm> sms = new List<TmArchiving.TreasuryManagementSm>{sm};
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();	
		List<RecordType> recordTypes = new List<RecordType>{rt};
		container.Pm = requestPm;
		container.RecordTypes = recordTypes;
		mockLockBoxMapper.Setup('handle').returns(productName);
		mockUtil.Setup('recordTypeObjects', new List<Object>{TmObjName}).returns(recordTypes);
		mockLockBoxMapper.Setup('buildTmService', new List<Object>{container}).returns(tmServiceObj);
		mockLockBoxMapper.Setup('build', new List<Object>{request.Id}).returns(new TmArchiving.QueryFields());
		mockLockBoxMapper.Setup('postProcess', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(sms);
		mockConfigRepository.Setup('getRecordTypeName', new List<Object>{request}).returns(productName);
		mockConfigRepository.Setup('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestPm);

		sut.buildTM(request);

		mockRepository.Verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Thrice);
	}

	@IsTest
    static void it_should_do_call_the_repository_to_save_contact_and_accounts() {
		String TmObjName = 'Treasury_Management__c';
		String productName = 'Lockbox';
		Treasury_Management__c tmServiceObj = new Treasury_Management__c();
		tmServiceObj.Id = ObjectFactory.getFakeId(Treasury_Management__c.SObjectType, '4');
		RecordType rt = new RecordType(Name=productName);
		Tm_service_Request__c request = new Tm_service_Request__c();
		request.RecordType = rt;
		request.RecordType.Name = productName;
		TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
		requestPm.requestPm = request;
		requestPm.serviceAccountPms = new List<Tm_Service_Request_Account__c>();
		TmArchiving.TreasuryManagementSm sm = new TmArchiving.TreasuryManagementSm();

		List<TmArchiving.TreasuryManagementSm> sms = new List<TmArchiving.TreasuryManagementSm>{sm};
		TM_Service_Contact__c svcContact = new TM_Service_Contact__c();
		EB_Account_Service__c svcAccount = new EB_Account_Service__c();

		List<TM_Service_Contact__c> contacts = new List<TM_Service_Contact__c>{svcContact};
		List<EB_Account_Service__c> accounts = new List<EB_Account_Service__c>{svcAccount};
		sm.contacts = contacts;
		sm.accounts = accounts;
		sm.core = new Treasury_Management__c(Id = tmServiceObj.Id);
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();	
		List<RecordType> recordTypes = new List<RecordType>{rt};
		container.Pm = requestPm;
		container.RecordTypes = recordTypes;
		mockLockBoxMapper.Setup('handle').returns(productName);
		mockUtil.Setup('recordTypeObjects', new List<Object>{TmObjName}).returns(recordTypes);
		mockLockBoxMapper.Setup('buildTmService', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tmServiceObj);
		mockLockBoxMapper.Setup('build', new List<Object>{request.Id}).returns(new TmArchiving.QueryFields());
		mockLockBoxMapper.Setup('postProcess', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(sms);
		mockConfigRepository.Setup('getRecordTypeName', new List<Object>{request}).returns(productName);
		mockConfigRepository.Setup('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestPm);

		List<TmArchiving.ArchiveReturn> result = sut.buildTM(request);
		
		mockRepository.Verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Thrice);
		mockSmManager.Verify('getTms', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		mockSmManager.Verify('getContactsAndAccounts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		System.assertEquals(tmServiceObj.Id, result[0].archiveId);
	}
}