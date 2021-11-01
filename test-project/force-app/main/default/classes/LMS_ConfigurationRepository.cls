public class LMS_ConfigurationRepository implements LMS_LoanMetricSubstage.ILMS_ConfigurationRepository {
    
    private static LMS_LoanMetricSubstage.ILMS_DataProvider m_dataProvider;
    private static CachedMap.ICachedMap m_cache;
    private String LMS_KEYWITHDETAILS = 'LMS_KEYWITHDETAILS';
    private String LMS_KEYWITHOUTDETAILS = 'LMS_KEYWITHOUTDETAILS';

    public LMS_ConfigurationRepository(LMS_LoanMetricSubstage.ILMS_DataProvider dataProvider, CachedMap.ICachedMap cache){
        m_dataProvider = dataProvider;
        m_cache = cache;
    }

    public List<LMS_LoanMetricSubstage.LMS_Definition> getDefinitionsWithDetails(){
        if (!m_cache.containsKey(LMS_KEYWITHDETAILS)) {
            loadDefinitions();
        } 
        return (List<LMS_LoanMetricSubstage.LMS_Definition>)m_cache.get(LMS_KEYWITHDETAILS);
    }

    public List<LMS_LoanMetricSubstage.LMS_Definition> getDefinitionsWithoutDetails(){
        if (!m_cache.containsKey(LMS_KEYWITHOUTDETAILS)) {
            loadDefinitions();
        } 
        return (List<LMS_LoanMetricSubstage.LMS_Definition>)m_cache.get(LMS_KEYWITHOUTDETAILS);
    }

    private void loadDefinitions(){
        m_cache.put(LMS_KEYWITHDETAILS, new List<LMS_LoanMetricSubstage.LMS_Definition>());
        m_cache.put(LMS_KEYWITHOUTDETAILS, new List<LMS_LoanMetricSubstage.LMS_Definition>());

        for (LMS_LoanMetricSubstage.LMS_Definition d : m_dataProvider.getDefinitions()) {
            if (d.detailsRequired) {
                addDetailsToList(d, LMS_KEYWITHDETAILS);
            } else {
                addDetailsToList(d, LMS_KEYWITHOUTDETAILS);
            }
        }
    }

    private void addDetailsToList(LMS_LoanMetricSubstage.LMS_Definition d, String key){
        ((List<LMS_LoanMetricSubstage.LMS_Definition>)m_cache.get(key)).add(d);
    }
}