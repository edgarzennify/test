public class EventRegistrationBootstrapper {
	public static EventRegistration.IPresenter getInstanceOfIPresenter() {

		EventRegistration.IDataProvider dataProvider = new EventRegistrationDataProvider();
		Utility.IUtility util = new Utility();
		EventRegistration.IDmBuilder dmBuilder = new EventRegistrationDmBuilder(util);
	
		Configurations.IConfigurations configs = Configurations.bootstrap();
		EventRegistration.ISmBuilder smBuilder = new EventRegistrationSmBuilder(configs);
		Documents.ISalesforceDocumentProvider sfDocumentProvider = new SalesforceDocumentProvider();
		Documents.IDocumentDmBuilder docDmBuilder = new DocumentDmBuilder();
		EventRegistration.IDocumentProvider docProvider = new EventRegistrationDocumentProvider(sfDocumentProvider, docDmBuilder);
		EventRegistration.IRepository repository = new EventRegistrationRepository(dataProvider, dmBuilder, util, configs, smBuilder, docProvider);
		IEncodingUtil encoder = new EncodingUtilProvider();
		EventRegistration.IVmBuilderHelper helper = new EventRegistrationVmBuilderHelper(encoder);
		EventRegistration.IVmBuilder vmBuilder = new EventRegistrationVmBuilder(helper);
		EventRegistration.IPresenter presenter = new EventRegistrationPresenter(vmBuilder, repository);
		
		return presenter;
	}
}