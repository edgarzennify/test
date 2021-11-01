@IsTest
public class ParentRelManagerControllerDataProvTests {

    private static final ParentRelManagerControllerDataProvider sut = new ParentRelManagerControllerDataProvider();


    private static testMethod void it_should_get_an_entity_for_entityId(){
        Account testEntity = ObjectFactory.getValidEntity('name');
        
        Account currentEntityFromDataProvCall = sut.getEntity(testEntity.Id);
        
        system.assertNotEquals(null, currentEntityFromDataProvCall.Id);       
        system.assertEquals(testEntity.Id, currentEntityFromDataProvCall.Id);       
    }

    private static testMethod void it_should_save_changes_to_an_existing_entity(){
        Account testEntity = ObjectFactory.getValidEntity('testName');
        Account testEntityPreChange = [SELECT id, Name FROM Account WHERE Name =: testEntity.Name];
        testEntity.Name = 'changedName';

        sut.saveEntity(testEntity);
        Account testEntityPostChange = [SELECT id, Name FROM Account WHERE Name =: testEntity.Name];

        system.assertNotEquals(testEntityPreChange.Name, testEntityPostChange.Name);
        system.assertEquals('changedName', testEntityPostChange.Name);
    }

    private static testMethod void it_should_insert_a_new_entity(){
        Account testEntity = new Account();
        testEntity.Name = 'testName';
        testEntity.Relationship_To_Parent__c = 'testType';
        
        sut.saveEntity(testEntity);
        Account testEntityPostInsert = [SELECT id, Relationship_To_Parent__c, Type FROM Account WHERE Name =: testEntity.Name AND Relationship_To_Parent__c =: testEntity.Relationship_To_Parent__c];       

        system.assertEquals('testType', testEntityPostInsert.Relationship_To_Parent__c);
    }

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
        Set<Id> acctIds = new Set<Id>();
        acctIds.Add(testAcctParent1.Id);
        acctIds.Add(testAcctParent2.Id);

        Map<Id, Account> returnResult = sut.getChildrenForEntities(acctIds);

        System.assertEquals(2, returnResult.size());
        System.assert(returnResult.containsKey(testAcctChild1.Id));
        System.assert(returnResult.containsKey(testAcctChild2.Id));
    }

    //private static testMethod void it_should_update_the_entities() {
    //    Account testAcctParent1 = ObjectFactory.getValidEntity('Parent1');
    //    Account testAcctChild1 = ObjectFactory.getValidEntity('Child1');
    //    testAcctChild1.ParentId = testAcctParent1.Id;
    //    testAcctChild1.Relationship_Change_Ignore_Validation__c = true;
    //    testAcctChild1.Relationship_To_Parent__c = 'child';
    //    Account testAcctChild2 = ObjectFactory.getValidEntity('Child2');
    //    testAcctChild2.ParentId = testAcctParent1.Id;
    //    testAcctChild2.Relationship_Change_Ignore_Validation__c = true;
    //    testAcctChild2.Relationship_To_Parent__c = 'child';
    //    List<Account> entitiesToUpdate = new List<Account>{testAcctChild1,testAcctChild2};
    //    Set<Id> childrenIds = new Set<Id>{testAcctChild1.Id,testAcctChild2.Id};
    //    List<Account> testChildrenPreCall = [SELECT id, ParentId FROM Account WHERE Id IN: childrenIds];

    //    sut.updateEntities(entitiesToUpdate);

    //    List<Account> testChildrenPostCall = [SELECT id, ParentId FROM Account WHERE Name IN: childrenIds];

    //    system.assertEquals(null, testChildrenPreCall[0].ParentId);
    //    system.assertEquals(null, testChildrenPreCall[1].ParentId);
    //    system.assertEquals(testAcctParent1.Id, testChildrenPostCall[0].ParentId);
    //    system.assertEquals(testAcctParent1.Id, testChildrenPostCall[1].ParentId);
    //}

    private static testMethod void it_should_return_expected_fields_in_SOQL_for_getEntity() {
        Account testEntity = ObjectFactory.getValidEntity('name');

        Account returnResult = sut.getEntity(testEntity.Id);
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult.Id;
        wasFieldInSOQL = returnResult.name;
        wasFieldInSOQL = returnResult.Relationship_To_Parent__c;
        wasFieldInSOQL = returnResult.Type;
        wasFieldInSOQL = returnResult.Parent.Id;
        wasFieldInSOQL = returnResult.Parent.Name;
        wasFieldInSOQL = returnResult.Parent.Relationship_To_Parent__c;
        wasFieldInSOQL = returnResult.ParentId;
        wasFieldInSOQL = returnResult.OwnerId;
        wasFieldInSOQL = returnResult.EB_UnitID__c;
        wasFieldInSOQL = returnResult.Relationship_Change_Ignore_Validation__c;
    }

    private static testMethod void it_should_return_expected_fields_in_SOQL_for_getChildrenForEntities() {
        Account testEntity = ObjectFactory.getValidEntity('name');
        Account childEntity = ObjectFactory.getValidEntity('child');
        childEntity.ParentId = testEntity.Id;
        childEntity.Relationship_Change_Ignore_Validation__c = true;
        update childEntity;

        Map<Id, Account> returnResult = sut.getChildrenForEntities(new Set<Id>{testEntity.Id});
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult.get(childEntity.Id).Id;
        wasFieldInSOQL = returnResult.get(childEntity.Id).OwnerId;
        wasFieldInSOQL = returnResult.get(childEntity.Id).EB_UnitID__c;
    }


}