public class TmBoardingSmBuilderHelper implements TmBoarding.ISmBuilderHelper {
    private final String TM_REQUEST_NAME = 'tm_service_request__c';
    private final String CONTACT_NAME = 'contact';
    private final String ACCOUNT_NAME = 'eb_account__c';
    private final String TM_REQUEST_CONTACT_NAME = 'tm_service_request_contact__c';
    private final String TM_REQUEST_ACCOUNT_NAME = 'tm_service_request_account__c';
    private final String TM_REQUEST_CONTACT_ACCOUNT_NAME = 'tm_service_request_contact_account__c';
    private final String CONTACT_ACCOUNT_KEY_DELIM = '\\|';

    private final TmBoarding.ISmExtractor m_smExtractor;
    private final TmBoarding.IFieldMapManager m_fieldMapper;
    private final Utility.IUtility m_util;

    public TmBoardingSmBuilderHelper(TmBoarding.ISmExtractor smExtractor , TmBoarding.IFieldMapManager fieldMapper, Utility.IUtility util) {
        m_smExtractor = smExtractor;
        m_fieldMapper = fieldMapper;
        m_util = util;
    }
    
	public TmBoarding.RelatedSm buildServiceContacts(TmBoarding.RelatedSm relatedSm, TmBoarding.coreSm coreSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestConfigPm metadata, TmBoarding.RequestPm pm) {
        
        Map<String, TM_Service_Request_Contact__c> serviceContacts = new Map<String, TM_Service_Request_Contact__c>();
        
        if(pm.serviceContactPms != null) {
            For(TM_Service_Request_Contact__c rc : pm.serviceContactPms) {
                serviceContacts.put(String.valueOf(rc.Contact__c) , rc);
            }
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
                        if(relatedSm.contactRelationships == null) {
                            relatedSm.contactRelationships = new List<tm_service_request_contact__c>();
                        }
                        relatedSm.contactRelationships.add(newRc);
                    }
                }else{
                    if(rc != null) {
                        if( relatedSm.deleteContactRelationships == null) {
                            relatedSm.deleteContactRelationships = new List<tm_service_request_contact__c>();
                        }
                        relatedSm.deleteContactRelationships.add(rc);
                    }
                }
            }
        }

        return relatedSm;
    }

    public List<TM_Service_Request_Contact__c> buildNewServiceRequestContact(TmBoarding.relatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestConfigPm metadata, TmBoarding.RequestPm pm) {
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

    public List<TM_Service_Request_Account__c> buildNewServiceRequestAccount(TmBoarding.relatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestConfigPm metadata, TmBoarding.RequestPm pm) {
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

    public TmBoarding.RelatedSm buildServiceAccounts(TmBoarding.RelatedSm relatedSm, TmBoarding.coreSm coreSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestConfigPm metadata, TmBoarding.RequestPm pm) {
        Map<String, TM_Service_Request_Account__c> serviceAccounts = new Map<String, TM_Service_Request_Account__c>();
        if(pm.serviceAccountPms != null){
            for(TM_Service_Request_Account__c rc : pm.serviceAccountPms) {
                serviceAccounts.put(String.valueOf(rc.EB_Account__c) , rc);
            }
        }

        for(EB_Account__c a : coreSm.accounts) {
            String aId = String.valueOf(a.Id);
            Map<String, Object> selectedAccount = m_smExtractor.getSelectedFields(aId, sms);
            if(selectedAccount.keySet().size() > 0) {
                boolean selected = (boolean)selectedAccount.get(aId);
                TM_Service_Request_Account__c ra = serviceAccounts.get(aId);
                if(selected == true) {
                    if(ra == null){
                        TM_Service_Request_Account__c newRa = new TM_Service_Request_Account__c();
                        newRa.TM_Service_Request__c = pm.requestPm.Id;
                        newRa.EB_Account__c = aId;
                        if(relatedSm.accountRelationships == null) {
                            relatedSm.accountRelationships = new List<TM_Service_Request_Account__c>();
                        }
                        relatedSm.accountRelationships.add(newRa);
                    }
                }else{
                    if(ra != null) {
                        if(relatedSm.deleteAccountRelationships == null) {
                            relatedSm.deleteAccountRelationships = new List<TM_Service_Request_Account__c>();
                        }
                        relatedSm.deleteAccountRelationships.add(ra);
                    }
                }
            }
        }

        return relatedSm;
    }

    
    public List<TM_Service_Request_Contact_Account__c> buildNewContactAccount(TmBoarding.RelatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestConfigPm metadata, TmBoarding.RequestPm pm) {
        List<TM_Service_Request_Contact_Account__c> newContactAccounts = new List<TM_Service_Request_Contact_Account__c>();
        Map<String, List<TmBoarding.SaveSm>> newRequestContactAccountSms = m_smExtractor.getObjectsByParentAndRelated(TM_REQUEST_CONTACT_ACCOUNT_NAME, sms);
        if(newRequestContactAccountSms == null) return null;

        for(String key : newRequestContactAccountSms.keySet()) {
                List<TmBoarding.SaveSm> contactAccountFields = newRequestContactAccountSms.get(key);

                if(contactAccountFields != null) {
                    TM_Service_Request_Contact_Account__c rca = buildContactAccountLookups(key, pm);

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

    //public TM_Service_Request__c buildRequestData(List<TmBoarding.SaveSm> requestFields, TmBoarding.RequestPm pm) {
    //    for(TmBoarding.SaveSm sm : requestFields) {
    //        String fieldName = m_smExtractor.getValidField(sm);
    //        if(String.isNotBlank(fieldName)) {
    //            Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_NAME, fieldName);
    //            if(m_fieldMapper.IsFieldUpdatable(fld)) {
    //                    Object o = m_fieldMapper.convert(fld, sm.fieldValue);
    //                    pm.requestPm.put(fld, o);                 
    //            }
    //        }
    //    }
    //    return pm.requestPm;
    //}

    //public List<Contact> buildContactsData(Map<String, List<TmBoarding.SaveSm>> fields, TmBoarding.RequestPm pm) {
    //    List<Contact> objects = new List<SObject>();
    //    for(Contact c : pm.contactPms) {
    //        String cId = String.valueOf(c.Id);
    //        List<TmBoarding.SaveSm> contactFields = fields.get(cId);
    //        if(contactFields != null){
    //            for(TmBoarding.SaveSm sm : contactFields) {         
    //                String fieldName = m_smExtractor.getValidField(sm);
    //                if(String.isNotBlank(fieldName)) {                 
    //                    Schema.SObjectField fld = m_fieldMapper.getField(CONTACT_NAME, fieldName);
    //                    if(m_fieldMapper.IsFieldUpdatable(fld)) {                     
    //                        Object o = m_fieldMapper.convert(fld, sm.fieldValue);
    //                        c.put(fld, o);           
    //                    }
    //                }
    //            }
    //        }
    //        objects.add(c);
    //    }
    //    return objects;
    //}

    //public List<EB_Account__c> buildAccountsData(Map<String, List<TmBoarding.SaveSm>> fields, TmBoarding.RequestPm pm) {
    //    List<EB_Account__c> objects = new List<EB_Account__c>();
    //    for(Eb_Account__c a : pm.accountPms) {
    //        String aId = String.valueOf(a.Id);
    //        List<TmBoarding.SaveSm> accountFields = fields.get(aId);
    //        if(accountFields != null) {
    //            for(TmBoarding.SaveSm sm : accountFields) {
    //                String fieldName = m_smExtractor.getValidField(sm);
    //                if(String.isNotBlank(fieldName)) {
    //                    Schema.SObjectField fld = m_fieldMapper.getField(ACCOUNT_NAME, fieldName);
    //                    if(m_fieldMapper.IsFieldUpdatable(fld)) {
    //                        Object o = m_fieldMapper.convert(fld, sm.fieldValue);
    //                        a.put(fld, o);
    //                    }
    //                }
    //            }
    //        }
    //        objects.add(a);
    //    }
    //    return objects;
    //}

    //public Map<String, TM_Service_Request_Account__c> buildAccountRequests(Map<String, List<TmBoarding.SaveSm>> fields, List<TM_Service_Request_Account__c> serviceAccounts, Map<String, TM_Service_Request_Account__c> serviceAccountPms) {
    //    Map<String, TM_Service_Request_Account__c> objects = new Map<String, TM_Service_Request_Account__c>();

    //    if(fields == null) return objects;
    //    Set<String> notFoundIds = new Set<String>();

    //    for(String key : fields.keyset()) {
    //        boolean foundId = false;
    //        for(TM_Service_Request_Account__c rc : serviceAccounts) {
    //            String rcId = String.valueOf(rc.Id);
    //            if(key == rcId) {
    //                foundId = true;
    //            }
    //        }
    //        if(!foundId) {notFoundIds.add(key);}
    //    }

    //    if(serviceAccounts == null) return objects;
    //    for(TM_Service_Request_Account__c cr : serviceAccounts) {
    //        String crId = String.valueOf(cr.Id);
    //        List<TmBoarding.SaveSm> requestAccountFields = fields.get(crId);

    //        if(requestAccountFields != null) {
    //            for(TmBoarding.SaveSm sm : requestAccountFields) {
    //                String fieldName = m_smExtractor.getValidField(sm);
    //                if(String.isNotBlank(fieldName)) {
    //                    Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_ACCOUNT_NAME, fieldName);
    //                    if(m_fieldMapper.IsFieldUpdatable(fld)) {                          
    //                        Object o = m_fieldMapper.convert(fld, sm.fieldValue);
    //                        cr.put(fld, o);
    //                    }
    //                }
    //            }
    //        }
    //        objects.put(String.valueOf(cr.Id), cr);
    //    }

    //    for(String key : notFoundIds) {
    //        TM_Service_Request_Account__c rc = serviceAccountPms.get(key);
    //        if(rc != null){
    //            List<TmBoarding.SaveSm> requestAccountFields = fields.get(key);
    //            if(requestAccountFields != null) {
    //                for(TmBoarding.SaveSm sm : requestAccountFields) {
    //                    String fieldName = m_smExtractor.getValidField(sm);
    //                    if(String.isNotBlank(fieldName)) {
    //                        Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_ACCOUNT_NAME, fieldName);
    //                        if(m_fieldMapper.IsFieldUpdatable(fld)) {                          
    //                            Object o = m_fieldMapper.convert(fld, sm.fieldValue);
    //                            rc.put(fld, o);
    //                        }
    //                    }
    //                }
    //                objects.put(String.valueOf(rc.Id), rc);
    //            }
            
    //        }
    //    }


    //    return objects;
    //}

    //public Map<String , TM_Service_Request_Contact__c> buildContactRequests( Map<String, List<TmBoarding.SaveSm>> fields, List<TM_Service_Request_Contact__c> serviceContacts, Map<String, TM_Service_Request_Contact__c> serviceContactPms) {
    //    Map<String, TM_Service_Request_Contact__c> objects = new Map<String, TM_Service_Request_Contact__c>();
    //    if(fields == null) return objects;
    //    Set<String> notFoundIds = new Set<String>();

    //    for(String key : fields.keyset()) {
    //        boolean foundId = false;
    //        for(TM_Service_Request_Contact__c rc : serviceContacts) {
    //            String rcId = String.valueOf(rc.Id);
    //            if(key == rcId) {
    //                foundId = true;
    //            }
    //        }
    //        if(!foundId) {notFoundIds.add(key);}
    //    }


    //    if(serviceContacts == null) return objects;
    //    for(TM_Service_Request_Contact__c cr : serviceContacts) {
    //        String crId = String.valueOf(cr.Id);
    //        List<TmBoarding.SaveSm> requestContactFields = fields.get(crId);

    //        if(requestContactFields != null) {
    //            for(TmBoarding.SaveSm sm : requestContactFields) {
    //                String fieldName = m_smExtractor.getValidField(sm);
    //                if(String.isNotBlank(fieldName)) {
    //                    Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_CONTACT_NAME, fieldName);
    //                    if(m_fieldMapper.IsFieldUpdatable(fld)) {                          
    //                        Object o = m_fieldMapper.convert(fld, sm.fieldValue);
    //                        cr.put(fld, o);
    //                    }
    //                }
    //            }
    //        }
    //        objects.put(String.valueOf(cr.Id), cr);
    //    }


    //    for(String key : notFoundIds) {
    //        TM_Service_Request_Contact__c rc = serviceContactPms.get(key);
    //        if(rc != null){
    //            List<TmBoarding.SaveSm> requestContactFields = fields.get(key);
    //            if(requestContactFields != null) {
    //                for(TmBoarding.SaveSm sm : requestContactFields) {
    //                    String fieldName = m_smExtractor.getValidField(sm);
    //                    if(String.isNotBlank(fieldName)) {
    //                        Schema.SObjectField fld = m_fieldMapper.getField(TM_REQUEST_CONTACT_NAME, fieldName);
    //                        if(m_fieldMapper.IsFieldUpdatable(fld)) {                          
    //                            Object o = m_fieldMapper.convert(fld, sm.fieldValue);
    //                            rc.put(fld, o);
    //                        }
    //                    }
    //                }
    //                objects.put(String.valueOf(rc.Id), rc);
    //            }
            
    //        }
    //    }
        
    //    return objects;
    //}

    private TM_Service_Request_Contact_Account__c buildContactAccountLookups(String key, TmBoarding.RequestPm pm) {
        TM_Service_Request_Contact_Account__c rca = new TM_Service_Request_Contact_Account__c();
        List<String> relationshipIds = key.split(CONTACT_ACCOUNT_KEY_DELIM);

        if(relationshipIds == null || relationshipIds.size() != 2 ) return null;

        String object1Name = m_util.getObjectNameFromId(relationshipIds[0]);
        String object2Name = m_util.getObjectNameFromId(relationshipIds[1]);
        String contactId;
        String accountId;
        Id requestContactId;
        Id requestAccountId;

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
            String rcContactId15 = get15CharFromId(rc.Contact__c);
            String contactId15 = get15CharFromId(contactId);
            if(rcContactId15 == contactId15) {
                rca.TM_Service_Request_Contact__c = rc.Id;
                break;
            }
        }

        for(TM_Service_Request_Account__c rc : pm.serviceAccountPms) {
            String rcAccountId15 = get15CharFromId(rc.Eb_Account__c);
            String accountId15 = get15CharFromId(accountId);
            if(rcAccountId15 == accountId15) {
                rca.TM_Service_Request_Account__c = rc.Id;
                break;
            }
        }

        return rca;

    }

    private String get15CharFromId(String objId) {
        String id15 = '';
        if(String.IsNotBlank(objId) && objId.length() > 14) {
            id15 = objId.substring(0, 14);
        }
        return id15;
    }


    
}