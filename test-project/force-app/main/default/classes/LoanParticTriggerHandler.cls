public with sharing class LoanParticTriggerHandler extends TriggerHandler {	
	
	private final LoanParticTriggerHandlerDataProv.ILoanParticTriggerHandlerDataProv m_dataProvider;
	private final LoanAppComplianceCalculator.ILoanAppComplianceCalculator m_loanAppComplianceCalculator;
	private Set<Id> m_participationIds = new Set<Id>();

	public LoanParticTriggerHandler(){
		m_dataProvider = new LoanParticTriggerHandlerDataProv();
		m_loanAppComplianceCalculator = new LoanAppComplianceCalculator();
	}

	public LoanParticTriggerHandler(LoanParticTriggerHandlerDataProv.ILoanParticTriggerHandlerDataProv dataProvider
										 ,LoanAppComplianceCalculator.ILoanAppComplianceCalculator loanAppComplianceCalculator){
		m_dataProvider = dataProvider;
		m_loanAppComplianceCalculator = loanAppComplianceCalculator;
	}

	public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
		for(SObject oldSo : oldSos){
			EB_Loan_Participation__c participation = (EB_Loan_Participation__c)newSosMap.get(oldSo.Id);
			m_participationIds.add(participation.Id);
		}
	}
		
	public override void finalize(){
		Set<Id> relatedLoanAppIds = m_dataProvider.getRelatedLoanAppIds(m_participationIds);
		m_loanAppComplianceCalculator.updateComplianceFieldsForLoanApps(relatedLoanAppIds);
	}

}