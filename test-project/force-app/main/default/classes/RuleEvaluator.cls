public class RuleEvaluator implements IRuleEvaluator {

    public interface IRuleEvaluator {
        Boolean evaluate(DescribeFieldResultWrapper.Type type, Object subjectOperand, String ruleOperation, String ruleOperand);
        Boolean evaluate(String referenceObject, String referenceFieldName, Object subjectOperand, String ruleOperation, String ruleOperand);
    }

    private final RuleEvaluatorHelper.IRuleEvaluatorHelper m_helper;
    private final ISchema m_schema;

    public RuleEvaluator (RuleEvaluatorHelper.IRuleEvaluatorHelper helper, ISchema schema) {
        m_helper = helper;
        m_schema = schema;
    }

    public Boolean evaluate(DescribeFieldResultWrapper.Type type, Object subjectOperand, String ruleOperation, String ruleOperand) {
        if (type == DescribeFieldResultWrapper.Type.TypeBoolean) {
            return m_helper.verifyBoolean(subjectOperand, ruleOperation, ruleOperand);
        }

        if (type == DescribeFieldResultWrapper.Type.TypeDouble
            || type == DescribeFieldResultWrapper.Type.TypeCurrency
        ) {
           return m_helper.verifyDouble(subjectOperand, ruleOperation, ruleOperand);
        }
   
        if (type == DescribeFieldResultWrapper.Type.TypeText 
            || type == DescribeFieldResultWrapper.Type.TypePicklist
            || type == DescribeFieldResultWrapper.Type.TypeTextArea
            || type == DescribeFieldResultWrapper.Type.TypeReference
        ) {
            return m_helper.verifyString(subjectOperand, ruleOperation, ruleOperand);
        }

        if (type == DescribeFieldResultWrapper.Type.TypeDate) {
           return m_helper.verifyDate(subjectOperand, ruleOperation, ruleOperand);
        }

        return false;
    }

    public Boolean evaluate(String referenceObject, String referenceFieldName, Object subjectOperand, String ruleOperation, String ruleOperand) {
        DescribeFieldResultWrapper.Type type = getType(referenceObject, referenceFieldName);
        return evaluate(type, subjectOperand, ruleOperation, ruleOperand);
    }

    private DescribeFieldResultWrapper.Type getType(String referenceObject, String referenceFieldName) {
        ISObjectField fld = m_schema.getField(referenceObject, referenceFieldName);
        return fld.getType();
    }
}