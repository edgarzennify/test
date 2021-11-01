@IsTest
public class AgreementSummaryUpdaterTests{
    static testMethod void it_should_test_all_static_calls(){
        TestUtilities.CreateLoanAppStages();
        AgreementSummaryUpdater.setAlreadyRan();
        AgreementSummaryUpdater.alreadyran = true;
        AgreementSummaryUpdater.setAlreadyRan();
        Agreement__c testAgreement = new Agreement__c(name='test');
        insert testAgreement;
        Account entity = (Account)ObjectFactory.getValidEntity('bogus');
        Eb_Loan_Application__c loanApp =  ObjectFactory.getLoanApplication('Test Entity' , 'Test Account', '1234' ,'Test Loan App');     
        Agreement_Loan_Application_Relationship__c loanAppRel = new Agreement_Loan_Application_Relationship__c();
        loanAppRel.Agreement__c = testAgreement.Id;
        loanAppRel.Loan_Application__c = loanApp.Id;
        insert loanAppRel;
        Agreement_Client_Relationships__c original = new Agreement_Client_Relationships__c(); 
        original.Agreement__c = testAgreement.Id;
        original.Entity__c = entity.Id;
        original.Entity__r = entity;
        insert original;
        Id apAgingsTypeId = utility.RecordTypeObject('Agreement_Financial_Documents__c', 'A/P Detailed Agings').Id;
        Agreement_Financial_Documents__c payablesAgings = new Agreement_Financial_Documents__c();
        payablesAgings.RecordTypeId = apAgingsTypeId;
        payablesAgings.Agreement_Client_Relationship__c = original.Id;
        payablesAgings.Agreement_Client_Relationship__r = original;
        payablesAgings.Frequency__c = 'A';
        payablesAgings.Period_Due__c = 'B';
        insert payablesAgings;        
        
        AgreementSummaryUpdater.updateSummaries(testAgreement.Id);
        AgreementSummaryUpdater.updateSummaries(new List<Agreement__c>{testAgreement});
        AgreementSummaryUpdater.updateSummaries(new List<Id>{testAgreement.Id});
    }
    
    static testMethod void it_should_sort_the_borrowers_by_relationship_type_then_order_entered(){
        TestUtilities.CreateLoanAppStages();
        Agreement__c testAgreement = new Agreement__c(name='test');
        insert testAgreement;
        Account e1 = new Account(Name='e1');
        Account e2 = new Account(Name='e2');
        Account e3 = new Account(Name='e3');
        Account e4 = new Account(Name='e4');
        Account e5 = new Account(Name='e5');
        List<Account> entities = new List<Account>{e1,e2,e3,e4,e5};
        insert entities;
        Agreement_Client_Relationships__c relE1 = new Agreement_Client_Relationships__c(Agreement__c = testAgreement.Id, Entity__c = e1.Id, Relationship__c='Primary Borrower');
        insert relE1;
        Agreement_Client_Relationships__c relE2 = new Agreement_Client_Relationships__c(Agreement__c = testAgreement.Id, Entity__c = e2.Id, Relationship__c='Guarantor');
        insert relE2;
        Agreement_Client_Relationships__c relE3 = new Agreement_Client_Relationships__c(Agreement__c = testAgreement.Id, Entity__c = e3.Id, Relationship__c='Guarantor');
        insert relE3;        
        Agreement_Client_Relationships__c relE5 = new Agreement_Client_Relationships__c(Agreement__c = testAgreement.Id, Entity__c = e5.Id, Relationship__c='Co-Borrower');
        insert relE5;
        Agreement_Client_Relationships__c relE4 = new Agreement_Client_Relationships__c(Agreement__c = testAgreement.Id, Entity__c = e4.Id, Relationship__c='Co-Borrower');
        insert relE4;
        
        AgreementSummaryUpdater.updateSummaries(testAgreement.Id);
        
        Agreement__c requery = [SELECT Id, Name, Borrower_Summary__c FROM Agreement__c WHERE Id =: testAgreement.Id];
        System.assertEquals('e1 (Primary Borrower)\ne5 (Co-Borrower)\ne4 (Co-Borrower)\ne2 (Guarantor)\ne3 (Guarantor)',requery.Borrower_Summary__c);
    }

}