public class TmConfigurationBootstrapper {
    public static TmConfiguration.IPresenter getInstanceOfPresenter() {  
        TmConfiguration.IRepository repo = getInstanceOfRepository();
        TmConfiguration.IVmMetadataBuilder metadataBuilder = new TmConfigurationVmMetadataBuilder();
        TmConfiguration.IVmBuilder vmBuilder = new TmConfigurationVmBuilder(metadataBuilder);
        
        return new TmConfigurationPresenter(repo, vmBuilder);
    }

    public static TmConfiguration.IRepository getInstanceOfRepository() {
        TmBoarding.IDataProvider dataProvider = new TmBoardingDataProvider();
        TmConfiguration.ISectionBuilder section = new TmConfigurationSectionBuilder();
        TmConfiguration.IFieldBuilder all = new TmConfigurationAllFieldBuilder();
        TmConfiguration.IFieldBuilder view = new TmConfigurationViewFieldBuilder();
        TmConfiguration.IFieldBuilder edit = new TmConfigurationEditFieldBuilder();
        List<TmConfiguration.IFieldBuilder> fieldBuilders = new List<TmConfiguration.IFieldBuilder>{all, view, edit};
        TmConfiguration.IDmBuilder dmBuilder = new TmConfigurationDmBuilder(fieldBuilders, section);
        SObjectFieldFactory.ISObjectFieldFactory schemaFactory= new SObjectFieldFactory();
        CachedMap.ICachedMap cache = CachedMap.getInstance();
        SchemaProvider.ISchemaProviderHelper schHelper = new SchemaProviderHelper(schemaFactory, cache);
        ISchema schemaProvider = new SchemaProvider(schHelper);
        TmConfiguration.IQueryBuilder queryBuilder = new TmConfigurationQueryBuilder();
        AttachmentHandler.IAttachmentHandler attachmentProvider = new AttachmentHandler(); 
        return new TmConfigurationRepository(dataProvider, dmBuilder, schemaProvider, queryBuilder, attachmentProvider);
    }
}