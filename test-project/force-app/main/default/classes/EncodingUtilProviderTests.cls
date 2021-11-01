@IsTest
private class EncodingUtilProviderTests {
	 private static final EncodingUtilProvider sut;
    
    static{
        sut = new EncodingUtilProvider();
    }

    private static testMethod void it_should_get_bytes_from_base64_content() {
    	Blob content = Blob.valueOf('base64-data');
    	String toBase64 = sut.toBase64(content);

    	Blob result = sut.fromBase64(toBase64);
    }

    private static testMethod void it_should_get_string_to_base64_content_when_bytes_Are_provided() {
    	Blob content = Blob.valueOf('test-data');

    	String result = sut.toBase64(content);
    }

    private static testMethod void it_should_get_bytes_when_string_data_is_provided() {
    	String content = 'test-data';

    	Blob result = sut.toBytes(content);
    }
}