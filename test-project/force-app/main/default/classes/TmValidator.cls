global class TmValidator {

    public interface IDataProvider extends DataProvider.IDataProvider {
        List<ValidationContainerPm> getValidationRules();
    }

    public interface IRepository {
        Map<string, List<String>> getRules();
        Map<string, Map<string, List<DmTmRule>>> getRuleForObjectAndStage(string objectName, string product);
        Map<string, Map<string, Map<string, List<DmTmRule>>>> getRulesByObjectByProductByStageByField(string objectName, List<string> products);
    }

    public interface IDmBuilder {
        List<DmTmRule> build(List<TmValidator.ValidationContainerPm> pms);
    }

    public interface IRuleRunner {
        boolean ValidateRule(DmField fieldMetadata, object fieldValue, DmTmRule rule);
        boolean ValidateCorrelatedValues(Map<DmField, object> fieldMap, Map<DmTmRule, List<DmTmRule>> ruleMap );
    }
    
    public interface IRuleRunnerProvider {        
        Map<string, ValidationResults> ValidationLookup(Map<string, List<ValidationResults>> validationsByStage);
        Map<string, List<ValidationResults>>  ValidationByStageMetadata(string objectName, string currentStageId, string product, List<DmField> fields);
        List<ValidationResult> ValidateRequestForObject(ValidationRequest request, List<DmField> fields);
        Map<string, List<TmValidator.ValidationResult>> ValidateExistingTmRequest(TM_Service_Request__c req, List<string> stageIds, List<DmField> fields);
        List<TmValidator.ValidationResultByProductByStage> ValidateTmRequestsByStage(Map<Tm_Service_Request__c, List<DmField>> tmRequests, List<string> stageIds, Set<string> products);
        List<TmValidator.ValidationResultByProductByStage> ValidateTmRequestsByCurrentStage(Map<Tm_Service_Request__c, List<DmField>> tmRequests, Set<string> products);
    }

    public interface IRuleManager {
        Map<DmTmRule, List<DmTmRule>> getGrouped(List<DmTmRule> dms);
    }

    public class ValidationResults {
        public string Id {get;set;}
        public string ObjectName {get;set;}
        public string FieldName {get;set;}
        public string StageId {get;set;}
        public boolean IsCurrentStage {get;set;}
        public string ParentId {get;set;}
        public boolean Correlated {get;set;}
        public string Error {get;set;}
    }

    global class ValidationRequest {
        public string ObjectName {get;set;}
        public string StageId {get;set;}
        public string Product {get;set;}
        public string RequestId {get;set;}
        public List<ValidationRequestItem> Fields {get;set;}
    }

    public class ValidationRequestItem {
        public string FieldName {get;set;}
        public object FieldValue {get;set;}
    }

    global class ValidationResult {
        public string ObjectName {get;set;}
        public string Product {get;set;}
        public string FieldName {get;set;}
        public string StageId {get;set;}
        public string Error {get;set;}
        public boolean IsValid {get;set;}
    }

    public class ValidationResultByProductByStage implements Comparable{
        public String Product{get;set;}
        public Map<string, List<TmValidator.ValidationResult>> ValidationsByStage{get;set;}

        public Integer compareTo(Object compareTo) {
            ValidationResultByProductByStage other = (ValidationResultByProductByStage) compareTo;
            if (Product < other.Product) return -1;
            if (Product == other.Product) return 0;
            return 1;
        }
    } 

    public class ValidationContainerPm {
        public TM_Service_Request_Validation_Container__c Container{get;set;}
        public List<ValidationDefinationPm> Rules{get;set;}
    }

    public class ValidationDefinationPm {
        public TM_Validation_Rule_Definition__c RuleDefinition{get;set;}
        public List<TM_Service_Request_Validation_Rule__c> RuleArtifacts{get;set;}
    }

    public class ValidationByProductAndStageException extends Exception { }
}