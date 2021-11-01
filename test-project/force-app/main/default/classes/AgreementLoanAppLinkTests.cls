@isTest
private class AgreementLoanAppLinkTests{
    static testMethod void it_should_be_able_to_add_LoanApp_to_an_agmt_on_renewal(){
        //assemble
        TestObjects t = new TestObjects(); 
        
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '11234');
        
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
                
        //act
        t.sut.ConnectLoanAppToAgreement(newLoanApplication.Id,testAgreement.Id);
        
        //assert
        system.assertEquals(true,t.mockDataProvider.SaveLoanAppToAgreementRelatedList_Called);      
    }
    
    static testMethod void it_should_be_able_to_remove_loanApp_from_agmt_relatedList(){
        
        //assemble
        TestObjects t = new TestObjects();
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '11234');
        
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        
        //act
        t.sut.RemoveLoanAppFromAgreement(newLoanApplication.Id, testAgreement.Id);
        
        //assert
        system.assertEquals(true,t.mockDataProvider.DeleteLoanAppFromAgreementRelatedList_Called);
    }
    
    static testMethod void it_should_be_able_to_get_all_agreements_for_an_ebaccount_and_remove_ebaccount_from_agmt_RelatedList(){
        TestObjects t = new TestObjects();
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '11234');
        
        Agreement__c testAgreement1 = new Agreement__c();
        insert testAgreement1;
        Agreement__c testAgreement2 = new Agreement__c();
        insert testAgreement2;
        
        Agreement_EB_Account_Relationship__c testebaccounttRel1 = new Agreement_EB_Account_Relationship__c(Agreement__c = testAgreement1.Id,Loan_Account__c = newEBAccount.Id);
        Agreement_EB_Account_Relationship__c testebaccounttRel2 = new Agreement_EB_Account_Relationship__c(Agreement__c = testAgreement2.Id,Loan_Account__c = newEBAccount.Id);
        //insert testebaccounttRel1;
        //insert testebaccounttRel2;
        t.mockDataProvider.GetListOfAgreementForEBAccount_Return = new List<Agreement__c>{testAgreement1,testAgreement2};
        
        //act
        for(Agreement__c agmt : t.sut.GetActiveAgreementsForEbAccount(newEBAccount.Id)){
                t.sut.RemoveEbAccountFromAgreement(newEBAccount.Id,agmt.Id);
        }
        
        //assert
        system.assertEquals(true,t.mockDataProvider.GetListOfAgreementForEBAccount_Called && t.mockDataProvider.DeleteEbAccountFromAgreementRelatedList_Called);
    }
    
    public class TestObjects{
        public MockDataProvider mockDataProvider {get;private set;} 
        public AgreementLoanAppLink sut {get;private set;}
        public TestObjects(){
               mockDataProvider = new MockDataProvider();
               sut = new AgreementLoanAppLink(mockDataProvider);
        }
    }
    
    public class MockDataProvider implements Agreements.IAgreementLoanAppLinkDataProvider{
        
        public Boolean SaveLoanAppToAgreementRelatedList_Called {get;private set;}
        public Id SaveLoanAppToAgreementRelatedList_param_loanappid {get; private set;}
        public Id SaveLoanAppToAgreementRelatedList_param_agmtId {get; private set;}
        
        public Boolean DeleteLoanAppFromAgreementRelatedList_Called {get;private set;}
        public Id DeleteLoanAppFromAgreementRelatedList_param_loanappid {get; private set;}
        public Id DeleteLoanAppFromAgreementRelatedList_param_agmtId {get; private set;}
        
        public Boolean DeleteEbAccountFromAgreementRelatedList_Called {get;private set;}
        public Id DeleteEbAccountFromAgreementRelatedList_param_ebaccountid {get; private set;}
        public Id DeleteEbAccountFromAgreementRelatedList_param_agmtId {get; private set;}
        
        public Boolean GetListOfAgreementForEBAccount_Called {get; private set;}
        public Id GetListOfAgreementForEBAccount_param_ebaccountId {get; private set;}
        public List<Agreement__c> GetListOfAgreementForEBAccount_Return {get; private set;}

        public void SaveLoanAppToAgreementRelatedList(Id loanAppId,Id agmtId ){
             SaveLoanAppToAgreementRelatedList_Called = true;
             SaveLoanAppToAgreementRelatedList_param_loanappid = loanAppId;
             SaveLoanAppToAgreementRelatedList_param_agmtId = agmtId;            
        }
        public void DeleteLoanAppFromAgreementRelatedList(Id loanAppId,Id agmtId){            
             DeleteLoanAppFromAgreementRelatedList_Called = true;
             DeleteLoanAppFromAgreementRelatedList_param_loanappid = loanAppId;
             DeleteLoanAppFromAgreementRelatedList_param_agmtId = agmtId;
        }
        public void DeleteEbAccountFromAgreementRelatedList(Id ebAccountId,Id agmtId){
             DeleteEbAccountFromAgreementRelatedList_Called = true;
             DeleteEbAccountFromAgreementRelatedList_param_ebaccountid = ebAccountId;
             DeleteEbAccountFromAgreementRelatedList_param_agmtId = agmtId;
            
        }
        public List<Agreement__c> GetListOfAgreementForEBAccount(Id ebaccountId){
            GetListOfAgreementForEBAccount_Called = true;
            GetListOfAgreementForEBAccount_param_ebaccountId = ebaccountId;
            return GetListOfAgreementForEBAccount_Return;
        }  
    }
}