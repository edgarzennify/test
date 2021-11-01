@isTest
public class EbtDocManagerBootstrapperTests {
	private static testMethod void it_should_get_the_adapter_instance(){
        EbtDocManager.IAdapter adapter = EbtDocManagerBootstrapper.getInstanceOfIEbtDocManagerAdapter();
        System.assert(adapter != null);
    }
}