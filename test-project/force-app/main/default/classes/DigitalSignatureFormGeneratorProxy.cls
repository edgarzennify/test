public class DigitalSignatureFormGeneratorProxy implements IProxy{
	
    public interface IProxy{
        SignatureResponse sendForSignature(SignatureRequest req);
        PdfResponse getPdfAsbase64(SignatureRequest req);
        SignatureStatusDataResponse getData(string appId);
    }

    
    private string SVC_ENDPOINT = 'DigitalFormGeneratorServiceUrl';
    private string RESOURCE_SEND_FOR_SIGNATURE = '/sendforsignature';
    private string RESOURCE_GENERATE_PDF = '/generatepdf';
    private string RESOURCE_GET_ESIGNATURE_DATA = 'esignatureapplication';
    private string STATUS = 'ok';

    private WebServices.IRESTService m_svcUtil;
    private IJson m_jsonUtil;

    public DigitalSignatureFormGeneratorProxy(WebServices.IRESTService svcUtil, IJson jsonUtil){
        m_svcUtil = svcUtil;
        m_jsonUtil = jsonUtil;
    }

    public PdfResponse getPdfAsbase64(SignatureRequest req){
        string requestJson = m_jsonUtil.serialize(req);
        RESTUtility.result res = m_svcUtil.POST(SVC_ENDPOINT, RESOURCE_GENERATE_PDF, requestJson);
        if(String.isNotBlank(res.status) && res.status.toLowerCase() == STATUS){
            return (PdfResponse)m_jsonUtil.deserialize(res.response, PdfResponse.class);
        }
        
        throw new DigitalSignatureFromGeneratorSvcException('Error retriving pdf : '+ res.status);
    }

    public SignatureResponse sendForSignature(SignatureRequest request){
        string requestJson = m_jsonUtil.serialize(request);
        RESTUtility.result res = m_svcUtil.POST(SVC_ENDPOINT, RESOURCE_SEND_FOR_SIGNATURE, requestJson);
        return (SignatureResponse)m_jsonUtil.deserialize(res.response, SignatureResponse.class);
    }

    public SignatureStatusDataResponse getData(string appId){
        string url = String.format('/{0}/{1}', new List<string>{RESOURCE_GET_ESIGNATURE_DATA,appId});
        RESTUtility.result res = m_svcUtil.GET(SVC_ENDPOINT,url);
        SignatureStatusDataResponse response = (SignatureStatusDataResponse)m_jsonUtil.deserialize(res.response, SignatureStatusDataResponse.class);
        return response;
    }
    private SignatureResponse post(string requestJson, string endpoint, String resource) {       
        RESTUtility.result res = m_svcUtil.POST(endpoint, resource, requestJson);
        SignatureResponse response = (SignatureResponse)m_jsonUtil.deserialize(res.response, SignatureResponse.class);
        return response;
    }


    public class SignatureRequest{
        public integer ApplicationId {get; set;}
        public string ReferenceId {get; set;}
        public string DocumentProfileName {get; set;}
        public string TransactionName {get; set;}
        public string TemplateFileName {get; set;}
        public string SignerTemplateFileName {get;set;}
        public Blob TemplateAsBytes{get;set;}
        public boolean IsTemplatePdf {get; set; }
        public boolean IsTemplateDynamic{get;set;}
        public boolean IsSignerAttachmentRequired {get;set;}
        public boolean IsNotificationOnCompleteRequired {get;set;}
        public string NotifyOnCompleteEmail{get;set;}
        public string Comments {get;set;}
        public string DynamicFileTemplateName {get;set;}
        public string UserId {get; set;}
        public string StatusObjectName{get;set;}
        public string StatusFieldName{get;set;}
        public string StatusValue{get;set;}
        public List<SignerInfo> Signers {get;set;}
        public Map<string,string> Data{get;set;}
    }

    public class SignerInfo {
        public string FirstName {get; set;}
        public string LastName {get; set;}
        public string Email {get; set;}
        public string SignerId {get; set;}
        public string Security {get; set;}
        public string SignatureRoleCode {get; set;}
        public integer SignatureRoleOrder{get;set;}
    }

    public class SignatureResponse{
        public boolean Status{get;set;}
        public string TransactionId{get;set;}
    }

    public class PdfRequest{
        public integer ApplicationId { get; set; }
        public string ReferenceId { get; set; }
    }

    public class PdfResponse{
        public List<string> base64Reports{get;set;}
    }

    public class SignatureStatusDataResponse{
        public List<SignatureStatusDataItemResponse> Items{get;set;}
    }

    public class SignatureStatusDataItemResponse{
        public integer ApplicationId { get; set; }
        public string Status { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string SecurityPin { get; set; }
        public string ReferenceId { get; set; }
        public string TransactionId { get; set; }
        public string SentDate { get; set; }
        public string SignedDate { get; set; }
        public string DocumentUrl { get; set; }
        public string NotifyOnCompleteEmail {get;set;}
        public string TemplateFileName {get;set;}
        public string Comments {get;set;}
        public string UserId { get; set; }
        public DateTime Created { get; set; }
    }

    public class PostSignatureFieldUpdate{
        public string StatusObjectName{get;set;}
        public string StatusFieldName{get;set;}
        public string StatusValue{get;set;}
    }

    public class DigitalSignatureFromGeneratorSvcException extends Exception{}
}