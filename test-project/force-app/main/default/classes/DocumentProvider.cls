public class DocumentProvider implements Documents.IDocumentProvider { 

    private final ImagingServiceProxy.IImagingServiceProxy m_imagingService;
    private final Documents.IDocumentCache m_documentCache;
    private final Utility.IUtility m_util;
    private final ISystem m_systemDate;

    public DocumentProvider(ImagingServiceProxy.IImagingServiceProxy imagingService, Documents.IDocumentCache documentCache, Utility.IUtility util,  ISystem systemDate){
        m_imagingService = imagingService;
        m_documentCache = documentCache;
        m_util = util;
        m_systemDate = systemDate;
    }

    public DmDocument getDocument(Documents.DocumentGetRequest request){
        DmDocument document = m_documentCache.getDocument(request.externalDocumentId);
        if (document == null){
            document = createDocumentFromService(request);
        }
        else if(isExpired(document, request.maxAgeMinutes)){
            document = refreshDocumentFromService(document, request);
        }
        return document;
    }

    private Boolean isExpired(DmDocument document, Integer maxAgeMinutes){
        return document.LastModifiedDate.addMinutes(maxAgeMinutes) < m_systemDate.Now();
    }

    private DmDocument createDocumentFromService(Documents.DocumentGetRequest request){               
        DmDocument document = new DmDocument();
        document.Id = null;
        document.Name = request.externalDocumentId;        
        return refreshDocumentFromService(document, request);
    }

    private DmDocument refreshDocumentFromService(DmDocument document, Documents.DocumentGetRequest request){
        List<String> pages = m_imagingService.retrieveDocument(document.name);
        document.IsInternalUseOnly = True;
        document.Keywords = request.description;
        document.AuthorId = UserInfo.getUserId();
        document.Type = request.docType;
        document.ContentType = request.docMimeType;       
        document.Description = request.description;
        document.Body = m_util.getBase64(pages[0]);     
        return m_documentCache.saveDocument(document);
    }
}