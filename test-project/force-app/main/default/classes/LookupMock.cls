@IsTest
public class LookupMock {
	
    public class ofILookup extends ApexMoq implements Lookup.ILookup {
        public List<Lookup.Response> search(String sObjectName, string lookupField, string searchItem){
            return (List<Lookup.Response>)handleMethodInvocation('search', new List<Object>{sObjectName,lookupField,searchItem});
        }
        public List<Lookup.Response> searchInFields(Lookup.Request req){
            return (List<Lookup.Response>)handleMethodInvocation('searchInFields', new List<Object>{req});
        }
    }
    
    public class ofIHelper extends ApexMoq implements Lookup.IHelper {
        public String buildQuery(String searchItem, List<String> searchInFields, String referenceObjectName){
            return (String)handleMethodInvocation('buildQuery', new List<Object>{searchItem,searchInFields, referenceObjectName});
        }
        public string getReferenceObjectFromField(String sObjectName, String lookupFieldName){
            return (String)handleMethodInvocation('getReferenceObjectFromField', new List<Object>{sObjectName, lookupFieldName});
        }
        public Lookup.Response buildResponse(String lookupField, String sObjectName, String referenceObjectName, List<DataProvider.DynamicQueryFieldResult> fieldValues){
            return (Lookup.Response)handleMethodInvocation('buildResponse', new List<Object>{lookupField, sObjectName,referenceObjectName,fieldValues });
        }
    }
}