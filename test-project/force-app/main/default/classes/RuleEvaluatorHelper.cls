public class RuleEvaluatorHelper implements IRuleEvaluatorHelper {
    
    public interface IRuleEvaluatorHelper {
        Boolean verifyBoolean(Object subjectOperand, String ruleOperation, String ruleOperand);
        Boolean verifyDouble(Object subjectOperand, String ruleOperation, String ruleOperand);
        Boolean verifyString(Object subjectOperand, String ruleOperation, String ruleOperand);
        Boolean verifyDate(Object subjectOperand, String ruleOperation, String ruleOperand);
    }

    public Boolean verifyBoolean(Object subjectOperand, String ruleOperation, String ruleOperand) {
        Boolean subjectOperandValue = subjectOperand == null ? false : Boolean.valueOf(subjectOperand);
        String formattedOperation = String.isBlank(ruleOperand) ? '' : ruleOperand;
        Boolean ruleOperandValue = formattedOperation == '1' || formattedOperation.toLowerCase() == 'true' ? true : false;

        if (ruleOperation == '=') { return subjectOperandValue == ruleOperandValue; }
        if (ruleOperation == '<>') { return subjectOperandValue != ruleOperandValue; }
        return subjectOperandValue == ruleOperandValue;
    }

    public Boolean verifyDouble(Object subjectOperand, String ruleOperation, string ruleOperand) {
        if (ruleOperand == null) { return false; }

        String subjectOperandStringValue = String.valueOf(subjectOperand);
        if (String.isBlank(subjectOperandStringValue)) { return false; }

        if (ruleOperation == '>') { return Double.valueOf(subjectOperand) > Double.valueOf(ruleOperand); }
        if (ruleOperation == '<') { return Double.valueOf(subjectOperand) < Double.valueOf(ruleOperand); }
        if (ruleOperation == '=') { return Double.valueOf(subjectOperand) == Double.valueOf(ruleOperand); }
        if (ruleOperation == '<>') { return Double.valueOf(subjectOperand) != Double.valueOf(ruleOperand); }
        if (ruleOperation == '>=') { return Double.valueOf(subjectOperand) >= Double.valueOf(ruleOperand); }
        if (ruleOperation == '<=') { return Double.valueOf(subjectOperand) <= Double.valueOf(ruleOperand); } 
       
        return false;
    }

    public Boolean verifyString(Object subjectOperand, String ruleOperation, String ruleOperand) {
        String subjectOperandStringValue = String.valueOf(subjectOperand) == null ? '' : String.valueOf(subjectOperand);
        String ruleOperandStringValue = ruleOperand == null ? '' : ruleOperand;  

        if (ruleOperation == '=') { return subjectOperandStringValue == ruleOperandStringValue; }
        if (ruleOperation == '<>') { return subjectOperandStringValue != ruleOperandStringValue; }
        if (ruleOperation == 'in') { 
            if (String.isNotBlank(ruleOperandStringValue) && String.isBlank(subjectOperandStringValue)) {
                return false;
            }
            return ruleOperandStringValue.contains(subjectOperandStringValue);
        }
        if(ruleOperation == 'not in') { return !ruleOperandStringValue.contains(subjectOperandStringValue); }
        return false;
    }

    public Boolean verifyDate(Object subjectOperand, String ruleOperation, String ruleOperand) {
        if (ruleOperand == null) { return false; }
        
        String subjectOperandStringValue = String.valueOf(subjectOperand);
        if (String.isBlank(subjectOperandStringValue)) { return false; }

        if (ruleOperation == '=') { return subjectOperand == Date.parse(ruleOperand); }
        if (ruleOperation == '<>') { return subjectOperand != Date.parse(ruleOperand); }
        if (ruleOperation == '>') { return Date.valueOf(subjectOperand) > Date.parse(ruleOperand); }
        if (ruleOperation == '<') { return Date.valueOf(subjectOperand) < Date.parse(ruleOperand); }
        if (ruleOperation == '>=') { return Date.valueOf(subjectOperand) >= Date.parse(ruleOperand); }
        if (ruleOperation == '<=') { return Date.valueOf(subjectOperand) <= Date.parse(ruleOperand); }              
        return false;
    }
}