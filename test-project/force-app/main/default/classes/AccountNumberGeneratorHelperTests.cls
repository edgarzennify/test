@IsTest
private class AccountNumberGeneratorHelperTests {
    private static Mock.ofIAccountNumberServiceProxy mockProxy;
    private static Mock.ofIUserInfoService mockUserInfo;
    private static Mock.ofIConfigurations mockConfigurations;
    private static Mock.ofIEncodingUtil mockEcodingUtil;
    private static AccountNumberGeneratorHelper sut;

    static{
        mockProxy = new Mock.ofIAccountNumberServiceProxy();
        mockUserInfo = new Mock.ofIUserInfoService();
        mockConfigurations = new Mock.ofIConfigurations();
        mockEcodingUtil = new Mock.ofIEncodingUtil();
        sut = new AccountNumberGeneratorHelper(mockProxy, mockUserInfo, mockConfigurations, mockEcodingUtil);
    }

     @IsTest
    private static void it_should_call_the_proxy_to_generate_one_account_number(){

        String cardId = 'x';
        AccountNumberServiceProxy.AccountNumberSvcResponse res = new AccountNumberServiceProxy.AccountNumberSvcResponse();
        res.AccountNumber = '1234';
        mockProxy.setup('getNewAccountNumber', new List<Object>{cardId}).returns(res);
        mockUserInfo.setup('isSystemAdministrator').returns(true);
        mockConfigurations.setup('Get', new List<object>{'NumberGeneratorAlternateMax'}).returns('2');

        AccountNumberGenerator.AccountSvcDetail result = sut.getNewAccountNumber(cardId, 1);

        System.assertEquals('1234' ,result.AccountNumbers[0]);
    }

    @IsTest
    private static void it_should_call_the_proxy_to_generate_two_account_number(){
        String cardId = 'x';
        AccountNumberServiceProxy.AccountNumbersSvcResponse res = new AccountNumberServiceProxy.AccountNumbersSvcResponse();
        res.AccountNumbers = new List<string>{'1234','3333'};
        mockProxy.setup('getNewAccountNumbers', new List<Object>{cardId,2}).returns(res);
        mockUserInfo.setup('isSystemAdministrator').returns(true);
        mockConfigurations.setup('Get', new List<object>{'NumberGeneratorAlternateMax'}).returns('2');

        AccountNumberGenerator.AccountSvcDetail result = sut.getNewAccountNumber(cardId, 2);

        System.assertEquals('1234' ,result.AccountNumbers[0]);
        System.assertEquals('3333' ,result.AccountNumbers[1]);
    }

    @IsTest
    private static void it_should_get_base64_cdv_lines_by_calling_encoding_util(){
        List<string> lines = new List<String>{'1111'};
        Blob b = Blob.valueof('1111\r\n');

        string result = sut.getBlobLineItems(lines);

        mockEcodingUtil.verify('toBase64', new List<object>{b}, Times.Once);
    }

    @IsTest 
    private static void it_should_get_alternate_max_number_when_admin(){
        mockUserInfo.setup('isSystemAdministrator').returns(true);
        mockConfigurations.setup('Get',new List<Object>{'NumberGeneratorAlternateMax'}).returns('90');

        Integer result = sut.getNumberGeneratorMax();

        System.assertEquals(90,result);
    }

    @IsTest 
    private static void it_should_get_alternate_max_number_when_has_permission(){
        mockUserInfo.setup('isSystemAdministrator').returns(false);
        mockUserInfo.setup('hasPermissionSet', new List<object>{'Function - Generate Account Number Alternate Max'}).returns(true);
        mockConfigurations.setup('Get',new List<Object>{'NumberGeneratorAlternateMax'}).returns('90');

        Integer result = sut.getNumberGeneratorMax();

        System.assertEquals(90,result);
    }

    @IsTest 
    private static void it_should_get_max_number_when_has_permission(){
        mockUserInfo.setup('isSystemAdministrator').returns(false);
        mockUserInfo.setup('hasPermissionSet', new List<object>{'Function - Generate Account Number Alternate Max'}).returns(false);
        mockConfigurations.setup('Get',new List<Object>{'NumberGeneratorMax'}).returns('10');

        Integer result = sut.getNumberGeneratorMax();

        System.assertEquals(10,result);
    }
}