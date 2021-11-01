@isTest
private class AgreementPickerTests{
    
    static testMethod void it_should_return_a_LoanObject_for_a_given_LoanAppId(){
        //assemble
        TestObjects t = new TestObjects();
       
        Account newEntity = ObjectFactory.getValidEntity('test entity');
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        system.debug('### Packet' + newPacket.Id);
        EB_Loan_Application__c loanapp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        system.debug('#### loanApp ' + loanapp.Id);
        system.debug('#### loanApp Name  ' + loanapp.Account_Number_Assigned__c);
        
        
        t.mockdataprovider.GetLoanApplicationObjectForLoanAppId_Return = new List<EB_Loan_Application__c>{loanApp};
        
        //act
        t.sut.GetLoanObjectForLoanAppId(loanapp.Id);
        
        //assert
        system.assertEquals('123445',t.sut.GetLoanObjectForLoanAppId(loanapp.Id)[0].Account_Number_Assigned__c);  
    }
    
    static testMethod void it_should_not_call_SaveAgreement_on_dataprovider_if_recordtype_is_null(){
        //assemble
        TestObjects t = new TestObjects();
        
        Agreement__c testAgreement = new Agreement__c();
        
        insert testAgreement;
        Account newEntity = ObjectFactory.getValidEntity('test entity');
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c loanapp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        
        //act
        t.mockDataProvider.GetAgreementFromId_Return = testAgreement;
        t.sut.SaveAgreementLoanRel(testAgreement.Id, loanapp.Id);
        
        //assert       
        system.assertEquals(false , t.mockdataprovider.SaveAgreementLoanAppRel_Called  );        
    }
    
    static testMethod void it_should_call_SaveAgreement_on_dataprovider_if_recordtype_is_Active(){
        //assemble
        TestObjects t = new TestObjects();
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.RecordTypeObject('Agreement__c', 'Active').Id;
        testAgreement.Name = 'AGMT - 01010';
        insert testAgreement;
        testAgreement = [SELECT Id, Name , RecordTypeId, RecordTypeDescription__c FROM Agreement__c WHERE Id =: testAgreement.Id];
        Account newEntity = ObjectFactory.getValidEntity('test entity');
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c loanapp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        
        //act
        t.mockDataProvider.GetAgreementFromId_Return = testAgreement;
        t.sut.SaveAgreementLoanRel(testAgreement.Id, loanapp.Id);
        
        //assert       
        system.assertEquals(true , t.mockdataprovider.SaveAgreementLoanAppRel_Called  );        
    }
    
    static testMethod void it_should_call_SaveAgreementLoanAppRel_on_dataprovider_if_recordtype_is_Pending(){
        //assemble
        TestObjects t = new TestObjects();
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.Name = 'AGMT - 01010';
        insert testAgreement;
        testAgreement = [SELECT Id, Name , RecordTypeId, RecordTypeDescription__c FROM Agreement__c WHERE Id =: testAgreement.Id];
        Account newEntity = ObjectFactory.getValidEntity('test entity');
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c loanapp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        
        //act
        t.mockDataProvider.GetAgreementFromId_Return = testAgreement;
        t.sut.SaveAgreementLoanRel(testAgreement.Id, loanapp.Id);
        
        //assert       
        system.assertEquals(true , t.mockdataprovider.SaveAgreementLoanAppRel_Called  );        
    }

    static testMethod void it_should_call_SaveAgreementLlcBiLoanRel_on_dataprovider_if_recordtype_is_Pending(){
        TestObjects t = new TestObjects();
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.Name = 'AGMT - 01010';
        insert testAgreement;
        testAgreement = [SELECT Id, Name , RecordTypeId, RecordTypeDescription__c FROM Agreement__c WHERE Id =: testAgreement.Id];
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        insert loan;

        t.mockDataProvider.GetAgreementFromId_Return = testAgreement;
        t.sut.saveAgreementLlcBiLoanRel(testAgreement.Id, loan.Id);
        
        system.assertEquals(true, t.mockdataprovider.SaveAgreementLlcBiLoanRel_Called);        
    }
    
    static testMethod void it_should_get_a_list_of_agreements_for_a_loanApp(){
        //assemble
        TestUtilities.createLoanAppStages();
        TestObjects t = new TestObjects();
                
        Account newEntity = ObjectFactory.getValidEntity('test entity');
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c loanapp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        
        EB_Loan_App_Entity_Relationship__c testloanAppEntityrel1 = ObjectFactory.getLoanAppEntityRelationship(newEntity,loanapp);
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Name = 'AGMT - 0101';
        testAgreement.Borrower_Name__c = newEntity.Id;
        insert testAgreement;
        t.mockDataProvider.GetAgreementsForLoanApp_Return = new List<Agreement__c>{testAgreement};
        
        //act
        List<Agreement__c> agreementpickerList = t.sut.GetAgreementsForLoanApp(loanapp.Id);
        
        
        //assert
        system.assert(agreementpickerList.get(0).Name.contains('0101'));
    }
    
    static testMethod void org_should_have_some_LoanAppStage(){    
    	TestUtilities.createLoanAppStages();   
        system.assertEquals(true,[SELECT Id FROM EB_Loan_App_stage__c].size()> 0);
    }
    
    static testMethod void test_bruteForce(){
        AgreementPicker apicker = new AgreementPicker();
    }
    
    //////////////////////////////////////////
    // utility functions
    public class TestObjects{
        public MockDataProvider mockDataProvider {get;private set;} 
        public AgreementPicker sut {get;private set;}
        public TestObjects(){
            mockDataProvider = new MockDataProvider();
            sut = new AgreementPicker(mockDataProvider);
        }
    }
    
    //////////////////////////////////////////
    // dependency mocks
    private class MockDataProvider implements  Agreements.IAgreementPickerDataProvider{

        public Boolean GetLoanApplicationObjectForLoanAppId_Called{get;private set;}
        public Id GetLoanApplicationObjectForLoanAppId_Param_agreementId{get;private set;}
        public List<EB_Loan_Application__c> GetLoanApplicationObjectForLoanAppId_Return{get;private set;} 
        
        public Boolean SaveAgreementLoanAppRel_Called{get; private set;}
        public Id SaveAgreementLoanAppRel_Param_AgreementId{get; private set;}
        public Id SaveAgreementLoanAppRel_Param_LoanAppId{get; private set;}

        public Boolean SaveAgreementLlcBiLoanRel_Called{get; private set;}
        public Id SaveAgreementLlcBiLoanRel_Param_AgreementId{get; private set;}
        public Id SaveAgreementLlcBiLoanRel_Param_LlcBiLoanId{get; private set;}
        
        public Boolean GetAgreementsForLoanApp_Called{get; private set;}
        public Id GetAgreementsForLoanApp_param_loanAppId{get; private set;}
        public List<Agreement__c> GetAgreementsForLoanApp_Return{get; private set;}
        
        public Boolean GetAgreementFromId_Called{get;private set;}
        public Id GetAgreementFromId_param_AgreementId{get;private set;}
        public Agreement__c GetAgreementFromId_Return{get;private set;}
        
        public MockDataProvider(){
            SaveAgreementLoanAppRel_Called = false;
            SaveAgreementLlcBiLoanRel_Called = false;
        }        
        public Agreement__c GetAgreementFromId(Id AgreementId){
            GetAgreementFromId_Called = true;
            GetAgreementFromId_param_AgreementId = AgreementId;
            return GetAgreementFromId_Return;
        }        
        public List<Eb_Loan_Application__c> GetLoanApplicationObjectForLoanAppId(Id LoanAppId){
            GetLoanApplicationObjectForLoanAppId_Called = true;
            GetLoanApplicationObjectForLoanAppId_Param_agreementId = LoanAppId;
            return GetLoanApplicationObjectForLoanAppId_Return;
        }
        public void SaveAgreementLoanAppRel(Id AgreementId, Id LoanAppId){
             SaveAgreementLoanAppRel_Called = true;
             SaveAgreementLoanAppRel_Param_AgreementId = AgreementId;
             SaveAgreementLoanAppRel_Param_LoanAppId = LoanAppId;
        }
        public void SaveAgreementLlcBiLoanRel(Id AgreementId, Id LlcBiLoanId){
             SaveAgreementLlcBiLoanRel_Called = true;
             SaveAgreementLlcBiLoanRel_Param_AgreementId = AgreementId;
             SaveAgreementLlcBiLoanRel_Param_LlcBiLoanId = LlcBiLoanId;
        }
        public List<Agreement__c> GetAgreementsForLoanApp(Id LoanAppId){
            GetAgreementsForLoanApp_Called = true;
            GetAgreementsForLoanApp_param_loanAppId = LoanAppId;
            return GetAgreementsForLoanApp_Return;            
        }        
    }
}