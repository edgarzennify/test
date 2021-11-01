public class TmConfigurationReportFieldBuilder extends TmConfigurationFieldBuilder implements TmConfiguration.IFieldBuilder {
	
	public TmConfiguration.Placement handle () {
    	return TmConfiguration.Placement.Report;
	}

	public List<DmField> build(List<TM_Service_Configuration_Field__c> pms) {
        List<DmField> dms = new List<DmField>();
        for(TM_Service_Configuration_Field__c pm : pms) {
            if(pm.Report__c == true) {
            	dms.add(build(pm, pm.Report_Placement__c));
            }
        }
        return dms;
    }

    public List<DmField> build(TmConfiguration.DmBuildRequest request) {
        List<DmField> dms = new List<DmField>();
        for(TM_Service_Configuration_Field__c pm : request.ServiceOptionPms) {
            DmField f = build(pm, request.SectionGroupOptions, pm.Report_Placement__c, request.fieldMap);
            if(f != null) {dms.add(f);}
        }
        return dms;
    }

    public List<DmField> build(List<TM_Service_Configuration_Field__c> fields, Map<Id,TM_Service_Configuration_Section_Group__c> groups) {
        return null;
    }
}