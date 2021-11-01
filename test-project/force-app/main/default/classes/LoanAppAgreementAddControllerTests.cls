@isTest
private class LoanAppAgreementAddControllerTests{

    static testMethod void it_should_be_able_to_get_a_list_of_agmts_for_loanApp(){
        //assemble
        TestObjects t = new TestObjects();
        
        Eb_Loan_Application__c loanapp = [SELECT id, EB_Loan_Packet__c,EB_Loan_Packet__r.Lead_Entity__c FROM Eb_Loan_Application__c WHERE id =:t.sut.LoanApp.Id];
        
        EB_Loan_App_Entity_Relationship__c testloanAppEntityrel1 = ObjectFactory.getLoanAppEntityRelationship(new Account(id = loanApp.EB_Loan_Packet__r.Lead_Entity__c,Name ='test Entity'),loanapp);
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Name = 'AGMT - 0101';
        testAgreement.Borrower_Name__c = loanapp.EB_Loan_Packet__r.Lead_Entity__c;
        insert testAgreement;
        t.mockAgreementPicker.GetAgreementsForLoanApp_Return = new List<Agreement__c>{testAgreement};
        
        //act
        List<Agreement__c> agreementpickerList = t.sut.AgreementLinkList;
        
        
        //assert
        system.assert(agreementpickerList.get(0).Name.contains('0101'));
    }
    
    static testMethod void it_should_be_able_to_add_an_agreement_to_LoanApp(){
        //assemble
        TestObjects t = new TestObjects();
        
        Eb_Loan_Application__c loanapp = [SELECT id, EB_Loan_Packet__c,EB_Loan_Packet__r.Lead_Entity__c FROM Eb_Loan_Application__c WHERE id =:t.sut.LoanApp.Id];
        
        EB_Loan_App_Entity_Relationship__c testloanAppEntityrel1 = ObjectFactory.getLoanAppEntityRelationship(new Account(id = loanApp.EB_Loan_Packet__r.Lead_Entity__c,Name ='test Entity'),loanapp);
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Name = 'AGMT - 0101';
        testAgreement.Borrower_Name__c = loanapp.EB_Loan_Packet__r.Lead_Entity__c;
        insert testAgreement;
        t.mockAgreementPicker.GetAgreementsForLoanApp_Return = new List<Agreement__c>{testAgreement};
        
        //act
        PageReference pg = t.sut.AddNewAgreement();
        
        //assert
        system.assert(pg.getUrl().contains(loanapp.Id));    
    }
    
    static testMethod void it_should_be_able_to_Save_an_agreement_LoanApp_to_AgmtLoanAppRelationship(){
        //assemble
        TestObjects t = new TestObjects();
        
        Eb_Loan_Application__c loanapp = [SELECT id, EB_Loan_Packet__c,EB_Loan_Packet__r.Lead_Entity__c FROM Eb_Loan_Application__c WHERE id =:t.sut.LoanApp.Id];
        
        EB_Loan_App_Entity_Relationship__c testloanAppEntityrel1 = ObjectFactory.getLoanAppEntityRelationship(new Account(id = loanApp.EB_Loan_Packet__r.Lead_Entity__c,Name ='test Entity'),loanapp);
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Name = 'AGMT - 0101';
        testAgreement.Borrower_Name__c = loanapp.EB_Loan_Packet__r.Lead_Entity__c;
        insert testAgreement;
        t.mockAgreementPicker.GetAgreementsForLoanApp_Return = new List<Agreement__c>{testAgreement};
        
        //act
        PageReference pg = t.sut.SaveExistingAgreement();
        
        //assert
        system.assert(pg.getUrl().contains(loanapp.Id));   
    }
    
    static testMethod void it_should_be_able_to_Cancel_attaching_an_agreement_to_loanApp(){
        //assemble
        TestObjects t = new TestObjects();
        
        Eb_Loan_Application__c loanapp = [SELECT id, EB_Loan_Packet__c,EB_Loan_Packet__r.Lead_Entity__c FROM Eb_Loan_Application__c WHERE id =:t.sut.LoanApp.Id];
        
        EB_Loan_App_Entity_Relationship__c testloanAppEntityrel1 = ObjectFactory.getLoanAppEntityRelationship(new Account(id = loanApp.EB_Loan_Packet__r.Lead_Entity__c,Name ='test Entity'),loanapp);
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Name = 'AGMT - 0101';
        testAgreement.Borrower_Name__c = loanapp.EB_Loan_Packet__r.Lead_Entity__c;
        insert testAgreement;
        t.mockAgreementPicker.GetAgreementsForLoanApp_Return = new List<Agreement__c>{testAgreement};
        
        //act
        PageReference pg = t.sut.CancelAgreement();
       
        //assert
        system.assert(pg.getUrl().contains(loanapp.Id));   
    }
    
    static testMethod void it_should_be_able_to_initialize_through_controller_constructor(){
        //assemble
        TestObjects t = new TestObjects();        
        Eb_Loan_Application__c loanapp = [SELECT id, EB_Loan_Packet__c,EB_Loan_Packet__r.Lead_Entity__c FROM Eb_Loan_Application__c WHERE id =:t.sut.LoanApp.Id];
        
        //act
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(loanapp);
        LoanAppAgreementAddController controller = new LoanAppAgreementAddController(sc);

        //assert
        system.assert(controller.loanapp == null);
    }
    
     public class TestObjects{
        public MockAgreementPicker mockAgreementPicker {get;private set;} 
        public LoanAppAgreementAddController sut {get;private set;}
        
        public TestObjects(){
               TestUtilities.createLoanAppStages();
               Account newEntity = ObjectFactory.getValidEntity('test entity');
        	   Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', newEntity);      
        	   EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
               EB_Loan_Application__c loanapp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
               system.debug('## TestObject 1 : ' + loanapp.Id);
               mockAgreementPicker = new MockAgreementPicker();
               system.debug('## TestObject : 2 ' + loanapp.Id);
               mockAgreementPicker.GetLoanObjectForLoanAppId_Return = new List<EB_Loan_Application__c>{loanapp};
               sut = new LoanAppAgreementAddController(loanapp.Id , mockAgreementPicker);
               system.debug('## TestObject 3 : ' + loanapp.Id);
        }
        
    }
     public class MockAgreementPicker implements Agreements.IAgreementPicker{
       
         public Boolean GetAgreements_Called {get;private set;}
         public Account GetAgreements_param_entity {get;private set;}
         public List<Agreement__c> GetAgreements_Return{get;private set;}
         
         public Boolean GetLoanObjectForLoanAppId_Called {get;private set;}
         public Id GetLoanObjectForLoanAppId_param_LoanAppId {get;private set;}
         public List<EB_Loan_Application__c> GetLoanObjectForLoanAppId_Return{get;private set;}
         
         public Boolean SaveAgreementLoanRel_Called{get;private set;}
         public Id SaveAgreementLoanRel_param_AgreementId{get;private set;}
         public Id SaveAgreementLoanRel_param_LoanAppId{get;private set;}

         public Boolean SaveAgreementLlcBiLoanRel_Called{get;private set;}
         public Id SaveAgreementLlcBiLoanRel_param_AgreementId{get;private set;}
         public Id SaveAgreementLlcBiLoanRel_param_LlcBiLoanId{get;private set;}

         public Boolean ReLinkLoanAppsOnModifiedAgreement_Called{get; private set;}
         public Id ReLinkLoanAppsOnModifiedAgreement_param_agreementId{get; private set;}
         public Agreement__c ReLinkLoanAppsOnModifiedAgreement_Return{get; private set;}
         
         public Boolean GetAgreementsForLoanApp_Called{get;private set;}
         public Id GetAgreementsForLoanApp_param_LoanappId{get; private set;}
         public List<Agreement__c> GetAgreementsForLoanApp_Return{get;private set;}
                  
         public List<Agreement__c> GetAgreements(Account entity){
             GetAgreements_Called = true;
             GetAgreements_param_entity = entity;
             return GetAgreements_Return;
         }         
         public List<EB_Loan_Application__c> GetLoanObjectForLoanAppId(Id LoanAppId){
             GetLoanObjectForLoanAppId_Called = true;
             GetLoanObjectForLoanAppId_param_LoanAppId = LoanAppId;
             return GetLoanObjectForLoanAppId_Return;            
         }         
         public void SaveAgreementLoanRel(Id AgreementId, Id LoanAppId){
             SaveAgreementLoanRel_Called = true;
             SaveAgreementLoanRel_param_AgreementId = AgreementId;
             SaveAgreementLoanRel_param_LoanAppId = LoanAppId;            
         }
         public void SaveAgreementLlcBiLoanRel(Id AgreementId, Id LlcBiLoanId){
             SaveAgreementLlcBiLoanRel_Called = true;
             SaveAgreementLlcBiLoanRel_param_AgreementId = AgreementId;
             SaveAgreementLlcBiLoanRel_param_LlcBiLoanId = LlcBiLoanId;            
         }
         public Agreement__c ReLinkLoanAppsOnModifiedAgreement(Id AgreementId){
             ReLinkLoanAppsOnModifiedAgreement_Called = true;
             ReLinkLoanAppsOnModifiedAgreement_param_agreementId = AgreementId;
             return ReLinkLoanAppsOnModifiedAgreement_Return;
         }
         public List<Agreement__c> GetAgreementsForLoanApp(Id LoanAppId){
             GetAgreementsForLoanApp_Called = true;
             GetAgreementsForLoanApp_param_LoanappId = LoanAppId;
             return GetAgreementsForLoanApp_Return;
         }
     }
}