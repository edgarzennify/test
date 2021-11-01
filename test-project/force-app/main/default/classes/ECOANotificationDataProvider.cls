public class ECOANotificationDataProvider implements ECOANotification.IDataProvider{

	public List<LLC_BI__Loan__c> getLoansForNotification(Date startDate, Date endDate) {
		return 
			[
				SELECT
					  Id,
					  Name,
					  ECOA_Date_Flagged__c,
					  ECOA_Date_Printed__c,
					  ECOA_URL__c,
					  LLC_BI__Account__r.Name,
					  LLC_BI__Account__c,
					  LLC_BI__Product__c,
					  LLC_BI__Product_Type__c,
					  LLC_BI__Product_Line__c
				FROM
					  LLC_BI__Loan__c
				WHERE
					  ECOA_Date_Flagged__c >=: startDate
					  AND ECOA_Date_Flagged__c <=: endDate
			];
	}

	public void save(List<SObject> sObjects) {
		List<SObject> updateObjs = new List<SObject>();
		for(SObject o : sObjects) {
			if(!String.isBlank(o.Id)) updateObjs.add(o);
		}
		update updateObjs;
	}

	public List<EB_loan_Application__c> getLoanAppsForNotification(Date startDate, Date endDate) {
		return [
				SELECT 
					Id,
					Name,
					EB_Loan_Packet__r.Lead_Entity__c,
					EB_Loan_Packet__r.Lead_Entity__r.Name,
					Loan_Type__c,
					ECOA_Date_Flagged__c,
					ECOA_Date_Printed__c,
					ECOA_Document_URL__c, 
				   	Business_Purpose__c
				FROM 
					EB_Loan_Application__c 
				WHERE 
					ECOA_Date_Flagged__c >=: startDate 
					AND ECOA_Date_Flagged__c <=: endDate
		];
	}

}