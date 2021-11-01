@isTest
public class AgreementLoanAppLinkDataProviderTests{

    private static testMethod void it_should_save_a_loanApp_to_agreement_relatedlist(){
        TestUtilities.createLoanAppStages();
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '11234');
        Agreement__c testAgreement = new Agreement__c(name='test Agreement');
        insert testAgreement;
        
        AgreementLoanAppLinkDataProvider dataProvider = new AgreementLoanAppLinkDataProvider();
        dataProvider.SaveLoanAppToAgreementRelatedList(newLoanApplication.Id, testAgreement.Id);
        
        system.assert([SELECT Id FROM Agreement_Loan_Application_Relationship__c WHERE Agreement__c =: testAgreement.Id].size() == 1);
    }

    private static testMethod void it_should_delete_a_loanAppLink_from_relatedlist(){
        TestUtilities.createLoanAppStages();
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '11234');
        Agreement__c testAgreement = new Agreement__c(name='test Agreement');
        insert testAgreement;
        
        AgreementLoanAppLinkDataProvider dataProvider = new AgreementLoanAppLinkDataProvider();
        
        dataProvider.SaveLoanAppToAgreementRelatedList(newLoanApplication.Id, testAgreement.Id);
        system.assert([SELECT Id FROM Agreement_Loan_Application_Relationship__c WHERE Agreement__c =: testAgreement.Id].size() == 1);
        
        dataProvider.DeleteLoanAppFromAgreementRelatedList(newLoanApplication.Id, testAgreement.Id);
        system.assert([SELECT Id FROM Agreement_Loan_Application_Relationship__c WHERE Agreement__c =: testAgreement.Id].size() == 0);
    }

    private static testMethod void it_should_delete_ebaccount_from_related_list(){
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        Agreement__c testAgreement = new Agreement__c(name='test Agreement');
        insert testAgreement;
        
        Agreement_EB_Account_Relationship__c ebRel = new Agreement_EB_Account_Relationship__c(Loan_Account__c = newEBAccount.Id,Agreement__c = testAgreement.Id);
        insert ebRel;
        AgreementLoanAppLinkDataProvider dataProvider = new AgreementLoanAppLinkDataProvider();
        dataProvider.DeleteEbAccountFromAgreementRelatedList(newEbAccount.Id,testAgreement.Id);
        
        system.assert([SELECT Id FROM Agreement_EB_Account_Relationship__c WHERE Agreement__c =: testAgreement.Id].size() == 0);
    }

    private static testMethod void it_should_get_a_list_of_agreement_for_ebaccount(){
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        Agreement__c testAgreement = new Agreement__c(name='test Agreement');
        insert testAgreement;
        
        Agreement_EB_Account_Relationship__c ebRel = new Agreement_EB_Account_Relationship__c(Loan_Account__c = newEBAccount.Id,Agreement__c = testAgreement.Id);
        insert ebRel;
        AgreementLoanAppLinkDataProvider dataProvider = new AgreementLoanAppLinkDataProvider();
        dataProvider.GetListOfAgreementForEBAccount(newEBAccount.Id);
        
        system.assert([SELECT Id FROM Agreement_EB_Account_Relationship__c WHERE Loan_Account__c =: newEBAccount.Id].size() ==1);
    }   
}