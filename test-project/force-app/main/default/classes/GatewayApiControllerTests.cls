@isTest
private class GatewayApiControllerTests{
    private static final Mock.ofHttpCalloutMock m_mockCallout;
    
    static{        
        m_mockCallout = new Mock.ofHttpCalloutMock();        
    }
    
    @IsTest
    private static  void it_should_execute_a_get_callout(){        
        String apiName = 'MyApiUrl';
        String endPoint = '/myresource';
        HttpResponse response;
        response = new HttpResponse();
        response.setBody('test');
        response.setStatusCode(200);
        response.setStatus('OK');
        m_mockCallout.Setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(response);
        
        Test.setMock(HttpCalloutMock.class, m_mockCallout);        
        Test.startTest();
        GatewayApiController.get(apiName,endPoint,0);
        Test.stopTest();
        
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest)arguments[0];
        System.assertEquals('GET', calledRequest.getMethod());     
    }

    @IsTest
    private static void it_should_return_an_empty_string_when_the_callout_fails(){
        
        String apiName = 'MyApiUrl';
        String endPoint = '/myresource';
        HttpResponse response;
        response = new HttpResponse();
        response.setBody('test');
        response.setStatusCode(500);
        response.setStatus('FAIL');
        m_mockCallout.Setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(response);

        Test.setMock(HttpCalloutMock.class, m_mockCallout);         
        Test.startTest();
        String results = GatewayApiController.get(apiName,endPoint,0);
        Test.stopTest();
        
        System.assertEquals('', results);
    }

    @IsTest
    private static void it_should_post_and_call_the_rest_service(){
        
        String apiName = 'MyApiUrl';
        String endPoint = '/myresource';
        String postUrl = 'apiName-endPoint';
        String body = 'test';
        HttpResponse response;
        response = new HttpResponse();
        response.setBody(body);
        response.setStatusCode(500);
        response.setStatus('OK');
        m_mockCallout.Setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(response);

        Test.setMock(HttpCalloutMock.class, m_mockCallout);         
        Test.startTest();
        String results = GatewayApiController.post(postUrl,body);
        Test.stopTest();
        
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest)arguments[0];
        System.assertEquals('POST', calledRequest.getMethod());     
    }

    @IsTest
    private static void it_should_get_current_user_id_code_coverage() {
        String result = GatewayApiController.getCurrentUser();
        System.assertEquals(true, String.isNotBlank(result));
    }

    @IsTest
    private static void it_should_get_server_instance_info_code_coverage(){
        GatewayApiController.InstanceMetadata result = GatewayApiController.getInstanceInfo();
        System.assertEquals(true, String.isNotBlank(result.InstanceName));
    }

}