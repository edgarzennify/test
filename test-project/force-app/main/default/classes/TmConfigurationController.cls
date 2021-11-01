global class TmConfigurationController {

	@RemoteAction
	global static List<String> getProducts() {
		String p1 = 'Lockbox';
		String p2 = 'Online Banking';

		return new List<String>{p1,p2};
	}

	@RemoteAction
	global static TmConfiguration.FormVm bootstrap(String product) {
		TmConfiguration.IPresenter presenter = TmConfigurationBootstrapper.getInstanceOfPresenter();
		return presenter.build(product);
	}
}