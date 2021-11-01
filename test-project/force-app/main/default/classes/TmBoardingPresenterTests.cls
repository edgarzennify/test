@IsTest
private class TmBoardingPresenterTests {

	private static final TmBoardingMock.ofIVmBuilder mockVmBuilder;
	private static final TmBoardingMock.ofIRepository mockRepository;
	private static final TmConfigurationMock.ofIRepository mockConfigRepository;
	private static final TmBoardingMock.ofIDataMapBuilder mockDataMapBuilder;
	private static final TmValidatorMock.ofIRuleRunnerProvider mockValidator;
	private static final TmBoardingMock.ofIValidationEngine mockValidationEngine;
	private static final TmBoardingMock.ofIAccountProvider mockAccountProvider;
	private static final TmBoardingMock.ofISmBuilder mockSmBuilder;
	private static final Mock.ofIErrorRepository mockErrors;
	private static final TmOpportunityConverterMock.ofIRepository mockOpportunityConverter;
	private static final Mock.ofIObjectActionLogService mockObjectActionLogService;
	private static final TmBoardingMock.ofIReportHelper mockReportHelper;

	private static final TmBoardingPresenter sut;


	static {
		mockVmBuilder = new TmBoardingMock.ofIVmBuilder();
		mockRepository = new TmBoardingMock.ofIRepository();
		mockConfigRepository = new TmConfigurationMock.ofIRepository();
		mockDataMapBuilder = new TmBoardingMock.ofIDataMapBuilder();
		mockValidator = new TmValidatorMock.ofIRuleRunnerProvider();
		mockValidationEngine = new TmBoardingMock.ofIValidationEngine();
		mockAccountProvider = new TmBoardingMock.ofIAccountProvider();
		mockSmBuilder = new TmBoardingMock.ofISmBuilder();
		mockErrors = new  Mock.ofIErrorRepository();
		mockOpportunityConverter = new TmOpportunityConverterMock.ofIRepository();
		mockObjectActionLogService = new Mock.ofIObjectActionLogService();
		mockReportHelper = new TmBoardingMock.ofIReportHelper();
		sut = new TmBoardingPresenter( mockVmBuilder, mockRepository, mockConfigRepository, mockDataMapBuilder, mockValidator, mockValidationEngine, mockAccountProvider, mockSmBuilder, mockErrors, mockOpportunityConverter, mockObjectActionLogService, mockReportHelper);
	}

	@IsTest
	static void it_should_build_the_form_vm() {
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		pm.packetPm = new Tm_Service_Request_Packet__c();
		TmBoarding.FormMetadata formMeta = new TmBoarding.FormMetadata();
		Map<string, TmConfiguration.ProductInfo> productInfos = new Map<string, TmConfiguration.ProductInfo>();
		mockRepository.setup('getdata', new List<Object>{record}).returns(pm);

		TmBoarding.FormComponent formComponent = new TmBoarding.FormComponent();
		formComponent.EditMetadata = new TmBoarding.FormMetadata();
		formComponent.ViewMetadata = new TmBoarding.FormMetadata();
		Map<string, List<TmValidator.ValidationResults>> validationsByStage = new Map<string, List<TmValidator.ValidationResults>>();
		Map<string, TmValidator.ValidationResults> validationLookup = new Map<string, TmValidator.ValidationResults>();
		mockvalidator.setup('ValidationByStageMetadata', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(validationsByStage);    
        mockvalidator.setup('ValidationLookup', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(validationLookup);
        mockDataMapBuilder.setup('buildDetails', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new TmBoarding.DataComponent()); 
        mockVmBuilder.setup('buildDetails',  ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(formComponent);
		mockValidationEngine.setup('addValidation', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(formMeta);

		TmBoarding.FormVm result =  sut.getFormVm(record);

		mockvmBuilder.verify('buildDetails' ,  ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
	static void it_should_build_the_entity_form_vm() {
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		pm.packetPm = new Tm_Service_Request_Packet__c();
		TmBoarding.FormMetadata formMeta = new TmBoarding.FormMetadata();
		Map<string, TmConfiguration.ProductInfo> productInfos = new Map<string, TmConfiguration.ProductInfo>();
		mockRepository.setup('getdata', new List<Object>{record}).returns(pm);

		TmBoarding.FormComponent formComponent = new TmBoarding.FormComponent();
		formComponent.EditMetadata = new TmBoarding.FormMetadata();
		formComponent.ViewMetadata = new TmBoarding.FormMetadata();
		Map<string, List<TmValidator.ValidationResults>> validationsByStage = new Map<string, List<TmValidator.ValidationResults>>();
		Map<string, TmValidator.ValidationResults> validationLookup = new Map<string, TmValidator.ValidationResults>();
		mockConfigRepository.setup('getProductInfos', new List<Object>{pm.packetPm.Id}).returns(productInfos);

		TmBoarding.EntityFormVm result =  sut.getEntityFormVm(record);

		mockvmBuilder.verify('getEntity' , new List<Object>{pm}, Times.Once);
	}

	@IsTest
	static void it_should_build_the_entity_form_vm_and_call_permission_when_stage_exists_on_request() {
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		pm.packetPm = new Tm_Service_Request_Packet__c();
		TmBoarding.FormMetadata formMeta = new TmBoarding.FormMetadata();
		mockRepository.setup('getdata', new List<Object>{record}).returns(pm);

		TmBoarding.FormComponent formComponent = new TmBoarding.FormComponent();
		formComponent.EditMetadata = new TmBoarding.FormMetadata();
		formComponent.ViewMetadata = new TmBoarding.FormMetadata();
		Map<string, List<TmValidator.ValidationResults>> validationsByStage = new Map<string, List<TmValidator.ValidationResults>>();
		Map<string, TmValidator.ValidationResults> validationLookup = new Map<string, TmValidator.ValidationResults>();
		Map<string, TmConfiguration.ProductInfo> productInfos = new Map<string, TmConfiguration.ProductInfo>();
		TmBoarding.LayoutComponent entity = new TmBoarding.LayoutComponent();
		DmTmRequestStage stageDm = new DmTmRequestStage();
		stageDm.name = 'stage-name';
		TmBoarding.LayoutComponentStage stageComponent = new TmBoarding.LayoutComponentStage();
		stageComponent.Name = stageDm.name;
		pm.packetPm = new Tm_Service_Request_Packet__c();
		mockvmBuilder.setup('getEntity' , new List<Object>{pm}).returns(entity);
		mockRepository.setup('getStageDetail', new List<Object>{record.id}).returns(stageDm);
		mockvmBuilder.setup('buildStages', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(stageComponent);
		mockConfigRepository.setup('getProductInfos', new List<Object>{pm.packetPm.Id}).returns(productInfos);


		TmBoarding.EntityFormVm result =  sut.getEntityFormVm(record);

		mockvmBuilder.verify('getPermission', new List<Object>{stageDm}, Times.Once);
	}

	@IsTest
	static void it_should_build_the_form_vm_and_call_the_vm_builder_to_buid_account_types() {
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		pm.packetPm = new Tm_Service_Request_Packet__c();
		TmBoarding.FormMetadata formMeta = new TmBoarding.FormMetadata();
		Map<string, TmConfiguration.ProductInfo> productInfos = new Map<string, TmConfiguration.ProductInfo>();
		mockRepository.setup('getdata', new List<Object>{record}).returns(pm);

		TmBoarding.FormComponent formComponent = new TmBoarding.FormComponent();
		formComponent.EditMetadata = new TmBoarding.FormMetadata();
		formComponent.ViewMetadata = new TmBoarding.FormMetadata();
		Map<string, List<TmValidator.ValidationResults>> validationsByStage = new Map<string, List<TmValidator.ValidationResults>>();
		Map<string, TmValidator.ValidationResults> validationLookup = new Map<string, TmValidator.ValidationResults>();
		
		TmBoarding.LayoutComponent entity = new TmBoarding.LayoutComponent();
		DmTmRequestStage stageDm = new DmTmRequestStage();
		stageDm.name = 'stage-name';
		TmBoarding.LayoutComponentStage stageComponent = new TmBoarding.LayoutComponentStage();
		stageComponent.Name = stageDm.name;

		TmBoarding.LayoutPickList pl = new TmBoarding.LayoutPickList();
		pl.Label = 'Checking';
		pl.Value = 'Checking';
		List<TmBoarding.LayoutPickList> accountTypes = new List<TmBoarding.LayoutPickList>{pl};

		mockvmBuilder.setup('getEntity' , new List<Object>{pm}).returns(entity);
		mockRepository.setup('getStageDetail', new List<Object>{record.id}).returns(stageDm);
		mockvmBuilder.setup('buildStages', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(stageComponent);
		mockvmBuilder.setup('getAccountTypes').returns(accountTypes);
		mockConfigRepository.setup('getProductInfos', new List<Object>{pm.packetPm.Id}).returns(productInfos);

		TmBoarding.EntityFormVm result =  sut.getEntityFormVm(record);

		mockvmBuilder.verify('getAccountTypes', Times.Once);
	}

	@IsTest
	static void it_should_build_the_form_vm_for_new_request() {
		Id stageId = ObjectFactory.getFakeId(Tm_Service_Request_Stage__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c();
		RecordType rt = new RecordType(Name = 'lockbox');
		record.RecordType = rt;
		record.RecordType.Name = rt.Name;
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		pm.packetPm = new Tm_Service_Request_Packet__c();
		Map<string, TmConfiguration.ProductInfo> productInfos = new Map<string, TmConfiguration.ProductInfo>();
		TmBoarding.FormMetadata formMeta = new TmBoarding.FormMetadata();
		mockRepository.setup('getdata', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(pm);
		DmTmRequestStage stg = new DmTmRequestStage();
		stg.Id = stageId;
		stg.Name = 'New';

		TmBoarding.FormComponent formComponent = new TmBoarding.FormComponent();
		formComponent.EditMetadata = new TmBoarding.FormMetadata();
		formComponent.ViewMetadata = new TmBoarding.FormMetadata();
		Map<string, List<TmValidator.ValidationResults>> validationsByStage = new Map<string, List<TmValidator.ValidationResults>>();
		Map<string, TmValidator.ValidationResults> validationLookup = new Map<string, TmValidator.ValidationResults>();
		mockvalidator.setup('ValidationByStageMetadata', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(validationsByStage);    
        mockvalidator.setup('ValidationLookup', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(validationLookup);
        mockDataMapBuilder.setup('buildDetails', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new TmBoarding.DataComponent()); 
        mockVmBuilder.setup('buildDetails',  ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(formComponent);
		mockValidationEngine.setup('addValidation', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(formMeta);
		mockRepository.setup('getDefaultStage').returns(stg);

		TmBoarding.FormVm result =  sut.getFormVm(record);

		mockDataMapBuilder.verify('buildDetails', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	
	@IsTest
	static void it_should_build_detail_vms() {
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		pm.packetPm = new Tm_Service_Request_Packet__c();
		TmBoarding.FormMetadata formMeta = new TmBoarding.FormMetadata();
		Map<string, TmConfiguration.ProductInfo> productInfos = new Map<string, TmConfiguration.ProductInfo>();
		mockRepository.setup('getdata', new List<Object>{record}).returns(pm);

		TmBoarding.FormComponent formComponent = new TmBoarding.FormComponent();
		formComponent.EditMetadata = new TmBoarding.FormMetadata();
		formComponent.ViewMetadata = new TmBoarding.FormMetadata();
		Map<string, List<TmValidator.ValidationResults>> validationsByStage = new Map<string, List<TmValidator.ValidationResults>>();
		Map<string, TmValidator.ValidationResults> validationLookup = new Map<string, TmValidator.ValidationResults>();
		mockvalidator.setup('ValidationByStageMetadata', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(validationsByStage);    
        mockvalidator.setup('ValidationLookup', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(validationLookup);
        mockDataMapBuilder.setup('buildDetails', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new TmBoarding.DataComponent()); 
        mockVmBuilder.setup('buildDetails',  ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(formComponent);
		mockValidationEngine.setup('addValidation', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(formMeta);
		mockConfigRepository.setup('getProductInfos', new List<Object>{pm.packetPm.Id}).returns(productInfos);

		TmBoarding.FormVm result =  sut.getDetailFormVm( record);

		mockRepository.verify('getStageDetail' , ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockVmBuilder.verify('buildStages', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockVmBuilder.verify('getPacket', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
	static void it_should_build_contact_account() {
		Id ebaId1 = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		String accountId = ebaId1;
		Eb_Account__c eba = new Eb_Account__c(Id = ebaId1);
		List<String> relatedContactIds = new List<String>{'rel-contact-id'};
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		pm.accountPms = new List<Eb_Account__c>{eba};
		TmBoarding.FormMetadata formMeta = new TmBoarding.FormMetadata();
		mockRepository.setup('getdata', new List<Object>{record}).returns(pm);

		DmSection accountSection = new DmSection();
		DmField fld1 = new DmField();
		List<DmField> flds = new List<DmField>{fld1};
		accountSection.Fields = flds;
		List<DmSection> accountsAll = new List<DmSection>{accountSection};
		mockConfigRepository.setup('getAccountSections2', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(accountsAll);
        mockConfigRepository.setup('getFields', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(flds);

		TmBoarding.FormModalVm result = sut.buildContactAccounts(accountId, relatedContactIds, record);

		mockVmBuilder.verify('buildAccounts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
	static void it_should_build_account_contact_vms() {

		String contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		Contact c = new Contact(Id = contactId);
		List<String> relatedAccountIds = new List<String>{'rel-account-id'};
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);

		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		pm.contactPms = new List<Contact>{c};
		TmBoarding.FormMetadata formMeta = new TmBoarding.FormMetadata();
		mockRepository.setup('getdata', new List<Object>{record}).returns(pm);

		DmSection contactSection = new DmSection();
		DmField fld1 = new DmField();
		List<DmField> flds = new List<DmField>{fld1};
		contactSection.Fields = flds;
		List<DmSection> contactsAll = new List<DmSection>{contactSection};
		mockConfigRepository.setup('getContactSections2', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(contactsAll);
        mockConfigRepository.setup('getFields', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(flds);

		TmBoarding.FormModalVm result = sut.buildAccountContacts(contactId, relatedAccountIds, record);

		mockVmBuilder.verify('buildContacts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
	static void it_should_get_vaidations() {
		TmValidator.ValidationRequest req = new TmValidator.ValidationRequest();
		req.ObjectName = TmConfiguration.TM_REQUEST;
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		RecordType rt = new RecordType(Name = 'lockbox-test');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
		record.RecordType = rt;
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;

		DmField detailDm = new DmField();
		DmField dependentDm = new DmField();
		List<DmField> detailsAllFields = new List<DmField>{detailDm};
		List<DmField> schedulesAllFields = new List<DmField>{dependentDm};
		mockRepository.setup('getdata', new List<Object>{record}).returns(pm);


		mockConfigRepository.setup('getDetailSections2' ,ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<DmSection>());
        mockConfigRepository.setup('getScheduleSections2', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<DmSection>());
		mockConfigRepository.setup('getFields', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(detailsAllFields);

		List<TmValidator.ValidationResult> result = sut.getValidations(req, record);

		mockConfigRepository.verify('getFields', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.AtLeastOnce);
	}


	@IsTest
	static void it_should_save_a_new_service_request() {
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
		
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();

		TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
		sm1.fieldName = 'TM_Service_Request__c.Domestic_Wires__c';
		sm1.FieldValue = (Object) true;
		TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
		sm2.fieldName = 'TM_Service_Request__c.International_Wires__c';
		sm2.FieldValue = (Object) false;
		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm1, sm2};
		TM_Service_Request__c newRecord = new TM_Service_Request__c();
		newRecord.Domestic_Wires__c = true;
		newRecord.International_Wires__c = false;

		TmBoarding.coreSm coreSm = new TmBoarding.coreSm();
		TmBoarding.relatedSm relatedSm = new TmBoarding.relatedSm();

		Set<String> excluded = new Set<String>();
		mockRepository.setup('getdata', new List<Object>{record}).returns(pm);
		mockRepository.setup('getMetaData', new List<Object>{record}).returns(metadata);
		mockSmBuilder.setup('buildNewCoreRequest', new List<Object>{sms, pm}).returns(newRecord);
		mockSmBuilder.setup('getExcludedFieldsFromRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(excluded);
		mockSmBuilder.setup('removeValuesFromRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(newRecord);

		mockSmBuilder.setup('coreSmBuilder' , ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(coreSm);
		mockSmBuilder.setup('relatedSmBuilder' , ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(relatedSm);
		mockErrors.setup('getUniqueErrors').returns(new List<string>());

		List<String> result = sut.saveRequest(sms, record);

		mockRepository.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.AtLeastOnce);
	}


	@IsTest
	static void it_should_save_a_new_service_contact() {
		Boolean isNew = true;
		Id recordId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = recordId);
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		Contact ct = new Contact(Id=contactId);
		TmBoarding.CoreSm coreSm = new TmBoarding.CoreSm();
		coreSm.request = record;
		coreSm.Contacts = new List<Contact>{ct};
		TmBoarding.RelatedSm relatedSm = new TmBoarding.RelatedSm();
		TmBoarding.RelatedRelatedSm relatedRelatedSm = new TmBoarding.RelatedRelatedSm();
		relatedRElatedSm.contactAccountRelationships = new List<Tm_Service_Request_Contact_Account__c>();

		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
		mockRepository.setup('getMetaData', new List<Object>{record}). returns(metadata);
		mockRepository.setup('getdata', new List<Object>{record}). returns(pm);
		mockSmBuilder.setup('coreSmBuilder', new List<Object>{sms, pm}).returns(coreSm);
		mockSmBuilder.setup('relatedSmBuilder', new List<Object>{coreSm, sms, pm}).returns(relatedSm);
		mockSmBuilder.setup('buildEditServiceContact', new List<Object>{relatedSm, sms, pm}).returns(relatedSm);
		mockSmBuilder.setup('buildNewCoreContact', new List<Object>{ sms, pm}).returns(ct);
		mockSmBuilder.setup('buildServiceContactAccount', new List<Object>{ relatedSm, sms, pm}).returns(relatedRelatedSm);

		List<String> result = sut.saveContact(sms, isNew, record);

		mockSmBuilder.verify('buildNewRequestContactForNewContact', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
	static void it_should_save_a_new_service_account() {
		Boolean isNew = true;
		Id recordId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
		Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = recordId);
		TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;
		pm.entityPm = new Account(id = entityId);
		Eb_Account__c act = new Eb_Account__c(Id=accountId);
		TmBoarding.CoreSm coreSm = new TmBoarding.CoreSm();
		coreSm.request = record;
		coreSm.accounts = new List<Eb_Account__c>{act};
		TmBoarding.RelatedSm relatedSm = new TmBoarding.RelatedSm();
		TmBoarding.RelatedRelatedSm relatedRelatedSm = new TmBoarding.RelatedRelatedSm();
		relatedRelatedSm.contactAccountRelationships = new List<Tm_Service_Request_Contact_Account__c>();

		List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
		mockRepository.setup('getMetaData', new List<Object>{record}). returns(metadata);
		mockRepository.setup('getdata', new List<Object>{record}). returns(pm);
		mockSmBuilder.setup('coreSmBuilder', new List<Object>{sms, pm}).returns(coreSm);
		mockSmBuilder.setup('relatedSmBuilder', new List<Object>{coreSm, sms, pm}).returns(relatedSm);
		mockSmBuilder.setup('buildEditServiceAccount', new List<Object>{relatedSm, sms, pm}).returns(relatedSm);
		mockSmBuilder.setup('buildNewCoreAccount', new List<Object>{ sms, pm}).returns(act);
		mockSmBuilder.setup('buildServiceContactAccount', new List<Object>{ relatedSm, sms, pm}).returns(relatedRelatedSm);

		List<String> result = sut.saveAccount(sms, isNew, record, new TmBoarding.NewAccountDetails());

		mockSmBuilder.verify('buildNewRequestAccountForNewAccount', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
	static void it_should_get_the_account_search_results() {
		String param = '1122';
		List<TmBoarding.AccountSearchResult> result =  sut.getAccountSearchResult(param);

		mockAccountProvider.verify('searchAccount', new List<Object>{param}, Times.Once);
	}

	@IsTest
	static void it_should_generate_a_new_number_when_account_number_type_is_provided() {
		String accountType = 'TmOperation';

		TmBoarding.AccountGeneratorResult result = sut.generateNewAccountNumber(accountType);

		mockaccountProvider.verify('generateNewAccountNumber', new List<Object>{accountType}, Times.Once);
	}

	@IsTest
	static void it_should_build_validation_results_when_stages_are_given() {
		string stageId = 'stage-id';
		string product = 'test-product';
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		RecordType rt = new RecordType(Name=product);
		TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
		record.RecordType = rt;
		record.RecordType.Name = rt.Name;
		record.RecordTypeId = rt.Id;
		List<string> stageIds = new List<string>{stageId};

		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = record;

		mockRepository.setup('getdata', new List<Object>{record}).returns(pm);
		mockConfigRepository.setup('getFields', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<DmField>());

		TmBoarding.ExistingDataValidationVm result = sut.validateTmRequest(record, stageIds);

		mockValidator.verify('ValidateExistingTmRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		mockRepository.verify('getAllStages', Times.Once);
	}

	@IsTest
	static void it_should_build_all_stages() {
		DmTmRequestStage dm = new DmTmRequestStage();
		dm.id = 'test-id';
		dm.name = 'test-name';
		List<DmTmRequestStage> dms = new List<DmTmRequestStage>{dm};
		mockRepository.setup('getAllStages').returns(dms);

		List<TmBoarding.LayoutComponentStage> result = sut.getAllStages();

		mockvmBuilder.verify('getAllStages', new List<object>{dms}, Times.Once);
	}

	@IsTest
	static void it_should_update_stage() {
		Id recordId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id stageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = recordId);

		sut.updateStage(record, stageId);

		mockRepository.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
	static void it_should_not_update_stage_when_stage_id_is_empty() {
		Id recordId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		Id stageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id = recordId);

		sut.updateStage(record, null);

		mockRepository.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
	}

	@IsTest
	static void it_should_return_a_list_of_logs_when_requested() {
		ObjectActionLogService.Data data = new ObjectActionLogService.Data();
		data.Action = 'test';
		data.CreatedBy = new DmUser();
		data.CreatedDate = System.now();
		List<ObjectActionLogService.Data> returnData = new List<ObjectActionLogService.Data>{data};

		TM_Service_Request__c record = new TM_Service_Request__c();
		record.Id = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');

		ObjectActionLogService.ObjectAndTypeRequest request = new ObjectActionLogService.ObjectAndTypeRequest();
		request.ObjectRecordId = record.Id;
		request.ActionType = 'Stage Logging';

		mockObjectActionLogService.setup('get',new List<Object>{request}).returns(returnData);

		List<TmBoarding.StageLog> results = sut.getStageLogs(record);

		System.assertEquals(1, results.size()); 
	}

	@IsTest
	static void it_should_return_a_list_of_record_types_for_each_product() {
		DmRecordType dmRecord = new DmRecordType();
		dmRecord.Name = 'test';
		List<DmRecordType> recordTypes = new List<DmRecordType>{dmRecord};

		mockRepository.setup('getRecordTypesForTmRequest').returns(recordTypes);

		List<TmBoarding.NameValue> results = sut.getAllProducts();

		system.assertEquals('test', results[0].name);
	}

	@IsTest
	static void it_should_update_ops_assignee() {
		String packetId = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '1');
		String requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		String assigneeName = 'test-name';

		Tm_Service_Request__c req = new Tm_Service_Request__c(id = requestId); 
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.requestPm = req;
		List<TmBoarding.RequestPm> products = new List<TmBoarding.RequestPm>{pm};
		List<SObject> reqs = new List<Tm_Service_Request__c>{req};
		mockrepository.setup('getRequestPmsForPacket', new List<Object>{packetId}).returns(products);
		mockSmBuilder.setup('updateProductAssignee', new List<Object>{products, assigneeName}).returns(reqs);

		sut.updateOpsAssignee(packetId, assigneeName);

		mockrepository.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> args = mockrepository.getArgumentsFromCall('save');
		List<TM_Service_Request__c> result = (List<TM_Service_Request__c>)args[0];
		System.assertEquals(requestId, result[0].id);
	}

	@IsTest
	static void it_should_get_stage_notes(){
		Id requestId = null;
		Tm_Service_Request__c req = new Tm_Service_Request__c(Id = requestId);
		List<string> fields = new List<string>{'Id', 'TM_Service_Request_Packet__r.Id', 'TM_Service_Request_Packet__r.Entity__r.Id', 'Notes__c'};
		TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
		requestPm.requestPm = new Tm_service_Request__c(Notes__c = 'test');
		mockRepository.setup('getRequestById', new List<Object>{req.Id, fields}).Returns(requestPm);

		string result = sut.getStageNotes(req);

		mockRepository.verify('getRequestById', new List<object>{req.Id, fields}, Times.Once);
	}

	@IsTest
	static void it_should_save_stage_notes() {
		Id requestId = null;
		Tm_Service_Request__c req = new Tm_Service_Request__c(Id = requestId);
		String notes = '';

		sut.saveStageNotes(req, notes);

		mockRepository.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
	static void it_should_validate_tm_requests_by_current_stage_by_calling_the_validator(){
		string packetId='';
		List<string> tmRequests = new List<string>{'test123'};
		Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		TmBoarding.ReportDataHolder dataHolder = new TmBoarding.ReportDataHolder();
		dataHolder.requestPms = new Map<Id, TmBoarding.RequestPm>{requestid => new TmBoarding.RequestPm()};
		TmConfiguration.ObjectDmFields objFields = new TmConfiguration.ObjectDmFields();
		objFields.requestFields = new List<DmField>();
		dataHolder.objectFieldsByRequestId = new Map<Id, TmConfiguration.ObjectDmFields>{requestId => new TmConfiguration.ObjectDmFields()};
		Map<string, TmConfiguration.ProductInfo> allProductInfos = new Map<string, TmConfiguration.ProductInfo>();
		Map<Tm_Service_Request__c, List<DmField>> fields = new Map<Tm_Service_Request__c, List<DmField>>();
		List<string> products = new List<string>();
		List<TmValidator.ValidationResultByProductByStage> vldResults = new List<TmValidator.ValidationResultByProductByStage>();
	    mockConfigRepository.setup('getProductInfosByRequestId', new List<Object>{packetId}).Returns(allProductInfos);
		mockReportHelper.setup('buildBulkRequestPmData', new List<Object>{allProductInfos, tmRequests}).returns(dataHolder);

		List<TmValidator.ValidationResult> result = sut.validateTmRequestsByCurrentStage(packetId, tmRequests);

		mockValidator.setup('ValidateTmRequestsByCurrentStage', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(vldResults);
	}
	
}