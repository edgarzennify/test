public class AppraisalOrders{
    public Interface IAppraisalOrderDataProvider{
        EB_Appraisal_Order__c getAppraisalOrderForId(Id orderId);
        EB_Appraisal_Order__c initializeThroughCollateral(Eb_Appraisal_Order__c order, Id collateralId);
        EB_Appraisal_Order__c initializeThroughAccount(Eb_Appraisal_Order__c order, Id accountId);
        void submitOrder(Eb_Appraisal_Order__c order);
        void save(Eb_Appraisal_Order__c order);
        void setRecordType(EB_Appraisal_Order__c order);
    }

    public class AppraisalOrderSummaryFieldDetails{
    	public String fieldLabel{get;set;}
    	public String fieldValue{get;set;}

    	public AppraisalOrderSummaryFieldDetails(String fldLabel, String fldValue){
    		fieldLabel = fldLabel;
    		fieldValue = fldValue;
    	}
    }

}