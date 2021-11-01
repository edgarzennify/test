public with sharing class LoanAppComplianceCalculator implements LoanAppComplianceCalculator.ILoanAppComplianceCalculator {

	public interface ILoanAppComplianceCalculator{
		void updateComplianceFieldsForLoanApps(Set<Id> loanAppIds);
	}

	private LoanAppComplianceCalculatorDataProv.ILoanAppComplianceCalculatorDataProv m_dataProv;
	private LoanAppWrapperBuilder.ILoanAppWrapperBuilder m_wrapperBuilder;
	private LoanAppCRACalculator.ILoanAppCRACalculator m_craCalculator;
	private LoanAppHMDACalculator.ILoanAppHMDACalculator m_hmdaCalculator;
	private LoanAppHOEPACalculator.ILoanAppHOEPACalculator m_hoepaCalculator;

	public LoanAppComplianceCalculator() 
	{
		LoanAppComplianceCalculatorDataProv dataProv = new LoanAppComplianceCalculatorDataProv();
		LoanAppWrapperBuilder wrapperBuilder = new LoanAppWrapperBuilder();
		LoanAppCRACalculator craCalculator = new LoanAppCRACalculator();
		LoanAppHMDACalculator hmdaCalculator = new LoanAppHMDACalculator();
		LoanAppHOEPACalculator hoepaCalculator = new LoanAppHOEPACalculator();
		Initialize(dataProv, wrapperBuilder, craCalculator, hmdaCalculator, hoepaCalculator);
	}

	public LoanAppComplianceCalculator(LoanAppComplianceCalculatorDataProv.ILoanAppComplianceCalculatorDataProv dataProv,
										LoanAppWrapperBuilder.ILoanAppWrapperBuilder wrapperBuilder,
										LoanAppCRACalculator.ILoanAppCRACalculator craCalculator, 
										LoanAppHMDACalculator.ILoanAppHMDACalculator hmdaCalculator, 
										LoanAppHOEPACalculator.ILoanAppHOEPACalculator hoepaCalculator) 
	{
		Initialize(dataProv, wrapperBuilder, craCalculator, hmdaCalculator, hoepaCalculator);
	}

	private void Initialize(LoanAppComplianceCalculatorDataProv.ILoanAppComplianceCalculatorDataProv dataProv,
										LoanAppWrapperBuilder.ILoanAppWrapperBuilder wrapperBuilder,
										LoanAppCRACalculator.ILoanAppCRACalculator craCalculator, 
										LoanAppHMDACalculator.ILoanAppHMDACalculator hmdaCalculator, 
										LoanAppHOEPACalculator.ILoanAppHOEPACalculator hoepaCalculator)  
	{
		m_dataProv = dataProv;
		m_wrapperBuilder = wrapperBuilder;
		m_craCalculator = craCalculator;
		m_hmdaCalculator = hmdaCalculator;
		m_hoepaCalculator = hoepaCalculator;
	}

	public void updateComplianceFieldsForLoanApps(Set<Id> loanAppIds){
		Map<Id,EB_Loan_Application__c> loanAppsToUpdate = new Map<Id,EB_Loan_Application__c>();
		List<EB_Loan_Application__c> loanApps = m_dataProv.getLoanApplicationsByIds(loanAppIds);
		for(EB_Loan_Application__c loanapp : loanApps){
			LoanAppWrapper loanappWrapper = m_wrapperBuilder.getLoanAppWrapperForLoanApp(loanapp);
			Boolean calculatedCRA = m_craCalculator.DetermineIfCRA(loanappWrapper);
			if(calculatedCRA != loanapp.IsCRAAsDeterminedByTrigger__c){
				loanapp.IsCRAAsDeterminedByTrigger__c = calculatedCRA;
				loanAppsToUpdate.put(loanapp.Id, loanapp);
			}
			Boolean calculatedHMDA = m_hmdaCalculator.DetermineIfHMDA(loanappWrapper);
			if(calculatedHMDA != loanapp.IsHMDAAsDeterminedByTrigger__c){
				loanapp.IsHMDAAsDeterminedByTrigger__c = calculatedHMDA;
				loanAppsToUpdate.put(loanapp.Id, loanapp);
			}
			Boolean calculatedHOEPA = m_hoepaCalculator.DetermineIfHOEPA(loanappWrapper);
			if(calculatedHOEPA != loanapp.IsHOEPAAsDeterminedByTrigger__c){
				loanapp.IsHOEPAAsDeterminedByTrigger__c = calculatedHOEPA;
				loanAppsToUpdate.put(loanapp.Id, loanapp);
			}
		}
		if(loanAppsToUpdate.size() > 0){
			m_dataProv.updateLoanApplications(loanAppsToUpdate.values());
		}
	}


}