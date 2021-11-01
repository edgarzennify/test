public class TmBoardingSmBuilder implements TmBoarding.ISmbuilder {

    private final String TM_REQUEST_NAME = 'tm_service_request__c';
    private final String TM_REQUEST_PACKET_NAME = 'tm_service_request_packet__c';
    private final String CONTACT_NAME = 'contact';
    private final String ACCOUNT_NAME = 'eb_account__c';
    private final String ACCOUNT_SOBJECT_NAME = 'EB_Account__c';
    private final String DDA = 'DDA';
    private final String TM_REQUEST_CONTACT_NAME = 'tm_service_request_contact__c';
    private final String TM_REQUEST_ACCOUNT_NAME = 'tm_service_request_account__c';
    private final String TM_REQUEST_CONTACT_ACCOUNT_NAME = 'tm_service_request_contact_account__c';
    private final String CONTACT_ACCOUNT_KEY_DELIM = '\\|';
    private final String EB_ACCOUNT_RELATIONSHIP = 'Primary Owner';

    private final TmBoarding.ISmExtractor m_smExtractor;
    private final TmBoarding.IFieldMapManager m_fieldMapper;
    private final Utility.IUtility m_util;

    public TmBoardingSmBuilder( TmBoarding.ISmExtractor smExtractor ,  TmBoarding.IFieldMapManager fieldMapper, Utility.IUtility util) {
        m_smExtractor = smExtractor;
        m_fieldMapper = fieldMapper;
        m_util = util;
    }

    public TmBoarding.CoreSm coreSmBuilder(List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        
        TmBoarding.CoreSm coreSm = new TmBoarding.CoreSm();
        Map<String, List<TmBoarding.SaveSm>> requestSms = m_smExtractor.getObjectsById(TM_REQUEST_NAME, sms);
        Map<String, List<TmBoarding.SaveSm>> packetSms = m_smExtractor.getObjectsById(TM_REQUEST_PACKET_NAME, sms);
 
        Map<String, List<TmBoarding.SaveSm>> contactSms = m_smExtractor.getObjectsById(CONTACT_NAME, sms);
        Map<String, List<TmBoarding.SaveSm>> accountSms = m_smExtractor.getObjectsById(ACCOUNT_NAME, sms);
        String requestId = String.valueOf(pm.requestPm.Id);
        List<TmBoarding.SaveSm> requestFields = requestSms.get(requestId);
        String packetId = pm.packetPm == null? '' : String.valueof(pm.packetPm.Id);

        List<TmBoarding.SaveSm> packetFields = packetSms == null?  new List<TmBoarding.SaveSm>() : packetSms.get(packetId);

      
           
        coreSm.packet = buildPacketData(packetFields, pm);
        coreSm.request = buildRequestData(requestFields, pm);
        coreSm.contacts = buildContactsData(contactSms , pm);
        coreSm.accounts = buildAccountsData(accountSms , pm);


        return coreSm;
    }

    public TmBoarding.CoreSm addCoreAccount(DmEbAccount dm, TmBoarding.CoreSm coreSm) {
        if(coreSm.accounts == null)
        {
            coreSm.accounts = new List<Eb_Account__c>();
        }
        if(dm != null){
            if(String.isBlank(dm.id)) {
                Eb_Account__c pm = new EB_Account__c();
                pm.name = dm.name;
                pm.Application__c = dm.application;
                pm.Account_Number__c = dm.accountNumber;
                pm.Key__c = dm.key;
                pm.Account_Line_1__c = dm.accountLine1;
                pm.Primary_Owner_Id__c = dm.PrimaryOwner == null? null: dm.primaryOwner.id;
                RecordType rec = m_util.recordTypeObject(ACCOUNT_SOBJECT_NAME, DDA);
                if(rec!= null){
                    pm.RecordTypeId = rec.Id;
                }
                coreSm.accounts.add(pm);
            }else{
                Eb_Account__c pmExisting = new EB_Account__c(Id = dm.id);
                coreSm.accounts.add(pmExisting);
            }
            
        }

        return coreSm;
    }

    public void updateCoreAccountId(DmEbAccount dm, TmBoarding.CoreSm coreSm) {
        if(coreSm == null || coreSm.accounts == null){return;}
        for(Eb_Account__c a : coreSm.accounts) {
            if(a.Application__c == dm.application && a.Account_Number__c == dm.accountNumber) {
                dm.id = a.id;
                return;
            }
        }
    }

    public SObject buildRelatedEbAccount(TmBoarding.requestPm pm, DmEbAccount coreAccount) {
        Eb_Account_Relationship__c rel = new Eb_Account_Relationship__c();
        rel.Client_Id__c = pm.entityPm.id;
        rel.EB_Account_Id__c = coreAccount.id;
        rel.Relationship__c = EB_ACCOUNT_RELATIONSHIP;
        rel.Key__c = String.format('{0};{1};{2}', new LIST<String>{pm.entityPm.Eb_Customer_Number__c, coreAccount.key, EB_ACCOUNT_RELATIONSHIP});
        
        return rel;
    }

    public TmBoarding.RelatedSm relatedSmBuilder(TmBoarding.coreSm coreSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {

        TmBoarding.RelatedSm relatedSm = new TmBoarding.RelatedSm();
        relatedSm.contactRelationships = new List<TM_Service_Request_Contact__c>();
        relatedSm.accountRelationships = new List<TM_Service_Request_Account__c>();
        relatedSm.deleteContactRelationships = new List<TM_Service_Request_Contact__c>();
        relatedSm.deleteAccountRelationships = new List<TM_Service_Request_Account__c>(); 
        relatedSm  = buildServiceContacts(relatedSm, coreSm, sms, pm);
        relatedSm = buildServiceAccounts(relatedSm, coreSm, sms, pm);
        return relatedSm;
    }

    public TmBoarding.RelatedSm buildEditServiceContact(TmBoarding.RelatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        Map<String, List<TmBoarding.SaveSm>> requestContactSms = m_smExtractor.getObjectsById(TM_REQUEST_CONTACT_NAME, sms);
        Map<String, TM_Service_Request_Contact__c> serviceContactPms = new Map<String, TM_Service_Request_Contact__c>();
        
        if(pm.serviceContactPms != null) {
            for(TM_Service_Request_Contact__c rc : pm.serviceContactPms) {
                serviceContactPms.put( String.valueOf(rc.Id), rc);
            }
        }

        Map<String , TM_Service_Request_Contact__c> requestContacts =  buildContactRequests( requestContactSms, relatedSm.contactRelationships, serviceContactPms);

        if(relatedSm.deleteContactRelationships != null && relatedSm.deleteContactRelationships.size() > 0) {
            List<TM_Service_Request_Contact__c> deletes = new List<TM_Service_Request_Contact__c>();
            for(TM_Service_Request_Contact__c rc : relatedSm.deleteContactRelationships) {
                String key = String.valueOf(rc.Id);
                if(!requestContacts.containsKey(key)) {
                    deletes.add(rc);
                }
            }
            relatedSm.deleteContactRelationships = deletes;
        }

        //if(relatedSm.contactRelationships == null) return relatedSm;

        Set<String> relatedContactIds = new Set<String>();
        for(TM_Service_Request_Contact__c rc : relatedSm.contactRelationships) {
            String requestContactId = String.valueOf(rc.Id);
            relatedContactIds.add(requestContactId);
            TM_Service_Request_Contact__c updateRequestContact = requestContacts.get(requestContactId);
            if(updateRequestContact != null) {
                rc = updateRequestContact;
            }
        }

        if(requestContacts != null && requestContacts.keyset().Size() > 0) {
            for(String key : requestContacts.keyset()){
                if(!relatedContactIds.contains(key)){
                    relatedSm.contactRelationships.add(requestContacts.get(key));
                }
            }
        }

        List<TM_Service_Request_Contact__c> newServiceContacts = buildNewServiceRequestContact(relatedSm, sms, pm);
        if(newServiceContacts != null && newServiceContacts.size() > 0) {
            relatedSm.contactRelationships.addAll(newServiceContacts);
        }

        return relatedSm;
    }

    public TmBoarding.RelatedSm buildEditServiceAccount(TmBoarding.RelatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {

        Map<String, List<TmBoarding.SaveSm>> requestAccountSms = m_smExtractor.getObjectsById(TM_REQUEST_ACCOUNT_NAME, sms);
        Map<String, TM_Service_Request_Account__c> serviceAccountPms = new Map<String, TM_Service_Request_Account__c>();
        
        if(pm.serviceAccountPms != null) {
            for(TM_Service_Request_Account__c rc : pm.serviceAccountPms) {
                serviceAccountPms.put( String.valueOf(rc.Id), rc);
            }
        }

        Map<String , TM_Service_Request_Account__c> requestAccounts =  buildAccountRequests( requestAccountSms, relatedSm.accountRelationships, serviceAccountPms);

        if(relatedSm.deleteAccountRelationships != null && relatedSm.deleteAccountRelationships.size() > 0) {
            List<TM_Service_Request_Account__c> deletes = new List<TM_Service_Request_Account__c>();
            for(TM_Service_Request_Account__c rc : relatedSm.deleteAccountRelationships) {
                String key = String.valueOf(rc.Id);
                if(!requestAccounts.containsKey(key)) {
                    deletes.add(rc);
                }
            }
            relatedSm.deleteAccountRelationships = deletes;
        }

        if(relatedSm.accountRelationships == null) return relatedSm;

        Set<String> relatedAccountIds = new Set<String>();
        for(TM_Service_Request_Account__c rc : relatedSm.accountRelationships) {
            String requestAccountId = String.valueOf(rc.Id);
            relatedAccountIds.add(requestAccountId);
            TM_Service_Request_Account__c updateRequestAccount = requestAccounts.get(requestAccountId);
            if(updateRequestAccount != null) {
                rc = updateRequestAccount;
            }
        }

        if(requestAccounts != null && requestAccounts.keyset().size() > 0) {
            for(String key : requestAccounts.keyset()){
                if(!relatedAccountIds.contains(key)){
                    relatedSm.accountRelationships.add(requestAccounts.get(key));
                }
            }
        }

        List<TM_Service_Request_Account__c> newServiceAccounts = buildNewServiceRequestAccount(relatedSm, sms, pm);
        if(newServiceAccounts != null && newServiceAccounts.size() > 0) {
            relatedSm.accountRelationships.addAll(newServiceAccounts);
        }

        return relatedSm;
    }

    public TmBoarding.RelatedRelatedSm buildServiceContactAccount(TmBoarding.RelatedSm relatedSm,List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        TmBoarding.RelatedRelatedSm relatedRelatedSm = new TmBoarding.RelatedRelatedSm();
        relatedRelatedSm.contactAccountRelationships = new List<TM_Service_Request_Contact_Account__c>();
        relatedRelatedSm.deleteContactAccountRelationships = new List<TM_Service_Request_Contact_Account__c>();
        Map<String, List<TmBoarding.SaveSm>> requestContactAccountSms = m_smExtractor.getObjectsById(TM_REQUEST_CONTACT_ACCOUNT_NAME, sms);

        Map<String, TM_Service_Request_Contact_Account__c> contactAccounts = new Map<String, TM_Service_Request_Contact_Account__c>();
        for(TM_Service_Request_Contact_Account__c rca : pm.serviceContactAccountPms) {
            contactAccounts.put(String.valueOf(rca.Id), rca);
        }
        
        if(requestContactAccountSms != null && requestContactAccountSms.keySet().size() > 0) {
            for(String key : requestContactAccountSms.keySet()) {
                List<TmBoarding.SaveSm> contactAccountFields = requestContactAccountSms.get(key);
                if(contactAccountFields != null && contactAccounts != null) {
                    TM_Service_Request_Contact_Account__c rca = contactAccounts.get(key);

                    if(rca != null) {
                        for(TmBoarding.SaveSm sm : contactAccountFields) { 
                            String fieldName = m_smExtractor.getValidField(sm);

                            if(String.isNotBlank(fieldName)) {
                                Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_CONTACT_ACCOUNT_NAME, fieldName);

                                if(m_fieldMapper.IsFieldUpdatable(fld)) {
                                        Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                                        rca.put(fld, o);                 
                                }
                            }
                        }
                        relatedRelatedSm.contactAccountRelationships.add(rca);
                    }
                }   
            }
        }
                   
        List<TM_Service_Request_Contact_Account__c> newItems = buildNewContactAccount(relatedSm, sms, pm);

        if(newItems != null){
            relatedRelatedSm.contactAccountRelationships.addAll(newItems);
        }
        // deletes / remove not implemented since master relationship with relatedSm might clean up

        return relatedRelatedSm;
    }

    public TM_Service_Request_Contact__c buildNewRequestContactForNewContact(Contact newContact, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        List<TmBoarding.SaveSm> newServiceRequestContactsSms = m_smExtractor.getObjectsWithoutId(TM_REQUEST_CONTACT_NAME, sms);

        if(newServiceRequestContactsSms != null) {
            TM_Service_Request_Contact__c rel = new TM_Service_Request_Contact__c();
            for(TmBoarding.SaveSm sm : newServiceRequestContactsSms) {
                String fieldName = m_smExtractor.getValidField(sm);

                Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_CONTACT_NAME, fieldName);
                if(m_fieldMapper.IsFieldUpdatable(fld)) {
                    Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                    rel.put(fld, o);                 
                }
            }
            rel.Contact__c = newContact.Id;
            rel.TM_Service_Request__c = pm.requestPm.Id;
            return rel;
        }

        return null;
    }

    public TM_Service_Request_Account__c buildNewRequestAccountForProspectiveAccount(DmEbAccount newAccount, TmBoarding.RequestPm pm) {
        TM_Service_Request_Account__c rel = new TM_Service_Request_Account__c();
        rel.EB_Account__c = newAccount.Id;
        rel.TM_Service_Request__c = pm.requestPm.Id;

        return rel;
    }


    public List<TM_Service_Request_Contact_Account__c> buildNewRequestContactAccount(TM_Service_Request_Contact__c reqContact, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        List<TM_Service_Request_Contact_Account__c> newContactAccounts = new List<TM_Service_Request_Contact_Account__c>();
        Map<String, List<TmBoarding.SaveSm>> newServiceRequestContactAccountsSms = m_smExtractor.getObjectsWithoutIdAndParentId(TM_REQUEST_CONTACT_ACCOUNT_NAME, sms);
        
        Map<String, TM_Service_Request_Account__c> serviceAccounts = new Map<String, TM_Service_Request_Account__c>();
        for(TM_Service_Request_Account__c rc : pm.serviceAccountPms) {
            serviceAccounts.put(rc.Eb_Account__c, rc);
        }

        if(newServiceRequestContactAccountsSms != null) {
            for( String accountId : newServiceRequestContactAccountsSms.keySet() ) {
                List<TmBoarding.SaveSm> contactAccountSms = newServiceRequestContactAccountsSms.get(accountId);
                TM_Service_Request_Account__c raccount = serviceAccounts.get(accountId);
                if(contactAccountSms != null && raccount != null) {
                    TM_Service_Request_Contact_Account__c rca = new TM_Service_Request_Contact_Account__c();
                    rca.TM_Service_Request_Contact__c = reqContact.Id;
                    rca.TM_Service_Request_Account__c = raccount.Id;

                    for(TmBoarding.SaveSm sm : contactAccountSms){
                        String fieldName = m_smExtractor.getValidField(sm);
                        Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_CONTACT_ACCOUNT_NAME, fieldName);
                        if(m_fieldMapper.IsFieldUpdatable(fld)) {
                            Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                            rca.put(fld, o);                 
                        }
                    }
                    newContactAccounts.add(rca);
                }
            }
        }

        return newContactAccounts;
    }

    public List<TM_Service_Request_Contact_Account__c> buildNewRequestAccountContact(TM_Service_Request_Account__c reqAccount, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        List<TM_Service_Request_Contact_Account__c> newAccountContacts = new List<TM_Service_Request_Contact_Account__c>();
        Map<String, List<TmBoarding.SaveSm>> newServiceRequestAccountContactsSms = m_smExtractor.getObjectsWithoutIdAndParentId(TM_REQUEST_CONTACT_ACCOUNT_NAME, sms);
        
        Map<String, TM_Service_Request_Contact__c> serviceContacts = new Map<String, TM_Service_Request_Contact__c>();
        for(TM_Service_Request_Contact__c rc : pm.serviceContactPms) {
            serviceContacts.put(rc.Contact__c, rc);
        }

        if(newServiceRequestAccountContactsSms != null) {
            for( String contactId : newServiceRequestAccountContactsSms.keySet() ) {
                List<TmBoarding.SaveSm> accountContactSms = newServiceRequestAccountContactsSms.get(contactId);
                TM_Service_Request_Contact__c rcontact = serviceContacts.get(contactId);
                if(accountContactSms != null && rcontact != null) {
                    TM_Service_Request_Contact_Account__c rca = new TM_Service_Request_Contact_Account__c();
                    rca.TM_Service_Request_Account__c = reqAccount.Id;
                    rca.TM_Service_Request_Contact__c = rcontact.Id;
                    for(TmBoarding.SaveSm sm : accountContactSms){
                        String fieldName = m_smExtractor.getValidField(sm);
                        Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_CONTACT_ACCOUNT_NAME, fieldName);
                        if(m_fieldMapper.IsFieldUpdatable(fld)) {
                            Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                            rca.put(fld, o);                 
                        }
                    }
                    newAccountContacts.add(rca);
                }
            }
        }

        return newAccountContacts;
    }

    public TM_Service_Request__c buildNewCoreRequest(List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        List<TmBoarding.SaveSm> newRequestSms = m_smExtractor.getObjectsWithoutId(TM_REQUEST_NAME, sms);
        if(newRequestSms != null) {
            TM_Service_Request__c req = new TM_Service_Request__c();
            for(TmBoarding.SaveSm sm : newRequestSms) {
                
                String fieldName = m_smExtractor.getValidField(sm);
                Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_NAME, fieldName);
                if(m_fieldMapper.IsFieldUpdatable(fld)) {
                    Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                    req.put(fld, o);                 
                }

            }
            req.TM_Service_Request_Packet__c = pm.requestPm.TM_Service_Request_Packet__c;
            req.RecordTypeId = pm.requestPm.RecordTypeId;
            return req;
        }

        return null;
    }

    public Contact buildNewCoreContact(List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        List<TmBoarding.SaveSm> newContactSms = m_smExtractor.getObjectsWithoutId(CONTACT_NAME, sms);
        if(newContactSms != null) {
            Contact c = new Contact();
            c.AccountId = pm.entityPm.Id;
            for(TmBoarding.SaveSm sm : newContactSms) {
                String fieldName = m_smExtractor.getValidField(sm);
                Schema.SObjectField fld = m_fieldMapper.getField(CONTACT_NAME, fieldName);
                if(m_fieldMapper.IsFieldUpdatable(fld)) {
                    Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                    c.put(fld, o);                 
                }
            }
            if(String.IsBlank(c.LastName)) {c.LastName = c.FirstName;}
            return c;
        }

        return null; 
    } 

    public Eb_Account__c buildNewCoreAccount(List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        List<TmBoarding.SaveSm> newAccountSms = m_smExtractor.getObjectsWithoutId(ACCOUNT_NAME, sms);
        if(newAccountSms != null) {
            EB_Account__c a = new EB_Account__c();
            a.Primary_Owner_Id__c = pm.entityPm.Id;
            for(TmBoarding.SaveSm sm : newAccountSms) {
                String fieldName = m_smExtractor.getValidField(sm);
                Schema.SObjectField fld = m_fieldMapper.getField(ACCOUNT_NAME, fieldName);
                if(m_fieldMapper.IsFieldUpdatable(fld)) {
                    Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                    a.put(fld, o);                 
                }
            }
            return a;
        }

        return null; 
    }   

    public Set<String> getExcludedFieldsFromRequest(TmBoarding.RequestConfigPm config, Tm_service_Request__c request) {
        Set<String> excluded = new Set<String>();
        List<TmBoarding.RequestScheduleConfigPm> schedules = config.schedulePms;
        if(schedules == null || schedules.size() == 0) {return excluded;}
        
        Map<String, List<TM_Service_Configuration_Field__c>> scheduleFields = new Map<String, List<TM_Service_Configuration_Field__c>>();

        for(TmBoarding.RequestScheduleConfigPm cfg : schedules) {
            scheduleFields.put(cfg.ScheduleName, cfg.serviceSchedulePms);
        }


        for(String key : scheduleFields.keySet()) {
            Boolean obj = (Boolean)request.get(key);
            List<TM_Service_Configuration_Field__c> fields = scheduleFields.get(key);
            
            if(obj != true && fields != null) {
                for(TM_Service_Configuration_Field__c f : fields) {
                    excluded.add(f.Field_Name__c);
                }
            }
        }

        return excluded;
    }

    public Tm_service_Request__c removeValuesFromRequest(Set<String> fields, Tm_service_Request__c request) {
        if(fields == null || fields.size() == 0) return request;
        for(String fieldName : fields) {
            Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_NAME, fieldName);
            if(fld != null && m_fieldMapper.IsFieldUpdatable(fld)) {
                Object o = m_fieldMapper.fillEmpty(fld);
                request.put(fld, o);                 
            }
        }

        return request;
    }

    public List<SObject> updateProductAssignee(List<TmBoarding.RequestPm> requestPms, String assigneeName){       
        List<Tm_Service_Request__c> requests = new List<Tm_Service_Request__c>();
        if(requestPms == null && requestPms.size() == 0 ){return requests;}
   
        for(TmBoarding.RequestPm pm : requestPms){
            Tm_Service_Request__c request = new Tm_Service_Request__c();
            request.id = pm.requestPm.id;
            request.Assigned_To__c = assigneeName;
            requests.add(request);
        }

        return requests;
    }

    private TmBoarding.RelatedSm buildServiceContacts(TmBoarding.RelatedSm relatedSm, TmBoarding.coreSm coreSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        
        Map<String, TM_Service_Request_Contact__c> serviceContacts = new Map<String, TM_Service_Request_Contact__c>();
        For(TM_Service_Request_Contact__c rc : pm.serviceContactPms) {
            serviceContacts.put(String.valueOf(rc.Contact__c) , rc);
        }

        for(Contact c : coreSm.contacts) {
            String cId = String.valueOf(c.Id);
            Map<String, Object> selectedContact = m_smExtractor.getSelectedFields(cId, sms);
            if(selectedContact != null && selectedContact.keySet().size() > 0) {
                boolean selected = (boolean)selectedContact.get(cId);
                TM_Service_Request_Contact__c rc = serviceContacts.get(cId);

                if(selected == true) {

                    if(rc == null){
                        TM_Service_Request_Contact__c newRc = new TM_Service_Request_Contact__c();
                        newRc.TM_Service_Request__c = pm.requestPm.Id;
                        newRc.Contact__c = cId;
                        relatedSm.contactRelationships.add(newRc);
                    }else{
                        relatedSm.contactRelationships.add(rc);
                    }
                }else{
                    if(rc != null) {
                        relatedSm.deleteContactRelationships.add(rc);
                    }
                }
            }
        }

        return relatedSm;
    }

    private List<TM_Service_Request_Contact__c> buildNewServiceRequestContact(TmBoarding.relatedSm relatedSm, List<TmBoarding.SaveSm> sms,  TmBoarding.RequestPm pm) {
        List<TM_Service_Request_Contact__c> objects = new List<TM_Service_Request_Contact__c>();
        Map<String, List<TmBoarding.SaveSm>> requestContactSms = m_smExtractor.getNewObjectsByParentId(TM_REQUEST_CONTACT_NAME, sms);
        if(pm.requestPm == null) return objects;
        Id requestId = pm.requestPm.Id;

        for(String contactId : requestContactSms.keyset()) {
            List<TmBoarding.SaveSm> fields = requestContactSms.get(contactId);
            if(Fields != null){
                TM_Service_Request_Contact__c rc = new TM_Service_Request_Contact__c(Contact__c = contactId, TM_Service_Request__c = requestId);
                for(TmBoarding.SaveSm sm : fields) {
                    String fieldName = m_smExtractor.getValidField(sm);
                    Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_CONTACT_NAME, fieldName);
                    if(m_fieldMapper.IsFieldUpdatable(fld)) {
                        Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                        rc.put(fld, o);                 
                    }
                }
                objects.add(rc);
            }
        }

        return objects;
    }

    private List<TM_Service_Request_Account__c> buildNewServiceRequestAccount(TmBoarding.relatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        List<TM_Service_Request_Account__c> objects = new List<TM_Service_Request_Account__c>();
        Map<String, List<TmBoarding.SaveSm>> requestAccountSms = m_smExtractor.getNewObjectsByParentId(TM_REQUEST_ACCOUNT_NAME, sms);
        if(pm.requestPm == null) return objects;
        Id requestId = pm.requestPm.Id;

        for(String accountId : requestAccountSms.keyset()) {
            List<TmBoarding.SaveSm> fields = requestAccountSms.get(accountId);
            TM_Service_Request_Account__c rc = new TM_Service_Request_Account__c(EB_Account__c = accountId, TM_Service_Request__c = requestId);
            for(TmBoarding.SaveSm sm : fields) {
                String fieldName = m_smExtractor.getValidField(sm);
                Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_ACCOUNT_NAME, fieldName);
                if(m_fieldMapper.IsFieldUpdatable(fld)) {
                    Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                    rc.put(fld, o);                 
                }
            }
            objects.add(rc);
        }

        return objects;
    }

    private TmBoarding.RelatedSm buildServiceAccounts(TmBoarding.RelatedSm relatedSm, TmBoarding.coreSm coreSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        Map<String, TM_Service_Request_Account__c> serviceAccounts = new Map<String, TM_Service_Request_Account__c>();
        Map<Id, Eb_Account__c> coreAccounts = new Map<Id, Eb_Account__c>();

        for(Eb_Account__c a : coreSm.accounts) {
            coreAccounts.put(a.id, a);
        }

        For(TM_Service_Request_Account__c rc : pm.serviceAccountPms) {
            serviceAccounts.put(String.valueOf(rc.EB_Account__c) , rc);
            if(!coreAccounts.containsKey(rc.EB_Account__c)) {
                coreAccounts.put(rc.Eb_Account__c, rc.Eb_Account__r);
            }
        }

        if(coreAccounts == null){return relatedSm;}

        for(EB_Account__c a : coreAccounts.values()) {
            String aId = String.valueOf(a.Id);
            Map<String, Object> selectedAccount = m_smExtractor.getSelectedFields(aId, sms);
            if(selectedAccount !=null && selectedAccount.keySet().size() > 0) {
                boolean selected = (boolean)selectedAccount.get(aId);

                TM_Service_Request_Account__c ra = serviceAccounts.get(aId);
                if(selected == true) {              
                    if(ra == null){
                        TM_Service_Request_Account__c newRa = new TM_Service_Request_Account__c();
                        newRa.TM_Service_Request__c = pm.requestPm.Id;
                        newRa.EB_Account__c = aId;
                        relatedSm.accountRelationships.add(newRa);
                    }else{
                        relatedSm.accountRelationships.add(ra);
                    }
                }else{
                    if(ra != null) {
                        relatedSm.deleteAccountRelationships.add(ra);
                    }
                }
            }
        }

        return relatedSm;
    }

    

    private List<TM_Service_Request_Contact_Account__c> buildNewContactAccount(TmBoarding.RelatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
        List<TM_Service_Request_Contact_Account__c> newContactAccounts = new List<TM_Service_Request_Contact_Account__c>();
        Map<String, List<TmBoarding.SaveSm>> newRequestContactAccountSms = m_smExtractor.getObjectsByParentAndRelated(TM_REQUEST_CONTACT_ACCOUNT_NAME, sms);
        
        if(newRequestContactAccountSms == null) return null;

        for(String key : newRequestContactAccountSms.keySet()) {
                List<TmBoarding.SaveSm> contactAccountFields = newRequestContactAccountSms.get(key);

                if(contactAccountFields != null) {
                    TM_Service_Request_Contact_Account__c rca = buildContactAccountLookups(key, pm, relatedSm);

                    if(rca != null) {
                        for(TmBoarding.SaveSm sm : contactAccountFields) { 
                            String fieldName = m_smExtractor.getValidField(sm);

                            if(String.isNotBlank(fieldName)) {
                                Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_CONTACT_ACCOUNT_NAME, fieldName);

                                if(m_fieldMapper.IsFieldUpdatable(fld)) {
                                        Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                                        rca.put(fld, o);                 
                                }
                            }
                        }
                    }
                    newContactAccounts.add(rca);
                }   
        }

        return newContactAccounts;
    }

    private TM_Service_Request_Contact_Account__c buildContactAccountLookups(String key, TmBoarding.RequestPm pm, TmBoarding.RelatedSm relatedSm) {
        TM_Service_Request_Contact_Account__c rca = new TM_Service_Request_Contact_Account__c();
        List<String> relationshipIds = key.split(CONTACT_ACCOUNT_KEY_DELIM);

        if(relationshipIds == null || relationshipIds.size() != 2 ) return null;

        String object1Name = m_util.getObjectNameFromId(relationshipIds[0]);
        String object2Name = m_util.getObjectNameFromId(relationshipIds[1]);
        String contactId;
        String accountId;

        if(object1Name.tolowerCase() == CONTACT_NAME) {
            contactId = relationshipIds[0];
        } else if(object2Name.tolowerCase() == CONTACT_NAME) {
            contactId = relationshipIds[1];
        }

        if(object1Name.tolowerCase() == ACCOUNT_NAME) {
            accountId = relationshipIds[0];
        } else if(object2Name.tolowerCase() == ACCOUNT_NAME) {
            accountId = relationshipIds[1];
        }

        for(TM_Service_Request_Contact__c rc : pm.serviceContactPms) {
            if(rc.Contact__c == contactId) {
                rca.TM_Service_Request_Contact__c = rc.Id;
                break;
            }
        }

        for(TM_Service_Request_Account__c rc : pm.serviceAccountPms) {
            if(rc.Eb_Account__c == accountId) {
                rca.TM_Service_Request_Account__c = rc.Id;
                break;
            }
        }

        if(rca.TM_Service_Request_Account__c == null && String.isNotBlank(contactId) && String.isNotBlank(accountId)) {
            for(TM_Service_Request_Contact__c c : relatedSm.contactRelationships) {
                if(c.Contact__c == contactId) {
                    rca.TM_Service_Request_Contact__c = c.Id;
                    break;
                }
            }
            for(TM_Service_Request_Account__c a : relatedSm.accountRelationships) {
                if(a.EB_Account__c == accountId) {
                    rca.TM_Service_Request_Account__c = a.Id;
                    break;
                }
            }
        }

        return rca;
    }


    private TM_Service_Request__c buildRequestData(List<TmBoarding.SaveSm> requestFields, TmBoarding.RequestPm pm) {
        if(requestFields != null) {
            for(TmBoarding.SaveSm sm : requestFields) {
                String fieldName = m_smExtractor.getValidField(sm);
                if(String.isNotBlank(fieldName)) {
                    Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_NAME, fieldName);
                    if(m_fieldMapper.IsFieldUpdatable(fld)) {
                            Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                            pm.requestPm.put(fld, o);                 
                    }
                }
            }
        }
        
        return pm.requestPm;
    }

    private TM_Service_Request_Packet__c buildPacketData(List<TmBoarding.SaveSm> packetFields, TmBoarding.RequestPm pm){
        if(packetFields != null) {
            for(TmBoarding.SaveSm sm: packetFields){
                String fieldName = m_smExtractor.getValidField(sm);
                if(String.isNotBlank(fieldName)){
                    Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_PACKET_NAME, fieldName);
                    if(m_fieldMapper.IsFieldAccessible(fld)){
                        Object o = m_fieldMapper.Convert(fld, sm.fieldValue);
                        pm.packetPm.put(fld, o);
                    }
                }
            }
        }
        return pm.packetPm;
    }

    private List<Contact> buildContactsData(Map<String, List<TmBoarding.SaveSm>> fields, TmBoarding.RequestPm pm) {
        List<Contact> objects = new List<SObject>();
        for(Contact c : pm.contactPms) {
            String cId = String.valueOf(c.Id);
            List<TmBoarding.SaveSm> contactFields = fields.get(cId);
            if(contactFields != null){
                for(TmBoarding.SaveSm sm : contactFields) {         
                    String fieldName = m_smExtractor.getValidField(sm);
                    if(String.isNotBlank(fieldName)) {                 
                        Schema.SObjectField fld = m_fieldMapper.getField(CONTACT_NAME, fieldName);
                        if(m_fieldMapper.IsFieldUpdatable(fld)) {                     
                            Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                            c.put(fld, o);           
                        }
                    }
                }
            }
            objects.add(c);
        }

        return objects;
    }

    private List<EB_Account__c> buildAccountsData(Map<String, List<TmBoarding.SaveSm>> fields, TmBoarding.RequestPm pm) {
        
        Map<Id, Eb_Account__c> accountPms = new Map<Id, Eb_Account__c>();
        for(Eb_Account__c a : pm.accountPms){
            accountPms.put(a.id, a);
        }

        if(pm.serviceAccountPms != null){
            for(Tm_Service_Request_Account__c r: pm.serviceAccountPms){
                if(!accountPms.containsKey(r.Eb_Account__c)){
                    accountPms.put(r.Eb_Account__c, r.Eb_Account__r);
                }
            }
        }


        List<EB_Account__c> objects = new List<EB_Account__c>();
        for(Eb_Account__c a : accountPms.values()) {
            String aId = String.valueOf(a.Id);
            List<TmBoarding.SaveSm> accountFields = fields.get(aId);
            if(accountFields != null) {
                for(TmBoarding.SaveSm sm : accountFields) {
                    String fieldName = m_smExtractor.getValidField(sm);
                    if(String.isNotBlank(fieldName)) {
                        Schema.SObjectField fld = m_fieldMapper.getField(ACCOUNT_NAME, fieldName);
                        if(m_fieldMapper.IsFieldUpdatable(fld)) {
                            Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                            a.put(fld, o);
                        }
                    }
                }
            }
            objects.add(a);
        }

        return objects;
    }

    private Map<String, TM_Service_Request_Account__c> buildAccountRequests(Map<String, List<TmBoarding.SaveSm>> fields, List<TM_Service_Request_Account__c> serviceAccounts, Map<String, TM_Service_Request_Account__c> serviceAccountPms) {
        Map<String, TM_Service_Request_Account__c> objects = new Map<String, TM_Service_Request_Account__c>();

        if(fields == null) return objects;
        Set<String> notFoundIds = new Set<String>();

        for(String key : fields.keyset()) {
            boolean foundId = false;
            for(TM_Service_Request_Account__c rc : serviceAccounts) {
                String rcId = String.valueOf(rc.Id);
                if(key == rcId) {
                    foundId = true;
                }
            }
            if(!foundId) {notFoundIds.add(key);}
        }

        if(serviceAccounts == null) return objects;
        for(TM_Service_Request_Account__c cr : serviceAccounts) {
            String crId = String.valueOf(cr.Id);
            List<TmBoarding.SaveSm> requestAccountFields = fields.get(crId);

            if(requestAccountFields != null) {
                for(TmBoarding.SaveSm sm : requestAccountFields) {
                    String fieldName = m_smExtractor.getValidField(sm);
                    if(String.isNotBlank(fieldName)) {
                        Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_ACCOUNT_NAME, fieldName);
                        if(m_fieldMapper.IsFieldUpdatable(fld)) {                          
                            Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                            cr.put(fld, o);
                        }
                    }
                }
            }
            objects.put(String.valueOf(cr.Id), cr);
        }

        for(String key : notFoundIds) {
            TM_Service_Request_Account__c rc = serviceAccountPms.get(key);
            if(rc != null){
                List<TmBoarding.SaveSm> requestAccountFields = fields.get(key);
                if(requestAccountFields != null) {
                    for(TmBoarding.SaveSm sm : requestAccountFields) {
                        String fieldName = m_smExtractor.getValidField(sm);
                        if(String.isNotBlank(fieldName)) {
                            Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_ACCOUNT_NAME, fieldName);
                            if(m_fieldMapper.IsFieldUpdatable(fld)) {                          
                                Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                                rc.put(fld, o);
                            }
                        }
                    }
                    objects.put(String.valueOf(rc.Id), rc);
                }
            
            }
        }

        return objects;
    }

    private Map<String , TM_Service_Request_Contact__c> buildContactRequests( Map<String, List<TmBoarding.SaveSm>> fields, List<TM_Service_Request_Contact__c> serviceContacts, Map<String, TM_Service_Request_Contact__c> serviceContactPms) {
        Map<String, TM_Service_Request_Contact__c> objects = new Map<String, TM_Service_Request_Contact__c>();
        if(fields == null) return objects;
        Set<String> notFoundIds = new Set<String>();

        for(String key : fields.keyset()) {
            boolean foundId = false;
            for(TM_Service_Request_Contact__c rc : serviceContacts) {
                String rcId = String.valueOf(rc.Id);
                if(key == rcId) {
                    foundId = true;
                }
            }
            if(!foundId) {notFoundIds.add(key);}
        }


        if(serviceContacts == null) return objects;
        for(TM_Service_Request_Contact__c cr : serviceContacts) {
            String crId = String.valueOf(cr.Id);
            List<TmBoarding.SaveSm> requestContactFields = fields.get(crId);

            if(requestContactFields != null) {
                for(TmBoarding.SaveSm sm : requestContactFields) {
                    String fieldName = m_smExtractor.getValidField(sm);
                    if(String.isNotBlank(fieldName)) {
                        Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_CONTACT_NAME, fieldName);
                        if(m_fieldMapper.IsFieldUpdatable(fld)) {                          
                            Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                            cr.put(fld, o);
                        }
                    }
                }
            }
            objects.put(String.valueOf(cr.Id), cr);
        }


        for(String key : notFoundIds) {
            TM_Service_Request_Contact__c rc = serviceContactPms.get(key);
            if(rc != null){
                List<TmBoarding.SaveSm> requestContactFields = fields.get(key);
                if(requestContactFields != null) {
                    for(TmBoarding.SaveSm sm : requestContactFields) {
                        String fieldName = m_smExtractor.getValidField(sm);
                        if(String.isNotBlank(fieldName)) {
                            Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_CONTACT_NAME, fieldName);
                            if(m_fieldMapper.IsFieldUpdatable(fld)) {                          
                                Object o = m_fieldMapper.convert(fld, sm.fieldValue);
                                rc.put(fld, o);
                            }
                        }
                    }
                    objects.put(String.valueOf(rc.Id), rc);
                }
            
            }
        }
        
        return objects;
    }
}