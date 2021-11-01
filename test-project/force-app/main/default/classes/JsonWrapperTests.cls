@IsTest
private class JsonWrapperTests {
    private static JsonWrapper sut;
    static {
        sut = new JsonWrapper();
    }
    
    @IsTest
    static void it_should_call_the_serialize() {
        DmEntity dm = new DmEntity();
        dm.Name = 'test';
        
        String result = sut.serialize(dm);
        
        System.assertEquals(true, result.contains('"Name":"test"'));
    }
    
    @IsTest
    static void it_should_call_the_serialize_pretty() {
        DmEntity dm = new DmEntity();
        dm.Name = 'test';
        
        String result = sut.serializePretty(dm);
        
        System.assertEquals(true, result.contains('test'));
    }
    
    @IsTest
    static void it_should_call_the_deserialize() {
        DmEntity result = (DmEntity)sut.deserialize('{"name":"test"}', DmEntity.class);
        
        System.assertEquals('test', result.Name);
    }
}