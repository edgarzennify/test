@IsTest
private class ClosingDisclosureFieldCalculatorTests {
    
    private static ClosingDisclosureFieldCalculator sut;

    static {
        sut = new ClosingDisclosureFieldCalculator();
    }

    @IsTest
    static void it_should_set_eligible_for_closing_disclosure_to_true_when_product_is_a_trid_product() {
		LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c(
            Eligible_for_Closing_Disclosure__c = false,
            LLC_BI__Is_Modification__c = false,
            LLC_BI__isRenewal__c = false,
            LLC_BI__Product__c = '2nd Deed of Trust Home Personal Residence'
        );
        LLC_BI__Loan__c ln2 = new LLC_BI__Loan__c(
            Eligible_for_Closing_Disclosure__c = false,
            LLC_BI__Is_Modification__c = false,
            LLC_BI__isRenewal__c = false,
            LLC_BI__Product__c = 'Bridge'
        );
        LLC_BI__Loan__c ln3 = new LLC_BI__Loan__c(
            Eligible_for_Closing_Disclosure__c = false,
            LLC_BI__Is_Modification__c = false,
            LLC_BI__isRenewal__c = false,
            LLC_BI__Product__c = 'Construction With or Without Lot Purchase'
        );
        LLC_BI__Loan__c ln4 = new LLC_BI__Loan__c(
            Eligible_for_Closing_Disclosure__c = false,
            LLC_BI__Is_Modification__c = false,
            LLC_BI__isRenewal__c = false,
            LLC_BI__Product__c = 'Portfolio Mortgage (QM & Non-QM)'
        );
        LLC_BI__Loan__c ln5 = new LLC_BI__Loan__c(
            Eligible_for_Closing_Disclosure__c = false,
            LLC_BI__Is_Modification__c = false,
            LLC_BI__isRenewal__c = false,
            LLC_BI__Product__c = 'Secondary Market Mortgage (QM & Non-QM)'
        );
        LLC_BI__Loan__c ln6 = new LLC_BI__Loan__c(
            Eligible_for_Closing_Disclosure__c = false,
            LLC_BI__Is_Modification__c = false,
            LLC_BI__isRenewal__c = false,
            LLC_BI__Product__c = 'Lot Purchase - No Construction'
        );

        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{ln1, ln2, ln3, ln4, ln5, ln6};
		
        sut.calculate(loans);
        
        System.assertEquals(true, ln1.Eligible_for_Closing_Disclosure__c);
        System.assertEquals(true, ln2.Eligible_for_Closing_Disclosure__c);
        System.assertEquals(true, ln3.Eligible_for_Closing_Disclosure__c);
        System.assertEquals(true, ln4.Eligible_for_Closing_Disclosure__c);
        System.assertEquals(true, ln5.Eligible_for_Closing_Disclosure__c);
        System.assertEquals(true, ln6.Eligible_for_Closing_Disclosure__c);
    }

    @IsTest
    static void it_should_set_eligible_for_closing_disclosure_to_false_when_product_is_not_a_trid_product() {
		LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c(
            LLC_BI__Is_Modification__c = false,
            LLC_BI__isRenewal__c = false,
            LLC_BI__Product__c = 'not trid1'
        );
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{ln1};

        sut.calculate(loans);

        System.assertEquals(false, ln1.Eligible_for_Closing_Disclosure__c);
    }
    
    @IsTest
    static void it_should_set_closing_disclosure_field_to_false_when_loan_no_longer_meets_trid_requirements() {
		LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c(
            Eligible_for_Closing_Disclosure__c = true,
            LLC_BI__Is_Modification__c = false,
            LLC_BI__isRenewal__c = false,
            LLC_BI__Product__c = 'not trid1'
        );
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{ln1};

        sut.calculate(loans);

        System.assertEquals(false, ln1.Eligible_for_Closing_Disclosure__c);
    }
}