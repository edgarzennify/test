public class HtmlReportingServiceProxy implements HtmlReportingServiceProxy.IHtmlReportingService {

  public interface IHtmlReportingService {
    Blob getPdf(String staticResourceName, String fileName, String jsonData);
    Blob getPdf(Blob template, String jsonData);
    Blob getHtml(Blob template, String jsonData);
    Blob getMergedPdfs(List<MergeRequest> request);
  }

  private final String SERVICE_API_NAME = 'HtmlReportingUrl';
  private final String GENERATE_SERVICE_RESOURCE = '/generate';
  private final String MERGE_SERVICE_RESOURCE = '/merge';
  private final String AVAILABLE_SERVICE_RESOURCE = '/available?mimetype=application/pdf';
  private final String EMPTY_JSON_DATA = '{}';

  private final WebServices.IRESTService m_svc;
  private final IEncodingUtil m_eutil;
  private final StaticResourceDataProvider.IStaticResource m_staticResource;
  private final IJson m_json;
  private final HtmlCoding.IHtmlCoding m_htmlCoding;

  public HtmlReportingServiceProxy(WebServices.IRESTService svc, IEncodingUtil eutil, StaticResourceDataProvider.IStaticResource staticResource, IJson json, HtmlCoding.IHtmlCoding htmlCoding) {
    m_svc = svc;
    m_eutil = eutil;
    m_staticResource = staticResource;
    m_json = json;
    m_htmlCoding = htmlCoding;
  }
  
  public Blob getPdf(Blob template, String jsonData) {
    if(template == null) {return null;}
    wakeup();
    String requestAsJson = m_json.serialize(build(template, jsonData, MimeType.Pdf));

    SvcResponse response = fetch(requestAsJson, GENERATE_SERVICE_RESOURCE);
    if(response == null) return null;
    return m_eutil.fromBase64(response.base64Report);
  }

  public Blob getHtml(Blob template, String jsonData) {
    if(template == null) {return null;}
    wakeup();
    String requestAsJson = m_json.serialize(build(template, jsonData, MimeType.Html));
    SvcResponse response = fetch(requestAsJson, GENERATE_SERVICE_RESOURCE);
    if(response == null) return null;
    return m_eutil.fromBase64(response.base64Report);
  }

  public Blob getMergedPdfs(List<MergeRequest> request) {
    wakeup();
    SvcMergeRequest req = build(request);
    if(req == null) {return null;}
    String requestAsJson = m_json.serialize(req);
    SvcResponse response = fetch(requestAsJson, MERGE_SERVICE_RESOURCE);
    return m_eutil.fromBase64(response.base64Report);
  }

  public Blob getPdf(String staticResourceName, String fileName, String jsonData) {
    Blob template = m_staticResource.getData(staticResourceName, fileName);
    String requestAsJson = m_json.serialize(build(template, jsonData, MimeType.Pdf));
    SvcResponse response = fetch(requestAsJson, GENERATE_SERVICE_RESOURCE);
    return m_eutil.fromBase64(response.base64Report);
  }

  private SvcResponse fetch(String request, String resource) {
    RESTUtility.result res = m_svc.POST(SERVICE_API_NAME, resource, request);

        if(res.status.contains('OK')){
            return (SvcResponse) m_json.deserialize(res.response, SvcResponse.class);
        }
    return null;
  }

  private HtmlReportingParams build(Blob template, String jsonData, String mimeType) {
    HtmlReportingParams params = new HtmlReportingParams();
    String templateBase64 = m_eutil.toBase64(template);
    String sanitizedJson = m_htmlCoding.httpRequestSanitizer(jsonData);
    params.Base64HtmlTemplate = templateBase64;
    params.ReportDataJson = sanitizedJson;
    params.MimeType = mimeType;
    return params;
  }

  private MergeReportingParams build(List<Blob> pdfBytes) {
    MergeReportingParams params = new MergeReportingParams();
    List<String> base64Pdfs = new List<String>();
    for(Blob b : pdfBytes) {
      base64Pdfs.add(m_eutil.toBase64(b));
    }
    params.PdfsAsBase64 = base64Pdfs;
    return params;
  }

  private SvcMergeRequest build(List<MergeRequest> requests) {
    if(requests == null || requests.size() == 0) return null;
    SvcMergeRequest m = new SvcMergeRequest();
    m.Footer = buildDefaultFooter(requests[0]);
    m.Requests = new List<SvcGenerateRequest>();
    for(MergeRequest r : requests) {
      String sanitizedJson = m_htmlCoding.httpRequestSanitizer(r.JsonData);
      SvcGenerateRequest gr = new SvcGenerateRequest();
      gr.Base64HtmlTemplate = m_eutil.toBase64(r.Template);
      gr.ReportDataJson = sanitizedJson;
      gr.MimeType = MimeType.Pdf;
      m.Requests.add(gr);
    }
      return m;
  }

  private SvcGenerateRequest buildDefaultFooter(MergeRequest request){
    SvcGenerateRequest footer = new SvcGenerateRequest();
    String sanitizedJson = m_htmlCoding.httpRequestSanitizer(request.JsonData);
    footer.Base64HtmlTemplate = m_eutil.toBase64(request.FooterTemplate);
    footer.ReportDataJson = sanitizedJson;
    return footer;
  }

  private void wakeup() {
    try{
      RESTUtility.result res = m_svc.GET(SERVICE_API_NAME, AVAILABLE_SERVICE_RESOURCE);
    }catch(exception ex) {

    }
  }

  private void wakeup_async() {
    try{
      m_svc.GET_Async(SERVICE_API_NAME, AVAILABLE_SERVICE_RESOURCE);
    }catch(exception ex) {

    }
  }

  public class HtmlReportingParams {
    public String Base64HtmlTemplate {get;set;}
        public String ReportDataJson {get;set;}
        public String MimeType {get;set;}
  }

  public class MergeReportingParams
    {
        public List<string> PdfsAsBase64 { get; set; }
    } 

  public class SvcResponse {
        public string base64Report { get; set;}
  }

  ////Merge parameters
   public class MergeRequest {
    public Blob Template {get;set;}
    public String JsonData {get;set;}
    public Blob FooterTemplate {get;set;}
   }

   public class SvcGenerateRequest
    {
        public String Base64HtmlTemplate { get; set; }
        public String ReportDataJson { get; set; }
        public String MimeType { get; set; }
        public Boolean TrimImage { get; set; }
    }

  public class SvcMergeRequest
    {
        public SvcGenerateRequest Footer { get; set; }
        public List<SvcGenerateRequest> Requests { get; set; }
    }
}