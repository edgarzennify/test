@IsTest
private class TmBoardingRepositoryTests {
	
    private static TmBoardingRepository sut;
    private static final TmBoardingMock.ofIDataProvider mockDataProvider;
	private static final TmBoardingMock.ofIDmBuilder mockDmBuilder;
	private static final TmConfigurationMock.ofIStageRepository mockStageRepository;
	private static final Mock.ofIErrorRepository mockErrors;
    private static final TmBoardingMock.ofIEbAccountRelBuilder mockEbAccountBuilder;
    private static final TmBoardingMock.ofISmVerifier mockSmVerifier;
    
    static {
        mockDataProvider = new TmBoardingMock.ofIDataProvider();
        mockDmBuilder = new TmBoardingMock.ofIDmBuilder();
        mockStageRepository = new TmConfigurationMock.ofIStageRepository();
        mockErrors = new Mock.ofIErrorRepository();
        mockEbAccountBuilder = new TmBoardingMock.ofIEbAccountRelBuilder();
        mockSmVerifier = new TmBoardingMock.ofISmVerifier();
        sut = new TmBoardingRepository(mockDataProvider, mockDmBuilder, mockStageRepository, mockErrors, mockEbAccountBuilder, mockSmVerifier);
    }
    
    @IsTest
    static void it_should_build_metadata() {
        String recordTypeName = 'Lockbox';
        TM_Service_Request_Packet__c packet = new TM_Service_Request_Packet__c();
        insert packet;
        TM_Service_Request_Stage__c stg = new TM_Service_Request_Stage__c(Name = 'New');
        insert stg;
        RecordType rt = Utility.recordTypeObject('TM_Service_Request__c', 'Lockbox');
        TM_Service_Request__c record = new TM_Service_Request__c( TM_Service_Request_Packet__c = packet.Id, Stage__c = stg.Id);
        record.RecordType = rt;
        record.RecordTypeId = rt.Id; 
        insert record;
        TmBoarding.RequestConfigPm requestConfigPm = new TmBoarding.RequestConfigPm();
        mockDataProvider.setup('getPageFieldConfigurationsByServiceType' , new List<Object>{recordTypeName}).returns(requestConfigPm);
        
        TmBoarding.RequestConfigPm result =  sut.getMetaData(record);
        
        mockDataProvider.verify('getPageFieldConfigurationsByServiceType' , new List<Object>{recordTypeName}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_build_data() {
        String recordTypeName = 'Lockbox';
    
        Account entity = new Account(Name = 'entity 1');
        insert entity;
        TM_Service_Request_Packet__c packet = new TM_Service_Request_Packet__c();
        packet.Entity__c = entity.Id;
        insert packet;
        TM_Service_Request_Stage__c stg = new TM_Service_Request_Stage__c(Name = 'New');
        insert stg;
        RecordType rt = Utility.recordTypeObject('TM_Service_Request__c', 'Lockbox');
        TM_Service_Request__c record = new TM_Service_Request__c();
        record.TM_Service_Request_Packet__c = packet.Id;
        record.Stage__c = stg.Id;
        record.RecordType = rt;
        record.RecordTypeId = rt.Id; 
        insert record;
        record = [SELECT Id, Name,RecordTypeId, TM_Service_Request_Packet__c, Stage__c, TM_Service_Request_Packet__r.Entity__r.id, TM_Service_Request_Packet__r.Entity__c  FROM TM_Service_Request__c WHERE id =: record.Id limit 1];
        TmBoarding.RequestConfigPm requestConfigPm = new TmBoarding.RequestConfigPm();
        TmBoarding.ServiceMetadata meta = new TmBoarding.ServiceMetadata();
        meta.Fields = new List<TmBoarding.Field>();
        meta.ServiceOptions = new List<TmBoarding.ServiceOption>();
        meta.ContactFields = new TmBoarding.FieldCategory();
        meta.ContactFields.RelatedFields = new TmBoarding.FieldCategory();
        meta.AccountFields = new TmBoarding.FieldCategory();
        meta.AccountFields.RelatedFields = new TmBoarding.FieldCateGory();

        DmEntity entityDm = new DmEntity();
        entityDm.id = entity.id;
        entityDm.name = entity.name;
        Map<String, DmEntity> relMap = new Map<String, DmEntity>{ entityDm.id => entityDm};
        mockDataProvider.setup('getPageFieldConfigurationsByServiceType' , new List<Object>{recordTypeName}).returns(requestConfigPm);
        mockDataProvider.setup('getPacketFromRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(record);
        mockDmBuilder.setup('getConfigurationsByService', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(meta);
        mockEbAccountBuilder.setup('getRelatedEntitiesIncludingParent', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(relMap);

        TmBoarding.RequestPm result = sut.getData(record);
        
        mockDataProvider.verify('getRequestWithRelatedEbAccounts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockDataProvider.verify('getPacketFromRequest', new List<Object>{record}, Times.Once);
        mockEbAccountBuilder.verify('getRelatedEntitiesIncludingParent', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void it_should_get_existing_account() {
        Integer app = 2;
        String accountNumber = '1122';
        Eb_Account__c abt = new Eb_Account__c();
        List<Eb_Account__c> accounts = new List<Eb_Account__c>{abt};
        mockdataProvider.setup('getEbAccount' , ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(accounts);
        
        DmEbAccount result =  sut.getExistingAccountByNumber(app, accountNumber);
        
        mockDmBuilder.verify('getEbAccount', new List<Eb_Account__c>{abt}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_an_existing_account_when_account_id_is_passed() {
        String ebaccountId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');
        Integer app = 2;
        String accountNumber = '1122';
        Eb_Account__c abt = new Eb_Account__c(Id = ebaccountId);
        List<Eb_Account__c> accounts = new List<Eb_Account__c>{abt};
        mockdataProvider.setup('getEbAccount' , new List<Object>{ebaccountId}).returns(abt);
       
        DmEbAccount result =  sut.getExistingAccountById(ebaccountId);
        
        mockDmBuilder.verify('getEbAccount', new List<Eb_Account__c>{abt}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_record_types_from_request() {
        List<DmRecordType> result = sut.getRecordTypesForTmRequest();
        
        mockDmBuilder.verify('getRequestRecordTypes', Times.Once);
    }
    
    @IsTest
    static void it_should_get_stage_details_when_request_id_is_provided() {
        Id requestId = ObjectFactory.getFakeId(Tm_service_Request__c.SObjectType, '1');
        
        DmTmRequestStage result = sut.getStageDetail(requestId);
        
        mockStageRepository.verify('getStageDetail', new List<OBject>{requestId}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_default_stage() {
        DmTmRequestStage result =  sut.getDefaultStage();
        
        mockStageRepository.verify('getDefaultStage', Times.Once);
    }
    
    @IsTest
    static void it_should_save_the_core_sm() {
        TmBoarding.CoreSm sm = new TmBoarding.CoreSm();
        mockDataProvider.setup('saveObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<string>());
        
        sut.save(sm);
        
        mockDataProvider.verify('saveObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void it_should_save_the_related_sms() {
        TmBoarding.RelatedSm sm = new TmBoarding.RelatedSm();
        sm.contactRelationships = new List<TM_Service_Request_Contact__c>();
        sm.accountRelationships = new List<TM_Service_Request_Account__c>();

        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = new TM_Service_Request__c();
        mockDataProvider.setup('getRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestPm);
        mockSmVerifier.setup('verifyRelatedSm', new List<Object>{sm, requestPm}).returns(sm);
        mockDataProvider.setup('saveObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<string>());
        
        sut.save(sm, requestPm.requestPm.id);
        
        mockDataProvider.verify('saveObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockSmVerifier.verify('verifyRelatedSm', new List<Object>{sm, requestPm}, Times.Once);
    }
    
    @IsTest
    static void it_should_save_the_related_related_sms() {
        TmBoarding.RelatedRelatedSm sm = new TmBoarding.RelatedRelatedSm ();
        sm.contactAccountRelationships = new List<TM_Service_Request_Contact_Account__c>();
        mockDataProvider.setup('saveObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<string>());    
        
        sut.save(sm);
        
		mockDataProvider.verify('saveObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);        
    }
    
    @IsTest
    static void it_should_save_an_object() {
        Account entity = new Account();
        mockdataProvider.setup('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<string>());
        
        sut.save((SObject)entity);
        
        mockdataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void it_should_remove_an_object() {
        TmBoarding.RelatedSm sm = new TmBoarding.RelatedSm();
        sm.deleteContactRelationships = new List<Tm_Service_Request_Contact__c>();
        sm.deleteAccountRelationships = new List<Tm_Service_Request_Account__c>();
        mockErrors.setup('addErrors', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<string>{'error'});
        mockdataProvider.setup('removeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<string>{'error'});

        sut.remove(sm);
        
        mockdataProvider.verify('removeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void it_should_remove_a_related_object() {
        TmBoarding.RelatedRelatedSm sm = new TmBoarding.RelatedRelatedSm();
        sm.deleteContactAccountRelationships = new List<Tm_Service_Request_Contact_Account__c>();
        mockErrors.setup('addErrors', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<string>{'error'});
        mockdataProvider.setup('removeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<string>{'error'});

        sut.remove(sm);
        
        mockdataProvider.verify('removeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_save_objects() {
        Contact entity = new Contact(LastName = 'last-name');
        List<SObject> sobjs = new List<SObject>();

        sut.save(sobjs);

        mockdataProvider.verify('saveObjects', new List<Object>{sobjs}, Times.Once);
    }

    @IsTest
    static void it_should_get_all_stages() {
        List<DmTmRequestStage> result = sut.getAllStages();

        mockStageRepository.verify('getAllStages', Times.Once);
    }
}