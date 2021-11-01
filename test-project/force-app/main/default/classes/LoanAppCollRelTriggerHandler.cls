public with sharing class LoanAppCollRelTriggerHandler extends TriggerHandler {	
	
	private final LoanAppCollRelTriggerHandlerDataProv.ILoanAppCollRelTriggerHandlerDataProv m_dataProvider;
	private final LoanAppComplianceCalculator.ILoanAppComplianceCalculator m_loanAppComplianceCalculator;
	private Set<Id> m_loanAppCollRelIds;

	public LoanAppCollRelTriggerHandler(){
		m_dataProvider = new LoanAppCollRelTriggerHandlerDataProv();
		m_loanAppComplianceCalculator = new LoanAppComplianceCalculator();
	}

	public LoanAppCollRelTriggerHandler(LoanAppCollRelTriggerHandlerDataProv.ILoanAppCollRelTriggerHandlerDataProv dataProvider
										 ,LoanAppComplianceCalculator.ILoanAppComplianceCalculator loanAppComplianceCalculator){
		m_dataProvider = dataProvider;
		m_loanAppComplianceCalculator = loanAppComplianceCalculator;
	}

	public override void initialize(){
		m_loanAppCollRelIds = new Set<Id>();
	}

	public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
		for(SObject oldSo : oldSos){
			EB_Loan_App_Collateral_Relationship__c loanAppCollRel = (EB_Loan_App_Collateral_Relationship__c)newSosMap.get(oldSo.Id);
			m_loanAppCollRelIds.add(loanAppCollRel.Id);
		}
	}
	
	public override void finalize(){
		if(m_loanAppCollRelIds.size() > 0){
			Set<Id> relatedLoanAppIds = m_dataProvider.getRelatedLoanAppIds(m_loanAppCollRelIds);
			m_loanAppComplianceCalculator.updateComplianceFieldsForLoanApps(relatedLoanAppIds);
		}
	}

}