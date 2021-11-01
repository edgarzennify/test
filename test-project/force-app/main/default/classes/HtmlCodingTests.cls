@IsTest
private class HtmlCodingTests {
    
    private static final HtmlCoding sut;
    static {
        sut = new HtmlCoding();
    }

    private static testMethod void it_should_html_decode(){
        string encodedText = '&lt;test';

        String result = sut.unEscape(encodedText);

        System.AssertEquals('<test' , result);
    }

    private static testMethod void it_should_html_encode(){
        string decodeText1 = '<test';
         string decodeText2 = 'test>';
          string decodeText3 = '&test';

        String result1 = sut.httpRequestSanitizer(decodeText1);
        String result2 = sut.httpRequestSanitizer(decodeText2);
        String result3 = sut.httpRequestSanitizer(decodeText3);

        System.AssertEquals('&lt;test' , result1);
        System.AssertEquals('test&gt;' , result2);
        System.AssertEquals('&amp;test' , result3);
    }
}