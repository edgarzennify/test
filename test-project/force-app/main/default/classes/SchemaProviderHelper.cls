public class SchemaProviderHelper implements SchemaProvider.ISchemaProviderHelper {
    
    private SObjectFieldFactory.ISObjectFieldFactory m_fieldFactory;
    private final CachedMap.ICachedMap m_cache;

    public SchemaProviderHelper(SObjectFieldFactory.ISObjectFieldFactory fieldFactory, CachedMap.ICachedMap cache) {
        m_fieldFactory = fieldFactory;
        m_cache = cache;
    }

    public Map<String, ISObjectField> getFieldMap(String objectName) {
        Map<String, ISObjectField> fields = new Map<String, ISObjectField>();
        Map<String, Schema.SObjectField> fieldMap = getSobjectFields(objectName);
        
        for (String key : fieldMap.keyset()) {
            fields.put(key, m_fieldFactory.getInstance(fieldMap.get(key)));
        }
        return fields;
    }
    
    public ISObjectType getSObjectType(String objectName) {
        String key = 'SchemaProvider.globalDescribeResult.' + objectName;

        if (!m_cache.containsKey(key)) {
            m_cache.put(key, Schema.getGlobalDescribe().get(objectName));
        }

        return new SObjectTypeWrapper((Schema.SObjectType)m_cache.get(key));
    }

    private Map<String, Schema.SObjectField> getSobjectFields(String objectName) {
        String key = 'SchemaProvider.globalDescribeResultFieldMap.' + objectName; 

        if (!m_cache.containsKey(key)) {
            m_cache.put(key, Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap());
        }
        return (Map<String, Schema.SObjectField>)m_cache.get(key);
    }
}