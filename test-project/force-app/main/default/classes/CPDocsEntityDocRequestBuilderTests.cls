@IsTest
private class CPDocsEntityDocRequestBuilderTests {

    private static CPDocsMock.ofINcinoRepository mockNcinoRepo;
    private static CPDocsMock.ofINcinoDocRequestBuilderHelper mockBuilderHelper;
    private static CPDocsEntityDocRequestBuilder sut;

    static{
        mockNcinoRepo = new CPDocsMock.ofINcinoRepository();
        mockBuilderHelper = new CPDocsMock.ofINcinoDocRequestBuilderHelper();
        sut = new CPDocsEntityDocRequestBuilder(mockNcinoRepo,mockBuilderHelper);
    }

    @IsTest
    private static void it_should_call_the_build_helper_to_accept_placeholders(){
        List<CPDocs.RelatedObject> relObjects = new List<CPDocs.RelatedObject>();
        List<DmCPDocumentRequest> cpDocs = new List<DmCPDocumentRequest>();
        List<string> ids = new List<string>{'a123'};
        List<DmNcinoDocumentPlaceHolder>  placeHolderDms = new List<DmNcinoDocumentPlaceHolder>();
        mockBuilderHelper.setup('getIds', new List<Object>{relObjects}).returns(ids);
        mockNcinoRepo.setup('getAccountDocuments', new List<object>{ids}).returns(placeHolderDms);

        List<CPDocs.CPDocRequestSm> result = sut.buildDocRequests(relObjects,cpDocs);

        mockBuilderHelper.verify('buildDocRequests', new List<object>{placeHolderDms,relObjects,cpDocs,'Entity'},Times.Once);
    }


}