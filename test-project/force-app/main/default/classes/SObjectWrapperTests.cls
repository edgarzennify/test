@IsTest
private class SObjectWrapperTests {
    
    private static final SObjectWrapper sut;

    static {
        sut = new SObjectWrapper();
    }

    @IsTest
    static void code_coverage_for_addError() {
        String errorMessage = 'test error';
        SObject testSObject = new Account(Name='test name');

        sut.addError(testSObject, errorMessage);      
    }
}