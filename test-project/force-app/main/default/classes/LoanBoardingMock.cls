public class LoanBoardingMock {
    
    public class ofDataProvider extends ApexMoq implements LoanBoarding.IDataProvider {
        public PM_LLCBI_Loan_c getnCinoLoan(Id loanId) {
            return (PM_LLCBI_Loan_c)handleMethodInvocation('getnCinoLoan', new List<Object>{loanId});
        } 
        public PM_EB_Loan_Application_c getLoanForceLoan(Id loanId) {
            return (PM_EB_Loan_Application_c)handleMethodInvocation('getLoanForceLoan', new List<Object>{loanId});
        }
        public List<PM_EB_Collateral_Client_Relationship_c> getLoanForceCollateralEntityRelationships(List<Id> collateralIds) {
            return (List<PM_EB_Collateral_Client_Relationship_c>)handleMethodInvocation('getLoanForceCollateralEntityRelationships', new List<Object>{collateralIds});
        }
        public List<EB_Industry_Code__c> getIndustryCodes() {
            return (List<EB_Industry_Code__c>)handleMethodInvocation('getIndustryCodes');
        }
        public List<PM_LLCBI_Pricing_Payment_Component_c> getnCinoPayStreams(String loanId) {
            return (List<PM_LLCBI_Pricing_Payment_Component_c>)handleMethodInvocation('getnCinoPayStreams', new List<Object>{loanId});
        }
        public List<PM_LLCBI_Pricing_Rate_Component_c> getnCinoRateStreams(String loanId) {
            return (List<PM_LLCBI_Pricing_Rate_Component_c>)handleMethodInvocation('getnCinoRateStreams', new List<Object>{loanId});
        }
    }

    public class ofDmBuilder extends ApexMoq implements LoanBoarding.IDmBuilder {
        public SObjectType isType() {
            return (SObjectType)handleMethodInvocation('isType');
        }
        public DmLoan buildDmLoan(string loanId) {
            return (DmLoan)handleMethodInvocation('buildDmLoan', new List<Object>{loanId});
        }
    }

    public class ofDmBuilderHelper extends ApexMoq implements LoanBoarding.IDmBuilderHelper {
        public DmLoan buildLoan(Object pm) {
            return (DmLoan)handleMethodInvocation('buildLoan', new List<Object>{pm});
        }
        public DmLoanEntityRelationship buildRelatedEntities(Object involvement, List<EB_Industry_Code__c> codes) {
            return (DmLoanEntityRelationship)handleMethodInvocation('buildRelatedEntities', new List<Object>{involvement, codes});
        }
        public DmLoanCollateralRelationship buildPledgedCollateral(Object pm) {
            return (DmLoanCollateralRelationship)handleMethodInvocation('buildPledgedCollateral', new List<Object>{pm});
        }
        public DmParticipation buildParticipation(Object pm) {
            return (DmParticipation)handleMethodInvocation('buildParticipation', new List<Object>{pm});
        }
        public DmMemo buildMemo(Object pm) { 
            return (DmMemo)handleMethodInvocation('buildMemo', new List<Object>{pm}); 
        }
        public DmLoanPaymentStream buildPayStream(Object pm) {
            return (DmLoanPaymentStream)handleMethodInvocation('buildPayStream', new List<Object>{pm});
        }
        public dmLoanRateStream buildRateStream(Object pm) {
            return (dmLoanRateStream)handleMethodInvocation('buildRateStream', new List<Object>{pm});
        }
    } 

    public class ofVmBuilder extends ApexMoq implements LoanBoarding.IVmBuilder {
        public LoanBoarding.FormVm buildFormVm(DmLoan dmLoan) {
            return (LoanBoarding.FormVm)handleMethodInvocation('buildFormVm', new List<Object>{dmLoan});
        }
    }

    public class ofVmBuilderHelper extends ApexMoq implements LoanBoarding.IVmBuilderHelper {
        public LoanBoarding.LoanVm buildVmLoan(DmLoan dmLoan) {
            return (LoanBoarding.LoanVm)handleMethodInvocation('buildVmLoan', new List<Object>{dmLoan});
        }
        public LoanBoarding.CustomerVm buildAccountToCustomerRelationship(DmLoanEntityRelationship dm) {
            return (LoanBoarding.CustomerVm)handleMethodInvocation('buildAccountToCustomerRelationship', new List<Object>{dm});
        }
        public LoanBoarding.CollateralVm buildVmCollateral(DmLoanCollateralRelationship dm) {
            return (LoanBoarding.CollateralVm)handleMethodInvocation('buildVmCollateral', new List<Object>{dm});
        }
        public LoanBoarding.ParticipationVm buildVmParticipation(DmParticipation dm) {
            return (LoanBoarding.ParticipationVm)handleMethodInvocation('buildVmParticipation', new List<Object>{dm});
        }
        public LoanBoarding.MemoVm buildVmMemo(DmMemo dm) {
            return (LoanBoarding.MemoVm)handleMethodInvocation('buildVmMemo', new List<Object>{dm});
        }
        public LoanBoarding.LoanPaymentStreamVm buildVmPayStream(DmLoanPaymentStream dm) {
            return (LoanBoarding.LoanPaymentStreamVm)handleMethodInvocation('buildVmPayStream', new List<Object>{dm});
        }
        public LoanBoarding.LoanRateStreamVm buildVmRateStream(DmLoanRateStream dm) {
            return (LoanBoarding.LoanRateStreamVm)handleMethodInvocation('buildVmRateStream', new List<Object>{dm});
        }
    }

    public class ofPresenter extends ApexMoq implements LoanBoarding.IPresenter {
        public LoanBoarding.FormVm build(String loanId){
            return (LoanBoarding.FormVm)handleMethodInvocation('build', new List<Object>{loanId});
        }
    }
}