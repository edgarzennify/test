global class EsignatureApplicationPluginController {
    public EsignatureApplicationPluginController(ApexPages.StandardController controller)
    {       
    }

	@RemoteAction 
    global static EsignatureApplication.SignatureData getSignatureDataByRecordId(string applicationId, string recordId){
        EsignatureApplication.IPresenter presenter = EsignatureApplicationBootstrapper.getInstanceOfIPresenter();
        EsignatureApplication.SignatureData data = presenter.getSignatureData(applicationId);
        return presenter.filterDataByRecordId(data, recordId);
    }
}