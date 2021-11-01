@isTest
private class AgreementPickerDataProviderTests{

    private final static AgreementPickerDataProvider sut;

    static{
        sut = new AgreementPickerDataProvider();
    }

    private static testMethod void it_should_get_a_list_of_agreemnt_From_agmtId(){
        Agreement__c testAgreement = new Agreement__c(name='test Agreement');
        insert testAgreement;
        
        AgreementPickerDataProvider dataProvider = new AgreementPickerDataProvider();
        Agreement__c agreement = dataProvider.GetAgreementFromId(testAgreement.Id);
        system.assert(agreement.Id == testAgreement.Id);
    }
    
    private static testMethod void it_should_get_loanAppObj_for_Id(){
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
        
        AgreementPickerDataProvider dataProvider = new AgreementPickerDataProvider();
        List<Eb_Loan_Application__c> loanList = dataProvider.GetLoanApplicationObjectForLoanAppId(newLoanApplication.Id);
        
        system.assert(loanList.size() == 1);
    }
    
    private static testMethod void it_should_save_agreement_loan_app_rel(){
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
        
        AgreementPickerDataProvider dataProvider = new AgreementPickerDataProvider();
        dataProvider.SaveAgreementLoanAppRel(testAgreement.Id, newLoanApplication.Id);
        
        system.assert([SELECT Id FROM Agreement_Loan_Application_Relationship__c WHERE Agreement__c =: testAgreement.Id].size() == 1);
    }

    private static testMethod void it_should_save_agreement_llc_loan_rel(){
        String loanName = 'TestName';
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Name = loanName;
        loan.LLC_BI__Amount__c = 123.45;
        insert loan;
        Agreement__c testAgreement = new Agreement__c(name='test Agreement');
        insert testAgreement;
        
        sut.SaveAgreementLlcBiLoanRel(testAgreement.Id, loan.Id);
        
        List<Agreement_LLC_BI_Loan_Relationship__c> requeryRels = [SELECT Id, LLCBI_Loan__r.Name FROM Agreement_LLC_BI_Loan_Relationship__c WHERE Agreement__c =: testAgreement.Id];
        System.assertEquals(1, requeryRels.size());
        System.assertEquals(loanName, requeryRels[0].LLCBI_Loan__r.Name);
     }
     
    private static testMethod void it_should_be_able_to_get_agreements_for_loanAppId(){
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
         EB_Loan_App_Entity_Relationship__c loanAppEntityRels = new EB_Loan_App_Entity_Relationship__c(Loan_Application_ID__c = newLoanApplication.Id,Entity_Name__c = newEntity.Id,Relationship_Type__c = 'Primary Borrower');
         insert loanAppEntityRels;
         Agreement_Client_Relationships__c agmtEntityRel = new Agreement_Client_Relationships__c(Agreement__c = testAgreement.Id,Entity__c = newEntity.Id);
         insert agmtEntityRel;
         Agreement_Loan_Application_Relationship__c agmtLoanAppRel = new Agreement_Loan_Application_Relationship__c(Loan_Application__c = newLoanApplication.Id,Agreement__c = testAgreement.Id);
         insert agmtLoanAppRel;
         
         AgreementPickerDataProvider dataProvider = new AgreementPickerDataProvider();         
         Boolean foundTestAgreement = false;         
         for(Agreement__c agmt : dataprovider.GetAgreementsForLoanApp(newLoanApplication.Id)){
             if(agmt.Id == testAgreement.Id) {
                 foundTestAgreement = true;
                 break;
             }             
         } 
         
         //system.assert(foundTestAgreement == true);  
     }
     
     private static testMethod void it_should_exclude_agreements_already_tied_to_the_loan_app_from_the_agreements_for_loan_app(){
        TestUtilities.createLoanAppStages();
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account'); 
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        EB_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '11234');
        EB_Loan_App_Entity_Relationship__c loanAppEntityRels = new EB_Loan_App_Entity_Relationship__c(Loan_Application_ID__c = newLoanApplication.Id,Entity_Name__c = newEntity.Id,Relationship_Type__c = 'Primary Borrower');
        insert loanAppEntityRels;
        Agreement__c testAgmt1 = new Agreement__c();
        insert testAgmt1;
        Agreement__c testAgmt2 = new Agreement__c();
        insert testAgmt2;
        Agreement_Client_Relationships__c agmtEntityRel = new Agreement_Client_Relationships__c(Agreement__c = testAgmt1.Id, Entity__c = newEntity.Id);
        insert agmtEntityRel;
        Agreement_Client_Relationships__c agmtEntityRel2 = new Agreement_Client_Relationships__c(Agreement__c = testAgmt2.Id, Entity__c = newEntity.Id);
        insert agmtEntityRel2;
        Agreement_Loan_Application_Relationship__c agmtLoanAppRel = new Agreement_Loan_Application_Relationship__c(Loan_Application__c = newLoanApplication.Id,Agreement__c = testAgmt1.Id);
        insert agmtLoanAppRel;
        
        AgreementPickerDataProvider dataProvider = new AgreementPickerDataProvider();         
        Boolean isAlreadyAttachedAgreementInList = false;         
        for(Agreement__c agmt : dataprovider.GetAgreementsForLoanApp(newLoanApplication.Id)){
            if(agmt.Id == testAgmt1.Id) {
                isAlreadyAttachedAgreementInList = true;
                break;
            }             
        }
        
        System.assertEquals(false,isAlreadyAttachedAgreementInList);
    }

}