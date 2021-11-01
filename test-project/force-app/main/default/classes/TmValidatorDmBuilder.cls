public class TmValidatorDmBuilder implements TmValidator.IDmBuilder {


	public List<DmTmRule> build(List<TmValidator.ValidationContainerPm> pms) {
		List<DmTmRule> ruleDms = new List<DmTmRule>();
		for(TmValidator.ValidationContainerPm pm : pms) {
			List<DmTmRule> rules = buildOne(pm);
			if(rules != null) {
				ruleDms.addAll(rules);
			}
		}
		return ruleDms;
	}

	private List<DmTmRule> buildOne(TmValidator.ValidationContainerPm pm) {

		List<DmTmRule> dmRules = new List<DmTmRule>();

		for(TmValidator.ValidationDefinationPm defPm : pm.Rules) {
			if(defPm.RuleArtifacts != null){
				for(TM_Service_Request_Validation_Rule__c rulePm : defPm.RuleArtifacts) {
					DmTmRule ruleDm = buildOneOne(pm.Container , defPm.RuleDefinition, rulePm);
					dmRules.add(ruleDm);
				}
			}			
		}

		return dmRules;
	}

	private DmTmRule buildOneOne(TM_Service_Request_Validation_Container__c container, TM_Validation_Rule_Definition__c ruleDef, TM_Service_Request_Validation_Rule__c rulePm) {
		DmTmRule dm = new DmTmRule();
		dm.Id = rulePm.Id;
		dm.Name = ruleDef.Description__c;
		dm.FieldName = rulePm.Field_Name__c;
		if(container != null) {
			dm.ObjectName = container.Object_Name__c;
			dm.StageId = container.TM_Service_Request_Stage__c;
			dm.Product = container.Product__c; 
		}
		dm.Error = rulePm.Error_Text__c;
		dm.Operation = rulePm.Operation__c;
		dm.Operand = rulePm.Operand__c;
		dm.Formula = ruleDef.Formula__c;
		dm.FormulaToken = rulePm.Formula_Token__c;
		dm.Correlated = rulePm.Correlated__c;
		dm.ParentId = ruleDef.Id;
		return dm;
	}
}