public interface IJson {
    String serialize(Object objectToSerialize);
    String serializePretty(Object objectToSerialize);
    Object deserialize(String jsonString, System.Type apexType);
}