public class EbObjectLookup implements IEbObjectLookup {
    public interface IEbObjectLookup{
        Id getObjectId(String objectKey);
        Id getObjectId(String objectKey, String keyType);
        KeyAndType getObjectKeyAndType(String contextId);
    }
    
    public interface IDataProvider {
        Account getEntity(String key);
        EB_Account__c getEbAccount(String key);
        EB_Collateral__c getEbCollateral(String key);
        Account getEntity(Id objectId);
        EB_Account__c getEbAccount(Id  objectId);
        EB_Collateral__c getEbCollateral(Id objectId);
    }

    public interface IObjectKeyProcessor {
        boolean isKeyValid(String objectKey);
        String getKeyType(String objectKey);
    }
    
    public class KeyAndType {
        public String objectKey {get;set;}
        public String keyType {get;set;}
        public KeyAndType(){}
        public KeyAndType(String key, String ktype){
            objectKey = key;
            keyType = ktype;
        }
    }
    
    private final String ENTITY_KEY_TYPE = 'entity';
    private final String EBACCOUNT_KEY_TYPE = 'account';
    private final String LLCBILOAN_KEY_TYPE = 'llcbiloan';
    private final String LLCBICOLLATERAL_KEY_TYPE = 'llcbicollateral';
    private EbObjectLookup.IDataProvider m_dataProvider;

    public EbObjectLookup(EbObjectLookup.IDataProvider dataProvder) {
        m_dataProvider = dataProvder;
    }
    
    public Id getObjectId(String objectKey) {
        List<String> keyParts = objectKey.split('-');

        if (keyParts.size() == 1) {
            return getEntity(objectKey);
        }
        
        if (keyParts.size() == 2) {
            if (keyParts[0] == '616') {
                return getEntity(objectKey);
            }
            if (keyParts[0] == 'FID') {
                return getEntity(objectKey);
            }
            return getEbAccount(objectKey);
        }

        if (keyParts.size() == 3 ) {
            if (keyParts[1] == '20') {
                return getEbCollateral(objectKey);
            } 
            return getEbAccount(objectKey);
        }
        
        if (keyParts.size() == 4 ) {            
            return getEbAccount(objectKey);
        }
        
        return null;
    }

    public Id getObjectId(String objectKey, String keyType) {
        String keyTypeLowerCase = keyType.toLowerCase();
        if(keyTypeLowerCase == ENTITY_KEY_TYPE){
            return getEntity(objectKey);
        }              
        if(keyTypeLowerCase == EBACCOUNT_KEY_TYPE){
            if(objectKey.contains('-20-')) return getEbCollateral(objectKey);
            return getEbAccount(objectKey);
        }
        return null;
    }

    public KeyAndType getObjectKeyAndType(String contextId) {
        if(String.isBlank(contextId)){return new KeyAndType();}
        Id objectId = Id.valueof(contextId);

        if(objectId.getSObjectType() == Account.SObjectType) {
            Account a = m_dataProvider.getEntity(objectId);
            if(a != null){
                if(!String.isBlank(a.EB_Customer_Number__c))
                    return new KeyAndType(a.EB_Customer_Number__c, ENTITY_KEY_TYPE);
                else if(!String.isBlank(a.WM_Key__c))
                    return new KeyAndType(a.WM_Key__c, ENTITY_KEY_TYPE);
                else
                    return new KeyAndType(objectId, ENTITY_KEY_TYPE);
            }
        } else if(objectId.getSObjectType() == EB_Account__c.SObjectType) {
            EB_Account__c eb = m_dataProvider.getEbAccount(objectId);
            if(eb != null) {
                return new KeyAndType(eb.Key__c, EBACCOUNT_KEY_TYPE);                
            }
        } else if(objectId.getSobjectType() == EB_Collateral__c.SObjectType) {
            EB_Collateral__c col = m_dataProvider.getEbCollateral(objectId);
            if(col != null){
            	return new KeyAndType(col.Key__c, EBACCOUNT_KEY_TYPE);
            }
        } else if(objectId.getSobjectType() == LLC_BI__Loan__c.SObjectType) {
            return new KeyAndType(objectId, LLCBILOAN_KEY_TYPE);
        } else if(objectId.getSobjectType() == LLC_BI__Collateral__c.SObjectType) {
            return new KeyAndType(objectId, LLCBICOLLATERAL_KEY_TYPE);
        }
        return new KeyAndType();
    }
    
    private Id getEntity(String key) {
        Account entity = m_dataProvider.getEntity(key);
        if(entity != null){
            return entity.Id;
        }
        return null;
    }
    
    private Id getEbAccount(String key) {
        EB_Account__c ebAccount = m_dataProvider.getEbAccount(key);
        if(ebAccount != null){
            return ebAccount.Id;
        }
        return null;
    }
    
    private Id getEbCollateral(String key) {
        EB_Collateral__c col = m_dataProvider.getEbCollateral(key);
        if(col != null){
            return col.Id;
        }
        return null;
    }
}