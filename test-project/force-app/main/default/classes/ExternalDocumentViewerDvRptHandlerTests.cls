@IsTest
private class ExternalDocumentViewerDvRptHandlerTests {
    private static ExternalDocumentViewerDvRptHandler sut;
    
    static{
        sut = new ExternalDocumentViewerDvRptHandler();
    }

    @IsTest
    private static void it_should_get_the_handler_identifier(){

        string result =  sut.handle();

        System.assertEquals('docid', result);
    }

    @IsTest
    private static void it_should_call_the_helper_to_get_template_data(){
        Map<string, string> parameters = new Map<string, string>{'docid' => 'aacc1234'};

        DmDocument result = sut.buildDocument(parameters);

        System.assertEquals('aacc1234', result.Id);
    }  
}