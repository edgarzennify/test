public class TmValidatorRepository implements TmValidator.IRepository {

    private List<TmValidator.ValidationContainerPm> VALIDATION_RULES = null;
    private Map<string, List<String>> DM_RULES = null;

    private final TmValidator.IDataProvider m_dataProvider;
    private final TmValidator.IDmBuilder m_dmBuilder;

    public TmValidatorRepository(TmValidator.IDataProvider dataProvider, TmValidator.IDmBuilder dmBuilder) {
        m_dataProvider = dataProvider;
        m_dmBuilder = dmBuilder;
    }

    public Map<string, List<String>> getRules() {
        List<DmTmRule> rules = m_dmBuilder.build(getValidationRules());   
        Map<string, List<String>> ruleFieldValues = buildRulesCached(rules);
        return ruleFieldValues;
    }

    public Map<string, Map<string, List<DmTmRule>>> getRuleForObjectAndStage(string objectName, string product) {
        Map<string, Map<string, List<DmTmRule>>> validationStageRuleMap = new Map<string, Map<string, List<DmTmRule>>>();
        if(String.IsBlank(objectName) || String.IsBlank(product)){return validationStageRuleMap;}
        
        Map<string, List<DmTmRule>> validationRuleMap = new Map<string, List<DmTmRule>>();
        List<DmTmRule> rules = m_dmBuilder.build(getValidationRules());
        List<DmTmRule> filteredRules =new List<DmTmRule>();
        
        Set<string> stages = buildStageLookup(rules, objectName);

        if(rules != null){
            for(string stageId : stages) {
                validationRuleMap = new Map<string, List<DmTmRule>>();
                for(DmTmRule r : rules){

                    if (r.StageId == stageId
                        && r.ObjectName.tolowercase() == objectName.toLowerCase()
                        && r.Product.toLowerCase() == product.toLowerCase()
                            ) {
                        String fieldName = r.FieldName.tolowercase();
                       
                        if(!validationRuleMap.containsKey(fieldName)) {
                            validationRuleMap.put(fieldName, new List<DmTmRule>());
                        }
                        validationRuleMap.get(fieldName).add(r);
                    }
                }
                validationStageRuleMap.put(stageId, validationRuleMap);
            }
        }

        return  validationStageRuleMap;
    }

    public Map<string, Map<string, Map<string, List<DmTmRule>>>> getRulesByObjectByProductByStageByField(string objectName, List<string> products) {
        
        Map<string, Map<string, Map<string, List<DmTmRule>>>> validationStageRuleMapByProduct = new Map<string, Map<string, Map<string, List<DmTmRule>>>>();
        if(String.IsBlank(objectName)){return validationStageRuleMapByProduct;}
       
        List<DmTmRule> rules = m_dmBuilder.build(getValidationRules());
        List<DmTmRule> filteredRules =new List<DmTmRule>();
        
        Set<string> stages = buildStageLookup(rules, objectName);
  
        if(rules != null){
            for(string stageId : stages) {
                for(DmTmRule r : rules){
               
                    if (r.StageId == stageId
                        && r.ObjectName.tolowercase() == objectName.toLowerCase()
                            ) {
                        String fieldName = r.FieldName.tolowercase();
                        string product = r.Product.toLowerCase();
                        if(!validationStageRuleMapByProduct.containsKey(product)){
                            validationStageRuleMapByProduct.put(product, new Map<string, Map<string, List<DmTmRule>>>());
                        }
                        if(!validationStageRuleMapByProduct.get(product).containsKey(stageId)){
                            validationStageRuleMapByProduct.get(product).put(stageId, new Map<string, List<DmTmRule>>());
                        }
                        if(!validationStageRuleMapByProduct.get(product).get(stageId).containskey(fieldName)){
                            validationStageRuleMapByProduct.get(product).get(stageId).put(fieldName, new List<DmTmRule>());
                        }

                        validationStageRuleMapByProduct.get(product).get(stageId).get(fieldName).add(r);
                    }

                }
            }
        }

        return  validationStageRuleMapByProduct;
    }

    private List<TmValidator.ValidationContainerPm> getValidationRules(){
        if(VALIDATION_RULES == null){
            VALIDATION_RULES =   m_dataProvider.GetValidationRules();
        }
        return VALIDATION_RULES;
    }

    private Map<string, List<String>> buildRulesCached(List<DmTmRule> pms) {
        if(DM_RULES == null){
            DM_RULES = buildRules(pms);
        }
        return DM_RULES;
    }

    private Map<string, List<String>> buildRules(List<DmTmRule> ruleDms) {
        Map<string, List<String>> returnedResults = new Map<string, List<String>>();
        Map<string, List<DmTmRule>> validationRuleMap = buildValidationRuleMap(ruleDms);
        if(validationRuleMap != null && validationRuleMap.KeySet().size() > 0) {
            for (string v : validationRuleMap.keySet()) {
                List<string> fieldNames = new List<string>();
                String objectName = getObjectNameFromRuleKey(v);
                List<DataProvider.DynamicQueryFieldResult> dynamicFieldResults = new List<DataProvider.DynamicQueryFieldResult>();
                for (DmTmRule r : validationRuleMap.get(v)){
                    fieldNames.add(r.FieldName);
                }
                returnedResults.put(v, fieldNames);
            }
        }
        return returnedResults;
    }

    private Set<string> buildStageLookup(List<DmTmRule> rules, string objectName) {
        Set<string> stages = new Set<string>();
        if(rules == null || String.isBlank(objectName)){return stages;}
        for(DmTmRule r : rules) {
            if(r.ObjectName.tolowercase() == objectName.toLowerCase()) {
                if(!stages.contains(r.StageId)) {
                    stages.add(r.StageId);
                }
            }
        }
        return stages;
    }

    private Map<string, List<DmTmRule>> buildValidationRuleMap(List<DmTmRule> rules) {
        Map<string, List<DmTmRule>> validationRuleMap = new Map<string, List<DmTmRule>>();
        for (DmTmRule r : rules) {

            string key = String.Format('{0}-{1}-{2}', new List<String>{r.ObjectName, r.StageId, r.Product});
            
            if (!validationRuleMap.containsKey(key)) {
                validationRuleMap.put(key, new List<DmTmRule>());            
            }
            validationRuleMap.get(key).add(r);

        }

        return validationRuleMap;
    }

    private string getObjectNameFromRuleKey(string rule) {
        if(string.IsBlank(rule)){return '';}
        List<String> items = rule.split('-');
        return items[0];
    }
}