@IsTest
private class LoanAppComplianceCalculatorTests {

	private static final EB_Loan_Application__c testLoanApp1;
	private static final EB_Loan_Application__c testLoanApp2;
	private static final EB_Loan_Application__c testLoanApp3;
	private static final List<EB_Loan_Application__c> testLoanApps;
	private static final Set<Id> loanAppIds;
	private static final LoanAppWrapper testLoanAppWrapper1;
	private static final LoanAppWrapper testLoanAppWrapper2;
	private static final LoanAppWrapper testLoanAppWrapper3;

	private static final MockofILoanAppComplianceCalculatorDataProv mockDataProv;
	private static final MockofILoanAppWrapperBuilder mockWrapperBuilder;
	private static final MockofILoanAppCRACalculator mockCRACalculator;
	private static final MockofILoanAppHMDACalculator mockHMDACalculator;
	private static final MockofILoanAppHOEPACalculator mockHOEPACalculator;
	private static final LoanAppComplianceCalculator sut;

	static {
		testLoanApp1 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1'), IsCRAAsDeterminedByTrigger__c=null, IsHMDAAsDeterminedByTrigger__c=null, IsHOEPAAsDeterminedByTrigger__c=null);
		testLoanApp2 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '2'), IsCRAAsDeterminedByTrigger__c=null, IsHMDAAsDeterminedByTrigger__c=null, IsHOEPAAsDeterminedByTrigger__c=null);
		testLoanApp3 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '3'), IsCRAAsDeterminedByTrigger__c=null, IsHMDAAsDeterminedByTrigger__c=null, IsHOEPAAsDeterminedByTrigger__c=null);
		testLoanApps = new List<EB_Loan_Application__c>{testLoanApp1, testLoanApp2, testLoanApp3};
		loanAppIds = new Set<Id> {testLoanApp1.Id, testLoanApp2.Id, testLoanApp3.Id};
		testLoanAppWrapper1 = new LoanAppWrapper(testLoanApp1);
		testLoanAppWrapper2 = new LoanAppWrapper(testLoanApp2);
		testLoanAppWrapper3 = new LoanAppWrapper(testLoanApp3);

		mockDataProv = new MockofILoanAppComplianceCalculatorDataProv();
		mockWrapperBuilder = new MockofILoanAppWrapperBuilder();
		mockCRACalculator = new MockofILoanAppCRACalculator();
		mockHMDACalculator = new MockofILoanAppHMDACalculator();
		mockHOEPACalculator = new MockofILoanAppHOEPACalculator();
		sut = new LoanAppComplianceCalculator(mockDataProv, mockWrapperBuilder, mockCRACalculator, mockHMDACalculator, mockHOEPACalculator);
		mockCRACalculator.setup('DetermineIfCRA', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
		mockHMDACalculator.setup('DetermineIfHMDA', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
		mockHOEPACalculator.setup('DetermineIfHOEPA', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
	}

	@IsTest
    static void it_should_make_a_call_to_data_prov_to_get_all_loan_apps_for_given_ids() {
		mockDataProv.setup('getLoanApplicationsByIds', new List<Object>{loanAppIds}).returns(testLoanApps);

		sut.updateComplianceFieldsForLoanApps(loanAppIds);

		mockDataProv.verify('getLoanApplicationsByIds', new List<Object>{loanAppIds}, Times.Once);
	}

	@IsTest
    static void it_should_get_a_loan_app_wrapper_for_each_loan_app_returned_from_data_prov() {
		mockDataProv.setup('getLoanApplicationsByIds', new List<Object>{loanAppIds}).returns(testLoanApps);

		sut.updateComplianceFieldsForLoanApps(loanAppIds);

		mockWrapperBuilder.verify('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp1}, Times.Once);
		mockWrapperBuilder.verify('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp2}, Times.Once);
		mockWrapperBuilder.verify('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp3}, Times.Once);
	}

	@IsTest
    static void it_should_make_a_call_to_mock_CRA_calculator_for_each_loan_app_returned_from_data_prov() {
		mockDataProv.setup('getLoanApplicationsByIds', new List<Object>{loanAppIds}).returns(testLoanApps);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp1}).returns(testLoanAppWrapper1);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp2}).returns(testLoanAppWrapper2);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp3}).returns(testLoanAppWrapper3);

		sut.updateComplianceFieldsForLoanApps(loanAppIds);
	
		mockCRACalculator.verify('DetermineIfCRA', new List<Object>{testLoanAppWrapper1}, Times.Once);
		mockCRACalculator.verify('DetermineIfCRA', new List<Object>{testLoanAppWrapper2}, Times.Once);
		mockCRACalculator.verify('DetermineIfCRA', new List<Object>{testLoanAppWrapper3}, Times.Once);
	}

	@IsTest
    static void it_should_update_CRA_value_on_loan_app_if_value_has_changed() {
		testLoanApp1.IsCRAAsDeterminedByTrigger__c = false;
		testLoanApp2.IsCRAAsDeterminedByTrigger__c = false;
		testLoanApp3.IsCRAAsDeterminedByTrigger__c = true;
		mockDataProv.setup('getLoanApplicationsByIds', new List<Object>{loanAppIds}).returns(testLoanApps);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp1}).returns(testLoanAppWrapper1);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp2}).returns(testLoanAppWrapper2);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp3}).returns(testLoanAppWrapper3);
		mockCRACalculator.setup('DetermineIfCRA', new List<Object>{testLoanAppWrapper1}).returns(true);
		mockCRACalculator.setup('DetermineIfCRA', new List<Object>{testLoanAppWrapper2}).returns(false);
		mockCRACalculator.setup('DetermineIfCRA', new List<Object>{testLoanAppWrapper3}).returns(false);

		sut.updateComplianceFieldsForLoanApps(loanAppIds);

		mockDataProv.verify('updateLoanApplications', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> rawRequest = mockDataProv.getArgumentsFromCall('updateLoanApplications');
        List<EB_Loan_Application__c> loanAppsUpdated = (List<EB_Loan_Application__c>) (rawRequest.get(0));
        EB_Loan_Application__c testLoanApp1PassedToUpdateCall;
        EB_Loan_Application__c testLoanApp3PassedToUpdateCall;
        for (EB_Loan_Application__c loanapp : loanAppsUpdated) {
        	if (loanapp.Id == testLoanApp1.Id) {
        		testLoanApp1PassedToUpdateCall = loanapp;
        	}
        	if (loanapp.Id == testLoanApp3.Id) {
        		testLoanApp3PassedToUpdateCall = loanapp;
        	}
        }
        System.assertEquals(2, loanAppsUpdated.size());
        System.assertEquals(testLoanApp1.Id, testLoanApp1PassedToUpdateCall.Id);
        System.assertEquals(true, testLoanApp1PassedToUpdateCall.IsCRAAsDeterminedByTrigger__c);
        System.assertEquals(testLoanApp3.Id, testLoanApp3PassedToUpdateCall.Id);
        System.assertEquals(false, testLoanApp3PassedToUpdateCall.IsCRAAsDeterminedByTrigger__c);
	}

	@IsTest
    static void it_should_make_a_call_to_mock_HMDA_calculator_for_each_loan_app_returned_from_data_prov() {
		mockDataProv.setup('getLoanApplicationsByIds', new List<Object>{loanAppIds}).returns(testLoanApps);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp1}).returns(testLoanAppWrapper1);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp2}).returns(testLoanAppWrapper2);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp3}).returns(testLoanAppWrapper3);

		sut.updateComplianceFieldsForLoanApps(loanAppIds);
	
		mockHMDACalculator.verify('DetermineIfHMDA', new List<Object>{testLoanAppWrapper1}, Times.Once);
		mockHMDACalculator.verify('DetermineIfHMDA', new List<Object>{testLoanAppWrapper2}, Times.Once);
		mockHMDACalculator.verify('DetermineIfHMDA', new List<Object>{testLoanAppWrapper3}, Times.Once);
	}

	@IsTest
    static void it_should_update_HMDA_value_on_loan_app_if_value_has_changed() {
		testLoanApp1.IsHMDAAsDeterminedByTrigger__c = false;
		testLoanApp2.IsHMDAAsDeterminedByTrigger__c = false;
		testLoanApp3.IsHMDAAsDeterminedByTrigger__c = true;
		mockDataProv.setup('getLoanApplicationsByIds', new List<Object>{loanAppIds}).returns(testLoanApps);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp1}).returns(testLoanAppWrapper1);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp2}).returns(testLoanAppWrapper2);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp3}).returns(testLoanAppWrapper3);
		mockHMDACalculator.setup('DetermineIfHMDA', new List<Object>{testLoanAppWrapper1}).returns(true);
		mockHMDACalculator.setup('DetermineIfHMDA', new List<Object>{testLoanAppWrapper2}).returns(false);
		mockHMDACalculator.setup('DetermineIfHMDA', new List<Object>{testLoanAppWrapper3}).returns(false);

		sut.updateComplianceFieldsForLoanApps(loanAppIds);

		mockDataProv.verify('updateLoanApplications', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> rawRequest = mockDataProv.getArgumentsFromCall('updateLoanApplications');
        List<EB_Loan_Application__c> loanAppsUpdated = (List<EB_Loan_Application__c>) (rawRequest.get(0));
        EB_Loan_Application__c testLoanApp1PassedToUpdateCall;
        EB_Loan_Application__c testLoanApp3PassedToUpdateCall;
        for (EB_Loan_Application__c loanapp : loanAppsUpdated) {
        	if (loanapp.Id == testLoanApp1.Id) {
        		testLoanApp1PassedToUpdateCall = loanapp;
        	}
        	if (loanapp.Id == testLoanApp3.Id) {
        		testLoanApp3PassedToUpdateCall = loanapp;
        	}
        }
        System.assertEquals(2, loanAppsUpdated.size());
        System.assertEquals(testLoanApp1.Id, testLoanApp1PassedToUpdateCall.Id);
        System.assertEquals(true, testLoanApp1PassedToUpdateCall.IsHMDAAsDeterminedByTrigger__c);
        System.assertEquals(testLoanApp3.Id, testLoanApp3PassedToUpdateCall.Id);
        System.assertEquals(false, testLoanApp3PassedToUpdateCall.IsHMDAAsDeterminedByTrigger__c);
	}

	@IsTest
    static void it_should_make_a_call_to_mock_HOEPA_calculator_for_each_loan_app_returned_from_data_prov() {
		mockDataProv.setup('getLoanApplicationsByIds', new List<Object>{loanAppIds}).returns(testLoanApps);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp1}).returns(testLoanAppWrapper1);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp2}).returns(testLoanAppWrapper2);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp3}).returns(testLoanAppWrapper3);

		sut.updateComplianceFieldsForLoanApps(loanAppIds);
	
		mockHOEPACalculator.verify('DetermineIfHOEPA', new List<Object>{testLoanAppWrapper1}, Times.Once);
		mockHOEPACalculator.verify('DetermineIfHOEPA', new List<Object>{testLoanAppWrapper2}, Times.Once);
		mockHOEPACalculator.verify('DetermineIfHOEPA', new List<Object>{testLoanAppWrapper3}, Times.Once);
	}

	@IsTest
    static void it_should_update_HOEPA_value_on_loan_app_if_value_has_changed() {
		testLoanApp1.IsHOEPAAsDeterminedByTrigger__c = false;
		testLoanApp2.IsHOEPAAsDeterminedByTrigger__c = false;
		testLoanApp3.IsHOEPAAsDeterminedByTrigger__c = true;
		mockDataProv.setup('getLoanApplicationsByIds', new List<Object>{loanAppIds}).returns(testLoanApps);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp1}).returns(testLoanAppWrapper1);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp2}).returns(testLoanAppWrapper2);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp3}).returns(testLoanAppWrapper3);
		mockHOEPACalculator.setup('DetermineIfHOEPA', new List<Object>{testLoanAppWrapper1}).returns(true);
		mockHOEPACalculator.setup('DetermineIfHOEPA', new List<Object>{testLoanAppWrapper2}).returns(false);
		mockHOEPACalculator.setup('DetermineIfHOEPA', new List<Object>{testLoanAppWrapper3}).returns(false);

		sut.updateComplianceFieldsForLoanApps(loanAppIds);

		mockDataProv.verify('updateLoanApplications', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> rawRequest = mockDataProv.getArgumentsFromCall('updateLoanApplications');
        List<EB_Loan_Application__c> loanAppsUpdated = (List<EB_Loan_Application__c>) (rawRequest.get(0));
        EB_Loan_Application__c testLoanApp1PassedToUpdateCall;
        EB_Loan_Application__c testLoanApp3PassedToUpdateCall;
        for (EB_Loan_Application__c loanapp : loanAppsUpdated) {
        	if (loanapp.Id == testLoanApp1.Id) {
        		testLoanApp1PassedToUpdateCall = loanapp;
        	}
        	if (loanapp.Id == testLoanApp3.Id) {
        		testLoanApp3PassedToUpdateCall = loanapp;
        	}
        }
        System.assertEquals(2, loanAppsUpdated.size());
        System.assertEquals(testLoanApp1.Id, testLoanApp1PassedToUpdateCall.Id);
        System.assertEquals(true, testLoanApp1PassedToUpdateCall.IsHOEPAAsDeterminedByTrigger__c);
        System.assertEquals(testLoanApp3.Id, testLoanApp3PassedToUpdateCall.Id);
        System.assertEquals(false, testLoanApp3PassedToUpdateCall.IsHOEPAAsDeterminedByTrigger__c);
	}

	@IsTest
    static void it_should_update_HOEPA_and_HMDA_and_CRA_values_on_loan_app_if_values_have_changed_with_single_call_to_data_prov() {
		testLoanApp1.IsCRAAsDeterminedByTrigger__c = false;
		testLoanApp2.IsCRAAsDeterminedByTrigger__c = false;
		testLoanApp3.IsCRAAsDeterminedByTrigger__c = false;
		testLoanApp1.IsHOEPAAsDeterminedByTrigger__c = false;
		testLoanApp2.IsHOEPAAsDeterminedByTrigger__c = false;
		testLoanApp3.IsHOEPAAsDeterminedByTrigger__c = false;
		testLoanApp1.IsHMDAAsDeterminedByTrigger__c = false;
		testLoanApp2.IsHMDAAsDeterminedByTrigger__c = false;
		testLoanApp3.IsHMDAAsDeterminedByTrigger__c = false;
		mockDataProv.setup('getLoanApplicationsByIds', new List<Object>{loanAppIds}).returns(testLoanApps);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp1}).returns(testLoanAppWrapper1);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp2}).returns(testLoanAppWrapper2);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp3}).returns(testLoanAppWrapper3);
		mockCRACalculator.setup('DetermineIfCRA', new List<Object>{testLoanAppWrapper1}).returns(true);
		mockCRACalculator.setup('DetermineIfCRA', new List<Object>{testLoanAppWrapper2}).returns(false);
		mockCRACalculator.setup('DetermineIfCRA', new List<Object>{testLoanAppWrapper3}).returns(false);
		mockHMDACalculator.setup('DetermineIfHMDA', new List<Object>{testLoanAppWrapper1}).returns(false);
		mockHMDACalculator.setup('DetermineIfHMDA', new List<Object>{testLoanAppWrapper2}).returns(false);
		mockHMDACalculator.setup('DetermineIfHMDA', new List<Object>{testLoanAppWrapper3}).returns(true);
		mockHOEPACalculator.setup('DetermineIfHOEPA', new List<Object>{testLoanAppWrapper1}).returns(false);
		mockHOEPACalculator.setup('DetermineIfHOEPA', new List<Object>{testLoanAppWrapper2}).returns(true);
		mockHOEPACalculator.setup('DetermineIfHOEPA', new List<Object>{testLoanAppWrapper3}).returns(false);

		sut.updateComplianceFieldsForLoanApps(loanAppIds);

		mockDataProv.verify('updateLoanApplications', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> rawRequest = mockDataProv.getArgumentsFromCall('updateLoanApplications');
        List<EB_Loan_Application__c> loanAppsUpdated = (List<EB_Loan_Application__c>) (rawRequest.get(0));
        EB_Loan_Application__c testLoanApp1PassedToUpdateCall;
        EB_Loan_Application__c testLoanApp2PassedToUpdateCall;
        EB_Loan_Application__c testLoanApp3PassedToUpdateCall;
        for (EB_Loan_Application__c loanapp : loanAppsUpdated) {
        	if (loanapp.Id == testLoanApp1.Id) {
        		testLoanApp1PassedToUpdateCall = loanapp;
        	}
        	if (loanapp.Id == testLoanApp2.Id) {
        		testLoanApp2PassedToUpdateCall = loanapp;
        	}
        	if (loanapp.Id == testLoanApp3.Id) {
        		testLoanApp3PassedToUpdateCall = loanapp;
        	}
        }
        System.assertEquals(3, loanAppsUpdated.size());
        System.assertEquals(testLoanApp1.Id, testLoanApp1PassedToUpdateCall.Id);
        System.assertEquals(true, testLoanApp1PassedToUpdateCall.IsCRAAsDeterminedByTrigger__c);
        System.assertEquals(false, testLoanApp1PassedToUpdateCall.IsHOEPAAsDeterminedByTrigger__c);
        System.assertEquals(false, testLoanApp1PassedToUpdateCall.IsHMDAAsDeterminedByTrigger__c);
        System.assertEquals(testLoanApp2.Id, testLoanApp2PassedToUpdateCall.Id);
        System.assertEquals(false, testLoanApp2PassedToUpdateCall.IsCRAAsDeterminedByTrigger__c);
        System.assertEquals(true, testLoanApp2PassedToUpdateCall.IsHOEPAAsDeterminedByTrigger__c);
        System.assertEquals(false, testLoanApp2PassedToUpdateCall.IsHMDAAsDeterminedByTrigger__c);
        System.assertEquals(testLoanApp3.Id, testLoanApp3PassedToUpdateCall.Id);
        System.assertEquals(false, testLoanApp3PassedToUpdateCall.IsCRAAsDeterminedByTrigger__c);
        System.assertEquals(false, testLoanApp3PassedToUpdateCall.IsHOEPAAsDeterminedByTrigger__c);
        System.assertEquals(true, testLoanApp3PassedToUpdateCall.IsHMDAAsDeterminedByTrigger__c);
	}

	@IsTest
    static void it_should_only_send_one_item_for_update_even_if_HOEPA_and_HMDA_and_CRA_values_all_changed() {
		testLoanApp1.IsCRAAsDeterminedByTrigger__c = false;
		testLoanApp1.IsHOEPAAsDeterminedByTrigger__c = false;
		testLoanApp1.IsHMDAAsDeterminedByTrigger__c = false;
		mockDataProv.setup('getLoanApplicationsByIds', new List<Object>{loanAppIds}).returns(testLoanApps);
		mockWrapperBuilder.setup('getLoanAppWrapperForLoanApp', new List<Object>{testLoanApp1}).returns(testLoanAppWrapper1);
		mockCRACalculator.setup('DetermineIfCRA', new List<Object>{testLoanAppWrapper1}).returns(true);
		mockHMDACalculator.setup('DetermineIfHMDA', new List<Object>{testLoanAppWrapper1}).returns(true);
		mockHOEPACalculator.setup('DetermineIfHOEPA', new List<Object>{testLoanAppWrapper1}).returns(true);

		sut.updateComplianceFieldsForLoanApps(loanAppIds);

		mockDataProv.verify('updateLoanApplications', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> rawRequest = mockDataProv.getArgumentsFromCall('updateLoanApplications');
        List<EB_Loan_Application__c> loanAppsUpdated = (List<EB_Loan_Application__c>) (rawRequest.get(0));
        System.assertEquals(1, loanAppsUpdated.size());
	}

	@IsTest
    static void it_should_only_have_one_item_in_list() {
		Map<Id,EB_Loan_Application__c> loanAppsToUpdateMap = new Map<Id,EB_Loan_Application__c>();
		testLoanApp1.IsCRAAsDeterminedByTrigger__c = false;
		loanAppsToUpdateMap.put(testLoanApp1.Id, testLoanApp1);
		testLoanApp1.IsHOEPAAsDeterminedByTrigger__c = false;
		loanAppsToUpdateMap.put(testLoanApp1.Id, testLoanApp1);
		testLoanApp1.IsHMDAAsDeterminedByTrigger__c = false;
		loanAppsToUpdateMap.put(testLoanApp1.Id, testLoanApp1);
		testLoanApp1.IsCRAAsDeterminedByTrigger__c = true;
		loanAppsToUpdateMap.put(testLoanApp1.Id, testLoanApp1);
		testLoanApp1.IsHOEPAAsDeterminedByTrigger__c = true;
		loanAppsToUpdateMap.put(testLoanApp1.Id, testLoanApp1);
		testLoanApp1.IsHMDAAsDeterminedByTrigger__c = true;
		loanAppsToUpdateMap.put(testLoanApp1.Id, testLoanApp1);
		System.debug('***** map list: ' + loanAppsToUpdateMap.values());

		System.assertEquals(1, loanAppsToUpdateMap.values().size());
	}

	private class MockofILoanAppComplianceCalculatorDataProv extends ApexMoq implements LoanAppComplianceCalculatorDataProv.ILoanAppComplianceCalculatorDataProv {
		public List<EB_Loan_Application__c> getLoanApplicationsByIds(Set<Id> ids){
			return (List<EB_Loan_Application__c>)handleMethodInvocation('getLoanApplicationsByIds', new List<Object>{ids});
		}
		public void updateLoanApplications(List<EB_Loan_Application__c> loanapps){
			handleMethodInvocation('updateLoanApplications', new List<Object>{loanapps});
		}
	}

	private class MockofILoanAppWrapperBuilder extends ApexMoq implements LoanAppWrapperBuilder.ILoanAppWrapperBuilder {
		public LoanAppWrapper getLoanAppWrapperForLoanApp(EB_Loan_Application__c loanApp){
			return (LoanAppWrapper)handleMethodInvocation('getLoanAppWrapperForLoanApp', new List<Object>{loanApp});
		}
	}

	private class MockofILoanAppCRACalculator extends ApexMoq implements LoanAppCRACalculator.ILoanAppCRACalculator {
		public Boolean DetermineIfCRA(LoanAppWrapper.ILoanAppWrapper loanapp){
			return (Boolean)handleMethodInvocation('DetermineIfCRA', new List<Object>{loanapp});
		}
	}

	private class MockofILoanAppHMDACalculator extends ApexMoq implements LoanAppHMDACalculator.ILoanAppHMDACalculator {
		public Boolean DetermineIfHMDA(LoanAppWrapper.ILoanAppWrapper loanapp){
			return (Boolean)handleMethodInvocation('DetermineIfHMDA', new List<Object>{loanapp});
		}
	}

	private class MockofILoanAppHOEPACalculator extends ApexMoq implements LoanAppHOEPACalculator.ILoanAppHOEPACalculator {
		public Boolean DetermineIfHOEPA(LoanAppWrapper.ILoanAppWrapper loanapp){
			return (Boolean)handleMethodInvocation('DetermineIfHOEPA', new List<Object>{loanapp});
		}
	}
}