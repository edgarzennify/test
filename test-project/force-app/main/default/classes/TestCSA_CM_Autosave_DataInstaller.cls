@IsTest(seeAllData=false)
public class TestCSA_CM_Autosave_DataInstaller {
	

	@IsTest
	public static void testBeans() {
	Test.startTest();
		CSA_CreditMemo_Autosave_DataInstaller di = new CSA_CreditMemo_Autosave_DataInstaller();
		di.onInstall(null);
	Test.stopTest();
	}
}