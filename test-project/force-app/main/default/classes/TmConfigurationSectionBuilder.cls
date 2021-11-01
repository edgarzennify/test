public class TmConfigurationSectionBuilder implements TmConfiguration.ISectionBuilder {
    public List<DmSection> build(List<DmField> fieldDms, Map<Id,TM_Service_Configuration_Section__c> lookup) {
		List<DmSection> dms = new List<DmSection>();
    	Map<TM_Service_Configuration_Section__c , List<DmField>> sectionHolder = getSectionHolder(fieldDms, lookup);

    	for(TM_Service_Configuration_Section__c key : sectionHolder.keySet()) {
    		List<DmField> fields = sectionHolder.get(key);
    		dms.add(buildOne(key, fields, '', ''));
    	}

        return dms;
    }

	public List<DmSection> build(List<DmField> fieldDms, TmConfiguration.DmBuildRequest req){
		List<DmSection> dms = new List<DmSection>();
		Map<TM_Service_Configuration_Section__c , List<DmField>> sectionHolder = getSectionHolder(fieldDms, req.sectionOptionPms);

    	for(TM_Service_Configuration_Section__c key : sectionHolder.keySet()) {
    		List<DmField> fields = sectionHolder.get(key);
			DmSection s = buildOne(key, fields, req.Type, req.Label);			
    		dms.add(s);
    	}
        return dms;
	}

	private Map<TM_Service_Configuration_Section__c, List<DmField>> getSectionHolder(List<DmField> fieldDms, Map<Id, TM_Service_Configuration_Section__c> lookup){

    	Map<TM_Service_Configuration_Section__c , List<DmField>> sectionHolder = new Map<TM_Service_Configuration_Section__c , List<DmField>>();
    	for(DmField dm : fieldDms) {
    		TM_Service_Configuration_Section__c pm = lookup.get(dm.sectionId);
    		TM_Service_Configuration_Section__c key = pm == null ? blankSection() : pm;
			if(!sectionHolder.containsKey(key)) {
				sectionHolder.put(key,new List<DmField>());
			}
			sectionHolder.get(key).add(dm);
    	}
		return sectionHolder;
	}

    private DmSection buildOne(TM_Service_Configuration_Section__c pm, List<DmField> fieldDms, string sectype, string label) {
    	DmSection dm = new DmSection();
    	dm.name = string.isBlank(pm.Label__c) ? pm.Name : pm.Label__c;
		dm.label = label;
    	dm.columns = pm.Number_Of_Columns__c;
    	dm.placement = pm.Placement__c == null? 0.00 :pm.Placement__c;
    	dm.show = pm.Show__c;
        dm.Id = pm.Id;
		dm.Type = sectype;
    	dm.fields = fieldDms;
    	return dm;
    }

    private TM_Service_Configuration_Section__c blankSection() {
    	TM_Service_Configuration_Section__c blankSection = new TM_Service_Configuration_Section__c(Name = '.', Show__c = false, Number_Of_Columns__c = 2, Placement__c = 0.00);
    	return blankSection;
    }
}