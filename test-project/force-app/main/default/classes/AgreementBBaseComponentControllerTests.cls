@isTest
private class AgreementBBaseComponentControllerTests{
    
    static testMethod void it_should_get_a_list_of_BorrowingBase_tied_to_Agreement(){
        TestUtilities.createLoanAppStages();
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;       
        Agreement_Borrowing_Base_Relationship__c bbRelation = new Agreement_Borrowing_Base_Relationship__c(Agreement__c=testAgreement.Id);
        List<Agreement_Borrowing_Base_Relationship__c> bbRelationList = new List<Agreement_Borrowing_Base_Relationship__c>();
        bbRelationList.add(bbRelation);
        t.mockDataProvider.GetBorrowingBaseComponents_Return = bbRelationList;
        
        //act
        t.sut.agmt = testAgreement;
        
        //assert
        system.assertequals(1,t.sut.components.size());
    }

    static testMethod void it_should_edit_a_component(){
        TestUtilities.createLoanAppStages();
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbRelation = new Agreement_Borrowing_Base_Relationship__c(Agreement__c=testAgreement.Id,Amount__c = 10);
        insert bbRelation;
        t.mockdataprovider.GetBorrowingBaseComponent_Return = bbRelation;
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        Agreement_Borrowing_Base_Entity_Rel__c bbentity = new Agreement_Borrowing_Base_Entity_Rel__c(Agreement_Related_Borrowing_Base__c = bbRelation.Id,Entity__c = testEntity.Id );
        List<Agreement_Borrowing_Base_Entity_Rel__c> bbentityList = new List<Agreement_Borrowing_Base_Entity_Rel__c>();
        bbentityList.add(bbentity);
        
        t.mockdataprovider.CurrentComponentEntityRelationshipList_Return = bbentityList;        
        
        bbRelation.Amount__c = 20;
        
        //act
        t.sut.agmt = testAgreement;        
        t.sut.EditComponent();
                
        //assert
        system.assertequals(20,t.sut.component.Amount__c);
    }

    static testMethod void it_should_add_a_component(){
        TestUtilities.createLoanAppStages();
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbRelation = new Agreement_Borrowing_Base_Relationship__c(Agreement__c=testAgreement.Id,Amount__c = 10);
        t.mockdataprovider.GetBorrowingBaseComponent_Return = bbRelation;
        t.mockUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        t.mockUserInfoService.setup('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);                
        
        //act
        t.sut.agmt = testAgreement;        
        t.sut.AddComponent();
        t.sut.component.Amount__c = 30;
        t.sut.SaveDialog();
            
        //assert
        system.assertequals(null,t.sut.component.Id); // checks if the component was refreshed
        system.assertequals(30,t.sut.component.Amount__c);

    }
    static testMethod void it_should_delete_a_component_with_user_having_agmtRW_rights(){
        TestUtilities.createLoanAppStages();
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbRelation = new Agreement_Borrowing_Base_Relationship__c(Agreement__c=testAgreement.Id,Amount__c = 10);
        t.mockdataprovider.GetBorrowingBaseComponent_Return = bbRelation;
        t.mockUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        t.mockUserInfoService.setup('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);

        //act
        t.sut.agmt = testAgreement;        
        t.sut.DeleteRecord();
                
        //assert
        system.assertequals(true,t.mockdataprovider.DeleteComponent_Called);
    }
    
     static testMethod void it_should_delete_a_component_with_user_having_agmtRead_rights(){
        TestUtilities.createLoanAppStages();
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbRelation = new Agreement_Borrowing_Base_Relationship__c(Agreement__c=testAgreement.Id,Amount__c = 10);
        t.mockdataprovider.GetBorrowingBaseComponent_Return = bbRelation;
        t.mockUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        t.mockUserInfoService.setup('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);

        //act
        t.sut.agmt = testAgreement;        
        t.sut.DeleteRecord();
                
        //assert
        system.assertequals(false,t.mockdataprovider.DeleteComponent_Called);
    }
    
    static testMethod void it_should_be_able_to_add_entities_to_component(){
        TestUtilities.createLoanAppStages();
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        Agreement_Client_Relationships__c agmtClient = new Agreement_Client_Relationships__c();
        agmtClient.Entity__c = testEntity.Id;
        agmtClient.Agreement__c = testAgreement.Id;
        //insert agmtClient;
        Agreement_Borrowing_Base_Relationship__c bbRelation = new Agreement_Borrowing_Base_Relationship__c(Agreement__c=testAgreement.Id,Amount__c = 10);
        t.mockdataprovider.GetBorrowingBaseComponent_Return = bbRelation;
        Agreement_Borrowing_Base_Entity_Rel__c bbEntityRel = new Agreement_Borrowing_Base_Entity_Rel__c();
        bbEntityRel.Entity__c = testEntity.Id;
        List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntityRelList = new List<Agreement_Borrowing_Base_Entity_Rel__c>();
        bbEntityRelList.add(bbEntityRel);
        t.mockdataprovider.CurrentComponentEntityRelationshipList_Return = bbEntityRelList;
        insert bbRelation;
        
        //act
        t.sut.agmt = testAgreement;
        
        //assert
        system.assertequals(true,t.sut.Component.EntitiesInText__c!= '');
               
    }
    static testMethod void it_should_call_the_validator_on_save_with_user_having_agmtRW_rights(){
        TestUtilities.createLoanAppStages();
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;        
        Agreement_Borrowing_Base_Relationship__c bbRelation = new Agreement_Borrowing_Base_Relationship__c(Agreement__c=testAgreement.Id,Amount__c = 10);        
        t.mockdataprovider.GetBorrowingBaseComponent_Return = bbRelation;
        t.mockUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        t.mockUserInfoService.setup('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
            
        //act
        t.sut.agmt = testAgreement;        
        t.sut.AddComponent();
        t.sut.SaveDialog();
        
        //assert
        system.assertequals(true,t.mockAgreementValidator.ValidateAndSave_Called);
    }
    
    static testMethod void it_should_call_the_validator_on_save_with_user_having_agmtRead_rights(){
        TestUtilities.createLoanAppStages();
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;        
        Agreement_Borrowing_Base_Relationship__c bbRelation = new Agreement_Borrowing_Base_Relationship__c(Agreement__c=testAgreement.Id,Amount__c = 10);        
        t.mockdataprovider.GetBorrowingBaseComponent_Return = bbRelation;
        t.mockUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        t.mockUserInfoService.setup('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
            
        //act
        t.sut.agmt = testAgreement;        
        t.sut.AddComponent();
        t.sut.SaveDialog();
        
        //assert
        system.assertequals(false,t.mockAgreementValidator.ValidateAndSave_Called);
    }
    
    static testMethod void brute_force_call_the_default_constructor(){
        AgreementBBaseComponentController controller = new AgreementBBaseComponentController();
    }
    
    public static User getUserWithEBBaseUserProfileAndAgreementRead(){
        Profile p = [SELECT Id, Name FROM Profile WHERE Name=:'EB Base User']; 
        User user = ObjectFactory.getUser('test', 'user', 'tuser@email.com', false); 
        user.ProfileId = p.Id;
        
        insert user;
        List<PermissionSet> permissionSetsForAgreementRead = new List<PermissionSet>();
        PermissionSet entityReadAccountReadPermissionset = [SELECT Id, Label FROM PermissionSet where Label=:'Function - Entity & Account Read Only' LIMIT 1 ];
        PermissionSet agreementReadOnlyPersmissionSet = [SELECT Id, Label FROM PermissionSet where Label=:'Function - Lending Agreement System Read Only' LIMIT 1 ];
        PermissionSet loanForceReadPermissionSet = [SELECT Id, Label FROM PermissionSet where Label=:'Function - Loan Force Read Only' LIMIT 1];
        permissionSetsForAgreementRead.add(entityReadAccountReadPermissionset);
        permissionSetsForAgreementRead.add(agreementReadOnlyPersmissionSet);
        permissionSetsForAgreementRead.add(loanForceReadPermissionSet);
        
        List<PermissionSetAssignment> permissionAssigmentforAgmtRead = new List<PermissionSetAssignment>();
        For (PermissionSet ps : permissionSetsForAgreementRead ){
            PermissionSetAssignment newAssignment  = new PermissionSetAssignment();
            newAssignment.AssigneeId = user.Id;
            newAssignment.PermissionSetId = ps.Id;
            permissionAssigmentforAgmtRead.add(newAssignment);
        }
        insert permissionAssigmentforAgmtRead;
        
        return user;
    }
    
    public static User getUserWithEBBaseUserProfileAndAgreementReadAndWrite(){
        Profile p = [SELECT Id, Name FROM Profile WHERE Name=:'EB Base User']; 
        User user = ObjectFactory.getUser('test', 'user', 'tuser@email.com', false); 
        user.ProfileId = p.Id;
        
        insert user;
        List<PermissionSet> permissionSetsForAgreementRead = new List<PermissionSet>();
        PermissionSet entityReadAccountReadPermissionset = [SELECT Id, Label FROM PermissionSet where Label=:'Function - Entity & Account Read Only' LIMIT 1];
        PermissionSet agreementReadOnlyPersmissionSet = [SELECT Id, Label FROM PermissionSet where Label=:'Function - Lending Agreement System Read/Write' LIMIT 1];
        PermissionSet loanForceReadPermissionSet = [SELECT Id, Label FROM PermissionSet where Label=:'Function - Loan Force Read Only' LIMIT 1];
        permissionSetsForAgreementRead.add(entityReadAccountReadPermissionset);
        permissionSetsForAgreementRead.add(agreementReadOnlyPersmissionSet); 
        permissionSetsForAgreementRead.add(loanForceReadPermissionSet);
        
        List<PermissionSetAssignment> permissionAssigmentforAgmtRead = new List<PermissionSetAssignment>();
        For (PermissionSet ps : permissionSetsForAgreementRead ){
            PermissionSetAssignment newAssignment  = new PermissionSetAssignment();
            newAssignment.AssigneeId = user.Id;
            newAssignment.PermissionSetId = ps.Id;
            permissionAssigmentforAgmtRead.add(newAssignment);
        }
        insert permissionAssigmentforAgmtRead;
        
        return user;
    }
    
    static testMethod void it_should_require_other_description_when_component_is_other(){
        TestUtilities.createLoanAppStages();
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        
        //act
        t.sut.agmt = testAgreement;
        t.sut.AddComponent();
        t.sut.RecordTypeChanged();
        t.sut.Component.Component__c = 'Other';
        t.sut.showFields();
        PageReference p = t.sut.SaveDialog(); //Validation does not let it save
        t.sut.CancelDialog();
        
        //assert
        system.assertequals(null,p);
    }

    static testMethod void it_should_display_the_correct_rate_label(){
        TestUtilities.createLoanAppStages();
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        
        //act
        t.sut.agmt = testAgreement;
        t.sut.AddComponent();
        t.sut.Component.Component__c = 'Cross Agings Limit';
        
        //assert
        system.assertequals('Rate',t.sut.RateLabel);
        
        //act
        t.sut.agmt = testAgreement;
        t.sut.AddComponent();
        t.sut.Component.Component__c = 'Other';
        
        //assert
        system.assertequals('Advance Rate',t.sut.RateLabel);
    }

    static testMethod void it_should_determine_if_other_description_is_required(){
        TestUtilities.createLoanAppStages();
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        
        //act
        t.sut.agmt = testAgreement;
        t.sut.AddComponent();
        t.sut.Component.Component__c = 'Other';
        
        //assert
        system.assertequals(true,t.sut.IsOtherDescriptionRequired);
        
        //act
        t.sut.agmt = testAgreement;
        t.sut.AddComponent();
        t.sut.Component.Component__c = 'test';
        
        //assert
        system.assertequals(false,t.sut.IsOtherDescriptionRequired);
    }
    
    public class TestObjects{
        public MockDataProvider mockDataProvider {get;private set;}
        public MockAgreementValidator mockAgreementValidator{get;private set;}
        public Mock.OfIUserInfoService mockUserInfoService{get; private set;}
        public AgreementBBaseComponentController sut {get;private set;}
        public TestObjects(){
            mockDataProvider = new MockDataProvider();
            mockAgreementValidator = new MockAgreementValidator();
            mockUserInfoService = new Mock.OfIUserInfoService();
            sut = new AgreementBBaseComponentController(mockDataProvider,mockAgreementValidator,mockUserInfoService);
        }
    }

    private class MockAgreementValidator implements Agreements.IAgreementValidator{
        public Boolean Validate_Called{get;private set;}
        public Agreement__c Validate_param_Agreement{get;private set;}
        
        public Boolean ValidateAndSave_Called{get;private set;}
        public Agreement__c ValidateAndSave_param_Agreement{get;private set;}
        
        public Boolean ValidateAndSaveFromTrigger_Called{get;private set;}
        public Agreement__c ValidateAndSaveFromTrigger_param_Agreement{get; private set;}
        
        public boolean  DisableValidateFromTrigger_called{get; private set;}
        public boolean DisableValidateFromTrigger_param_disable{get; private set;}
        
        public MockAgreementValidator(){
            ValidateAndSave_Called = false;
        }
        
        public void Validate(Agreement__c agreement){
            Validate_Called = true;
            Validate_param_Agreement = agreement;           
        }
        public void ValidateAndSave(Agreement__c agreement){
            ValidateAndSave_Called = true;
            ValidateAndSave_param_Agreement = agreement;
        }
        public void ValidateAndSaveFromTrigger(Agreement__c agreement){
            ValidateAndSaveFromTrigger_Called = true;
            ValidateAndSaveFromTrigger_param_Agreement = agreement;
        }
        public void DisableValidateFromTrigger(Boolean disable){
            DisableValidateFromTrigger_called = true;
            DisableValidateFromTrigger_param_disable = disable;
        }
    }

    private class MockDataProvider implements Agreements.IAgreementBBaseComponentControllerDataProvider{
        
        public Boolean SaveComponent_Called{get;set;}
        public Agreement_Borrowing_Base_Relationship__c SaveComponent_Param_Component{get;set;}
        
        public Boolean GetBorrowingBaseComponents_Called{get;set;}
        public Id GetBorrowingBaseComponents_Param_agreementId{get;set;}
        public List<Agreement_Borrowing_Base_Relationship__c> GetBorrowingBaseComponents_Return{get;set;}
        
        public Boolean GetBorrowingBaseComponent_Called{get;set;}
        public Id GetBorrowingBaseComponent_Param_componentId{get;set;}
        public Agreement_Borrowing_Base_Relationship__c GetBorrowingBaseComponent_Return{get;set;}
        
        public Boolean GetAgreementClientRelationships_Called{get;set;}
        public Id GetAgreementClientRelationships_Param_agreementId{get;set;}
        public Map<Id,Agreement_Client_Relationships__c> GetAgreementClientRelationships_Return{get;set;}
        
        public Boolean CurrentComponentEntityRelationshipList_Called{get;set;}
        public Id CurrentComponentEntityRelationshipList_Param_componentId{get;set;}
        public List<Agreement_Borrowing_Base_Entity_Rel__c> CurrentComponentEntityRelationshipList_Return{get;set;}
        
        public Boolean DeleteComponent_Called{get;set;}
        
        public MockDataProvider(){
            DeleteComponent_Called = false;
        }
        
        public void DeleteComponent(Agreement_Borrowing_Base_Relationship__c component){
            DeleteComponent_Called = true;
        }
        
        public void SaveComponent(Agreement_Borrowing_Base_Relationship__c component){          
            SaveComponent_Called = true;
            SaveComponent_Param_Component = component;
        }
        
        public void InsertComponentEntities(List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntities){}
        public void DeleteComponentEntities(List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntities){}
        
        public List<Agreement_Borrowing_Base_Relationship__c> GetBorrowingBaseComponents(Id agreementId){
            GetBorrowingBaseComponents_Called = true;
            GetBorrowingBaseComponents_Param_agreementId = agreementId;          
            return GetBorrowingBaseComponents_Return;
        }
        public Agreement_Borrowing_Base_Relationship__c GetBorrowingBaseComponent(Id componentId){
            GetBorrowingBaseComponent_Called = true;
            GetBorrowingBaseComponent_Param_componentId = componentId;
            return GetBorrowingBaseComponent_Return;
        }
        public Map<Id,Agreement_Client_Relationships__c> GetAgreementClientRelationships(Id agreementId){
            GetAgreementClientRelationships_Called = true;
            GetAgreementClientRelationships_Param_agreementId = agreementId;
            return GetAgreementClientRelationships_Return;
        }
        public List<Agreement_Borrowing_Base_Entity_Rel__c> CurrentComponentEntityRelationshipList(Id componentId){
            CurrentComponentEntityRelationshipList_Called = true;
            CurrentComponentEntityRelationshipList_Param_componentId = componentId;
            return CurrentComponentEntityRelationshipList_Return;
        }
    }
    
}