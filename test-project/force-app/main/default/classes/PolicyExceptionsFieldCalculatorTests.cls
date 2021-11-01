@IsTest
private class PolicyExceptionsFieldCalculatorTests {
    
    private static PolicyExceptionsFieldCalculator sut;

    static {
        sut = new PolicyExceptionsFieldCalculator();
    }

    @IsTest
    static void it_should_set_policy_exception_and_description_fields_when_exceptions_field_is_null() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(
            Channel__c = 'Commercial Banking',
            LLC_BI__Pricing_Basis__c = 'Variable',
            Need_Rate_Floor__c = 'No',
            Policy_Exceptions__c = null
        );
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan};

        sut.calculate(loans);

        System.assertEquals('Variable Pricing Floor Overridden', loan.Policy_Exceptions_Description__c);
        System.assertEquals('Variable Pricing Floor Overridden', loan.Policy_Exceptions__c);
    }

    @IsTest
    static void it_should_set_policy_exception_and_description_fields_when_exceptions_field_contains_NA() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(
            Channel__c = 'Commercial Banking',
            LLC_BI__Pricing_Basis__c = 'Variable',
            Need_Rate_Floor__c = 'No',
            Policy_Exceptions__c = 'containsN/A'
        );
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan};

        sut.calculate(loans);

        System.assertEquals('Variable Pricing Floor Overridden', loan.Policy_Exceptions_Description__c);
        System.assertEquals('contains;Variable Pricing Floor Overridden;', loan.Policy_Exceptions__c);
    }

    @IsTest
    static void it_should_set_policy_exception_and_description_fields_when_exceptions_field_does_not_contain_NA_and_description_is_invalid() {
        String description = buildStringOfSize(220);
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(
            Channel__c = 'Commercial Banking',
            LLC_BI__Pricing_Basis__c = 'Variable',
            Need_Rate_Floor__c = 'No',
            Policy_Exceptions__c = 'asdf',
            Policy_Exceptions_Description__c = description
        );
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan};

        sut.calculate(loans);

        System.assertEquals(description, loan.Policy_Exceptions_Description__c);
        System.assertEquals('asdf;Variable Pricing Floor Overridden;', loan.Policy_Exceptions__c);
    }

    @IsTest
    static void it_should_set_policy_exception_and_description_fields_when_exceptions_field_does_not_contain_NA_and_description_is_valid() {
        String description = buildStringOfSize(5);
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(
            Channel__c = 'Commercial Banking',
            LLC_BI__Pricing_Basis__c = 'Variable',
            Need_Rate_Floor__c = 'No',
            Policy_Exceptions__c = 'asdf',
            Policy_Exceptions_Description__c = description
        );
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan};

        sut.calculate(loans);

        System.assertEquals(description + ' Variable Pricing Floor Overridden', loan.Policy_Exceptions_Description__c);
        System.assertEquals('asdf;Variable Pricing Floor Overridden;', loan.Policy_Exceptions__c);
    }

    private static String buildStringOfSize(Integer size){
        String s = '1';
        for (Integer i = 1; i < size; i++) {
            s += '1';
        }
        return s;
    }
}