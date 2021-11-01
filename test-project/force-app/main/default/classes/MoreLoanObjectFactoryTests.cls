@IsTest
private class MoreLoanObjectFactoryTests {
    
    private static MoreLoanObjectFactory sut;

    static {
        sut = new MoreLoanObjectFactory();
    }

    @IsTest
    static void it_should_create_a_more_loan_record_related_to_the_given_loan() {
        Id lnId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c(Id = lnId);
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan1};

        List<More_Loan__c> results = sut.create(loans);

        System.assertEquals(lnId, results[0].Loan__c);
    }

    @IsTest
    static void it_should_return_a_more_loan_record_for_each_given_loan() {
        Id lnId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id lnId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c(Id = lnId1);
        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c(Id = lnId2);
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan1, loan2};

        List<More_Loan__c> results = sut.create(loans);

        System.assertEquals(2, results.size());
    }
}