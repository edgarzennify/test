@IsTest
private class RuleEvaluatorTests {
    
    private static final RuleEvaluator sut;
    private static final MockOfIRuleEvaluatorHelper mockHelper;
    private static final Mock.ofISchema mockSchema;

    static {
        mockHelper = new MockOfIRuleEvaluatorHelper();
        mockSchema = new Mock.ofISchema();
        sut = new RuleEvaluator(mockHelper, mockSchema);  
    }

    @IsTest
    static void it_should_return_true_when_given_type_is_boolean() {
        DescribeFieldResultWrapper.Type type = DescribeFieldResultWrapper.Type.TypeBoolean;
        Object subjectOperand = 'test subject';
        String ruleOperation = 'test operation';
        String ruleOperand = 'test operand';
        
        mockHelper
            .setup('verifyBoolean', new List<Object>{subjectOperand, ruleOperation, ruleOperand})
            .returns(true);

        Boolean results = sut.evaluate(type, subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results, 'results should equal true');
    }

    @IsTest
    static void it_should_return_true_when_given_type_is_double() {
        DescribeFieldResultWrapper.Type type = DescribeFieldResultWrapper.Type.TypeDouble;
        Object subjectOperand = 'test subject';
        String ruleOperation = 'test operation';
        String ruleOperand = 'test operand';
        
        mockHelper
            .setup('verifyDouble', new List<Object>{subjectOperand, ruleOperation, ruleOperand})
            .returns(true);

        Boolean results = sut.evaluate(type, subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results, 'results should equal true');
    }

    @IsTest
    static void it_should_return_true_when_given_type_is_currency() {
        DescribeFieldResultWrapper.Type type = DescribeFieldResultWrapper.Type.TypeCurrency;
        Object subjectOperand = 'test subject';
        String ruleOperation = 'test operation';
        String ruleOperand = 'test operand';
        
        mockHelper
            .setup('verifyDouble', new List<Object>{subjectOperand, ruleOperation, ruleOperand})
            .returns(true);

        Boolean results = sut.evaluate(type, subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results, 'results should equal true');
    }

    @IsTest
    static void it_should_return_true_when_given_type_is_text() {
        DescribeFieldResultWrapper.Type type = DescribeFieldResultWrapper.Type.TypeText;
        Object subjectOperand = 'test subject';
        String ruleOperation = 'test operation';
        String ruleOperand = 'test operand';
        
        mockHelper
            .setup('verifyString', new List<Object>{subjectOperand, ruleOperation, ruleOperand})
            .returns(true);

        Boolean results = sut.evaluate(type, subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results, 'results should equal true');
    }

    @IsTest
    static void it_should_return_true_when_given_type_is_picklist() {
        DescribeFieldResultWrapper.Type type = DescribeFieldResultWrapper.Type.TypePicklist;
        Object subjectOperand = 'test subject';
        String ruleOperation = 'test operation';
        String ruleOperand = 'test operand';
        
        mockHelper
            .setup('verifyString', new List<Object>{subjectOperand, ruleOperation, ruleOperand})
            .returns(true);

        Boolean results = sut.evaluate(type, subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results, 'results should equal true');
    }

    @IsTest
    static void it_should_return_true_when_given_type_is_text_area() {
        DescribeFieldResultWrapper.Type type = DescribeFieldResultWrapper.Type.TypeTextArea;
        Object subjectOperand = 'test subject';
        String ruleOperation = 'test operation';
        String ruleOperand = 'test operand';
        
        mockHelper
            .setup('verifyString', new List<Object>{subjectOperand, ruleOperation, ruleOperand})
            .returns(true);

        Boolean results = sut.evaluate(type, subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results, 'results should equal true');
    }

    @IsTest
    static void it_should_return_true_when_given_type_is_date() {
        DescribeFieldResultWrapper.Type type = DescribeFieldResultWrapper.Type.TypeDate;
        Object subjectOperand = 'test subject';
        String ruleOperation = 'test operation';
        String ruleOperand = 'test operand';
        
        mockHelper
            .setup('verifyDate', new List<Object>{subjectOperand, ruleOperation, ruleOperand})
            .returns(true);

        Boolean results = sut.evaluate(type, subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results, 'results should equal true');
    }

    @IsTest
    static void it_should_return_true_when_given_type_is_reference() {
        DescribeFieldResultWrapper.Type type = DescribeFieldResultWrapper.Type.TypeReference;
        Object subjectOperand = 'test subject';
        String ruleOperation = 'test operation';
        String ruleOperand = 'test operand';
        
        mockHelper
            .setup('verifyString', new List<Object>{subjectOperand, ruleOperation, ruleOperand})
            .returns(true);

        Boolean results = sut.evaluate(type, subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(true, results, 'results should equal true');
    }

    @IsTest
    static void it_should_return_false_when_given_type_is_invalid() {
        DescribeFieldResultWrapper.Type type = DescribeFieldResultWrapper.Type.TypeDateTime;
        Object subjectOperand = 'test subject';
        String ruleOperation = 'test operation';
        String ruleOperand = 'test operand';
        
        Boolean results = sut.evaluate(type, subjectOperand, ruleOperation, ruleOperand);

        System.assertEquals(false, results, 'results should equal false');
    }

    @IsTest
    static void it_should_return_true_when_given_reference_object_and_reference_field() {
        DescribeFieldResultWrapper.Type type = DescribeFieldResultWrapper.Type.TypeBoolean;
        String referenceObject = 'ref obj';
        String referenceField = 'REF FIELD';
        Object subjectOperand = 'test subject';
        String ruleOperation = 'test operation';
        String ruleOperand = 'test operand';

        Mock.ofISObjectField mockField = new Mock.ofISObjectField();
        
        mockSchema
            .setup('getField', new List<Object>{referenceObject, referenceField})
            .returns(mockField);

        mockField
            .setup('getType')
            .returns(type);
            
        mockHelper
            .setup('verifyBoolean', new List<Object>{subjectOperand, ruleOperation, ruleOperand})
            .returns(true);

        Boolean results = sut.evaluate(referenceObject, referenceField, subjectOperand, ruleOperation, ruleOperand);

        mockSchema.verify('getField', new List<Object>{referenceObject, referenceField}, Times.Once);
        System.assertEquals(true, results, 'results should equal true');
    }

    public class MockOfIRuleEvaluatorHelper extends ApexMoq implements RuleEvaluatorHelper.IRuleEvaluatorHelper{
        public Boolean verifyBoolean(Object subjectOperand, String ruleOperation, String ruleOperand){
            return (Boolean)handleMethodInvocation('verifyBoolean', new List<Object>{subjectOperand, ruleOperation, ruleOperand});
        }
        public Boolean verifyDouble(Object subjectOperand, String ruleOperation, String ruleOperand){
            return (Boolean)handleMethodInvocation('verifyDouble', new List<Object>{subjectOperand, ruleOperation, ruleOperand});
        }
        public Boolean verifyString(Object subjectOperand, String ruleOperation, String ruleOperand){
            return (Boolean)handleMethodInvocation('verifyString', new List<Object>{subjectOperand, ruleOperation, ruleOperand});
        }
        public Boolean verifyDate(Object subjectOperand, String ruleOperation, String ruleOperand){
            return (Boolean)handleMethodInvocation('verifyDate', new List<Object>{subjectOperand, ruleOperation, ruleOperand});
        }
    }
}