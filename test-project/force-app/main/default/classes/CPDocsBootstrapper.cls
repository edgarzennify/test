public class CPDocsBootstrapper {
	
    public static CPDocs.IPresenter getIPresenterInstance(){       
        CPDocs.INcinoRepository ncinoRepo =  getNcinoRepositoryInstance();      
        CPDocs.ICPDocsRepository cpDocsRepo = getCPDocsRepositoryInstance();
        ISystem sys = new SystemWrapper();
        Configurations.IConfigurations configs = Configurations.bootstrap();
        CPDocs.IVmBuilder vmb = new CPDocsVmBuilder(sys,configs);
        Utility.IUtility util = new Utility();
        IUserInfoService usr = UserInfoService.bootstrap();
        CPDocs.IDocRequestManager prv = getDocRequestManager(util,cpDocsRepo,ncinoRepo);
        CPDocs.IDocumentSynchronizer sync =  new CPDocsDocumentSynchronizer(util);
        return new CPDocsPresenter(vmb,usr,prv,cpDocsRepo, sync);
    }

    private static CPDocs.IDocRequestManager getDocRequestManager(Utility.IUtility util,CPDocs.ICPDocsRepository cpDocsRepo, CPDocs.INcinoRepository ncinoRepo){
        CPDocs.INcinoDocRequestBuilderHelper helper = new CPDocsDocRequestBuilderHelper();
        CPDocs.IObjectTypeBuilder objTypeBldr = new CPDocsObjectTypeBuilder(util);
        CPDocs.IDocRequestBuilder entityBldr = new CPDocsEntityDocRequestBuilder(ncinoRepo,helper);
        CPDocs.IDocRequestBuilder loanBldr = new CPDocsLoanDocRequestBuilder(ncinoRepo,helper);
        CPDocs.IDocRequestBuilder collateralBldr = new CPDocsCollateralDocRequestBuilder(ncinoRepo,helper);
        CPDocs.IDocRequestBuilder internalBldr = new CPDocsInternalDocRequestBuilder(cpDocsRepo);
        List<CPDocs.IDocRequestBuilder> bldrs = new List<CPDocs.IDocRequestBuilder>{entityBldr,loanBldr,collateralBldr,internalBldr};
        CPDocs.IRelatedObjectsProvider relObjProvider = new CPDocsRelatedObjectsProvider(ncinoRepo);
        CPDocs.IDocRequestManager prv = new CPDocsDocRequestManager(cpDocsRepo,bldrs,relObjProvider);
        return prv;
    }

    private static CPDocs.INcinoRepository getNcinoRepositoryInstance() {
        CPDocs.IDataProvider dp = new CPDocsDataProvider();
        CPDocs.IDmBuilder dmb = new CPDocsDmBuilder();
        CPDocs.INcinoDataProvider ncinoDp = new CPDocsNcinoDataProvider();
        CPDocs.INcinoDmBuilder ncinoDmBld = new CPDocsNcinoDmBuilder();
        CPDocs.INcinoRepository repo = new CPDocsNcinoRepository(dmb,dp,ncinoDp,ncinoDmBld);
        return repo;
    }

    public static CPDocs.ICPDocsRepository getCPDocsRepositoryInstance() {
        CPDocs.IDataProvider dp = new CPDocsDataProvider();
        CPDocs.IDmBuilder dmb = new CPDocsDmBuilder();
        CPDocs.ICPDocsRepository repo = new CPDocsRepository(dp, dmb);
        return repo;
    }
}