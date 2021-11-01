@IsTest
public class PluginMock {

	public class ofILoan_PluginDataProvider extends ApexMoq implements Plugin.ILoan_PluginDataProvider{
        public LLC_BI__Loan__c getNcinoLoanById(Id recordId){
            return (LLC_BI__Loan__c)handleMethodInvocation('getNcinoLoanById', new List<Object>{recordId});
        }
        public List<PM_EB_Account_c> getEbAccountByKey(String key){
            return (List<PM_EB_Account_c>)handleMethodInvocation('getEbAccountByKey', new List<Object>{key});
        }
        public List<LLC_BI__LoanRenewal__c> getParentLoanRelationship(Id loanId){
            return (List<LLC_BI__LoanRenewal__c>)handleMethodInvocation('getParentLoanRelationship', new List<Object>{loanId});
        }
    }  

    public class ofICollateral_PluginDataProvider extends ApexMoq implements Plugin.ICollateral_PluginDataProvider{
        public LLC_BI__Collateral__c getNcinoCollateralById(Id ncinoId){
            return (LLC_BI__Collateral__c)handleMethodInvocation('getNcinoCollateralById', new List<Object>{ncinoId});
        }        
        public List<EB_Collateral__c> getEbCollateralByNameOrKey(String name, String syncKey){
            return (List<EB_Collateral__c>)handleMethodInvocation('getEbCollateralByNameOrKey', new List<Object>{name, syncKey});
        }       
        public Collateral_Code__c getCollateralCode(String collCodeName){
            return (Collateral_Code__c)handleMethodInvocation('getCollateralCode', new List<Object>{collCodeName});
        }        
        public EB_Collateral__c save(EB_Collateral__c ebCollateral){
            return (EB_Collateral__c)handleMethodInvocation('save', new List<Object>{ebCollateral});
        }
    }
}