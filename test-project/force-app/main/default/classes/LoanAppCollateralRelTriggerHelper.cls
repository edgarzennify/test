public class LoanAppCollateralRelTriggerHelper {
	public void AfterUpdate(list <EB_Loan_App_Collateral_Relationship__c> newList, Map <id, EB_Loan_App_Collateral_Relationship__c> newMap ){
        Map<Id, EB_Loan_Application__c> appsToUpdate = new Map<Id, EB_Loan_Application__c>();
		
        //Map<id,String> appMap = new Map<Id,String>();
		for(EB_Loan_App_Collateral_Relationship__c rel: [SELECT 
		                                                 Id, EB_Loan_Application_ID__c, EB_Loan_Application_ID__r.Primary_Collateral_Code__c, Purpose_of_Collateral__c, EB_Collateral_ID__r.Collateral_Code__r.Name, EB_Collateral_ID__r.Collateral_Code__r.Collateral_Code_ID__c 
		                                                 FROM EB_Loan_App_Collateral_Relationship__c 
		                                                 WHERE Id IN: newMap.keyset() AND Purpose_of_Collateral__c = 'Primary'] ){
            //if(rel.Purpose_of_Collateral__c == 'Primary'){
            String collateralCode = rel.EB_Collateral_ID__r.Collateral_Code__r.Name + ' [' +  rel.EB_Collateral_ID__r.Collateral_Code__r.Collateral_Code_ID__c + ']';
            if(rel.EB_Loan_Application_ID__r.Primary_Collateral_Code__c != collateralCode){
            	EB_Loan_Application__c app = new EB_Loan_Application__c(Id=rel.EB_Loan_Application_Id__c, Primary_Collateral_Code__c=collateralCode);
                appsToUpdate.put(app.Id, app);
            }            
			//appMap.put(rel.EB_Loan_Application_ID__c, CollCodeDescription  );
			//system.debug('####   ' + rel.EB_Collateral_ID__r.Collateral_Code__r.name);
			//}
		}

        /*for(List<EB_Loan_Application__c> apps : [SELECT Id, Primary_Collateral_Code__c FROM EB_Loan_Application__c WHERE id in :appMap.KeySet()]){
			for(EB_Loan_Application__c app: apps){
				app.Primary_Collateral_Code__c = appMap.get(app.Id);
				updateList.add(app);
			}
			 update updateList;
		}*/
		
		if(appsToUpdate.size() > 0){
           update appsToUpdate.values();
        }
	}
	
}