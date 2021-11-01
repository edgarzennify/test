public class AccountNumberServiceProxy implements IAccountNumberService {
    public interface IAccountNumberService{
        AccountNumberSvcResponse getNewAccountNumber(String cardNumberUrl);
        AccountNumbersSvcResponse getNewAccountNumbers(String cardNumberUrl, Integer numberOfAccounts);
    }
    
    private final String SERVICE_API_NAME = 'NumberGeneratorUrl';
    
    private final Webservices.IRestService m_restService;
    private final IJson m_json;

    public AccountNumberServiceProxy(Webservices.IRestService restService, IJson json) {
        m_restService = restService;
        m_json = json;
    }
    
    public AccountNumberSvcResponse getNewAccountNumber(String cardNumberIdentifier) {
        AccountNumbersSvcResponse resAll = getNewAccountNumbers(cardNumberIdentifier, 1);
        AccountNumberSvcResponse res = new AccountNumberSvcResponse();
        if(resAll == null || resAll.AccountNumbers == null) return res;
        res.AccountNumber = resAll.AccountNumbers[0];
        return res;
    }

    public AccountNumbersSvcResponse getNewAccountNumbers(String cardNumberIdentifier, Integer numberOfAccounts) {
        String resource = String.Format('/generate?accounttype={0}&count={1}', new List<string>{cardNumberIdentifier,String.valueof(numberOfAccounts)});
        Map<string,string> headers = new Map<string,string>();
        headers.put('User', UserInfo.getName());
        headers.put('Source', 'Salesforce');
        RESTUtility.result result = m_restService.GET(SERVICE_API_NAME, resource, headers);
        if(result == null || result.response == null) return new AccountNumbersSvcResponse();
        return (AccountNumbersSvcResponse)m_json.deserialize(result.response, AccountNumbersSvcResponse.Class);
        //return TestNumbers(numberOfAccounts);
    }
    
    public class AccountNumberSvcResponse {
        public string AccountNumber{get;set;}
    }

    public class AccountNumbersSvcResponse {
        public List<string> AccountNumbers{get;set;}
    }

    private AccountNumbersSvcResponse TestNumbers(Integer numberOfAccounts){
        AccountNumbersSvcResponse asr = new AccountNumbersSvcResponse();
        asr.AccountNumbers = new List<string>();
        for(Integer i = 0; i<numberOfAccounts;i++){
            asr.AccountNumbers.add('100000'+ String.valueOf(i));
        }
        return asr;
    }
}