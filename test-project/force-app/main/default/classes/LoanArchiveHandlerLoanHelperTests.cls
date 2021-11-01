@isTest
public class LoanArchiveHandlerLoanHelperTests{

    private final static LoanArchiveHandlerLoanHelper sut;

    static{
        sut = new LoanArchiveHandlerLoanHelper();
    }

    private static testMethod void it_should_build_the_map(){
        Id loanId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id loanId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        Id ebAcctId1 = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');
        Id ebAcctId2 = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '2');

        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c(Id=loanId1);
        loan1.LLC_BI__lookupKey__c = '111';
        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c(Id=loanId2);
        loan2.LLC_BI__lookupKey__c = '222';     
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan1, loan2};

        EB_Account__c ebAcct1 = new EB_Account__c(Id=ebAcctId1);
        ebAcct1.Key__c = '222';
        EB_Account__c ebAcct2 = new EB_Account__c(Id=ebAcctId2);
        ebAcct2.Key__c = '111'; 
        List<EB_Account__c> ebAccts = new List<EB_Account__c>{ebAcct1, ebAcct2};        
        
        Map<Id, Id> result = sut.buildCachedMap(loans, ebAccts);

        System.assertEquals(2, result.size());
        System.assertEquals(ebAcct2.Id, result.get(loan1.Id));
        System.assertEquals(ebAcct1.Id, result.get(loan2.Id));
    }
}