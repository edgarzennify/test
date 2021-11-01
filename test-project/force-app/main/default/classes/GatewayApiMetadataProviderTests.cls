@IsTest
private class GatewayApiMetadataProviderTests
{
    private static final GatewayApiMetadataProvider sut = new GatewayApiMetadataProvider();
    
    private static testMethod void it_should_get_a_list_of_gateway_apis()
    {    

        Map<string, DmGateway> result = sut.GetAll();
        
        System.AssertEquals(true , result.size() > 0);
       
    }
    
    private static testMethod void it_should_find_NumberGeneratorUrl_in_gateway_apis()
    {
        List<DmGateway> dms= sut.GetAll().values();
        DmGateway dm = dms[0];
        
        String result = sut.GetResourceBy(dm.Name);
        
        System.AssertEquals(true , String.isNotBlank(dm.Name));
        System.AssertEquals(true , String.isNotBlank(dm.Resource));
        System.AssertEquals(dm.Resource , result);
    }
}