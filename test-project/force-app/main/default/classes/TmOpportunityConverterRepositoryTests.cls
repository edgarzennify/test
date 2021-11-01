@IsTest
private class TmOpportunityConverterRepositoryTests {

	private static final TmOpportunityConverterRepository sut;

	private static final TmBoardingMock.ofIDataProvider mockDataProvider;
	private static final TmOpportunityConverterMock.ofIDmBuilder mockDmBuilder;
	private static final TmOpportunityConverterMock.ofIOpportunityBuilder mockOpportunityBuilder;
	private static final Mock.ofIUtility mockUtility;
	private static final TmConfigurationMock.ofIStageRepository mockStageRepository;
	private static final TmOpportunityConverterMock.ofIMapper mockMapper1;
	private static final TmOpportunityConverterMock.ofIMapper mockMapper2;
	private static final TmOpportunityConverterMock.ofIOpportunityMapper mockOpportunityMapper1;
	private static final TmOpportunityConverterMock.ofIOpportunityMapper mockOpportunityMapper2;


	static {
		mockDataProvider = new TmBoardingMock.ofIDataProvider();
		mockDmBuilder = new TmOpportunityConverterMock.ofIDmBuilder();
		mockOpportunityBuilder = new TmOpportunityConverterMock.ofIOpportunityBuilder();
		mockUtility = new Mock.ofIUtility();
		mockStageRepository = new TmConfigurationMock.ofIStageRepository();
		mockMapper1 = new TmOpportunityConverterMock.ofIMapper();
		mockMapper2 = new TmOpportunityConverterMock.ofIMapper();
		mockOpportunityMapper1 = new TmOpportunityConverterMock.ofIOpportunityMapper();
		mockOpportunityMapper2 = new TmOpportunityConverterMock.ofIOpportunityMapper();
		List<TmOpportunityConverterMock.ofIMapper> mappers = new List<TmOpportunityConverterMock.ofIMapper>{mockMapper1, mockMapper2};
		List<TmOpportunityConverterMock.ofIOpportunityMapper> oppMappers = new List<TmOpportunityConverterMock.ofIOpportunityMapper>{mockOpportunityMapper1,mockOpportunityMapper2};
		sut = new TmOpportunityConverterRepository(mockDataProvider, mockDmBuilder,mockOpportunityBuilder, mockUtility, mockStageRepository, mappers, oppMappers);
	}

	@IsTest
    static void it_should_call_the_dataProvider_to_get_opportunity_pm() {
		String opportunityId = 'test-id';
		sut.getOpportunity(opportunityId);

		mockDataProvider.verify('getOpportunity', new List<Object>{opportunityId});
	}

	@IsTest
    static void it_should_call_the_dmbuilder_to_build_opportunity_dm() {
		String opportunityId = 'test-id';
		Id entityId = null;
		String entityName = 'test-entity';
		Account entity = new Account(Id = entityId, Name = entityName);
		Opportunity opp = new Opportunity(Account = entity);
		mockDataProvider.setup('getOpportunity', new List<Object>{opportunityId}).returns(opp);

		sut.getOpportunity(opportunityId);

		mockDmBuilder.verify('build', new List<OBject>{opp}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_dataProvider_to_get_packet_pms() {
		String entityId = 'test-entity-id';

		sut.getExistingTmPackets(entityId);

		mockDataProvider.verify('getPacketsFromEntity', new List<Object>{entityId}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_dmbuilder_to_build_packet_dms() {
		String entityId = 'test-entity-id';
		Tm_Service_Request_Packet__c packet1 = new Tm_Service_Request_Packet__c(Name = 'packet-1');
		Tm_Service_Request_Packet__c packet2 = new Tm_Service_Request_Packet__c(Name = 'packet-2');
		List<Tm_Service_Request_Packet__c> packets = new List<Tm_Service_Request_Packet__c>{packet1, packet2};
		mockDataProvider.setup('getPacketsFromEntity', new List<Object>{entityId}).returns(packets);

		sut.getExistingTmPackets(entityId);

		mockDmBuilder.verify('build', new List<Object>{packet1}, Times.Once);
		mockDmBuilder.verify('build', new List<Object>{packet2}, Times.Once);
	}

	@IsTest
    static void it_should_create_a_string_join_when_a_list_of_string_is_provided() {
		List<String> existingProducts = new List<String>{'Online Banking', 'Lockbox'};
		String Products = String.Join(existingProducts, ',');

		System.assertEquals('Online Banking,Lockbox', Products);
	}

	@IsTest
    static void it_should_throw_an_exception_on_gettting_configuration_field_errors() {
		String product = 'not-Lockbox';
		String product2 = 'Lockbox';
		DmRecordType prod = new DmRecordType();
		prod.Name = product;
		DmRecordType prod2 = new DmRecordType();
		prod2.Name = product2;
		List<DmRecordType>  products = new List<DmRecordType>{prod, prod2};
		mockDataProvider.setup('getPageFieldConfigurationsByServiceType' , new List<Object>{product}).throws(new MissingConfigException('test'));
		
		Map<String, Set<String>> result = sut.getOpportunityProducts(products);
	}

	@IsTest
    static void it_should_update_an_opportunity_with_removed_products() {
		String productName = 'x';
		Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		Tm_Service_Request__c request = new Tm_Service_Request__c(Id = requestId);
		RecordType recType = new RecordType(Name = 'x');
		request.RecordType = recType;
		request.RecordType.Name = recType.Name;
		TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
		Opportunity opm = new Opportunity();
        opm.RecordTypeId = '01230000000YmmCAAS';
		opm.Products__c = 'x;y;z;u;v';
		opm.Name = 'TM';
		opm.StageName = 'Closed';
		opm.CloseDate = System.Today();
		insert opm;
		requestPm.PacketPm = new Tm_Service_Request_Packet__c(Opportunity__c = opm.Id);
		requestPm.requestPm = request;

		DmTmRequestStage stageDm = new DmTmRequestStage();
		stageDm.Type = 'Withdraw';
		opm = [SELECT Id, Products__c FROM Opportunity WHERE Id =: opm.Id LIMIT 1];

		TmBoarding.RequestConfigPm cfg = new TmBoarding.RequestConfigPm();
		cfg.productPm = new Tm_Service_Configuration__c(Related_To_Opportunity_Products__c = 'x,y', Product_Name__c = productName);
		Map<string, TmBoarding.RequestConfigPm> pms = new Map<string, TmBoarding.RequestConfigPm>{productName => cfg};
		mockDataProvider.setup('getOpportunity', new List<Object>{opm.Id}).returns(opm);
		mockDataProvider.setup('getAllPageFieldConfigurationsByServiceType').returns(pms);

		mockStageRepository.setup('getStageDetail', new List<Object>{requestId}).returns(stageDm);

		sut.updateOpportunityForWithdrawnProduct(requestPm);

		Opportunity requery = [SELECT Id, Products__c FROM Opportunity WHERE Id =: opm.Id LIMIT 1];
		System.assertEquals('z;u;v', requery.Products__c );
	}

	@IsTest
    static void it_should_not_update_an_opportunity_with_removed_products() {
		String productName = 'x';
		Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		Tm_Service_Request__c request = new Tm_Service_Request__c(Id = requestId);
		RecordType recType = new RecordType(Name = 'x');
		request.RecordType = recType;
		request.RecordType.Name = recType.Name;
		TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();        
		Opportunity opm = new Opportunity();
        opm.RecordTypeId = '01230000000YmmCAAS';
		opm.Products__c = 'x;y;z;u;v';
		opm.Name = 'TM';
		opm.StageName = 'Closed';
		opm.CloseDate = System.Today();
		insert opm;
		requestPm.PacketPm = new Tm_Service_Request_Packet__c(Opportunity__c = opm.Id);
		requestPm.requestPm = request;

		DmTmRequestStage stageDm = new DmTmRequestStage();
		stageDm.Type = 'Not-Withdraw';
		opm = [SELECT Id, Products__c FROM Opportunity WHERE Id =: opm.Id LIMIT 1];

		TmBoarding.RequestConfigPm cfg = new TmBoarding.RequestConfigPm();
		cfg.productPm = new Tm_Service_Configuration__c(Related_To_Opportunity_Products__c = 'x,y', Product_Name__c = productName);
		Map<string, TmBoarding.RequestConfigPm> pms = new Map<string, TmBoarding.RequestConfigPm>{productName => cfg};
		mockDataProvider.setup('getOpportunity', new List<Object>{opm.Id}).returns(opm);
		mockDataProvider.setup('getAllPageFieldConfigurationsByServiceType').returns(pms);

		mockStageRepository.setup('getStageDetail', new List<Object>{requestId}).returns(stageDm);

		sut.updateOpportunityForWithdrawnProduct(requestPm);

		Opportunity requery = [SELECT Id, Products__c FROM Opportunity WHERE Id =: opm.Id LIMIT 1];
		System.assertEquals('x;y;z;u;v', requery.Products__c );
	}

	@IsTest
    static void it_should_request_record_types() {
		String recordTypeName = 'name-1';
		RecordType rt = new RecordType(Name=recordTypeName);
		DmRecordType recordTypeDm = new DmRecordType();
		recordTypeDm.IsActive = true;
		recordTypeDm.Name = recordTypeName;
		List<RecordType> recordTypes = new List<RecordType>{rt};
		mockUtility.setup('recordTypeObjects', new List<Object>{TmConfiguration.TM_REQUEST}).returns(recordTypes);
		mockDmBuilder.setup('build', new List<Object>{rt}).returns(recordtypeDm);

		List<DmRecordType> result = sut.getRequestRecordTypes();

		mockUtility.verify('recordTypeObjects', new List<Object>{TmConfiguration.TM_REQUEST}, Times.Once);
		mockDmBuilder.verify('build', new List<Object>{rt}, Times.Once);
	}

	@IsTest
    static void it_should_update() {
		String product = 'req-product';
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		TM_Service_Request__c record = new TM_Service_Request__c(Id= requestId);
		Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c();
		Set<string> productSet = new Set<String>();
		productSet.add('prod');
		Map<String, Set<String>> productMap = new Map<String, Set<String>>{product => productSet};
		mockDataProvider.setup('getPacket', new List<Object>{record}).returns(packet);
		mockOpportunityBuilder.setup('getOpportunityProducts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(productMap);

		Opportunity result = sut.updateOpportunityOnPacket(record,  product);

		mockOpportunityBuilder.verify('getOpportunityProducts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		mockOpportunityBuilder.verify('getUpdatedOpportunity', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_update_the_packet_with_opportunity() { 
		string oppHandle = 'Buniness Banking';
		Id opportunityId = ObjectFactory.getFakeId(Opportunity.SObjectType, '1');
		Opportunity o = new Opportunity(Id=opportunityId);
		DmOpportunity opDm = new DmOpportunity();
		opDm.Id = o.Id;
		opDm.BankProducts = new List<String>{'test'};
		opDm.RecordType = new DmRecordType();
		opDm.RecordType.Name = oppHandle;
		String product = 'req-product';
		Set<string> productSet = new Set<String>();
		productSet.add('prod');
		Map<String, Set<String>> productMap = new Map<String, Set<String>>{product => productSet};
		TmOpportunityConverter.ConvertRequest request = new TmOpportunityConverter.ConvertRequest();
		request.Products = new List<String>{product};
		request.packetId = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '1');
		request.OpportunityId = ObjectFactory.getFakeId(Opportunity.SObjectType, '1');
		RecordType rt = new RecordType(Name=product);
		List<RecordType> recordTypes = new List<RecordType>{rt};
		DmRecordType rtDm = new DmRecordType();
		rtDm.Name = product;
		rtDm.IsActive = true;
		DmTmRequestStage defaultStage = new DmTmRequestStage();
		defaultStage.type = 'default';
		defaultStage.name = 'stg-name';
		mockOpportunityBuilder.setup('getOpportunityProducts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(productMap);
		mockOpportunityBuilder.setup('getUpdatedOpportunity', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(o);
		mockDataProvider.setup('getPageFieldConfigurationsByServiceType', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new TmBoarding.RequestConfigPm());
		mockUtility.setup('recordTypeObjects', new List<Object>{TmConfiguration.TM_REQUEST}).returns(recordTypes);
		mockDmBuilder.setup('build', new List<Object>{rt}).returns(rtDm);
		mockStageRepository.setup('getDefaultStage').returns(defaultStage);
		mockDataProvider.setup('getOpportunity', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(o);
		mockDmBuilder.setup('build', new List<Object>{o}).returns(opDm);
		mockMapper1.setup('handle').returns(product);
		mockMapper2.setup('handle').returns('test');
		Tm_Service_Request__c updatedRequest = new Tm_Service_Request__c();
		mockMapper1.setup('updateTmObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(updatedRequest);
		mockOpportunityMapper1.setup('handle').returns(oppHandle);
		mockOpportunityMapper2.setup('handle').returns('');
		mockOpportunityMapper1.setup('updateTmObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(updatedRequest);

		String result =  sut.save(request);

		mockDataProvider.verify('save',  ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Twice);
	}

	public class MissingConfigException extends Exception {}

}