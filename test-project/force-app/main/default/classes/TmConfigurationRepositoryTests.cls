@IsTest
private class TmConfigurationRepositoryTests {

	private static final TmConfigurationRepository sut;
	private static final TmBoardingMock.ofIDataProvider m_mockDataProvider;
	private static final TmConfigurationMock.ofIDmBuilder m_mockDmBuilder;
	private static final Mock.ofISchema m_mockSchema;
	private static final TmConfigurationMock.ofIQueryBuilder m_mockQueryBuilder;
	private static final Mock.ofIAttachmentHandler m_mockAttachmentProvider;


	static {
		m_mockDataProvider = new TmBoardingMock.ofIDataProvider();
		m_mockDmBuilder = new TmConfigurationMock.ofIDmBuilder();
		m_mockSchema = new Mock.ofISchema();
		m_mockQueryBuilder = new TmConfigurationMock.ofIQueryBuilder();
		m_mockAttachmentProvider = new Mock.ofIAttachmentHandler();
		sut = new TmConfigurationRepository(m_mockDataProvider, m_mockDmBuilder, m_mockSchema, m_mockQueryBuilder, m_mockAttachmentProvider);
	}

	@IsTest
    static void it_should_call_the_dm_builder_to_build_details() {
		String recordTypeName = 'online banking';
		String objectName = TMConfiguration.TM_REQUEST;
		TmConfiguration.Placement placement = TmConfiguration.Placement.All;
		TmBoarding.RequestConfigPm config = new TmBoarding.RequestConfigPm();
		config.serviceOptionPms = new List<TM_Service_Configuration_Field__c>();
		config.sectionOptionPms = new Map<Id,TM_Service_Configuration_Section__c>();
		List<DmSection> sections = new List<DmSection>();
		Map<string, TmBoarding.RequestConfigPm> configMap = new Map<string, TmBoarding.RequestConfigPm>{ recordTypeName => config};
		m_mockDataProvider.setup('getAllPageFieldConfigurationsByServiceType').returns(configMap);
		String fieldName = 'Name';
		Mock.ofISObjectField mockSField = new Mock.ofISObjectField();
		string key = string.format('{0}.{1}', new List<String>{objectName.toLowerCase(), fieldName});
		Map<string, ISObjectField> fieldMap = new Map<string, ISObjectField>{key => mockSField};
		m_mockSchema.setup('getFieldMap' , new List<OBject>{objectName}).returns(fieldMap);

		List<DmSection> result = sut.getDetailSections(recordTypeName, placement);

		m_mockDmBuilder.verify('buildSections', new List<Object>{config.serviceOptionPms, config.sectionOptionPms, placement}, Times.Once);
	}

	@IsTest
    static void it_shoud_call_the_dm_builder_to_build_schedule_sections() {	
		String recordTypeName = 'online banking';
		TmConfiguration.Placement placement = TmConfiguration.Placement.All;
		TmBoarding.RequestConfigPm config = new TmBoarding.RequestConfigPm();
		config.serviceOptionPms = new List<TM_Service_Configuration_Field__c>();
		config.sectionOptionPms = new Map<Id,TM_Service_Configuration_Section__c>();
		TmBoarding.RequestScheduleConfigPm scheduleConfigPm = new TmBoarding.RequestScheduleConfigPm();
		scheduleConfigPm.serviceSchedulePms = new  List<TM_Service_Configuration_Field__c>();
		config.schedulePms = new List<TmBoarding.RequestScheduleConfigPm>{scheduleConfigPm};
		List<DmSection> sections = new List<DmSection>();
		Map<string, TmBoarding.RequestConfigPm> configMap = new Map<string, TmBoarding.RequestConfigPm>{ recordTypeName => config};
		m_mockDataProvider.setup('getAllPageFieldConfigurationsByServiceType').returns(configMap);
		m_mockDmBuilder.setup('buildSections', new List<Object>{scheduleConfigPm.serviceSchedulePms, config.sectionOptionPms, placement}).returns(sections);

		List<DmSection> result = sut.getScheduleSections(recordTypeName, placement);

		m_mockDmBuilder.verify('buildSections', new List<Object>{scheduleConfigPm.serviceSchedulePms, config.sectionOptionPms, placement}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_dm_builder_to_build_contacts() {
		String recordTypeName = 'online banking';
		TmConfiguration.Placement placement = TmConfiguration.Placement.All;
		TmBoarding.RequestConfigPm config = new TmBoarding.RequestConfigPm();
		config.serviceOptionPms = new List<TM_Service_Configuration_Field__c>();
		config.sectionOptionPms = new Map<Id,TM_Service_Configuration_Section__c>();
		config.contactOptionPms = new List<TM_Service_Configuration_Field__c>();
		List<DmSection> sections = new List<DmSection>();
		Map<string, TmBoarding.RequestConfigPm> configMap = new Map<string, TmBoarding.RequestConfigPm>{ recordTypeName => config};
		m_mockDataProvider.setup('getAllPageFieldConfigurationsByServiceType').returns(configMap);
		m_mockDmBuilder.setup('buildSections', new List<Object>{config.contactOptionPms, config.sectionOptionPms, placement}).returns(sections);

		List<DmSection> result = sut.getContactSections(recordTypeName, placement);

		m_mockDmBuilder.verify('buildSections', new List<Object>{config.contactOptionPms, config.sectionOptionPms, placement}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_dm_builder_to_build_accounts() {
		String recordTypeName = 'online banking';
		TmConfiguration.Placement placement = TmConfiguration.Placement.All;
		TmBoarding.RequestConfigPm config = new TmBoarding.RequestConfigPm();
		config.serviceOptionPms = new List<TM_Service_Configuration_Field__c>();
		config.sectionOptionPms = new Map<Id,TM_Service_Configuration_Section__c>();
		config.accountOptionPms = new List<TM_Service_Configuration_Field__c>();
		List<DmSection> sections = new List<DmSection>();
		Map<string,TmBoarding.RequestConfigPm> configMap = new Map<string, TmBoarding.RequestConfigPm>{recordTypeName => config}; 
		m_mockDataProvider.setup('getAllPageFieldConfigurationsByServiceType').returns(configMap);
		m_mockDmBuilder.setup('buildSections', new List<Object>{config.accountOptionPms, config.sectionOptionPms, placement}).returns(sections);

		List<DmSection> result = sut.getAccountSections(recordTypeName, placement);

		m_mockDmBuilder.verify('buildSections', new List<Object>{config.accountOptionPms, config.sectionOptionPms, placement}, Times.Once);
	}

	@IsTest
    static void it_should_call_contact_account_sections() {
		String recordTypeName = 'online banking';
		TmConfiguration.Placement placement = TmConfiguration.Placement.All;
		TmBoarding.RequestConfigPm config = new TmBoarding.RequestConfigPm();
		config.serviceOptionPms = new List<TM_Service_Configuration_Field__c>();
		config.sectionOptionPms = new Map<Id,TM_Service_Configuration_Section__c>();
		config.contactAccountOptionPms = new List<TM_Service_Configuration_Field__c>();
		List<DmSection> sections = new List<DmSection>();
		Map<string, TmBoarding.RequestConfigPm> configMap = new Map<string, TmBoarding.RequestConfigPm>{recordTypeName => config};
		m_mockDataProvider.setup('getAllPageFieldConfigurationsByServiceType').returns(configMap);
		m_mockDmBuilder.setup('buildSections', new List<Object>{config.contactAccountOptionPms, config.sectionOptionPms, placement}).returns(sections);

		List<DmSection> result = sut.getContactAccountSections(recordTypeName, placement);

		m_mockDmBuilder.verify('buildSections', new List<Object>{config.contactAccountOptionPms, config.sectionOptionPms, placement}, Times.Once);		
	}

	@IsTest
    static void it_should_call_schema_to_get_recordtype_name() {
		TM_Service_Request__c record = new TM_Service_Request__c();
		String recordTypeName = 'Lockbox';
		RecordType rt = Utility.RecordTypeObject('TM_Service_Request__c', recordTypeName);
		record.RecordTypeId = rt.Id;

		String result = sut.getRecordTypeName(record);

		System.assertEquals(recordTypeName ,result);
	}

	@IsTest
    static void it_should_call_the_config_to_get_product() {
		String recordTypeName = 'online banking';
		TmBoarding.RequestConfigPm config = new TmBoarding.RequestConfigPm();
		config.productPm = new TM_Service_Configuration__c();
		config.productPm.product_Name__c = recordTypeName;
		Map<string, TmBoarding.RequestConfigPm> configMap = new Map<string, TmBoarding.RequestConfigPm>{recordTypeName => config};
		m_mockDataProvider.setup('getAllPageFieldConfigurationsByServiceType').returns(configMap);

		TmBoarding.ProductConfig result = sut.getProduct(recordTypeName);

		System.assertEquals(recordTypeName ,result.product);
	}

	@IsTest
    static void it_should_call_the_attachment_handler_to_get_template_bytes() {
		String attachmentName = 'attachment-name';
		TM_Service_Configuration__c config = new TM_Service_Configuration__c();
		config.Id = ObjectFactory.getFakeId(TM_Service_Configuration__c.SObjectType, '1');
		Attachment a = new Attachment();
		List<Attachment> attachments = new List<Attachment>{a};
		m_mockAttachmentProvider.setup('getAllAttachmentsForParent', new List<Object>{config.Id}).returns(attachments);

		Blob result = sut.getTemplateFromAttachment(attachmentName, config.Id);

		m_mockAttachmentProvider.verify('getAllAttachmentsForParent', new List<Object>{config.Id}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_dm_builder_to_get_all_objects() {		
		List<ISObjectField> fields = new List<ISObjectField>();
		m_mockSchema.setup('getFields', new List<Object>{TmConfiguration.CORE_CONTACT}).returns(fields);

		Map<String, DmSection> result = sut.getAllObjectSections();

		m_mockDmBuilder.verify('buildObjectFields', new List<Object>{fields, TmConfiguration.CORE_CONTACT}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_dataProvider_to_build_dynamic_request() {
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		List<string> requestFields = new List<string>();
		List<string> contactFields = new List<string>();
		List<string> accountFields = new List<string>();
		List<string> contactAccountFields = new List<string>();
		List<String> contactCoreFields = new List<string>();
		List<String> accountCoreFields = new List<string>();

		List<String> requests = new List<String>();
		List<String> contacts = new List<String>();
		List<String> accounts = new List<String>();
		List<String> contactRequests = new List<String>();
		List<String> accountRequests = new List<String>();
		List<String> contactAccountRequests = new List<String>();

		m_mockQueryBuilder.setup('addRequiredRequestFields', new List<Object>{requestFields}).returns(requests);
		m_mockQueryBuilder.setup('addRequiredContactFields', new List<Object>{contactCoreFields}).returns(contacts);
		m_mockQueryBuilder.setup('addRequiredAccountFields', new List<Object>{accountCoreFields}).returns(accounts);
		m_mockQueryBuilder.setup('addRequiredContactRequestFields', new List<Object>{contactFields}).returns(contactRequests);
		m_mockQueryBuilder.setup('addRequiredAccountRequestFields', new List<Object>{accountFields}).returns(accountRequests);
		m_mockQueryBuilder.setup('addRequiredContactAccountFields', new List<Object>{contactAccountFields}).returns(contactAccountRequests);

		TmBoarding.requestPm result  = sut.getRequest(requestId, requestFields, contactFields, accountFields, contactAccountFields, contactCoreFields, accountCoreFields);
		
		m_mockDataProvider.verify('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_call_data_provider_to_build_product_infos_when_packet_id_is_provided() {
		Id packetId = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');

		Map<string, TmConfiguration.ProductInfo> result = sut.getProductInfos(packetId);

		m_mockDataProvider.verify('getAllConfigurations', Times.Once);
		m_mockDataProvider.verify('getRequestsForPacket', new List<Object>{packetId}, Times.Once);
	}

	@IsTest
    static void it_should_call_dm_builder_to_build_product_infos_when_packet_id_is_provided() {
		Id packetId = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id cfgId = ObjectFactory.getFakeId(TM_Service_Configuration__c.SObjectType, '1');
		String product = 'prod';
		
		TM_Service_Request__c r = new TM_Service_Request__c(Id=requestId);
		r.RecordType = new RecordType(Name = product);
		TM_Service_Configuration__c cfg = new TM_Service_Configuration__c(Id=cfgId, Product_Name__c = 'prod');
		List<TM_Service_Configuration__c> cfgs = new List<TM_Service_Configuration__c>{cfg};
		List<TM_Service_Request__c> requests = new List<TM_Service_Request__c>{r};
		TmConfiguration.ProductInfo pi = new TmConfiguration.ProductInfo();
		pi.productType = new DmRecordType();
		pi.productType.name = product;
		m_mockDataProvider.setup('getAllConfigurations').returns(cfgs);
		m_mockDataProvider.setup('getRequestsForPacket', new List<Object>{packetId}).returns(requests);
		m_mockDmBuilder.setup('buildProductInfo', new List<Object>{r, cfg}).returns(pi);

		Map<string, TmConfiguration.ProductInfo> result = sut.getProductInfos(packetId);

		m_mockDmBuilder.verify('buildProductInfo', new List<Object>{r, cfg}, Times.Once);
	}

	@IsTest
    static void it_should_call_dm_builder_to_build_product_infos_by_request_id_when_packet_id_is_provided() {
		Id packetId = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id cfgId = ObjectFactory.getFakeId(TM_Service_Configuration__c.SObjectType, '1');
		String product = 'prod';
		
		TM_Service_Request__c r = new TM_Service_Request__c(Id=requestId);
		r.RecordType = new RecordType(Name = product);
		TM_Service_Configuration__c cfg = new TM_Service_Configuration__c(Id=cfgId, Product_Name__c = 'prod');
		List<TM_Service_Configuration__c> cfgs = new List<TM_Service_Configuration__c>{cfg};
		List<TM_Service_Request__c> requests = new List<TM_Service_Request__c>{r};
		TmConfiguration.ProductInfo pi = new TmConfiguration.ProductInfo();
		pi.productType = new DmRecordType();
		pi.productType.name = product;
		m_mockDataProvider.setup('getAllConfigurations').returns(cfgs);
		m_mockDataProvider.setup('getRequestsForPacket', new List<Object>{packetId}).returns(requests);
		m_mockDmBuilder.setup('buildProductInfo', new List<Object>{r, cfg}).returns(pi);

		Map<string, TmConfiguration.ProductInfo> result = sut.getProductInfos(packetId);

		m_mockDmBuilder.verify('buildProductInfo', new List<Object>{r, cfg}, Times.Once);
	}
}