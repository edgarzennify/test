@IsTest
private class TmBoardingSmBuilderTests {

	private static final TmBoardingSmBuilder sut;
	private static TmBoardingMock.ofISmBuilderHelper m_smBuilderHelper;
	private static TmBoardingMock.ofISmExtractor m_smExtractor;
	private static TmBoardingMock.ofIFieldMapManager m_FieldMapper;
	private static Mock.ofIUtility m_util;

	static {
		m_smExtractor = new TmBoardingMock.ofISmExtractor();
		m_FieldMapper = new TmBoardingMock.ofIFieldMapManager();
		m_util = new Mock.ofIUtility();
		sut = new TmBoardingSmBuilder( m_smExtractor, m_FieldMapper, m_util);
	}

	private static testMethod void it_should_update_the_edited_service_contact() {
		String serviceRequestObjectName = 'tm_service_request_contact__c';
		TmBoarding.RelatedSm existingRelatedSm = new TmBoarding.RelatedSm();
		existingRelatedSm.contactRelationships = new List<TM_Service_Request_Contact__c>();
		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();

		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		Id serviceContactId = ObjectFactory.getFakeId(TM_Service_Request_Contact__c.SObjectType, '1');
		TM_Service_Request__c request = new TM_Service_Request__c(Id=requestId);
		Contact c = new Contact(Id=contactId);
		TM_Service_Request_Contact__c serviceContact = new TM_Service_Request_Contact__c(Id = serviceContactId);
		serviceContact.Contact__r = c;
		serviceContact.Contact__c = c.Id;
		existingRelatedSm.contactRelationships.add(serviceContact);
		
		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		sm1.fieldName = 'TM_Service_Request_Contact__c.Access_Level__c';
		sm1.FieldValue = (Object) 'Supervisor / Manage Users';
		sm1.ObjectId = String.valueOf(serviceContactId);
		TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
		sm2.FieldName = 'TM_Service_Request_Contact__c.User_Special_Instructions__c';
		sm2.FieldValue = (Object) 'test-data';
		sm2.ObjectId = String.valueOf(serviceContactId);

		sms.add(sm1);
		sms.add(sm2);

		Map<String, List<TmBoarding.SaveSm>> requestContactSms = new Map<String, List<TmBoarding.SaveSm>>();
		requestContactSms.put(String.valueOf(serviceContactId), sms);
		Schema.SObjectField fldAccess_Level = getField(serviceRequestObjectName, 'Access_Level__c');
		Schema.SObjectField fldUser_Special_Instructions = getField(serviceRequestObjectName, 'User_Special_Instructions__c');
		m_smExtractor.setup('getObjectsById', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestContactSms);
		m_smExtractor.setup('getValidField' , new List<Object>{sm1}).returns('Access_Level__c');
		m_smExtractor.setup('getValidField' , new List<Object>{sm2}).returns('User_Special_Instructions__c');
		m_FieldMapper.setup('getField', new List<Object>{serviceRequestObjectName, 'Access_Level__c'}).returns(fldAccess_Level);
		m_FieldMapper.setup('getField', new List<Object>{serviceRequestObjectName, 'User_Special_Instructions__c'}).returns(fldUser_Special_Instructions);
		m_FieldMapper.setup('convert', new List<Object>{fldAccess_Level, sm1.FieldValue} ).returns(sm1.FieldValue);
		m_FieldMapper.setup('convert', new List<Object>{fldUser_Special_Instructions, sm2.FieldValue} ).returns(sm2.FieldValue);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fldAccess_Level}).returns(true);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fldUser_Special_Instructions}).returns(true);
		
		TmBoarding.RelatedSm result = sut.buildEditServiceContact(existingRelatedSm, sms, pm);
		
		System.assertEquals(1 ,result.contactRelationships.size());
		System.assertEquals('Supervisor / Manage Users' ,result.contactRelationships[0].Access_Level__c);
		System.assertEquals('test-data' ,result.contactRelationships[0].User_Special_Instructions__c);
	}

	private static testMethod void it_should_remove_edit_request_countact_id_from_delete_if_present_in_sm(){
		String serviceRequestObjectName = 'tm_service_request_contact__c';
		TmBoarding.RelatedSm existingRelatedSm = new TmBoarding.RelatedSm();
		existingRelatedSm.deleteContactRelationships = new List<TM_Service_Request_Contact__c>();
		existingRelatedSm.contactRelationships = new List<TM_Service_Request_Contact__c>();
		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.serviceContactPms = new List<TM_Service_Request_Contact__c>();
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		Id serviceContactId = ObjectFactory.getFakeId(TM_Service_Request_Contact__c.SObjectType, '1');
		TM_Service_Request__c request = new TM_Service_Request__c(Id=requestId);
		Contact c = new Contact(Id=contactId);
		TM_Service_Request_Contact__c serviceContact = new TM_Service_Request_Contact__c(Id = serviceContactId);
		serviceContact.Contact__r = c;
		serviceContact.Contact__c = c.Id;
		existingRelatedSm.deleteContactRelationships.add(serviceContact);
		pm.serviceContactPms.add(serviceContact);
		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		sm1.fieldName = 'TM_Service_Request_Contact__c.Access_Level__c';
		sm1.FieldValue = (Object) 'Supervisor / Manage Users';
		sm1.ObjectId = String.valueOf(serviceContactId);
		sms.add(sm1);
		Map<String, List<TmBoarding.SaveSm>> requestContactSms = new Map<String, List<TmBoarding.SaveSm>>();
		requestContactSms.put(String.valueOf(serviceContactId), sms);
		Schema.SObjectField fldAccess_Level = getField(serviceRequestObjectName, 'Access_Level__c');
		
		m_smExtractor.setup('getObjectsById', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestContactSms);
		m_smExtractor.setup('getValidField' , new List<Object>{sm1}).returns('Access_Level__c');
		m_FieldMapper.setup('getField', new List<Object>{serviceRequestObjectName, 'Access_Level__c'}).returns(fldAccess_Level);
		m_FieldMapper.setup('convert', new List<Object>{fldAccess_Level, sm1.FieldValue} ).returns(sm1.FieldValue);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fldAccess_Level}).returns(true);
		
		TmBoarding.RelatedSm result = sut.buildEditServiceContact(existingRelatedSm, sms, pm);

		System.assertEquals(0, result.deleteContactRelationships.size());
		System.assertEquals(1, result.contactRelationships.size());
		System.assertEquals('Supervisor / Manage Users' ,result.contactRelationships[0].Access_Level__c);
	}

	private static testMethod void it_should_update_the_edited_service_contact_when_service_contact_Id_does_not_exist() {
		String serviceRequestObjectName = 'tm_service_request_contact__c';
		TmBoarding.RelatedSm existingRelatedSm = new TmBoarding.RelatedSm();
		existingRelatedSm.contactRelationships = new List<TM_Service_Request_Contact__c>();
		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();

		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		pm.requestPm = new TM_Service_Request__c(Id=requestId);
		Contact c = new Contact(Id=contactId);
		String contactIdStr = String.valueOf(c.Id);
		
		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		sm1.fieldName = 'TM_Service_Request_Contact__c.Access_Level__c';
		sm1.FieldValue = (Object) 'Supervisor / Manage Users';
		sm1.ObjectId = '';
		sm1.ParentId = contactIdStr;

		sms.add(sm1);

		Map<String, List<TmBoarding.SaveSm>> requestContactSms = new Map<String, List<TmBoarding.SaveSm>>();
		requestContactSms.put(contactIdStr, sms);
		Schema.SObjectField fldAccess_Level = getField(serviceRequestObjectName, 'Access_Level__c');
		m_smExtractor.setup('getNewObjectsByParentId', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestContactSms);
		m_smExtractor.setup('getValidField' , new List<Object>{sm1}).returns('Access_Level__c');
		m_FieldMapper.setup('getField', new List<Object>{serviceRequestObjectName, 'Access_Level__c'}).returns(fldAccess_Level);
		m_FieldMapper.setup('convert', new List<Object>{fldAccess_Level, sm1.FieldValue} ).returns(sm1.FieldValue);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fldAccess_Level}).returns(true);
		
		TmBoarding.RelatedSm result = sut.buildEditServiceContact(existingRelatedSm, sms, pm);
		
		System.assertEquals(1 ,result.contactRelationships.size());
		System.assertEquals(contactId ,result.contactRelationships[0].Contact__c);
		System.assertEquals(requestId ,result.contactRelationships[0].Tm_service_Request__c);
		System.assertEquals('Supervisor / Manage Users' ,result.contactRelationships[0].Access_Level__c);
	}

	private static testMethod void it_should_update_the_edited_service_account_when_service_account_Id_does_not_exist() {
		String serviceRequestObjectName = 'tm_service_request_account__c';
		TmBoarding.RelatedSm existingRelatedSm = new TmBoarding.RelatedSm();
		existingRelatedSm.accountRelationships = new List<TM_Service_Request_Account__c>();
		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();

		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		pm.requestPm = new TM_Service_Request__c(Id=requestId);
		Eb_Account__c a = new Eb_Account__c(Id=accountId);
		String accountIdStr = String.valueOf(a.Id);
		
		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		sm1.fieldName = 'TM_Service_Request_Account__c.Master_Account__c';
		sm1.FieldValue = (Object) true;
		sm1.ObjectId = '';
		sm1.ParentId = accountIdStr;

		sms.add(sm1);

		Map<String, List<TmBoarding.SaveSm>> requestContactSms = new Map<String, List<TmBoarding.SaveSm>>();
		requestContactSms.put(accountIdStr, sms);
		Schema.SObjectField fld = getField(serviceRequestObjectName, 'Master_Account__c');
		m_smExtractor.setup('getNewObjectsByParentId', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestContactSms);
		m_smExtractor.setup('getValidField' , new List<Object>{sm1}).returns('Master_Account__c');
		m_FieldMapper.setup('getField', new List<Object>{serviceRequestObjectName, 'Master_Account__c'}).returns(fld);
		m_FieldMapper.setup('convert', new List<Object>{fld, sm1.FieldValue} ).returns(sm1.FieldValue);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fld}).returns(true);
		
		TmBoarding.RelatedSm result = sut.buildEditServiceAccount(existingRelatedSm, sms, pm);
		
		System.assertEquals(1 ,result.accountRelationships.size());
		System.assertEquals(accountId ,result.accountRelationships[0].Eb_Account__c);
		System.assertEquals(requestId ,result.accountRelationships[0].TM_Service_Request__c);
		System.assertEquals(true ,result.accountRelationships[0].Master_Account__c);
	}

	private static testMethod void it_should_update_the_edited_service_account() {
		String serviceRequestObjectName = 'tm_service_request_account__c';
		TmBoarding.RelatedSm existingRelatedSm = new TmBoarding.RelatedSm();
		existingRelatedSm.accountRelationships = new List<TM_Service_Request_Account__c>();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');
		Id serviceAccountId = ObjectFactory.getFakeId(TM_Service_Request_Account__c.SObjectType, '1');
		TM_Service_Request__c request = new TM_Service_Request__c(Id=requestId);
		EB_Account__c a = new EB_Account__c(Id=accountId);
		TM_Service_Request_Account__c serviceAccount = new TM_Service_Request_Account__c(Id = serviceAccountId);
		serviceAccount.Eb_Account__r = a;
		serviceAccount.Eb_Account__c = a.Id;
		existingRelatedSm.accountRelationships.add(serviceAccount);
		pm.serviceAccountPms = new List<TM_Service_Request_Account__c>();
		TM_Service_Request_Account__c serviceAccountPm = new TM_Service_Request_Account__c(Id = serviceAccountId);
		serviceAccountPm.Master_Account__c = false;
		pm.serviceAccountPms.add(serviceAccountPm);
		
		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		sm1.fieldName = 'TM_Service_Request_Account__c.ACH_Originator_ID__c';
		sm1.FieldValue = (Object) 'test-orig';
		sm1.ObjectId = String.valueOf(serviceAccountId);
		TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
		sm2.FieldName = 'TM_Service_Request_Account__c.Master_Account__c';
		sm2.FieldValue = (Object) true;
		sm2.ObjectId = String.valueOf(serviceAccountId);

		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm1, sm2};

		Map<String, List<TmBoarding.SaveSm>> requestAccountSms = new Map<String, List<TmBoarding.SaveSm>>();
		requestAccountSms.put(String.valueOf(serviceAccountId), sms);
		Schema.SObjectField fldOrig = getField(serviceRequestObjectName, 'ACH_Originator_ID__c');
		Schema.SObjectField fldMaster = getField(serviceRequestObjectName, 'Master_Account__c');
		m_smExtractor.setup('getObjectsById', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestAccountSms);
		m_smExtractor.setup('getValidField' , new List<Object>{sm1}).returns('ACH_Originator_ID__c');
		m_smExtractor.setup('getValidField' , new List<Object>{sm2}).returns('Master_Account__c');
		m_FieldMapper.setup('getField', new List<Object>{serviceRequestObjectName, 'ACH_Originator_ID__c'}).returns(fldOrig);
		m_FieldMapper.setup('getField', new List<Object>{serviceRequestObjectName, 'Master_Account__c'}).returns(fldMaster);
		m_FieldMapper.setup('convert', new List<Object>{fldOrig, sm1.FieldValue} ).returns(sm1.FieldValue);
		m_FieldMapper.setup('convert', new List<Object>{fldMaster, sm2.FieldValue} ).returns(sm2.FieldValue);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fldOrig}).returns(true);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fldMaster}).returns(true);
		
		TmBoarding.RelatedSm result = sut.buildEditServiceAccount(existingRelatedSm, sms, pm);
		
		System.assertEquals(1 ,result.accountRelationships.size());
		System.assertEquals('test-orig' ,result.accountRelationships[0].ACH_Originator_ID__c);
		System.assertEquals(true ,result.accountRelationships[0].Master_Account__c);
	}


	private static testMethod void it_should_build_service_contact_account_for_existing_pm() {
		String objectName = 'TM_Service_Request_Contact_Account__c'.tolowerCase();
		String fieldName = 'Deposit__c';
		Id contactAccountId = ObjectFactory.getFakeId(TM_Service_Request_Contact_Account__c.SObjectType, '1');
		Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		TmBoarding.RelatedSm existingRelatedSm = new TmBoarding.RelatedSm();
		existingRelatedSm.accountRelationships = new List<TM_Service_Request_Account__c>();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();

		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		sm1.fieldName = 'TM_Service_Request_Contact_Account__c.Deposit__c';
		sm1.FieldValue = (Object) true;
		sm1.ObjectId = String.valueOf(contactAccountId);
        
        TM_Service_Request_Contact_Account__c ca1 = new TM_Service_Request_Contact_Account__c(Id=contactAccountId);
        pm.serviceContactAccountPms = new List<TM_Service_Request_Contact_Account__c>{ca1};
		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm1};
		Map<String, List<TmBoarding.SaveSm>> contactAccountMap = new Map<String, List<TmBoarding.SaveSm>>{contactAccountId => sms};
		m_smExtractor.setup('getObjectsById', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(contactAccountMap);

		Schema.SObjectField fld = getField(objectName, fieldName);
		m_fieldMapper.setup('getField', new List<Object>{objectName, fieldName}).returns(fld);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fld}).returns(true);
		m_smExtractor.setup('getValidField', new List<Object>{sm1}).returns(fieldName);
		m_fieldMapper.setup('convert', new List<Object>{fld, sm1.fieldValue}).returns((object)sm1.fieldValue);

		TmBoarding.RelatedRelatedSm result = sut.buildServiceContactAccount(existingRelatedSm, sms, pm);

		System.assertEquals(1, result.contactAccountRelationships.Size());
		System.assertEquals(true, result.contactAccountRelationships[0].Deposit__c);
	}

	private static testMethod void it_should_build_service_contact_account_for_non_existing_pm() {
		String objectName = 'TM_Service_Request_Contact_Account__c'.tolowerCase();
		String fieldName = 'View__c';
		Id contactAccountId = ObjectFactory.getFakeId(TM_Service_Request_Contact_Account__c.SObjectType, '1');
		Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		Id requestContactId = ObjectFactory.getFakeId(TM_Service_Request_Contact__c.SObjectType, '1');
		Id requestAccountId = ObjectFactory.getFakeId(TM_Service_Request_Account__c.SObjectType, '1');
		TmBoarding.RelatedSm existingRelatedSm = new TmBoarding.RelatedSm();
		existingRelatedSm.accountRelationships = new List<TM_Service_Request_Account__c>();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.serviceContactPms = new List<TM_Service_Request_Contact__c>{new TM_Service_Request_Contact__c(Id = requestContactId, Contact__c = contactId)};
		pm.serviceAccountPms = new List<TM_Service_Request_Account__c>{new TM_Service_Request_Account__c(Id = requestAccountId, Eb_Account__c = accountId)};

		TmBoarding.SaveSm sm = new TmBoarding.SaveSm();
		sm.fieldName = 'TM_Service_Request_Contact_Account__c.View__c';
		sm.FieldValue = (Object) true;
		sm.ParentId = contactId;
        sm.RelatedId = accountId;
        
        TM_Service_Request_Contact_Account__c ca1 = new TM_Service_Request_Contact_Account__c(Id=contactAccountId);
        pm.serviceContactAccountPms = new List<TM_Service_Request_Contact_Account__c>{ca1};
		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm};
		String key = String.format('{0}|{1}', new LIST<String>{contactId, accountId});
		Map<String, List<TmBoarding.SaveSm>> contactAccountMap = new Map<String, List<TmBoarding.SaveSm>>{key => sms};
		m_smExtractor.setup('getObjectsByParentAndRelated', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(contactAccountMap);

		Schema.SObjectField fld = getField(objectName, fieldName);
		m_fieldMapper.setup('getField', new List<Object>{objectName, fieldName}).returns(fld);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fld}).returns(true);
		m_smExtractor.setup('getValidField', new List<Object>{sm}).returns(fieldName);
		m_fieldMapper.setup('convert', new List<Object>{fld, sm.fieldValue}).returns((object)sm.fieldValue);
		m_util.setup('getObjectNameFromId', new List<Object>{contactId}).returns('Contact');
		m_util.setup('getObjectNameFromId', new List<Object>{accountId}).returns('Eb_Account__c');

		TmBoarding.RelatedRelatedSm result = sut.buildServiceContactAccount(existingRelatedSm, sms, pm);

		System.assertEquals(1, result.contactAccountRelationships.Size());
		System.assertEquals(true, result.contactAccountRelationships[0].View__c);
	}

	private static testMethod void it_should_build_service_contact_account_for_non_existing_and_existing_pm() {
		String objectName = 'TM_Service_Request_Contact_Account__c'.tolowerCase();
		String fieldName1 = 'View__c';
		String fieldName2 = 'Deposit__c';
		Id contactAccountId = ObjectFactory.getFakeId(TM_Service_Request_Contact_Account__c.SObjectType, '1');
		Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		Id requestContactId = ObjectFactory.getFakeId(TM_Service_Request_Contact__c.SObjectType, '1');
		Id requestAccountId = ObjectFactory.getFakeId(TM_Service_Request_Account__c.SObjectType, '1');
		TmBoarding.RelatedSm existingRelatedSm = new TmBoarding.RelatedSm();
		existingRelatedSm.accountRelationships = new List<TM_Service_Request_Account__c>();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.serviceContactPms = new List<TM_Service_Request_Contact__c>{new TM_Service_Request_Contact__c(Id = requestContactId, Contact__c = contactId)};
		pm.serviceAccountPms = new List<TM_Service_Request_Account__c>{new TM_Service_Request_Account__c(Id = requestAccountId, Eb_Account__c = accountId)};

		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		sm1.fieldName = 'TM_Service_Request_Contact_Account__c.View__c';
		sm1.FieldValue = (Object) true;
		sm1.ParentId = contactId;
        sm1.RelatedId = accountId;

		TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
		sm2.fieldName = 'TM_Service_Request_Contact_Account__c.Deposit__c';
		sm2.FieldValue = (Object) true;
		sm2.ObjectId = String.valueOf(contactAccountId);
        
        TM_Service_Request_Contact_Account__c ca1 = new TM_Service_Request_Contact_Account__c(Id=contactAccountId);
        pm.serviceContactAccountPms = new List<TM_Service_Request_Contact_Account__c>{ca1};
		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm1, sm1};
		List<TmBoarding.SaveSm> smsParentRelated = new List<TmBoarding.SaveSm>{sm1};
		List<TmBoarding.SaveSm> smsByObject = new List<TmBoarding.SaveSm>{sm2};
		String key = String.format('{0}|{1}', new LIST<String>{contactId, accountId});
		Map<String, List<TmBoarding.SaveSm>> contactAccountMapParentRelated = new Map<String, List<TmBoarding.SaveSm>>{key => smsParentRelated};
		Map<String, List<TmBoarding.SaveSm>> contactAccountMapByObject = new Map<String, List<TmBoarding.SaveSm>>{sm2.ObjectId => smsByObject};
		m_smExtractor.setup('getObjectsByParentAndRelated', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(contactAccountMapParentRelated);
		m_smExtractor.setup('getObjectsById', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(contactAccountMapByObject);

		Schema.SObjectField fld1 = getField(objectName, fieldName1);
		Schema.SObjectField fld2 = getField(objectName, fieldName2);
		m_fieldMapper.setup('getField', new List<Object>{objectName, fieldName1}).returns(fld1);
		m_fieldMapper.setup('getField', new List<Object>{objectName, fieldName2}).returns(fld2);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fld1}).returns(true);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fld2}).returns(true);
		m_smExtractor.setup('getValidField', new List<Object>{sm1}).returns(fieldName1);
		m_smExtractor.setup('getValidField', new List<Object>{sm2}).returns(fieldName2);
		m_fieldMapper.setup('convert', new List<Object>{fld1, sm1.fieldValue}).returns((object)sm1.fieldValue);
		m_fieldMapper.setup('convert', new List<Object>{fld2, sm2.fieldValue}).returns((object)sm2.fieldValue);
		m_util.setup('getObjectNameFromId', new List<Object>{contactId}).returns('Contact');
		m_util.setup('getObjectNameFromId', new List<Object>{accountId}).returns('Eb_Account__c');

		TmBoarding.RelatedRelatedSm result = sut.buildServiceContactAccount(existingRelatedSm, sms, pm);

		System.assertEquals(2, result.contactAccountRelationships.Size());
		System.assertEquals(true, result.contactAccountRelationships[0].Deposit__c);
		System.assertEquals(false, result.contactAccountRelationships[0].View__c);
		System.assertEquals(false, result.contactAccountRelationships[1].Deposit__c);
		System.assertEquals(true, result.contactAccountRelationships[1].View__c);
	}


	private static testMethod void it_should_build_a_new_request_contact_for_a_given_saved_new_contact() {
		String objectName = 'tm_service_request_contact__c';
		Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		Contact newContact = new Contact(Id = contactId);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = new Tm_Service_Request__c(Id = requestId);

		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		String fieldName = 'Access_Level__c';
		sm1.fieldName = 'TM_Service_Request_Contact__c.Access_Level__c';
		sm1.FieldValue = (Object) 'Supervisor / Manage Users';

		TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
		sm2.fieldName = 'TM_Service_Request_Contact__c.Authorized_to_Receive_Return_Files__c';
		sm2.FieldValue = (Object) 'Yes';
		sm2.ObjectId = 'some-id';
		List<TmBoarding.SaveSm> smsAll = new List<TmBoarding.SaveSm>{sm1, sm2};
		List<TmBoarding.SaveSm> smsFiltered = new List<TmBoarding.SaveSm>{sm1};
		Schema.SObjectField fld = getField(objectName, fieldName);
		m_smExtractor.setup('getObjectsWithoutId',  new List<Object>{objectName, smsAll}).returns(smsFiltered);
		m_smExtractor.setup('getValidField', new List<Object>{sm1}).returns(fieldName);
		m_fieldMapper.setup('getField', new List<Object>{objectName, fieldName}).returns(fld);
		m_fieldMapper.setup('IsFieldUpdatable', new List<Object>{fld}).returns(true);
		m_fieldMapper.setup('convert', new List<Object>{fld, sm1.FieldValue}).returns(sm1.FieldValue);

		TM_Service_Request_Contact__c result = sut.buildNewRequestContactForNewContact(newContact, smsAll, pm);

		System.assertEquals(contactId ,result.Contact__c);
		System.assertEquals(requestId ,result.TM_Service_Request__c);
		System.assertEquals('Supervisor / Manage Users' ,result.Access_Level__c);
	}

	private static testMethod void it_should_build_a_new_request_account_for_a_given_existing_dmaccount() {
		String objectName = 'tm_service_request_account__c';
		Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		DmEbAccount newAccount = new DmEbAccount();
		newAccount.Id = accountId;
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = new Tm_Service_Request__c(Id = requestId);

		TM_Service_Request_Account__c result = sut.buildNewRequestAccountForProspectiveAccount(newAccount, pm);

		System.assertEquals(accountId ,result.Eb_Account__c);
		System.assertEquals(requestId ,result.TM_Service_Request__c);
	}

	private static testMethod void it_should_build_a_new_contact_account_when_service_contact_is_provided() {
		String objectName = 'tm_service_request_contact_account__c';
		Id serviceContactId = ObjectFactory.getFakeId(TM_Service_Request_Contact__c.SObjectType, '1');
		Id serviceAccountId = ObjectFactory.getFakeId(TM_Service_Request_Account__c.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		TM_Service_Request_Contact__c serviceContact = new tm_service_request_contact__c(Id=serviceContactId);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		TM_Service_Request_Account__c serviceAccount = new TM_Service_Request_Account__c(Id= serviceAccountId, Eb_Account__c=accountId);
		pm.serviceAccountPms = new List<TM_Service_Request_Account__c>{serviceAccount };

		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		String fieldName = 'Deposit__c';
		sm1.fieldName = 'TM_Service_Request_Contact_Account__c.Deposit__c';
		sm1.FieldValue = (Object) true;
		sm1.RelatedId = accountId;

		TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
		sm2.fieldName = 'TM_Service_Request_Contact_Account__c.View__c';
		sm2.FieldValue = (Object) false;
		sm2.ObjectId = 'some-id';
		List<TmBoarding.SaveSm> smsAll = new List<TmBoarding.SaveSm>{sm1, sm2};
		List<TmBoarding.SaveSm> smsFiltered = new List<TmBoarding.SaveSm>{sm1};
		Map<String,List<TmBoarding.SaveSm>> smsFilteredMap = new Map<String,List<TmBoarding.SaveSm>>{accountId => smsFiltered};
		Schema.SObjectField fld = getField(objectName, fieldName);
		m_smExtractor.setup('getObjectsWithoutIdAndRelatedId', new List<Object>{objectName, smsAll}).returns(smsFilteredMap);
		m_smExtractor.setup('getValidField', new List<Object>{sm1}).returns(fieldName);
		m_fieldMapper.setup('getField', new List<Object>{objectName, fieldName}).returns(fld);
		m_fieldMapper.setup('IsFieldUpdatable', new List<Object>{fld}).returns(true);
		m_fieldMapper.setup('convert', new List<Object>{fld, sm1.fieldValue}).returns(sm1.fieldValue);

		List<TM_Service_Request_Contact_Account__c> result = sut.buildNewRequestContactAccount(serviceContact, smsAll, pm);

		System.assertEquals(1, result.size());
		System.assertEquals(true , result[0].Deposit__c);
		System.assertEquals(serviceContactId , result[0].TM_Service_Request_Contact__c);
		System.assertEquals(serviceAccountId , result[0].TM_Service_Request_Account__c);
	}

	private static testMethod void it_should_build_a_new_account_contact_when_service_account_is_provided() {
		String objectName = 'tm_service_request_contact_account__c';
		Id serviceContactId = ObjectFactory.getFakeId(TM_Service_Request_Contact__c.SObjectType, '1');
		Id serviceAccountId = ObjectFactory.getFakeId(TM_Service_Request_Account__c.SObjectType, '1');
		Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		TM_Service_Request_Account__c serviceAccount = new TM_Service_Request_Account__c(Id= serviceAccountId);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		TM_Service_Request_Contact__c serviceContact = new tm_service_request_contact__c(Id=serviceContactId, Contact__c=contactId);
		pm.serviceContactPms = new List<TM_Service_Request_Contact__c>{serviceContact};

		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		String fieldName = 'Deposit__c';
		sm1.fieldName = 'TM_Service_Request_Contact_Account__c.Deposit__c';
		sm1.FieldValue = (Object) true;
		sm1.RelatedId = contactId;

		TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
		sm2.fieldName = 'TM_Service_Request_Contact_Account__c.View__c';
		sm2.FieldValue = (Object) false;
		sm2.ObjectId = 'some-id';
		List<TmBoarding.SaveSm> smsAll = new List<TmBoarding.SaveSm>{sm1, sm2};
		List<TmBoarding.SaveSm> smsFiltered = new List<TmBoarding.SaveSm>{sm1};
		Map<String,List<TmBoarding.SaveSm>> smsFilteredMap = new Map<String,List<TmBoarding.SaveSm>>{contactId => smsFiltered};
		Schema.SObjectField fld = getField(objectName, fieldName);
		m_smExtractor.setup('getObjectsWithoutIdAndRelatedId', new List<Object>{objectName, smsAll}).returns(smsFilteredMap);
		m_smExtractor.setup('getValidField', new List<Object>{sm1}).returns(fieldName);
		m_fieldMapper.setup('getField', new List<Object>{objectName, fieldName}).returns(fld);
		m_fieldMapper.setup('IsFieldUpdatable', new List<Object>{fld}).returns(true);
		m_fieldMapper.setup('convert', new List<Object>{fld, sm1.fieldValue}).returns(sm1.fieldValue);

		List<TM_Service_Request_Contact_Account__c> result = sut.buildNewRequestAccountContact(serviceAccount, smsAll, pm);

		System.assertEquals(1, result.size());
		System.assertEquals(true , result[0].Deposit__c);
		System.assertEquals(serviceContactId , result[0].TM_Service_Request_Contact__c);
		System.assertEquals(serviceAccountId , result[0].TM_Service_Request_Account__c);
	}

	private static testMethod void it_should_build_a_new_core_request() {
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		String objectName = 'tm_service_request__c';
		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		String fieldName = 'Domestic_Wires__c';
		sm1.fieldName = 'TM_Service_Request__c.Domestic_Wires__c';
		sm1.FieldValue = (Object) true;

		TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
		sm2.fieldName = 'TM_Service_Request__c.International_Wires__c';
		sm2.FieldValue = (Object) false;
		sm2.objectId = 'some-id';

		List<TmBoarding.SaveSm> smsAll = new List<TmBoarding.SaveSm>{sm1, sm2};
		List<TmBoarding.SaveSm> smsFiltered = new List<TmBoarding.SaveSm>{sm1};
		Schema.SObjectField fld = getField(objectName, fieldName);
		m_smExtractor.setup('getObjectsWithoutId', new List<Object>{objectName, smsAll}).returns(smsFiltered);
		m_smExtractor.setup('getValidField', new List<Object>{sm1}).returns(fieldName);
		m_fieldMapper.setup('getField', new List<Object>{objectName, fieldName}).returns(fld);
		m_fieldMapper.setup('IsFieldUpdatable', new List<Object>{fld}).returns(true);
		m_fieldMapper.setup('convert', new List<Object>{fld, sm1.fieldValue}).returns(sm1.fieldValue);

		Tm_Service_request__c result = sut.buildNewCoreRequest(smsAll, pm);

		System.assertEquals(true, result.Domestic_Wires__c);
	}

	private static testMethod void it_should_build_a_new_core_contact() {
		String objectName = 'contact';
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		pm.entityPm = new Account(Id= entityId);
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();

		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		String fieldName = 'LastName';
		sm1.fieldName = 'Contact.LastName';
		sm1.FieldValue = (Object) 'test-last-name';

		TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
		sm2.fieldName = 'Contact.FirstName';
		sm2.FieldValue = (Object) 'first-name';
		sm2.objectId = 'some-id';
		List<TmBoarding.SaveSm> smsAll = new List<TmBoarding.SaveSm>{sm1, sm2};
		List<TmBoarding.SaveSm> smsFiltered = new List<TmBoarding.SaveSm>{sm1};
		Schema.SObjectField fld = getField(objectName, fieldName);
		m_smExtractor.setup('getObjectsWithoutId', new List<Object>{objectName, smsAll}).returns(smsFiltered);
		m_smExtractor.setup('getValidField', new List<Object>{sm1}).returns(fieldName);
		m_fieldMapper.setup('getField', new List<Object>{objectName, fieldName}).returns(fld);
		m_fieldMapper.setup('IsFieldUpdatable', new List<Object>{fld}).returns(true);
		m_fieldMapper.setup('convert', new List<Object>{fld, sm1.fieldValue}).returns(sm1.fieldValue);

		Contact result = sut.buildNewCoreContact(smsAll, pm);

		System.assertEquals(entityId, result.AccountId);
		System.assertEquals('test-last-name', result.LastName);
	}

	private static testMethod void it_should_build_a_new_core_account() {
		String objectName = 'eb_account__c';
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		pm.entityPm = new Account(Id= entityId);
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();

		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		String fieldName = 'Account_Line_1__c';
		sm1.fieldName = 'EB_Account__c.Account_Line_1__c';
		sm1.FieldValue = (Object) 'test-line-1';

		TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
		sm2.fieldName = 'EB_Account__c.Account_Line_2__c';
		sm2.FieldValue = (Object) 'test-line-2';
		sm2.objectId = 'some-id';
		List<TmBoarding.SaveSm> smsAll = new List<TmBoarding.SaveSm>{sm1, sm2};
		List<TmBoarding.SaveSm> smsFiltered = new List<TmBoarding.SaveSm>{sm1};
		Schema.SObjectField fld = getField(objectName, fieldName);
		m_smExtractor.setup('getObjectsWithoutId', new List<Object>{objectName, smsAll}).returns(smsFiltered);
		m_smExtractor.setup('getValidField', new List<Object>{sm1}).returns(fieldName);
		m_fieldMapper.setup('getField', new List<Object>{objectName, fieldName}).returns(fld);
		m_fieldMapper.setup('IsFieldUpdatable', new List<Object>{fld}).returns(true);
		m_fieldMapper.setup('convert', new List<Object>{fld, sm1.fieldValue}).returns(sm1.fieldValue);

		Eb_Account__c result = sut.buildNewCoreAccount(smsAll, pm);

		System.assertEquals(entityId, result.Primary_Owner_Id__c);
		System.assertEquals('test-line-1', result.Account_Line_1__c);
	}


	private static testMethod void it_should_build_excludes_when_schedule_config_pm_is_provided() {
		TmBoarding.RequestConfigPm config = new TmBoarding.RequestConfigPm();

		TmBoarding.RequestScheduleConfigPm scheduleconfig1 = new TmBoarding.RequestScheduleConfigPm();
		scheduleconfig1.ScheduleName = 'International_Wires__c';
		TM_Service_Configuration_Field__c fld11 = new TM_Service_Configuration_Field__c();
		fld11.Field_Name__c = 'International_Wires_Dual_Authorization__c';
		TM_Service_Configuration_Field__c fld12 = new TM_Service_Configuration_Field__c();
		fld12.Field_Name__c = 'Int_l_Monthly_Limit__c';
		TM_Service_Configuration_Field__c fld13 = new TM_Service_Configuration_Field__c();
		fld13.Field_Name__c = 'Int_l_Daily_Limit__c';
		scheduleconfig1.serviceSchedulePms = new List<TM_Service_Configuration_Field__c>{fld11, fld12,  fld13};

		TmBoarding.RequestScheduleConfigPm scheduleconfig2 = new TmBoarding.RequestScheduleConfigPm();
		scheduleconfig2.ScheduleName = 'Domestic_Wires__c';
		TM_Service_Configuration_Field__c fld21 = new TM_Service_Configuration_Field__c();
		fld21.Field_Name__c = 'International_Wires_Dual_Authorization__c';
		TM_Service_Configuration_Field__c fld22 = new TM_Service_Configuration_Field__c();
		fld22.Field_Name__c = 'Domestic_Monthly_Limit__c';
		TM_Service_Configuration_Field__c fld23 = new TM_Service_Configuration_Field__c();
		fld23.Field_Name__c = 'Domestic_Daily_Limit__c';

		scheduleconfig2.serviceSchedulePms = new List<TM_Service_Configuration_Field__c>{fld21, fld22,  fld23};

		config.schedulePms = new List<TmBoarding.RequestScheduleConfigPm>{scheduleconfig1, scheduleconfig2};

		TM_Service_Request__c request = new TM_Service_Request__c();
		request.International_Wires__c = true;
		request.Domestic_Wires__c = false;
		request.Int_l_Monthly_Limit__c = 25.00;


		Set<String> result =  sut.getExcludedFieldsFromRequest(config, request);

		System.assertEquals(3, result.size());
		System.assertEquals(true, result.contains('International_Wires_Dual_Authorization__c'));
		System.assertEquals(true, result.contains('Domestic_Monthly_Limit__c'));
		System.assertEquals(true, result.contains('Domestic_Daily_Limit__c'));
	}


	private static testMethod void it_should_remove_values_from_request_when_a_list_of_field_names_is_provided() {

		String TM_REQUEST_NAME = 'tm_service_request__c';
		String field1 = 'Int_l_Monthly_Limit__c';
		String field2 = 'Start_Date__c';
		String field3 = 'International_Wires__c';

		Set<String> fields = new Set<String>();
		fields.add(field1);
		fields.add(field2);
		fields.add(field3);

		TM_Service_Request__c request = new TM_Service_Request__c();
		request.International_Wires__c = true;
		request.Domestic_Wires__c = true;
		request.Int_l_Monthly_Limit__c = 25.00;
		request.Start_Date__c = Date.newInstance(2000, 1, 24);

		Schema.SObjectField fld1 = getField(TM_REQUEST_NAME, field1);
		Schema.SObjectField fld2 = getField(TM_REQUEST_NAME, field2);
		Schema.SObjectField fld3 = getField(TM_REQUEST_NAME, field3);

		m_fieldMapper.setup('getField', new List<Object>{TM_REQUEST_NAME, field1}).returns(fld1);
		m_fieldMapper.setup('getField', new List<Object>{TM_REQUEST_NAME, field2}).returns(fld2);
		m_fieldMapper.setup('getField', new List<Object>{TM_REQUEST_NAME, field3}).returns(fld3);

		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fld1}).returns(true);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fld2}).returns(true);
		m_FieldMapper.setup('IsFieldUpdatable', new List<Object>{fld3}).returns(true);

		m_FieldMapper.setup('fillEmpty', new List<Object>{fld1}).returns(((Object)decimal.valueof('0.00')));
		m_FieldMapper.setup('fillEmpty', new List<Object>{fld2}).returns(null);
		m_FieldMapper.setup('fillEmpty', new List<Object>{fld3}).returns((Object)false);

		Tm_service_Request__c result = sut.removeValuesFromRequest(fields, request);

		System.assertEquals(false ,result.International_Wires__c);
		System.assertEquals(0.00 ,result.Int_l_Monthly_Limit__c);
		System.assertEquals(null ,result.Start_Date__c);
		System.assertEquals(true ,result.Domestic_Wires__c);
	}


	private static testMethod void it_should_build_core_sm() {
		String packetObjectName = 'tm_service_request_packet__c';
		String requestObjectName = 'tm_service_request__c';
		String contactObjectName = 'contact';
		String accountObjectName = 'eb_account__c';

		Id packetId = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
		Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(Eb_account__c.SObjectType, '1');
		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = new Tm_Service_Request__c(Id = requestId);
		
		Contact contactPm = new Contact(Id=contactId);
		pm.contactPms = new List<Contact>{contactPm};
		EB_Account__c accountPm = new Eb_Account__c(Id=accountId);
		pm.accountPms = new List<Eb_Account__c>{accountPm};

		TmBoarding.SaveSm requestSaveSm = new TmBoarding.SaveSm();
		requestSaveSm.FieldName = 'Tm_Service_Request__c.Name';
		requestSaveSm.FieldValue = '-name-rq-';
		requestSaveSm.ObjectId = requestId;
		Map<String, List<TmBoarding.SaveSm>> requestSms = new Map<String, List<TmBoarding.SaveSm>>{requestObjectName => new List<TmBoarding.SaveSm>{requestSaveSm}};
		TmBoarding.SaveSm contactSm = new TmBoarding.SaveSm();
		contactSm.FieldName = 'Contact.Name';
		contactSm.FieldValue = '-name-';
		contactSm.objectId = contactId;
		Map<String, List<TmBoarding.SaveSm>> contactSms = new Map<String, List<TmBoarding.SaveSm>>{contactObjectName => new List<TmBoarding.SaveSm>{contactSm}};
		TmBoarding.SaveSm accountSm = new TmBoarding.SaveSm();
		accountSm.FieldName = 'Eb_Account__c.Name';
		accountSm.FieldValue = '-name-eb';
		accountSm.ObjectId = accountId;
		Map<String, List<TmBoarding.SaveSm>> accountSms = new Map<String, List<TmBoarding.SaveSm>>{accountObjectName => new List<TmBoarding.SaveSm>{accountSm}};
		TmBoarding.SaveSm packetSm = new TmBoarding.SaveSm();
		packetSm.FieldName = packetObjectName +'.Digital_Signature_Imaging_Document_Id__c';
		packetSm.FieldValue = '-name-';
		packetSm.objectId = packetId;
		Map<String, List<TmBoarding.SaveSm>> packetSms = new Map<String, List<TmBoarding.SaveSm>>{packetObjectName => new List<TmBoarding.SaveSm>{packetSm}};

		m_smExtractor.setup('getObjectsById', new List<Object>{packetObjectName, sms}).returns(packetSms);
		m_smExtractor.setup('getObjectsById', new List<Object>{requestObjectName, sms}).returns(requestSms);
		m_smExtractor.setup('getObjectsById', new List<Object>{contactObjectName, sms}).returns(contactSms);
		m_smExtractor.setup('getObjectsById', new List<Object>{accountObjectName, sms}).returns(accountSms);

		TmBoarding.CoreSm result = sut.coreSmBuilder(sms, pm);

		System.assertEquals(requestId, result.request.Id);
		System.assertEquals(1, result.contacts.size());
		System.assertEquals(1, result.accounts.size());
	}


	private static testMethod void it_should_add_a_core_account() {
		Id requestId = ObjectFactory.getFakeId(Tm_service_Request__c.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		String ebFieldName = 'eb-name';
		DmEbAccount dm = new DmEbAccount();
		dm.Name = ebFieldName;
		TmBoarding.CoreSm coreSm = new TmBoarding.CoreSm();
		coreSm.request = new Tm_service_Request__c(Id = requestId);
		coreSm.accounts = new List<Eb_Account__c>{new Eb_Account__c(Id = accountId, name =ebFieldName)};

		TmBoarding.CoreSm result = sut.addCoreAccount(dm, coreSm);

		System.assertEquals(accountId, result.accounts[0].Id);
	}


	private static testMethod void it_should_update_account() {
		String accountNumber = '123-2';
		Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		DmEbAccount dm = new DmEbAccount();
		dm.AccountNumber = accountNumber;
		Eb_Account__c pm = new Eb_Account__c(Id = accountId);
		pm.Account_Number__c = accountNumber;
		TmBoarding.CoreSm coreSm = new TmBoarding.CoreSm();
		coreSm.accounts = new List<Eb_Account__c>{pm};

		sut.updateCoreAccountId(dm, coreSm);

		System.assertEquals(accountId ,pm.id);
	}

	private static testMethod void it_should_get_related_sm() {
		Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		Id contactId = ObjectFactory.getFakeId(contact.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');

		Account entityPm = new Account(Id=entityId, Eb_Customer_Number__c = '1223');
		Tm_service_Request__c req = new Tm_Service_Request__c(Id = requestId);
		Contact c = new Contact(Id = contactId);
		Eb_Account__c ebaccount = new Eb_Account__c(Id = accountId);

		TmBoarding.coreSm coreSm = new TmBoarding.coreSm();
		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		TM_Service_Request_Contact__c relContact = new TM_Service_Request_Contact__c();
		relContact.TM_Service_Request__c = requestId;
		relContact.Contact__c = contactId;
		TM_Service_Request_Account__c relAccount = new TM_Service_Request_Account__c();
		relAccount.TM_Service_Request__c = requestId;
		relAccount.EB_Account__c = accountId;

		coreSm.request = req;
		coreSm.contacts = new List<Contact>{c};
		coreSm.accounts = new List<Eb_Account__c>{ebaccount};
		pm.entityPm = entityPm;
		pm.contactPms = new List<Contact>{c};
		pm.accountPms = new List<Eb_Account__c>{ebaccount};
		pm.serviceContactPms = new List<TM_Service_Request_Contact__c>{relContact};
		pm.serviceAccountPms = new List<TM_Service_Request_Account__c>{relAccount};

		Map<String, Object> selectedContact = new Map<String, Object>{c.Id => true};
		Map<String, Object> selectedAccount = new Map<String, Object>{ebAccount.Id => true};

		m_smExtractor.setup('getSelectedFields' , new List<Object>{c.Id, sms}).returns(selectedContact);
		m_smExtractor.setup('getSelectedFields' , new List<Object>{ebAccount.Id, sms}).returns(selectedAccount);

		TmBoarding.RelatedSm result = sut.relatedSmBuilder(coreSm, sms, pm);

		System.assertEquals(1, result.contactRelationships.size());
		System.assertEquals(1, result.accountRelationships.size());
		System.assertEquals(requestId, result.contactRelationships[0].Tm_Service_Request__c);
		System.assertEquals(contactId, result.contactRelationships[0].Contact__c);
		System.assertEquals(AccountId, result.accountRelationships[0].Eb_Account__c);
	}

	private static testMethod void it_should_build_related_eb_account() {

		TmBoarding.requestPm pm = new TmBoarding.requestPm();
		pm.entityPm = new Account();
		DmEbAccount coreAccount = new DmEbAccount();

		SObject result = sut.buildRelatedEbAccount( pm, coreAccount);

		Eb_Account_Relationship__c resultRelated = (Eb_Account_Relationship__c)result;
		System.assertEquals('Primary Owner' ,resultRelated.Relationship__c);
	}

	private static testMethod void it_should_create_objs_with_assignees() {
		String assigneeName = 'test-name';
		Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = new TM_Service_Request__c(Id=requestId, Assigned_To__c = assigneeName);
		List<TmBoarding.RequestPm> requestPms = new List<TmBoarding.RequestPm>{pm};

		List<SObject> result = sut.updateProductAssignee(requestPms, assigneeName);

		System.assertEquals(assigneeName, ((Tm_Service_Request__c)result[0]).Assigned_To__c);
	}

	//utility method
	private static Schema.SObjectField getField(String objectName, String fieldName) {
		Map<string, Map<string,Schema.SObjectField>> m_fieldMap = new Map<string, Map<string,Schema.SObjectField>>();
		if(!m_fieldMap.containsKey(objectName)){
			m_fieldMap.put(objectName,Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap());
		}
    	return m_fieldMap.get(objectName).get(fieldName);
	}
}