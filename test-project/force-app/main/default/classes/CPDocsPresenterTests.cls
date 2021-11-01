@IsTest
public class CPDocsPresenterTests {
    
    private static CPDocsMock.ofIVmBuilder mockVmBuilder;
    private static CPDocsMock.ofICPDocsRepository mockCpDocsRepo;
    private static Mock.ofIUserInfoService mockUserInfoSvc;
    private static CPDocsMock.ofIDocRequestManager mockDocRequestManager;
    private static CPDocsMock.ofIDocumentSynchronizer mockSync;
    private static CPDocsPresenter sut;

    static{
        mockVmBuilder = new CPDocsMock.ofIVmBuilder();
        mockCpDocsRepo = new CPDocsMock.ofICPDocsRepository();
        mockUserInfoSvc = new Mock.ofIUserInfoService();
        mockDocRequestManager = new CPDocsMock.ofIDocRequestManager();
        mockSync = new CPDocsMock.ofIDocumentSynchronizer();

        sut = new CPDocsPresenter(mockVmBuilder, mockUserInfoSvc, mockDocRequestManager, mockCpDocsRepo, mockSync);
    }

    @IsTest 
    private static void it_should_call_the_vm_builder_and_pass_dms_to_build_vms(){
        String userId = '0057d000005Bo1WAAS';
        DmUser userDm = new DmUser();
        userDm.id = userId;
        List<DmCPDocumentRequest> requestDms = new List<DmCPDocumentRequest>();
        mockUserInfoSvc.setup('getCurrentUserId').returns(userId);
        mockCpDocsRepo.setup('getUser', new List<Object>{userId}).returns(userDm);
        mockDocRequestManager.setup('calculateRequests', new List<Object>{userDm}).returns(requestDms);

        List<CPDocs.DocumentRequest> result =  sut.getAllDocumentRequests();

        mockVmBuilder.verify('buildVm', new List<Object>{requestDms},Times.Once);
    }

    @IsTest 
    private static void it_should_call_the_vm_builder_to_build_vms_when_filter_is_provided(){
        String userId = '0057d000005Bo1WAAS';
        String objDescription = 'xyz';
        DmUser userDm = new DmUser();
        userDm.id = userId;
        List<DmCPDocumentRequest> requestDms = new List<DmCPDocumentRequest>();
        mockUserInfoSvc.setup('getCurrentUserId').returns(userId);
        mockCpDocsRepo.setup('getUser', new List<Object>{userId}).returns(userDm);
        mockDocRequestManager.setup('getRequestByObjectDescription', new List<Object>{userDm, objDescription}).returns(requestDms);

        List<CPDocs.DocumentRequest> result =  sut.getDocumentRequestsByFilter(objDescription);

        mockVmBuilder.verify('buildVm', new List<Object>{requestDms},Times.Once);
    }

    @IsTest  
    private static void it_should_call_the_doc_request_manager_and_pass_the_doc_request_Id_for_update_on_post_upload(){
        String documentRequestId = 'abc';
        String userId = '0057d000005Bo1WAAS';
        String objDescription = 'xyz';
        DmUser userDm = new DmUser();
        userDm.id = userId;
        List<DmCPDocumentRequest> requestDms = new List<DmCPDocumentRequest>();
        mockUserInfoSvc.setup('getCurrentUserId').returns(userId);
        mockCpDocsRepo.setup('getUser', new List<Object>{userId}).returns(userDm);
        mockDocRequestManager.setup('getRequests', new List<Object>{userDm}).returns(requestDms);

        List<CPDocs.DocumentRequest> result = sut.postUpload(documentRequestId);

        mockDocRequestManager.verify('updateRequestStatus', new List<Object>{new List<string>{documentRequestId}}, Times.once);
    }

    @IsTest 
    private static void it_should_get_doc_requests_when_doc_request_id_is_provided(){
        String documentRequestId = 'abc';
        String userId = '0057d000005Bo1WAAS';
        String objDescription = 'xyz';
        DmUser userDm = new DmUser();
        userDm.id = userId;
        List<DmCPDocumentRequest> requestDms = new List<DmCPDocumentRequest>();
        mockUserInfoSvc.setup('getCurrentUserId').returns(userId);
        mockCpDocsRepo.setup('getUser', new List<Object>{userId}).returns(userDm);
        mockDocRequestManager.setup('getRequestByIds', new List<Object>{new List<string>{documentRequestId}}).returns(requestDms);

        List<CPDocs.DocumentRequest> result =  sut.getDocumentRequestById(documentRequestId);

        mockVmBuilder.verify('buildVm', new List<Object>{requestDms}, Times.once);
    }
}