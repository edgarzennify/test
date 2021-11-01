public with sharing class LoanApplicationTriggerHandler extends TriggerHandler {	
	
	private final LoanAppComplianceCalculator.ILoanAppComplianceCalculator m_loanAppComplianceCalculator;
	private Set<Id> m_loanAppIds = new Set<Id>();

	public LoanApplicationTriggerHandler(){
		m_loanAppComplianceCalculator = new LoanAppComplianceCalculator();
	}

	public LoanApplicationTriggerHandler(LoanAppComplianceCalculator.ILoanAppComplianceCalculator loanAppComplianceCalculator){
		m_loanAppComplianceCalculator = loanAppComplianceCalculator;
	}

	public override void initialize(){	
		m_loanAppIds = new Set<Id>();
	}

	public override void bulkAfterInsert(List<SObject> sos){
		for(SObject so : sos){
			EB_Loan_Application__c loanApp = (EB_Loan_Application__c)so;
			m_loanAppIds.add(loanApp.Id);
		}		
	}
	
	public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
		for(SObject oldSo : oldSos){
			EB_Loan_Application__c loanApp = (EB_Loan_Application__c)newSosMap.get(oldSo.Id);
			m_loanAppIds.add(loanApp.Id);
		}
	}
	
	public override void finalize(){
		if(m_loanAppIds.size() > 0){
			m_loanAppComplianceCalculator.updateComplianceFieldsForLoanApps(m_loanAppIds);
		}
	}

}