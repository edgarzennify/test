@isTest
public class LLCBI_LoanTriggerHandlerHelperTests {
	private static LLCBI_LoanTriggerHandlerHelper sut;
    
    static{
        sut = new LLCBI_LoanTriggerHandlerHelper();
    }
    
    private static testMethod void it_should_call_gatherPackageIds_with_a_list_of_sobject_and_return_their_package_ids(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = pack.Id;
        List<SObject> sos = new List<SObject>{loan};
        
        Set<Id> results = sut.gatherPackageIds(sos);
        system.assertEquals(true, results.size()>0);
        system.assertEquals(true, results.contains(pack.Id));
    }
    private static testMethod void it_should_return_a_map_of_id_keys_and_condition_array_values_when_mapConditions_is_called_with_an_array_of_conditions(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        Conditions__c condition1 = new Conditions__c();
        condition1.Product_Package__c = packId;
        Conditions__c condition2 = new Conditions__c();
        condition2.Product_Package__c = packId;
        
        List<Conditions__c> relatedConditions = new List<Conditions__c>{condition1, condition2};
        Map<Id, List<Conditions__c>> results = sut.mapConditions(relatedConditions);
        system.assertEquals(true, results.get(packId).size() == 2);
        system.assertEquals(true, results.keySet().contains(packId));
    }
    private static testMethod void it_should_call_gatherEntityIds_with_a_list_of_sobject_and_return_their_package_ids(){
        Account entity = new Account();
        entity.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Account__c = entity.Id;
        List<SObject> sos = new List<SObject>{loan};
        
        Set<Id> results = sut.gatherEntityIds(sos);
        system.assertEquals(true, results.size()>0);
        system.assertEquals(true, results.contains(entity.Id));
    }
    private static testMethod void it_should_return_a_map_of_id_keys_and_entity_values_when_mapEntities_is_called_with_an_array_of_entities(){
        Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Account entity = new Account();
        entity.Id = entityId;
        
        List<Account> entities = new List<Account>{entity};
        Map<Id, Account> results = sut.mapEntities(entities);
        system.assertEquals(true, results.get(entityId).Id == entity.Id);
        system.assertEquals(true, results.keySet().contains(entity.Id));
    }
    private static testMethod void it_should_return_a_list_of_entities_when_gatherEntitiesToUpdate_is_called_with_entities_that_have_the_annualRevenue_field_updated_if_mismatched_from_loan(){
        Id entityId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id entityId2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Id loanId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id loanId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        
        Account entity1 = new Account();
        entity1.Id = entityId1;
        entity1.AnnualRevenue = null;
        
        Account entity2 = new Account();
        entity2.Id = entityId2;
        entity2.AnnualRevenue = 5000000;
        
        LLC_BI__Loan__c beforeLoan1 = new LLC_BI__Loan__c();
        beforeLoan1.Id = loanId1;
        beforeLoan1.Gross_Annual_Revenue_Income__c = null;
        beforeLoan1.LLC_BI__Account__c = entity1.Id;
        beforeLoan1.LLC_BI__Account__r = entity1;
        
        LLC_BI__Loan__c afterLoan1 = new LLC_BI__Loan__c();
        afterLoan1.Id = loanId1;
        afterLoan1.Gross_Annual_Revenue_Income__c = 10000000;
        afterLoan1.LLC_BI__Account__c = entity1.Id;
        afterLoan1.LLC_BI__Account__r = entity1;
        
        LLC_BI__Loan__c beforeLoan2 = new LLC_BI__Loan__c();
        beforeLoan2.Id = loanId2;
        beforeLoan2.Gross_Annual_Revenue_Income__c = 10000000;
        beforeLoan2.LLC_BI__Account__c = entity2.Id;
        beforeLoan2.LLC_BI__Account__r = entity2;
        
        LLC_BI__Loan__c afterLoan2 = new LLC_BI__Loan__c();
        afterLoan2.Id = loanId2;
        afterLoan2.Gross_Annual_Revenue_Income__c = 10000000;
        afterLoan2.LLC_BI__Account__c = entity2.Id;
        afterLoan2.LLC_BI__Account__r = entity2;
        
        List<SObject> sos = new List<SObject>{beforeLoan1, beforeLoan2};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(afterLoan1.Id, afterLoan1);
        newSosMap.put(afterLoan2.Id, afterLoan2);
        
        List<Account> relatedEntities = new List<Account>{entity1, entity2};
        
        List<Account> results = sut.gatherEntitiesToUpdate(sos, newSosMap, relatedEntities);
        system.assertEquals(1, results.size());
        system.assertEquals(entity1.Id, results[0].Id);
    }
}