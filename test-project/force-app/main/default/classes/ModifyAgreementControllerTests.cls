@isTest
public class ModifyAgreementControllerTests{
    
    private static testMethod void it_should_not_clone_the_agreement_when_there_is_already_a_pending_revision_of_this_agreement(){
        //Assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        t.mockAgreementCloner.GetAgreementById_Return = testAgreement;
        t.mockAgreementCloner.CloneAndRemoveLoanApps_Return = testAgreement;
        t.mockAgreementCloner.GetPendingAgreementCount_Return = 1;
                
        //Act
        t.sut.ModifyCurrentAgreement();
        
        //Assert
        System.assertEquals(false, t.mockAgreementCloner.CloneAndRemoveLoanApps_Called);
    }
    
    private static testMethod void it_should_clone_the_agreement_when_there_is_no_pending_revision_of_this_agreement(){
        //Assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        t.mockAgreementCloner.GetAgreementById_Return = testAgreement;
        t.mockAgreementCloner.GetPendingAgreementCount_Return = 0;
        t.mockAgreementCloner.CloneAndRemoveLoanApps_Return = testAgreement;
                
        //Act
        t.sut.ModifyCurrentAgreement();
        
        //Assert
        System.assertEquals(true, t.mockAgreementCloner.CloneAndRemoveLoanApps_Called);
    }
    
    private static testMethod void it_should_get_code_coverage_for_the_default_constructor(){
        Agreement__c agreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        insert agreement;
        ApexPages.StandardController c = new ApexPages.StandardController(agreement);
        ModifyAgreementController sut = new ModifyAgreementController(c);
    }
    
    private static testMethod void it_should_clone_an_agreement(){
    	Agreement__c testAgreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
    	insert testAgreement;
    	
    	integer entitiesToCreate = 100;
    	List<Account> entities = new List<Account>();
    	for(integer i = 0; i < entitiesToCreate; i++){
    		Account a = new Account(Name='testEntity'+i);
    		entities.add(a);		
    	}
    	insert entities;

    	List<Agreement_Client_Relationships__c> rels = new List<Agreement_Client_Relationships__c>();
    	for(Account a : entities){
    		Agreement_Client_Relationships__c newRel = new Agreement_Client_Relationships__c();
    		newRel.Agreement__c = testAgreement.Id;
    		newRel.entity__c = a.Id;
    		rels.add(newRel);
    	}
    	insert rels;
    	
    	test.startTest();
    	system.debug('%%%% STARTTEST');
    	//utility.debug_log(testAgreement);
    	PageReference pr = Page.ModifyAgreementView;
    	test.setCurrentPage(pr);    	
    	ApexPages.StandardController c = new ApexPages.StandardController(testAgreement);
        ModifyAgreementController sut = new ModifyAgreementController(c);
        sut.ModifyCurrentAgreement();    	
    	test.stopTest();  
    	
    	//no assert needed, just making sure the thing doesn't crash 	
    }
    
    //////////////////////////////////////////
    // utility functions
    public class TestObjects{
        public MockAgreementCloner mockAgreementCloner {get;private set;} 
        public ModifyAgreementController sut {get;private set;}
        public Agreement__c originalAgreement {get;private set;}
        public TestObjects(){
            mockAgreementCloner = new MockAgreementCloner();
            originalAgreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
            originalAgreement.Name = 'OriginalAgreement';
        	insert originalAgreement;
            
            sut = new ModifyAgreementController(originalAgreement,mockAgreementCloner);                    
        }
    }
    
    //////////////////////////////////////////
    // dependency mocks
    public class MockAgreementCloner implements Agreements.IClone_Agreement{
        public Boolean clone_Called {get;private set;}
        public Id clone_Parameter_origId {get;set;}
        public Agreement__c clone_Return {get;set;}
        
        public Boolean GetPendingAgreementCount_Called {get;private set;}
        public Integer GetPendingAgreementCount_Return {get;set;}
        
        public Boolean CloneAndRemoveLoanApps_Called {get;private set;}
        public Id CloneAndRemoveLoanApps_param_agreementId {get;private set;}
        public Agreement__c CloneAndRemoveLoanApps_Return {get; private set;}
        
        public Boolean GetAgreementById_Called{get;private set;}
        public Id GetAgreementById_param_agreementId {get;private set;}
        public Agreement__c GetAgreementById_Return {get;private set;}
        
        public MockAgreementCloner(){
            clone_Called = false;
            GetPendingAgreementCount_Called = false;
            CloneAndRemoveLoanApps_Called = false;
        }        
        public Agreement__c Clone(Id origId){
            clone_Called = true;
            clone_Parameter_origId = origId;
            return clone_Return;
        }
        public Integer GetPendingAgreementCount(Agreement__c orig){
            GetPendingAgreementCount_Called = true;
            return GetPendingAgreementCount_Return;
        }
        public Agreement__c GetAgreementById(Id agmtId){
        	GetAgreementById_Called = true;
            GetAgreementById_param_agreementId = agmtId;          
            return GetAgreementById_Return;
        }
        public Agreement__c CloneAndRemoveLoanApps(id origId){
            CloneAndRemoveLoanApps_Called = true;
            CloneAndRemoveLoanApps_param_agreementId = origId;
            return CloneAndRemoveLoanApps_Return;
        }
    }
}