@isTest
public class MoreLoanTriggerHandlerHelperTests {
    private static final MoreLoanTriggerHandler.IMoreLoanTriggerHandlerHelper sut;
    static{
        sut = new MoreLoanTriggerHandlerHelper();
    }
    
    private static testMethod void it_should_return_a_set_of_ids_when_getLoanIds_is_called_with_a_list_of_more_loan_sobjects(){
        List<SObject> sos = new List<SObject>();
        Id loanId = ObjectFactory.getFakeId(More_Loan__c.SObjectType, '1');
        More_Loan__c ml = new More_Loan__c();
        ml.Loan__c = loanId;
        sos.add(ml);
        Set<Id> results = sut.getLoanIds(sos);
        system.assertEquals(true, results.contains(loanId));
        system.assertEquals(1, results.size());
    }
    private static testMethod void it_should_return_a_map_of_id_and_more_loan_when_buildMoreLoanMap_is_called_with_a_list_of_more_loans(){
        Id loanId = ObjectFactory.getFakeId(More_Loan__c.SObjectType, '1');
        More_Loan__c ml = new More_Loan__c();
        ml.Loan__c = loanId;
        List<More_Loan__c> relatedMoreLoans = new List<More_Loan__c>{ml};
        Map<Id, More_Loan__c> results = sut.buildMoreLoanMap(relatedMoreLoans);
        system.assertEquals(ml, results.get(loanId));
    }

}