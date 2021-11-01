@IsTest
private class TmBoardingAccountProviderTests {
	
    private static TmBoardingAccountProvider sut;
    private static final TmBoardingMock.ofIDataProvider mockDataProvider;
    private static final Mock.ofIAccountNumberServiceProxy mockAccountNumberProxy;
    
    static {
        mockDataProvider = new TmBoardingMock.ofIDataProvider();
        mockAccountNumberProxy = new Mock.ofIAccountNumberServiceProxy();
        sut = new TmBoardingAccountProvider(mockDataProvider, mockAccountNumberProxy);
    }
    
    @IsTest
    static void it_should_build_a_search_account_results() {
        String searchParam = '1234';
        Eb_Account__c eba = new Eb_Account__c(Account_Line_1__c = 'test');
        mockdataProvider.setup('getEbAccountSearchResults', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<Eb_Account__c>{eba});
        
        List<TmBoarding.AccountSearchResult> result = sut.searchAccount(searchParam);
            
        mockDataProvider.verify('getEbAccountSearchResults', new List<OBject>{'%1234%'}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_account_number_proxy_to_generate_new_tm_number() {   
        String ACCOUNT_TM_GENERATE_KEY = 'TMOperatingAccount';

        TmBoarding.AccountGeneratorResult result = sut.generateNewTmAccountNumber();

        mockAccountNumberProxy.verify('getNewAccountNumber' , new List<Object>{ACCOUNT_TM_GENERATE_KEY}, Times.Once);   
    }

    @IsTest
    static void it_should_call_the_account_number_proxy_to_generate_new_number() {   
        String ACCOUNT_TM_GENERATE_KEY = 'TMOperatingAccount';

        TmBoarding.AccountGeneratorResult result = sut.generateNewAccountNumber(ACCOUNT_TM_GENERATE_KEY);

        mockAccountNumberProxy.verify('getNewAccountNumber' , new List<Object>{ACCOUNT_TM_GENERATE_KEY}, Times.Once);   
    }
}