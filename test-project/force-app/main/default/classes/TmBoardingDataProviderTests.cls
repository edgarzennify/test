@IsTest
private class TmBoardingDataProviderTests {

	private static final TmBoardingDataProvider sut;

	static{
		sut = new TmBoardingDataProvider();
	}

	private static testMethod void  it_should_build_a_request_when_a_request_id_and_relationships_are_provided(){
		Account entity = new Account(Name='test-entity-1');
		insert entity;
		Contact contactObj = new Contact(AccountId = entity.Id, FirstName = 'first', LastName = 'last');
		insert contactObj;
		EB_Account__c account = ObjectFactory.getEbAccount('1122-2', '1122-2', entity);
		account.Application__c = 2;
		update account;
		EB_Account_Relationship__c accountRelationship = new EB_Account_Relationship__c(EB_Account_ID__c = account.Id, Client_Id__c = entity.Id);
		insert accountRelationship;
		TM_Service_Request_Packet__c packet = new TM_Service_Request_Packet__c(Entity__c = entity.Id);
		insert packet;
		TM_Service_Request_Stage__c	stg = new TM_Service_Request_Stage__c(Name = 'New');
		insert stg;
		TM_Service_Request__c request = new TM_Service_Request__c(TM_Service_Request_Packet__c = packet.Id, Stage__c = stg.Id);
		insert request;
		TM_Service_Request_Contact__c relContact = new TM_Service_Request_Contact__c(Contact__c = contactObj.Id, TM_Service_Request__c = request.Id);
		insert relContact;
		TM_Service_Request_Account__c relAccount = new TM_Service_Request_Account__c(EB_Account__c = account.Id, TM_Service_Request__c = request.Id);
		insert relAccount;
		Tm_Service_Request_Contact_Account__c relContactAccount = new Tm_Service_Request_Contact_Account__c();
		relContactAccount.TM_Service_Request_Contact__c = relContact.Id;
		relContactAccount.TM_Service_Request_Account__c = relAccount.Id;
		insert relContactAccount;
		List<String> requestFields = new List<String>{'Id', 'Name', 'TM_Service_Request_Packet__r.Id', 'TM_Service_Request_Packet__r.Name', 'TM_Service_Request_Packet__r.Entity__r.Id'};
		List<String> contactFields = new List<String>{'Id', 'Contact__c', 'TM_Service_Request__c'};
		List<String> accountFields = new List<String>{'Id', 'EB_Account__c', 'TM_Service_Request__c'};
		List<String> contactAccountFields = new List<String>{'Id', 'TM_Service_Request_Account__c', 'TM_Service_Request_Contact__c', 'TM_Service_Request_Contact__r.Contact__r.Id'};
		List<string> contactCoreFields = new List<String>{'Id','AccountId','FirstName','LastName','Name'};
		List<string> accountCoreFields = new List<String>{'EB_Account_Id__r.Id', 'EB_Account_Id__r.Name', 'EB_Account_Id__r.Account_Number__c', 'EB_Account_Id__r.Application__c'};

		TmBoarding.requestPm result = sut.getRequest(request.Id, requestFields, contactFields, accountFields, contactAccountFields, contactCoreFields, accountCoreFields);

		System.assertEquals(request.Id, result.requestPm.Id);
		Object soqlObj;
		soqlObj = result.requestPm;
		soqlObj = result.requestPm.Id;
		soqlObj = result.requestPm.Name;
		soqlObj = result.packetPm;
		soqlObj = result.packetPm.Id;
		soqlObj = result.packetPm.Name;
		soqlObj = result.entityPm;
		soqlObj = result.entityPm.Id;
		soqlObj = result.entityPm.Name;
		soqlObj = result.contactPms;
		soqlObj = result.contactPms[0].Id;
		soqlObj = result.accountPms[0].Id;
		soqlObj = result.accountPms[0].Name;
		soqlObj = result.serviceContactPms[0].Id;
		soqlObj = result.serviceContactPms[0].Contact__c;
		soqlObj = result.serviceContactPms[0].TM_Service_Request__c;
		soqlObj = result.serviceAccountPms[0].EB_Account__c;
		soqlObj = result.serviceAccountPms[0].TM_Service_Request__c;
		soqlObj = result.serviceContactAccountPms[0].TM_Service_Request_Contact__c;
		soqlObj = result.serviceContactAccountPms[0].TM_Service_Request_Account__c;
		soqlObj = result.serviceContactAccountPms[0].TM_Service_Request_Contact__r.Contact__r.Id;
	}

	private static testMethod void it_should_build_packet() {
		Account entity = new Account(Name='test-entity-1');
		insert entity;
		TM_Service_Request_Packet__c packet = new TM_Service_Request_Packet__c(Entity__c = entity.Id);
		insert packet;
		TM_Service_Request_Stage__c	stg = new TM_Service_Request_Stage__c(Name = 'New');
		insert stg;
		TM_Service_Request__c request = new TM_Service_Request__c(TM_Service_Request_Packet__c = packet.Id, Stage__c = stg.Id);
		insert request;

		TmBoarding.requestPm result =  sut.getRequestFromPacket(request);

		System.assertEquals(request.Id ,result.requestPm.Id);
		System.assertEquals(packet.Id ,result.packetPm.Id);
	}

	private static testMethod void it_should_get_an_ebaccount_when_account_number_is_provided() {
		String accountNumber = '1122-2';
		Account entity = new Account(Name='test-entity-1');
		insert entity;
		EB_Account__c eba = ObjectFactory.getEbAccount(accountNumber, accountNumber, entity);
		eba.Application__c = 2;
		update eba;
		List<Eb_Account__c> result = sut.getEbAccount(2, accountNumber);

		System.assertEquals(1, result.size());
		System.assertEquals(accountNumber, result[0].account_number__c);
	}

	private static testMethod void it_should_get_an_ebaccount_when_ebaccountId_is_provided() {
		String accountNumber = '1122-2';
		Account entity = new Account(Name='test-entity-1');
		insert entity;
		EB_Account__c eba = ObjectFactory.getEbAccount(accountNumber, accountNumber, entity);

		Eb_Account__c result = sut.getEbAccount(eba.Id);

		System.assertEquals(eba.id, result.id);
	}

	private static testMethod void it_should_get_an_opportunity_when_id_is_provided() {
		RecordType clientRecordType = utility.RecordTypeObject('Account', 'Client');
        Account entity = new Account(Name = 'test1', EB_Client_Name__c='Buffalo Bill Not BW', Import_Source__c = 'not bw', RecordTypeId = clientRecordType.Id);
        insert entity;
        Opportunity opp = getOpportunity(entity);

		Opportunity result = sut.getOpportunity(opp.id);

		System.assertEquals(opp.id ,result.id);
	}

	private static testMethod void it_should_build_configuration_when_recordType_name_is_provided() {
		String recordTypeName = 'Lockbox';
		Account entity = new Account(Name='test-entity-1');
		insert entity;
		TM_Service_Request_Packet__c packet = new TM_Service_Request_Packet__c(Entity__c = entity.Id);
		insert packet;
		TM_Service_Request_Stage__c	stg = new TM_Service_Request_Stage__c(Name = 'New');
		insert stg;
		RecordType rt = Utility.recordTypeObject('TM_Service_Request__c', recordTypeName);
		TM_Service_Request__c request = new TM_Service_Request__c(TM_Service_Request_Packet__c = packet.Id, Stage__c = stg.Id, RecordTypeId = rt.id);
		insert request;
		TM_Service_Configuration__c cfg = new TM_Service_Configuration__c();
		cfg.Product_Name__c = recordTypeName;
		insert cfg;
		TM_Service_Configuration_Field__c svcField = new TM_Service_Configuration_Field__c();
		svcField.Field_Name__c = 'Name';
		svcField.Object_Name__c = 'TM_Service_Request__c';
		svcField.Service_Options__c = cfg.id;
		insert svcField;

		TmBoarding.RequestConfigPm result = sut.getPageFieldConfigurationsByServiceType(recordTypeName);

		System.assertEquals(1, result.serviceOptionPms.size());
		System.assertEquals('Name', result.serviceOptionPms[0].Field_Name__c);
	}

	private static testMethod void it_should_get_all_packets_from_entity() {
		Account entity = new Account(Name='test-entity-1');
		insert entity;
		TM_Service_Request_Packet__c packet = new TM_Service_Request_Packet__c(Entity__c = entity.Id);
		insert packet;

		List<Tm_Service_Request_Packet__c> result = sut.getPacketsFromEntity(entity.Id);

		System.assertEquals(1, result.size());
		System.assertEquals(entity.id, result[0].Entity__c);
	}

	private static testMethod void it_should_get_stage_when_request_id_is_provided() {
		Account entity = new Account(Name='test-entity-1');
		insert entity;
		TM_Service_Request_Packet__c packet = new TM_Service_Request_Packet__c(Entity__c = entity.Id);
		insert packet;
		TM_Service_Request_Stage__c	stg = new TM_Service_Request_Stage__c(Name = 'New');
		insert stg;
		TM_Service_Request__c request = new TM_Service_Request__c(TM_Service_Request_Packet__c = packet.Id, Stage__c = stg.Id);
		insert request;

		Tm_Service_Request_Stage__c result = sut.getStageForRequest(request.Id);

		System.assertEquals(stg.name ,result.name);
	}


	private static testMethod void it_should_get_valid_stages_for_parent_stage() {
		TM_Service_Request_Stage__c	stg1 = new TM_Service_Request_Stage__c(Name = 'New');
		insert stg1;
		TM_Service_Request_Stage__c	stg2 = new TM_Service_Request_Stage__c(Name = 'Tm support');
		insert stg2;
		Tm_Service_Request_Stage_Relationships__c stgRel = new Tm_Service_Request_Stage_Relationships__c(Parent_Stage__c = stg1.id, Child_Stage__c = stg2.id);
		insert stgRel;

		List<Tm_Service_Request_Stage_Relationships__c> result = sut.getValidStages(stg1);

		System.assertEquals(1, result.size());
		System.assertEquals(stg1.id, result[0].Parent_Stage__c);
		System.assertEquals(stg2.id, result[0].Child_Stage__c);
	}


	private static testMethod void it_should_get_eb_account_by_search_results() {
		String param = '1122';
		Account entity = new Account(Name='test-entity-1');
		insert entity;
		EB_Account__c eba = ObjectFactory.getEbAccount(param, param, entity);
		eba.Account_Number__c = param;
		eba.Application__c = 2;
		update eba;
		List<Eb_Account__c> result = sut.getEbAccountSearchResults(param);

		System.assertEquals(1, result.size());
		System.assertEquals(param, result[0].Account_Number__c);
	}

	private static testMethod void it_should_get_stage_by_stage_name() {
		String stageName = 'New';
		String stageType = 'Default';
		String stagePermssion = 'stage-permission';
		Tm_Service_Request_Stage__c stg = new Tm_Service_Request_Stage__c();
		stg.name = stageName;
		stg.type__c = stageType;
		stg.permission__c = stagePermssion;
		insert stg;

		Tm_Service_Request_Stage__c result = sut.getStageByName(stg.name);

		System.assertEquals(stageName, result.name);
		System.assertEquals(stageType, result.type__c);
		System.assertEquals(stagePermssion, result.Permission__c);
	}

	private static testMethod void it_should_get_the_default_stage() {
		String defaultStage = 'New';
		Tm_Service_Request_Stage__c stg = new Tm_Service_Request_Stage__c(Name = defaultStage, Type__c = 'Default');
		insert stg;

		Tm_Service_Request_Stage__c result =  sut.getDefaultStage();

		System.assertEquals(defaultStage ,result.name);
	}

	private static Opportunity getOpportunity(Account entity) {
        Opportunity opp = new Opportunity();
        RecordType tmRecType = Utility.RecordTypeObject('Opportunity', 'Consumer');
        opp.Name = 'test';
        opp.CloseDate = system.today();
        opp.StageName = 'test stage';
        opp.RecordTypeId = tmRecType.Id;
        opp.AccountId = entity.Id;
        insert opp;
        return opp;
	}

	private static testMethod void it_should_get_request_when_packet_id_is_provided() {
		Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c();
		stage.Name = 'New';
		insert stage;
		Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c();
		insert packet;
		Tm_Service_Request__c req = new Tm_Service_Request__c();
		req.Stage__c = stage.Id;
		req.TM_Service_Request_Packet__c = packet.Id;
		insert req;

		List<Tm_Service_Request__c> result =  sut.getRequestsForPacket(packet.Id);

		System.assertEquals(1 , result.size());
		Object soqlField;
		soqlField = result[0].Id;
		soqlField = result[0].Name;
		soqlField = result[0].RecordTypeId;
		soqlField = result[0].RecordType.Name;
		soqlField = result[0].Stage__c;
		soqlField = result[0].Stage__r.Id;
		soqlField = result[0].Stage__r.Name;
		soqlField = result[0].Stage__r.Type__c;
		soqlField = result[0].Stage__r.Permission__c;
		soqlField = result[0].Stage__r.Auto_Forward_Stage__c;
		soqlField = result[0].Stage__r.Auto_Forward_Stage__r.Name;
		soqlField = result[0].TM_Service_Request_Packet__c;
		soqlField = result[0].TM_Service_Request_Packet__r.Id;
		soqlField = result[0].TM_Service_Request_Packet__r.Name;
		soqlField = result[0].TM_Service_Request_Packet__r.Opportunity__c;
	}
	
	private static testMethod void it_should_get_fields_by_service_type() {
		RecordType recType = Utility.RecordTypeObject('TM_Service_Request__c', 'Lockbox');
		Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c();
		stage.Name = 'New';
		insert stage;
		Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c();
		insert packet;
		Tm_Service_Request__c req = new Tm_Service_Request__c();
		req.Stage__c = stage.Id;
		req.RecordTypeId = recType.Id;
		req.TM_Service_Request_Packet__c = packet.Id;
		insert req;
		TM_Service_Configuration__c config = new TM_Service_Configuration__c();
		config.Product_Name__c = recType.Name;
		insert config;

		TmBoarding.RequestConfigPm result = sut.getPageFieldConfigurationsByServiceType(recType.Name);

		System.assertNotEquals(null , result);
		System.assertEquals(recType.Name, result.productPm.Product_Name__c);
	} 

	private static testMethod void it_should_get_all_configuration_sections() {
		TM_Service_Configuration_Section__c section = new TM_Service_Configuration_Section__c();
		section.name = 'test';
		insert section;

		Map<Id, TM_Service_Configuration_Section__c> result = sut.getConfigSections();

		System.assertEquals(1, result.keyset().size());
		System.assertEquals('test' , result.values()[0].name);
	}

	private static testMethod void it_should_get_all_configuration_section_groups() {
		Tm_Service_Configuration_Section_Group__c sGroup = new Tm_Service_Configuration_Section_Group__c();
		sGroup.Label__c = 'test-lbl';
		insert sGroup;

		Map<Id, Tm_Service_Configuration_Section_Group__c> result =  sut.getConfigSectionGroups();

		System.assertEquals('test-lbl', result.values()[0].Label__c);
	}

	private static testMethod void it_should_get_all_configurations() {
		TM_Service_Configuration__c config = new TM_Service_Configuration__c();
		config.Product_Name__c = 'test';
		insert config;

		List<TM_Service_Configuration__c> result = sut.getAllConfigurations();

		System.assertEquals(1, result.size());
		System.assertEquals('test', config.Product_Name__c);
	}

	private static testMethod void it_should_get_all_page_fields_by_service() {
		String product = 'Lockbox';
		RecordType recType = Utility.RecordTypeObject('TM_Service_Request__c', product);
		Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c();
		stage.Name = 'New';
		insert stage;
		Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c();
		insert packet;
		Tm_Service_Request__c req = new Tm_Service_Request__c();
		req.Stage__c = stage.Id;
		req.RecordTypeId = recType.Id;
		req.TM_Service_Request_Packet__c = packet.Id;
		insert req;
		TM_Service_Configuration__c config = new TM_Service_Configuration__c();
		config.Product_Name__c = recType.Name;
		insert config;

		Map<string, TmBoarding.RequestConfigPm> result =  sut.getAllPageFieldConfigurationsByServiceType();

		System.assertEquals(1, result.keySet().size());
		System.assertEquals(product, result.values()[0].productPm.Product_Name__c);
	} 

	private static testMethod void it_should_get_all_request() {
		String product = 'Lockbox';
		RecordType recType = Utility.RecordTypeObject('TM_Service_Request__c', product);
		Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c();
		stage.Name = 'New';
		insert stage;
		Account entity = new Account();
		entity.Name = 'test-entity';
		insert entity;
		Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c();
		packet.Entity__c = entity.Id;
		insert packet;
		Tm_Service_Request__c req = new Tm_Service_Request__c();
		req.Stage__c = stage.Id;
		req.RecordTypeId = recType.Id;
		req.TM_Service_Request_Packet__c = packet.Id;
		req.TM_Service_Request_Packet__r = packet;
		insert req;

		List<Id> requestIds = new List<Id>{req.Id};
		List<string> requestFields = new List<string>{'Name', 'TM_Service_Request_Packet__r.Entity__r.Id','TM_Service_Request_Packet__r.Entity__r.Name'};
		List<string> contactFields = new List<string>{'Name'};
		List<string> accountFields = new List<string>{'Name'};
		List<string> contactAccountFields = new List<string>();
		List<String> contactCoreFields = new List<string>{'Name'};
		List<String> accountCoreFields = new List<string>{'Name'};

		Map<Id, TmBoarding.requestPm> result = sut.getAllRequests(requestIds, requestFields, contactFields, accountFields, contactAccountFields, contactCoreFields, accountCoreFields);
		
		Tm_Service_Request__c reqReQuery = [SELECT Id, Name FROM TM_Service_Request__c WHERE Id =: req.Id limit 1];
		System.assertEquals(1, result.keyset().size());
		System.assertEquals(reqReQuery.Name, result.values()[0].requestPm.Name);
	}

	private static testMethod void it_should_get_all_stages() {
		Tm_Service_Request_Stage__c stg = new Tm_Service_Request_Stage__c();
		stg.Name = 'New';
		stg.Permission__c = 'New-Permission';
		insert stg;

		List<Tm_Service_Request_Stage__c> result = sut.getAllStages();

		Object fieldObject;
		fieldObject = result[0].Id;
		fieldObject = result[0].Name;
		fieldObject = result[0].Type__c;
		fieldObject = result[0].Permission__c;
	} 

	private static testMethod void it_should_get_user_to_account_centric_data() {
		Account e = new Account(Name='test-entity');
		insert e;
		Eb_Account__c a = new Eb_Account__c(Name='test-eb-account');
		a.Primary_Owner_Id__c = e.Id;
		insert a;
		Contact c1 = new Contact(AccountId = e.Id, LastName = 'c1-name');
		insert c1;
		Contact c2 = new Contact(AccountId = e.Id, LastName = 'c2-name', Active_Contact__c = false);
		insert c2;
		TM_Service_Request_Packet__c packet = new TM_Service_Request_Packet__c(Name='test-packet');
		packet.Entity__c = e.Id;
		insert packet;
		TM_Service_Request__c r1 = new TM_Service_Request__c();
		r1.TM_Service_Request_Packet__c = packet.Id;
		insert r1;
		TM_Service_Request__c r2 = new TM_Service_Request__c();
		r2.TM_Service_Request_Packet__c = packet.Id;
		insert r2;
		Tm_Service_Request_Contact__c svc1 = new Tm_Service_Request_Contact__c();
		svc1.TM_Service_Request__c = r1.Id;
		svc1.Contact__c = c1.Id;
		insert svc1;
		Tm_Service_Request_Contact__c svc2 = new Tm_Service_Request_Contact__c();
		svc2.TM_Service_Request__c = r2.Id;
		svc2.Contact__c = c2.Id;
		insert svc2;
		Tm_Service_Request_Account__c sva1 = new Tm_Service_Request_Account__c();
		sva1.EB_Account__c = a.Id;
		sva1.TM_Service_Request__c = r1.Id;
		insert sva1;

		List<TmBoarding.RequestPm> result = sut.getUserCentricAccountsForPacket(packet.Id);

		TmBoarding.RequestPm resultObj = result[0];
		Object fieldObj = resultObj.requestPm;
		fieldObj = resultObj.requestPm.RecordType.Name;
		fieldObj = resultObj.contactPms[0].LastName;
		fieldObj = resultObj.accountPms[0].Name;

		System.assertEquals('c1-name', resultObj.contactPms[0].LastName);
	}

	private static testMethod void it_should_get_request_with_related_items() {
		Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c();
		stage.Name = 'New';
		insert stage;
		Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c();
		insert packet;
		Tm_Service_Request__c req = new Tm_Service_Request__c();
		req.Stage__c = stage.Id;
		req.TM_Service_Request_Packet__c = packet.Id;
		insert req;

		TM_Service_Request__c result = sut.getPacketFromRequest(req);

		Object fieldObj = result.id;
		fieldObj = result.TM_Service_Request_Packet__c;
		fieldObj = result.TM_Service_Request_Packet__r.Name;
		fieldObj = result.TM_Service_Request_Packet__r.Entity__r.Id;
		fieldObj = result.TM_Service_Request_Packet__r.Entity__r.Name;
		fieldObj = result.TM_Service_Request_Packet__r.Entity__r.Date_TM_Master_Agmt_Signed__c;
		fieldObj = result.TM_Service_Request_Packet__r.Entity__c;
		fieldObj = result.TM_Service_Request_Packet__r.Opportunity__c;
	}

	private static testMethod void it_should_build_request_pm_with_related_accounts(){
		Account entity = new Account(Name='entity 1');
		insert entity;
		Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c();
		insert packet;
		Tm_Service_Request__c req = new Tm_Service_Request__c();
		req.TM_Service_Request_Packet__c = packet.Id;
		insert req;

		Id requestId = req.id;
		List<string> requestFields = new List<String>{'Name','TM_Service_Request_Packet__c,TM_Service_Request_Packet__r.Id,TM_Service_Request_Packet__r.Entity__r.Id'};
		List<string> contactFields = new List<String>{'Name'};
		List<string> accountFields = new List<String>{'Name','EB_Account__r.Id','EB_Account__r.Name','TM_Service_Request__c','TM_Service_Request_Account__c.Master_Account__c','TM_Service_Request_Account__c.IsZBAaccount__c'};
		List<string> contactAccountFields = new List<String>{'Name'};
		List<String> contactCoreFields = new List<String>{'Name'};
		List<String> accountCoreFields = new List<String>{'Name','Id','EB_Account_Id__r.Id', 'EB_Account_Id__r.Name', 'EB_Account_Id__r.Account_Number__c', 'EB_Account_Id__r.Application__c', 'EB_Account_Id__r.Account_Line_1__c', 'EB_Account_Id__r.ApplicationDescription__c', 'EB_Account_Id__r.Fee_Master_Account__c'};
		List<String> entityIds = new List<String>{entity.id};

		TmBoarding.requestPm result = sut.getRequestWithRelatedEbAccounts(requestId, entityIds, requestFields, contactFields, accountFields, contactAccountFields, contactCoreFields, accountCoreFields);

		Object fieldObject = result.requestPm.Id;
		fieldObject = result.requestPm.Name;
	}
}