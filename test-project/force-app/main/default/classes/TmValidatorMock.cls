@IsTest
public class TmValidatorMock {

    public class ofIDataProvider extends Mock.ofIDataProvider implements TmValidator.IDataProvider {
        public List<TmValidator.ValidationContainerPm> getValidationRules() {
            return (List<TmValidator.ValidationContainerPm>)handleMethodInvocation('getValidationRules');
        }
    }

    public class ofIRepository extends ApexMoq implements TmValidator.IRepository {
        public Map<string, List<String>> getRules() {
            return (Map<string, List<string>>)handleMethodInvocation('getRules');
        }
        public Map<string, Map<string, List<DmTmRule>>> getRuleForObjectAndStage(string objectName, string product) {
            return (Map<string, Map<string, List<DmTmRule>>>)handleMethodInvocation('getRuleForObjectAndStage', new List<Object>{objectName, product});
        }
        public Map<String,Map<String,Map<String,List<DmTmRule>>>> getRulesByObjectByProductByStageByField(String objectName, List<String> products){
            return (Map<String,Map<String,Map<String,List<DmTmRule>>>>)handleMethodInvocation('getRulesByObjectByProductByStageByField', new List<Object>{objectName, products});
        }
    }

    public class ofIDmBuilder extends ApexMoq implements TmValidator.IDmBuilder {
        public List<DmTmRule> build(List<TmValidator.ValidationContainerPm> containerPms) {
            return (List<DmTmRule>)handleMethodInvocation('build', new List<Object>{containerPms});
        }
    }

    public class ofIRuleRunner extends ApexMoq implements TmValidator.IRuleRunner {
        public boolean ValidateRule(DmField dm, Object fieldValue, DmTmRule rule) {
            return (boolean)handleMethodInvocation('ValidateRule', new List<Object>{dm, fieldValue, rule});
        }
        public boolean ValidateCorrelatedValues(Map<DmField, object> fieldMap, Map<DmTmRule, List<DmTmRule>> rules) {
            return (boolean)handleMethodInvocation('ValidateCorrelatedValues', new List<OBject>{fieldMap, rules});
        }
    }

    public class ofIRuleRunnerProvider extends ApexMoq implements TmValidator.IRuleRunnerProvider {
        public Map<string, List<TmValidator.ValidationResults>>  ValidationByStageMetadata(string objectName, string currentStageId, string product, List<DmField> fields) {
            return (Map<string, List<TmValidator.ValidationResults>>)handleMethodInvocation('ValidationByStageMetadata', new List<Object>{objectName, currentStageId, product, fields});
        }
        public Map<string, TmValidator.ValidationResults> ValidationLookup(Map<string, List<TmValidator.ValidationResults>> validationsByStage) {
            return (Map<string, TmValidator.ValidationResults>)handleMethodInvocation('ValidationLookup', new List<Object>{validationsByStage});
        }
        public List<TmValidator.ValidationResult> ValidateRequestForObject(TmValidator.ValidationRequest request, List<DmField> dms) {
            return (List<TmValidator.ValidationResult>)handleMethodInvocation('ValidateRequestForObject', new List<Object>{request, dms});
        }
        public Map<string,List<TmValidator.ValidationResult>> ValidateExistingTmRequest(TM_Service_Request__c req, List<string> stageIds, List<DmField> fields) {
            return (Map<string,List<TmValidator.ValidationResult>>)handleMethodInvocation('ValidateExistingTmRequest', new List<object>{req, stageIds, fields});
        }
        public List<TmValidator.ValidationResultByProductByStage> ValidateTmRequestsByStage(Map<TM_Service_Request__c,List<DmField>> tmRequests, List<String> stageIds, Set<String> products) {
            return (List<TmValidator.ValidationResultByProductByStage>)handleMethodInvocation('ValidateTmRequestsByStage', new List<Object>{tmRequests, stageIDs, products});
        }
        public List<TmValidator.ValidationResultByProductByStage> ValidateTmRequestsByCurrentStage(Map<Tm_Service_Request__c, List<DmField>> tmRequests, Set<string> products){
            return (List<TmValidator.ValidationResultByProductByStage>)handleMethodInvocation('ValidateTmRequestsByCurrentStage', new List<Object>{tmRequests, products});
        }
    }

    public class ofIRuleManager extends ApexMoq implements TmValidator.IRuleManager {
        public Map<DmTmRule,List<DmTmRule>> getGrouped(List<DmTmRule> rules) {
            return (Map<DmTmRule,List<DmTmRule>>)handleMethodInvocation('getGrouped', new List<Object>{rules});
        }
    }
}