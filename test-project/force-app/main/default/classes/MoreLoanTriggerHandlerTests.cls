@isTest
public class MoreLoanTriggerHandlerTests {
    private static final MoreLoanTriggerHandler sut;
    private static final MockOfMoreLoansHelper mockHelper;
    private static final MockOfMoreLoansDataProvider mockDataProvider;
    static{
        mockHelper = new MockOfMoreLoansHelper();
        mockDataProvider = new MockOfMoreLoansDataProvider();
        sut = new MoreLoanTriggerHandler(mockHelper, mockDataProvider);
    }
    
    private static testMethod void it_should_add_an_error_when_a_more_loan_is_entered_for_a_loan_that_already_has_a_more_loan_record_related(){
        List<SObject> sos = new List<SObject>();
        Id loanId = ObjectFactory.getFakeId(More_Loan__c.SObjectType, '1');
        Set<Id> loanIds = new Set<Id>{loanId};
        List<More_Loan__c> existingMls = new List<More_Loan__c>();
        Map<Id, More_Loan__c> relatedMlMap = new Map<Id, More_Loan__c>();
        More_Loan__c newMl = new More_Loan__c();
        newMl.Loan__c = loanId;
        sos.add(newMl);
        More_Loan__c existingMl = new More_Loan__c();
        existingMl.Loan__c = loanId;
        existingMls.add(existingMl);
        relatedMlMap.put(existingMl.Loan__c, existingMl);
        
        mockHelper.setup('getLoanIds',  new List<Object>{sos}).returns(loanIds);
        mockDataProvider.setup('getRelatedMoreLoanRecords', new List<Object>{loanIds}).returns(existingMls);
        mockHelper.setup('buildMoreLoanMap', new List<Object>{existingMls}).returns(relatedMlMap);
        sut.bulkBeforeInsert(sos);
        List<Database.Error> errors = newMl.getErrors(); 
        system.debug('errors is:   ' + errors);
        system.assertEquals(true, newMl.getErrors().size() > 0);
        system.assertEquals(true, errors[0].getMessage().contains('Only one More Loan record may be related to this Loan. More Loan Id:'));
    }
    private static testMethod void it_should_not_add_an_error_when_a_more_loan_is_entered_for_a_loan_that_does_not_already_have_a_more_loan_record_related(){
        List<SObject> sos = new List<SObject>();
        Id loanId = ObjectFactory.getFakeId(More_Loan__c.SObjectType, '1');
        Set<Id> loanIds = new Set<Id>{loanId};
        More_Loan__c newMl = new More_Loan__c();
        newMl.Loan__c = loanId;
        sos.add(newMl);
        
        mockHelper.setup('getLoanIds',  new List<Object>{sos}).returns(loanIds);
        sut.bulkBeforeInsert(sos);
        system.assertEquals(0, newMl.getErrors().size());
    }
    private static testMethod void it_should_cover_the_construtor(){
        MoreLoanTriggerHandler mlth = new MoreLoanTriggerHandler();
    }
    
    public class MockOfMoreLoansHelper extends ApexMoq implements MoreLoanTriggerHandler.IMoreLoanTriggerHandlerHelper {
        public Set<Id> getLoanIds(List<SObject> sos) {
			return (Set<Id>)handleMethodInvocation('getLoanIds', new List<Object>{sos});
		}
        public Map<Id, More_Loan__c> buildMoreLoanMap(List<More_Loan__c> relatedMoreLoanRecords) {
			return (Map<Id, More_Loan__c>)handleMethodInvocation('buildMoreLoanMap', new List<Object>{relatedMoreLoanRecords});
		}
    }
    public class MockOfMoreLoansDataProvider extends ApexMoq implements MoreLoanTriggerHandler.IMoreLoanTriggerHandlerDataProvider {
        public List<More_Loan__c> getRelatedMoreLoanRecords(Set<Id> loanIds) {
			return (List<More_Loan__c>)handleMethodInvocation('getRelatedMoreLoanRecords', new List<Object>{loanIds});
		}
    }
}