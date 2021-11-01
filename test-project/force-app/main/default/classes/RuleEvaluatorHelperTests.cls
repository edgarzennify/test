@IsTest
private class RuleEvaluatorHelperTests {
    
    private static final RuleEvaluatorHelper sut;

    static {
        sut = new RuleEvaluatorHelper();
    }

    /*-----------------------verifyBoolean-----------------------*/
    @IsTest
    static void verifyBoolean_should_return_true_when_operation_is_equals_and_operands_are_equal() {
        Object subjectOperand = true;
        String ruleOperation = '=';
        String ruleOperand = 'True';

        Boolean results = sut.verifyBoolean(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyBoolean_should_return_false_when_operation_is_equals_and_operands_are_not_equal() {
        Object subjectOperand = true;
        String ruleOperation = '=';
        String ruleOperand = 'false';

        Boolean results = sut.verifyBoolean(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyBoolean_should_return_true_when_operation_is_not_equals_and_operands_are_not_equal() {
        Object subjectOperand = true;
        String ruleOperation = '<>';
        String ruleOperand = 'false';

        Boolean results = sut.verifyBoolean(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyBoolean_should_return_false_when_operation_is_not_equals_and_operands_are_not_equal() {
        Object subjectOperand = true;
        String ruleOperation = '!=';
        String ruleOperand = 'false';

        Boolean results = sut.verifyBoolean(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyBoolean_should_return_true_when_operation_is_invalid_and_operands_are_equal() {
        Object subjectOperand = true;
        String ruleOperation = 'invalid';
        String ruleOperand = 'true';

        Boolean results = sut.verifyBoolean(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyBoolean_should_return_false_when_operation_is_invalid_and_operands_are_not_equal() {
        Object subjectOperand = true;
        String ruleOperation = 'invalid';
        String ruleOperand = 'false';

        Boolean results = sut.verifyBoolean(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyBoolean_should_return_true_when_operation_is_equals_and_rule_operand_is_1() {
        Object subjectOperand = true;
        String ruleOperation = '=';
        String ruleOperand = '1';

        Boolean results = sut.verifyBoolean(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyBoolean_should_return_false_when_operation_is_equals_and_rule_operand_is_blank() {
        Object subjectOperand = true;
        String ruleOperation = '=';
        String ruleOperand = '';

        Boolean results = sut.verifyBoolean(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    /*-----------------------verifyDouble-----------------------*/
    @IsTest
    static void verifyDouble_should_return_false_when_rule_operand_is_null() {
        Object subjectOperand = 10.00;
        String ruleOperation = '=';
        String ruleOperand = null;

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDouble_should_return_false_when_subject_operand_is_null() {
        Object subjectOperand = null;
        String ruleOperation = '=';
        String ruleOperand = '10.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDouble_should_return_true_when_operation_is_greater_than_and_subject_operand_is_greater_than_rule_operand() {
        Object subjectOperand = 10.00;
        String ruleOperation = '>';
        String ruleOperand = '1.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDouble_should_return_false_when_operation_is_greater_than_and_subject_operand_is_less_than_rule_operand() {
        Object subjectOperand = 0.00;
        String ruleOperation = '>';
        String ruleOperand = '1.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDouble_should_return_true_when_operation_is_less_than_and_subject_operand_is_less_than_rule_operand() {
        Object subjectOperand = 10.00;
        String ruleOperation = '<';
        String ruleOperand = '100.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDouble_should_return_false_when_operation_is_less_than_and_subject_operand_is_greater_than_rule_operand() {
        Object subjectOperand = 100.00;
        String ruleOperation = '<';
        String ruleOperand = '10.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDouble_should_return_true_when_operation_is_equals_and_operands_are_equal() {
        Object subjectOperand = 10.00;
        String ruleOperation = '=';
        String ruleOperand = '10.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDouble_should_return_false_when_operation_is_equals_and_operands_are_not_equal() {
        Object subjectOperand = 10.00;
        String ruleOperation = '=';
        String ruleOperand = '1.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDouble_should_return_true_when_operation_is_not_equals_and_operands_are_not_equal() {
        Object subjectOperand = 1.00;
        String ruleOperation = '<>';
        String ruleOperand = '10.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDouble_should_return_false_when_operation_is_not_equals_and_operands_are_equal() {
        Object subjectOperand = 10.00;
        String ruleOperation = '<>';
        String ruleOperand = '10.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDouble_should_return_true_when_operation_is_greater_than_or_equal_to_and_subject_operand_is_greater_than_rule_operand() {
        Object subjectOperand = 10.00;
        String ruleOperation = '>=';
        String ruleOperand = '1.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDouble_should_return_true_when_operation_is_greater_than_or_equal_to_and_operands_are_equal() {
        Object subjectOperand = 10.00;
        String ruleOperation = '>=';
        String ruleOperand = '10.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDouble_should_return_false_when_operation_is_greater_than_or_equal_to_and_subject_operand_is_less_than_rule_operand() {
        Object subjectOperand = 1.00;
        String ruleOperation = '>=';
        String ruleOperand = '10.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDouble_should_return_true_when_operation_is_less_than_or_equal_to_and_subject_operand_is_less_than_rule_operand() {
        Object subjectOperand = 1.00;
        String ruleOperation = '<=';
        String ruleOperand = '10.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDouble_should_return_true_when_operation_is_less_than_or_equal_to_and_operands_are_equal() {
        Object subjectOperand = 10.00;
        String ruleOperation = '<=';
        String ruleOperand = '10.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDouble_should_return_false_when_operation_is_less_than_or_equal_to_and_subject_operand_is_greater_than_rule_operand() {
        Object subjectOperand = 10.00;
        String ruleOperation = '<=';
        String ruleOperand = '1.00';

        Boolean results = sut.verifyDouble(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    /*-----------------------verifyString-----------------------*/
    @IsTest
    static void verifyString_should_return_true_when_operation_is_equals_and_operands_are_equal() {
        Object subjectOperand = 'true';
        String ruleOperation = '=';
        String ruleOperand = 'true';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyString_should_return_false_when_operation_is_equals_and_operands_are_not_equal() {
        Object subjectOperand = 'not true';
        String ruleOperation = '=';
        String ruleOperand = 'true';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyString_should_return_true_when_operation_is_not_equals_and_operands_are_not_equal() {
        Object subjectOperand = 'not true';
        String ruleOperation = '<>';
        String ruleOperand = 'true';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyString_should_return_false_when_operation_is_not_equals_and_operands_are_equal() {
        Object subjectOperand = 'true';
        String ruleOperation = '<>';
        String ruleOperand = 'true';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyString_should_return_true_when_operation_is_in_and_rule_operand_contains_subject_operand() {
        Object subjectOperand = 'true';
        String ruleOperation = 'in';
        String ruleOperand = 'true, this contains the subject operand value';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyString_should_return_false_when_operation_is_in_and_rule_operand_does_not_contain_subject_operand() {
        Object subjectOperand = 'true';
        String ruleOperation = 'in';
        String ruleOperand = 'false, this does not contain the subject operand value';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyString_should_return_false_when_operation_is_in_and_subject_operand_is_blank_and_rule_operand_is_not_blank(){
        Object subjectOperand = '';
        String ruleOperation = 'in';
        String ruleOperand = 'false, this does not contain the subject operand value';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyString_should_return_false_when_operation_is_in_and_subject_operand_is_null_and_rule_operand_is_not_blank(){
        Object subjectOperand = null;
        String ruleOperation = 'in';
        String ruleOperand = 'false, this does not contain the subject operand value';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyString_should_return_true_when_operation_is_not_in_and_rule_operand_does_not_contain_subject_operand() {
        Object subjectOperand = 'true';
        String ruleOperation = 'not in';
        String ruleOperand = 'false, this does not contain the subject operand value';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyString_should_return_false_when_operation_is_not_in_and_rule_operand_contains_subject_operand() {
        Object subjectOperand = 'true';
        String ruleOperation = 'not in';
        String ruleOperand = 'true, this contains the subject operand value';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyString_should_return_false_when_operation_is_invalid() {
        Object subjectOperand = 'true';
        String ruleOperation = 'invalid';
        String ruleOperand = 'true, this contains the subject operand value';

        Boolean results = sut.verifyString(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    /*-----------------------verifyDate-----------------------*/
    @IsTest
    static void verifyDate_should_return_false_when_rule_operand_is_null() {
        Date dt = Date.newInstance(2021, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '=';
        String ruleOperand = null;

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDate_should_return_false_when_subject_operand_is_null() {
        Object subjectOperand = null;
        String ruleOperation = '=';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDate_should_return_true_when_operation_is_equals_and_operands_are_equal() {
        Date dt = Date.newInstance(2020, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '=';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDate_should_return_false_when_operation_is_equals_and_operands_are_not_equal() {
        Date dt = Date.newInstance(2020, 1, 2);
        Object subjectOperand = dt;
        String ruleOperation = '=';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDate_should_return_true_when_operation_is_not_equals_and_operands_are_not_equal() {
        Date dt = Date.newInstance(2020, 1, 2);
        Object subjectOperand = dt;
        String ruleOperation = '<>';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDate_should_return_false_when_operation_is_not_equals_and_operands_are_equal() {
        Date dt = Date.newInstance(2020, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '<>';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDate_should_return_true_when_operation_is_greater_than_and_subject_operand_is_greater_than_rule_operand() {
        Date dt = Date.newInstance(2021, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '>';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDate_should_return_false_when_operation_is_greater_than_and_subject_operand_is_less_than_rule_operand() {
        Date dt = Date.newInstance(2019, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '>';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDate_should_return_true_when_operation_is_less_than_and_subject_operand_is_less_than_rule_operand() {
        Date dt = Date.newInstance(2019, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '<';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDate_should_return_false_when_operation_is_less_than_and_subject_operand_is_greater_than_rule_operand() {
        Date dt = Date.newInstance(2021, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '<';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDate_should_return_true_when_operation_is_greater_than_or_equal_to_and_subject_operand_is_greater_than_rule_operand() {
        Date dt = Date.newInstance(2021, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '>=';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDate_should_return_true_when_operation_is_greater_than_or_equal_to_and_subject_operand_is_equal_to_rule_operand() {
        Date dt = Date.newInstance(2020, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '>=';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDate_should_return_false_when_operation_is_greater_than_or_equal_to_and_subject_operand_is_less_than_rule_operand() {
        Date dt = Date.newInstance(2019, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '>=';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }

    @IsTest
    static void verifyDate_should_return_true_when_operation_is_less_than_or_equal_to_and_subject_operand_is_less_than_rule_operand() {
        Date dt = Date.newInstance(2019, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '<=';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDate_should_return_true_when_operation_is_less_than_or_equal_to_and_subject_operand_is_equal_to_rule_operand() {
        Date dt = Date.newInstance(2020, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '<=';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results);
    }

    @IsTest
    static void verifyDate_should_return_false_when_operation_is_less_than_or_equal_to_and_subject_operand_is_greater_than_rule_operand() {
        Date dt = Date.newInstance(2021, 1, 1);
        Object subjectOperand = dt;
        String ruleOperation = '<=';
        String ruleOperand = '01/01/2020';

        Boolean results = sut.verifyDate(subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results);
    }
}