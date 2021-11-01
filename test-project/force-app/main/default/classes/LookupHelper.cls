public class LookupHelper implements Lookup.IHelper {
    private final String ID_FIELD = 'Id';

    private final ISchema m_schema;

    public LookupHelper(ISchema schema){
        m_schema = schema;
    }

    public String buildQuery(String searchItem, List<String> SearchInFields, String referenceObjectName){
        String search = sanatize(SearchItem);
        String likeClause = buildLikeClause(SearchInFields, search);
        String joined = String.Join(SearchInFields, ',');
        return String.Format('SELECT {0} FROM {1} WHERE {2}', new List<String>{joined, referenceObjectName, likeClause});
    }

    public string getReferenceObjectFromField(String sObjectName, String lookupFieldName){
        ISObjectType sType = m_schema.getSObjectType(sObjectName);
        IDescribeSObjectResult sObjectResult = sType.getDescribe();
        IDescribeFieldResult fieldResult = sObjectResult.getFieldResult(LookupFieldName);

        for(ISObjectType ref : fieldResult.getReferenceTo()){
            return ref.getDescribe().getName();
        }

        return '';
    }

    public Lookup.Response buildResponse(String lookupField, String sObjectName, String referenceObjectName, List<DataProvider.DynamicQueryFieldResult> fieldValues){
        Lookup.Response res = new Lookup.Response();
        res.LookupFieldName = LookupField;
        res.SObjectName = SObjectName;
        res.LookupSObjectName = referenceObjectName;
        res.fieldNameValues = new Map<String, Object>();
        for(DataProvider.DynamicQueryFieldResult f : fieldValues){
            res.fieldNameValues.put(f.fieldName, f.fieldValue);
        }
        return res;
    }

    private String buildLikeClause(List<String> fields, String searchItem){
        String x = '';
        for(String f : fields){
            if(f.tolowercase() != ID_FIELD.tolowercase()){
                x += String.Format(' {0} LIKE {1} OR ', new List<String>{f, searchItem});
            }
        }

        return x.endsWith('OR ')?x.mid(0, x.length() - 3): x;
    }

    private string sanatize(String searchTerm){
        if(searchTerm == null || searchTerm == '') return '';
                        
        searchTerm = searchTerm.replace('*', ' ');                      
        searchTerm = searchTerm.trim();
        searchTerm = searchTerm.replace('  ', ' ');
        searchTerm = searchTerm.replace('  ', ' ');
        searchTerm = searchTerm.replace(' ', '%');
        searchTerm = '\'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
        
        if(searchTerm == '%%') return ''; 
        return searchTerm;
    }

}