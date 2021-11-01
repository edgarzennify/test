global class EsignatureApplicationController {
	
    @RemoteAction
    public static EsignatureApplication.FormVm bootstrap(string applicationId, string recordId){
        EsignatureApplication.IPresenter presenter = EsignatureApplicationBootstrapper.getInstanceOfIPresenter();
        EsignatureApplication.FormVm formvm = presenter.buildFormVm(applicationId, recordId);
        return formvm;
    }

    @RemoteAction
    public static string getPreviewSignatureDocument(string applicationId, string recordId, EsignatureApplication.SaveModel sm){
        EsignatureApplication.IPresenter presenter = EsignatureApplicationBootstrapper.getInstanceOfIPresenter();
        return presenter.getDocumentForSignaturePreview(applicationId,recordId,sm);
    }

    @RemoteAction 
    public static boolean sendForSignature(string applicationId, string recordId, EsignatureApplication.SaveModel  sm){
        EsignatureApplication.IPresenter presenter = EsignatureApplicationBootstrapper.getInstanceOfIPresenter();
        
        try{
            presenter.sendForSignature(applicationId,recordId, sm);
            return true;
        }catch(exception ex){

        }
        return false;
    }

    @RemoteAction 
    public static EsignatureApplication.SignatureData getSignatureDataByRecordId(string applicationId, string recordId){
        EsignatureApplication.IPresenter presenter = EsignatureApplicationBootstrapper.getInstanceOfIPresenter();
        EsignatureApplication.SignatureData data = presenter.getSignatureData(applicationId);
        return presenter.filterDataByRecordId(data, recordId);
    }

    @RemoteAction 
    public static EsignatureApplication.SignatureData getSignatureDataPending(string applicationId){
        EsignatureApplication.IPresenter presenter = EsignatureApplicationBootstrapper.getInstanceOfIPresenter();
        EsignatureApplication.SignatureData data = presenter.getSignatureData(applicationId);
        return presenter.filterData(data, 'Out For Signature');
    }

    @RemoteAction 
    public static EsignatureApplication.SignatureData getSignatureDataRecentlyCompleted(string applicationId){
        EsignatureApplication.IPresenter presenter = EsignatureApplicationBootstrapper.getInstanceOfIPresenter();
        EsignatureApplication.SignatureData data = presenter.getSignatureData(applicationId);
        return presenter.filterData(data, 'Signature Complete');
    }

    @RemoteAction 
    public static EsignatureApplication.SignatureData getSignatureDataHistory(string applicationId){
        EsignatureApplication.IPresenter presenter = EsignatureApplicationBootstrapper.getInstanceOfIPresenter();
        return presenter.getSignatureData(applicationId);
    } 
}