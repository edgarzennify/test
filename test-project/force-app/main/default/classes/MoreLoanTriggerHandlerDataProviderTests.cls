@isTest
public class MoreLoanTriggerHandlerDataProviderTests {
    private static final MoreLoanTriggerHandlerDataProvider sut;
    static{
        sut = new MoreLoanTriggerHandlerDataProvider();
    }
    
    private static testMethod void it_should_return_a_list_of_more_loan_records_when_getRelatedMoreLoanRecords_is_called_with_a_set_of_loan_ids(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        insert loan;
        //Loan trigger handler creates a related More_Loan__c record 
        Set<Id> idSet = new Set<Id>{loan.Id};
        List<More_Loan__c> results = sut.getRelatedMoreLoanRecords(idSet); 
        System.assertEquals(1, results.size());
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Loan__c;
    }

}