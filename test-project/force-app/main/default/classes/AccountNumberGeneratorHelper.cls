public class AccountNumberGeneratorHelper implements IAccountNumberGeneratorHelper {
    public interface IAccountNumberGeneratorHelper{
        List<SelectOption> GetAccountTypes(List<Card_Information__c> accountTypes, string selectItemKey, Id generateId);
        AccountNumberGenerator.AccountSvcDetail getNewAccountNumber(String cardIdentifier, Integer numberOfAccounts);
        string getBlobLineItems(List<string> lines);
        integer getNumberGeneratorMax();
    }

    private final string PERMISSIONSET_ALTERNATE_MAX = 'Function - Generate Account Number Alternate Max';
    private final string CONFIG_NUMBER_MAX = 'NumberGeneratorMax';
    private final string CONFIG_ALTERNATE_NUMBER_MAX = 'NumberGeneratorAlternateMax';

    private final AccountNumberServiceProxy.IAccountNumberService m_accountService;
    private final IEncodingUtil m_encodingUtil;
    private final IUserInfoService m_userInfo;
    private final Configurations.IConfigurations m_configs;

    public AccountNumberGeneratorHelper(AccountNumberServiceProxy.IAccountNumberService accountService, IUserInfoService userInfo, Configurations.IConfigurations configs,  IEncodingUtil encodingUtil){
        m_accountService = accountService;
        m_encodingUtil = encodingUtil;
        m_userInfo = userInfo;
        m_configs = configs;
    }

    public List<SelectOption> GetAccountTypes(List<Card_Information__c> accountTypes, string selectItemKey, Id generateId){
        List<SelectOption> localAccountTypes = new List<SelectOption>();
        for(Card_Information__c c : accountTypes){
            localAccountTypes.add(new SelectOption(c.Id,c.Card_Type__c));
            if(String.IsBlank(generateId) && String.isNotBlank(c.Card_Type__c)&& c.Card_Type__c.tolowerCase().contains(selectItemKey)){
                generateId = c.Id;
            }
        }
        return localAccountTypes;
    }

    public AccountNumberGenerator.AccountSvcDetail getNewAccountNumber(String cardIdentifier, Integer numberOfAccounts){
        AccountNumberGenerator.AccountSvcDetail svcDetail = new AccountNumberGenerator.AccountSvcDetail();
        svcDetail.ErrorMessage = '';
        String error = 'Error getting account number.';
        Integer numberGeneratorMax = getNumberGeneratorMax();
        if(numberOfAccounts == 1){
            AccountNumberServiceProxy.AccountNumberSvcResponse res = m_accountService.getNewAccountNumber(cardIdentifier);
            if(res != null && String.isNotBlank(res.accountNumber)){
                svcDetail.AccountNumbers = new List<string>{res.AccountNumber};
                svcDetail.AccountDetails =  BuildAccountDetails(svcDetail.AccountNumbers);
                svcDetail.CsvDataAsBase64 = getBlobLineItems(svcDetail.AccountNumbers);
            }else{
                svcDetail.ErrorMessage = error;
            }
        }else if(numberOfAccounts > 1 && numberOfAccounts <= numberGeneratorMax){
            AccountNumberServiceProxy.AccountNumbersSvcResponse res = m_accountService.getNewAccountNumbers(cardIdentifier, numberOfAccounts);
            if(res != null && res.accountNumbers != null){
                svcDetail.AccountNumbers = res.AccountNumbers;
                svcDetail.AccountDetails =  BuildAccountDetails(svcDetail.AccountNumbers);
                svcDetail.CsvDataAsBase64 = getBlobLineItems(svcDetail.AccountNumbers);
            }else{
                svcDetail.ErrorMessage = error;
            }
        }else {
            svcDetail.ErrorMessage = String.Format('Please select number of accounts between 1 and {0}', new List<string>{String.valueof(numberGeneratorMax)});
        }
       
        return svcDetail;
    }

    public string getBlobLineItems(List<string> lines){
        String linesAsString = '';
        for(string s: lines){
            linesAsString = linesAsString + s + '\r\n';
        }
        blob b = Blob.ValueOf(linesAsString);
        return m_encodingUtil.toBase64(b);
    }

    public Integer getNumberGeneratorMax(){
        Boolean checkPermissionForAltMax = m_userInfo.isSystemAdministrator();
        if(!checkPermissionForAltMax){
            checkPermissionForAltMax = m_userInfo.hasPermissionSet(PERMISSIONSET_ALTERNATE_MAX);
        }
        if(checkPermissionForAltMax){
            String numberAltMax = m_configs.Get(CONFIG_ALTERNATE_NUMBER_MAX);
            return Integer.valueOf(numberAltMax);
        }
        String numberMax = m_configs.Get(CONFIG_NUMBER_MAX);
        return Integer.valueOf(numberMax);
    }

    private List<AccountNumberGenerator.AccountDetail> BuildAccountDetails(List<string> accounts){
        Integer count = 1;
        List<AccountNumberGenerator.AccountDetail> AccountDetails = new List<AccountNumberGenerator.AccountDetail>();
        for(String a: accounts){
            AccountNumberGenerator.AccountDetail ad = new AccountNumberGenerator.AccountDetail();
            ad.Count = count;
            ad.AccountNumber = a;
            AccountDetails.add(ad);
            count++;
        }
        return AccountDetails;
    }

}