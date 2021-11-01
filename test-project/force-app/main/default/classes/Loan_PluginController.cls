public with sharing class Loan_PluginController {

    private final Plugin.ILoan_PluginDataProvider m_dataProvider;
    private IStandardController m_standardControllerWrapper;

    public LLC_BI__Loan__c loan {get; private set;}
    public EB_Account__c ebAccount {get; private set;}
    public Boolean displayEbAccountList {get; private set;}
    public Boolean displayLoanList {get; private set;}
    public EB_Account__c ebAccountOfSelf {get; private set;}
    public EB_Account__c ebAccountOfParent {get; private set;}
    public Boolean ebAccountOfParentHasAgreement {get; private set;}

    public Loan_PluginController(Plugin.ILoan_PluginDataProvider dataProvider, IStandardController controller) {
        m_standardControllerWrapper = controller;
        m_dataProvider = dataProvider;
    }
    
    public Loan_PluginController(ApexPages.StandardController controller) {
        m_standardControllerWrapper = new StandardControllerWrapper(controller);
        m_dataProvider = new Loan_PluginDataProvider();       
    }
     
    public void initialize() {
        loan = m_dataProvider.getNcinoLoanById(m_standardControllerWrapper.getRecord().Id);
        setProperties();
        ebAccount = ebAccountOfSelf == null ? ebAccountOfParent : ebAccountOfSelf;
    }

    private void setProperties() {
        List<PM_EB_Account_c> ebAccounts = m_dataProvider.getEbAccountByKey(loan.LLC_BI__lookupKey__c);
        List<LLC_BI__LoanRenewal__c> parentLoanRels = m_dataProvider.getParentLoanRelationship(loan.Id);
        
        if (loanHasEbAccount(ebAccounts)) { 
            ebAccountOfSelf = (EB_Account__c)ebAccounts[0].OriginalSObject;
            displayEbAccountList = true;
            displayLoanList = false;
        } else if(loanHasParent(parentLoanRels)) {
            String parentLoanKey = parentLoanRels[0].LLC_BI__ParentLoanId__r.LLC_BI__lookupKey__c;
            List<PM_EB_Account_c> parentEbAccounts = m_dataProvider.getEbAccountByKey(parentLoanKey);
            if (parentLoanHasEbAccount(parentEbAccounts)) {
                ebAccountOfParent = (EB_Account__c)parentEbAccounts[0].OriginalSObject;
                ebAccountOfParentHasAgreement = parentEbAccountHasAgreement(parentEbAccounts[0]);
                displayEbAccountList = true;
                displayLoanList = false;                
            } else {
                setDefaultDisplayValues();
            }   
        } else {
            setDefaultDisplayValues();
        }
    }

    private void setDefaultDisplayValues() {
        displayEbAccountList = false;
        displayLoanList = true;
        ebAccountOfParentHasAgreement = false;
    }

    private Boolean loanHasEbAccount(List<PM_EB_Account_c> ebAccounts) {
        return !ebAccounts.isEmpty() ? true : false;
    }

    private Boolean loanHasParent(List<LLC_BI__LoanRenewal__c> parentLoanRels) {
        return !parentLoanRels.isEmpty() ? true : false;
    }

    private Boolean parentLoanHasEbAccount(List<PM_EB_Account_c> parentEbAccounts) {
        if (!parentEbAccounts.isEmpty()){// && parentEbAccounts[0].Agreement_EB_Account_Relationship_r.size() > 0) {
            return true;
        }
        return false;
    }
    
    private Boolean parentEbAccountHasAgreement(PM_EB_Account_c parentEbAccount) {
        return parentEbAccount.Agreement_EB_Account_Relationship_r.size() > 0;
    }
}