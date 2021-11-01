public class JsonWrapper implements IJson{
    public String serialize(Object objectToSerialize){
        return JSON.serialize(objectToSerialize);
    }
    
    public String serializePretty(Object objectToSerialize){
        return JSON.serializePretty(objectToSerialize);
    }
    
    public Object deserialize(String jsonString, System.Type apexType){
        return JSON.deserialize(jsonString, apexType);
    }
}