public class EventRegistrationAdminBootstrapper {
	public static EventRegistrationAdmin.IPresenter getInstanceOfIPresenter() {
		Configurations.IConfigurations configs = Configurations.bootstrap();
		EventRegistrationAdmin.IDataProvider m_dataProvider = new EventRegistrationAdminDataProvider();
		EventRegistrationAdmin.IDmBuilderHelper m_dmBuilderHelper = new EventRegistrationAdminDmBldrHlp();
		EventRegistrationAdmin.IDmBuilder m_dmBuilder = new EventRegistrationAdminDmBuilder(m_dmBuilderHelper);
		Utility.IUtility util = new Utility();
		EventRegistrationAdmin.IRepository m_repository = new EventRegistrationAdminRepository(configs, m_dataProvider, m_dmBuilder, util);
		EventRegistrationAdmin.IVmBuilder m_vmBuilder = new EventRegistrationAdminVmBuilder();
		
        EventRegistrationAdmin.IPresenter m_presenter = new EventRegistrationAdminPresenter(m_repository, m_vmBuilder);
		return m_presenter;
	}
}