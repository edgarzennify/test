@IsTest
private class OwnerOverviewComponentTests {
    
    private static final OwnerOverviewComponent sut;
    private static final User testOwner = new User(Id='005a00000000001');
    private static final List<Map<Id, Account>> relationshipTree = new List<Map<Id, Account>>();
    private static final User rm1;
    private static final User rm2;
    private static final User rm3;
    private static final List<User> availableRMs;
    private static final MockofIOwnerOverviewComponentDataProv mockDataProv = new MockofIOwnerOverviewComponentDataProv();
    private static final MockofIParentRelTreeBuilder mockParentRelTreeBuilder = new MockofIParentRelTreeBuilder();   
    private static final Mock.ofIApexPages mockApexPages = new Mock.ofIApexPages();
    private static final Mock.ofIUserInfoService mockUserInfoService = new Mock.ofIUserInfoService(); 
    private static final Mock.ofIUtility mockUtility = new Mock.ofIUtility(); 

    static {
        User rmInsert1 = ObjectFactory.getUser('firstname', 'rm1', 'rm1test@enterprisebank.com.test', true);
        User rmInsert2 = ObjectFactory.getUser('firstname', 'rm2', 'rm2test@enterprisebank.com.test', true);
        User rmInsert3 = ObjectFactory.getUser('firstname', 'rm3', 'rm3test@enterprisebank.com.test', true);
        rm1 = [SELECT Id, Name FROM User WHERE Id =: rmInsert1.Id];
        rm2 = [SELECT Id, Name FROM User WHERE Id =: rmInsert2.Id];
        rm3 = [SELECT Id, Name FROM User WHERE Id =: rmInsert3.Id];
        availableRMs = new List<User>{rm1, rm2, rm3};
        mockApexPages.setup('getParameter', new List<Object>{'Id'}).returns(testOwner.Id);
        mockUserInfoService.setup('getCurrentUserId').returns(testOwner.Id);
        mockDataProv.setup('getUser', new List<Object>{testOwner.Id}).returns(testOwner);
        mockDataProv.setup('getRelationshipManagers').returns(availableRMs);
        mockParentRelTreeBuilder.setup('getRelationshipTreesForOwners', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(relationshipTree);
        mockParentRelTreeBuilder.setup('getRelationshipTreeListForDisplay', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<ParentRelationships.RelatedEntity>());
        sut = new OwnerOverviewComponent(mockDataProv, mockParentRelTreeBuilder, mockApexPages, mockUserInfoService, mockUtility);
    }

    @IsTest
    static void it_should_call_the_default_constructor_without_error() {
        User testUser = ObjectFactory.getUser('firstName', 'lastName', 'firstNamelastName@enterprisebank.com.test', true);
        Account testAcct = ObjectFactory.getValidEntity('name');
        testAcct.OwnerId = testUser.Id;
        update testAcct;
        ApexPages.currentPage().getParameters().put('Id', testUser.Id);
        OwnerOverviewComponent sutDef = new OwnerOverviewComponent();
    }

    @IsTest
    static void it_should_save_RM_changes_by_sending_modified_items_to_data_provider_for_saving() {
        Account testAcct1 = new Account(Id='001f000000GsU5a', OwnerId='005a00000000001');
        Account testAcct2 = new Account(Id='001f000000GsU6a', OwnerId='005a00000000001');
        Account testAcct3 = new Account(Id='001f000000GsU7a', OwnerId='005a00000000001');
        Account testAcct4 = new Account(Id='001f000000GsU8a', OwnerId='005a00000000001');
        EB_Account_Relationship__c relationship = new EB_Account_Relationship__c(Client_Id__c = testAcct1.ID);
        List<EB_Account_Relationship__c> relationships = new List<EB_Account_Relationship__c>{relationship};
        ParentRelationships.RelatedEntity entity1 = new ParentRelationships.RelatedEntity(testAcct1, relationships,  0, false);
        ParentRelationships.RelatedEntity entity2 = new ParentRelationships.RelatedEntity(testAcct2, relationships, 1, false);
        ParentRelationships.RelatedEntity entity3 = new ParentRelationships.RelatedEntity(testAcct3, relationships, 2, false);
        ParentRelationships.RelatedEntity entity4 = new ParentRelationships.RelatedEntity(testAcct4, relationships, 1, false);
        List<ParentRelationships.RelatedEntity> relationshipTreeForDisplay = new List<ParentRelationships.RelatedEntity>{entity1,entity2,entity3,entity4};
    

        while (relationshipTreeForDisplay.size() < 1000) {
            relationshipTreeForDisplay.add(new ParentRelationships.RelatedEntity(new Account(OwnerId='005a00000000001'),relationships, 1, false));
        }
        MockofIParentRelTreeBuilder mockParentRelTreeBuilderLarge = new MockofIParentRelTreeBuilder();
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreesForOwners', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Map<Id, Account>>());
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreeListForDisplay', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(relationshipTreeForDisplay);
        OwnerOverviewComponent sutForLargeTest = new OwnerOverviewComponent(mockDataProv, mockParentRelTreeBuilderLarge, mockApexPages, mockUserInfoService, mockUtility);
        sutForLargeTest.relationshipTreesForDisplay[2].entity.OwnerId = '005a00000000003';
        sutForLargeTest.relationshipTreesForDisplay[3].entity.OwnerId = '005a00000000004';

        PageReference retURL = sutForLargeTest.saveChanges();

        List<Object> rawRequest = mockDataProv.getArgumentsFromCall('updateEntities');
        List<Account> entitiesUpdated = (List<Account>) (rawRequest.get(0));
        Account testAcct3AfterUpdate = new Account();       
        Account testAcct4AfterUpdate = new Account();       
        for (Account acct : entitiesUpdated) {
            if (acct.Id == testAcct3.Id) {testAcct3AfterUpdate = acct;}
            if (acct.Id == testAcct4.Id) {testAcct4AfterUpdate = acct;}
        }
        System.assertEquals(testAcct3.Id, testAcct3AfterUpdate.Id);
        System.assertEquals('005a00000000003', testAcct3AfterUpdate.OwnerId);
        System.assertEquals(testAcct4.Id, testAcct4AfterUpdate.Id);
        System.assertEquals('005a00000000004', testAcct4AfterUpdate.OwnerId);
    }

    @IsTest
    static void it_should_set_variable_indicating_changes_have_been_made() {
        System.assertEquals(false, sut.haveChangesBeenMade);

        sut.changesMade();

        System.assertEquals(true, sut.haveChangesBeenMade);
    }

    @IsTest
    static void it_should_return_true_if_user_is_admin() {
        mockUserInfoService.setup('isSystemAdministrator', new List<Object>{testOwner.Id}).returns(true);
        mockUserInfoService.setup('hasPermissionSet', new List<Object>{testOwner.Id, 'Function - Mass Modify RM'}).returns(false);

        System.assertEquals(true, sut.canEditRM);
    }

    @IsTest
    static void it_should_return_true_if_user_has_permission_to_edit() {
        mockUserInfoService.setup('isSystemAdministrator', new List<Object>{testOwner.Id}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<Object>{testOwner.Id, 'Function - Mass Modify RM'}).returns(true);

        System.assertEquals(true, sut.canEditRM);
    }

    @IsTest
    static void it_should_return_false_if_user_does_not_have_permission_to_edit() {
        mockUserInfoService.setup('isSystemAdministrator', new List<Object>{testOwner.Id}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<Object>{testOwner.Id, 'Function - Mass Modify RM'}).returns(false);

        System.assertEquals(false, sut.canEditRM);
    }

    @IsTest
    static void it_should_return_user_back_to_owner_selection_page_if_cancel_selected_and_no_return_url_provided() {
        mockUtility.setup('getServerUrl').returns('homepage');

        PageReference retURL = sut.cancel();

        System.assertEquals('homepage/apex/OwnerSelection', retURL.getUrl());
    }

    @IsTest
    static void it_should_return_to_return_url_if_cancel_selected_and_return_url_provided() {
        mockApexPages.setup('getParameter', new List<Object>{'retURL'}).returns('returnURL');
        mockUtility.setup('getServerUrl').returns('homepage');

        PageReference retURL = sut.cancel();

        System.assertEquals('returnURL', retURL.getUrl());
    }

    @IsTest
    static void it_should_display_next_page_link_if_a_next_page_is_available() {
        List<ParentRelationships.RelatedEntity> relationshipTreeForDisplay = new List<ParentRelationships.RelatedEntity>();
        EB_Account_Relationship__c relationship = new EB_Account_Relationship__c();
        List<EB_Account_Relationship__c> relationships = new List<EB_Account_Relationship__c>{relationship};
        while (relationshipTreeForDisplay.size() < 1000) {
            relationshipTreeForDisplay.add(new ParentRelationships.RelatedEntity(new Account(OwnerId='005a00000000001'),relationships, 1, false));
        }
        MockofIParentRelTreeBuilder mockParentRelTreeBuilderLarge = new MockofIParentRelTreeBuilder();
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreesForOwners', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Map<Id, Account>>());
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreeListForDisplay', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(relationshipTreeForDisplay);
        OwnerOverviewComponent sutForLargeTest = new OwnerOverviewComponent(mockDataProv, mockParentRelTreeBuilderLarge, mockApexPages, mockUserInfoService, mockUtility);
        sutForLargeTest.currentPageNumber = 0;

        System.assertEquals(true, sutForLargeTest.displayNextPageLink);
    }

    @IsTest
    static void it_should_display_previous_page_link_if_not_on_first_page() {
        List<ParentRelationships.RelatedEntity> relationshipTreeForDisplay = new List<ParentRelationships.RelatedEntity>();
         EB_Account_Relationship__c relationship = new EB_Account_Relationship__c();
        List<EB_Account_Relationship__c> relationships = new List<EB_Account_Relationship__c>{relationship};
        while (relationshipTreeForDisplay.size() < 1000) {
            relationshipTreeForDisplay.add(new ParentRelationships.RelatedEntity(new Account(OwnerId='005a00000000001'),relationships, 1, false));
        }
        MockofIParentRelTreeBuilder mockParentRelTreeBuilderLarge = new MockofIParentRelTreeBuilder();
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreesForOwners', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Map<Id, Account>>());
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreeListForDisplay', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(relationshipTreeForDisplay);
        OwnerOverviewComponent sutForLargeTest = new OwnerOverviewComponent(mockDataProv, mockParentRelTreeBuilderLarge, mockApexPages, mockUserInfoService, mockUtility);
        sutForLargeTest.currentPageNumber = 2;
    
        System.assertEquals(true, sutForLargeTest.displayPrevPageLink);
    }

    @IsTest
    static void it_should_return_the_expanded_relationships() {
        List<ParentRelationships.RelatedEntity> relationshipTreeForDisplay = new List<ParentRelationships.RelatedEntity>();
        EB_Account_Relationship__c relationship = new EB_Account_Relationship__c();
        List<EB_Account_Relationship__c> relationships = new List<EB_Account_Relationship__c>{relationship};
        while (relationshipTreeForDisplay.size() < 1000) {
            relationshipTreeForDisplay.add(new ParentRelationships.RelatedEntity(new Account(OwnerId='005a00000000001', ParentId='001f000000GsU3a'),relationships, 1, false));
            relationshipTreeForDisplay.add(new ParentRelationships.RelatedEntity(new Account(OwnerId='005a00000000001', ParentId=null),relationships, 1, false));
        }
        MockofIParentRelTreeBuilder mockParentRelTreeBuilderLarge = new MockofIParentRelTreeBuilder();
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreesForOwners', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Map<Id, Account>>());
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreeListForDisplay', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(relationshipTreeForDisplay);
        OwnerOverviewComponent sutForLargeTest = new OwnerOverviewComponent(mockDataProv, mockParentRelTreeBuilderLarge, mockApexPages, mockUserInfoService, mockUtility);
        
        sutForLargeTest.expandRelationships();

        System.assertEquals(true, sutForLargeTest.relationshipsExpanded);
        System.assertEquals(951, sutForLargeTest.relationshipTreesForDisplay.size());
    }

    @IsTest
    static void it_should_return_the_collapsed_relationships() {
        List<ParentRelationships.RelatedEntity> relationshipTreeForDisplay = new List<ParentRelationships.RelatedEntity>();
        EB_Account_Relationship__c relationship = new EB_Account_Relationship__c();
        List<EB_Account_Relationship__c> relationships = new List<EB_Account_Relationship__c>{relationship};
        while (relationshipTreeForDisplay.size() < 1000) {
            relationshipTreeForDisplay.add(new ParentRelationships.RelatedEntity(new Account(OwnerId='005a00000000001', ParentId='001f000000GsU3a'),relationships, 1, false));
            relationshipTreeForDisplay.add(new ParentRelationships.RelatedEntity(new Account(OwnerId='005a00000000001', ParentId=null),relationships, 1, false));
        }
        MockofIParentRelTreeBuilder mockParentRelTreeBuilderLarge = new MockofIParentRelTreeBuilder();
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreesForOwners', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Map<Id, Account>>());
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreeListForDisplay', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(relationshipTreeForDisplay);
        OwnerOverviewComponent sutForLargeTest = new OwnerOverviewComponent(mockDataProv, mockParentRelTreeBuilderLarge, mockApexPages, mockUserInfoService, mockUtility);
        
        sutForLargeTest.collapseRelationships();

        System.assertEquals(false, sutForLargeTest.relationshipsExpanded);
        System.assertEquals(475, sutForLargeTest.relationshipTreesForDisplay.size());
    }

    @IsTest
    static void it_should_navigate_to_requested_page() {
        List<ParentRelationships.RelatedEntity> relationshipTreeForDisplay = new List<ParentRelationships.RelatedEntity>();
        EB_Account_Relationship__c relationship = new EB_Account_Relationship__c();
        List<EB_Account_Relationship__c> relationships = new List<EB_Account_Relationship__c>{relationship};
        while (relationshipTreeForDisplay.size() < 1000) {
            relationshipTreeForDisplay.add(new ParentRelationships.RelatedEntity(new Account(OwnerId='005a00000000001'),relationships, 1, false));
        }
        MockofIParentRelTreeBuilder mockParentRelTreeBuilderLarge = new MockofIParentRelTreeBuilder();
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreesForOwners', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Map<Id, Account>>());
        mockParentRelTreeBuilderLarge.setup('getRelationshipTreeListForDisplay', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(relationshipTreeForDisplay);
        OwnerOverviewComponent sutForLargeTest = new OwnerOverviewComponent(mockDataProv, mockParentRelTreeBuilderLarge, mockApexPages, mockUserInfoService, mockUtility);

        System.assertEquals(1, sutForLargeTest.currentPageNumber);
        sutForLargeTest.nextPage();
        System.assertEquals(2, sutForLargeTest.currentPageNumber);
        sutForLargeTest.prevPage();
        System.assertEquals(1, sutForLargeTest.currentPageNumber);
    }

    @IsTest
    static void it_should_get_list_of_available_RMs_from_data_prov() {
        mockDataProv.verify('getRelationshipManagers', Times.Once);  
    }

    @IsTest
    static void it_should_populate_select_list_of_RMs_with_those_from_data_prov() {
        System.assertEquals(3, sut.availableRMs.size());
        Boolean foundRM1 = false;
        Boolean foundRM2 = false;
        Boolean foundRM3 = false;
        for (SelectOption option : sut.availableRMs) {
            if (option.getValue() == rm1.Id) {foundRM1 = true;}
            if (option.getValue() == rm2.Id) {foundRM2 = true;}
            if (option.getValue() == rm3.Id) {foundRM3 = true;}
        }
        System.assertEquals(true, foundRM1);        
        System.assertEquals(true, foundRM2);        
        System.assertEquals(true, foundRM3);        
    }

    @IsTest
    static void it_should_make_call_to_get_all_eb_accounts_for_owner() {
        mockDataProv.setup('getEntitiesForOwner', new List<Object>{testOwner.Id}).returns(new List<Account>());
        
        sut.updateAllRM();

        mockDataProv.verify('getEntitiesForOwner', new List<Object>{testOwner.Id}, Times.Once);
    }

    @IsTest
    static void it_should_update_accounts_returned_from_data_provider_to_new_Id_and_submit_back_to_data_provider() {
        Account testAcct1 = new Account(Id=ObjectFactory.getFakeId(Account.SObjectType, '1'));
        Account testAcct2 = new Account(Id=ObjectFactory.getFakeId(Account.SObjectType, '2'));
        Account testAcct3NotIncluded = new Account(Id=ObjectFactory.getFakeId(Account.SObjectType, '3'));
        List<Account> testAccts = new List<Account> {testAcct1, testAcct2};
        mockDataProv.setup('getEntitiesForOwner', new List<Object>{testOwner.Id}).returns(testAccts);   
        mockDataProv.setup('getEBAccountsForOwner', new List<Object>{testOwner.Id}).returns(new List<EB_Account__c>());   
        sut.newRMId = ObjectFactory.getFakeId(User.SObjectType, '9');
        
        sut.updateAllRM();

        List<Object> rawRequest = mockDataProv.getArgumentsFromCall('updateEntities');
        List<Account> entitiesUpdated = (List<Account>) (rawRequest.get(0));
        Account testAcct1AfterUpdate = new Account();       
        Account testAcct2AfterUpdate = new Account();       
        Account testAcct3AfterUpdate;       
        for (Account acct : entitiesUpdated) {
            if (acct.Id == testAcct1.Id) {testAcct1AfterUpdate = acct;}
            if (acct.Id == testAcct2.Id) {testAcct2AfterUpdate = acct;}
            if (acct.Id == testAcct3NotIncluded.Id) {testAcct3AfterUpdate = acct;}
        }
        System.assertEquals(testAcct1.Id, testAcct1AfterUpdate.Id);
        System.assertEquals(sut.NewRMId, testAcct1AfterUpdate.OwnerId);
        System.assertEquals(true, testAcct1AfterUpdate.Relationship_Change_Ignore_Validation__c);
        System.assertEquals(testAcct2.Id, testAcct2AfterUpdate.Id);
        System.assertEquals(sut.NewRMId, testAcct2AfterUpdate.OwnerId);
        System.assertEquals(true, testAcct2AfterUpdate.Relationship_Change_Ignore_Validation__c);
        System.assertEquals(null, testAcct3AfterUpdate);
    }

    private class MockofIOwnerOverviewComponentDataProv extends ApexMoq implements OwnerOverviewComponentDataProv.IOwnerOverviewComponentDataProv {
        public User getUser(Id userId){
            return (User)handleMethodInvocation('getUser', new List<Object>{userId});
        }
        public List<User> getRelationshipManagers(){
            return (List<User>)handleMethodInvocation('getRelationshipManagers');
        }
        public List<Account> getEntitiesForOwner(Id userId){
            return (List<Account>)handleMethodInvocation('getEntitiesForOwner', new List<Object>{userId});
        }
        public void updateEntities(List<Account> entities){
            handleMethodInvocation('updateEntities', new List<Object>{entities});
        }
        public List<EB_Account__c> getEBAccountsForOwner(Id userId){
            return (List<EB_Account__c>)handleMethodInvocation('getEBAccountsForOwner', new List<Object>{userId});
        }
        public void updateEBAccts(List<EB_Account__c> accts){
            handleMethodInvocation('updateEBAccts', new List<Object>{accts});
        }
    }

    private class MockofIParentRelTreeBuilder extends ApexMoq implements ParentRelationships.IParentRelTreeBuilder {
        public List<Map<Id, Account>> getRelationshipTreesForOwners(Set<Id> ownerIds){
            return (List<Map<Id, Account>>)handleMethodInvocation('getRelationshipTreesForOwners', new List<Object>{ownerIds});
        }
        public List<Map<Id, Account>> getRelationshipTreeForEntity(Id entityId, Boolean ignoreLookupForParent, Id excludeChildId){
            return (List<Map<Id, Account>>)handleMethodInvocation('getRelationshipTreeForEntity', new List<Object>{entityId, ignoreLookupForParent, excludeChildId});
        }
        public List<Map<Id, Account>> addChildToRelationshipTreeOfParent(Id parentIDofNewChild, Id childID, String relationshipToParent){
            return (List<Map<Id, Account>>)handleMethodInvocation('addChildToRelationshipTreeOfParent', new List<Object>{parentIDofNewChild, childID, relationshipToParent});
        }
        public List<ParentRelationships.RelatedEntity> getRelationshipTreeListForDisplay(List<Map<Id, Account>> relTree, Id currentId){
            return (List<ParentRelationships.RelatedEntity>)handleMethodInvocation('getRelationshipTreeListForDisplay', new List<Object>{relTree, currentId});
        }
    }
}