public virtual class TmConfigurationFieldBuilder {
    protected DmField build(TM_Service_Configuration_Field__c pm, Decimal sortOrder) {
     
        DmField dm = new DmField();
        if(String.isBlank(pm.Field_Name__c)) {return null;}
        dm.label = pm.Name;
        dm.name = pm.Field_Name__c;
        dm.objectName = pm.Object_Name__c;
        dm.edit = pm.Edit__c;
        dm.view = pm.View__c;
        dm.report = pm.Report__c;
        dm.viewPlacement = pm.View_Placement__c;
        dm.editPlacement = pm.Edit_Placement__c;
		dm.reportPlacement = pm.Report_Placement__c;
        dm.sectionId = pm.TM_Section__c;
        dm.sortBySelectedPlacement = sortOrder;
        dm.Correlated = pm.Correlated__c;
        dm.AlternateName = String.isBlank(pm.Alternate_Field_Name__c)? '':pm.Alternate_Field_Name__c;
        dm.Readonly = pm.Readonly__c;
        return dm;
    }

    protected DmField build(TM_Service_Configuration_Field__c pm,  Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups, Decimal sortOrder, Map<string,ISObjectField> fieldMap) {
        DmField dm = new DmField();
       
        try{
            if(String.isBlank(pm.Object_Name__c)) {return null;}      
            ISObjectField fldMeta = null;
            if(String.isNotBlank(pm.Field_Name__c)){
                string lookupField = string.format('{0}.{1}', new List<String>{ pm.Object_Name__c.tolowercase(), pm.Field_Name__c.tolowercase()});
                fldMeta = fieldMap.get(lookupField);
            }

            dm.label = String.isNotBlank(pm.Field_Name__c)? pm.Name : '';
            dm.name = pm.Field_Name__c;
            dm.objectName = pm.Object_Name__c;
            dm.Type = fldMeta != null ? fldMeta.getType():null;
            dm.HelpText = fldMeta != null ? fldMeta.getInlineHelpText() : null;
        
            dm.edit = pm.Edit__c;
            dm.view = pm.View__c;
            dm.report = pm.Report__c;
            dm.viewPlacement = pm.View_Placement__c;
            dm.editPlacement = pm.Edit_Placement__c;
            dm.reportPlacement = pm.Report_Placement__c;
            dm.sectionId = pm.TM_Section__c;

            dm.SectionGroupName = getGroup(pm, sectionGroups);

            dm.SectionGroupType = getGroupType(pm, sectionGroups);

            dm.sortBySelectedPlacement = sortOrder;
            dm.IsAccessible = fldMeta != null ? fldMeta.isAccessible() : true;
            dm.IsUpdatable = fldMeta != null ? fldMeta.isUpdateable() : true;
            dm.IsCreatable = fldMeta != null ? fldMeta.isCreatable() : null;
            
            dm.Picklist = fldMeta != null ? getPickList(fldMeta) : null;
            dm.Correlated = pm.Correlated__c;
            dm.AlternateName = String.isBlank(pm.Alternate_Field_Name__c)?'': pm.Alternate_Field_Name__c;
            dm.Readonly = pm.Readonly__c;
        }catch(exception ex){
            utility.debug_displayinfo(dm);
        }
        return dm;
    }

    private List<IPicklistEntry> getPickList(ISObjectField fld) {
        if(fld.getType() == DescribeFieldResultWrapper.Type.TypePicklist) {
            return fld.getPicklistValues();
        }
        return null;
    }

    private String getGroup(TM_Service_Configuration_Field__c pm, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
        TM_Service_Configuration_Section_Group__c grp = sectionGroups.get(pm.TM_Section_Group__c);
        if(grp == null) {return '';}

        return String.IsBlank(grp.Name) ? grp.Label__c : grp.Name;
    }

    private String getGroupType(TM_Service_Configuration_Field__c pm, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
        TM_Service_Configuration_Section_Group__c grp = sectionGroups.get(pm.TM_Section_Group__c);
        if(grp == null) {return '';}

        return String.IsBlank(grp.Type__c) ? '' : grp.Type__c;
    }
}