public class TmValidatorRuleRunnerProvider implements TmValidator.IRuleRunnerProvider {

    private final TmValidator.IRuleRunner m_ruleRunner;
    private final TmValidator.IRepository m_repository;
    private final TmValidator.IRuleManager m_ruleManager;
    private final Utility.IUtility m_util;

    public TmValidatorRuleRunnerProvider(TmValidator.IRuleRunner ruleRunner, TmValidator.IRepository repository, TmValidator.IRuleManager ruleManager, Utility.IUtility util){
        m_ruleRunner = ruleRunner;
        m_repository = repository;
        m_ruleManager = ruleManager;
        m_util = util;
    }

    public Map<string, List<TmValidator.ValidationResults>>  ValidationByStageMetadata(string objectName, string currentStageId, string product, List<DmField> fields) {
        Map<string, List<String>> rules = m_repository.getRules();
        Map<string, Map<string, List<DmTmRule>>> rulesMapByStage = m_repository.getRuleForObjectAndStage(objectName, product);
        Map<string, List<TmValidator.ValidationResults>> returnResultsByStage = ValidationByStage(objectName,  currentStageId,  product, rulesMapByStage, rules,  fields);
        
        return returnResultsByStage;
    }

    public Map<string,List<TmValidator.ValidationResult>> ValidateExistingTmRequest(TM_Service_Request__c req, List<string> stageIds, List<DmField> fields){      
        Map<string, List<TmValidator.ValidationResult>> output = new Map<string,List<TmValidator.ValidationResult>>();
        String product = req.RecordType.Name;
        String objectName = TmConfiguration.TM_REQUEST;


        Map<string, List<String>> rules = m_repository.getRules();

        Map<string, Map<string, List<DmTmRule>>> rulesMapByStage = m_repository.getRuleForObjectAndStage(objectName, product);

        Map<string, List<TmValidator.ValidationResults>> validationsByStage = ValidationByStage(objectName, stageIds[0], product,rulesMapByStage, rules, fields);
        for(string stageId : stageIds) {
             List<TmValidator.ValidationResults> toValidate = validationsByStage.get(stageId);

             if(toValidate != null && toValidate.size() > 0) {
                TmValidator.ValidationRequest vRequest = buildValidationRequest(req, objectName, product, stageId, toValidate);
                List<TmValidator.ValidationResult> results = ValidateRequestForObject(vRequest, fields);
                if(results != null && results.size() > 0){
                    output.put(stageId,results);
                }
             }
        }
        return output;
    }

    public List<TmValidator.ValidationResultByProductByStage> ValidateTmRequestsByCurrentStage(Map<Tm_Service_Request__c, List<DmField>> tmRequests, Set<string> products){
        List<TmValidator.ValidationResultByProductByStage> vldAllResults = new List<TmValidator.ValidationResultByProductByStage>();
        String objectName = TmConfiguration.TM_REQUEST;
         List<String> productList = new List<String>();
        for(string p : products){
            productList.add(p.tolowercase());
        }
        
        Map<string, List<String>> rules = m_repository.getRules();
        Map<string,Map<string, Map<string, List<DmTmRule>>>> rulesMapByProductByStage = m_repository.getRulesByObjectByProductByStageByField(objectName, productList);

        for(Tm_Service_Request__c req: tmRequests.keyset()){
            TmValidator.ValidationResultByProductByStage vldResult = buildValidationResultsByStage(req, req.RecordType.Name, objectName, new List<string>{req.Stage__c}, tmRequests, rulesMapByProductByStage, rules);
        
            if(vldResult.ValidationsByStage != null && vldResult.ValidationsByStage.keyset().size() > 0){
                vldAllResults.add(vldResult);
            }      
        }

        if(vldAllResults != null){vldAllResults.sort();}
        return vldAllResults;
    }

    public List<TmValidator.ValidationResultByProductByStage> ValidateTmRequestsByStage(Map<Tm_Service_Request__c, List<DmField>> tmRequests, List<string> stageIds, Set<string> products){

        List<TmValidator.ValidationResultByProductByStage> vldAllResults = new List<TmValidator.ValidationResultByProductByStage>();
        String objectName = TmConfiguration.TM_REQUEST;
        List<String> productList = new List<String>();
        for(string p : products){
            productList.add(p.tolowercase());
        }

        Map<string, List<String>> rules = m_repository.getRules();

        Map<string,Map<string, Map<string, List<DmTmRule>>>> rulesMapByProductByStage = m_repository.getRulesByObjectByProductByStageByField(objectName, productList);

        for(Tm_Service_Request__c req: tmRequests.keyset()){
            try{
                String product = req.RecordType.Name;
                List<String> allStageIds = getFilteredStages(stageIds, req.Stage__c);
                TmValidator.ValidationResultByProductByStage vldResult = buildValidationResultsByStage(req, product, objectName, allStageIds, tmRequests, rulesMapByProductByStage, rules);
                if(vldResult.ValidationsByStage != null && vldResult.ValidationsByStage.keyset().size() > 0){
                    vldAllResults.add(vldResult);
                }
            }catch(Exception ex){
                utility.debug_displayinfo(ex.getMessage());
            }
            
        }
        if(vldAllResults != null){vldAllResults.sort();}
        return vldAllResults;

    }

    public Map<string, TmValidator.ValidationResults> ValidationLookup(Map<string, List<TmValidator.ValidationResults>> validationsByStage) {
        Map<string, TmValidator.ValidationResults> validationMap = new Map<string, TmValidator.ValidationResults>();
        List<TmValidator.ValidationResults> vResults = new List<TmValidator.ValidationResults>();
        if(validationsByStage == null || validationsByStage.keyset().size() == 0){return validationMap;}
        for(string stageId : validationsByStage.keyset()) {
            List<TmValidator.ValidationResults> currentResults = validationsByStage.get(stageId);
            if(currentResults != null) {
                for(TmValidator.ValidationResults r : currentResults) {
                    if(!validationMap.containsKey(r.FieldName)) {
                        validationMap.put(r.FieldName, r);
                    }
                }
            }
        }
        return validationMap;
    }

    public List<TmValidator.ValidationResult> ValidateRequestForObject(TmValidator.ValidationRequest request, List<DmField> fieldDms) {
        string objectName = request == null ? '' : request.ObjectName;
        Map<string, DmField> fieldMap = getFieldMap(fieldDms);
        return getValidationsWithCorrelated(request, fieldMap);
    }

    private TmValidator.ValidationResultByProductByStage buildValidationResultsByStage(Tm_Service_Request__c req , String product, string objectName, List<string> stageIds, Map<Tm_Service_Request__c, List<DmField>> tmRequestMap,  
                                    Map<string,Map<string, Map<string, List<DmTmRule>>>> rulesMapByProductByStage, Map<string, List<String>> rules){
        String productLowerCase = product.toLowerCase();
        TmValidator.ValidationResultByProductByStage vldResults = new TmValidator.ValidationResultByProductByStage();
        vldResults.Product = product;
        vldResults.ValidationsByStage = new Map<string,List<TmValidator.ValidationResult>>();
        List<DmField> fields = tmRequestMap.get(req);
        Map<string, Map<string, List<DmTmRule>>> rulesMapByStage = rulesMapByProductByStage.get(productLowerCase);
        
        if(rulesMapByStage != null){
            for(string stageId : stageIds) {
                Map<string, List<TmValidator.ValidationResults>> validationsByStage = ValidationByStage(objectName, stageId, productLowerCase,rulesMapByStage, rules,  fields);
                
                 List<TmValidator.ValidationResults> toValidate = validationsByStage.get(stageId);
                
                 if(toValidate != null && toValidate.size() > 0) {
                    TmValidator.ValidationRequest vRequest = buildValidationRequest(req, objectName, product, stageId, toValidate);
                       
                    List<TmValidator.ValidationResult> results = ValidateRequestForObject(vRequest, fields);
                
                    if(results != null && results.size() > 0){
                        vldResults.ValidationsByStage.put(stageId,results);
                    }
                 }
              
            }
        }
        return vldResults;
    }

    private Map<string, List<TmValidator.ValidationResults>>  ValidationByStage(string objectName, string currentStageId, string product, Map<string, Map<string, List<DmTmRule>>> rulesMapByStage, Map<string, List<String>> rules, List<DmField> fields){
        Map<string, List<TmValidator.ValidationResults>> returnResultsByStage = new Map<string, List<TmValidator.ValidationResults>>(); 
        List<TmValidator.ValidationResults> returnResults = new List<TmValidator.ValidationResults>();
        Map<string, DmField> fieldMap = getFieldMap(fields);

        Set<string> fieldTracker = new Set<string>();
        for(string r : rules.keyset()) {
            String ruleObjectName = getObjectNameFromRuleKey(r);

            if(ruleObjectName.tolowercase() == objectName.tolowerCase()) {
               
                List<String> currentRulesForFields = rules.get(r);

                for(String fieldName: currentRulesForFields) {
                    DmField fieldMetadata = fieldMap.get(fieldName.toLowerCase());
                    if(rulesMapByStage != null){
                        for(string stageId : rulesMapByStage.keyset()) {
                            
                            returnResults = buildValidationResults(stageId, fieldName, objectName, currentStageId, fieldMetadata, rulesMapBystage, fieldTracker); 
                    
                            if(returnResults != null || returnResults.size() > 0) {
                                if(!returnResultsByStage.containskey(stageId)) {
                                    returnResultsByStage.put(stageId, new List<TmValidator.ValidationResults>());
                                }
                                returnResultsByStage.get(stageId).addAll(returnResults);
                            }
                            
                        }
                    }                       
                }
               
            }
             
        }
        
        return returnResultsByStage; 
    }

    private List<TmValidator.ValidationResults> buildValidationResults(string stageId, string fieldName, string objectName, string currentStageId, DmField fieldMetadata, Map<string, Map<string, List<DmTmRule>>> rulesMapByStage, Set<string> fieldTracker) {
        List<TmValidator.ValidationResults> returnResults = new List<TmValidator.ValidationResults>();
        Map<string, List<DmTmRule>> rulesByStage =  rulesMapByStage.get(stageId);
        List<DmTmRule> rulesList = rulesByStage.get(fieldName.tolowercase());

        if(rulesList != null){
            for(DmTmRule vr : rulesList) {

                if(fieldMetadata != null){          
                    if (vr != null ) {
                        if(vr.FieldName.tolowerCase() == fieldName.toLowerCase() ){
                            TmValidator.ValidationResults vResults = new TmValidator.ValidationResults();
                            vResults.Error = vr.Error;
                            vResults.FieldName = fieldName;
                            vResults.ObjectName = objectName;
                            vResults.StageId = stageId;
                            vResults.IsCurrentStage = stageId == currentStageId;
                            vResults.Correlated = vr.Correlated;
                            vResults.Id = vr.Id;
                            vResults.ParentId = vr.ParentId;
                            string fieldLookup = string.format('{0}.{1}', new List<string>{objectName.toLowerCase(), fieldName.tolowercase()});
                            if(!fieldTracker.contains(fieldLookup)){
                                returnResults.add(vResults);
                                fieldTracker.add(fieldLookup);
                            }
                            
                        }
                    }
                }
            }
        } 

        return returnResults;
    }

    private string getField(string objectName, string fieldNameWithObjectName) {
        string fieldName = fieldNameWithObjectName;
        if(string.isBlank(fieldName)){return '';}
        fieldName = fieldName.replace(objectName, '');
        fieldName = fieldName.replace('.', '');
        return fieldName;
    }

    private string getFieldLowerCase(string objectName, string fieldNameWithObjectName) {
        return getField(objectName, fieldNameWithObjectName).tolowerCase();
    }

    private Map<string, DmField> getFieldMap(List<DmField> fields) {
        Map<string, DmField> fieldMap = new Map<string, DmField>();
        for(DmField f : fields) {
            if(String.IsNotBlank(f.Name)){
                fieldMap.put(f.Name.tolowerCase(), f);
            }
        }
        return fieldMap;
    }

    private string getObjectNameFromRuleKey(string rule) {
        if(string.IsBlank(rule)){return '';}
        List<String> items = rule.split('-');
        return items[0];
    } 

    public List<TmValidator.ValidationResult> getValidationsWithCorrelated(TmValidator.ValidationRequest req, Map<string, DmField> fieldMap) {
        List<TmValidator.ValidationResult> results = new List<TmValidator.ValidationResult>();
        if(req == null || req.Fields == null || req.Fields.size() == 0 || fieldMap.keyset().size() == 0){return results;}
        Map<string, Map<string, List<DmTmRule>>> rulesMapByFieldNameAndStage = m_repository.getRuleForObjectAndStage(req.objectName, req.product);
        Map<string, List<DmTmRule>> rulesMapByFieldName = rulesMapByFieldNameAndStage.get(req.stageId);

        Map<DmTmRule, List<DmTmRule>> ruleParentChildMap = buildParentChildMap(rulesMapByFieldName);
        List<List<DmTmRule>> children = new List<List<DmTmRule>>();
        if(ruleParentChildMap != null){
            children = ruleParentChildMap.values();
        }
        Set<string> childrenLookup = new Set<string>();
        for(List<DmTmRule> lst : children){
            for(DmTmRule t : lst) {
                String key = String.format('{0}.{1}', new LIST<String>{t.objectName, t.fieldName});
                childrenLookup.add(key.tolowercase());
            }
        }

        Map<DmField, object> fieldValueMap = buildFieldValueMap(req, fieldMap);
     
        if(rulesMapByFieldName != null) {
            for(TmValidator.ValidationRequestItem vrt : req.Fields) {
                string fieldName = getFieldLowerCase(req.objectName, vrt.FieldName);
                List<DmTmRule> rules = rulesMapByFieldName.get(fieldName); 
                if(rules != null) {
                    boolean valid = true;
                    TmValidator.ValidationResult r = new TmValidator.ValidationResult();
                    for(DmTmRule rule : rules) {
                        DmField dm = fieldMap.get(fieldName);                       
                        List<DmTmRule> childs = ruleParentChildMap.get(rule);
                        boolean currentValid = true;
                        if(childs == null || childs.size() == 0) {
                            currentValid = m_ruleRunner.ValidateRule(dm, vrt.FieldValue, rule);
                        } else {
                            Map<DmTmRule, List<DmTmRule>> currentRules = new Map<DmTmRule, List<DmTmRule>>();
                            currentRules.put(rule, childs);
                            Map<DmField, object> fieldValueMapLocal = new Map<DmField, object>();
                            for(DmTmRule ch : childs) {
                                DmField fld = fieldMap.get(ch.fieldName.tolowercase());
                                if(fieldValueMap.containskey(fld)) {
                                    object obj = fieldValueMap.get(fld);
                                    fieldValueMapLocal.put(fld, obj);
                                }
                            }
                            DmField parentfld = fieldMap.get(rule.FieldName.toLowerCase());
                            if(parentFld != null) {fieldValueMapLocal.put(parentfld, fieldValueMap.get(parentFld));}
                            currentValid = m_ruleRunner.ValidateCorrelatedValues(fieldValueMapLocal, currentRules);
                                   
                        }
 
                        if(currentValid == false) {
                            valid = false;
                            r.Error = rule.Error;
                        }
                    }
                    r.ObjectName = req.ObjectName;
                    r.stageId = req.stageId;
                    r.FieldName = vrt.FieldName;
                    r.IsValid = valid;
                    r.Product = req.Product;
                    results.add(r);
                }                
            }
        }

        List<TmValidator.ValidationResult> filteredResults = new List<TmValidator.ValidationResult>();
        for(TmValidator.ValidationResult r : results) {
            if(!childrenLookup.contains(r.FieldName.toLowerCase())) {
                filteredResults.add(r);
            }
        }

        return filteredResults;
    }

    private Map<DmTmRule, List<DmTmRule>> buildParentChildMap( Map<string, List<DmTmRule>> rulesMapByFieldName ) {
        
        List<List<DmTmRule>> allRulesByStage = rulesMapByFieldName.values();
        List<DmTmRule> allRulesByStageConsolidated = new List<DmTmRule>();
        for(List<DmTmRule> l : allRulesByStage) {
            allRulesByStageConsolidated.addAll(l);
        }

        return m_ruleManager.getGrouped(allRulesByStageConsolidated);
    }

    private Map<DmField, object> buildFieldValueMap(TmValidator.ValidationRequest req, Map<string, DmField> fieldMap) {
        Map<DmField, object> fieldValueMap = new Map<DmField, object>();
        for(TmValidator.ValidationRequestItem vrt : req.Fields) {
            string f = getFieldLowerCase(req.objectName, vrt.FieldName);
            DmField fld = fieldMap.get(f);
            if(fld != null && !fieldValueMap.containsKey(fld)) {          
                fieldValueMap.put(fld, vrt.FieldValue);
            }
        }
        return fieldValueMap;
    }

    private TmValidator.ValidationRequest buildValidationRequest( TM_Service_Request__c req, string objectName, string product, string stageId, List<TmValidator.ValidationResults> toValidate){
        TmValidator.ValidationRequest vRequest = new TmValidator.ValidationRequest();
        vRequest.ObjectName = objectName;
        vRequest.Product = product;
        vRequest.RequestId = req.Id;
        vRequest.StageId = stageId;
        vRequest.Fields = new List<TmValidator.ValidationRequestItem>();

        for(TmValidator.ValidationResults v : toValidate) {
            TmValidator.ValidationRequestItem item = new TmValidator.ValidationRequestItem();
            item.FieldName = String.format('{0}.{1}', new List<string>{TmConfiguration.TM_REQUEST ,v.FieldName});
            item.FieldValue = req.get(v.FieldName);
            vRequest.Fields.add(item);
        }

        return vRequest;
    }

    private List<string> getFilteredStages(List<string> stageIds, Id currentProductStageId){
        if(currentProductStageId == null){return stageIds;}
        String stageId = m_util.convertid15ToId18(currentProductStageId);
        List<string> allStages = new List<string>();
        if(stageIds != null && stageIds.size() > 0){
            allStages.addAll(stageIds);
        }
        allStages.add(stageId);
        Set<string> allStageSet = new Set<string>(allStages);
        return new List<string>(allStageSet);
    }
}