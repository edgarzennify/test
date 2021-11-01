@isTest
private class AccountTriggerHandlerDataProvTests {
    
    private static final AccountTriggerHandlerDataProv sut = new AccountTriggerHandlerDataProv();

    private static testMethod void it_should_retrieve_the_children_for_the_entities() {
        Account testAcctParent1 = ObjectFactory.getValidEntity('Parent1');
        Account testAcctChild1 = ObjectFactory.getValidEntity('Child1');
        testAcctChild1.ParentId = testAcctParent1.Id;
        testAcctChild1.Relationship_Change_Ignore_Validation__c = true;
        testAcctChild1.Relationship_To_Parent__c = 'child';
        update testAcctChild1;
        Account testAcctParent2 = ObjectFactory.getValidEntity('Parent2');
        Account testAcctChild2 = ObjectFactory.getValidEntity('Child2');
        testAcctChild2.ParentId = testAcctParent2.Id;
        testAcctChild2.Relationship_Change_Ignore_Validation__c = true;
        testAcctChild2.Relationship_To_Parent__c = 'child';
        update testAcctChild2;
        Account testAcctParent3 = ObjectFactory.getValidEntity('ParentNotIncluded3');
        Account testAcctChild3 = ObjectFactory.getValidEntity('ChildNotIncluded3');
        testAcctChild3.ParentId = testAcctParent3.Id;
        testAcctChild3.Relationship_Change_Ignore_Validation__c = true;
        testAcctChild3.Relationship_To_Parent__c = 'child';
        update testAcctChild3;
        Set<Id> acctIds = new Set<Id>{testAcctParent1.Id, testAcctParent2.Id};

        List<Account> returnResult = sut.getChildrenOfAccounts(acctIds);

        Boolean child1Found = false;
        Boolean child2Found = false;
        for(Account child : returnResult){
            if(child.Id == testAcctChild1.Id){
                child1Found = true;
            }else if(child.Id == testAcctChild2.Id){
                child2Found = true;
            }
        }

        System.assertEquals(2, returnResult.size());
        System.assertEquals(true, child1Found);
        System.assertEquals(true, child2Found);
    }

    private static testMethod void it_should_return_an_empty_list_if_no_children_found() {
        Account testAcctParent1 = ObjectFactory.getValidEntity('Parent1');
        Set<Id> acctIds = new Set<Id>{testAcctParent1.Id};

        List<Account> returnResult = sut.getChildrenOfAccounts(acctIds);
    
        System.assertEquals(0, returnResult.size());
    }

    private static testMethod void it_should_update_the_accounts() {
        Account testAcct1 = ObjectFactory.getValidEntity('Old Name 1');
        Account testAcct2 = ObjectFactory.getValidEntity('Old Name 2');
        testAcct1.Name = 'New Name 1';
        testAcct2.Name = 'New Name 2';
        List<Account> acctsToUpdate = new List<Account>{testAcct1, testAcct2};
        Account testAcct1PreChange = [SELECT Name FROM Account WHERE Id =: testAcct1.Id];
        Account testAcct2PreChange = [SELECT Name FROM Account WHERE Id =: testAcct2.Id];
        
        sut.updateAccounts(acctsToUpdate);

        Account testAcct1PostChange = [SELECT Name FROM Account WHERE Id =: testAcct1.Id];
        Account testAcct2PostChange = [SELECT Name FROM Account WHERE Id =: testAcct2.Id];

        system.assertEquals('Old Name 1', testAcct1PreChange.Name);
        system.assertEquals('Old Name 2', testAcct2PreChange.Name);
        system.assertEquals('New Name 1', testAcct1PostChange.Name);
        system.assertEquals('New Name 2', testAcct2PostChange.Name);
    }

    private static testMethod void it_should_return_expected_fields_in_SOQL_for_getChildrenOfAccounts() {
        Account testAcctParent1 = ObjectFactory.getValidEntity('Parent1');
        Account testAcctChild1 = ObjectFactory.getValidEntity('Child1');
        testAcctChild1.ParentId = testAcctParent1.Id;
        testAcctChild1.Relationship_Change_Ignore_Validation__c = true;
        testAcctChild1.Relationship_To_Parent__c = 'child';
        update testAcctChild1;
        Set<Id> acctIds = new Set<Id>{testAcctParent1.Id};

        List<Account> returnResult = sut.getChildrenOfAccounts(acctIds);
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Id;
        wasFieldInSOQL = returnResult[0].ParentId;
        wasFieldInSOQL = returnResult[0].OwnerId;
        wasFieldInSOQL = returnResult[0].EB_UnitID__c;
        wasFieldInSOQL = returnResult[0].Relationship_Change_Ignore_Validation__c;
    }

    private static testMethod void it_should_return_all_team_members_given_a_list_of_user_ids(){
        User user1 = ObjectFactory.getUser('user1','one','one@user.enterprisebank.sfdc.com', false);
        User user2 = ObjectFactory.getUser('user2','two','two@user.enterprisebank.sfdc.com', false);
        User user3 = ObjectFactory.getUser('user3','three','three@user.enterprisebank.sfdc.com', false);
        insert (new List<User> {user1, user2, user3});

        EB_Team_Member__c tm1 = new EB_Team_Member__c(User__c = user1.Id);
        EB_Team_Member__c tm2 = new EB_Team_Member__c(User__c = user2.Id);
        EB_Team_Member__c tm3 = new EB_Team_Member__c(User__c = user3.Id);
        insert (new List<EB_Team_Member__c>{tm1,tm2,tm3});
        
        List<Id> userIds = new List<Id> {user1.Id, user2.Id};
       
        List<EB_Team_Member__c> result = sut.getTeamMembersById(userIds); 

        System.assertEquals(2, result.size());
        System.assertEquals(user1.Id, result[0].User__c);
        System.assertEquals(user2.Id, result[1].User__c);
    }
    
}