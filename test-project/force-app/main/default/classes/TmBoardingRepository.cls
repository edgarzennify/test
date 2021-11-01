public class TmBoardingRepository implements TmBoarding.IRepository {   
    private TmBoarding.RequestConfigPm m_dynamicConfigs;
    private integer RELATIONSHIP_LIMIT = 8;

    private final TmBoarding.IDataProvider m_dataProvider;
    private final TmBoarding.IDmBuilder m_dmBuilder;
    private final TmConfiguration.IStageRepository m_stageRepository;
    private final ErrorRepository.IErrorRepository m_errors;
    private final TmBoarding.IEbAccountRelBuilder m_ebAccountRelBuilder;
    private final TmBoarding.ISmVerifier m_smVerifier;

    public TmBoardingRepository(TmBoarding.IDataProvider dataProvider, TmBoarding.IDmBuilder dmBuilder, TmConfiguration.IStageRepository stageRepository
                ,ErrorRepository.IErrorRepository errors, TmBoarding.IEbAccountRelBuilder ebAccountRelBuilder
                ,TmBoarding.ISmVerifier smVerifier) {
        m_dataProvider = dataProvider;
        m_dmBuilder = dmBuilder;
        m_stageRepository = stageRepository;
        m_errors = errors;
        m_ebAccountRelBuilder = ebAccountRelBuilder;
        m_smVerifier = smVerifier;
    }

    public TmBoarding.RequestConfigPm getMetaData(TM_Service_Request__c record) {
        if(m_dynamicConfigs == null){           
            string recordTypeName = getRecordTypeName(record);
            m_dynamicConfigs = m_dataProvider.getPageFieldConfigurationsByServiceType(recordTypeName);
        }
        return m_dynamicConfigs;
    }

    public TmBoarding.RequestPm getData(TM_Service_Request__c record) {

        if(string.Isblank(record.Id)) return newRequestPm(record);

        TmBoarding.ServiceMetadata metadata = getConfigurations(record);

        List<string> serviceFields = getRequesObjFields(metadata);
        
        List<string> entityIds = getRelatedEntities(record);
        List<string> contactFields = getContactFields(metadata);
        List<string> accountFields = getAccountFields(metadata);
        List<string> contactAccountFields = getContactAccountFields(metadata);

        List<string> contactObjFields = getContactObjFields(metadata);
        List<string> accountObjFields = getAccountObjFields(metadata);
        
        return m_dataProvider.getRequestWithRelatedEbAccounts(record.Id, entityIds , serviceFields, contactFields, accountFields, contactAccountFields, contactObjFields, accountObjFields);
    }

    public DmEbAccount getExistingAccountByNumber(Integer app, String accountNumber) {
        Decimal appDecimal = Decimal.valueOf(app);
        List<EB_Account__c> accounts = m_dataProvider.getEbAccount(appDecimal, accountNumber);
        return accounts.size() >0 ? m_dmBuilder.getEbAccount(accounts[0]) : null;
    }

    public DmEbAccount getExistingAccountById(String ebaccountId) {
        Eb_Account__c ebaccount = m_dataProvider.getEbAccount(ebaccountId);
        return ebaccount == null ? null :m_dmBuilder.getEbAccount(ebaccount);
    }

    public List<DmRecordType> getRecordTypesForTmRequest() {
        return m_dmBuilder.getRequestRecordTypes();
    }

    public DmTmRequestStage getStageDetail(String requestId) {
        return m_stageRepository.getStageDetail(requestId);
    }

    public DmTmRequestStage getDefaultStage() {
        return m_stageRepository.getDefaultStage();
    }

    public List<DmTmRequestStage> getAllStages() {
        return m_stageRepository.getAllStages();
    }

    public TmBoarding.RequestPm getRequestById(String requestId, List<string> fields){
        return m_dataProvider.getRequest(requestId, fields, new List<string>{'Id', 'Contact__c', 'Tm_service_request__c'}, new List<string> {'Id', 'Eb_Account__c', 'Name','EB_Account__r.Id','EB_Account__r.Name','TM_Service_Request__c'}, new List<string>{'Id'}, new List<String>{'Id'}, new List<String>{'Id','EB_Account_Id__r.Id'});
    }
    
    public void save(TmBoarding.CoreSm sm) {
        List<SObject> saves = new List<SObject>();

        if(sm.request != null)saves.add(sm.request);
        if(sm.packet != null)saves.add(sm.packet);
        if(sm.contacts != null) saves.addAll((List<SObject>)sm.contacts);
        if(sm.accounts != null) saves.addAll((List<SObject>)sm.accounts);

        List<String> errors = m_dataProvider.saveObjects(saves);
        
        if(errors.size() > 0 ) m_errors.addErrors(errors);
    }

    public void save(TmBoarding.RelatedSm sm, Id requestId){
        List<SObject> saves = new List<SObject>();

        TmBoarding.RequestPm requestPm = m_dataProvider.getRequest(requestId, new List<string> {'Id', 'TM_Service_Request_Packet__r.Id', 'TM_Service_Request_Packet__r.Entity__r.Id'}, new List<string>{'Id', 'Contact__c', 'Tm_service_request__c'}, new List<string> {'Id', 'Eb_Account__c', 'Name','EB_Account__r.Id','EB_Account__r.Name','TM_Service_Request__c'}, new List<string>{'Id'}, new List<String>{'Id'}, new List<String>{'Id','EB_Account_Id__r.Id'});
        TmBoarding.RelatedSm currSm = m_smVerifier.verifyRelatedSm(sm, requestPm);
        saves.addAll((List<SObject>)currSm.contactRelationships);
        saves.addAll((List<SObject>)currSm.accountRelationships);
        
        List<String> errors = m_dataProvider.saveObjects(saves);
        if(errors.size() > 0 )m_errors.addErrors(errors);
    }

    public void save(TmBoarding.RelatedRelatedSm sm) {
        List<SObject> savesRels = new List<SObject>();

        savesRels.addAll((List<SObject>)sm.contactAccountRelationships);
        
        List<String> errors = m_dataProvider.saveObjects(savesRels);
        if(errors.size()> 0) m_errors.addErrors(errors);
    }

    public void save(SObject obj) {
        if(obj != null) {
            m_dataProvider.save(obj);
        }
    }

    public void save(List<SObject> objs) {
        if(objs != null) {
            List<String> errors = m_dataProvider.saveObjects(objs);
        }
    }

    public void remove(TmBoarding.RelatedSm sm) {
        List<SObject> deletes = new List<SObject>();
        deletes.addAll((List<SObject>)sm.deleteContactRelationships);
        deletes.addAll((List<SObject>)sm.deleteAccountRelationships);
        List<String> errors = m_dataProvider.removeObjects(deletes);
        if(errors != null && errors.size()> 0) m_errors.addErrors(errors);
    }

    public void remove(TmBoarding.RelatedRelatedSm sm) {
        List<SObject> deletes = new List<SObject>();
        deletes.addAll((List<SObject>)sm.deleteContactAccountRelationships);
        List<String> errors = m_dataProvider.removeObjects(deletes);
        if(errors != null && errors.size()> 0) m_errors.addErrors(errors);
    }

    public List<TmBoarding.RequestPm> getRequestPmsForPacket(string packetId) {
        List<TmBoarding.RequestPm> pms = m_dataProvider.getUserCentricAccountsForPacket(packetId);
        return pms;
    }

    private List<string> getRelatedEntities(TM_Service_Request__c record){
        List<string> entityIds = new List<string>();
        TM_Service_Request__c req = m_dataProvider.getPacketFromRequest(record);
        Account entity = req.TM_Service_Request_Packet__r.Entity__r;

        if(req == null || entity == null){
            return entityIds;
        }

        Map<String, DmEntity> entityMap = m_ebAccountRelBuilder.getRelatedEntitiesIncludingParent(entity);
        
        if(entityMap != null && entityMap.keySet().size() > 0){
            //entityIds = new List<String>(entityMap.keyset());
            entityIds = getLimitedEntitySet(entityMap.keyset(),entity.Id);
        }
        
        return entityIds;
    }

    private TmBoarding.Field getContactKeyField(Tm_Service_Request__c request) {
        Tmboarding.ServiceMetadata metadata = getConfigurations(request);
        return metadata.ContactFields == null ||   metadata.ContactFields.keyfields == null ||  metadata.ContactFields.keyfields.size() == 0? new TmBoarding.field(): metadata.ContactFields.keyfields[0];
    }

    private TmBoarding.Field getAccountKeyField(Tm_Service_Request__c request) {
        Tmboarding.ServiceMetadata metadata = getConfigurations(request);
        return metadata.AccountFields == null ||   metadata.AccountFields.keyfields == null || metadata.AccountFields.keyfields.size() == 0 ? new TmBoarding.field(): metadata.AccountFields.keyfields[0];
    }

    private List<String> getRequesObjFields(Tmboarding.ServiceMetadata metadata) {
        List<String> queryRequest = new List<String>();
        Set<string> queryRequestSet = new Set<string>();
        queryRequestSet.add('Id'); 
        queryRequestSet.add('Name');
        queryRequestSet.add('RecordType.Id');
        queryRequestSet.add('RecordType.Name');
        queryRequestSet.add('RecordTypeId');
        queryRequestSet.add('Stage__c');
        queryRequestSet.add('Stage__r.Name');
        queryRequestSet.add('TM_Service_Request_Packet__c');
        queryRequestSet.add('TM_Service_Request_Packet__r.Name');
        queryRequestSet.add('TM_Service_Request_Packet__r.Id'); 
        queryRequestSet.add('TM_Service_Request_Packet__r.Entity__r.Id');
        queryRequestSet.add('TM_Service_Request_Packet__r.Entity__r.Name');
        queryRequestSet.add('TM_Service_Request_Packet__r.Opportunity__c');

        buildQueryFields(queryRequestSet, 'TM_Service_Request__c', metadata.Fields);
        buildQueryFields(queryRequestSet, 'TM_Service_Request_Packet__c', metadata.Fields);

        for(TmBoarding.ServiceOption so: metadata.ServiceOptions) {
            buildQueryFields(queryRequestSet, TmConfiguration.TM_REQUEST, so.Fields);
            buildQueryFields(queryRequestSet, TmConfiguration.TM_REQUEST_PACKET, so.Fields);
            
        }
        queryRequest.addAll(queryRequestSet);
               
    
        List<string> updatedPacketFields = new List<string>();
        for(String x : queryRequest){
            String updated = x.replace('Packet__c.', 'Packet__r.');
            updatedPacketFields.add(updated);
        }

        return updatedPacketFields;
    }

    private List<String> getContactObjFields(TmBoarding.ServiceMetadata metadata) {
        List<string> queryContact = new List<string>();
        Set<string> queryContactSet = new Set<string>();
        Set<string> queryContact2Set = new Set<string>();
        List<string> queryContact2 = new List<string>();
        queryContactSet.add('Id');
        queryContactSet.add('AccountId');
        queryContactSet.add('FirstName');
        queryContactSet.add('LastName');
        queryContactSet.add('Name');

        buildQueryFields(queryContactSet, 'Contact' ,metadata.ContactFields.KeyFields);
        buildQueryFields(queryContactSet, 'Contact' ,metadata.ContactFields.ViewFields);
        buildQueryFields(queryContactSet, 'Contact' ,metadata.ContactFields.EditFields);
        buildQueryFields(queryContactSet, 'Contact' ,metadata.ContactFields.ReportFields);

        queryContact.addAll(queryContactSet);
        for(String s : queryContact) {
            List<String> sobj = s.split('\\.');
            if(sobj != null) {
                if(sobj.size() == 2) {
                    queryContact2Set.add(sobj[1]);
                }
                if(sobj.size() == 1) {
                    queryContact2Set.add(sobj[0]);
                }
            }
            
        }
        queryContact2.addAll(queryContact2Set);
        return queryContact2;  
    }

    private List<String> getContactFields(TmBoarding.ServiceMetadata metadata) {
        List<string> queryContact = new List<string>();
        Set<string> queryContactSet = new Set<string>();
        queryContactSet.add('Contact__r.Id');
        queryContactSet.add('Contact__r.FirstName');
        queryContactSet.add('Contact__r.LastName');
        queryContactSet.add('Contact__r.Name');
        queryContactSet.add('TM_Service_Request__c');
        queryContactSet.add('Contact_Title__c');

        buildQueryFields(queryContactSet, 'TM_Service_Request_Contact__c' ,metadata.ContactFields.KeyFields);
        buildQueryFields(queryContactSet, 'TM_Service_Request_Contact__c' ,metadata.ContactFields.ViewFields);
        buildQueryFields(queryContactSet, 'TM_Service_Request_Contact__c' ,metadata.ContactFields.EditFields);
        buildQueryFields(queryContactSet, 'TM_Service_Request_Contact__c' ,metadata.ContactFields.ReportFields);

        queryContact.addAll(queryContactSet);

        return queryContact;       
    }

    private List<String> getAccountObjFields(TmBoarding.ServiceMetadata metadata) {
        List<String> queryAccount = new List<String>();
        List<String> queryAccount2 = new List<String>();
        Set<string> queryAccountSet = new Set<string>();
        Set<String> queryAccount2Set = new Set<String>();
        queryAccountSet.add('EB_Account_Id__r.Id');
        queryAccountSet.add('EB_Account_Id__r.Name');
        queryAccountSet.add('EB_Account_Id__r.Account_Number__c');
        queryAccountSet.add('EB_Account_Id__r.Application__c');
        queryAccountSet.add('EB_Account_Id__r.Account_Line_1__c');
        queryAccountSet.add('EB_Account_Id__r.Account_Name__c');
        queryAccountSet.add('EB_Account_Id__r.ApplicationDescription__c'); 
        queryAccountSet.add('EB_Account_Id__r.Fee_Master_Account__c');   

        buildQueryFields(queryAccountSet, 'EB_Account__c' ,metadata.AccountFields.KeyFields);
        buildQueryFields(queryAccountSet, 'EB_Account__c' ,metadata.AccountFields.ViewFields);
        buildQueryFields(queryAccountSet, 'EB_Account__c' ,metadata.AccountFields.EditFields);
        buildQueryFields(queryAccountSet, 'EB_Account__c' ,metadata.AccountFields.ReportFields);

        queryAccount.addAll(queryAccountSet);
        for(String s : queryAccount) {
            String sobj = s.replace('EB_Account__c', 'EB_Account_Id__r');
            queryAccount2Set.add(sobj);
        }
        queryAccount2.addAll(queryAccount2Set);
        return queryAccount2;
    }

    private List<String> getAccountFields(TmBoarding.ServiceMetadata metadata) {
        List<String> queryAccount = new List<String>();
        Set<string> queryAccountSet = new Set<string>();
        queryAccountSet.add('EB_Account__r.Id');
        queryAccountSet.add('EB_Account__r.Name');
        queryAccountSet.add('EB_Account__r.Account_Number__c');
        queryAccountSet.add('EB_Account__r.Application__c');
        queryAccountSet.add('EB_Account__r.Account_Line_1__c');
        queryAccountSet.add('EB_Account__r.Account_Name__c');
        queryAccountSet.add('EB_Account__r.ApplicationDescription__c'); 
        queryAccountSet.add('EB_Account__r.Fee_Master_Account__c');  
        queryAccountSet.add('Prospective_Account__c'); 
        queryAccountSet.add('TM_Service_Request__c');

        buildQueryFields(queryAccountSet, 'TM_Service_Request_Account__c' ,metadata.AccountFields.KeyFields);
        buildQueryFields(queryAccountSet, 'TM_Service_Request_Account__c' ,metadata.AccountFields.ViewFields);
        buildQueryFields(queryAccountSet, 'TM_Service_Request_Account__c' ,metadata.AccountFields.EditFields);
        buildQueryFields(queryAccountSet, 'TM_Service_Request_Account__c' ,metadata.AccountFields.ReportFields);

        queryAccount.addAll(queryAccountSet);

        return queryAccount;
    }

    private List<string> getContactAccountFields(TmBoarding.ServiceMetadata metadata) {
        List<String> queryAccountContact = new List<String>();

        Set<string> queryAccountContactSet = new Set<string>();
        queryAccountContactSet.add('Id');
        queryAccountContactSet.add('Name');
        queryAccountContactSet.add('Account__c');
        queryAccountContactSet.add('Contact__c');
        queryAccountContactSet.add('Account_Key__c');
        queryAccountContactSet.add('Contact_Key__c');
        queryAccountContactSet.add('TM_Service_Request_Account__c');
        queryAccountContactSet.add('TM_Service_Request_Contact__c');
        queryAccountContactSet.add('TM_Service_Request_Contact__r.TM_Service_Request__c');
        queryAccountContactSet.add('TM_Service_Request_Account__r.TM_Service_Request__c');
        queryAccountContactSet.add('TM_Service_Request_Account__r.Prospective_Account__c');
        queryAccountContactSet.add('TM_Service_Request_Account__r.Eb_Account__r.Id');
        queryAccountContactSet.add('TM_Service_Request_Account__r.Eb_Account__r.Name');
        queryAccountContactSet.add('TM_Service_Request_Account__r.Eb_Account__r.Account_Line_1__c');
         queryAccountContactSet.add('TM_Service_Request_Account__r.Eb_Account__r.Account_Name__c');
        queryAccountContactSet.add('TM_Service_Request_Account__r.Eb_Account__r.ApplicationDescription__c');
        queryAccountContactSet.add('TM_Service_Request_Account__r.Eb_Account__r.Fee_Master_Account__c');
        queryAccountContactSet.add('TM_Service_Request_Contact__r.Contact__r.Id');
        queryAccountContactSet.add('TM_Service_Request_Contact__r.Contact__r.Name');
        queryAccountContactSet.add('TM_Service_Request_Contact__r.Contact__r.AccountId');

        buildQueryFields(queryAccountContactSet, 'TM_Service_Request_Contact_Account__c' ,metadata.AccountFields.RelatedFields.KeyFields);
        buildQueryFields(queryAccountContactSet, 'TM_Service_Request_Contact_Account__c' ,metadata.AccountFields.RelatedFields.ViewFields);
        buildQueryFields(queryAccountContactSet, 'TM_Service_Request_Contact_Account__c' ,metadata.AccountFields.RelatedFields.EditFields);
        buildQueryFields(queryAccountContactSet, 'TM_Service_Request_Contact_Account__c' ,metadata.AccountFields.RelatedFields.ReportFields);
        buildQueryFields(queryAccountContactSet, 'TM_Service_Request_Contact_Account__c' ,metadata.ContactFields.RelatedFields.KeyFields);
        buildQueryFields(queryAccountContactSet, 'TM_Service_Request_Contact_Account__c' ,metadata.ContactFields.RelatedFields.ViewFields);
        buildQueryFields(queryAccountContactSet, 'TM_Service_Request_Contact_Account__c' ,metadata.ContactFields.RelatedFields.EditFields);
        buildQueryFields(queryAccountContactSet, 'TM_Service_Request_Contact_Account__c' ,metadata.ContactFields.RelatedFields.ReportFields);

        queryAccountContact.addAll(queryAccountContactSet);

        return queryAccountContact;

    }

    private void buildQueryFields(Set<string> querySet, string objectName, List<TmBoarding.Field> fields) {
        if(fields == null || fields.size() == 0) return;

        for(TmBoarding.Field d : fields){
            if(d != null  ) {
                if(d.objectName == objectName ){
                    if(String.isNotBlank(d.Name)){                     
                        querySet.add(d.Name);
                        if(String.isNotBlank(d.AlternateName)){
                            querySet.add(d.AlternateName);
                        }
                    }               
                }
            }
        }   
    }

    private string getRecordTypeName(Tm_service_request__c record) {
        return  Schema.SObjectType.TM_Service_Request__c.getRecordTypeInfosById().get(record.RecordTypeId).getName();
    }

    private Tmboarding.RequestPm newRequestPm(TM_Service_Request__c record) {
        Tmboarding.RequestPm pm = m_dataProvider.getRequestFromPacket(record);
        pm.requestPm.RecordType = new RecordType(Id = record.RecordTypeId, Name = getRecordTypeName(record));

        return pm;
    }

    private List<SObject> getNewAccounts(List<EB_Account__c> accounts) {
        List<EB_Account__c> inserts = new List<EB_Account__c>();
        for(EB_Account__c a : accounts) {
            if(string.isBlank(a.Id) ) {
                inserts.add(a);
            }
        }

        return inserts;
    }

    private TmBoarding.ServiceMetadata getConfigurations(TM_Service_Request__c record) {
        if(m_dynamicConfigs == null){
            string recordTypeName = getRecordTypeName(record);
            m_dynamicConfigs = m_dataProvider.getPageFieldConfigurationsByServiceType(recordTypeName);
        }
        return m_dmBuilder.getConfigurationsByService(m_dynamicConfigs);
    }

    private List<string> getLimitedEntitySet(Set<string> entitySet, string parentEntity){
        List<string> entities = new List<string>();
        if(entitySet.size() <=RELATIONSHIP_LIMIT) return new List<string>(entitySet);
        integer count = 1;
        entities.add(parentEntity);
        for(string key : entitySet){
            if(count == RELATIONSHIP_LIMIT) break;
            if(key != parentEntity){
                entities.add(key);
            }
            count++;
        }
        return entities;
        
    }
}