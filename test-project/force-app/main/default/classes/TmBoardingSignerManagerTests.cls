@IsTest
private class TmBoardingSignerManagerTests {
    
    private static final TmBoardingMock.ofIServiceRequestBuilder mockBuilder; 
    private static final TmBoardingMock.ofITmBoardingServiceProxy mockProxy;
    private static TmBoardingSignerManager sut;

    static {
        mockBuilder = new TmBoardingMock.ofIServiceRequestBuilder();
        mockProxy = new TmBoardingMock.ofITmBoardingServiceProxy();
        sut = new TmBoardingSignerManager(mockBuilder, mockProxy);
    }

    @IsTest
    static void it_should_call_the_request_builder_to_build_proxy_request() {
        String packetId = 'test-id';
        Integer applicationId = 1;
        Boolean includeMaster = true;
        TmBoarding.SignerInfo info = new TmBoarding.SignerInfo();
        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{};
        List<String> tmRequests = new List<String>{'req-1', 'req-2'};
        
        Boolean result = sut.sendForSignature(packetId, signers, tmRequests, includeMaster, applicationId);

        mockBuilder.verify('build', new List<Object>{packetId, signers, tmRequests, includeMaster, applicationId}, Times.Once);
    }

    @IsTest
    static void it_should_get_the_request_from_builder_and_call_proxy() {
        String packetId = 'test-id';
        Integer applicationId = 1;
        Boolean includeMaster = true;
        TmBoarding.SignerInfo info = new TmBoarding.SignerInfo();
        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{};
        List<String> tmRequests = new List<String>{'req-1', 'req-2'};
        List<TmBoardingServiceProxy.HtmlToSignatureRequest> request = new List<TmBoardingServiceProxy.HtmlToSignatureRequest>();
        mockBuilder.setup('build', new List<Object>{packetId, signers, tmRequests, includeMaster, applicationId}).returns(request);

        Boolean result = sut.sendForSignature(packetId, signers, tmRequests, includeMaster, applicationId);

        mockProxy.verify('sendForSignature', new List<Object>{request}, Times.Once);
    }

    @IsTest
    static void it_should_get_the_request_for_entity_from_builder_and_call_proxy() {
        String entityId = 'test-id';
        String entityName = 'entity-name';
        Integer applicationId = 1;
        TmBoarding.SignerInfo info = new TmBoarding.SignerInfo();
        List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>{};
        List<String> relatedIDs = new List<String>{entityId};
        List<TmBoardingServiceProxy.HtmlToSignatureRequest> request = new List<TmBoardingServiceProxy.HtmlToSignatureRequest>();
        mockBuilder.setup('buildTMSADataForEntity', new List<Object>{entityname,entityId, signers, relatedIDs, applicationId}).returns(request);

        boolean result = sut.sendForSignature(entityName, entityId, signers, relatedIDs, applicationId);

        mockProxy.verify('sendForSignature', new List<Object>{request}, Times.Once);
    }
}