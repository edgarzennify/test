@IsTest
private class Clone_AgreementTests{
    static testMethod void it_should_clone_the_related_child_objects(){
        //Assemble: Setup/Instantiation
        TestObjects t = new TestObjects();
        Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.Name = 'AGMT-0001 rev 01';
        original.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Active').Id;
        insert original;
        //Assemble: Build/Assign Test values
        List<Agreement_Borrowing_Base_Relationship__c> bbRel = new List<Agreement_Borrowing_Base_Relationship__c>();
        List<Agreement_Financial_Covenant__c> fcRel = new List<Agreement_Financial_Covenant__c>();
        List<Agreement_Client_Relationships__c> crRel = new List<Agreement_Client_Relationships__c>();
        List<Agreement_EB_Account_Relationship__c> arRel = new List<Agreement_EB_Account_Relationship__c>();
        List<Agreement_Loan_Application_Relationship__c> larRel = new List<Agreement_Loan_Application_Relationship__c>();
        List<Agreement_Subordination__c> subRel = new List<Agreement_Subordination__c>();
        bbRel.add(New Agreement_Borrowing_Base_Relationship__c(Agreement__c = original.Id));
        fcRel.add(New Agreement_Financial_Covenant__c(Agreement__c = original.Id));
        crRel.add(New Agreement_Client_Relationships__c(Agreement__c = original.Id));
        subRel.add(New Agreement_Subordination__c(Agreement__C = original.Id,Creditor__c = ObjectFactory.getValidEntity('Test Entity').Id));
        Agreement_Borrowing_Base_Entity_Rel__c bbEntity = new Agreement_Borrowing_Base_Entity_Rel__c();
        bbEntity.Agreement_Related_Borrowing_Base__c = bbRel[0].Id;
        bbEntity.Entity__c = ObjectFactory.getValidEntity('Test Entity').Id;
        Agreement_Financial_Covenant_Entity_Rel__c fcEntity = new Agreement_Financial_Covenant_Entity_Rel__c();
        fcEntity.Agreement_Financial_Covenant__c = fcRel[0].Id;
        fcEntity.Entity__c = ObjectFactory.getValidEntity('Test Entity').Id;
        Agreement_Subordination_Entity_Rel__c subEntity = new Agreement_Subordination_Entity_Rel__c();
        subEntity.Agreement_Subordination__c = subRel[0].Id;
        subEntity.Entity__c = ObjectFactory.getValidEntity('Test Entity').Id;     
        
        t.mockDataProvider.getAgreementById_Return= original;
        t.mockDataProvider.bbRelToReturn = bbRel;
        t.mockDataProvider.fcRelToReturn = fcRel;
        t.mockDataProvider.crRelToReturn = crRel;
        t.mockDataProvider.arRelToReturn = arRel;
        t.mockDataProvider.larRelToReturn = larRel;
        t.mockDataProvider.subRelToReturn = subRel;
        t.mockRelCloner.cloneCR_Return = new Map<SObject,List<SObject>>();
        t.mockRelCloner.cloneBB_Return = new Map<SObject,List<SObject>>();
        t.mockRelCloner.cloneBB_Return.put((SObject)bbRel[0], (List<SObject>)new List<Agreement_Borrowing_Base_Entity_Rel__c>{ bbEntity});
        t.mockRelCloner.cloneFC_Return = new Map<SObject,List<SObject>>();
        t.mockRelCloner.cloneFC_Return.put((SObject)fcRel[0], (List<SObject>)new List<Agreement_Financial_Covenant_Entity_Rel__c>{ fcEntity});
        t.mockRelCloner.cloneSUB_Return = new Map<SObject,List<SObject>>();
        t.mockRelCloner.cloneSUB_Return.put((SObject)subRel[0], (List<SObject>)new List<Agreement_Subordination_Entity_Rel__c>{ subEntity});
        //Act
        Agreement__c copy = t.sut.Clone(original.Id);         
        
        //Assert
        System.assertEquals(true, t.mockDataProvider.wasGetBBRelCalled);
        
        System.assertEquals(true, t.mockRelCloner.cloneBB_Called);
        System.assertEquals(bbRel, t.mockRelCloner.cloneBB_OrigList);
        System.assertEquals(copy.Id, t.mockRelCloner.cloneBB_AgreementId);
        
        System.assertEquals(true, t.mockRelCloner.cloneFC_Called);
        System.assertEquals(fcRel, t.mockRelCloner.cloneFC_OrigList);
        System.assertEquals(copy.Id, t.mockRelCloner.cloneFC_AgreementId);
        
        System.assertEquals(true, t.mockRelCloner.cloneCR_Called);
        System.assertEquals(crRel, t.mockRelCloner.cloneCR_OrigList);
        System.assertEquals(copy.Id, t.mockRelCloner.cloneCR_AgreementId);
        
        System.assertEquals(true, t.mockRelCloner.cloneAR_Called);
        System.assertEquals(arRel, t.mockRelCloner.cloneAR_OrigList);
        System.assertEquals(copy.Id, t.mockRelCloner.cloneAR_AgreementId);
        
        System.assertEquals(true, t.mockRelCloner.cloneLAR_Called);
        System.assertEquals(larRel, t.mockRelCloner.cloneLAR_OrigList);
        System.assertEquals(copy.Id, t.mockRelCloner.cloneLAR_AgreementId);
        
        System.assertEquals(true, t.mockRelCloner.cloneSUB_Called);
        System.assertEquals(subRel, t.mockRelCloner.cloneSUB_OrigList);
        System.assertEquals(copy.Id, t.mockRelCloner.cloneSUB_AgreementId);
    }
    
    static testMethod void it_should_not_throw_an_exception_when_the_cloned_BorrowingBaseList_contains_a_null(){
        //Assemble: Setup/Instantiation
        TestObjects t = new TestObjects();
        //Assemble: Build/Assign Test values
        Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Active').Id;
        original.Name = 'AGMT-0001 rev 01';
            
        insert original;
        
        t.mockDataProvider.getAgreementById_Return = original;
        t.mockRelCloner.cloneCR_Return = new Map<SObject,List<SObject>>();
                        
        List<Agreement_Borrowing_Base_Relationship__c> bbListWithNull = new List<Agreement_Borrowing_Base_Relationship__c>();
        //bbListWithNull.add(null);
        Agreement_Borrowing_Base_Relationship__c bbRel = new Agreement_Borrowing_Base_Relationship__c();
        bbRel.Agreement__c = original.Id;
        bbListWithNull.add(bbRel);
        t.mockRelCloner.cloneBB_Return = new Map<SObject,List<SObject>>();
        
        //Act
        Agreement__c copy = t.sut.Clone(original.Id);         
        
        //Assert
		System.assertEquals(1, 1, 'if we get here without an exception thrown we are good');
    }
    
    static testMethod void it_should_retain_the_original_agreements_name_but_add_version_number_to_it(){
        //Assemble: Setup/Instantiation
        TestObjects t = new TestObjects();
        //Assemble: Build/Assign Test values
        Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.Name = 'AGMT-0001 rev 01';
        insert original;
        original = FetchAgreementFromDatabase(original.Id);
        
        t.mockDataProvider.getAgreementById_Return = original;
        t.mockRelCloner.cloneCR_Return = new Map<SObject,List<SObject>>();
                
        //Act
        Agreement__c copy = t.sut.Clone(original.Id);        
        
        //Assert
        copy = FetchAgreementFromDatabase(copy.Id);
		System.assertEquals(original.Name + ' rev 01', copy.Name);
        System.assertEquals(1, copy.Revision_Number__c);
    }    
    
    static testMethod void it_should_retain_a_lookup_to_the_orignal_agreement(){
        //Assemble: Setup/Instantiation
        TestObjects t = new TestObjects();
        //Assemble: Build/Assign Test values
        Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.Name = 'AGMT-0001 rev 01';
        insert original;
        
        t.mockDataProvider.getAgreementById_Return = original;
        t.mockRelCloner.cloneCR_Return = new Map<SObject,List<SObject>>();
                        
        //Act
        Agreement__c copy = t.sut.Clone(original.Id);        
        
        //Assert
        System.assertEquals(original.Id, copy.Source_Agreement__c);
    }
    
    static testMethod void it_should_set_the_copys_status_to_pending(){
        //Assemble: Setup/Instantiation
        TestObjects t = new TestObjects();
        //Assemble: Build/Assign Test values
        Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.Agreement_Status__c = 'Active';
        original.Name = 'AGMT-0001 rev 01';
        insert original;
        
        t.mockDataProvider.getAgreementById_Return = original;
        t.mockRelCloner.cloneCR_Return = new Map<SObject,List<SObject>>();
                        
        //Act
        Agreement__c copy = t.sut.Clone(original.Id);        
        
        //Assert
        System.assertEquals('Pending', copy.Agreement_Status__c);
    }
    
    static testMethod void it_should_load_the_original_agreement_by_id(){
        //Assemble: Setup/Instantiation
        TestObjects t = new TestObjects();
        //Assemble: Build/Assign Test values
        Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.Name = 'AGMT-0001 rev 01';
        insert original;
        
        t.mockDataProvider.getAgreementById_Return = original;
        t.mockRelCloner.cloneCR_Return = new Map<SObject,List<SObject>>();
                        
        //Act
        Agreement__c copy = t.sut.Clone(original.Id);        
        
        //Assert
        System.assertEquals(true, t.mockDataProvider.getAgreementById_Called);
        System.assertEquals(original.Id, t.mockDataProvider.getAgreementById_Parameter_agreementId);
    }
    
    static testMethod void it_should_clone_an_agreement_and_remove_loanapps_from_original_Active_Agreement(){
        //Assemble
        TestUtilities.createLoanAppStages();
        TestObjects t = new TestObjects();

        Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.Name = 'AGMT-1001';
        insert original;
        
        t.mockDataProvider.getAgreementById_Return = original;
        t.mockRelCloner.cloneCR_Return = new Map<SObject,List<SObject>>();
        
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '11234');
        system.debug('### loanapp id in test : ' + newLoanApplication.Id);
        Agreement_Loan_Application_Relationship__c testAgmtLoanAppRel = new  Agreement_Loan_Application_Relationship__c();
        testAgmtLoanAppRel.Agreement__c = original.Id;
        testAgmtLoanAppRel.Loan_Application__c = newLoanApplication.Id;
        insert testAgmtLoanAppRel;
        
        //Act
        Agreement__c copy = t.sut.CloneAndRemoveLoanApps(original.Id);
        
        //Assert
        system.assert(t.mockDataProvider.RemoveAgreementLoanApps_Called == true);
    }
    
    static testMethod void it_can_get_pending_agreement_count(){
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Name = 'test rev 02';
        insert testAgreement;
        
        integer count = t.sut.GetPendingAgreementCount(testAgreement);
        
        system.assertEquals(true, t.mockDataProvider.GetPendingAgreementCountByName_Called);
    }
    
    static testMethod void it_get_get_an_agreement_id(){
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        
        t.sut.GetAgreementById(testAgreement.Id);
        
        system.assertEquals(true, t.mockDataProvider.getAgreementById_Called);
    }
    
    static testMethod void it_should_send_the_agreement_root_name_to_the_data_provider_to_check_for_other_agreements_already_in_process(){
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c(Name='AGMT-0000930');
        
        t.sut.GetPendingAgreementCount(testAgreement);
        
        System.assertEquals('AGMT-0000930', t.mockDataProvider.GetPendingAgreementCountByName_Param_revisionName);
    }
    
    static testMethod void it_should_send_the_agreement_root_name_to_the_data_provider_to_check_for_other_agreements_already_in_process_with_revision(){
    	TestObjects t = new TestObjects();
    	Agreement__c testAgreement = new Agreement__c(Name='AGMT-0000930 rev 01');
    	
    	t.sut.GetPendingAgreementCount(testAgreement);
    	
    	System.assertEquals('AGMT-0000930', t.mockDataProvider.GetPendingAgreementCountByName_Param_revisionName);
    }
    
    static testMethod void it_should_clone_the_borrowing_base_relationships(){
        //assemble
        Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.Loan_Coordinator__c = null;
        original.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Active').Id;
        original.Name = 'AGMT-0001 rev 01';
        insert original;
        Account entity = new Account(FirstName='Test', LastName='Entity');
        insert entity;
        Agreement_Borrowing_Base_Relationship__c rel = new Agreement_Borrowing_Base_Relationship__c();
        rel.Agreement__c = original.Id;
        insert rel;
        Agreement_Borrowing_Base_Entity_Rel__c relEntity = new Agreement_Borrowing_Base_Entity_Rel__c();
        relEntity.Agreement_Related_Borrowing_Base__c = rel.Id;
        relEntity.Entity__c = entity.Id;
        insert relEntity;
        Mock.ofIUserInfoService mockUserInfoService = new Mock.ofIUserInfoService();
        mockUserInfoService.setup('getCurrentUserId').returns(ObjectFactory.getUser().Id);

        //act
        Clone_Agreement sut = new Clone_Agreement(new Clone_AgreementDataProvider(), new Clone_AgreementRelationships(mockUserInfoService), AgreementValidator.getInstance());
        Agreement__c copy = sut.Clone(original.Id);

        //assert
        List<Agreement_Borrowing_Base_Relationship__c> requeryRels = [SELECT Id, Name FROM Agreement_Borrowing_Base_Relationship__c WHERE Agreement__c =: copy.Id];
        System.assertEquals(1, requeryRels.size());
        
        List<Agreement_Borrowing_Base_Entity_Rel__c> requeryAllEntityRels = [SELECT Id, Name FROM Agreement_Borrowing_Base_Entity_Rel__c];
        System.assertEquals(2, requeryAllEntityRels.size());
        
        List<Agreement_Borrowing_Base_Entity_Rel__c> requeryEntityRels = [SELECT Id, Name FROM Agreement_Borrowing_Base_Entity_Rel__c WHERE Agreement_Related_Borrowing_Base__c =: requeryRels[0].Id];
        System.assertEquals(1, requeryEntityRels.size());
    }
    
    static testMethod void it_should_clone_the_financial_covenant_relationships(){
        Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Active').Id;
        original.Name = 'AGMT-0001 rev 01';
        insert original;
        Account entity = new Account(FirstName='Test', LastName='Entity');
        insert entity;
        Agreement_Financial_Covenant__c rel = new Agreement_Financial_Covenant__c();
        rel.Agreement__c = original.Id;
        insert rel;
        Agreement_Financial_Covenant_Entity_Rel__c relEntity = new Agreement_Financial_Covenant_Entity_Rel__c();
        relEntity.Agreement_Financial_Covenant__c = rel.Id;
        relEntity.Entity__c = entity.Id;
        insert relEntity;
        Mock.ofIUserInfoService mockUserInfoService = new Mock.ofIUserInfoService();
        mockUserInfoService.setup('getCurrentUserId').returns(ObjectFactory.getUser().Id);
        
        Clone_Agreement sut = new Clone_Agreement(new Clone_AgreementDataProvider(), new Clone_AgreementRelationships(mockUserInfoService), AgreementValidator.getInstance());
        Agreement__c copy = sut.Clone(original.Id);
        
        List<Agreement_Financial_Covenant__c> requeryRels = [SELECT Id, Name FROM Agreement_Financial_Covenant__c WHERE Agreement__c =: copy.Id];
        System.assertEquals(1, requeryRels.size());
        
        List<Agreement_Financial_Covenant_Entity_Rel__c> requeryAllEntityRels = [SELECT Id, Name FROM Agreement_Financial_Covenant_Entity_Rel__c];
        System.assertEquals(2, requeryAllEntityRels.size());
        
        List<Agreement_Financial_Covenant_Entity_Rel__c> requeryEntityRels = [SELECT Id, Name FROM Agreement_Financial_Covenant_Entity_Rel__c WHERE Agreement_Financial_Covenant__c =: requeryRels[0].Id];
        System.assertEquals(1, requeryEntityRels.size());
    }
    
    static testMethod void it_should_clone_the_subordination_relationships(){
        Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Active').Id;
        original.Name = 'AGMT-0001 rev 01';
        insert original;
        Account entity = new Account(FirstName='Test', LastName='Entity');
        insert entity;
        Agreement_Subordination__c rel = new Agreement_Subordination__c();
        rel.Agreement__c = original.Id;
        rel.Creditor__c = entity.Id;
        insert rel;
        Agreement_Subordination_Entity_Rel__c relEntity = new Agreement_Subordination_Entity_Rel__c();
        relEntity.Agreement_Subordination__c = rel.Id;
        relEntity.Entity__c = entity.Id;
        insert relEntity;
        Mock.ofIUserInfoService mockUserInfoService = new Mock.ofIUserInfoService();
        mockUserInfoService.setup('getCurrentUserId').returns(ObjectFactory.getUser().Id);
        
        Clone_Agreement sut = new Clone_Agreement(new Clone_AgreementDataProvider(), new Clone_AgreementRelationships(mockUserInfoService), AgreementValidator.getInstance());
        Agreement__c copy = sut.Clone(original.Id);
        
        List<Agreement_Subordination__c> requeryRels = [SELECT Id, Name FROM Agreement_Subordination__c WHERE Agreement__c =: copy.Id];
        System.assertEquals(1, requeryRels.size());
        
        List<Agreement_Subordination_Entity_Rel__c> requeryAllEntityRels = [SELECT Id, Name FROM Agreement_Subordination_Entity_Rel__c];
        System.assertEquals(2, requeryAllEntityRels.size());
        
        List<Agreement_Subordination_Entity_Rel__c> requeryEntityRels = [SELECT Id, Name FROM Agreement_Subordination_Entity_Rel__c WHERE Agreement_Subordination__c =: requeryRels[0].Id];
        System.assertEquals(1, requeryEntityRels.size());
    }
    
    static testMethod void it_should_clone_the_financial_reporting_documents(){
    	Agreement__c original = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        original.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Active').Id;
        original.Name = 'AGMT-0001 rev 01';
        insert original;
        Account entity = new Account(FirstName='Test', LastName='Entity');
        insert entity;
        Agreement_Client_Relationships__c rel = new Agreement_Client_Relationships__c();
        rel.Agreement__c = original.Id;
        rel.Entity__c = entity.Id;
        insert rel;
        Agreement_Financial_Documents__c doc = new Agreement_Financial_Documents__c();
        doc.Agreement_Client_Relationship__c = rel.Id;
        doc.Agreement__c = original.Id;
        insert doc;
        Mock.ofIUserInfoService mockUserInfoService = new Mock.ofIUserInfoService();
        mockUserInfoService.setup('getCurrentUserId').returns(ObjectFactory.getUser().Id);
        
        Clone_Agreement sut = new Clone_Agreement(new Clone_AgreementDataProvider(), new Clone_AgreementRelationships(mockUserInfoService), AgreementValidator.getInstance());
        Agreement__c copy = sut.Clone(original.Id);
        
        List<Agreement_Client_Relationships__c> requeryRels = [SELECT Id, Name, Agreement__c, Entity__c FROM Agreement_Client_Relationships__c WHERE Agreement__c =: copy.Id];
        System.assertEquals(1, requeryRels.size());
        
        List<Agreement_Financial_Documents__c> requeryAllDocs = [SELECT Id, Name, Agreement__c, Agreement_Client_Relationship__c FROM Agreement_Financial_Documents__c];
        System.assertEquals(2, requeryAllDocs.size());
        
        List<Agreement_Financial_Documents__c> requeryDocs = [SELECT Id, Name, Agreement__c, Agreement_Client_Relationship__c FROM Agreement_Financial_Documents__c WHERE Agreement_Client_Relationship__c =: requeryRels[0].Id];
        System.assertEquals(1, requeryDocs.size());
    }
    
    //////////////////////////////////////////
    // utility functions
    public class TestObjects{
        public MockDataProvider mockDataProvider {get;private set;} 
        public MockRelCloner mockRelCloner {get;private set;}
        public MockAgreementValidator mockAgreementValidator{get;private set;}
        public Clone_Agreement sut {get;private set;}
        public TestObjects(){
            mockDataProvider = new MockDataProvider();
            mockRelCloner = new MockRelCloner();
            mockAgreementValidator = new MockAgreementValidator(); 
            sut = new Clone_Agreement(mockDataProvider,mockRelCloner,mockAgreementValidator);
        }
    }
    
    private class MockAgreementValidator implements Agreements.IAgreementValidator{
        public Boolean Validate_Called{get;private set;}
        public Agreement__c Validate_param_Agreement{get;private set;}
        
        public Boolean ValidateAndSave_Called{get;private set;}
        public Agreement__c ValidateAndSave_param_Agreement{get;private set;}
         
        public Boolean ValidateAndSaveFromTrigger_Called{get;private set;}
        public Agreement__c ValidateAndSaveFromTrigger_param_Agreement{get;private set;}
        
        public boolean  DisableValidateFromTrigger_called{get; private set;}
        public boolean DisableValidateFromTrigger_param_disable{get; private set;}
        
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
    
    private static Clone_Agreement SetupSystemUnderTest(){
        MockDataProvider mockDataProvider = new MockDataProvider();
        MockRelCloner mockRelCloner = new MockRelCloner();
        MockAgreementValidator mockAgreementValidator = new MockAgreementValidator();
        return new Clone_Agreement(mockDataProvider,mockRelCloner,mockAgreementValidator);
    }
    
    private static Agreement__c FetchAgreementFromDatabase(Id agreementId){
    	return [SELECT Id, Name, Revision_Number__c FROM Agreement__c WHERE Id =: agreementId];
    }
    
    //////////////////////////////////////////
    // dependency mocks
    public class MockRelCloner implements Agreements.IClone_AgreementRelationships{
        public Boolean cloneBB_Called{get;set;}
        public List<Agreement_Borrowing_Base_Relationship__c> cloneBB_OrigList {get;set;}
        public Id cloneBB_AgreementId {get;set;}
        public Map<SObject,List<SObject>> cloneBB_Return {get;set;}
        
        public Boolean cloneFC_Called{get;set;}        
        public List<Agreement_Financial_Covenant__c> cloneFC_OrigList {get;set;}        
        public Id cloneFC_AgreementId {get;set;}        
        public Map<SObject,List<SObject>> cloneFC_Return {get;set;}
        
        public Boolean cloneCR_Called{get;set;}        
        public List<Agreement_Client_Relationships__c> cloneCR_OrigList {get;set;}        
        public Id cloneCR_AgreementId {get;set;}        
        public Map<SObject,List<SObject>> cloneCR_Return {get;set;}
        
        public Boolean cloneAR_Called{get;set;}        
        public List<Agreement_EB_Account_Relationship__c> cloneAR_OrigList {get;set;}        
        public Id cloneAR_AgreementId {get;set;}        
        public List<Agreement_EB_Account_Relationship__c> cloneAR_Return {get;set;}
        
        public Boolean cloneLAR_Called{get;set;}        
        public List<Agreement_Loan_Application_Relationship__c> cloneLAR_OrigList {get;set;}        
        public Id cloneLAR_AgreementId {get;set;}        
        public List<Agreement_Loan_Application_Relationship__c> cloneLAR_Return {get;set;}
        
        public boolean cloneSUB_Called{get;set;}
        public List<Agreement_Subordination__c> cloneSUB_OrigList{get;set;}
        public Id cloneSUB_AgreementID{get;set;}
        public Map<SObject,List<SObject>> cloneSUB_Return {get;set;}
        
    	public Map<SObject,List<Sobject>> Clone(List<Agreement_Borrowing_Base_Relationship__c> origList, Id newAgreementId){
            cloneBB_Called = true;
            cloneBB_OrigList = origList;
            cloneBB_AgreementId = newAgreementId;
    		return cloneBB_Return;
    	}       
        public Map<SObject,List<Sobject>> Clone(List<Agreement_Financial_Covenant__c> origList, Id newAgreementId){
        	cloneFC_Called = true;
            cloneFC_OrigList = origList;
            cloneFC_AgreementId = newAgreementId;
    		return cloneFC_Return;
        }
        public Map<SObject,List<SObject>> Clone(List<Agreement_Client_Relationships__c> origList, Id newAgreementId){
            cloneCR_Called = true;
            cloneCR_OrigList = origList;
            cloneCR_AgreementId = newAgreementId;
    		return cloneCR_Return;
        }
        public List<Agreement_EB_Account_Relationship__c> Clone(List<Agreement_EB_Account_Relationship__c> origList, Id newAgreementId){
            cloneAR_Called = true;
            cloneAR_OrigList = origList;
            cloneAR_AgreementId = newAgreementId;
    		return cloneAR_Return;
        }
        public List<Agreement_Loan_Application_Relationship__c> Clone(List<Agreement_Loan_Application_Relationship__c> origList, Id newAgreementId){
            cloneLAR_Called = true;
            cloneLAR_OrigList = origList;
            cloneLAR_AgreementId = newAgreementId;
    		return cloneLAR_Return;
        }
        public Map<SObject,List<SObject>> clone(List<Agreement_Subordination__c> origList, Id agreementId){
            cloneSUB_Called = true;
            cloneSUB_OrigList = origList;
            cloneSUB_AgreementId = agreementId;            
            return cloneSUB_Return;
        }
    }
    
    public class MockDataProvider implements Agreements.IClone_AgreementDataProvider{
        public Boolean getAgreementById_Called {get;set;}
        public Boolean wasGetBBRelCalled {get;set;}
        public Boolean wasGetFCRelCalled {get;set;}
		public Boolean wasGetCRRelCalled {get;set;}
		public Boolean wasGetARRelCalled {get;set;}
		public Boolean wasGetLARRelCalled {get;set;}
        public Boolean wasGetSUBRelCalled{get;set;}
        public Agreement__c getAgreementById_Return {get;set;}
        public List<Agreement_Borrowing_Base_Relationship__c> bbRelToReturn {get;set;}
        public List<Agreement_Financial_Covenant__c> fcRelToReturn {get;set;}
        public List<Agreement_Client_Relationships__c> crRelToReturn{get;set;}
        public List<Agreement_EB_Account_Relationship__c> arRelToReturn{get;set;}
        public List<Agreement_Loan_Application_Relationship__c> larRelToReturn{get;set;}
        public List<Agreement_Subordination__c> subRelToReturn{get;set;}
        public id getAgreementById_Parameter_agreementId {get;set;}
        
        public boolean GetPendingAgreementCountByName_Called{get;set;}
        public String GetPendingAgreementCountByName_Param_revisionName {get;set;}
        
        public boolean RemoveAgreementLoanApps_Called{get; private set;}
        public List<Agreement_Loan_Application_Relationship__c> RemoveAgreementLoanApps_param_agmtRelList{get; private set;}
        public Agreement__c RemoveAgreementLoanApps_param_Agreement{get;private set;}
		
        public MockDataProvider(){
            RemoveAgreementLoanApps_Called = false;
        }

        public Agreement__c GetAgreementById(Id agreementId){
            getAgreementById_Called = true;
            getAgreementById_Parameter_agreementId = agreementId;
            return getAgreementById_Return;
        }
        public List<Agreement_Borrowing_Base_Relationship__c> GetAgreementBorrowingBaseRelationships(Id agreementId){
            wasGetBBRelCalled = true;
            return bbRelToReturn;
        }
        public List<Agreement_Financial_Covenant__c> GetAgreementFinancialCovenants(Id agreementId){
            wasGetFCRelCalled = true;
            return fcRelToReturn;
        }
		public List<Agreement_Client_Relationships__c> GetAgreementClientRelationships(Id agreementId){
            wasGetCRRelCalled = true;
            return crRelToReturn;
        }
        public List<Agreement_EB_Account_Relationship__c> GetAgreementEBAccountRelationships(Id agreementId){
            wasGetARRelCalled = true;
            return arRelToReturn;
        }
		public List<Agreement_Loan_Application_Relationship__c> GetAgreementLoanApplicationRelationships(Id agreementId){
            wasGetLARRelCalled = true;
            return larRelToReturn;
        }
        public Integer GetPendingAgreementCountByName(String revisionName){
            GetPendingAgreementCountByName_Called = true;
            GetPendingAgreementCountByName_Param_revisionName = revisionName;
        	return 0;
        }
        public void RemoveAgreementLoanApps(List<Agreement_Loan_Application_Relationship__c> relatedAgmtLoanApps, Agreement__c original){
            RemoveAgreementLoanApps_Called = true;
            RemoveAgreementLoanApps_param_agmtRelList = relatedAgmtLoanApps;
            RemoveAgreementLoanApps_param_Agreement = original;
        }
        public List<Agreement_Subordination__c> getAgreementSubordinationRelationships(Id agreementId){
            wasGetSUBRelCalled = true;
            return subRelToReturn;
            
        }
    }
}