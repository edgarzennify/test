public class TmBoardingBootstrapper {

    public static TmBoarding.IReportManager getInstanceOfIReportManager() {
        TmConfiguration.IFieldBuilder allfldBuilder = new TmConfigurationAllFieldBuilder();
        List<TmConfiguration.IFieldBuilder> fldBuilders = new List<TmConfiguration.IFieldBuilder>{ allfldBuilder};
        TmConfiguration.ISectionBuilder sectionBuilder = new TmConfigurationSectionBuilder();
        TmConfiguration.IDmBuilder dmBuilder = new TmConfigurationDmBuilder(fldBuilders, sectionBuilder);
        TmBoarding.IDataProvider dataProvider = new TmBoardingDataProvider();
        SObjectFieldFactory.ISObjectFieldFactory schemaFactory= new SObjectFieldFactory();
        CachedMap.ICachedMap cache = CachedMap.getInstance();
        SchemaProvider.ISchemaProviderHelper schHelper = new SchemaProviderHelper(schemaFactory, cache);
        ISchema schProvider = new SchemaProvider(schHelper);
        TmConfiguration.IQueryBuilder queryBuilder = new TmConfigurationQueryBuilder();
        AttachmentHandler.IAttachmentHandler attachmentProvider = new AttachmentHandler();
        TmConfiguration.IRepository repository = new TmConfigurationRepository(dataProvider, dmBuilder, schProvider, queryBuilder, attachmentProvider);
        Configurations.IConfigurations cfg = Configurations.bootstrap();
        TmBoarding.IDataMapBuilder dataMapBuilder = new TmBoardingDataMapBuilder();

        TmConfiguration.IStageRepository stageRepository = new TmConfigurationStageRepository(dataProvider);
        ErrorRepository.IErrorRepository errors = new ErrorRepository();
        Utility.IUtility util = new Utility();
        TmBoarding.IFieldMapManager fieldMapManager = new TmBoardingFieldMapManager();
        TmBoarding.IFieldMetadataBuilder fieldMetadataBuilder = new TmBoardingFieldMetadataBuilder(fieldMapManager);
        TmBoarding.IDmBuilder dmTmBuilder = new TmBoardingDmBuilder(fieldMetadataBuilder, fieldMapManager, errors, util);
        TmBoarding.ISmVerifier smVerifier = new TmBoardingSmVerifier();
        TmBoarding.IRepository tmRepository = new TmBoardingRepository(dataProvider, dmTmBuilder, stageRepository, errors, geRelBuilder(), smVerifier);

        GatewayApiMetadataProvider.IGatewayApiMetadataProvider gtProvider = new GatewayApiMetadataProvider();
        
        WebServices.IRESTService restSvc = new RESTService(gtProvider, cfg);
        IEncodingUtil eutil = new EncodingUtilProvider();
        StaticResourceDataProvider.IStaticResource sresource = new StaticResourceDataProvider();
        IJson json = new JsonWrapper();
        HtmlCoding.IHtmlCoding htmlCoding = new HtmlCoding();
        HtmlReportingServiceProxy.IHtmlReportingService reportSvc = new HtmlReportingServiceProxy(restSvc, eutil, sresource, json, htmlCoding);
        EbDocRepoProvider.IDataProvider ebDocDataProvider = new EbDocRepoDataProvider();
        EbDocRepoProvider.IEbDocRepoProvider docRepoProvider = new EbDocRepoProvider(attachmentProvider, ebDocDataProvider);
        TmBoarding.IReportHelper rtpHelper = new TmBoardingReportHelper(repository, dataMapBuilder, docRepoProvider );
        

        return new TmBoardingReportManager(repository, dataMapBuilder, reportSvc, json, tmRepository, eutil, rtpHelper, docRepoProvider);
    }

    public static TmOpportunityConverter.IRepository getOpportunityConverterRepository(TmBoarding.IDataProvider dataProvider, Utility.IUtility util, TmConfiguration.IStageRepository stageRepository) {
        TmOpportunityConverter.IDmBuilder dmBuilder = new TmOpportunityConverterDmBuilder();
        
        TmOpportunityConverter.IOpportunityBuilder opportunityBuilder = new TmOpportunityConverterBuilder(); 
        TmOpportunityConverter.IConfiguration config = new TmOpportunityConverterConfiguration();
        List<TmOpportunityConverter.IMapper> productFieldMappers = TmOpportunityConverterBootstrapper.getMappers(config);
        List<TmOpportunityConverter.IOpportunityMapper> oppMappers = TmOpportunityConverterBootstrapper.getOpportunityMappers(config);
        return new TmOpportunityConverterRepository(dataProvider,dmBuilder,opportunityBuilder, util, stageRepository, productFieldMappers, oppMappers);
    }

    public static TmBoarding.IPresenter getInstanceOfIPresenter() { 
        SObjectFieldFactory.ISObjectFieldFactory schemaFactory= new SObjectFieldFactory();
        CachedMap.ICachedMap cache = CachedMap.getInstance();
        SchemaProvider.ISchemaProviderHelper schHelper = new SchemaProviderHelper(schemaFactory, cache);
        ISchema sch = new SchemaProvider(schHelper);
        
        TmBoarding.IFieldMapManager fieldMapManager = new TmBoardingFieldMapManager();

        Utility.IUtility util = new Utility();
        ErrorRepository.IErrorRepository errors = new ErrorRepository();
        TmBoarding.ISmExtractor smExtractor = new TmBoardingSmExtractor();
        TmBoarding.ISmBuilder smBuilder = new TmBoardingSmBuilder( smExtractor, fieldMapManager, util);

        TmBoarding.IFieldMetadataBuilder fieldMetadataBuilder = new TmBoardingFieldMetadataBuilder(fieldMapManager);

        TmBoarding.IDmBuilder dmBuilder = new TmBoardingDmBuilder(fieldMetadataBuilder, fieldMapManager, errors, util);
        TmBoarding.IDataProvider dataProvider = new TmBoardingDataProvider();

        Configurations.IConfigurations cfg = Configurations.bootstrap();
        IJson js = new JsonWrapper();
        AccountNumberServiceProxy.IAccountNumberService accountSvc = getAccountSvcInstance(cfg, js);
        TmBoarding.IAccountProvider accountProvider = new TmBoardingAccountProvider(dataProvider, accountSvc);
        TmConfiguration.IStageRepository stageRepository = new TmConfigurationStageRepository(dataProvider);
        TmBoarding.ISmVerifier smVerifier = new TmBoardingSmVerifier();
        TmBoarding.IRepository repository = new TmBoardingRepository(dataProvider, dmBuilder,stageRepository, errors,geRelBuilder(), smVerifier);

        TmOpportunityConverter.IRepository opportunityConverter = getOpportunityConverterRepository(dataProvider, util, stageRepository);
        IUserInfoService userSvc = UserInfoService.bootstrap();

        TmBoarding.IPermission permission = new TmBoardingPermission(userSvc, cfg);
        TmBoarding.IVmBuilder vmbld = getVmBuilder(permission, cfg, util);
        TmConfiguration.IRepository configRepo = TmConfigurationBootstrapper.getInstanceOfRepository();

        TmBoarding.IDataMapBuilder dataMapBuilder = new TmBoardingDataMapBuilder();
        TmValidator.IRuleRunnerProvider validator = getValidator(errors);
        TmBoarding.IValidationEngine engine = new TmBoardingValidationEngine();
        AttachmentHandler.IAttachmentHandler attachmentProvider = new AttachmentHandler();
        EbDocRepoProvider.IDataProvider ebDocDataProvider = new EbDocRepoDataProvider();
        EbDocRepoProvider.IEbDocRepoProvider docRepoProvider = new EbDocRepoProvider(attachmentProvider, ebDocDataProvider);
        TmBoarding.IReportHelper helper = new TmBoardingReportHelper(configRepo, dataMapBuilder, docRepoProvider);

        ObjectActionLogService.IObjectActionLogService objectActionLogService = ObjectActionLogService.bootstrap();// ObjectActionLogService(objectActionDataProvider, util, cMap);

        TmBoarding.IPresenter presenter = new TmBoardingPresenter(vmbld, repository, configRepo, dataMapBuilder, validator, engine, accountProvider, smBuilder, errors, opportunityConverter, objectActionLogService, helper);
        
        return presenter;
    }

    public static TmBoarding.IRepository getInstanceOfIRepository( Utility.IUtility util, ErrorRepository.IErrorRepository errors) {
        TmConfiguration.IFieldBuilder allfldBuilder = new TmConfigurationAllFieldBuilder();
        List<TmConfiguration.IFieldBuilder> fldBuilders = new List<TmConfiguration.IFieldBuilder>{ allfldBuilder};
        TmConfiguration.ISectionBuilder sectionBuilder = new TmConfigurationSectionBuilder();
        TmConfiguration.IDmBuilder dmBuilder = new TmConfigurationDmBuilder(fldBuilders, sectionBuilder);
        TmBoarding.IDataProvider dataProvider = new TmBoardingDataProvider();

        SObjectFieldFactory.ISObjectFieldFactory schemaFactory= new SObjectFieldFactory();
        CachedMap.ICachedMap cache = CachedMap.getInstance();
        SchemaProvider.ISchemaProviderHelper schHelper = new SchemaProviderHelper(schemaFactory, cache);
        ISchema schProvider = new SchemaProvider(schHelper);

        TmConfiguration.IQueryBuilder queryBuilder = new TmConfigurationQueryBuilder();
        AttachmentHandler.IAttachmentHandler attachmentProvider = new AttachmentHandler(); 
        TmConfiguration.IRepository repository = new TmConfigurationRepository(dataProvider, dmBuilder, schProvider, queryBuilder, attachmentProvider);
        Configurations.IConfigurations cfg = Configurations.bootstrap();
        TmBoarding.IDataMapBuilder dataMapBuilder = new TmBoardingDataMapBuilder();

        TmConfiguration.IStageRepository stageRepository = new TmConfigurationStageRepository(dataProvider);
        TmBoarding.IFieldMapManager fieldMapManager = new TmBoardingFieldMapManager();
        TmBoarding.IFieldMetadataBuilder fieldMetadataBuilder = new TmBoardingFieldMetadataBuilder(fieldMapManager);
        TmBoarding.IDmBuilder dmTmBuilder = new TmBoardingDmBuilder(fieldMetadataBuilder, fieldMapManager, errors, util);
        TmBoarding.ISmVerifier smVerifier = new TmBoardingSmVerifier();
        return new TmBoardingRepository(dataProvider, dmTmBuilder, stageRepository, errors, geRelBuilder(), smVerifier);
    }

    public static TmBoarding.ISignerManager getInstanceOfISignerManager(){
        IEncodingUtil eutil = new EncodingUtilProvider();
        Utility.IUtility util = new Utility();
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider gtProvider = new GatewayApiMetadataProvider();
        Configurations.IConfigurations cfg = Configurations.bootstrap();
        IJson json = new JsonWrapper();
        WebServices.IRESTService restSvc = new RESTService(gtProvider, cfg);
        TmConfiguration.IRepository configRepo = TmConfigurationBootstrapper.getInstanceOfRepository();
        TmBoarding.IDataMapBuilder dataMapBuilder = new TmBoardingDataMapBuilder();
        AttachmentHandler.IAttachmentHandler attachmentProvider = new AttachmentHandler();
        EbDocRepoProvider.IDataProvider ebDocDataProvider = new EbDocRepoDataProvider();
        EbDocRepoProvider.IEbDocRepoProvider docRepoProvider = new EbDocRepoProvider(attachmentProvider, ebDocDataProvider);
        TmBoarding.IReportHelper reportHelper = new TmBoardingReportHelper(configRepo, dataMapBuilder, docRepoProvider);
        TmBoarding.IServiceClientInfoProvider clientInfoProvider = new TmBoardingServiceClientInfoProvider(cfg);
        TmBoarding.IServiceRequestBuilder bld = new TmBoardingServiceRequestBuilder(configRepo, reportHelper, eutil, util, json, clientInfoProvider, docRepoProvider);
        TmBoardingServiceProxy.ITmBoardingServiceProxy proxy = new TmBoardingServiceProxy(restSvc, json);
        return new TmBoardingSignerManager(bld, proxy);
    }

    public static TmBoarding.IApproval getInstanceOfIApproval(){
        ApprovalProcess.IManager approvalManager = ApprovalProcess.bootstrap();
        Utility.IUtility util = new Utility();
        ErrorRepository.IErrorRepository errors = new ErrorRepository();
        TmBoarding.IRepository repo = getInstanceOfIRepository( util, errors);
        ApprovalProcess.IVmBuilderHelper vmHelper = new ApprovalProcessVmBuilderHelper(util);
        ApprovalProcess.IVmBuilder vmBuilder = new ApprovalProcessVmBuilder(vmHelper);
        Configurations.IConfigurations cfg = Configurations.bootstrap();

        return new TmBoardingApproval(approvalManager, repo, vmBuilder, cfg);
    }


    private static TmBoarding.IVmBuilder getVmBuilder(TmBoarding.IPermission perm, Configurations.IConfigurations cfg, Utility.IUtility util){
        TmBoarding.IInputTypeVmBuilder inputTypeBuilder = new TmBoardingInputTypeVmBuilder();
        TmBoarding.IVmFieldBuilder fieldBuilder = new TmBoardingVmFieldBuilder(inputTypeBuilder);
        TmBoarding.IVmMetadataTypeBuilder metadataEdit = new TmBoardingEditVmBuilder();
        TmBoarding.IVmMetadataTypeBuilder metadataView = new TmBoardingViewVmBuilder();
        List<TmBoarding.IVmMetadataTypeBuilder> metaBuilders = new List<TmBoarding.IVmMetadataTypeBuilder>{metadataedit, metadataView};
        TmBoarding.IVmBuilderHelper vmHelper = new TmBoardingVmBuilderHelper(perm, util);
        AccountNumberGenerator.IDataProvider cardDataProvider = new AccountNumberGeneratorDataProvider();
        CardRepository.ICardRepository cardRepo = new CardRepository(cardDataProvider);
        TmBoarding.IVmBuilder vmBuilder = new TmBoardingVmBuilder(inputTypeBuilder,fieldBuilder,  metaBuilders, vmHelper, cardRepo);
        return vmBuilder;
    }

    private static TmValidator.IRuleRunnerProvider getValidator(ErrorRepository.IErrorRepository errors) {
        return TmValidatorBootstrapper.getRuleRunnerProviderInstance(errors);
    }

    public static AccountNumberServiceProxy.IAccountNumberService getAccountSvcInstance(Configurations.IConfigurations cfg, IJson js) {
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider gatewayMetadataProvider = new GatewayApiMetadataProvider();
        WebServices.IRestService restService = new RestService(gatewayMetadataProvider, cfg);
        AccountNumberServiceProxy.IAccountNumberService accountSvc = new AccountNumberServiceProxy(restService, js);
        return accountSvc;
    }

    private static TmBoarding.IEbAccountRelBuilder geRelBuilder(){
        ParentRelTreeBuilderDataProv relDataProvider = new ParentRelTreeBuilderDataProv(); 
        ParentRelationshipSvc parentRelSvc = new ParentRelationshipSvc();
        ParentRelationships.IParentRelTreeBuilder treeBuilder = new ParentRelTreeBuilder(relDataProvider, parentRelSvc);
        TmBoarding.IEbAccountRelBuilder relBuilder = new TmBoardingEbAccountRelBuilder(treeBuilder);
        return relBuilder;
    }
}