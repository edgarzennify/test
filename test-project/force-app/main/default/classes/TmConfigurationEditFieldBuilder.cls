public class TmConfigurationEditFieldBuilder extends TmConfigurationFieldBuilder implements TmConfiguration.IFieldBuilder {
    
    public TmConfiguration.Placement handle () {
        return TmConfiguration.Placement.Edit;
    }

    public List<DmField> build(List<TM_Service_Configuration_Field__c> pms) {
        List<DmField> dms = new List<DmField>();
        for(TM_Service_Configuration_Field__c pm : pms) {
            if(pm.Edit__c == true ) {
                DmField f = build(pm, pm.Edit_Placement__c);
                if(f != null) {dms.add(f);}
            }
        }
        return dms;
    }

    public List<DmField> build(TmConfiguration.DmBuildRequest request) {
        List<DmField> dms = new List<DmField>();
        for(TM_Service_Configuration_Field__c pm : request.ServiceOptionPms) {
            DmField f = build(pm, request.SectionGroupOptions, pm.Edit_Placement__c, request.fieldMap);
            if(f != null) {dms.add(f);}
        }
        return dms;
    }
}