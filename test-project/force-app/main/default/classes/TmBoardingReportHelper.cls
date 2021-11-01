public class TmBoardingReportHelper implements TmBoarding.IReportHelper {

    private final TmConfiguration.IRepository m_repository;
    private final TmBoarding.IDataMapBuilder m_dataMapBuilder;
    private final EbDocRepoProvider.IEbDocRepoProvider m_docRepoProvider;

    public TmBoardingReportHelper(TmConfiguration.IRepository repository, TmBoarding.IDataMapBuilder dataMapBuilder, EbDocRepoProvider.IEbDocRepoProvider docRepoProvider) {
        m_repository = repository;
        m_dataMapBuilder = dataMapBuilder;
        m_docRepoProvider = docRepoProvider;
    }

    public TmBoarding.ReportDataHolder buildBulkRequestPmData(Map<string, TmConfiguration.ProductInfo> allProductInfos, List<string> tmRequestIds){
        Set<string> productSet = new Set<string>(tmRequestIds);

        List<TmBoarding.BoardingData> boardingData = new List<TmBoarding.BoardingData>();

        Map<string, Tm_Service_Request__c> jsonRequest = new Map<string, Tm_Service_Request__c>();
        for(string requestId : allProductInfos.keyset()) {
            if(productSet.contains(requestId)){
                TmConfiguration.ProductInfo info = allProductInfos.get(requestId);
                jsonRequest.put(info.requestId, new Tm_Service_Request__c(Id = info.requestId, RecordTypeId = info.productType.Id ));
            }   
        }

        return buildJsonDataBulk(jsonRequest);
    }

    public TmBoarding.ReportDataHolder buildJsonDataBulk(Map<string, Tm_Service_Request__c> jsonRequest) {

        TmBoarding.ReportDataHolder dataHolder = new TmBoarding.ReportDataHolder();
        Map<string, TmBoarding.BoardingData> jsonData = new Map<string, TmBoarding.BoardingData>();
        Map<string,ObjectFields> objFieldMap = new Map<string,ObjectFields>();
        Map<Id, TmConfiguration.ObjectDmFields> objDmFields = new Map<Id, TmConfiguration.ObjectDmFields>();
        
        for(String requestId : jsonRequest.keySet()) {
            TM_Service_Request__c req = jsonRequest.get(requestId);
            String productName = m_repository.getRecordTypeName(req);
            List<DmSection> details = m_repository.getDetailSections2(productName, TmConfiguration.Placement.All);
            List<DmSection> schedules = m_repository.getScheduleSections2(productName, TmConfiguration.Placement.All);
            List<DmSection> contactOptions = m_repository.getContactSections(productName, TmConfiguration.Placement.All);
            List<DmSection> accountOptions = m_repository.getAccountSections(productName, TmConfiguration.Placement.All);
            List<DmSection> contactAccountOptions = m_repository.getContactAccountSections(productName, TmConfiguration.Placement.All);

            List<DmField> requestFields = details == null? new List<DmField>(): getFields(details);
            List<DmField> scheduleFields = schedules == null? new List<DmField>(): getFields(schedules);
            List<DmField> contactFields = contactOptions == null ? new List<DmField>() : getFields(contactOptions);
            List<DmField> accountFields = accountOptions == null ? new List<DmField>() : getFields(accountOptions);
            List<DmField> contactAccountFields = contactAccountOptions == null ? new List<DmField>() : getFields(contactAccountOptions);
            ObjectFields flds = buildFields(req, requestFields, scheduleFields, contactFields, accountFields, contactAccountFields);
            
            objFieldMap.put(requestId, flds);
            
            TmConfiguration.ObjectDmFields dmFlds = new TmConfiguration.ObjectDmFields();
            dmFlds.core = req;
            dmFlds.requestFields = requestFields;
            dmFlds.scheduleFields = scheduleFields;
            dmFlds.contactFields = contactFields;
            dmFlds.accountFields = accountFields;
            dmFlds.contactAccountFields = contactAccountFields;
            objDmFields.put(req.Id, dmFlds);
        }
        
        List<Id> requestIds = new List<Id>();
        Set<string> allRequestSet = new Set<string>();
        Set<string> allContactSet = new Set<string>();
        Set<string> allContactRequestSet = new Set<string>();
        Set<string> allAccountSet = new Set<string>();
        Set<string> allAccountRequestSet = new Set<string>();
        for(ObjectFields o : objFieldMap.values()) {
            requestIds.add(o.core.id);
            allRequestSet.addAll(o.requestsAndSchedules);
            allContactSet.addAll(o.contacts);
            allContactRequestSet.addAll(o.contactRequests);
            allAccountSet.addAll(o.accounts);
            allAccountRequestSet.addAll(o.accountRequests);
        }
        List<string> allRequests = new List<string>();
        allrequests.addAll(allRequestSet);
        List<string> allContacts = new List<string>();
        allContacts.addAll(allContactSet);
        List<string> allContactRequests = new List<string>();
        allContactRequests.addAll(allContactRequestSet);
        List<string> allAccounts = new List<string>();
        allAccounts.addAll(allAccountSet);
        List<string> allAccountRequests = new List<string>();
        allAccountRequests.addAll(allAccountRequestSet);

        Map<Id, TmBoarding.RequestPm> pms = m_repository.getAllRequests(requestIds, allrequests, allContactRequests, allAccountRequests, new List<string>(), allContacts, allAccounts);         

        for(Id reqId : pms.keySet()) {
            TmBoarding.requestPm requestPm = pms.get(reqId);
            TmConfiguration.ObjectDmFields dmF = objDmFields.get(reqId);
            TmBoarding.BoardingData bdata = buildData(requestPm, dmF.requestFields, dmF.scheduleFields, dmF.contactFields, dmF.accountFields, dmF.contactAccountFields);
            String key = String.Format('{0}', new List<String>{requestPm.requestpm.Id});
            jsonData.put(key, bdata);
        }

        dataHolder.allBoardingData = jsonData;
        dataHolder.requestPms = pms;
        dataHolder.objectFieldsByRequestId = objDmFields;
        return dataHolder;
    }

    public TmBoarding.BoardingData buildJsonData(TM_Service_Request__c record, String productName) {
        List<DmSection> details = m_repository.getDetailSections(productName, TmConfiguration.Placement.All);
        List<DmSection> schedules = m_repository.getScheduleSections(productName, TmConfiguration.Placement.All);
        List<DmSection> contactOptions = m_repository.getContactSections(productName, TmConfiguration.Placement.All);
        List<DmSection> accountOptions = m_repository.getAccountSections(productName, TmConfiguration.Placement.All);
        List<DmSection> contactAccountOptions = m_repository.getContactAccountSections(productName, TmConfiguration.Placement.All);
        
        List<DmField> requestFields = details == null? new List<DmField>(): getFields(details);
        List<DmField> scheduleFields = schedules == null? new List<DmField>(): getFields(schedules);
        List<DmField> contactFields = contactOptions == null ? new List<DmField>() : getFields(contactOptions);
        List<DmField> accountFields = accountOptions == null ? new List<DmField>() : getFields(accountOptions);
        List<DmField> contactAccountFields = contactAccountOptions == null ? new List<DmField>() : getFields(contactAccountOptions);
        
        TmBoarding.RequestPm pm = buildRequestPm(record, requestFields, scheduleFields, contactFields, accountFields, contactAccountFields);

        return buildData(pm, requestFields, scheduleFields, contactFields, accountFields, contactAccountFields);
    }

    public TmBoarding.BoardingData buildData(TmBoarding.RequestPm pm, List<DmField> requestFields, List<DmField> scheduleFields, List<DmField> contactFields, List<DmField> accountFields, List<DmField> contactAccountFields) {

        TmBoarding.BoardingData data = new TmBoarding.BoardingData();
        data.packet = m_dataMapBuilder.buildPacket(pm);
        data.details = m_dataMapBuilder.buildDetails(pm, requestfields, scheduleFields);
        data.contacts = m_dataMapBuilder.buildContacts(pm, contactFields);
        data.accounts = m_dataMapBuilder.buildAccounts(pm, accountFields);
        data.contactAccounts = m_dataMapBuilder.buildContactAccounts(pm, contactAccountFields);

        return data;
    }
    
    public Blob getMasterServiceAgreement(string packetId) {
        TmConfiguration.ProductInfo masterSvcProd = getProductWithMasterServiceAgreement(packetId);
        DmDocument masterSvcDoc = m_docRepoProvider.GetFileByEbDocId(masterSvcProd.masterAgreementTemplateName);
        if(masterSvcDoc == null) return Blob.valueOf('');
        return masterSvcDoc.body;
    }

    private TmBoarding.RequestPm buildRequestPm(Tm_Service_Request__c record, List<DmField> requestFields, List<DmField> scheduleFields, List<DmField> contactFields, List<DmField> accountFields, List<DmField> contactAccountFields) {
        List<String> packetsInRequests = getSfFields(requestFields, TmConfiguration.TM_REQUEST_PACKET);
        List<String> requests = getSfFields(requestFields, TmConfiguration.TM_REQUEST);
        List<String> packetsInSchedules = getSfFields(scheduleFields, TmConfiguration.TM_REQUEST_PACKET);
        List<String> sfSchedules = getSfFields(scheduleFields, TmConfiguration.TM_REQUEST);
        List<String> sfrequestFields = new List<String>();
        Set<string> packetFields = new Set<string>();
        packetFields.addall(packetsInRequests);
        packetFields.addAll(packetsInSchedules);
        sfrequestFields.addAll(requests);
        sfrequestFields.addAll(sfSchedules);

        for(String x: packetFields){
            String packetField = getPacketField(x);
            sfrequestFields.add(packetField);
        }
       
        List<String> contacts = getSfFields(contactFields, TmConfiguration.CORE_CONTACT);
        List<String> contactRequests = getSfFields(contactFields, TmConfiguration.TM_REQUEST_CONTACT);
        List<String> accounts = getSfFields(accountFields, TmConfiguration.CORE_ACCOUNT);
        List<String> accountRequests = getSfFields(accountFields, TmConfiguration.TM_REQUEST_ACCOUNT);
        List<String> contactAccountRequests = getSfFields(contactAccountFields, TmConfiguration.TM_REQUEST_CONTACT_ACCOUNT);

        return m_repository.getRequest(record.Id, sfrequestFields, contactRequests, accountRequests, contactAccountRequests, contacts, accounts);
    }

    private ObjectFields buildFields(Tm_Service_Request__c record, List<DmField> requestFields, List<DmField> scheduleFields, List<DmField> contactFields, List<DmField> accountFields, List<DmField> contactAccountFields){
        List<String> packetsInRequests = getSfFields(requestFields, TmConfiguration.TM_REQUEST_PACKET);
        List<String> requests = getSfFields(requestFields, TmConfiguration.TM_REQUEST);
        List<String> packetsInSchedules = getSfFields(scheduleFields, TmConfiguration.TM_REQUEST_PACKET);
        List<String> sfSchedules = getSfFields(scheduleFields, TmConfiguration.TM_REQUEST);
        List<String> sfrequestFields = new List<String>();

        Set<string> packetFields = new Set<string>();
        packetFields.addall(packetsInRequests);
        packetFields.addall(packetsInSchedules);

        sfrequestFields.addAll(requests);
        sfrequestFields.addAll(sfSchedules);
        for(String x: packetFields){
            String packetField = getPacketField(x);
            sfrequestFields.add(packetField);
        }
        

        List<String> contacts = getSfFields(contactFields, TmConfiguration.CORE_CONTACT);
        List<String> contactRequests = getSfFields(contactFields, TmConfiguration.TM_REQUEST_CONTACT);
        List<String> accounts = getSfFields(accountFields, TmConfiguration.CORE_ACCOUNT);
        List<String> accountRequests = getSfFields(accountFields, TmConfiguration.TM_REQUEST_ACCOUNT);
        List<String> contactAccountRequests = getSfFields(contactAccountFields, TmConfiguration.TM_REQUEST_CONTACT_ACCOUNT);
        
        ObjectFields flds = new ObjectFields();
        flds.core = record;
        flds.requests = requests;
        flds.schedules = sfSchedules;
        flds.requestsAndSchedules = sfrequestFields;
        flds.contacts = contacts;
        flds.contactRequests = contactRequests;
        flds.accounts = accounts;
        flds.accountRequests = accountRequests;
        flds.contactAccountRequests = contactAccountRequests;
        return flds;
    }

    private List<DmField> getFields(List<DmSection> sections) {
        Set<DmField> fieldSet = new Set<DmField>();
        List<DmField> fields = new List<DmField>();
        for(DmSection s : sections) {
            fieldSet.addAll(s.Fields);          
        }
        fields.addAll(fieldSet);

        return fields;
    }

    private List<String> getSfFields(List<DmField> fields, String objectName) {
        List<String> fieldList = new List<String>();
        for(DmField dm : fields) {
            if(dm.objectName.tolowerCase() == objectName.tolowerCase() && String.isNotBlank(dm.Name)) {
                fieldList.add(dm.Name);
                if(String.isNotBlank(dm.AlternateName)){
                    fieldList.add(dm.AlternateName);
                }
            }
        }

        return fieldList;
    }

    private String getPacketField(String field){
        String related = TmConfiguration.TM_REQUEST_PACKET.replace('__c', '__r');
        return String.Format('{0}.{1}', new List<string>{related, field});
    }

    private class ObjectFields {
        public TM_Service_Request__c core {get;set;}
        public List<String> requests{get;set;}
        public List<string> schedules {get;set;}
        public List<string> requestsAndSchedules{get;set;}
        public List<string> contacts {get;set;}
        public List<string> contactRequests{get;set;}
        public List<string> accounts{get;set;}
        public List<string> accountRequests{get;set;}
        public List<string> contactAccountRequests{get;set;}  
    }

    public TmConfiguration.ProductInfo getProductWithMasterServiceAgreement(String packetId){

        Map<string, TmConfiguration.ProductInfo> productInfos =  m_repository.getProductInfos(packetId);
       
        if(productInfos == null) {
            return null;
        }

        for(String product : productInfos.keySet()) {
            TmConfiguration.ProductInfo productInfo = productInfos.get(product);
            if(productInfo != null){
                if(String.isNotBlank(productInfo.masterAgreementTemplateName)){
                    return productInfo;
                }
            }
        }

        return null;
    }

}