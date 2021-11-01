@isTest
private class SL_ChatterLightning_Controller_Test {
	static testMethod void SL_Test() {
        ApexPages.currentPage().getParameters().putAll(new Map<String, String>{
            'color' => 'abc',
            'button' => 'edf',
            'a[1]' => 'ddd',
            'b[2][4]' => 'ccc'
        });
        SL_ChatterLightning_Controller testController = new SL_ChatterLightning_Controller();
		system.assertNotEquals(
            testController.aParam.get('color'), null, ''
        );  
	}
}