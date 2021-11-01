public class TmConfigurationRepository implements TmConfiguration.IRepository {

    private Map<String, TmBoarding.RequestConfigPm> m_dynamicConfigsMap;

    private final TmBoarding.IDataProvider m_dataProvider;
    private final TmConfiguration.IDmBuilder m_dmBuilder;
    private final ISchema m_schema;
    private final TmConfiguration.IQueryBuilder m_queryBuilder;
    private final AttachmentHandler.IAttachmentHandler m_attachmentProvider;

    public TmConfigurationRepository(TmBoarding.IDataProvider dataProvider, TmConfiguration.IDmBuilder dmBuilder, ISchema schema, TmConfiguration.IQueryBuilder queryBuilder, AttachmentHandler.IAttachmentHandler attachmentProvider) {
        m_dataProvider = dataProvider;
        m_dmBuilder = dmBuilder;
        m_schema = schema;
        m_queryBuilder = queryBuilder;
        m_attachmentProvider = attachmentProvider;
    }

    public List<DmSection> getDetailSections(String recordTypeName, TmConfiguration.Placement placement) {
        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);
        List<DmSection> dms = m_dmBuilder.buildSections(meta.serviceOptionPms, meta.sectionOptionPms, placement);
        return dms;
    }

    public List<DmSection> getDetailSections2(String recordTypeName, TmConfiguration.Placement placement) {

        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);

        Map<string, ISObjectField> fieldMapCore = buildUpdatedKeys(TmConfiguration.TM_REQUEST);
        Map<string, ISObjectField> fieldMapRelated = buildUpdatedKeys(TmConfiguration.TM_REQUEST_PACKET);
        Map<string, ISObjectField> fieldMap = new Map<string, ISObjectField>();
        fieldMap.putAll(fieldMapCore);
        fieldMap.putAll(fieldMapRelated);

        TmConfiguration.DmBuildRequest req = buildRequest(fieldMap, meta, placement);
        List<DmSection> dms = m_dmBuilder.buildSections(req);

        return dms;
    }

    public List<DmSection> getScheduleSections(String recordTypeName, TmConfiguration.Placement placement) {
        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);
        List<DmSection> sections = new List<DmSection>();
        for(TmBoarding.RequestScheduleConfigPm cfg : meta.schedulePms) {
            List<DmSection> scheduleSections = m_dmBuilder.buildSections(cfg.serviceSchedulePms , meta.sectionOptionPms, placement);
            updateSchedule(cfg, scheduleSections);
            sections.addAll(scheduleSections);
        }
        return sections;
    }

    public List<DmSection> getScheduleSections2(String recordTypeName, TmConfiguration.Placement placement) {
        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);
        List<DmSection> sections = new List<DmSection>();

        Map<string, ISObjectField> fieldMapCore = buildUpdatedKeys(TmConfiguration.TM_REQUEST);
        Map<string, ISObjectField> fieldMapRelated = buildUpdatedKeys(TmConfiguration.TM_REQUEST_PACKET);
        Map<string, ISObjectField> fieldMap = new Map<string, ISObjectField>();
        fieldMap.putall(fieldMapCore);
        fieldMap.putall(fieldMapRelated);
        for(TmBoarding.RequestScheduleConfigPm cfg : meta.schedulePms) {
            TmConfiguration.DmBuildRequest req = buildScheduleRequest(fieldMap,meta,cfg, placement);
            List<DmSection> scheduleSections = m_dmBuilder.buildSections(req);
            updateSchedule(cfg, scheduleSections);
            sections.addAll(scheduleSections);
        }

        return sections;
    }

    public List<DmSection> getContactSections(String recordTypeName, TmConfiguration.Placement placement) {
        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);
        TmConfiguration.DmBuildRequest req = build('',meta, placement);
        return m_dmBuilder.buildSections(meta.contactOptionPms, meta.sectionOptionPms, placement);
    }

    public List<DmSection> getContactSections2(String recordTypeId, TmConfiguration.Placement placement) {
        String recordTypeName = getRecordTypeName(new TM_Service_Request__c(RecordTypeId = recordTypeId));

        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);
        Map<string, ISObjectField> fieldMapCore = buildUpdatedKeys(TmConfiguration.CORE_CONTACT);
        Map<string, ISObjectField> fieldMapRelated = buildUpdatedKeys(TmConfiguration.TM_REQUEST_CONTACT);
        Map<string, ISObjectField> fieldMap = new Map<string, ISObjectField>();
        fieldMap.putAll(fieldMapCore);
        fieldMap.putAll(fieldMapRelated);
        TmConfiguration.DmBuildRequest req = buildContact(fieldMap,meta, placement);
        
        return m_dmBuilder.buildSections(req);
    }

    public List<DmSection> getAccountSections(String recordTypeName, TmConfiguration.Placement placement) {
        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);
        TmConfiguration.DmBuildRequest req = build('',meta, placement);
        return m_dmBuilder.buildSections(meta.accountOptionPms, meta.sectionOptionPms, placement);
    }

    public List<DmSection> getAccountSections2(String recordTypeId, TmConfiguration.Placement placement) {
        String recordTypeName = getRecordTypeName(new TM_Service_Request__c(RecordTypeId = recordTypeId));

        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);

        Map<string, ISObjectField> fieldMapCore = buildUpdatedKeys(TmConfiguration.CORE_ACCOUNT);
        Map<string, ISObjectField> fieldMapRelated = buildUpdatedKeys(TmConfiguration.TM_REQUEST_ACCOUNT);
        Map<string, ISObjectField> fieldMap = new Map<string, ISObjectField>();
        fieldMap.putAll(fieldMapCore);

        fieldMap.putAll(fieldMapRelated);

        TmConfiguration.DmBuildRequest req = buildAccount(fieldMap,meta, placement);
                                
        List<DmSection> sections = m_dmBuilder.buildSections(req);
        
        return sections;
    }


    private Map<string, ISObjectField> buildUpdatedKeys(string objectName) {
        Map<string, ISObjectField> fieldMap = new Map<string, ISObjectField>();
        Map<string, ISObjectField> oldfieldMap = m_schema.getFieldMap(objectName);

        for(string key : oldFieldMap.keyset()){
            string k = String.format('{0}.{1}', new LIST<String>{objectName.toLowerCase(), key} );
            fieldMap.put(k, oldFieldMap.get(key));
        }
        
        return fieldMap;
    }

    public List<DmSection> getContactAccountSections(String recordTypeName, TmConfiguration.Placement placement) {
        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);
        TmConfiguration.DmBuildRequest req = build('',meta, placement);
        return m_dmBuilder.buildSections(meta.contactAccountOptionPms, meta.sectionOptionPms, placement);
    }

    public List<DmSection> getContactAccountSections2(String recordTypeName, TmConfiguration.Placement placement) {
        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);
        Map<string, ISObjectField> fieldMapRelated = buildUpdatedKeys(TmConfiguration.TM_REQUEST_CONTACT_ACCOUNT);
        TmConfiguration.DmBuildRequest req = buildContactAccount(fieldMapRelated,meta, placement);
        
        return m_dmBuilder.buildSections(req);
    }

    public Map<String, DmSection> getAllObjectSections() {
        Map<String, DmSection> objectSections = new Map<String, DmSection>();
        objectSections.put(TmConfiguration.CORE_CONTACT, m_dmBuilder.buildObjectFields(m_schema.getFields(TmConfiguration.CORE_CONTACT), TmConfiguration.CORE_CONTACT));
        objectSections.put(TmConfiguration.CORE_ACCOUNT, m_dmBuilder.buildObjectFields(m_schema.getFields(TmConfiguration.CORE_ACCOUNT), TmConfiguration.CORE_ACCOUNT));
        objectSections.put(TmConfiguration.TM_REQUEST, m_dmBuilder.buildObjectFields(m_schema.getFields(TmConfiguration.TM_REQUEST), TmConfiguration.TM_REQUEST));
        objectSections.put(TmConfiguration.TM_REQUEST_CONTACT, m_dmBuilder.buildObjectFields(m_schema.getFields(TmConfiguration.TM_REQUEST_CONTACT), TmConfiguration.TM_REQUEST_CONTACT));
        objectSections.put(TmConfiguration.TM_REQUEST_ACCOUNT, m_dmBuilder.buildObjectFields(m_schema.getFields(TmConfiguration.TM_REQUEST_ACCOUNT), TmConfiguration.TM_REQUEST_ACCOUNT));
        objectSections.put(TmConfiguration.TM_REQUEST_CONTACT_ACCOUNT, m_dmBuilder.buildObjectFields(m_schema.getFields(TmConfiguration.TM_REQUEST_CONTACT_ACCOUNT), TmConfiguration.TM_REQUEST_CONTACT_ACCOUNT));
        
        return objectSections;
    }

    public TmBoarding.requestPm getRequest(Id requestId, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields) {
        List<String> requests = m_queryBuilder.addRequiredRequestFields(requestFields);
        List<String> contacts = m_queryBuilder.addRequiredContactFields(contactCoreFields);
        List<String> accounts = m_queryBuilder.addRequiredAccountFields(accountCoreFields);
        List<String> contactRequests = m_queryBuilder.addRequiredContactRequestFields(contactFields);
        List<String> accountRequests = m_queryBuilder.addRequiredAccountRequestFields(accountFields);
        List<String> contactAccountRequests = m_queryBuilder.addRequiredContactAccountFields(contactAccountFields);
        
        return m_dataProvider.getRequest(requestId, requests, contactRequests, accountRequests, contactAccountRequests, contacts, accounts);
    }

    public Map<Id, TmBoarding.requestPm> getAllRequests(List<Id> requestIds, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields) {
        List<String> requests = m_queryBuilder.addRequiredRequestFields(requestFields);
        List<String> contacts = m_queryBuilder.addRequiredContactFields(contactCoreFields);
        List<String> accounts = m_queryBuilder.addRequiredAccountFields(accountCoreFields);
        List<String> contactRequests = m_queryBuilder.addRequiredContactRequestFields(contactFields);
        List<String> accountRequests = m_queryBuilder.addRequiredAccountRequestFields(accountFields);
        List<String> contactAccountRequests = m_queryBuilder.addRequiredContactAccountFields(contactAccountFields);
        
        return m_dataProvider.getAllRequests(requestIds, requests, contactRequests, accountRequests, contactAccountRequests, contacts, accounts);
    }

    public TmBoarding.ProductConfig getProduct(String recordTypeName) {
        TmBoarding.RequestConfigPm meta = getMetadata(recordTypeName);
        TM_Service_Configuration__c productPm = meta.productPm;
        TmBoarding.ProductConfig config = new TmBoarding.ProductConfig();
        config.productId = productPm.Id;
        config.product = productPm.product_Name__c;
        config.templateFolderName = productPm.Template_Folder__c;
        config.templateFileName = productPm.Template_File__c;
        config.tmScreenTemplateFileName = productPm.TM_Screen_Template__c;
        config.contactSummaryReportTemplateName = productPm.Contact_Summary_Report_Template__c;
        config.userBoardingTemplateName = productPm.User_Boarding_Template2__c;
        config.footerTemplateId = productPm.Footer_Template__c;
        config.primarySignerCode = productPm.Digital_Signature_Primary_Signer_Code__c;
        config.secondarySignerCode = productPm.Digital_Signature_Secondary_Signer_Code__c;
        config.tmoSignerCode = productPm.Digital_Signature_Tmo_Signer_Code__c;
        config.requiresInitialSignature = productPm.Digital_Signature_Requires_Initial__c;
        return config;
    }

    public String getRecordTypeName(TM_Service_Request__c record) {
        return String.IsNotBlank(record.RecordTypeId) 
               ? Schema.SObjectType.TM_Service_Request__c.getRecordTypeInfosById().get(record.RecordTypeId).getName()
               : '';
    }

    public Blob getTemplateFromAttachment(String attachmentName, String productConfigId) {
        for(Attachment a : m_attachmentProvider.getAllAttachmentsForParent(productConfigId)) {
            if(a.name == attachmentName) {
                return a.Body;
            }
        }
        return null;
    }

    public Map<string, TmConfiguration.ProductInfo> getProductInfos(Id packetId) {
        List<TM_Service_Configuration__c> configs = m_dataProvider.getAllConfigurations();
        Map<string, TM_Service_Configuration__c> configMap = new Map<string, TM_Service_Configuration__c>();
        Map<string , TmConfiguration.ProductInfo> products = new Map<string, TmConfiguration.ProductInfo>();

        List<TM_Service_Request__c> requests = m_dataProvider.getRequestsForPacket(packetId);
        if(requests == null || configs == null){return products;}

        for(TM_Service_Configuration__c c : configs) {
            configMap.put(c.Product_Name__c.toLowerCase(), c);
        }

        for( TM_Service_Request__c r : requests) {          
            TM_Service_Configuration__c cfg = configMap.get(r.recordType.name.toLowerCase());
            TmConfiguration.ProductInfo info = m_dmBuilder.buildProductInfo(r, cfg);
            products.put(info.productType.name, info);
        }
        return products;
    }

    public Map<string, TmConfiguration.ProductInfo> getProductInfosByRequestId(Id packetId) {
        List<TM_Service_Configuration__c> configs = m_dataProvider.getAllConfigurations();
        Map<string, TM_Service_Configuration__c> configMap = new Map<string, TM_Service_Configuration__c>();
        Map<string , TmConfiguration.ProductInfo> products = new Map<string, TmConfiguration.ProductInfo>();

        List<TM_Service_Request__c> requests = m_dataProvider.getRequestsForPacket(packetId);
        if(requests == null || configs == null){return products;}

        for(TM_Service_Configuration__c c : configs) {
            configMap.put(c.Product_Name__c.toLowerCase(), c);
        }

        for( TM_Service_Request__c r : requests) {          
            TM_Service_Configuration__c cfg = configMap.get(r.recordType.name.toLowerCase());
            TmConfiguration.ProductInfo info = m_dmBuilder.buildProductInfo(r, cfg);
            products.put(r.Id, info);
        }
        return products;
    }

    public List<DmField> getFields(List<DmSection> sections) {
        List<DmField> dms = new List<DmField>();
        for(DmSection dm : sections) {
            dms.addall(dm.Fields);
        }
        return dms;
    }

    private TmBoarding.RequestConfigPm getMetadata(String recordTypeName) {
        if(m_dynamicConfigsMap == null) {
            m_dynamicConfigsMap = new Map<String, TmBoarding.RequestConfigPm>();
        }

        if(m_dynamicConfigsMap == null || m_dynamicConfigsMap.keySet().size() == 0) {
            m_dynamicConfigsMap = m_dataProvider.getAllPageFieldConfigurationsByServiceType();
        }
        return m_dynamicConfigsMap.get(recordTypeName);
    }

    private void updateSchedule(TmBoarding.RequestScheduleConfigPm cfg, List<DmSection> scheduleSections) {
        for(DmSection dm : scheduleSections) {
            dm.lookup = cfg.scheduleName;
        }
    }

    private TmConfiguration.DmBuildRequest build(String objectName, TmBoarding.RequestConfigPm meta, TmConfiguration.Placement pl) {
        TmConfiguration.DmBuildRequest req = new TmConfiguration.DmBuildRequest();
        req.ServiceOptionPms = meta.serviceOptionPms;
        req.SectionOptionPms = meta.sectionOptionPms;
        req.SectionGroupOptions = meta.sectionGroupOptionPms;
        req.Placement = pl;
        if(String.IsNotBlank(objectName)) {
            Map<string, ISObjectField> newFieldMap = new Map<string, ISObjectField>();
            Map<string, ISObjectField> fieldMap = m_schema.getFieldMap(objectName);
            for(string k : fieldMap.keySet()) {
                string key = string.format('{0}.{1}', new List<String>{objectName.toLowerCase(), k});
                newFieldMap.put(key, fieldMap.get(k));
            }
            req.fieldMap = newFieldMap;
        }
        return req;
    }

    private TmConfiguration.DmBuildRequest buildRequest(Map<string, ISObjectField> fieldMap , TmBoarding.RequestConfigPm meta, TmConfiguration.Placement pl) {
        TmConfiguration.DmBuildRequest req = new TmConfiguration.DmBuildRequest();
        req.ServiceOptionPms = meta.serviceOptionPms;
        req.SectionOptionPms = meta.sectionOptionPms;
        req.SectionGroupOptions = meta.sectionGroupOptionPms;
        req.Placement = pl;
        if(fieldMap != null) {
            req.fieldMap = fieldMap;
        }
        return req;
    }

    private TmConfiguration.DmBuildRequest buildScheduleRequest(Map<string, ISObjectField> fieldMap , TmBoarding.RequestConfigPm meta, TmBoarding.RequestScheduleConfigPm cfg, TmConfiguration.Placement pl) {
        TmConfiguration.DmBuildRequest req = new TmConfiguration.DmBuildRequest();
        req.type = cfg.scheduleType;
        req.Label = cfg.ScheduleLabel;
        req.ServiceOptionPms = cfg.serviceSchedulePms;
        req.SectionOptionPms = meta.sectionOptionPms;
        req.SectionGroupOptions = meta.sectionGroupOptionPms;
        req.Placement = pl;
        if(fieldMap != null) {
            req.fieldMap = fieldMap;
        }
        return req;
    }

    private TmConfiguration.DmBuildRequest buildContact(Map<string, ISObjectField> fieldMap , TmBoarding.RequestConfigPm meta, TmConfiguration.Placement pl) {
        TmConfiguration.DmBuildRequest req = new TmConfiguration.DmBuildRequest();
        req.ServiceOptionPms = meta.contactOptionPms;
        req.SectionOptionPms = meta.sectionOptionPms;
        req.SectionGroupOptions = meta.sectionGroupOptionPms;
        req.Placement = pl;
        if(fieldMap != null) {
            req.fieldMap = fieldMap;
        }
        return req;
    }

    private TmConfiguration.DmBuildRequest buildAccount(Map<string, ISObjectField> fieldMap , TmBoarding.RequestConfigPm meta, TmConfiguration.Placement pl) {
        
        TmConfiguration.DmBuildRequest req = new TmConfiguration.DmBuildRequest();
        req.ServiceOptionPms = meta.accountOptionPms;
        req.SectionOptionPms = meta.sectionOptionPms;
        req.SectionGroupOptions = meta.sectionGroupOptionPms;
        req.Placement = pl;
        if(fieldMap != null) {
            req.fieldMap = fieldMap;
        }
        return req;
    }

    private TmConfiguration.DmBuildRequest buildContactAccount(Map<string, ISObjectField> fieldMap , TmBoarding.RequestConfigPm meta, TmConfiguration.Placement pl) {
        TmConfiguration.DmBuildRequest req = new TmConfiguration.DmBuildRequest();
        req.ServiceOptionPms = meta.contactAccountOptionPms;
        req.SectionOptionPms = meta.sectionOptionPms;
        req.SectionGroupOptions = meta.sectionGroupOptionPms;
        req.Placement = pl;
        if(fieldMap != null) {
            req.fieldMap = fieldMap;
        }
        return req;
    }

    private List<string> getUniques(List<string> fields) {
        Set<string> uniqueSet = new Set<string>();
        List<string> output = new List<string>();
        if(fields == null){return fields;}
        for(String field : fields) {
            uniqueSet.add(field);
        }
        output.addAll(uniqueSet);
        return output;
    }
}