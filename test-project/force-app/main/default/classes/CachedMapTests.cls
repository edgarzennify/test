@isTest
public class CachedMapTests {
    private static final CachedMap.ICachedMap sut;

    static{
        sut = CachedMap.getInstance();
    }

    private class testObject {
        public String ObjectName {get;set;}
    }
    
    @isTest
    static void it_should_confirm_put_get_size_containsKey_and_values_function(){
    String testKey01 = '1234';
    testObject testObject01 = new testObject();
    testObject01.ObjectName = 'testName 01';
    String testKey02 = '4567';
    testObject testObject02 = new testObject();
    testObject02.ObjectName = 'testName 02';
    //act
    sut.put(testKey01, testObject01);
    sut.put(testKey02, testObject02);
    //assert
    System.assertEquals(testObject01, sut.get(testKey01));
    System.assertEquals(2,sut.size());
    System.assertEquals(true,sut.containsKey(testKey01));
    System.assertEquals(true,sut.containsKey(testKey02));
    System.assertEquals(new List<Object>{testObject01,testObject02},sut.values());    
    }

    @isTest
    static void it_should_remove_a_value_from_the_cache_map(){
    String testKey01 = '1234';
    testObject testObject01 = new testObject();
    testObject01.ObjectName = 'testName 01';
    String testKey02 = '4567';
    testObject testObject02 = new testObject();
    testObject02.ObjectName = 'testName 02';
    //act
    sut.put(testKey01, testObject01);
    sut.put(testKey02, testObject02);
    sut.remove(testKey01);
    //assert
    System.assertEquals(1, sut.size());
    System.assertEquals(true, sut.containsKey(testKey02));
    }

    @isTest
    static void it_should_clear_the_cache_map(){
    String testKey01 = '1234';
    testObject testObject01 = new testObject();
    testObject01.ObjectName = 'testName 01';
    String testKey02 = '4567';
    testObject testObject02 = new testObject();
    testObject02.ObjectName = 'testName 02';
    //act
    sut.put(testKey01, testObject01);
    sut.put(testKey02, testObject02);
    sut.clear();
    //assert
    System.assertEquals(0, sut.size());
    }

    @isTest
    static void it_should_keep_the_same_cacheMap_over_multiple_instance_calls(){
    String testKey01 = '1234';
    testObject testObject01 = new testObject();
    testObject01.ObjectName = 'testName 01';
    //act
    sut.put(testKey01, testObject01);
    
    CachedMap.ICachedMap sut2 = CachedMap.getInstance();
    //assert
    System.assertEquals(testObject01, sut.get(testKey01));
    System.assertEquals(testObject01, sut2.get(testKey01));
    }    
}