@isTest
private class TmConfigurationControllerTests {
	
	private static testMethod void it_should_get_products() {

		List<String> results = TmConfigurationController.getProducts();

		System.assertEquals('Lockbox', results[0]);
		System.assertEquals('Online Banking', results[1]);
	}

	private static testMethod void it_should_get_bootstrap() {
		try 
		{
			TmConfigurationController.bootstrap('Lockbox');
		} catch(Exception ex) {

		}
	}

	private static testMethod void it_should_call_the_get_products() {
		List<String> result =  TmConfigurationController.getProducts();
	}
	
}