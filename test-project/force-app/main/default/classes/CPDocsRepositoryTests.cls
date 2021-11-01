@IsTest
public class CPDocsRepositoryTests {
    
    private static CPDocsMock.ofIDataProvider mockCpDocsDataProvider;
    private static CPDocsMock.ofIDmBuilder mockCpDocsDmBuilder;
    private static CPDocsRepository sut;

    static{
        mockCpDocsDataProvider = new CPDocsMock.ofIDataProvider();
        mockCpDocsDmBuilder = new CPDocsMock.ofIDmBuilder();
        sut = new CPDocsRepository(mockCpDocsDataProvider, mockCpDocsDmBuilder);
    }

    @IsTest 
    private static void it_should_call_the_dm_builder_to_build_dms_from_pms(){
        String userId = 'xyz';
        PM_User userPm = new PM_User();
        userPm.id = userId;

        mockCpDocsDataProvider.setup('getUserDetail', new List<Object>{userId}).returns(userPm);

        DmUser result = sut.getUser(userId);

        mockCpDocsDmBuilder.verify('build', new List<object>{userPm}, Times.once);
    }

    @IsTest 
    private static void it_should_get_all_document_requests_by_calling_data_provider(){
        PM_CP_Document_Request_c pm = new PM_CP_Document_Request_c();
        List<PM_CP_Document_Request_c> pms = new List<PM_CP_Document_Request_c>{pm}; 
        mockCpDocsDataProvider.setup('getAllDocumentRequests').returns(pms);

        List<DmCPDocumentRequest> result = sut.getAllDocumentRequestDms();

        mockCpDocsDmBuilder.verify('build', new List<object>{pms}, Times.once);
    }

    @IsTest 
    private static void it_should_call_the_data_provider_to_get_document_requests_based_on_objectIds_and_pass_to_dm_builder(){
        String objectId = 'ax123';
        List<string> objectIds = new List<string>{objectId};
        PM_CP_Document_Request_c pm = new PM_CP_Document_Request_c();
        pm.id = objectId;
        List<PM_CP_Document_Request_c> pms = new List<PM_CP_Document_Request_c>{pm}; 
        mockCpDocsDataProvider.setup('getDocumentRequestByObjectIds', new List<object>{objectIds}).returns(pms);

        List<DmCPDocumentRequest> result = sut.getDocumentRequestByObjectIdsDms(objectIds);

        mockCpDocsDmBuilder.verify('build', new List<object>{pms}, Times.once);
    }

    @IsTest 
    private static void it_should_call_the_data_provider_to_get_pms_to_build_dms_when_ids_are_provided(){
        
        String id = 'xid';
        List<string> ids = new List<string>{id};
        PM_CP_Document_Request_c pm = new PM_CP_Document_Request_c();
        pm.id = id;
        List<PM_CP_Document_Request_c> pms = new List<PM_CP_Document_Request_c>{pm}; 
        mockCpDocsDataProvider.setup('getDocumentRequestByIds', new List<object>{ids}).returns(pms);

        List<DmCPDocumentRequest> result = sut.getDocumentRequestByIdsDms(ids);

        mockCpDocsDmBuilder.verify('build', new List<object>{pms}, Times.once);
    
    }
}