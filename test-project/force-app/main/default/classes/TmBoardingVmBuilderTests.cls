@IsTest
private class TmBoardingVmBuilderTests {

	private static final TmBoardingVmBuilder sut;
	private static final TmBoardingMock.ofIInputTypeVmBuilder mockInputTypeVmBuilder;
	private static final TmBoardingMock.ofIVmFieldBuilder mockVmFieldBuilder;
	private static final TmBoardingMock.ofIVmMetadataTypeBuilder mockMetaTypeBuilder1;
	private static final TmBoardingMock.ofIVmMetadataTypeBuilder mockMetaTypeBuilder2;
	private static final TmBoardingMock.ofIVmBuilderHelper mockVmBuilderHelper;
	private static final Mock.ofICardRepository mockCardRepository;

	static {
		mockInputTypeVmBuilder = new TmBoardingMock.ofIInputTypeVmBuilder();
		mockVmFieldBuilder = new TmBoardingMock.ofIVmFieldBuilder();
		mockMetaTypeBuilder1 = new TmBoardingMock.ofIVmMetadataTypeBuilder();
		mockMetaTypeBuilder2 = new TmBoardingMock.ofIVmMetadataTypeBuilder();
		List<TmBoardingMock.ofIVmMetadataTypeBuilder> metaTypeList = new List<TmBoardingMock.ofIVmMetadataTypeBuilder>{mockMetaTypeBuilder1, mockMetaTypeBuilder2};
		mockVmBuilderHelper = new TmBoardingMock.ofIVmBuilderHelper();
		mockCardRepository = new Mock.ofICardRepository();
		sut = new TmBoardingVmBuilder(mockInputTypeVmBuilder, mockVmFieldBuilder, metaTypeList, mockVmBuilderHelper, mockCardRepository);
	}

	@IsTest
    static void it_should_build_details_by_calling_input_type_vm_builder() {
		DmSection detailDm = new DmSection();
		DmField detailFld = new DmField();
		detailDm.Name = 'detail-name';
		detailDm.Fields = new List<DmField>{detailFld};
		DmSection dependentDm = new DmSection();
		DmField dependentFld = new DmField();
		dependentDm.Fields = new List<DmField>{dependentFld};
		dependentDm.Name = 'dependent-name';
		List<DmSection> allDetailDms = new List<DmSection>{detailDm};
		List<DmSection> allDependentDms = new List<DmSection>{dependentDm};
		TmBoarding.DataComponent dataComponent = new TmBoarding.DataComponent();

		TmBoarding.Field fldVm = new TmBoarding.Field();
		List<TmBoarding.Field> fldVms = new List<TmBoarding.Field>{fldVm};

		mockMetaTypeBuilder1.setup('getType').returns(TmConfiguration.Placement.View);
		mockMetaTypeBuilder2.setup('getType').returns(TmConfiguration.Placement.Edit);
		mockMetaTypeBuilder1.setup('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(fldVms);
		mockMetaTypeBuilder2.setup('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(fldVms);

		TmBoarding.FormComponent result = sut.buildDetails(allDetailDms, allDependentDms, dataComponent);

		mockMetaTypeBuilder1.verify('getType', Times.AtLeastOnce);
		mockMetaTypeBuilder2.verify('getType', Times.AtLeastOnce);
	}

	@IsTest
    static void it_should_build_contacts() {
		DmSection contactDm = new DmSection();
		DmField contactFld = new DmField();
		List<DmField> dmFields = new List<DmField>{contactFld};
		contactDm.Fields = dmFields;
		contactDm.Name = 'contact-name';
		List<DmSection> allContactDms = new List<DmSection>{contactDm};

		TmBoarding.Field fldVm = new TmBoarding.Field();
		List<TmBoarding.Field> fldVms = new List<TmBoarding.Field>{fldVm};

		TmBoarding.DataComponent dataComponent = new TmBoarding.DataComponent();
		mockMetaTypeBuilder1.setup('getType').returns(TmConfiguration.Placement.View);
		mockMetaTypeBuilder2.setup('getType').returns(TmConfiguration.Placement.Edit);
		mockMetaTypeBuilder1.setup('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(fldVms);
		mockMetaTypeBuilder2.setup('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(fldVms);

		TmBoarding.FormComponent result =  sut.buildContacts(allContactDms, dataComponent);

		mockMetaTypeBuilder1.verify('getType', Times.AtLeastOnce);
		mockMetaTypeBuilder2.verify('getType', Times.AtLeastOnce);
	}

	@IsTest
    static void it_should_build_accounts() {
		List<DmSection> allAccountDms = new List<DmSection>();
		TmBoarding.DataComponent dataComponent = new TmBoarding.DataComponent();
		mockMetaTypeBuilder1.setup('getType').returns(TmConfiguration.Placement.View);
		mockMetaTypeBuilder2.setup('getType').returns(TmConfiguration.Placement.Edit);

		TmBoarding.FormComponent result =  sut.buildAccounts( allAccountDms, dataComponent);

		mockMetaTypeBuilder1.verify('getType', Times.AtLeastOnce);
		mockMetaTypeBuilder2.verify('getType', Times.AtLeastOnce);
	}

	@IsTest
    static void it_should_build_packet_view() {
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		List<DmRecordType> products = new List<DmRecordType>();
		List<DmTmRequestStage> stageDms = new List<DmTmRequestStage>();
		Map<String, TmConfiguration.ProductInfo> productInfo = new Map<String, TmConfiguration.ProductInfo>();

		TmBoarding.LayoutComponent2 result =  sut.getPacket(pm, products, productInfo, stageDms);

		mockVmBuilderHelper.verify('getPacket' , new List<Object>{pm, products, productInfo, stageDms}, Times.Once);
	}

	@IsTest
    static void it_should_build_entity() {
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();

		TmBoarding.LayoutComponent result = sut.getEntity(pm);

		mockVmBuilderHelper.verify('getEntity' , new List<Object>{pm}, Times.Once);
	}

	@IsTest
    static void it_should_build_stages() {
		TM_Service_Request__c record = new TM_Service_Request__c();
		DmTmRequestStage stageDm = new DmTmRequestStage();

		TmBoarding.LayoutComponentStage result = sut.buildStages( record, stageDm);

		mockVmBuilderHelper.verify('buildStages' , new List<Object>{record, stageDm}, Times.Once);
	}

	@IsTest
    static void it_should_get_permissions() {
		String stageName = 'test-stage-name';
		DmTmRequestStage stageDm = new  DmTmRequestStage();
		stageDm.name = stageName;

		TmBoarding.LayoutComponentPermission result = sut.getPermission(stageDm);

		mockVmBuilderHelper.verify('getPermission' , new List<Object>{stageDm}, Times.Once);
	}

	@IsTest
    static void it_should_build_contact_account() {
		TM_Service_Request__c record = new TM_Service_Request__c();

		TmBoarding.FormComponent result = sut.buildContactAccount(record);

		System.assertEquals(null, result);
	}

	@IsTest
    static void it_should_build_account_contact() {
		TM_Service_Request__c record = new TM_Service_Request__c();

		TmBoarding.FormComponent result = sut.buildAccountContact(record);

		System.assertEquals(null, result);
	}  

	@IsTest
    static void it_should_build_account_types() {
		DmCardInformation dc = new DmCardInformation();

		List<DmCardInformation> depositCards = new List<DmCardInformation>{dc}; 
		mockCardRepository.setup('getTmCards').returns(depositCards);

		List<TmBoarding.LayoutPickList> results = sut.getAccountTypes();

		mockCardRepository.verify('getTmCards', Times.Once);
	}

	@IsTest
    static void it_should_build_validation_results() {
		String stageId = 'test-id';
		String stageName = 'test-name';
		String error = 'test-error';
		DmTmRequestStage stageDm = new DmTmRequestStage();
		stageDm.id = stageId;
		stageDm.name = stageName;
		List<DmTmRequestStage> stageDms = new List<DmTmRequestStage>{stageDm};
		TmValidator.ValidationResult vr = new TmValidator.ValidationResult();
		vr.StageId = stageId;
		vr.Error = error;
		vr.IsValid = false;
		Map<String, List<TmValidator.ValidationResult>> validationResults = new Map<String, List<TmValidator.ValidationResult>>{
											stageId => new List<TmValidator.ValidationResult>{vr}};

		TmBoarding.ExistingDataValidationVm result =  sut.build(stageDms , validationResults);

		System.assertEquals(stageId, result.StageDetails[0].Id);
		System.assertEquals(stageName, result.StageDetails[0].name);
		System.assertEquals(stageId, result.ValidationsByStage.get(stageId)[0].stageId);
		System.assertEquals(error, result.ValidationsByStage.get(stageId)[0].error);
	}

	@IsTest
    static void it_should_build_stage_for_all_vms() {
		DmTmRequestStage stg = new DmTmRequestStage();
		stg.name = 'stage-name';
		stg.type = 'stage-type';
		List<DmTmRequestStage> stageDms = new List<DmTmRequestStage>{stg};

		List<TmBoarding.LayoutComponentStage> result = sut.getAllStages(stageDms);

		System.assertEquals(1, result.size());
		System.assertEquals('stage-name', result[0].name);
	}
}