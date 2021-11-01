@isTest
private class Clone_AgreementDataProviderTests{
    @IsTest
    private static void go_for_code_coverage(){
        Clone_AgreementDataProvider sut = new Clone_AgreementDataProvider();
        Agreement__c agreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        agreement.Name = 'AGMT-0001 rev 01';
        insert agreement;
        
        sut.GetAgreementById(agreement.Id);
        sut.GetAgreementBorrowingBaseRelationships(agreement.Id);
        sut.GetAgreementFinancialCovenants(agreement.Id);
        sut.GetAgreementClientRelationships(agreement.Id);
        sut.GetAgreementEBAccountRelationships(agreement.Id);
        sut.GetAgreementLoanApplicationRelationships(agreement.Id);
        sut.GetPendingAgreementCountByName(agreement.Name);
    }
    
    @IsTest
    private static void it_should_return_financial_reporting_fields_from_entity_when_retrieving_client_relationships(){
        Clone_AgreementDataProvider sut = new Clone_AgreementDataProvider();
        
        Agreement__c agreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        insert agreement;
        Account entity = ObjectFactory.getValidEntity('bogus');
        entity.Tax_Returns__c = '0001';
        entity.Tax_Return_Days_Due_After_Filing__c = 2;
        entity.Annual_Financial_Statements__c = '0003';               
        entity.Annual_Statement_Quality__c = '0004';           
        entity.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = 5;
        entity.Personal_Financial_Statement__c = '0006';
        entity.Personal_Financial_Statement_Frequency__c = '0007';
        entity.Interim_Statements__c = '0008';
        entity.Interim_Stm_Prepared_By__c = '0009';
        entity.Interim_Stmt_Days_Due_After_Period_End__c = 10;
        update entity;
        Agreement_Client_Relationships__c clientRel = (Agreement_Client_Relationships__c)SmartFactory.createSObject('Agreement_Client_Relationships__c');
        clientRel.Entity__c = entity.Id;
        clientRel.Agreement__c = agreement.Id;
        insert clientRel;   
                
        //Act
        List<Agreement_Client_Relationships__c> clientRels = sut.GetAgreementClientRelationships(agreement.Id);
        
        //Assert
        // get the new client rel from the list by id, in case some trigger has added another one
        Agreement_Client_Relationships__c newRel = getAgreementClientRelByIdFromList(clientRels, clientRel.Id);
        
        System.assertEquals('0001', newRel.Entity__r.Tax_Returns__c);
        System.assertEquals(2, newRel.Entity__r.Tax_Return_Days_Due_After_Filing__c);
        System.assertEquals('0003', newRel.Entity__r.Annual_Financial_Statements__c);
        System.assertEquals('0004', newRel.Entity__r.Annual_Statement_Quality__c);
        System.assertEquals(5, newRel.Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c);
        System.assertEquals('0006', newRel.Entity__r.Personal_Financial_Statement__c);
        System.assertEquals('0007', newRel.Entity__r.Personal_Financial_Statement_Frequency__c);
        System.assertEquals('0008', newRel.Entity__r.Interim_Statements__c);
        System.assertEquals('0009', newRel.Entity__r.Interim_Stm_Prepared_By__c);
        System.assertEquals(10, newRel.Entity__r.Interim_Stmt_Days_Due_After_Period_End__c);
    }
    
    @IsTest
    private static void it_should_get_a_list_of_subordinates(){
        Clone_AgreementDataProvider sut = new Clone_AgreementDataProvider();
        Agreement__c agreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        agreement.Name = 'AGMT-0001 rev 01';
        insert agreement;
        Agreement_Subordination__c sub = new Agreement_Subordination__c();
        sub.Agreement__c = agreement.Id;
        sub.Obligation_Amount__c = 2.0;
        sub.Creditor__c = ObjectFactory.getValidEntity('Test Entity').Id;
        insert sub;
        
        List<Agreement_Subordination__c> subList = sut.getAgreementSubordinationRelationships(agreement.Id);
        
        system.assertEquals(1, subList.size());
    }

    @IsTest
    private static void it_should_be_able_to_remove_loanApps_from_Agreement(){
    	TestUtilities.createLoanAppStages();
        Clone_AgreementDataProvider sut = new Clone_AgreementDataProvider();
        Agreement__c agreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        agreement.Name = 'AGMT-0001 rev 01';
        agreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Active').Id;
        insert agreement;
		Eb_Loan_Application__c loanApp =  ObjectFactory.getLoanApplication('Test Entity' , 'Test Account', '1234' ,'Test Loan App');     
        Agreement_Loan_Application_Relationship__c loanAppRel = new Agreement_Loan_Application_Relationship__c();
        loanAppRel.Agreement__c = agreement.Id;
        loanAppRel.Loan_Application__c = loanApp.Id;
        insert loanAppRel;
        Agreement__c reQueryAgmt = [SELECT Id, RecordTypeDescription__c FROM Agreement__c WHERE id =: agreement.Id];
        
        sut.RemoveAgreementLoanApps(new List<Agreement_Loan_Application_Relationship__c> {loanAppRel}, reQueryAgmt);
        
        system.assertEquals(0,[SELECT Id FROM Agreement_Loan_Application_Relationship__c WHERE Agreement__c =: agreement.Id and Loan_Application__c =: loanApp.Id].size());
    }
    
    //////////////////////////////////////////
    // utility functions
    private static Agreement_Client_Relationships__c getAgreementClientRelByIdFromList(List<Agreement_Client_Relationships__c> acrList, Id acrId){
        for(Agreement_Client_Relationships__c rel : acrList){
            if(rel.Id == acrId){
                return rel;
            }
        }
        return null;
    }
}