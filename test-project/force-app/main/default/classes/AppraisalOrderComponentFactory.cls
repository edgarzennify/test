public with sharing class AppraisalOrderComponentFactory implements IAppraisalOrderComponentFactory{
	
	public interface IAppraisalOrderComponentFactory{
		ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder);
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> getAppraisalOrderSummaryFieldDetailsList(EB_Appraisal_Order__c appraisalOrder);
		String getComponentFieldValidationError(EB_Appraisal_Order__c appraisalOrder);
	}

	private List<AppraisalOrderComponent.IAppraisalOrderComponent> m_components;
	
	public AppraisalOrderComponentFactory(List<AppraisalOrderComponent.IAppraisalOrderComponent> components) {
		m_components = components;
	}

	public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder)
	{
		String collateralCode = collateralCodeFor(appraisalOrder);
		for(AppraisalOrderComponent.IAppraisalOrderComponent c : m_components){
			if(c.handlesCollateralCode(collateralCode)){
				return c.getComponentFor(appraisalOrder);
			}
		}
		return null;
	}

	public List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> getAppraisalOrderSummaryFieldDetailsList(EB_Appraisal_Order__c appraisalOrder)
	{
		String collateralCode = collateralCodeFor(appraisalOrder);
		for(AppraisalOrderComponent.IAppraisalOrderComponent c : m_components){
			if(c.handlesCollateralCode(collateralCode)){
				return c.getAppraisalOrderSummary(appraisalOrder);
			}
		}
		return new List<AppraisalOrders.AppraisalOrderSummaryFieldDetails>();
	}

	private String collateralCodeFor(EB_Appraisal_Order__c appraisalOrder){
		if(appraisalOrder.OREO_Account__c == null){
			return appraisalOrder.Related_Collateral__r.Collateral_Code__r.Collateral_Code_ID__c;
		}else{
			return appraisalOrder.OREO_Account__r.OREO_Collateral_Code__r.Collateral_Code_ID__c;
		}
	}

	public String getComponentFieldValidationError(EB_Appraisal_Order__c appraisalOrder)
	{
		String validationError = '';
		String collateralCode = collateralCodeFor(appraisalOrder);
		for(AppraisalOrderComponent.IAppraisalOrderComponent c : m_components){
			if(c.handlesCollateralCode(collateralCode)){
				return c.getComponentFieldValidationError(appraisalOrder);
			}
		}
		return validationError;
	}


}