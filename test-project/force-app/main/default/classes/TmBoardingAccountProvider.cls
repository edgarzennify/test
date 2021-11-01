public class TmBoardingAccountProvider implements TmBoarding.IAccountProvider{

	private final String ACCOUNT_TM_GENERATE_KEY = 'TMOperatingAccount';

	private final TmBoarding.IDataProvider m_dataProvider;
	private final AccountNumberServiceProxy.IAccountNumberService m_accountNumberSvc;

	public TmBoardingAccountProvider(TmBoarding.IDataProvider dataProvider, AccountNumberServiceProxy.IAccountNumberService accountNumberSvc) {
		m_dataProvider = dataProvider;
		m_accountNumberSvc = accountNumberSvc;
	}

	public TmBoarding.AccountGeneratorResult generateNewTmAccountNumber(){
		AccountNumberServiceProxy.AccountNumberSvcResponse res = m_accountNumberSvc.getNewAccountNumber(ACCOUNT_TM_GENERATE_KEY);
		TmBoarding.AccountGeneratorResult result = new TmBoarding.AccountGeneratorResult();
		if(res != null) {	
			result.AccountNumber = res.AccountNumber;
			result.Errors = new List<String>();
		}
        return result;
	}

	public TmBoarding.AccountGeneratorResult generateNewAccountNumber(String apiResourceKey){
		AccountNumberServiceProxy.AccountNumberSvcResponse res = m_accountNumberSvc.getNewAccountNumber(apiResourceKey);
		TmBoarding.AccountGeneratorResult result = new TmBoarding.AccountGeneratorResult();
		if(res != null) {	
			result.AccountNumber = res.AccountNumber;
			result.Errors = new List<String>();
		}
        return result;
	}

	public List<TmBoarding.AccountSearchResult> searchAccount(String searchParam) {
		String param = cleanParameter(searchParam);
		List<Eb_Account__c> ebAccounts = m_dataProvider.getEbAccountSearchResults(param);

		return buildSearchResult(ebAccounts);
	}

	private List<TmBoarding.AccountSearchResult> buildSearchResult(List<Eb_Account__c> ebAccounts) {
		List<TmBoarding.AccountSearchResult> result = new List<TmBoarding.AccountSearchResult>();
		if(ebAccounts == null || ebAccounts.size() == 0) {return result;}

		for(Eb_Account__c a : ebAccounts) {
			TmBoarding.AccountSearchResult r = new TmBoarding.AccountSearchResult();
			r.id = a.Id;
			r.name = String.isBlank(a.Account_Line_1__c) ? '':a.Account_Line_1__c;
			r.accountNumber = a.Name;
			String line2 = String.isBlank(a.Account_Line_2__c) ? '':a.Account_Line_2__c;
			String line3 = String.isBlank(a.Account_Line_3__c) ? '':a.Account_Line_3__c;
			r.address = String.format('{0},{1}', new LIST<String>{line2, line3});
			r.entity = a.Primary_Owner_Id__r ==null ? '' : a.Primary_Owner_Id__r.Name;
			result.add(r);
		}

		return result;
	}

	private String cleanParameter(String searchTerm) {
		if(String.isBlank(searchTerm)){return '';}
		searchTerm = searchTerm.replace('*', ' ');                      
        searchTerm = searchTerm.trim();
        searchTerm = searchTerm.replace('  ', ' ');
        searchTerm = searchTerm.replace('  ', ' ');
        searchTerm = searchTerm.replace('- 2', '');
        searchTerm = searchTerm.replace('-2', '');
        searchTerm = searchTerm.replace(' ', '%');
        searchTerm = '%' + searchTerm + '%';
        if(searchTerm == '%%') return '';

        return searchTerm; 
	}
}