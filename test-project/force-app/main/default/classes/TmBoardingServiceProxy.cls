public class TmBoardingServiceProxy implements ITmBoardingServiceProxy {

    public interface ITmBoardingServiceProxy {
        SvcResponse sendForSignature(List<HtmlToSignatureRequest> request);
        void sendMaintenanceStatus(String requestAsJson);
    }
    
    private final String SERVICE_API_NAME = 'TmBoardingServiceUrl';
    private final String GENERATE_SERVICE_RESOURCE = '/sendforsignature';
    private final String GENERATE_MAINTENANCE_SERVICE_RESOURCE = '/maintenance/update/status';

    private final String EMPTY_JSON_DATA = '{}';

    private final WebServices.IRESTService m_svc;
    private final IJson m_json;

    public TmBoardingServiceProxy(WebServices.IRESTService svc, IJson json){
        m_svc = svc;
        m_json = json;
    }

    public SvcResponse sendForSignature(List<HtmlToSignatureRequest> request){
        if(request == null) {return null; }
        String requestAsJson = m_json.serialize(request);
        return post(requestAsJson, GENERATE_SERVICE_RESOURCE);      
    }

    public void sendMaintenanceStatus(String requestAsJson){
        if(String.isBlank(requestAsJson)) {return;}
        RESTUtility.result res = m_svc.POST(SERVICE_API_NAME, GENERATE_MAINTENANCE_SERVICE_RESOURCE, requestAsJson);
    }

    private SvcResponse post(String request, String resource) {
        RESTUtility.result res = m_svc.POST(SERVICE_API_NAME, resource, request);
        if(res.status.contains('OK')){
            return (SvcResponse) m_json.deserialize(res.response, SvcResponse.class);
        }
        return null;
    }

    public class HtmlToSignatureRequest 
    {
        public Integer ApplicationId {get;set;}
        public string PacketId { get; set; }
        public string RequestId { get; set; }
        public string ClientName{get;set;}
        public string ProductType { get; set; }
        public string DocumentProfileName { get; set; }
        public List<ClientInfo> Clients { get; set; }
        public string Base64HtmlTemplate { get; set; }
        public Blob PdfBytes {get;set;} 
        public boolean HasInitials {get;set;}
        public string MimeType { get; set; }
        public string ReportDataJson { get; set; }
    }

    public class ClientInfo
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Initial { get; set; }
        public string EmailAddress { get; set; }
        public string SignatureRoleIdentifier { get; set; }
        public integer SignatureRolePriority { get; set; }
        public string SecurityCode { get; set; }
    }

    public class SvcResponse
    {
        public string TransactionId { get; set; }
        public boolean Status { get; set; }
    }

    public class TmMaintenanceStatusUpdateRequest{
        public string SyncKey{get;set;}
        public string Status{get;set;}
        public string SalesforceId{get;set;}
    }
}