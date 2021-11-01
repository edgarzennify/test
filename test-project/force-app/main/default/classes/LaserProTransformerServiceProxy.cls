public class LaserProTransformerServiceProxy implements LaserProTransformer.IService{
    
    private static String SERVICE_API_NAME = 'LaserProTransformerUrl';
    private static String TRIAL_EXPORT_URI = '/export/trial';
    private static String EXPORT_URI = '/export';
    
    private final Webservices.IRESTService m_restService;
    private final IJson m_jsonSerializer;
    
    public LaserProTransformerServiceProxy(Webservices.IRESTService restService, IJson jsonSerializer){
        m_restService = restService;
        m_jsonSerializer = jsonSerializer;
    }

    public LaserProTransformer.LpLoan trialExport(DmLoan dm){
        String requestAsJson = m_jsonSerializer.serialize(dm);
        RESTUtility.result res = m_restService.POST(SERVICE_API_NAME, TRIAL_EXPORT_URI, requestAsJson);

        if(res.status.contains('OK')){
            return (LaserProTransformer.LpLoan) m_jsonSerializer.deserialize(res.response, LaserProTransformer.LpLoan.class);
        }
        return null;
    }
    
    public LaserProTransformer.ExportResponse export(DmLoan dm){
        String requestAsJson = m_jsonSerializer.serialize(dm);
        RESTUtility.result res = m_restService.POST(SERVICE_API_NAME, EXPORT_URI, requestAsJson);

        if(res.status.contains('OK')){
            return (LaserProTransformer.ExportResponse) m_jsonSerializer.deserialize(res.response, LaserProTransformer.ExportResponse.class);
        }
        return null;
    }    
}