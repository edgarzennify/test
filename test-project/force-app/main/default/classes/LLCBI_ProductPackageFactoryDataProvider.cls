public class LLCBI_ProductPackageFactoryDataProvider extends DataProvider implements LLCBI_ProductPackageObjectFactory.IProductPackageFactoryDataProvider{
    public List<LLC_BI__Product_Package__c> getProductPackages(Set<Id> packageIds){ 
		return [
			SELECT
				Id
				,First_Approver__c
				,Second_Approver__c
				,Third_Approver__c
            	,LLC_BI__TCE__c
            	,Channel__c
            	,New_Money_Renewal__c
            	,PASS_Recommendation__c
            	,Contains_Policy_Exceptions__c
            	,Material_Exceptions_Approval_Required__c
			FROM
				LLC_BI__Product_Package__c
			WHERE
				Id IN: packageIds
		];
	}
    public List<LLC_BI__Loan__c> getLoansRelatedToPackages(Set<Id> packageIds){
        return [
			SELECT
				Id
				,Underwriting_Complete__c
            	,LLC_BI__Product_Package__c
            	,LLC_BI__Stage__c
            	,LLC_BI__Structure_Hierarchy__c 
			FROM
				LLC_BI__Loan__c
			WHERE
				LLC_BI__Product_Package__c IN: packageIds
		];
    }

}