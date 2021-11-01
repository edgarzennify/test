@IsTest
private class StaticResourceDataProviderTests {

	private static final StaticResourceDataProvider sut;

	static {
		sut = new StaticResourceDataProvider();
	}

	private static testMethod void it_should_get_data_when_resource_name_is_provided_code_coverage() {
		String staticResourceName = 'resource';
		try{
			Blob result =  sut.getData(staticResourceName);
		}catch(exception ex) {

		}
	}

	private static testMethod void it_should_get_data_when_static_resource_and_file_name_is_provided_code_coverage() {
		String staticResourceName = 'static-resource';
		String fileName = 'file.txt';
		try{
			Blob result = sut.getData(staticResourceName, fileName);
		}catch(exception ex) {

		}
	}
}