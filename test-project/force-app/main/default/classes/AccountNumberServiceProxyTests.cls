@IsTest
private class AccountNumberServiceProxyTests {
	
    private static AccountNumberServiceProxy sut;
    private static Mock.ofIRestService mockRestService;
    private static Mock.ofIJson mockJson;
    
    static {
        mockRestService = new Mock.ofIRestService();
        mockJson = new Mock.ofIJson();
        sut = new AccountNumberServiceProxy(mockRestService, mockJson);
    }
    
    @IsTest
    static void it_should_call_the_rest_service_to_get_a_new_account_number_when_url_is_provided() {
        String service_key = 'NumberGeneratorUrl';
        String url = 'some-card-number';
        String resource = String.Format('/generate?accounttype={0}&count={1}', new List<string>{url,String.valueof(1)});
        Map<string, string> headers = new Map<string,string>();
        headers.put('User', UserInfo.getName());
        headers.put('Source', 'Salesforce');
        RestUtility.result r = new RestUtility.result();
        AccountNumberServiceProxy.AccountNumbersSvcResponse res = new AccountNumberServiceProxy.AccountNumbersSvcResponse();
        mockRestService.setup('GET', new List<Object>{service_key, resource}).returns(r);
        mockJson.setup('deserialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(res);

        AccountNumberServiceProxy.AccountNumberSvcResponse result = sut.getNewAccountNumber(url);
        
        mockRestService.verify('GET', new List<Object>{service_key, resource, headers}, Times.Once);
    }

    @IsTest
    static void code_coverage() {
        AccountNumberServiceProxy.AccountNumberSvcResponse obj = new AccountNumberServiceProxy.AccountNumberSvcResponse();
        obj.AccountNumber = '1-2-3-4';
    }
}