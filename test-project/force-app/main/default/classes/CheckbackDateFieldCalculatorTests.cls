@IsTest
private class CheckbackDateFieldCalculatorTests {
    
    private static CheckbackDateFieldCalculator sut;
    private static Mock.ofISystem mockSystem;

    static {
        mockSystem = new Mock.ofISystem();
        sut = new CheckbackDateFieldCalculator(mockSystem);
    }

    @IsTest
    static void when_checkback_is_not_in_progress_checkback_date_should_be_null() {
        LLC_BI__Loan__c ln = new LLC_BI__Loan__c(Checkback_in_progress_box__c = false);
        
        sut.calculate(ln);

        System.assertEquals(null, ln.Checkback_in_Progress__c);
    }

    @IsTest
    static void when_checkback_is_in_progress_checkback_date_should_be_today() {
        Date dt = Date.newInstance(2020, 11, 19);
        LLC_BI__Loan__c ln = new LLC_BI__Loan__c(Checkback_in_progress_box__c = true);

        mockSystem.setup('today').returns(dt);

        sut.calculate(ln);

        System.assertEquals(dt, ln.Checkback_in_Progress__c);
    }

    @IsTest
    static void it_should_calculate_for_multiple_new_loans() {
        Date dt = Date.newInstance(2020, 11, 19);
        LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c(Checkback_in_progress_box__c = true);
        LLC_BI__Loan__c ln2 = new LLC_BI__Loan__c(Checkback_in_progress_box__c = false);
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{ln1, ln2};

        mockSystem.setup('today').returns(dt);

        sut.calculate(loans);

        System.assertEquals(dt, ln1.Checkback_in_Progress__c);
        System.assertEquals(null, ln2.Checkback_in_Progress__c);
    }

    @IsTest
    static void when_checkback_is_not_changed_checkback_date_should_be_null() {
        LLC_BI__Loan__c oldLn = new LLC_BI__Loan__c(Checkback_in_progress_box__c = false);
        LLC_BI__Loan__c newLn = new LLC_BI__Loan__c(Checkback_in_progress_box__c = false);

        sut.calculate(oldLn, newLn);

        System.assertEquals(null, newLn.Checkback_in_Progress__c);
    }

    @IsTest
    static void when_checkback_is_in_progress_is_checked_it_should_be_marked_with_todays_date() {
        Date dt = Date.newInstance(2020, 11, 19);
        LLC_BI__Loan__c oldLn = new LLC_BI__Loan__c(Checkback_in_progress_box__c = false);
        LLC_BI__Loan__c newLn = new LLC_BI__Loan__c(Checkback_in_progress_box__c = true);

        mockSystem.setup('today').returns(dt);

        sut.calculate(oldLn, newLn);

        System.assertEquals(dt, newLn.Checkback_in_Progress__c);
    }

    @IsTest
    static void when_checkback_in_progress_is_unchecked_it_should_clear_the_date() {
        Date dt = Date.newInstance(2020, 11, 19);
        LLC_BI__Loan__c oldLn = new LLC_BI__Loan__c(Checkback_in_progress_box__c = true, Checkback_in_Progress__c = dt);
        LLC_BI__Loan__c newLn = new LLC_BI__Loan__c(Checkback_in_progress_box__c = false, Checkback_in_Progress__c = dt);
        
        sut.calculate(oldLn, newLn);

        System.assertEquals(null, newLn.Checkback_in_Progress__c);
    }

    @IsTest
    static void it_should_only_update_the_checkback_in_progress_date_when_the_checkback_in_progress_box_is_initially_checked() {
        LLC_BI__Loan__c oldLn = new LLC_BI__Loan__c(Checkback_in_progress_box__c = true);
        LLC_BI__Loan__c newLn = new LLC_BI__Loan__c(Checkback_in_progress_box__c = true);

        sut.calculate(oldLn, newLn);
        
        mockSystem.verify('today', Times.Never);
    }

    @IsTest
    static void it_should_calculate_for_multiple_updated_loans() {
        Id id1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        Date dt = Date.newInstance(2020, 11, 19);
        LLC_BI__Loan__c oldLn1 = new LLC_BI__Loan__c(Id = id1, Checkback_in_progress_box__c = false);
        LLC_BI__Loan__c newLn1 = new LLC_BI__Loan__c(Id = id1, Checkback_in_progress_box__c = true);
        LLC_BI__Loan__c oldLn2 = new LLC_BI__Loan__c(Id = id2, Checkback_in_progress_box__c = false);
        LLC_BI__Loan__c newLn2 = new LLC_BI__Loan__c(Id = id2, Checkback_in_progress_box__c = true);
        List<LLC_BI__Loan__c> oldLoans = new List<LLC_BI__Loan__c>{oldLn1, oldLn2};
        Map<Id, LLC_BI__Loan__c> newLoans = new Map<Id, LLC_BI__Loan__c>();
        newLoans.put(id1, newLn1);
        newLoans.put(id2, newLn2);
        
        mockSystem.setup('today').returns(dt);

        sut.calculate(oldLoans, newLoans);

        System.assertEquals(dt, newLn1.Checkback_in_Progress__c);
        System.assertEquals(dt, newLn2.Checkback_in_Progress__c);
    }
}