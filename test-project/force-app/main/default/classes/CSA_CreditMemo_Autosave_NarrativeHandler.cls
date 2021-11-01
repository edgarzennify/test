global with sharing virtual class CSA_CreditMemo_Autosave_NarrativeHandler extends nFORCE.ATriggerHandler{

	public CSA_CreditMemo_Autosave_NarrativeHandler() {}
    public virtual override Boolean shouldExecute(nFORCE.IPipelineContext context){
        Boolean should = super.shouldExecute(context);
        System.debug(context);
        if(should){
        	
            should = true; 
        }
        return should;
    }
    public override Boolean isDoubleFireSafe(){
		return false;
	}


    public virtual override void afterUpdate(List<sObject> newObjs, List<sObject> oldObjs, Set<Id> objIds) {
		System.debug('new');
		System.debug(newObjs);
		System.debug('Old');
		System.debug(oldObjs);
     	List<nFORCE__Screen_Section__c> widgets;
     	List<nFORCE__Widget__c> pendingWidgets;
     	Set<Id> widgets_to_modify = new Set<Id>();
        LLC_BI__Product_Package__c[] product_package = (LLC_BI__Product_Package__c[])newObjs;
        LLC_BI__Product_Package__c[] old_product_package = (LLC_BI__Product_Package__c[])oldObjs;
        List<nFORCE__Widget__c> wToUpdate = new List<nFORCE__Widget__c>();

        if ( (product_package[0].CSA_Auto_Save_Credit_Memo_Narratives__c == true && old_product_package[0].CSA_Auto_Save_Credit_Memo_Narratives__c == false) ||
        	 (product_package[0].CSA_Auto_Save_Credit_Memo_Narratives__c == false && old_product_package[0].CSA_Auto_Save_Credit_Memo_Narratives__c == true) ) {

	        widgets = [SELECT nFORCE__Widget__c from nFORCE__Screen_Section__c where nFORCE__Screen__c in 
	        		(Select LLC_BI__FScreen__c from LLC_BI__Credit_Memo__c where Id = :product_package[0].LLC_BI__Credit_Memo__c) ];
	        for (nFORCE__Screen_Section__c w : widgets) {
	        	if (w.nFORCE__Widget__c != null && String.isNotEmpty(w.nFORCE__Widget__c)) {
	        		widgets_to_modify.add(w.nFORCE__Widget__c);
	        	}
	        }
	        pendingWidgets = [Select Id, nFORCE__View__c from nFORCE__Widget__c where Id in: widgets_to_modify];
	        for (nFORCE__Widget__c item: pendingWidgets) {
	        	if ((item.nFORCE__View__c.unescapeHtml4().indexOf(INCLUDE_TAG) == -1) && (product_package[0].CSA_Auto_Save_Credit_Memo_Narratives__c == true && old_product_package[0].CSA_Auto_Save_Credit_Memo_Narratives__c == false)){
	        		item.nFORCE__View__c = INCLUDE_TAG.escapeHtml4() + ' ' + item.nFORCE__View__c;
	        	} else if (product_package[0].CSA_Auto_Save_Credit_Memo_Narratives__c == false && old_product_package[0].CSA_Auto_Save_Credit_Memo_Narratives__c == true) {
	        		item.nFORCE__View__c = item.nFORCE__View__c.unescapeHtml4().replace(INCLUDE_TAG, '').escapeHtml4();
	        	}
	        	System.debug(item);
	        	wToUpdate.add(item);
	        }

	        nFORCE.DmlUtility.updateObj(wToUpdate);
		}

    }

    public override Type getType(){
		return CSA_CreditMemo_Autosave_NarrativeHandler.class;
	}

	public static String getBeanName(String name) {
		return nFORCE.BeanRegistry.getInstance().generateUniqueBeanName(nFORCE.ATriggerHandler.class,name);
	}
	public static final String BEAN_NAME = getBeanName('csa-credit-memo-autosave-narratives');
	public static final String INCLUDE_TAG = '<script src="/resource/csa_auto_save_credit_memo" />';


}