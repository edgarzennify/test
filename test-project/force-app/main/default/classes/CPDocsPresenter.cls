public class CPDocsPresenter implements CPDocs.IPresenter {
	
    private final CPDocs.IVmBuilder m_vmBuilder;
    private final CPDocs.ICPDocsRepository m_CDocsRepo;
    private final IUserInfoService m_userInfo;
    private final CPDocs.IDocRequestManager m_docRequestManager;
    private final CPDocs.IDocumentSynchronizer m_docSync;
    
    public CPDocsPresenter(CPDocs.IVmBuilder vmBuilder, IUserInfoService userInfo,
    CPDocs.IDocRequestManager docRequestManager, 
      CPDocs.ICPDocsRepository CDocsRepo , CPDocs.IDocumentSynchronizer docSync){
        m_vmBuilder = vmBuilder;
        m_userInfo = userInfo;
        m_docRequestManager = docRequestManager;
        m_CDocsRepo = CDocsRepo;
        m_docSync = docSync;
    }

    public List<CPDocs.DocumentRequest> getAllDocumentRequests(){
        DmUser userDm = getUserDm();
        List<DmCPDocumentRequest> requestDms = m_docRequestManager.calculateRequests(userDm);
        List<CPDocs.DocumentRequest> vms = m_vmBuilder.buildVm(requestDms);
        return vms;
    }
    
    public List<CPDocs.DocumentRequest> getDocumentRequestsByFilter(string objectDescription){ 
        DmUser userDm = getUserDm(); 
        List<DmCPDocumentRequest> requestDms = m_docRequestManager.getRequestByObjectDescription(userDm, objectDescription);
        return m_vmBuilder.buildVm(requestDms);
    }

    public List<CPDocs.DocumentRequest> postUpload(String documentRequestId){
        DmUser userDm = getUserDm();
        m_docRequestManager.updateRequestStatus(new List<string>{documentRequestId});
        List<DmCPDocumentRequest> requestDms = m_docRequestManager.getRequests(userDm);  
        DmCPDocumentRequest documentRequestDm = getRequest(requestDms, documentRequestId);    
        if(documentRequestDm != null) m_docSync.sync(documentRequestDm);
        return m_vmBuilder.buildVm(requestDms);
    }

    public List<CPDocs.DocumentRequest> getDocumentRequestById(string documentRequestId){ 
        List<DmCPDocumentRequest> requestDms = m_docRequestManager.getRequestByIds(new List<string>{documentRequestId});
        return m_vmBuilder.buildVm(requestDms);
    }

    private DmUser getUserDm(){
        List<CPDocs.CPDocRequestSm> reqs = new List<CPDocs.CPDocRequestSm>();
        String userId = m_userInfo.getCurrentUserId();
        return m_CDocsRepo.getUser(userId);
    }

    private DmCPDocumentRequest getRequest(List<DmCPDocumentRequest> requestDms, String documentRequestId){
        for(DmCPDocumentRequest r: requestDms){
            if(r.Id == documentRequestId)
                return r;
        }
        return null;
    }
}