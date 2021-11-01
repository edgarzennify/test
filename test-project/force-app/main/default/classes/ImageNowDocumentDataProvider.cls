public class ImageNowDocumentDataProvider Implements ImageNowDocument.IImageNowDocumentDataProvider{

    private WebServices.IRESTService m_svc;

    public ImageNowDocumentDataProvider(WebServices.IRESTService svc){
        m_svc = svc;
    }

    public String GetDocumentByDocID(string docID)
    {        
        try
        {
            RestUtility.result res = m_svc.GET(RESTUtility.ImageNowDocumentUrl + docID);
            return res.response;

        }
        catch(exception ex)
        {
            return null;
        }
    }
  
}