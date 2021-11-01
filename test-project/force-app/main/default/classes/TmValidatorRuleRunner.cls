public class TmValidatorRuleRunner implements TmValidator.IRuleRunner {
    
    private StackFactory.IStackFactory m_stackFactory;
    private final ShuntingYard.IShuntingYard m_algorithm;
    private final ErrorRepository.IErrorRepository m_errors;
    private final RuleEvaluator.IRuleEvaluator m_ruleEvaluator;

    public TmValidatorRuleRunner(ShuntingYard.IShuntingYard algorithm, ErrorRepository.IErrorRepository errors, RuleEvaluator.IRuleEvaluator ruleEvaluator) {
        m_algorithm = algorithm;
        m_errors = errors;
        m_ruleEvaluator = ruleEvaluator;
    }

    public boolean ValidateRule(DmField fieldMetadata, object fieldValue, DmTmRule rule) {
        return m_ruleEvaluator.evaluate(fieldMetadata.Type, fieldValue, rule.Operation, rule.Operand);
    }

    public boolean ValidateCorrelatedValues(Map<DmField, object> fieldMap, Map<DmTmRule, List<DmTmRule>> ruleMap ) {       
        Set<DmTmRule> parentSet = ruleMap.keyset();
        if(parentSet == null) {return false;}
        List<DmTmRule> parentList = new List<DmTmRule>();
        parentList.addAll(parentSet);
        DmTmRule parent = parentList[0];
        String formula = parent.Formula;
        if(string.isBlank(formula)) { return false;}

        Map<string, DmTmRule> ruleByField = buildRuleByFieldName(parent, ruleMap);    
        Map<string, boolean> data = buildAlgorithmData(fieldMap, ruleByField);
        try{
            boolean status = m_algorithm.run(formula, data);
            return status;
        }catch(exception ex) {
            String errorMessage = String.format('Error in validation formula {0} for field {1}', new LIST<String> {formula, parent.fieldName});
            m_errors.addError(errorMessage);
        }

        return false;
    }

    private Map<string, DmTmRule> buildRuleByFieldName(DmTmRule parent, Map<DmTmRule, List<DmTmRule>> ruleMap) {
        Map<string, DmTmRule> ruleByField = new Map<string, DmTmRule>();
        ruleByField.put(parent.FieldName.tolowerCase(), parent);
        for(List<DmTmRule> rList : ruleMap.values()) {
            for(DmTmRule r : rList){
                ruleByField.put(r.FieldName.toLowerCase(), r);
            }
        }
        return ruleByField;
    }

    private Map<string, boolean> buildAlgorithmData(Map<DmField, object> fieldMap, Map<string, DmTmRule> ruleByField) {
        Map<string, boolean> data = new Map<string, boolean>();

        for(DmField fld : fieldMap.keyset()) {
            DmTmRule r = ruleByField.get(fld.name.toLowerCase());
            object currentFieldValue = fieldMap.get(fld);
            boolean isValid = ValidateRule(fld, currentFieldValue, r);
            data.put(r.formulaToken, isValid);
        }
        return data;
    }
}