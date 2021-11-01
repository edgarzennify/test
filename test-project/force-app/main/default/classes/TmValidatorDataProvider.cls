public class TmValidatorDataProvider extends DataProvider implements TmValidator.IDataProvider {
    
    public List<TmValidator.ValidationContainerPm> getValidationRules() {
        List<TM_Service_Request_Validation_Container__c> containerPms = 
        [
            SELECT
                Id
                ,Name
                ,Active__c
                ,Object_Name__c
                ,Product__c
                ,TM_Service_Request_Stage__c
                ,(
                    SELECT
                        Id
                        ,Description__c
                        ,Formula__c
                    FROM
                        TM_Validation_Rule_Definitions__r
                    WHERE
                        Active__c = true
                )
            FROM
                TM_Service_Request_Validation_Container__c
            WHERE
                Active__c = true
        ];


        List<TM_Service_Request_Validation_Rule__c> rulePms = 
        [
            SELECT
                Id
                ,Error_Text__c
                ,Field_Name__c
                ,Operand__c
                ,Operation__c
                ,Formula_Token__c
                ,TM_Validation_Rule_Definition__c
                ,TM_Validation_Rule_Definition__r.Name
                ,TM_Validation_Rule_Definition__r.Description__c
                ,TM_Validation_Rule_Definition__r.Formula__c
                ,Correlated__c
            FROM
                TM_Service_Request_Validation_Rule__c
        ];

        Map<Id, List<TM_Service_Request_Validation_Rule__c>> ruleMap = buildRuleMap(rulePms);

        List<TmValidator.ValidationContainerPm> containers = new List<TmValidator.ValidationContainerPm>();

        for(TM_Service_Request_Validation_Container__c containerPm : containerPms) {
           TmValidator.ValidationContainerPm pm = new TmValidator.ValidationContainerPm();
           pm.Container = containerPm;
           pm.Rules = buildRules(containerPm.TM_Validation_Rule_Definitions__r, ruleMap);
           containers.add(pm);
        }

        return containers;
    }

    private List<TmValidator.ValidationDefinationPm> buildRules(List<TM_Validation_Rule_Definition__c> definitionPms, Map<Id, List<TM_Service_Request_Validation_Rule__c>> ruleMap) {
        List<TmValidator.ValidationDefinationPm> definitions = new List<TmValidator.ValidationDefinationPm>();
        for(TM_Validation_Rule_Definition__c pm : definitionPms) {
            TmValidator.ValidationDefinationPm vPm = new TmValidator.ValidationDefinationPm();
            vPm.RuleDefinition = pm;
            vPm.RuleArtifacts = ruleMap.get(pm.Id);
            definitions.add(vPm);
        }
        return definitions;
    }

    private Map<Id, List<TM_Service_Request_Validation_Rule__c>> buildRuleMap(List<TM_Service_Request_Validation_Rule__c> rulePms) {
        Map<Id, List<TM_Service_Request_Validation_Rule__c>> ruleMap = new Map<Id, List<TM_Service_Request_Validation_Rule__c>>();

        for(TM_Service_Request_Validation_Rule__c rulePm : rulePms) {
            if(!ruleMap.containsKey(rulePm.TM_Validation_Rule_Definition__c)){
                ruleMap.put(rulePm.TM_Validation_Rule_Definition__c, new List<TM_Service_Request_Validation_Rule__c>());

            }
            ruleMap.get(rulePm.TM_Validation_Rule_Definition__c).add(rulePm);
        }

        return ruleMap;
    }
}