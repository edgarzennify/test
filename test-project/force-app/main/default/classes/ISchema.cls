public interface ISchema {
	ISObjectField getField(string objectName, string fieldName);
	List<ISObjectField> getFields(string objectName);
	Map<string, ISObjectField> getFieldMap(string objectName); 
	ISObjectType getSObjectType(String objectName);
}