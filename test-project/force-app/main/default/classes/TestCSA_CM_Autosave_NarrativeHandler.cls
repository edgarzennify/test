@IsTest(seeAllData=false)
public class TestCSA_CM_Autosave_NarrativeHandler  {
	@IsTest
	public static void disableNarratives() {
	     nFORCE__Screen__c screen = new nFORCE__Screen__c(
	     	Name = 'TestScreen'
	     );
	     Database.insert(screen);
	     nFORCE__Widget__c widget = new nFORCE__Widget__c(
                Name = 'LifeCycle.KO_Narrative',
                nFORCE__View__c = '<div data-bind="template: { name: \'narrative-template\' }"></div>'
        );
        Database.insert(widget);
	     nFORCE__Screen_Section__c screenSection =  new nFORCE__Screen_Section__c(
			Name = 'TestSCSE',
	     	nFORCE__Screen__c = screen.Id,
	     	nFORCE__Widget__c = widget.Id,
	     	nFORCE__Section_Resource__c = 'MappedSObjectHierarchyScreenResource'
	     );
	     Database.insert(screenSection);
	     LLC_BI__Credit_Memo__c creditMemo = new LLC_BI__Credit_Memo__c (
	     	Name = 'Test CM',
			LLC_BI__FScreen__c = screen.Id
	     );
	     Database.insert(creditMemo);
		 LLC_BI__Product_Package__c pp = new LLC_BI__Product_Package__c(
                Name = 'TestPP',
                LLC_BI__Credit_Memo__c = creditMemo.Id,
                CSA_Auto_Save_Credit_Memo_Narratives__c = false
        );
		LLC_BI__Product_Package__c oldPP = new LLC_BI__Product_Package__c(
                Name = 'TestPP',
                LLC_BI__Credit_Memo__c = creditMemo.Id,
                CSA_Auto_Save_Credit_Memo_Narratives__c = false, 
				Id = pp.Id
        );
        List<LLC_BI__Product_Package__c> oldObjs = new List<LLC_BI__Product_Package__c>();
        Database.insert(pp);
        oldObjs.add(oldPP);
		
        Test.startTest();
		pp.CSA_Auto_Save_Credit_Memo_Narratives__c = true;
		System.debug('updated ' + pp.CSA_Auto_Save_Credit_Memo_Narratives__c);
		Database.update(pp);
		Set<Id> listObjs = new Set<Id>();
		listObjs.add(pp.Id);

		List<LLC_BI__Product_Package__c> newObjs = [Select Name, LLC_BI__Credit_Memo__c, CSA_Auto_Save_Credit_Memo_Narratives__c from LLC_BI__Product_Package__c where Id = :pp.Id];
        CSA_CreditMemo_Autosave_NarrativeHandler disable = new CSA_CreditMemo_Autosave_NarrativeHandler();
		disable.afterUpdate(newObjs, oldObjs, listObjs);
		disable.afterUpdate(oldObjs, newObjs, listObjs);
		disable.isDoubleFireSafe();
		disable.getType();
        Test.stopTest();
   }
}