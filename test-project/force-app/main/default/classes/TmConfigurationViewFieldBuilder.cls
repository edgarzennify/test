public class TmConfigurationViewFieldBuilder extends TmConfigurationFieldBuilder implements TmConfiguration.IFieldBuilder {

	public TmConfiguration.Placement handle() {
    	return TmConfiguration.Placement.View;
	}

	public List<DmField> build(List<TM_Service_Configuration_Field__c> pms) {
        List<DmField> dms = new List<DmField>();
        for(TM_Service_Configuration_Field__c pm : pms) {
            if(pm.View__c == true) {
                DmField f = build(pm, pm.View_Placement__c);
            	if(f != null) {dms.add(f);}
            }
        }
        return dms;
    }

    public List<DmField> build(TmConfiguration.DmBuildRequest request) {
        List<DmField> dms = new List<DmField>();
        for(TM_Service_Configuration_Field__c pm : request.ServiceOptionPms) {
            DmField f = build(pm, request.SectionGroupOptions, pm.View_Placement__c, request.fieldMap);
            if(f != null) {dms.add(f);}
        }
        return dms;
    }

    //public List<DmField> build(List<TM_Service_Configuration_Field__c> pms, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
    //    List<DmField> dms = new List<DmField>();
    //    for(TM_Service_Configuration_Field__c pm : pms) {
    //        DmField f = build(pm, sectionGroups, pm.View_Placement__c);
    //        if(f != null) {dms.add(f);}
    //    }
    //    return dms;
    //}
}