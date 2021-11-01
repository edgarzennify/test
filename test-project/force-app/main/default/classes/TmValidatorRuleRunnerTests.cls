@IsTest
public class TmValidatorRuleRunnerTests {
    private static TmValidatorRuleRunner sut;
    private static final Mock.ofIShuntingYard mockAlgorithm;
    private static final Mock.ofIErrorRepository mockErrors;
    private static final Mock.ofIRuleEvaluator mockRuleEvaluator;

    static {
        mockAlgorithm = new Mock.ofIShuntingYard();
        mockErrors = new Mock.ofIErrorRepository();
        mockRuleEvaluator = new Mock.ofIRuleEvaluator();
        sut = new TmValidatorRuleRunner(mockAlgorithm, mockErrors, mockRuleEvaluator);
    }

    @IsTest
    static void it_should_call_the_rule_runner_once() {
        DmField dm = new DmField();
        dm.Type = DescribeFieldResultWrapper.Type.TypeBoolean;
        object fieldValue = true;
        DmTmRule rule = new DmTmRule();
        rule.FieldName ='ACH_Credits__c';
        rule.Operand = null;
        rule.Operation = '=';

        Boolean results = sut.ValidateRule(dm, fieldValue, rule);

        mockRuleEvaluator.verify('evaluate', new List<Object>{dm.Type, fieldValue, rule.Operation, rule.Operand}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_algorithm_and_pass_the_formula_and_data() {
        String formula = '(A or B)';
        String parentFieldName = 'p-field-name';
        String childFieldName = 'ch-field-name';

        DmField parentField = new DmField();
        parentField.name = parentFieldName;
        parentField.Type = DescribeFieldResultWrapper.Type.TypeBoolean;

        DmField childField = new DmField();
        childField.name = childFieldName;
        childField.Type = DescribeFieldResultWrapper.Type.TypeBoolean;

        DmTmRule parentRule = new DmTmRule();
        parentRule.Formula = formula;
        parentRule.fieldName = parentFieldName;
        parentRule.FormulaToken = 'A';
        parentRule.Operand = 'true';
        parentRule.Operation = '=';

        DmTmRule childRule = new DmTmRule();
        childRule.FieldName = childFieldName;
        childRule.Operand = 'true';
        childRule.Operation = '=';
        childRule.FormulaToken = 'B';

        Map<DmField, object> fieldMap = new Map<DmField, object>{parentField => true, childField => true};
        Map<DmTmRule, List<DmTmRule>> ruleMap = new Map<DmTmRule, List<DmTmRule>>{parentRule => new List<DmTmRule>{childRule}};

        mockRuleEvaluator.setup('evaluate', new List<Object>{parentField.Type, true, parentRule.Operation, parentRule.Operand}).returns(true);
        mockRuleEvaluator.setup('evaluate', new List<Object>{childField.Type, true, childRule.Operation, childRule.Operand}).returns(true);

        boolean result = sut.ValidateCorrelatedValues(fieldMap, ruleMap );

        Map<string, boolean> resultData = new Map<string, Boolean>{'A' => true, 'B' => true};
        mockAlgorithm.verify('run', new List<Object>{formula, resultData}, Times.Once);
    }

    @IsTest
    static void it_should_log_error_when_data_sent_to_algorithm_is_invalid() {
        string formula = '(A or B)';
        string parentFieldName = 'p-field-name';
        string childFieldName = 'ch-field-name';

        DmField parentField = new DmField();
        parentField.name = parentFieldName;
        parentField.Type = DescribeFieldResultWrapper.Type.TypeBoolean;

        DmField childField = new DmField();
        childField.name = childFieldName;
        childField.Type = DescribeFieldResultWrapper.Type.TypeBoolean;

        DmTmRule parentRule = new DmTmRule();
        parentRule.Formula = formula;
        parentRule.fieldName = parentFieldName;
        parentRule.FormulaToken = 'A';
        parentRule.Operand = 'true';
        parentRule.Operation = '=';

        DmTmRule childRule = new DmTmRule();
        childRule.FieldName = childFieldName;
        childRule.Operand = 'true';
        childRule.Operation = '=';
        childRule.FormulaToken = 'B';

        Map<DmField, object> fieldMap = new Map<DmField, object>{parentField => true, childField => true};
        Map<DmTmRule, List<DmTmRule>> ruleMap = new Map<DmTmRule, List<DmTmRule>>{parentRule => new List<DmTmRule>{childRule}};
        mockAlgorithm.setup('run', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).throws(new TestException());

        boolean result = sut.ValidateCorrelatedValues(fieldMap, ruleMap);
        
        String expectedError = 'Error in validation formula (A or B) for field p-field-name';
        mockErrors.verify('addError', new List<Object>{expectedError}, Times.Once);
    }

    private class TestException extends Exception {}
}