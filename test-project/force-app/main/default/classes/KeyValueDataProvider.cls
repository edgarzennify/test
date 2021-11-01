public class KeyValueDataProvider implements IKeyValueDataProvider {
    
    public interface IKeyValueDataProvider {
        Object get(Schema.SObjectType soType, String key);
    }

    private final CachedMap.ICachedMap m_cache;
    private final String KEY_NAME = 'Label';
    private final String VALUE_NAME = 'Value__c';

    public KeyValueDataProvider(CachedMap.ICachedMap cache) {
        m_cache = cache;
    }

    public Object get(Schema.SObjectType soType, String key) {
        String cacheKey = String.valueOf(soType) + key;
        Map<String, Object> configs = getConfigs(soType, cacheKey);
        
        if (configs.containsKey(key.toUpperCase())) {
            return configs.get(key.toUpperCase());
        } else {
            throw new ApplicationException('Key was not found in custom metadata configurations.');
        }
    }

    private Map<String, Object> getConfigs(Schema.SObjectType soType, String cacheKey) {
        if (m_cache.containsKey(cacheKey)) {
            return (Map<String, Object>)m_cache.get(cacheKey);
        }
        return loadSettings(soType, cacheKey);
    }

    private Map<String, Object> loadSettings(Schema.SObjectType soType, String cacheKey) {
        List<SObject> settings = getRecords(soType, cacheKey);
        Map<String, Object> output = convertToMap(settings);
        m_cache.put(cacheKey, output);
        return output;
    }

    private List<SObject> getRecords(Schema.SObjectType soType, String cacheKey) {
        String template = 'SELECT {0}, {1} FROM {2}';
        String query = String.format(template, new List<Object>{KEY_NAME, VALUE_NAME, String.valueOf(soType)});
        
        return Database.query(query);
    }

    private Map<String, Object> convertToMap(List<SObject> sobs) {
        Map<String, Object> output = new Map<String, Object>();
        for (SObject s : sobs) {
            String key = (String)s.get(KEY_NAME);
            output.put(key.toUpperCase(), s.get(VALUE_NAME));
        }
        return output;
    }
}