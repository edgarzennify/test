public class ObjectForwardDataProvider implements ObjectForward.IDataProvider {
    
    private final ObjectForward.IDmBuilder m_dmBuilder;
    
    public ObjectForwardDataProvider (ObjectForward.IDmBuilder dmBuilder){
        m_dmBuilder = dmBuilder;
    }
    
    public List<ObjectForward.DmForward> getForwards(String origObjName, String origObjRecordTypeName){
        List<Object_Forward__mdt> objForwards =
               [SELECT   OriginalObjectRecordTypeName__c
                        ,OriginalObjectName__c
                        ,OriginalObjectLookupField__c
                        ,ForwardObjectName__c
                        ,ForwardObjectLookupField__c
                        ,Active__c
                        ,Show_Interstitial__c 
                  FROM  Object_Forward__mdt 
                  WHERE OriginalObjectName__c =: origObjName
                        AND OriginalObjectRecordTypeName__c =: origObjRecordTypeName
                        AND Active__c = true
               ];
        
        return m_dmBuilder.buildDmForwards(objForwards);        
    }

    public SObject queryOne(String queryString){
        return Database.query(queryString);
    }

    public List<SObject> query(String queryString){
        return Database.query(queryString);
    }
}