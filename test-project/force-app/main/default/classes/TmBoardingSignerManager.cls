public class TmBoardingSignerManager implements Tmboarding.ISignerManager{
    private final TmBoarding.IServiceRequestBuilder m_svcBuilder;
    private final TmBoardingServiceProxy.ITmBoardingServiceProxy m_proxy;
    public TmBoardingSignerManager(TmBoarding.IServiceRequestBuilder svcBuilder, TmBoardingServiceProxy.ITmBoardingServiceProxy proxy){
        m_svcBuilder = svcBuilder;
        m_proxy = proxy;
    }

    public boolean sendForSignature(string packetId, List<TmBoarding.SignerInfo> signers, List<string> tmRequests, boolean includeMaster, integer applicationId){
        List<TmBoardingServiceProxy.HtmlToSignatureRequest> request = m_svcBuilder.build(packetId, signers,  tmRequests, includeMaster, applicationId);
        TmBoardingServiceProxy.SvcResponse res = m_proxy.sendForSignature(request);
        return res != null;
    }

    public boolean sendForSignature(string clientName, string entityId, List<TmBoarding.SignerInfo> signers, List<string> relatedIds, integer applicationId){     
        List<TmBoardingServiceProxy.HtmlToSignatureRequest> request = m_svcBuilder.buildTMSADataForEntity(clientName,entityId, signers, relatedIds , applicationId);
        TmBoardingServiceProxy.SvcResponse res = m_proxy.sendForSignature(request);
        return res != null;
    }
}