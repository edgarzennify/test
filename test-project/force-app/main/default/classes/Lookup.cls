global class Lookup implements ILookup {
    public interface ILookup{
        List<Response> search(String sObjectName, string lookupField, string searchItem);
        List<Response> searchInFields(Request req);
    }

    public interface IHelper{
        String buildQuery(String searchItem, List<String> SearchInFields, String referenceObjectName);
        string getReferenceObjectFromField(String sObjectName, String lookupFieldName);
        Response buildResponse(String lookupField, String sObjectName, String referenceObjectName, List<DataProvider.DynamicQueryFieldResult> fieldValues);
    }

    private final String ID_FIELD = 'Id';
    private final String ID_NAME = 'Name';

    private final IHelper m_helper;
    private final Dataprovider.IDataProvider m_dataProvider;

    public Lookup(IHelper helper, Dataprovider.IDataProvider dataProvider){
        m_helper = helper;
        m_dataProvider = dataProvider;
    }

    public List<Response> search(String sObjectName, string lookupField, string searchItem){
        Request req = new Request();
        req.LookupField = lookupField;
        req.SObjectName = sObjectName;
        req.SearchItem = searchItem;
        req.SearchInFields = new List<string>{ID_FIELD, ID_NAME};
        return searchInFields(req);
    }

    public List<Response> searchInFields(Request req){
        List<Response> responses = new List<Response>();
        String referenceObjectName = m_helper.getReferenceObjectFromField(req.SObjectName, req.LookupField);
        String query = m_helper.buildQuery(req.SearchItem, req.SearchInFields, referenceObjectName);

        for(DataProvider.DynamicQueryResult r : m_dataProvider.executeDynamicQuery(query, req.SearchInFields)){
            Response res = m_helper.buildResponse(req.lookupField, req.sObjectName, referenceObjectName, r.fieldValues); 
            responses.add(res);
        }

        return responses;
    }

    global class Request {
        public String LookupField{get;set;}
        public String SObjectName{get;set;}
        public String SearchItem{get;set;}
        public List<String> SearchInFields{get;set;}
    }

    global class Response{
        public String LookupSObjectName{get;set;}
        public String SObjectName{get;set;}
        public String LookupFieldName{get;set;}
        public Map<String, Object> fieldNameValues{get;set;}
    }

    public static ILookup bootstrap(){
        DataProvider.IDataProvider dp = new DataProvider();
        CachedMap.ICachedMap cache = CachedMap.getInstance();
        SObjectFieldFactory.ISObjectFieldFactory fieldFactory = new SObjectFieldFactory();
        SchemaProvider.ISchemaProviderHelper schemaHelper = new SchemaProviderHelper(fieldFactory, cache);
        ISchema sch = new SchemaProvider(schemaHelper);
        Lookup.IHelper hlp = new LookupHelper(sch);
        return new Lookup(hlp, dp);
    }
}