public class TmConfigurationDmBuilder implements TmConfiguration.IDmBuilder {
    
    private final List<TmConfiguration.IFieldBuilder> m_fieldBuilders;
    private final TmConfiguration.ISectionBuilder m_sectionBuilder;

    public TmConfigurationDmBuilder(List<TmConfiguration.IFieldBuilder> fieldBuilders , TmConfiguration.ISectionBuilder sectionBuilder) {
        m_fieldBuilders = fieldBuilders;
        m_sectionBuilder =  sectionBuilder;
    }

    public List<DmSection> buildSections(List<TM_Service_Configuration_Field__c> serviceOptionPms, Map<Id,TM_Service_Configuration_Section__c> sectionOptionPms, TmConfiguration.Placement placement) {
        TmConfiguration.IFieldBuilder fieldBuilder = locate(placement);
        List<DmField> fields = fieldBuilder.build(serviceOptionPms);
        List<DmSection> sections = m_sectionBuilder.build(fields, sectionOptionPms);
        return sections;
    }

    public List<DmSection> buildSections(TmConfiguration.DmBuildRequest request) {   
        TmConfiguration.IFieldBuilder fieldBuilder = locate(request.placement);
        List<DmField> fields = fieldBuilder.build(request);

        if(fields != null){fields.sort();}
        List<DmSection> sections = m_sectionBuilder.build(fields, request);
        if(sections != null){sections.sort();}
        return sections;
    }

    public DmSection buildObjectFields(List<ISobjectField> fields, String objectName) {

        List<DmField> relatedfields = new List<DmField>();
        for(ISobjectField fld : fields) {
            DmField dm = new DmField();
            IDescribeFieldResult fieldMetadata = fld.getDescribe();
            dm.name = fieldMetadata.getName();
            dm.label = fieldMetadata.getLabel();
            dm.ObjectName = objectName;
            dm.Type = fieldMetadata.getType();
            dm.IsUpdatable = fieldMetadata.isUpdateable();
            dm.IsCreatable = fieldMetadata.isCreateable();
            dm.IsAccessible = fieldMetadata.isAccessible();
            relatedfields.add(dm);
        }
        return buildSection(objectName, relatedFields);
    }

    public TmConfiguration.ProductInfo buildProductInfo(Tm_Service_Request__c pm, TM_Service_Configuration__c cfg) {
            TmConfiguration.ProductInfo info = new TmConfiguration.ProductInfo();          
            info.productType = new DmRecordType();
            info.productType.Id = pm.RecordTypeId;
            info.productType.name = pm.RecordType.Name;
            info.requestId = pm.Id;
            info.configId = cfg.id;
            info.templateFileName = cfg.Template_File__c;
            info.tmScreenTemplateFileName = cfg.TM_Screen_Template__c;
            info.contactSummaryReportTemplateName = cfg.Contact_Summary_Report_Template__c;
            info.userBoardingTemplateName = cfg.User_Boarding_Template2__c;
            info.masterAgreementTemplateName = cfg.Master_Service_Agreement__c;
            info.footerTemplateId = cfg.Footer_Template__c;
            info.primarySignerCode = cfg.Digital_Signature_Primary_Signer_Code__c;
            info.secondarySignerCode = cfg.Digital_Signature_Secondary_Signer_Code__c;
            info.tmoSignerCode = cfg.Digital_Signature_Tmo_Signer_Code__c;
            info.requiresInitialSignature = cfg.Digital_Signature_Requires_Initial__c;   
            return info;
    }

    private DmSection buildSection(String objectName, List<DmField> fields) {
        DmSection section = new DmSection();
        section.name = objectName;
        section.fields = fields;
        return section;
    }

    private TmConfiguration.IFieldBuilder locate(TmConfiguration.Placement placement) {
        for(TmConfiguration.IFieldBuilder fb: m_fieldBuilders) {
            if(fb.handle() == placement) return fb;
        }
        return null;
    } 
}