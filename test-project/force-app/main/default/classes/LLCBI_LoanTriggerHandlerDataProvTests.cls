@isTest
private class LLCBI_LoanTriggerHandlerDataProvTests{
    
    private static LLCBI_LoanTriggerHandlerDataProvider sut;
    
    static {
        sut = new LLCBI_LoanTriggerHandlerDataProvider();
    }
    
    private static testMethod void it_should_call_getAllRelatedConditions_and_return_conditions(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.LLC_BI__TCE__c = 100000;
        insert pack;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = pack.Id;
        loan.LLC_BI__Product_Package__r = pack;
        insert loan;
        Conditions__c condition = new Conditions__c();
        condition.Funding_Condition__c = true;
        condition.Loan__c = loan.Id;
        condition.Product_Package__c = pack.Id;
        condition.Status__c = 'New';
        insert condition;
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<Conditions__c> results = sut.getAllRelatedConditions(packageIds);
        
        Object fieldsInResults = results[0].Id;
        fieldsInResults = results[0].Funding_Condition__c;
        fieldsInResults = results[0].Product_Package__c;
        fieldsInResults = results[0].Status__c;
    }
    private static testMethod void it_should_call_gatherRelatedEntities_with_a_list_of_entity_ids_and_return_a_list_of_accounts(){
        Account entity = new Account();
        entity.Name = 'Grand Lakes University';
        entity.BillingState = 'MI';
        insert entity;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Account__c = entity.Id;
        insert loan;
        Set<Id> entityIds = new Set<Id>{loan.LLC_BI__Account__c};
		
        List<Account> results = sut.gatherRelatedEntities(entityIds);
        
        system.assertEquals(entity.Id, results[0].Id);
    }
    private static testMethod void it_should_test_getPledges(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        insert loan;
        LLC_BI__Collateral_Type__c colType = new LLC_BI__Collateral_Type__c();
        LLC_BI__Loan_Collateral_Aggregate__c colAgg = new LLC_BI__Loan_Collateral_Aggregate__c();
        insert colAgg;
        colType.Collateral_Record_Type__c = 'Real Estate';
        insert colType;
        LLC_BI__Collateral__c colMgmt = new LLC_BI__Collateral__c();
        colMgmt.LLC_BI__Collateral_Type__c = colType.Id;
        colMgmt.LLC_BI__Collateral_Type__r = colType;
        insert colMgmt;
        LLC_BI__Loan_Collateral2__c colPledge = new LLC_BI__Loan_Collateral2__c();
        colPledge.LLC_BI__Loan__c = loan.Id;
        colPledge.LLC_BI__Collateral__c = colMgmt.Id;
        colPledge.LLC_BI__Collateral__r = colMgmt;
        colPledge.LLC_BI__Loan_Collateral_Aggregate__c = colAgg.Id;
        insert colPledge;
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan};
        
        
        List<LLC_BI__Loan_Collateral2__c> results = sut.getPledges(loans);
        system.assertEquals(colPledge.LLC_BI__Loan__c, results[0].LLC_BI__Loan__c);
        system.assertEquals(colPledge.LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Collateral_Record_Type__c, results[0].LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Collateral_Record_Type__c);
    }
}