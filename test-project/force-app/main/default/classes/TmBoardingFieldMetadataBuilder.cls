public class TmBoardingFieldMetadataBuilder implements TmBoarding.IFieldMetadataBuilder {

    private string REQUEST_OBJ = 'Tm_Service_Request__c';
    private final TmBoarding.IFieldMapManager m_fieldMapManager;

    public TmBoardingFieldMetadataBuilder(TmBoarding.IFieldMapManager fieldMapManager) {
        m_fieldMapManager = fieldMapManager;
    }
    
    public TmBoarding.Field getFieldMetadata(TM_Service_Configuration_Field__c cfgField, TmBoarding.Placement plc, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
        if(cfgField.Field_Name__c == null) return buildBlankField(cfgField, plc, sectionGroups);
        Schema.SObjectField sObjField = m_fieldMapManager.getField(cfgField.Object_Name__c, cfgField.Field_Name__c);
        if(sObjField == null) return null;

        return buildTmField(cfgField, sObjField, plc, sectionGroups);
    }

    public TmBoarding.FieldCategory getCategoryMetadata(List<TM_Service_Configuration_Field__c> parent, List<TM_Service_Configuration_Field__c> related,  Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {      
        TmBoarding.FieldCategory fieldCategory = getCategoryMetadata(parent, sectionGroups);
        fieldCategory.RelatedFields = getCategoryMetadata(related, sectionGroups);

        return fieldCategory;
    }

    public TmBoarding.FieldCategory getCategoryMetadata(List<TM_Service_Configuration_Field__c> fields, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {      
        TmBoarding.FieldCategory fieldCategory = new TmBoarding.FieldCategory();
        fieldCategory.KeyFields = new List<TmBoarding.Field>();
        fieldCategory.ViewFields = new List<TmBoarding.Field>();
        fieldCategory.EditFields = new List<TmBoarding.Field>();
        fieldCategory.ReportFields = new List<TmBoarding.Field>();
        fieldCategory.RelatedFields = new TmBoarding.FieldCategory();

        for(TM_Service_Configuration_Field__c f : fields) {
                if(f.Title__c == true) {
                    fieldCategory.KeyFields.add(buildTextboxField(f, f.Field_Name__c,'', Tmboarding.Placement.Title, sectionGroups));
                }
                if(f.View__c == true) {
                    fieldCategory.ViewFields.add(getFieldMetadata(f, TmBoarding.Placement.View, sectionGroups));
                }
                if(f.Edit__c == true) {
                    fieldCategory.EditFields.add(getFieldMetadata(f, TmBoarding.Placement.Edit, sectionGroups));
                }
                if(f.Report__c == true) {
                    fieldCategory.ReportFields.add(getFieldMetadata(f, TmBoarding.Placement.Report, sectionGroups));
                }
        }

        return fieldCategory;
    }

    private TmBoarding.Field buildTmField(TM_Service_Configuration_Field__c cfgField, Schema.SObjectField field, TmBoarding.Placement plc, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
        String fieldName = m_fieldMapManager.getFieldName(field);
        String helpText = m_fieldMapManager.getFieldHelpText(field);
        Schema.DisplayType fieldType = m_fieldMapManager.getType(field);
        Boolean accessible = m_fieldMapManager.isFieldAccessible(field);
        if(!accessible){return null;}

        return buildTextboxField(cfgField, fieldName, helpText, plc, sectionGroups);
    }

    private TmBoarding.Field buildTextboxField(TM_Service_Configuration_Field__c cfgField, string fieldName, string helpText, TmBoarding.Placement plc, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
        return buildField(cfgField, 'Text', fieldName, helpText, new List<Tmboarding.FieldOption>(), plc, sectionGroups);
    }

    private TmBoarding.Field buildField(TM_Service_Configuration_Field__c cfgField, string inputType, string fieldName, string helpText, List<Tmboarding.FieldOption> options, TmBoarding.Placement plc, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
        TM_Service_Configuration_Section_Group__c sectionGroup = sectionGroups.get(cfgField.TM_Section_Group__c);
        String inputTypeOverride = getInputTypeOverride(sectionGroup, inputType);
        TmBoarding.Field f = new TmBoarding.Field();
        f.InputType = inputTypeOverride;
        f.ObjectName = cfgField.Object_Name__c;
        f.ObjectId = getObjectId(cfgField.Object_Name__c);
        f.Label = cfgField.Name;
        f.Name = getNameField(cfgField.Object_Name__c, fieldName);
        f.HelpText = String.IsBlank(helpText) ? '': helpText;
        f.Multilist = getGroup(sectionGroup);
        f.Correlated = cfgField.Correlated__c;
        f.Readonly = cfgField.Readonly__c;
        f.Options = options;
        if(String.isNotBlank(cfgField.Alternate_Field_Name__c)){
            f.AlternateName = getNameField(cfgField.Object_Name__c, cfgField.Alternate_Field_Name__c);
        }
        f.SortOrder = buildSortOrder(cfgField, plc);

        return f;
    }

    private TmBoarding.Field buildBlankField(TM_Service_Configuration_Field__c cfgField, TmBoarding.Placement plc, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
        TmBoarding.Field f = new TmBoarding.Field();
        f.InputType = 'Blank';
        f.ObjectName = cfgField.Object_Name__c;
        f.ObjectId = getObjectId(cfgField.Object_Name__c);
        f.Label = '';
        f.Name = '';
        f.Multilist = getGroup(sectionGroups.get(cfgField.TM_Section_Group__c));

        f.Correlated = null;
        f.Options = new List<Tmboarding.FieldOption>();
        f.SortOrder = buildSortOrder(cfgField, plc);

        return f;
    }

    private Decimal buildSortOrder(TM_Service_Configuration_Field__c cfgField, TmBoarding.Placement plc) {
        if(plc == TmBoarding.Placement.Edit){
            return cfgField.Edit_Placement__c == null ? 0.0 : cfgField.Edit_Placement__c;
        } else if(plc == TmBoarding.Placement.View) {
            return cfgField.View_Placement__c == null? 0.0 : cfgField.View_Placement__c;
        } else if(plc == TmBoarding.Placement.Report) {
            return cfgField.Report_Placement__c == null? 0.0 : cfgField.Report_Placement__c;
        } 
        return 0.0;
    }

    private String getObjectId(String objectName) {
        return String.IsBlank(objectName) ? '': String.format('{0}.Id', new LIST<String> {objectName});
    }

    private String getNameField(String objectName, String fieldName) {
        return String.IsBlank(objectName) || String.IsBlank(objectName) ? '': String.format('{0}.{1}', new LIST<String> {objectName, fieldName});
    }

    private string getGroup(TM_Service_Configuration_Section_Group__c grp) {
        if(grp == null) {return '';}
        return String.isBlank(grp.Name) ? grp.Label__c : grp.Name;
    }

    private string getInputTypeOverride(TM_Service_Configuration_Section_Group__c sectionGroup, string inputType) {
        if(sectionGroup == null) {return inputType;}
        if(String.isBlank(sectionGroup.Type__c) || sectionGroup.Type__c == 'Multipicklist') {return inputType;}
        return sectionGroup.Type__c;
    }
}