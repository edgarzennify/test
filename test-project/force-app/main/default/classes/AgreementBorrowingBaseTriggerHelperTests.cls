@IsTest
private class AgreementBorrowingBaseTriggerHelperTests{
    static  testMethod void it_should_insert_the_agreement_with_warning(){
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Name = 'test agreement';
        insert testAgreement;
        
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        Agreement_Client_Relationships__c testAgreement2Entity = new Agreement_Client_Relationships__c();
        testAgreement2Entity.Agreement__c = testAgreement.Id;
        testAgreement2Entity.Entity__c = testEntity.Id;
        testAgreement2Entity.Borrowing_Base_Certificate__c = 'Yes';
        testAgreement2Entity.Borrowing_Base_Certificate_Period_Due__c = 'Month';
        testAgreement2Entity.Borrowing_Base_Frequency__c = '90';
        //testAgreement2Entity.Borrowing_Base_Certificate_Period_Other__c = '60';
        
        Agreement_Borrowing_Base_Relationship__c bbRelation = new Agreement_Borrowing_Base_Relationship__c(Agreement__c = testAgreement.Id);
        insert bbRelation;
        
        
        System.assertEquals(true,testAgreement.ErrorMessages__c != '');
        
    }

}