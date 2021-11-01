@IsTest
private class LoanArchiveValidatorTests {

    private final static Id objectId1;
    private final static Id objectId2;
	private final static LoanArchiveValidator sut;
	private final static Mock.ofIConfigurations mockConfigs;
	private final static Mock.ofISystem mockSystem;

    static {
        objectId1 = ObjectFactory.getFakeId(Account.SobjectType, '1');
        objectId2 = ObjectFactory.getFakeId(Account.SobjectType, '2');
        mockConfigs = new Mock.ofIConfigurations();
        mockSystem = new Mock.ofISystem();
        sut = new LoanArchiveValidator(mockConfigs, mockSystem);
    }

    @IsTest
    static void it_should_call_the_configurations_to_get_validator_how_old_entity_is() {
    	Integer current_year = 2000;
    	Integer current_month = 1;
    	Integer current_days = 1;
    	String key = 'ArchiveEntityValidDateOfCreation';
    	Datetime currentDate = Datetime.newInstance(current_year, current_month, current_days);
    	LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
        vm.objectid = objectId1;
        vm.description = 'test';
    	List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>{vm};
        LoanArchive.MergeObjectVm selectedvm = new LoanArchive.MergeObjectVm();
        selectedvm.selectedOptionId = objectId1;
        List<LoanArchive.MergeObjectVm> selectedVms = new List<LoanArchive.MergeObjectVm>{selectedVm};
    	String objType = 'entity';
    	mockSystem.setup('now').returns(currentDate);
    	mockConfigs.setup('get', new List<Object>{key}).returns('30');

    	sut.validateCoreAge(selectedvms, vms, objType);

    	mockConfigs.verify('get', new List<Object>{key}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_system_to_get_todays_date() {
    	Integer current_year = 2000;
    	Integer current_month = 1;
    	Integer current_days = 1;
    	String key = 'ArchiveEntityValidDateOfCreation';
    	Datetime currentDate = Datetime.newInstance(current_year, current_month, current_days);
    	LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
        vm.objectid = objectId1;
        vm.description = 'test';
    	List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>{vm};
        LoanArchive.MergeObjectVm selectedvm = new LoanArchive.MergeObjectVm();
        selectedvm.selectedOptionId = objectId1;
        List<LoanArchive.MergeObjectVm> selectedVms = new List<LoanArchive.MergeObjectVm>{selectedVm};
    	String objType = 'entity';
    	mockSystem.setup('now').returns(currentDate);
    	mockConfigs.setup('get', new List<Object>{key}).returns('30');

    	sut.validateCoreAge(selectedvms, vms, objType);

    	mockSystem.verify('now', Times.Once);
    }

    @IsTest
    static void it_should_get_an_error_when_the_created_date_for_entity_is_more_than_config_days_old() {
    	Integer created_year = 2000;
    	Integer created_month = 1;
    	Integer created_days = 1;
    	Integer current_year = 2000;
    	Integer current_month = 2;
    	Integer current_days = 10;  //current 2/10/2000
    	Datetime currentDate = Datetime.newInstance(current_year, current_month, current_days);
    	
        LoanArchive.MergeObjectVm corevm = new LoanArchive.MergeObjectVm();
        //created date 1/1/2000
    	corevm.createdDate = Datetime.newInstance(created_year, created_month, created_days);
    	corevm.description = 'Test Entity';
        corevm.objectId = objectId1;
    	List<LoanArchive.MergeObjectVm> coreVms = new List<LoanArchive.MergeObjectVm>{corevm};
        LoanArchive.MergeObjectVm selectedvm = new LoanArchive.MergeObjectVm();
        selectedvm.selectedOptionId = ObjectId1;
        List<LoanArchive.MergeObjectVm> selectedVms = new List<LoanArchive.MergeObjectVm>{selectedVm};
        
    	String objType = 'entity';
    	String key = 'ArchiveEntityValidDateOfCreation';
    	mockSystem.setup('now').returns(currentDate);
    	mockConfigs.setup('get', new List<Object>{key}).returns('30');

    	List<String> results = sut.validateCoreAge(selectedVms, coreVms, objType);

    	System.assertEquals(1 , results.size());
        System.assertEquals('Error : Created Date (01/01/2000) of entity Test Entity is too old for merge. Please call IT for manual merge', results[0]);
    }

	@IsTest
    static void it_should_not_get_an_error_when_the_created_date_for_entity_is_less_than_config_days_old() {
    	Integer created_year = 2000;
    	Integer created_month = 1;
    	Integer created_days = 1;
    	Integer current_year = 2000;
    	Integer current_month = 1;
    	Integer current_days = 10;
    	Datetime currentDate = Datetime.newInstance(current_year, current_month, current_days);
    	LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
    	vm.createdDate = Datetime.newInstance(created_year, created_month, created_days);
    	vm.description = 'Test Entity';
        vm.objectid = objectId1;
    	List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>{vm};
        LoanArchive.MergeObjectVm selectedvm = new LoanArchive.MergeObjectVm();
        selectedvm.selectedOptionId = objectId1;
        List<LoanArchive.MergeObjectVm> selectedVms = new List<LoanArchive.MergeObjectVm>{selectedVm};
    	String objType = 'entity';
    	String key = 'ArchiveEntityValidDateOfCreation';
    	mockSystem.setup('now').returns(currentDate);
    	mockConfigs.setup('get', new List<Object>{key}).returns('30');

    	List<String> results = sut.validateCoreAge(selectedVms, vms, objType);

    	System.assertEquals(0 , results.size());
    }

    @IsTest
    static void it_should_get_an_error_when_the_created_date_for_collateral_is_more_than_config_days_old() {
    	Integer created_year = 2000;
    	Integer created_month = 1;
    	Integer created_days = 1;
    	Integer current_year = 2000;
    	Integer current_month = 2;
    	Integer current_days = 10;
    	Datetime currentDate = Datetime.newInstance(current_year, current_month, current_days);
    	LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
    	vm.createdDate = Datetime.newInstance(created_year, created_month, created_days);
    	vm.description = 'Test Collateral';
        vm.objectId = objectId1;
    	List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>{vm};
        LoanArchive.MergeObjectVm selectedvm = new LoanArchive.MergeObjectVm();
        selectedvm.selectedOptionId = objectId1;
        List<LoanArchive.MergeObjectVm> selectedVms = new List<LoanArchive.MergeObjectVm>{selectedVm};
    	String objType = 'collateral';
    	String key = 'ArchiveCollateralValidDateOfCreation';
    	mockSystem.setup('now').returns(currentDate);
    	mockConfigs.setup('get', new List<Object>{key}).returns('30');

    	List<String> results = sut.validateCoreAge(selectedVms, vms, objType);

    	System.assertEquals(1 , results.size());
    	System.assertEquals('Error : Created Date (01/01/2000) of collateral Test Collateral is too old for merge. Please call IT for manual merge', results[0]);
    }

	@IsTest
    static void it_should_not_get_an_error_when_the_created_date_for_collateral_is_less_than_config_days_old() {
    	Integer created_year = 2000;
    	Integer created_month = 1;
    	Integer created_days = 1;
    	Integer current_year = 2000;
    	Integer current_month = 1;
    	Integer current_days = 10;
    	Datetime currentDate = Datetime.newInstance(current_year, current_month, current_days);
    	LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
    	vm.createdDate = Datetime.newInstance(created_year, created_month, created_days);
    	vm.description = 'Test Collateral';
        vm.objectid = objectId1;
    	List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>{vm};
		LoanArchive.MergeObjectVm selectedvm = new LoanArchive.MergeObjectVm();
        selectedvm.selectedOptionId = objectId1;
        List<LoanArchive.MergeObjectVm> selectedVms = new List<LoanArchive.MergeObjectVm>{selectedVm};
    	String objType = 'collateral';
    	String key = 'ArchiveCollateralValidDateOfCreation';
    	mockSystem.setup('now').returns(currentDate);
    	mockConfigs.setup('get', new List<Object>{key}).returns('30');

    	List<String> results = sut.validateCoreAge(selectedvms, vms, objType);

    	System.assertEquals(0 , results.size());
    }

    @IsTest
    static void it_should_get_an_error_when_selected_option_is_zero() {
    	String objType = 'entity';
    	LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
    	vm.selectedOptionId = '0';
    	vm.description = 'test entity';
        vm.objectid = objectId1;
    	List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>{vm};
        LoanArchive.MergeObjectVm selectedvm = new LoanArchive.MergeObjectVm();
        selectedvm.selectedOptionId = objectId1;
        List<LoanArchive.MergeObjectVm> selectedVms = new List<LoanArchive.MergeObjectVm>{selectedVm};

    	List<String> result = sut.validateCoreMerge(vms, objType);

    	System.assertEquals(1, result.size());
    	System.assertEquals('"test entity" is not mapped to a Core entity', result[0]);
    }

    @IsTest
    static void it_should_error_when_core_is_merged_to_more_than_one_item() {
    	String objType = 'entity';
    	LoanArchive.MergeObjectVm vm1 = new LoanArchive.MergeObjectVm();
    	vm1.selectedOptionId = '1';
    	vm1.description = 'test entity1';
        vm1.objectid = objectId1;
    	LoanArchive.MergeObjectVm vm2 = new LoanArchive.MergeObjectVm();
    	vm2.selectedOptionId = '1';
    	vm2.description = 'test entity2';
        vm2.objectid = objectId2;
    	List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>{vm1, vm2};
        LoanArchive.MergeObjectVm selectedvm1 = new LoanArchive.MergeObjectVm();
        selectedvm1.selectedOptionId = objectId1;
        LoanArchive.MergeObjectVm selectedvm2 = new LoanArchive.MergeObjectVm();
        selectedvm2.selectedOptionId = objectId1;
        List<LoanArchive.MergeObjectVm> selectedVms = new List<LoanArchive.MergeObjectVm>{selectedVm1, selectedVm2};

    	List<String> result = sut.validateCoreMerge(vms, objType);

    	System.assertEquals(1, result.size());
    	System.assertEquals('"test entity2" and "test entity1" are mapped to the same Core entity', result[0]);
    }

    @IsTest
    static void it_should_throw_when_the_objectType_is_not_entity() {
    	List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>();
    	String objType = 'not-entity';

    	try {
    		sut.validateCoreAge(vms, vms, objType);
            System.assert(false);
        } catch (LoanArchiveValidator.UnknownObjTypeException ex) {
            System.assert(true);
        } catch (Exception defEx) {
            System.assert(false);
        }
    }

    @IsTest
    static void it_should_not_get_an_error_when_the_created_date_for_entity_is_less_than_config_days_old2() {
        Integer created_year = 2016;
        Integer created_month = 12;
        Integer created_days = 21;
        Integer current_year = 2017;
        Integer current_month = 1;
        Integer current_days = 6;
        Datetime currentDate = Datetime.newInstance(current_year, current_month, current_days);
        LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
        vm.createdDate = Datetime.newInstance(created_year, created_month, created_days);
        vm.description = 'Test Entity';
        vm.objectid = objectId1;
        List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>{vm};
        LoanArchive.MergeObjectVm selectedvm = new LoanArchive.MergeObjectVm();
        selectedvm.selectedOptionId = objectId1;
        List<LoanArchive.MergeObjectVm> selectedVms = new List<LoanArchive.MergeObjectVm>{selectedVm};
        String objType = 'entity';
        String key = 'ArchiveEntityValidDateOfCreation';
        mockSystem.setup('now').returns(currentDate);
        mockConfigs.setup('get', new List<Object>{key}).returns('30');

        List<String> results = sut.validateCoreAge(selectedVms, vms, objType);

        System.assertEquals(0 , results.size());
    }
}