public with sharing class AccountNumberGenerator {

    public interface IDataProvider {
        Card_Information__c getCardInformationById(Id objectId);
        List<Card_Information__c> getActiveCardInformationsByType(String accountType);
        List<Card_Information__c> getAllActiveCardInformations();
        void save(SObject so);
    }

    private List<Card_Information__c> depositTypes;
    private List<Card_Information__c> loanTypes;
    private final IDataProvider m_dataProvider;
    private final IApexPages m_apexPages;
    private final AccountNumberGeneratorHelper.IAccountNumberGeneratorHelper m_helper;
    private Integer CountTestCall = 0;
    private string InitialMessage = '';
    private final string DEPOSIT_DEFAULT_SELECTED_TYPE_KEY = 'checking';
    private final string LOAN_DEFAULT_SELECTED_TYPE_KEY = 'business loan';
    private final string DEPOSIT_KEY = 'Deposit';
    private final string LOAN_KEY = 'Loan';

    public String generatedNumber {get;set;}
    public String numberOfAccounts {get;set;}
    public String downloadData{get;set;}
    public Id generateId {get;set;}
    public String CardName {get;set;}
    public Boolean IsError{get{return String.isNotBlank(ErrorMessage);}}  
    public Boolean IsNumberOfAccountsMoreThanOne{get{return AccountDetails != null && AccountDetails.size()>1;}}     
    public List<AccountDetail> AccountDetails{get;set;}
    public String ErrorMessage{get;set;}
    
    public AccountNumberGenerator(){       
        m_dataProvider = new AccountNumberGeneratorDataProvider();
        m_apexPages = new ApexPagesWrapper();
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider gatewayMetadataProvider = new GatewayApiMetadataProvider();
        RestService restService = new RestService(gatewayMetadataProvider, Configurations.bootstrap());
        IJson jsonWrapper = new jsonWrapper();
        AccountNumberServiceProxy.IAccountNumberService accountService = new AccountNumberServiceProxy(restService,jsonWrapper);
        IEncodingUtil encondigUtil = new EncodingUtilProvider();
        UserInfoService.IUserInfoServiceDataProv userInfoDp = new UserInfoServiceDataProv();
        Configurations.IConfigurations configs = Configurations.Bootstrap();
        IUserInfoService uinfo = new UserInfoService(configs,userInfoDp);
        m_helper = new AccountNumberGeneratorHelper(accountService,uinfo, configs,  encondigUtil);
        initialize();
    }

    public AccountNumberGenerator(IDataProvider dataProvider, IApexPages apexPages,  AccountNumberGeneratorHelper.IAccountNumberGeneratorHelper helper){
        m_dataProvider = dataProvider;
        m_apexPages = apexPages;
        m_helper = helper;
        initialize();
    }

    private void initialize(){
        CardName = '';
        downloadData = '';
        ErrorMessage = '';
        if(string.isBlank(numberOfAccounts)) numberOfAccounts = '1'; 
    }

    public Integer NumberGeneratorMax{
        get{
            return m_helper.getNumberGeneratorMax();
        }
    }

    public List<SelectOption> getDepositAccountType{
        get{           
            return m_helper.GetAccountTypes(DepositCardInformation,DEPOSIT_DEFAULT_SELECTED_TYPE_KEY, generateId);
        }
    }

    public List<SelectOption> getLoanAccountType{
        get{          
            return m_helper.GetAccountTypes(LoanCardInformation, LOAN_DEFAULT_SELECTED_TYPE_KEY, generateId);
        }
    }

    public string DepositTableTitle{
        get{
            for(Card_Information__c c : depositTypes){
                if(c.Id == generateId){
                    return c.Card_Type__c;
                }
            }
            return '';
        }
    }

    public string LoanTableTitle{
        get{
            for(Card_Information__c c : loanTypes){
                if(c.Id == generateId){
                    return c.Card_Type__c;
                }
            }
            return '';
        }
    }

    public PageReference Generate() {
        PageReference pg = GenerateAndAssignLoan();
        if(pg != null) return pg;
        String sanatizedNumberOfAccounts = numberOfAccounts.replace(',','').trim();
        if(String.isBlank(sanatizedNumberOfAccounts)) return pg;
        Integer numOfAccounts = Integer.valueOf(sanatizedNumberOfAccounts);
        GenerateAccounts(numOfAccounts);   
        return pg;
    }

    //Used by loan apps to generate new numbers
    public PageReference GenerateAndAssignLoan(){
        Id objectId = m_apexPages.getParameter('id'); 
        if(objectId != null && objectId.getSobjectType() == LLC_BI__Loan__c.SObjectType){
            GenerateAccounts(1);
            assignNumberToLoan(objectId, generatedNumber);
            return new PageReference('/' + objectId);
        }
        return null;
    }

    public void ResetGenerator() {
            numberOfAccounts = '1';
            ErrorMessage = '';
            generateId = null;
            ResetAccountDetails();  
    }

    //Used by old applications to generate numbers
    public String getNewAccountNumber(String cardIdentifier){
        AccountSvcDetail asd = m_helper.getNewAccountNumber(cardIdentifier, 1);
        SetDetails(asd);
        return cardIdentifier == 'Available'?  InitialMessage: generatedNumber;
    }

    private void GenerateAccounts(Integer numberOfAccounts){
        Card_Information__c card = m_dataProvider.getCardInformationById(generateId);
        if(card == null) return;
        AccountSvcDetail asd =  m_helper.getNewAccountNumber(card.url__c, numberOfAccounts);
        if(asd == null) return;
        SetDetails(asd);
        CardName = card.Card_Type__c;
    }

    private void SetDetails(AccountSvcDetail asd){
        ErrorMessage = asd.ErrorMessage;
        if(String.IsBlank(ErrorMessage)){
            generatedNumber = asd.AccountNumbers[0];
            AccountDetails = asd.AccountDetails;
            downloadData = asd.CsvDataAsBase64;
        }else{
            ResetAccountDetails();
        }
    }

    private void assignNumberToLoan(Id loanId, String accountNumber){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Id=loanId);
        loan.LLC_BI__lookupKey__c = accountNumber;
        m_dataProvider.save(loan);
    }

    private void ResetAccountDetails(){
        AccountDetails = null;
        downloadData = '';
    }

    private List<Card_Information__c> DepositCardInformation{
        get{
            if(depositTypes == null){
                depositTypes = m_dataProvider.getActiveCardInformationsByType(DEPOSIT_KEY);
            }
            return depositTypes;
        }
    }
    private List<Card_Information__c> LoanCardInformation{
        get{
            if(loanTypes == null){
                loanTypes = m_dataProvider.getActiveCardInformationsByType(LOAN_KEY);
            }
            return loanTypes;
        }
    }

    public class AccountDetail{
        public integer Count{get;set;}
        public String AccountNumber{get;set;}
    }

    public class AccountSvcDetail{
        public List<String> AccountNumbers{get;set;}
        public String ErrorMessage{get;set;}
        public List<AccountDetail> AccountDetails{get;set;}
        public String CsvDataAsBase64{get;set;}
    }

}