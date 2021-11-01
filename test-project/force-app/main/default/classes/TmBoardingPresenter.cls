public class TmBoardingPresenter  implements TmBoarding.IPresenter {

    private final String TM_REQUEST_OBJECT_NAME = 'TM_Service_Request__c';
    private final Integer APPLICATION_NUMBER = 2;
    private final String PICKLIST_FIELD_TMOS = 'Tmos__c';
    private final String STAGE_LOGGING = 'Stage Logging';

    private final TmBoarding.IVmBuilder m_vmBuilder;
    private final TmBoarding.IRepository m_repository;
    private final TmConfiguration.IRepository m_configRepository;
    private final TmBoarding.IDataMapBuilder m_dataMapper;
    private final TmValidator.IRuleRunnerProvider m_validator;
    private final TmBoarding.IValidationEngine m_validationEngine;
    private final TmBoarding.IAccountProvider m_accountProvider;
    private final TmBoarding.ISmBuilder m_smBuilder;
    private final ErrorRepository.IErrorRepository m_errors;
    private final TmOpportunityConverter.IRepository m_opportunityConverter;
    private final ObjectActionLogService.IObjectActionLogService m_objectActionLogService;
    private final TmBoarding.IReportHelper m_productBuilder;

    public TmBoardingPresenter( TmBoarding.IVmBuilder vmBuilder, TmBoarding.IRepository repository, TmConfiguration.IRepository configRepository, 
        TmBoarding.IDataMapBuilder dataMapper, TmValidator.IRuleRunnerProvider validator, 
        TmBoarding.IValidationEngine validationEngine, TmBoarding.IAccountProvider accountProvider, 
        TmBoarding.ISmBuilder smBuilder, ErrorRepository.IErrorRepository errors, 
        TmOpportunityConverter.IRepository opportunityConverter, ObjectActionLogService.IObjectActionLogService objectActionLogService,
        TmBoarding.IReportHelper productBuilder) {
        m_vmBuilder = vmBuilder;
        m_repository = repository;
        m_configRepository = configRepository;
        m_dataMapper = dataMapper;
        m_validator = validator;
        m_validationEngine = validationEngine;
        m_accountProvider = accountProvider;
        m_smBuilder = smBuilder;
        m_errors = errors;
        m_opportunityConverter = opportunityConverter;
        m_objectActionLogService = objectActionLogService;
        m_productBuilder = productBuilder;
    }

    public TmBoarding.FormVm getFormVm(TM_Service_Request__c record) {
        Boolean isNew = handleNewRequest(record);

        TmBoarding.FormVm formVm = new TmBoarding.FormVm();      
        TmBoarding.RequestPm pm = m_repository.getdata(record);
        String productName = pm.requestPm.RecordType.Name;
                               
        formVm.Details  = buildDetails(productName,  pm);
        formVm.Contacts = buildContacts(productName, pm);
        formVm.Accounts = buildAccounts(productName, pm);

        return formVm;
    }

    public TmBoarding.EntityFormVm getEntityFormVm(TM_Service_Request__c record){
        Boolean isNew = handleNewRequest(record);

        TmBoarding.EntityFormVm formVm = new TmBoarding.EntityFormVm();

        TmBoarding.RequestPm pm = m_repository.getdata(record);
        Map<string, TmConfiguration.ProductInfo> productInfos = m_configRepository.getProductInfos(pm.packetPm.Id);
        List<DmRecordType> products = m_repository.getRecordTypesForTmRequest();
        
        formVm.Entity = m_vmBuilder.getEntity(pm);
        
        /* refactor stage */
        DmTmRequestStage stageDm = m_repository.getStageDetail(record.id);
        List<DmTmRequestStage> stageDms = m_repository.getAllStages();
        
        formVm.StageDetails = m_vmBuilder.buildStages(record, stageDm);
        
        formVm.Packet = m_vmBuilder.getPacket(pm, products, productInfos, stageDms);
        
        if(formVm.StageDetails != null && String.isNotBlank(formVm.StageDetails.Name)){
            formVm.PermissionDetails = m_vmBuilder.getPermission(stageDm);
        }
        
        formVm.AccountNumberTypes = m_vmBuilder.getAccountTypes();

        return formVm;
    }

    public TmBoarding.FormVm getDetailFormVm(TM_Service_Request__c record) {
        Boolean isNew = handleNewRequest(record);

        TmBoarding.FormVm formVm = new TmBoarding.FormVm();
        TmBoarding.RequestPm pm = m_repository.getdata(record);
        List<DmRecordType> products = m_repository.getRecordTypesForTmRequest();
        String productName = pm.requestPm.RecordType.Name;

        TmBoarding.FormVm detailVm = new TmBoarding.FormVm();

        TmBoarding.FormComponent details = buildDetails(productName,  pm);
        detailVm.Details  = buildDetails(productName,  pm);
        detailVm.Entity = m_vmBuilder.getEntity(pm);
        DmTmRequestStage stageDm = m_repository.getStageDetail(record.id);
        detailVm.StageDetails = m_vmBuilder.buildStages(record, stageDm);
        List<DmTmRequestStage> stageDms = m_repository.getAllStages();
        Map<string, TmConfiguration.ProductInfo> productInfos = m_configRepository.getProductInfos(pm.packetPm.Id);
        detailVm.Packet = m_vmBuilder.getPacket(pm, products,productInfos, stageDms);
        if(detailVm.StageDetails != null && String.isNotBlank(detailVm.StageDetails.Name)){
            detailVm.PermissionDetails = m_vmBuilder.getPermission(stageDm);
        }

        return detailVm;
    }

    
    public TmBoarding.FormModalVm buildContactAccounts(String accountId, List<String> relatedContactIds, TM_Service_Request__c record) {
        TmBoarding.FormModalVm formVm = new TmBoarding.FormModalVm();
        TmBoarding.RequestPm pm = m_repository.getdata(record);

        List<DmSection> accountsAll = m_configRepository.getAccountSections2(String.valueof(record.RecordTypeId), TmConfiguration.Placement.All);
        List<DmField> accountAllFields = m_configRepository.getFields(accountsAll);

        Map<String, TM_Service_Request_Account__c> serviceMap = serviceAccountMap(pm.serviceAccountPms);
        
        Eb_Account__c parent;
        for(Eb_Account__c a: pm.accountPms) {
            if(String.valueof(a.Id) == accountId) {
                parent = a; 
            }

        }

        if(parent == null){
            for(TM_Service_Request_Account__c r: serviceMap.values()){
                if(String.valueof(r.EB_Account__c) == accountId){
                    parent = r.Eb_Account__r;
                }
            }
        }

        Map<string, Object> dataMap = m_dataMapper.buildAccount(parent, accountAllFields, serviceMap);
        
        List<Map<string, Object>> data = new List<Map<string, Object>>{dataMap};
        TmBoarding.DataComponent dataComponent = new TmBoarding.DataComponent();
        dataComponent.Data = data; 

        formVm.Parent = m_vmBuilder.buildAccounts(accountsAll, dataComponent);
        formVm.Children = buildEmptyFormComponent();
        return formVm;
    }

    public TmBoarding.FormModalVm buildAccountContacts(String contactId, List<String> relatedAccountIds, TM_Service_Request__c record) {
        TmBoarding.FormModalVm formVm = new TmBoarding.FormModalVm();
        formVm.Parent = new TmBoarding.FormComponent();

        formVm.Children = new TmBoarding.FormComponent();
        TmBoarding.RequestPm pm = m_repository.getData(record);

        List<DmSection> contactsAll = m_configRepository.getContactSections2(String.valueof(record.RecordTypeId), TmConfiguration.Placement.All);
        List<DmField> contactAllFields = m_configRepository.getFields(contactsAll);

        Map<Id, TM_Service_Request_Contact__c> serviceMap = serviceContactMap(pm.serviceContactPms);
        Contact parent;
        for(Contact c: pm.contactPms) {
            if(String.valueof(c.Id) == contactId) {
                parent = c; 
            }
        }

        Map<String, Object> dataMap = m_dataMapper.buildContact(parent, contactAllFields, serviceMap);
        List<Map<string, Object>> data = new List<Map<string, Object>>{dataMap};
        TmBoarding.DataComponent dataComponent = new TmBoarding.DataComponent();
        dataComponent.Data = data; 

        formVm.Parent = m_vmBuilder.buildContacts(contactsAll, dataComponent);
        formVm.Children = buildEmptyFormComponent();
        return formVm;
    }

    public List<TmValidator.ValidationResult> getValidations(TmValidator.ValidationRequest req, TM_Service_Request__c record) {
        If(req.ObjectName == TmConfiguration.TM_REQUEST) {
            TmBoarding.RequestPm pm = m_repository.getdata(record);
            String productName = pm.requestPm.RecordType.Name;
            List<DmSection> detailsAll = m_configRepository.getDetailSections2(productName, TmConfiguration.Placement.All);
            List<DmSection> schedulesAll = m_configRepository.getScheduleSections2(productName, TmConfiguration.Placement.All);
            List<DmField> detailsAllFields = m_configRepository.getFields(detailsAll);
            List<DmField> schedulesAllFields = m_configRepository.getFields(schedulesAll);
            List<DmField> allFields = new List<DmField>();
            allFields.addAll(detailsAllFields);
            allFields.addAll(schedulesAllFields);
            return m_validator.ValidateRequestForObject(req, allFields);
        }
        return null;
    }

    public TmBoarding.ExistingDataValidationVm validateTmRequest(TM_Service_Request__c record, List<string> stageIds) {
        if(record == null || String.isBlank(record.Id) || stageIds == null || stageIds.size() == 0){ return new TmBoarding.ExistingDataValidationVm();}

        TmBoarding.RequestPm pm = m_repository.getdata(record);
        String productName = pm.requestPm.RecordType.Name;
        List<DmSection> detailsAll = m_configRepository.getDetailSections2(productName, TmConfiguration.Placement.All);
        List<DmSection> schedulesAll = m_configRepository.getScheduleSections2(productName, TmConfiguration.Placement.All);
        List<DmField> detailsAllFields = m_configRepository.getFields(detailsAll);
        List<DmField> schedulesAllFields = m_configRepository.getFields(schedulesAll);
        List<DmField> allFields = new List<DmField>();
        allFields.addAll(detailsAllFields);
        allFields.addAll(schedulesAllFields);
        Map<string, List<TmValidator.ValidationResult>> validations = m_validator.ValidateExistingTmRequest(pm.requestPm, stageIds, allFields);
        List<DmTmRequestStage> stageDms = m_repository.getAllStages();

        return m_vmBuilder.build(stageDms, validations);
    }

    public List<TmValidator.ValidationResult> validateTmRequestsByCurrentStage(string packetId, List<string> tmRequests){
        if(String.isBlank(packetId) || tmRequests == null ){ return new List<TmValidator.ValidationResult>();}
        List<TmValidator.ValidationResult> results = new List<TmValidator.ValidationResult>();
        Map<string, TmConfiguration.ProductInfo> allProductInfos = m_configRepository.getProductInfosByRequestId(packetId);
        TmBoarding.ReportDataHolder dataHolder = m_productBuilder.buildBulkRequestPmData(allProductInfos, tmRequests);
        Map<Tm_Service_Request__c, List<DmField>> fields = new Map<Tm_Service_Request__c, List<DmField>>();

        Set<string> products = new Set<string>();

        Map<Id, TmBoarding.RequestPm> pms = new Map<Id, TmBoarding.RequestPm>();
        for(Id requestId : dataHolder.requestPms.keyset()){
            pms.put(requestId, dataHolder.requestPms.get(requestId));
        }

        for(Id requestId : dataHolder.objectFieldsByRequestId.keyset()){
            TmBoarding.RequestPm pm = pms.get(requestId);
            products.add(pm.RequestPm.recordtype.Name);
            TmConfiguration.ObjectDmFields objFlds = dataHolder.objectFieldsByRequestId.get(requestId);

            fields.put(pm.requestPm, objFlds.requestFields);
          
        }
        
        List<TmValidator.ValidationResultByProductByStage> vldResults =  m_validator.ValidateTmRequestsByCurrentStage(fields, products);
        for(TmValidator.ValidationResultByProductByStage r: vldResults){
            for(string itm: r.validationsByStage.keyset()){
                List<TmValidator.ValidationResult> vlds = r.validationsByStage.get(itm);
                if(vlds != null && vlds.size() > 0){
                    results.addAll(vlds);
                }
            }
        }

        return results;

    }

    public List<TmValidator.ValidationResult> validateTmRequests(string packetId, List<string> tmRequests, List<string> stageIds){
        
        if(String.isBlank(packetId) || tmRequests == null || stageIds.size() == 0){ return new List<TmValidator.ValidationResult>();}
        List<TmValidator.ValidationResult> results = new List<TmValidator.ValidationResult>();
        Map<string, TmConfiguration.ProductInfo> allProductInfos = m_configRepository.getProductInfosByRequestId(packetId);
        TmBoarding.ReportDataHolder dataHolder = m_productBuilder.buildBulkRequestPmData(allProductInfos, tmRequests);
        Map<Tm_Service_Request__c, List<DmField>> fields = new Map<Tm_Service_Request__c, List<DmField>>();

        Set<string> products = new Set<string>();

        Map<Id, TmBoarding.RequestPm> pms = new Map<Id, TmBoarding.RequestPm>();
        for(Id requestId : dataHolder.requestPms.keyset()){
            pms.put(requestId, dataHolder.requestPms.get(requestId));
        }

        for(Id requestId : dataHolder.objectFieldsByRequestId.keyset()){
            TmBoarding.RequestPm pm = pms.get(requestId);
            products.add(pm.RequestPm.recordtype.Name);
            TmConfiguration.ObjectDmFields objFlds = dataHolder.objectFieldsByRequestId.get(requestId);
            fields.put(pm.requestPm, objFlds.requestFields);
        }
        
        List<TmValidator.ValidationResultByProductByStage> vldResults =  m_validator.ValidateTmRequestsByStage(fields, stageIds, products);
        for(TmValidator.ValidationResultByProductByStage r: vldResults){
            for(string itm: r.validationsByStage.keyset()){
                List<TmValidator.ValidationResult> vlds = r.validationsByStage.get(itm);
                if(vlds != null && vlds.size() > 0){
                    results.addAll(vlds);
                }
            }
        }

        return results;
    }

    public List<TmBoarding.LayoutComponentStage> getAllStages() {     
        List<DmTmRequestStage> stageDms = m_repository.getAllStages();
        return m_vmBuilder.getAllStages(stageDms);
    }

    public List<TmBoarding.NameValue> getAllProducts() {
        List<TmBoarding.NameValue> productNames = new List<TmBoarding.NameValue>();
        List<DmRecordType> products = m_repository.getRecordTypesForTmRequest();
        for(DmRecordType p : products){
            TmBoarding.NameValue nameValue = new TmBoarding.NameValue();
            nameValue.id = p.Id;
            namevalue.name = p.name;
            productNames.add(nameValue);
        }
        return productNames;
    }

    public TmBoarding.AccountGeneratorResult generateNewAccountNumber(String apiResource) {
        return m_accountProvider.generateNewAccountNumber(apiResource);
    }

    public List<TmBoarding.AccountSearchResult> getAccountSearchResult(String param) {
        return m_accountProvider.searchAccount(param);
    }

    public void updateOpsAssignee(String packetId, String assigneeName){
        if(String.isBlank(packetId) || String.isBlank(assigneeName)){return;}
        List<TM_Service_Request__c> requests = new List<TM_Service_Request__c>();
        List<TmBoarding.RequestPm> products = m_repository.getRequestPmsForPacket(packetId);
        List<SObject> updates = m_smBuilder.updateProductAssignee(products, assigneeName);
        if(updates != null && updates.size() > 0){m_repository.save(updates);}
    }

    public List<string> saveRequest(List<TmBoarding.SaveSm> sms, TM_Service_Request__c record) {
        Boolean isNew = false;
        TmBoarding.RequestConfigPm metadata = m_repository.getMetaData(record);
        TmBoarding.RequestPm pm = m_repository.getdata(record);
        String prevStage = pm.requestPm.Stage__c;
        TmBoarding.coreSm coreSm;
        if(pm.requestPm == null || pm.requestPm.Id == null) {
            pm = saveNewRequest(sms, pm, metadata, record);
            return new List<String> {pm.requestPm.Id};
        }
       
        saveExistingRequest(sms, pm, metadata, prevStage);
        if(getErrors() != null || getErrors().size() == 0) {
            updateIfWithdrawnOpportunity(pm);
        }
        
        return getErrors();
    }

    public List<string> getTmos() {
        List<string> tmos = new List<string>();
        List<SelectOption> options = Utility.ListValuesFromObject(TM_REQUEST_OBJECT_NAME, PICKLIST_FIELD_TMOS);
        for(SelectOption o : options){
            tmos.add(o.getValue());
        }

        return tmos;
    }

    public string getStageNotes(Tm_Service_Request__c req){
        TmBoarding.RequestPm pm = m_repository.getRequestById(req.Id, new List<string>{'Id', 'TM_Service_Request_Packet__r.Id', 'TM_Service_Request_Packet__r.Entity__r.Id', 'Notes__c'});
        return pm.requestPm.Notes__c;
    }

    public void saveStageNotes(Tm_Service_Request__c req, String notes){
        TM_Service_Request__c saveReq = new TM_Service_Request__c(Id = req.Id, Notes__c = notes);
        m_repository.save(new List<SObject>{saveReq});
    }

    private TmBoarding.FormComponent buildDetails(String productName, TmBoarding.RequestPm pm) {
        
        Id stageId = pm.requestpm.Stage__c;
        string stageStrId = string.valueof(stageId);
  
        List<DmSection> detailsAll = m_configRepository.getDetailSections2(productName, TmConfiguration.Placement.All);
        List<DmSection> schedulesAll = m_configRepository.getScheduleSections2(productName, TmConfiguration.Placement.All);
        List<DmField> detailsAllFields = m_configRepository.getFields(detailsAll);

        List<DmField> schedulesAllFields = m_configRepository.getFields(schedulesAll);
        List<DmField> allFields = new List<DmField>();
        if(detailsAllFields != null){allFields.addAll(detailsAllFields);}
        if(schedulesAllFields != null){allFields.addAll(schedulesAllFields);}
             
        //Map<string, TmValidator.ValidationResults> detailsAndSchedulesValidations = buildDetailsValidations(TmConfiguration.TM_REQUEST, stageStrId, productName, allFields);
         
        TmBoarding.DataComponent dataDetails = m_dataMapper.buildDetails(pm, detailsAllFields, schedulesAllFields);
        
        TmBoarding.FormComponent formComponent = m_vmBuilder.buildDetails(detailsAll, schedulesAll, dataDetails);

        //TmBoarding.FormMetadata edit = m_validationEngine.addValidation(TmConfiguration.TM_REQUEST, formComponent.EditMetadata, detailsAndSchedulesValidations);
        TmBoarding.FormMetadata edit = m_validationEngine.addValidation(TmConfiguration.TM_REQUEST, formComponent.EditMetadata, new Map<string, TmValidator.ValidationResults>());
        formComponent.EditMetadata = edit;
  

        return formComponent;
    }

    private Map<string, TmValidator.ValidationResults> buildDetailsValidations(string objectName, string stageId, string productName, List<DmField> fieldDms) {
        Map<string, List<TmValidator.ValidationResults>> validationsByStage = m_validator.ValidationByStageMetadata(objectName, stageId, productName, fieldDms);    
        return m_validator.ValidationLookup(validationsByStage);
    }

    private TmBoarding.FormComponent buildContacts(String productName, TmBoarding.RequestPm pm) {
        Id stageId = pm.requestpm.Stage__c;
        List<DmSection> contactsAll = m_configRepository.getContactSections2(pm.requestPm.RecordTypeId, TmConfiguration.Placement.All);
        List<DmField> contactAllFields = m_configRepository.getFields(contactsAll);

        //Map<string, TmValidator.ValidationResults> contactValidations = m_validator.ValidationLookup(stageId, TmConfiguration.CORE_CONTACT, contactAllFields);
        //Map<string, TmValidator.ValidationResults> tmContactValidations = m_validator.ValidationLookup(stageId, TmConfiguration.TM_REQUEST_CONTACT, contactAllFields);
        TmBoarding.DataComponent dataContacts = m_dataMapper.buildContacts(pm, contactAllFields);
        return m_vmBuilder.buildContacts(contactsAll, dataContacts);
    }

    private TmBoarding.FormComponent buildAccounts(String productName, TmBoarding.RequestPm pm) {
        Id stageId = pm.requestpm.Stage__c;
        List<DmSection> accountsAll = m_configRepository.getAccountSections2(pm.requestPm.RecordTypeId, TmConfiguration.Placement.All);
        List<DmField> accountAllFields = m_configRepository.getFields(accountsAll);

        //Map<string, TmValidator.ValidationResults> accountValidations = m_validator.ValidationLookup(stageId, TmConfiguration.CORE_ACCOUNT, accountAllFields);
        //Map<string, TmValidator.ValidationResults> tmAccountValidations = m_validator.ValidationLookup(stageId, TmConfiguration.TM_REQUEST_ACCOUNT, accountAllFields);

        TmBoarding.DataComponent dataAccounts = m_dataMapper.buildAccounts(pm, accountAllFields);
        return m_vmBuilder.buildAccounts(accountsAll, dataAccounts);
    }

    private Boolean handleNewRequest(TM_Service_Request__c record) {
        if(String.isBlank(record.id)) {
            TmBoarding.CoreSm sm = new TmBoarding.CoreSm();
            sm.request = record;

            DmTmRequestStage defaultStage = m_repository.getDefaultStage();

            sm.request.Stage__c =  defaultStage == null? null : defaultStage.Id;

            m_repository.save(sm);

            return true;
        }
        return false;
    }

    private Map<String, TM_Service_Request_Account__c> serviceAccountMap(List<TM_Service_Request_Account__c> serviceAccounts) {
        Map<String, TM_Service_Request_Account__c> serviceMap = new Map<String, TM_Service_Request_Account__c>();
        if(serviceAccounts != null) {
            for(TM_Service_Request_Account__c ra : serviceAccounts) {
                if(String.IsBlank(ra.Eb_Account__c)){
                    String prospective = ra.Prospective_Account__c;
                    serviceMap.put(prospective, ra);
                }else{
                    serviceMap.put(ra.Eb_Account__c , ra);
                }
            }
        }
        return serviceMap;
    }

    private Map<Id, TM_Service_Request_Contact__c> serviceContactMap(List<TM_Service_Request_Contact__c> serviceContacts) {
        Map<Id, TM_Service_Request_Contact__c> serviceMap = new Map<Id, TM_Service_Request_Contact__c>();
        if(serviceContacts != null) {
            for(TM_Service_Request_Contact__c rc : serviceContacts) {
                serviceMap.put(rc.Contact__c , rc);
            }
        }
        return serviceMap;
    }

    private TmBoarding.FormComponent buildEmptyFormComponent() {
        TmBoarding.FormComponent fc = new TmBoarding.FormComponent();
        fc.Data = new List<Map<string, Object>>();
        fc.EditMetadata = new TmBoarding.FormMetadata();
        fc.EditMetadata.Sections = new List<TmBoarding.FormSection>();
        fc.ViewMetadata = new TmBoarding.FormMetadata();
        fc.ViewMetadata.Sections = new List<TmBoarding.FormSection>();
        return fc;
    }

    
    private void updateIfWithdrawnOpportunity(TmBoarding.RequestPm req) {
        m_opportunityConverter.updateOpportunityForWithdrawnProduct(req);
    }

    private void saveExistingRequest(List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm, TmBoarding.RequestConfigPm metadata, String prevStage) {
        TmBoarding.coreSm coreSm = m_smBuilder.coreSmBuilder(sms, pm);
        
        checkExcludedRequestFields(metadata, coreSm);
        String currentStage = coreSm.request.Stage__c;
        TmBoarding.relatedSm relatedSm = m_smBuilder.relatedSmBuilder(coreSm, sms, pm);

        m_repository.save(relatedSm, pm.requestPm.id);
        m_repository.remove(relatedSm);
        
        m_repository.save(coreSm); // run again validations
        List<String> errors = getErrors();
        
        if(errors != null && errors.size() > 0) {
            coreSm.request.Stage__c = prevStage;
            m_repository.save(coreSm);
        }
    }

    private TmBoarding.RequestPm saveNewRequest(List<TmBoarding.SaveSm> sms,  TmBoarding.RequestPm pm, TmBoarding.RequestConfigPm metadata, Tm_service_Request__c record) {
        TM_Service_Request__c newReq = m_smBuilder.buildNewCoreRequest(sms, pm);
        TmBoarding.coreSm coreSm = new TmBoarding.CoreSm();
        coreSm.Request = newReq;
        checkExcludedRequestFields(metadata, coreSm);
        m_repository.save(coreSm);
        record.Id = coreSm.Request.Id;
        
        return m_repository.getdata(record);
    }

    public List<string> saveContact(List<TmBoarding.SaveSm> sms, Boolean isNew, TM_Service_Request__c record) {
        boolean isNewRecord = false;
        List<Tm_Service_Request_Contact_Account__c> newContactAccounts = new List<Tm_Service_Request_Contact_Account__c>();
        TmBoarding.RequestConfigPm metadata = m_repository.getMetaData(record);
        TmBoarding.RequestPm pm = m_repository.getdata(record);
        if(pm.requestPm == null || pm.requestPm.Id == null) {
            isNewRecord = true;
            pm = saveNewRequest(sms, pm, metadata, record);
        }
        TmBoarding.coreSm coreSm = m_smBuilder.coreSmBuilder(sms, pm);
        //m_repository.save(coreSm); // might need to be done later

        TmBoarding.relatedSm relatedSm = m_smBuilder.relatedSmBuilder(coreSm, sms, pm);
        relatedSm = m_smBuilder.buildEditServiceContact(relatedSm, sms, pm);
        m_repository.save(relatedSm, record.id);

        if(isNew) {
            Contact newContact = m_smBuilder.buildNewCoreContact(sms, pm);
            coreSm.contacts.add(newContact);
            m_repository.save(coreSm);
            Tm_Service_Request_Contact__c req = m_smBuilder.buildNewRequestContactForNewContact(newContact, sms, pm);
            if(req != null) {
                relatedSm.contactRelationships.add(req);
                m_repository.save(relatedSm, record.id);
                newContactAccounts = m_smBuilder.buildNewRequestContactAccount(req, sms, pm);
            }           
        }

        TmBoarding.relatedrelatedSm relatedRelatedSm = m_smBuilder.buildServiceContactAccount(relatedSm, sms, pm);
        relatedRelatedSm.contactAccountRelationships.addall(newContactAccounts);

        m_repository.save(relatedRelatedSm);
        m_repository.remove(relatedSm);
        m_repository.save(coreSm);

        return getErrors();
    }

    public List<String> saveAccount(List<TmBoarding.SaveSm> sms, Boolean isNew, TM_Service_Request__c record, TmBoarding.NewAccountDetails newAccount) {
        boolean isNewRecord = false;
        
        List<Tm_Service_Request_Contact_Account__c> newAccountContacts = new List<Tm_Service_Request_Contact_Account__c>();
        TmBoarding.RequestConfigPm metadata = m_repository.getMetaData(record);
        TmBoarding.RequestPm pm = m_repository.getdata(record);

        if(pm.requestPm == null || pm.requestPm.Id == null) {
            isNewRecord = true;
            pm = saveNewRequest(sms, pm, metadata, record);
        }

        TmBoarding.coreSm coreSm = m_smBuilder.coreSmBuilder(sms, pm);

        TmBoarding.relatedSm relatedSm = m_smBuilder.relatedSmBuilder(coreSm, sms, pm);
        relatedSm = m_smBuilder.buildEditServiceAccount(relatedSm, sms, pm);
        m_repository.save(relatedSm, record.id);
      
        if(newAccount != null) {
            DmEbAccount coreAccount = lookupAccount(newAccount, pm);
            if(coreAccount == null) {return getErrors();}

            m_smBuilder.addCoreAccount(coreAccount, coreSm);
            if(String.isBlank(coreAccount.id)){
                m_repository.save(coreSm);
                m_smBuilder.updateCoreAccountId(coreAccount, coreSm);
                SObject related = m_smBuilder.buildRelatedEbAccount(pm, coreAccount);
                m_repository.save(related);
            }
            
            Tm_Service_Request_Account__c req = m_smBuilder.buildNewRequestAccountForProspectiveAccount(coreAccount, pm);
            if(req != null) {
                relatedSm.accountRelationships.add(req);
                m_repository.save(relatedSm, record.id);
                newAccountContacts = m_smBuilder.buildNewRequestAccountContact(req, sms, pm);
            }
        }

        TmBoarding.relatedrelatedSm relatedRelatedSm = m_smBuilder.buildServiceContactAccount(relatedSm, sms, pm);
        relatedRelatedSm.contactAccountRelationships.addall(newAccountContacts);

        m_repository.save(relatedRelatedSm);
        m_repository.remove(relatedSm);

        m_repository.save(coreSm);

        return getErrors();
    }

    public void updateStage(Tm_service_Request__c record, string stageId) {
        TmBoarding.CoreSm coreSm = new TmBoarding.CoreSm();
        coreSm.request = new TM_Service_Request__c(Id = record.Id, Stage__c = stageId);
        if(coreSm.request.Id != null && string.IsNotBlank(stageId)){m_repository.save(coreSm);}
    }

    public void updateStage(List<string> tmRequests, string stageId) {
        if(String.isBlank(stageId) || tmRequests == null){return;}
        List<SObject> objs = new List<SObject>();

        for(String tmRequstId : tmRequests){
            if(String.isNotBlank(tmRequstId)){
                Sobject obj = new Tm_Service_Request__c(Id = tmRequstId, Stage__c = stageId);
                objs.add(obj);
            }           
        }

        if(objs.size() > 0){m_repository.save(objs);}
    }

    public List<TmBoarding.StageLog> getStageLogs(Tm_service_Request__c record) {
        ObjectActionLogService.ObjectAndTypeRequest request = new ObjectActionLogService.ObjectAndTypeRequest();
        request.ObjectRecordId = record.id;
        request.ActionType = STAGE_LOGGING;

        List<ObjectActionLogService.Data> results = m_objectActionLogService.get(request);
        List<TmBoarding.StageLog> logs = new List<TmBoarding.StageLog> ();

        for (ObjectActionLogService.Data result: results) {
            TmBoarding.StageLog log = new TmBoarding.StageLog();
            TmBoarding.UserVm user = new TmBoarding.UserVm();
            user.id = result.CreatedBy.id;
            user.Name = result.CreatedBy.name;
            log.createdBy = user;
            log.createdDate = result.CreatedDate;
            log.timeInBusinessDays = result.TimeInStageBusinessDays;
            log.timeInBusinessDaysExpanded = result.TimeInStageBusinessDaysHours;
            TmBoarding.NameValue stage = new TmBoarding.NameValue();
            stage.name = result.Action;
            log.stage = stage;
            logs.add(log);
        }

        return logs;
    }

    private DmEbAccount lookupAccount(TmBoarding.NewAccountDetails accountDetails, TmBoarding.RequestPm pm) {
        DmEbAccount accountDm = new DmEbAccount();
        if(String.isBlank(accountDetails.ExistingAccountId)) {        
            accountDm.id = accountDetails.ExistingAccountId;
            accountDm.accountLine1 = accountDetails.AccountName;
            accountDm.accountNumber = accountDetails.AccountNumber;
            accountDm.application = APPLICATION_NUMBER;
            accountDm.name = String.format('{0}-{1}', new LIST<String>{accountDm.accountNumber, String.valueof(accountDm.application)});
            accountDm.key = String.format('616-{0}-{1}', new LIST<String>{ String.valueof(accountDm.application) ,accountDm.accountNumber});
            accountDm.primaryOwner = new DmEntity();
            accountDm.primaryOwner.id = pm.entityPm.id;
        }else{
            DmEbAccount existing = m_repository.getExistingAccountById(accountDetails.ExistingAccountId);
            if(existing == null || String.isBlank(existing.id)) {
                m_errors.addError('Select account ( ' + accountDetails.AccountNumber + ' ) not found');
                return null;
            }else{
                if(pm.accountPms != null) {
                    for(Eb_Account__c a : pm.accountPms) {
                        if(a.id == existing.id) {
                            m_errors.addError('Selected account ( ' + accountDetails.AccountNumber + ' ) already exists');
                            return null;
                        }
                    }
                }
            }

            return existing;
        }
       
        return accountDm;
    }

    private void checkExcludedRequestFields(TmBoarding.RequestConfigPm config, TmBoarding.CoreSm coreSm) {
        //find excluded fields
        Set<String> excluded = m_smBuilder.getExcludedFieldsFromRequest(config, coreSm.request);
        //remove values for the excluded fields
        coreSm.request = m_smBuilder.removeValuesFromRequest(excluded, coreSm.request);
    }

    private TmBoarding.LayoutComponentStage buildStages(TM_Service_Request__c record) {
        TmBoarding.LayoutComponentStage layout = new TmBoarding.LayoutComponentStage();
        if(record == null || record.id == null){return layout;}
        DmTmRequestStage stageDm = m_repository.getStageDetail(record.id);
        if(stageDm == null){return layout;}
        layout.id = stageDm.id;
        layout.name = stageDm.name;
        layout.RelatedStages = new List<TmBoarding.LayoutComponentStage>();
        if(stageDm.relatedStages != null) {
            for(DmTmRequestStage s : stageDm.relatedStages) {
                TmBoarding.LayoutComponentStage layoutRelated = new TmBoarding.LayoutComponentStage();
                layoutRelated.id = s.id;
                layoutRelated.name = s.name;
                layout.RelatedStages.add(layoutRelated);
            }
        }
        
        return layout;
    }

    private void updateOpportunity(TmBoarding.RequestPm pm, boolean isNew) {
        if(isNew){
            Opportunity o = m_opportunityConverter.updateOpportunityOnPacket(pm.requestPm, pm.requestPm.RecordType.Name);
            m_repository.save(o);
        }
    }

    private List<String> getErrors() {
        return m_errors.getUniqueErrors();
    }

    private void resetErrors() {
        m_errors.resetErrors();
    }
}