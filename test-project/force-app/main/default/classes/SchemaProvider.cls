public class SchemaProvider implements ISchema {

    public interface ISchemaProviderHelper {
        Map<String, ISObjectField> getFieldMap(String objectName);
        ISObjectType getSObjectType(String objectName);
    }

    private final ISchemaProviderHelper m_helper;

    public SchemaProvider(ISchemaProviderHelper helper) {
        m_helper = helper;
    }

    public ISObjectField getField(String objectName, String fieldName) {
        return m_helper.getFieldMap(objectName).get(fieldName.toLowerCase());
    }

    public List<ISObjectField> getFields(String objectName) {
    	return m_helper.getFieldMap(objectName).values();
    }

    public Map<String, ISObjectField> getFieldMap(String objectName) {
        return m_helper.getFieldMap(objectName);
    }

    public ISObjectType getSObjectType(String objectName) {
        return m_helper.getSObjectType(objectName);
    }
}