@IsTest
public class ParentRelManagerControllerTests {

    private static final MockofIParentRelManagerControllerDataProvider mockDataProvider = new MockofIParentRelManagerControllerDataProvider();

    @IsTest
    static void it_should_return_false_if_entity_has_no_parent() {
        Account testAcct = new Account(Id='001f000000GsU5a');
        testAcct.ParentId = null;
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);

        System.assertEquals(false, sut.hasParent);
    }

    @IsTest
    static void it_should_return_true_if_entity_has_a_parent() {
        Account testAcct = new Account(Id='001f000000GsU5a');
        testAcct.ParentId = '001f000000GsU6a';
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);

        System.assertEquals(true, sut.hasParent);
    }

    @IsTest
    static void it_should_retrieve_entity_via_default_constructor() {
        Account testAcct = ObjectFactory.getValidEntity('name');
        PageReference pr = Page.ParentRelationshipManagerView;
        test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('Id', testAcct.Id);
        ParentRelManagerController sut = new ParentRelManagerController();

        System.assertEquals(testAcct.Id, sut.viewEntity.entity.Id);
    }

    @IsTest
    static void it_should_only_enable_save_button_after_changes_are_made() {
        Account testAcct = new Account(Id='001f000000GsU5a');
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);
        System.assertEquals(true, sut.saveDisabled);
        sut.changesMade();
        System.assertEquals(false, sut.saveDisabled);
    }

    @IsTest
    static void it_should_save_changes_to_entity_and_return_entity_page() {
        Account testAcct = new Account(Id='001f000000GsU5a');
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);

        PageReference newPage = sut.save();

        mockDataProvider.verify('saveEntity', new List<Object>{testAcct}, Times.Once);
        System.assertEquals(true, newPage.getUrl().contains(testAcct.Id));
    }

    @IsTest
    static void it_should_not_save_changes_to_entity_and_return_entity_page() {
        Account testAcct = ObjectFactory.getValidEntity('name');
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        Account preCallAcct = [SELECT Id, Name FROM Account WHERE Id =: testAcct.Id];
        testAcct.Name = 'newname';
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);

        PageReference newPage = sut.cancel();
        Account postCallAcct = [SELECT Id, Name FROM Account WHERE Id =: testAcct.Id];

        mockDataProvider.verify('saveEntity', new List<Object>{testAcct}, Times.Never);
        System.assertEquals(preCallAcct.Name, postCallAcct.Name);
        System.assertEquals(true, newPage.getUrl().contains(testAcct.Id));
    }

    @IsTest
    static void it_should_return_the_name_of_the_entity_parent() {
        Account testAcct = new Account(Id='001f000000GsU5a');
        Account testAcctParent = new Account(Id='001f000000GsU6a');
        testAcctParent.Name = 'ParentName';
        testAcct.parentId = testAcctParent.Id;
            
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        mockDataProvider.setup('getEntity', new List<Object>{testAcctParent.Id}).returns(testAcctParent);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);

        System.assertEquals(testAcctParent.Name, sut.viewEntity.entityParentName);
    }

    @IsTest
    static void it_should_clear_relationship_to_parent_when_toggling_no_parent() {
        Account testAcct = new Account(Id='001f000000GsU5a');
        Account testAcctParent = new Account(Id='001f000000GsU6a');
        testAcct.parentId = testAcctParent.Id;
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);
        System.assertEquals(testAcctParent.Id, testAcct.parentId, 'it_should_clear_relationship_to_parent_when_toggling_no_parent: ParentId not setup initially');

        sut.noParentToggled();

        System.assertEquals(null, testAcct.parentId);
    }

    @IsTest
    static void it_should_clear_relationship_to_parent_when_setting_noparent_to_true() {
        Account testAcct = new Account(Id='001f000000GsU5a');
        Account testAcctParent = new Account(Id='001f000000GsU6a');
        testAcct.parentId = testAcctParent.Id;
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);
        System.assertEquals(testAcctParent.Id, testAcct.parentId, 'it_should_clear_relationship_to_parent: ParentId not setup initially');

        sut.viewEntity.noParent = true;

        System.assertEquals(null, testAcct.parentId);
    }

    @IsTest
    static void it_should_display_the_no_changes_necessary_button_if_account_has_relationship_review_required_date_set() {
        Time eightAM = Time.newInstance(8,0,0,0);
        DateTime expectedDateTime = DateTime.newInstance(Date.Today(), eightAM);
        Account testAcct = new Account(Id='001f000000GsU5a');
        testAcct.Relationship_Review_Required_Date__c = expectedDateTime;
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);
        
        System.assertEquals(true, sut.displayNoChangesNecessary);
    }

    @IsTest
    static void it_should_not_display_the_no_changes_necessary_button_if_relationship_review_required_date_is_null_on_account() {
        Account testAcct = new Account(Id='001f000000GsU5a');
        testAcct.Relationship_Review_Required_Date__c = null;
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);

        System.assertEquals(false, sut.displayNoChangesNecessary);
    }

    @IsTest
    static void it_should_clear_the_relationship_review_required_date_on_account_if_changes_are_made_to_relationships() {
        Time eightAM = Time.newInstance(8,0,0,0);
        DateTime expectedDateTime = DateTime.newInstance(Date.Today(), eightAM);
        Account testAcct = new Account(Id='001f000000GsU5a');
        testAcct.Relationship_Review_Required_Date__c = expectedDateTime;
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);
        sut.changesMade();

        System.assertEquals(false, sut.saveDisabled);
        sut.save();

        mockDataProvider.verify('saveEntity', new List<Object>{testAcct}, Times.Once);       
        System.assertEquals(null, testAcct.Relationship_Review_Required_Date__c);
    }

    @IsTest
    static void it_should_clear_the_relationship_review_required_date_on_account_if_no_changes_option_is_selected_on_save() {
        Time eightAM = Time.newInstance(8,0,0,0);
        DateTime expectedDateTime = DateTime.newInstance(Date.Today(), eightAM);
        Account testAcct = new Account(Id='001f000000GsU5a');
        testAcct.Relationship_Review_Required_Date__c = expectedDateTime;
        mockDataProvider.setup('getEntity', new List<Object>{testAcct.Id}).returns(testAcct);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcct.Id, '', false);

        System.assertEquals(true, sut.saveDisabled);
        sut.noChangesNecessary();

        mockDataProvider.verify('saveEntity', new List<Object>{testAcct}, Times.Once);       
        System.assertEquals(null, testAcct.Relationship_Review_Required_Date__c);
    }

    @IsTest
    static void it_should_return_relationship_review_message_for_opportunity_when_proper_parameter_sent() {
        Account testAcct = ObjectFactory.getValidEntity('name');
        PageReference pr = Page.ParentRelationshipManagerView;
        test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('msg', 'reqOpp');
        ApexPages.currentPage().getParameters().put('Id', testAcct.Id);
        ParentRelManagerController sut = new ParentRelManagerController();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        Boolean messageFound = false;
        for (ApexPages.Message msg:msgs) {
            if (msg.getDetail().contains('required to review the relationship')) {
                messageFound = true;
                break;
            }
        }
        System.assertEquals(true, messageFound);
    }

    @IsTest
    static void it_should_return_error_if_trying_to_set_parent_to_entity_that_is_already_a_child_of_parent() {
        Account testAcctParent = ObjectFactory.getValidEntity('Parent');
        Account testAcctChild = ObjectFactory.getValidEntity('Child');
        testAcctChild.Relationship_Change_Ignore_Validation__c = true;
        testAcctChild.ParentId = testAcctParent.Id;
        update testAcctChild;
        PageReference pr = Page.ParentRelationshipManagerView;
        test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('msg', 'reqOpp');
        ApexPages.currentPage().getParameters().put('Id', testAcctParent.Id);
        ParentRelManagerController sut = new ParentRelManagerController();

        sut.viewEntity.entity.ParentId = testAcctChild.Id;
        sut.viewEntity.entity.Relationship_Change_Ignore_Validation__c = true;
        sut.changesMade();
        sut.save();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        Boolean messageFound = false;
        for (ApexPages.Message msg:msgs) {
            if (msg.getSeverity() == ApexPages.Severity.ERROR) {
                messageFound = true;
                break;
            }
        }

        System.assertEquals(true, messageFound);
    }

    @IsTest
    static void it_should_return_error_if_trying_to_save_to_a_parent_without_a_relationship_defined() {
        Account testAcctParent = new Account(Id='001f000000GsU5a');
        Account testAcctChild = new Account(Id='001f000000GsU6a');
        mockDataProvider.setup('getEntity', new List<Object>{testAcctParent.Id}).returns(testAcctParent);
        mockDataProvider.setup('getEntity', new List<Object>{testAcctChild.Id}).returns(testAcctChild);
        PageReference pr = Page.ParentRelationshipManagerView;
        test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('msg', 'reqOpp');
        ApexPages.currentPage().getParameters().put('Id', testAcctParent.Id);
        ParentRelManagerController sut = new ParentRelManagerController(mockDataProvider, testAcctChild.Id, '', false);

        sut.viewEntity.entity.ParentId = testAcctParent.Id;
        sut.changesMade();
        sut.save();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        Boolean messageFound = false;
        for (ApexPages.Message msg:msgs) {
            if (msg.getSeverity() == ApexPages.Severity.ERROR) {
                messageFound = true;
                break;
            }
        }
        System.assertEquals(true, messageFound);
    }

    private class MockofIParentRelManagerControllerDataProvider extends ApexMoq implements ParentRelationships.IParentRelManagerControllerDataProvider {
        public Account getEntity(Id entityId){
            return (Account)handleMethodInvocation('getEntity', new List<Object>{entityId});
        }
        public void saveEntity(Account entity){
            handleMethodInvocation('saveEntity', new List<Object>{entity});
        }
        public Map<Id, Account> getChildrenForEntities(Set<Id> entityIds){
            return (Map<Id,Account>)handleMethodInvocation('getChildrenForEntities', new List<Object>{entityIds});
        }
    }
}