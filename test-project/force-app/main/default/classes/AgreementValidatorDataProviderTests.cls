@IsTest
private class AgreementValidatorDataProviderTests {
    @IsTest
    static void it_should_be_able_to_update_an_agreement() {
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        testAgreement.Name = 'test Agreement';
        
        AgreementValidatorDataProvider dataProvider = new AgreementValidatorDataProvider();
        dataProvider.SaveAgreement(testAgreement);
        
        system.assertEquals('test Agreement', testAgreement.Name);
    }
    
    @IsTest
    static void it_should_be_able_to_get_entities_tied_to_ARbb() {
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;        
        Agreement_Borrowing_Base_Relationship__c bbRel = new Agreement_Borrowing_Base_Relationship__c(Agreement__c = testAgreement.Id,component__c = 'A/R < 30 Days');
        insert bbRel;
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Agreement_Borrowing_Base_Entity_Rel__c bbEntityRel = new Agreement_Borrowing_Base_Entity_Rel__c(Agreement_Related_Borrowing_Base__c = bbRel.Id,Entity__c = newEntity.Id);
        insert bbEntityRel;
        
        AgreementValidatorDataProvider dataProvider = new AgreementValidatorDataProvider();
        List<Account> entities = dataProvider.getEntitiesTiedToARBorrowingBaseComponent(testAgreement.Id);
        
        System.assertEquals(1, entities.size());
    }
    
    @IsTest
    static void it_should_get_list_of_reportingRequirements_for_entity_list() {
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        List<Account> entityList = new List<Account>{newEntity};
        Agreement_Client_Relationships__c agmtEntityRel = new Agreement_Client_Relationships__c(Agreement__c = testAgreement.Id,Entity__c = newEntity.Id);
        insert agmtEntityRel;
        
        AgreementValidatorDataProvider dataProvider = new AgreementValidatorDataProvider();
        List<Agreement_Client_Relationships__c> agmtEntityList = dataProvider.getReportingRequirementsForEntityList(entityList,testAgreement.Id);
   
        System.assertEquals(1, agmtEntityList.size());        
    }
    
    @IsTest
    static void it_should_agreementEntityRel_for_agreementId() {
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account testEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);   
        Agreement_Client_Relationships__c agmtEntityRel = new Agreement_Client_Relationships__c(Agreement__c = testAgreement.Id,Entity__c = testEntity.Id);
        insert agmtEntityRel;
        
        AgreementValidatorDataProvider dataProvider = new AgreementValidatorDataProvider();
        List<Agreement_Client_Relationships__c> testAgmtEntityRelList = dataProvider.GetAgreementEntityRels(testAgreement.Id);
        
        System.assertEquals(1, testAgmtEntityRelList.size());
    }
    
    @IsTest
    static void it_should_get_entities_for_bb() {
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbRel = new Agreement_Borrowing_Base_Relationship__c(Agreement__c = testAgreement.Id);
        insert bbRel;
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Agreement_Borrowing_Base_Entity_Rel__c bbEntityRel = new Agreement_Borrowing_Base_Entity_Rel__c(Agreement_Related_Borrowing_Base__c = bbRel.Id,Entity__c = newEntity.Id);
        insert bbEntityRel;
        
        AgreementValidatorDataProvider dataProvider = new AgreementValidatorDataProvider();
        List<Account> entities = dataProvider.getEntitiesTiedToBorrowingBaseComponent(testAgreement.Id);
        
        System.assertEquals(1, entities.size());        
    }

    static  testMethod void it_should_get_the_other_agreemententities() {
        Agreement__c testSourceAgreement = new Agreement__c();
        insert testSourceAgreement;
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Source_Agreement__c = testSourceAgreement.Id;
        insert testAgreement;
        Agreement__c otherAgreement = new Agreement__c();
        otherAgreement.Source_Agreement__c = testSourceAgreement.Id;
        insert otherAgreement;
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account testEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Agreement_Client_Relationships__c agmtEntityRel = new Agreement_Client_Relationships__c(Agreement__c = otherAgreement.Id,Entity__c = testEntity.Id);
        insert agmtEntityRel;
        
		test.startTest();        
        AgreementValidatorDataProvider dataProvider = new AgreementValidatorDataProvider();
        List<Agreement_Client_Relationships__c> otherEntities = dataProvider.getOtherAgreementEntitiesRels(new List<Account> {testEntity},testAgreement.Id, testSourceAgreement.Id);
        test.stopTest();
        
        System.assertEquals(1, otherEntities.size());
    }
    
    @IsTest
    static void it_should_get_loan_apps_not_related_to_agreement() {
    	TestUtilities.createLoanAppStages();
        Agreement__c testSourceAgreement = new Agreement__c();
        insert testSourceAgreement;
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Source_Agreement__c = testSourceAgreement.Id;
        insert testAgreement;
        Agreement__c otherAgreement = new Agreement__c();
        insert otherAgreement;        
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '11234');
        Agreement_Loan_Application_Relationship__c agmtLoanAppRel = new Agreement_Loan_Application_Relationship__c(Agreement__c = otherAgreement.Id,Loan_Application__c = newLoanApplication.Id);
        insert agmtLoanAppRel;
        Agreement_Loan_Application_Relationship__c agmtLoanAppRel2 = new Agreement_Loan_Application_Relationship__c(Agreement__c = testAgreement.Id,Loan_Application__c = newLoanApplication.Id);
        insert agmtLoanAppRel2;
        
        AgreementValidatorDataProvider dataProvider = new AgreementValidatorDataProvider();
        List<EB_Loan_Application__c> otherLoanAppList = dataProvider.getEbLoanApplicationsNotRelatedToCurrentAgreement(testAgreement.Id,testSourceAgreement.Id);

        System.assertEquals(1, otherLoanAppList.size());
    }
    
    @IsTest
    static void it_should_ebaccounts_not_related_to_agreements() {
        Agreement__c testSourceAgreement = new Agreement__c();
        insert testSourceAgreement;
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Source_Agreement__c = testSourceAgreement.Id;
        insert testAgreement;
        Agreement__c otherAgreement = new Agreement__c();
        insert otherAgreement;        
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '11234');
        Agreement_EB_Account_Relationship__c agmtEbAccountRels = new Agreement_EB_Account_Relationship__c(Agreement__c = testAgreement.Id, Loan_Account__c = newEBAccount.Id);
        insert agmtEbAccountRels;
        Agreement_EB_Account_Relationship__c agmtEbAccountRels2 = new Agreement_EB_Account_Relationship__c(Agreement__c = otherAgreement.Id, Loan_Account__c =  newEBAccount.Id);
        insert agmtEbAccountRels2;
        
        AgreementValidatorDataProvider dataProvider = new AgreementValidatorDataProvider();
        List<Agreements.EBAccountWrapper> otherEbAccountList = dataProvider.getEbAccountsNotRelatedToCurrentAgreement(testAgreement.Id,testSourceAgreement.Id);

        System.assertEquals(1, otherEbAccountList.size());
    }
    
    @IsTest
    static void it_should_get_a_list_of_loan_relationships_for_agreementId() {
    	Agreement__c testAgreement = new Agreement__c(); 
        insert testAgreement;
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('testEbAccount','1234', newEntity);
        TestUtilities.createLoanAppStages(); 
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '11234');
        Agreement_Loan_Application_Relationship__c agmtLoanAppRel = new Agreement_Loan_Application_Relationship__c(Agreement__c = testAgreement.Id,Loan_Application__c = newLoanApplication.Id);
        insert agmtLoanAppRel;
        AgreementValidatorDataProvider sut = new AgreementValidatorDataProvider();
        
        List<Agreement_Loan_Application_Relationship__c> agmtLoanRels = sut.getLoanApplicationRelationshipsByAgreementId(testAgreement.Id);
        
        System.assertEquals(1, agmtLoanRels.size());
    }
}