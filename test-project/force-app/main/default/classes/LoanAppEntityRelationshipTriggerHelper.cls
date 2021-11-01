public class LoanAppEntityRelationshipTriggerHelper {	
	public void AfterUpdate(List<EB_Loan_App_Entity_Relationship__c> newList, Map<id ,EB_Loan_App_Entity_Relationship__c> newMap ){
		updatePrimaryBorrowerOnLoanApp(newMap);
	}
	
	public void updatePrimaryBorrowerOnLoanApp(Map<Id, EB_Loan_App_Entity_Relationship__c> rels){
		Map<Id,EB_Loan_Application__c> appsToUpdate = new Map<Id,EB_Loan_Application__c>();
        
        for(EB_Loan_App_Entity_Relationship__c rel: [SELECT 
                                                     Id, Loan_Application_ID__c, Loan_Application_ID__r.Primary_Borrower__c, Relationship_type__c , Entity_Name__r.Entity_Name__c 
                                                     FROM EB_Loan_App_Entity_Relationship__c 
                                                     WHERE id IN: rels.keySet() AND Relationship_type__c = 'Primary Borrower']){
            if(rel.Loan_Application_ID__r.Primary_Borrower__c <> rel.Entity_Name__r.Entity_Name__c){
                EB_Loan_Application__c app = new EB_Loan_Application__c(Id=rel.Loan_Application_ID__c, Primary_Borrower__c = rel.Entity_Name__r.Entity_Name__c);
                appsToUpdate.put(app.Id, app);
            }
        }
            
        if(appsToUpdate.size() > 0){
           update appsToUpdate.values();
        }
	}
}