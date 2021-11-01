@isTest
private class LoanArchiveVmBuilderTests {
    private final static LoanArchiveVmBuilder sut;

    static{
        sut = new LoanArchiveVmBuilder();
    }

    private static testMethod void it_should_build_a_list_of_entity_merge_objects_when_a_list_of_involvements_is_provided() {
        Id prospectId = ObjectFactory.getFakeId(Account.SobjectType, '1');
        RecordType prospectRecordType = Utility.RecordTypeObject('Account', 'Prospect');
        Account entity = new Account(Id = prospectId, RecordType = prospectRecordType, Name= 'test Name', EB_Client_Name__c = 'test client name');
        LLC_BI__Legal_Entities__c inv = new LLC_BI__Legal_Entities__c();
        inv.LLC_BI__Account__r = entity;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        List<LLC_BI__Legal_Entities__c> involvements = new List<LLC_BI__Legal_Entities__c>();
        involvements.add(inv);

        List<LoanArchive.MergeObjectVm> result = sut.buildEntityMergeList(involvements);

        System.assertEquals(1, result.size());
        System.assertEquals('test client name (test Name)', result[0].description);
        System.assertEquals(prospectId, result[0].objectId);
    }

    private static testMethod void it_should_build_a_list_of_entity_merge_objects_with_correct_description() {
        Id prospectId = ObjectFactory.getFakeId(Account.SobjectType, '1');
        RecordType prospectRecordType = Utility.RecordTypeObject('Account', 'Prospect');
        Account entity = new Account(Id = prospectId, RecordType = prospectRecordType, Name= 'test Name', EB_Client_Name__c = 'test Name');
        LLC_BI__Legal_Entities__c inv = new LLC_BI__Legal_Entities__c();
        inv.LLC_BI__Account__r = entity;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        List<LLC_BI__Legal_Entities__c> involvements = new List<LLC_BI__Legal_Entities__c>();
        involvements.add(inv);

        List<LoanArchive.MergeObjectVm> result = sut.buildEntityMergeList(involvements);

        System.assertEquals(1, result.size());
        System.assertEquals('test Name', result[0].description);
    }

    private static testMethod void it_should_build_a_list_of_entity_merge_object_when_involvements_is_passed_and_client_name_is_not_filled() {
        Id prospectId = ObjectFactory.getFakeId(Account.SobjectType, '1');
        RecordType prospectRecordType = Utility.RecordTypeObject('Account', 'Prospect');
        Account entity = new Account(Id = prospectId, RecordType = prospectRecordType, Name= 'test Name');
        LLC_BI__Legal_Entities__c inv = new LLC_BI__Legal_Entities__c();
        inv.LLC_BI__Account__r = entity;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        List<LLC_BI__Legal_Entities__c> involvements = new List<LLC_BI__Legal_Entities__c>();
        involvements.add(inv);

        List<LoanArchive.MergeObjectVm> result = sut.buildEntityMergeList(involvements);

        System.assertEquals(1, result.size());
        System.assertEquals('test Name', result[0].description);
        System.assertEquals(prospectId, result[0].objectId);
    }

    private static testMethod void it_should_build_a_list_of_collateral_merge_objects_when_a_list_of_pledged_is_provided() {
        Id prospectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SobjectType, '1');
        Id collateralTypeId = ObjectFactory.getFakeId(LLC_BI__Collateral_Type__c.SObjectType, '1');
        LLC_BI__Collateral_Type__c collateralType = new LLC_BI__Collateral_Type__c(Id = collateralTypeId, Name = 'test type');
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        collateral.Id = prospectId;
        collateral.LLC_BI__Collateral_Name__c = 'test collateral name';
        collateral.LLC_BI__Collateral_Type__r = collateralType;
        LLC_BI__Loan_Collateral2__c pledge = new LLC_BI__Loan_Collateral2__c();
        pledge.Description__c = 'desc';
        pledge.LLC_BI__Collateral__r = collateral;
        List<LLC_BI__Loan_Collateral2__c> pledged = new List<LLC_BI__Loan_Collateral2__c>{pledge};

        List<LoanArchive.MergeObjectVm> result = sut.buildCollateralMergeList(pledged);

        System.assertEquals(1 ,result.size());
        System.assertEquals(prospectId ,result[0].objectId);
        System.assertEquals('test collateral name | desc ()', result[0].description);
    }

    private static testMethod void it_should_build_a_list_of_collateral_merge_with_no_name_provided() {
        Id prospectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SobjectType, '1');
        Id collateralTypeId = ObjectFactory.getFakeId(LLC_BI__Collateral_Type__c.SObjectType, '1');
        LLC_BI__Collateral_Type__c collateralType = new LLC_BI__Collateral_Type__c(Id = collateralTypeId, Name = 'test type');
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        collateral.Id = prospectId;
        collateral.LLC_BI__Collateral_Name__c = 'test collateral name';
        collateral.LLC_BI__Collateral_Type__r = collateralType;
        LLC_BI__Loan_Collateral2__c pledge = new LLC_BI__Loan_Collateral2__c();
        pledge.LLC_BI__Collateral__r = collateral;
        List<LLC_BI__Loan_Collateral2__c> pledged = new List<LLC_BI__Loan_Collateral2__c>{pledge};

        List<LoanArchive.MergeObjectVm> result = sut.buildCollateralMergeList(pledged);

        System.assertEquals(1 ,result.size());
        System.assertEquals('test collateral name | test type ()', result[0].description);
    }

    private static testMethod void it_should_build_a_list_of_collateral_merge_with_collateral_description_provided() {
        Id prospectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SobjectType, '1');
        Id collateralTypeId = ObjectFactory.getFakeId(LLC_BI__Collateral_Type__c.SObjectType, '1');
        LLC_BI__Collateral_Type__c collateralType = new LLC_BI__Collateral_Type__c(Id = collateralTypeId, Name = 'test type');
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        collateral.Id = prospectId;
        collateral.LLC_BI__Collateral_Name__c = 'test collateral name';
        collateral.LLC_BI__Description__c = 'col Name';
        collateral.LLC_BI__Collateral_Type__r = collateralType;
        LLC_BI__Loan_Collateral2__c pledge = new LLC_BI__Loan_Collateral2__c();
        pledge.LLC_BI__Collateral__r = collateral;
        pledge.LLC_BI__Collateral__r.LLC_BI__Description__c = collateral.LLC_BI__Description__c;
        List<LLC_BI__Loan_Collateral2__c> pledged = new List<LLC_BI__Loan_Collateral2__c>{pledge};

        List<LoanArchive.MergeObjectVm> result = sut.buildCollateralMergeList(pledged);

        System.assertEquals(1 ,result.size());
        System.assertEquals('test collateral name | col Name ()', result[0].description);
    }

    private static testMethod void it_should_build_a_list_of_collateral_merge_objects_when_a_list_of_pledged_is_provided_and_collateral_name_is_not_filled() {
        Id prospectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SobjectType, '1');
        Id collateralTypeId = ObjectFactory.getFakeId(LLC_BI__Collateral_Type__c.SObjectType, '1');
        LLC_BI__Collateral_Type__c collateralType = new LLC_BI__Collateral_Type__c(Id = collateralTypeId, Name = 'test type');
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        collateral.Id = prospectId;
        collateral.LLC_BI__Collateral_Type__r = collateralType;
        LLC_BI__Loan_Collateral2__c pledge = new LLC_BI__Loan_Collateral2__c();
        pledge.Description__c = 'desc';
        pledge.LLC_BI__Collateral__r = collateral;
        List<LLC_BI__Loan_Collateral2__c> pledged = new List<LLC_BI__Loan_Collateral2__c>{pledge};

        List<LoanArchive.MergeObjectVm> result = sut.buildCollateralMergeList(pledged);

        System.assertEquals(1 ,result.size());
        System.assertEquals(prospectId ,result[0].objectId);
        System.assertEquals('null | desc ()', result[0].description);
    }

    private static testMethod void it_should_build_a_list_of_options_when_a_list_of_involvements_is_provided() {
        Id prospectId = ObjectFactory.getFakeId(Account.SobjectType, '1');
        RecordType prospectRecordType = Utility.RecordTypeObject('Account', 'Client');
        Account entity = new Account(Id = prospectId, RecordType = prospectRecordType, Name= 'test Name', EB_Client_Name__c = 'test client name');
        LLC_BI__Legal_Entities__c inv = new LLC_BI__Legal_Entities__c();
        inv.LLC_BI__Account__r = entity;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        List<LLC_BI__Legal_Entities__c> involvements = new List<LLC_BI__Legal_Entities__c>();
        involvements.add(inv);

        List<SelectOption> result = sut.buildCoreEntityOptions(involvements);

        System.assertEquals(2, result.size());
        System.assertEquals('--None--', result[0].getLabel());
        System.assertEquals('test client name (test Name)', result[1].getLabel());
    }

    private static testMethod void it_should_build_a_list_of_options_when_a_list_of_pledged_is_provided() {
        Id prospectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SobjectType, '1');
        Id collateralTypeId = ObjectFactory.getFakeId(LLC_BI__Collateral_Type__c.SObjectType, '1');
        Id prospectEntityId = ObjectFactory.getFakeId(Account.SobjectType, '1');
        LLC_BI__Collateral_Type__c collateralType = new LLC_BI__Collateral_Type__c(Id = collateralTypeId, Name = 'test type');
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        RecordType prospectRecordType = Utility.RecordTypeObject('Account', 'Client');
        Account entity = new Account(Id = prospectEntityId, RecordType = prospectRecordType, Name= 'test Name', EB_Client_Name__c = 'test client name');
        collateral.Id = prospectId;
        collateral.LLC_BI__Collateral_Name__c = 'test coll';
        collateral.LLC_BI__Collateral_Type__r = collateralType;
        collateral.Sync_Key__c = 'key1';
        collateral.Primary_Owner__r = entity;
        LLC_BI__Loan_Collateral2__c pledge = new LLC_BI__Loan_Collateral2__c();
        pledge.Description__c = 'desc';
        pledge.LLC_BI__Collateral__r = collateral;
        List<LLC_BI__Loan_Collateral2__c> pledged = new List<LLC_BI__Loan_Collateral2__c>{pledge};

        List<SelectOption> result = sut.buildCoreCollateralOptions(pledged);

        System.assertEquals(2, result.size());
        System.assertEquals('--None--', result[0].getLabel());
        System.assertEquals('test coll | desc (test client name (test Name))', result[1].getLabel());
    }

    private static testMethod void it_should_build_a_entity_core_merge_list_when_involvements_are_provided(){
        Id clientId = ObjectFactory.getFakeId(Account.SobjectType, '1');
        RecordType clientRecordType = Utility.RecordTypeObject('Account', 'Client');
        Account entity = new Account(Id = clientId, RecordType = clientRecordType, Name= 'test Name', EB_Client_Name__c = 'test client name');
        LLC_BI__Legal_Entities__c inv = new LLC_BI__Legal_Entities__c();
        inv.LLC_BI__Account__r = entity;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        List<LLC_BI__Legal_Entities__c> involvements = new List<LLC_BI__Legal_Entities__c>();
        involvements.add(inv);

        List<SelectOption> options = new List<SelectOption>();
        for(LLC_BI__Legal_Entities__c i : involvements){
            options.add(new SelectOption(i.LLC_BI__Account__r.Id, i.LLC_BI__Account__r.Name));
        }

        List<LoanArchive.MergeObjectVm> result = sut.buildEntityCoreMergeList(options, involvements);

        System.assertEquals(1, result.size());
    }

    private static testMethod void it_should_build_a_collateral_core_merge_list_when_involvements_are_provided(){
        Id prospectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SobjectType, '1');
        Id collateralTypeId = ObjectFactory.getFakeId(LLC_BI__Collateral_Type__c.SObjectType, '1');
        Id clientEntityId = ObjectFactory.getFakeId(Account.SobjectType, '1');
        LLC_BI__Collateral_Type__c collateralType = new LLC_BI__Collateral_Type__c(Id = collateralTypeId, Name = 'test type');
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        RecordType clientRecordType = Utility.RecordTypeObject('Account', 'Client');
        Account entity = new Account(Id = clientEntityId, RecordType = clientRecordType, Name= 'test Name', EB_Client_Name__c = 'test client name');
        collateral.Id = prospectId;
        collateral.LLC_BI__Collateral_Name__c = 'test coll';
        collateral.LLC_BI__Collateral_Type__r = collateralType;
        collateral.Sync_Key__c = 'key1';
        collateral.Primary_Owner__r = entity;
        LLC_BI__Loan_Collateral2__c pledge = new LLC_BI__Loan_Collateral2__c();
        pledge.Description__c = 'desc';
        pledge.LLC_BI__Collateral__r = collateral;
        List<LLC_BI__Loan_Collateral2__c> pledged = new List<LLC_BI__Loan_Collateral2__c>{pledge};
        List<SelectOption> options = new List<SelectOption>();
        for(LLC_BI__Loan_Collateral2__c pld : pledged){
            options.add(new SelectOption(pld.LLC_BI__Collateral__r.Id, pld.LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c));
        }

        List<LoanArchive.MergeObjectVm> result = sut.buildCollateralCoreMergeList(options, pledged);

        System.assertEquals(1, result.size());
    }
}