public class TmValidatorRuleManager implements TmValidator.IRuleManager {

	public Map<DmTmRule, List<DmTmRule>> getGrouped(List<DmTmRule> dms) {
		Map<DmTmRule, List<DmTmRule>> grouped = new Map<DmTmRule, List<DmTmRule>>();

		Map<string, List<DmTmRule>> parentList = new Map<string, List<DmTmRule>>();
		for(DmTmRule d : dms) {
			if(!parentList.containsKey(d.ParentId)) {
				parentList.put(d.ParentId, new List<DmTmRule>());
			}
			parentList.get(d.ParentId).add(d);
		}

		for(string key : parentList.keyset()) {
			List<DmTmRule> rules = parentList.get(key);
			if(rules != null){
				if(rules.size()> 0){
					List<DmTmRule> rulesFiltered = new List<DmTmRule>();
					for(DmTmRule dm : rules) {
						if(dm.fieldName != rules[0].fieldName) {
							rulesFiltered.add(dm);
						}
					}
					grouped.put(rules[0], rulesFiltered);
				}
			}
		}
		
		return grouped;
	}
}