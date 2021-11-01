public class DataViewerDocumentHandler implements DataViewer.IDocumentHandler{
 private final String CONTENT_TYPE = 'application/pdf';
    private final String PDF = 'pdf';
    private final string FOLDER_NAME = 'DataViewer';

    private final HtmlReportingServiceProxy.IHtmlReportingService m_reportingSvc;
    private final Documents.ISalesforceDocumentProvider m_sfDocumentProvider;
    private final ISystem m_sys;
    private final IEncodingUtil m_encodingUtil;
    private final IUserInfoService m_userInfoSvc;

    public DataViewerDocumentHandler(HtmlReportingServiceProxy.IHtmlReportingService reportingSvc,  Documents.ISalesforceDocumentProvider sfDocumentProvider, ISystem sys, IUserInfoService userInfoSvc,  IEncodingUtil encodingUtil){
        m_reportingSvc = reportingSvc;
        m_sfDocumentProvider = sfDocumentProvider;
        m_sys = sys;
        m_userInfoSvc = userInfoSvc;
        m_encodingUtil = encodingUtil;
    }

    public string getPdfDocument(Blob templateBytes, string dataAsJson, string folderName, string documentName){
        Blob body = getReportPdf(templateBytes, dataAsJson);
        return getDocumentId(body, folderName, documentName);
    }

    public string getPdfDocument(string base64Pdf, string folderName,string documentName){
        Blob body = m_encodingUtil.fromBase64(base64Pdf);
        return getDocumentId(body, folderName, documentName);
    }

    public string getHtmlDocument(Blob templateBytes, string dataAsJson){
        try{   
        	Blob b = m_reportingSvc.getHtml(templateBytes, dataAsJson);
        	return b.toString();
        }catch(Exception ex){
            return 'Report load failed.';
        }   
    }

    public string getDocumentName(string documentNamePrefix){
        String userId = m_userInfoSvc.getCurrentUserId();
        String docName = String.format('{0}-{1}', new List<string>{documentNamePrefix, userId});
        return docName;
    }

    private string getDocumentId(Blob pdfBytes, string folderName,string documentName){
        Document d = m_sfDocumentProvider.getDocument(folderName, documentName);
        Document newDocument = new Document();
        newDocument.Id = d == null?null:d.Id;
        newDocument.name = documentName;
        newDocument.Body = pdfBytes;
        newDocument.Contenttype = CONTENT_TYPE;
        newDocument.type = PDF;
        newDocument = m_sfDocumentProvider.saveDocument(folderName, newDocument);
        return newDocument.Id;
    }

    private Blob getReportPdf(Blob templateBytes, string data){
        try{                    
            return m_reportingSvc.getPdf(templateBytes, data);
        }catch(Exception ex){
            return  Blob.valueof('Report load failed.');
        }                
    }
}