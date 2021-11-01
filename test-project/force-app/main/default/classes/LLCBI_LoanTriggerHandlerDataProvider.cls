public class LLCBI_LoanTriggerHandlerDataProvider extends DataProvider implements LLCBI_LoanTriggerHandler.ILLCBI_LoanTriggerHandlerDataProvider{
	
	public List<LLC_BI__Loan_Collateral2__c> getPledges(List<LLC_BI__Loan__c> loans){
		return [
			SELECT
				Id
				,LLC_BI__Loan__c
				,LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Collateral_Record_Type__c
			FROM
				LLC_BI__Loan_Collateral2__c
			WHERE
				LLC_BI__Loan__c IN: loans
		];
	}
    public List<Conditions__c> getAllRelatedConditions(Set<Id> packageIds){
        return [SELECT Id
                	  ,Funding_Condition__c
               		  ,Product_Package__c
               		  ,Status__c
               FROM Conditions__c
               WHERE Product_Package__c IN : packageIds ];
    }
    public List<Account> gatherRelatedEntities(Set<Id> entityIds){ 
        return [SELECT Id
                	,AnnualRevenue
                	,BillingState
               FROM Account
               WHERE Id IN: entityIds];
    }
}