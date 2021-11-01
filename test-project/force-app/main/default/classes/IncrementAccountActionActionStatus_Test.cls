@IsTest
private class IncrementAccountActionActionStatus_Test {

	private static final IncrementAccountActionActionStatusUpdate sut;
    private static final MockOfIDataProvider mockDataProvider;
    private static final Mock.ofIApexPages mockApexPages;    
    
    static {
        mockDataProvider = new MockOfIDataProvider();
        mockApexPages = new Mock.ofIApexPages();        
        sut = new IncrementAccountActionActionStatusUpdate(mockDataProvider, mockApexPages);
    }
    
    @IsTest
    static void it_should_save_the_retrieved_account_action_with_the_update_action_status_field_set_to_0() {
        String testId = '001abcdefghijklm';        
        EB_Loan_Action__c action1 = new EB_Loan_Action__c();
        action1.On_Hold__c = false;
        action1.Action_Status_Update__c = null;
        mockApexPages.setup('getParameter', new List<Object>{'id'}).returns(testId);  
        mockDataProvider.setup('getAccountAction', new List<Object>{testId}).returns(action1);
        
        PageReference results = sut.IncrementActionStatusUpdate();
        
        List<Object> calledSaveParams = mockDataProvider.getArgumentsFromCall('save');
        EB_Loan_Action__c calledAction = (EB_Loan_Action__c)calledSaveParams[0];
        System.assertEquals(0, calledAction.Action_Status_Update__c);
    }
    
    @IsTest
    static void it_should_save_the_retrieved_account_action_with_the_update_action_status_field_set_to_2_when_starting_at_1() {
        String testId = '001abcdefghijklm';        
        EB_Loan_Action__c action1 = new EB_Loan_Action__c();
        action1.On_Hold__c = false;
        action1.Action_Status_Update__c = 1;
        mockApexPages.setup('getParameter', new List<Object>{'id'}).returns(testId);  
        mockDataProvider.setup('getAccountAction', new List<Object>{testId}).returns(action1);
        
        PageReference results = sut.IncrementActionStatusUpdate();
        
        List<Object> calledSaveParams = mockDataProvider.getArgumentsFromCall('save');
        EB_Loan_Action__c calledAction = (EB_Loan_Action__c)calledSaveParams[0];
        System.assertEquals(2, calledAction.Action_Status_Update__c);
    }
    
    @IsTest
    static void it_should_not_save_the_retrieved_account_action_when_on_hold() {
        String testId = '001abcdefghijklm';        
        EB_Loan_Action__c action1 = new EB_Loan_Action__c();
        action1.On_Hold__c = true;
        action1.Action_Status_Update__c = 1;
        mockApexPages.setup('getParameter', new List<Object>{'id'}).returns(testId);  
        mockDataProvider.setup('getAccountAction', new List<Object>{testId}).returns(action1);
        
        PageReference results = sut.IncrementActionStatusUpdate();
        
        mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
    }
    
    @IsTest
    static void it_should_return_the_correct_page_reference() {
	    String testId = 'a0XK0000006aummMAA';
        EB_Loan_Action__c testAA = new EB_Loan_Action__c();		
        mockApexPages.setup('getParameter', new List<Object>{'id'}).returns(testId);          
        mockDataProvider.setup('getAccountAction', new List<Object>{testId}).returns(testAA);        
        
        PageReference results = sut.IncrementActionStatusUpdate();
        
        System.assertEquals('/a0XK0000006aummMAA', results.getURL());
    }
    
    @IsTest
    static void code_coverage_call_the_default_constructor() {
		IncrementAccountActionActionStatusUpdate code_coverage = new IncrementAccountActionActionStatusUpdate();
    }   

    public class MockOfIDataProvider extends Mock.ofIDataProvider implements IncrementAccountActionActionStatusUpdate.IupdateActionStatusDataProvider {
        public EB_Loan_Action__c getAccountAction(String currentId) {
            return (EB_Loan_Action__c)handleMethodInvocation('getAccountAction', new List<Object>{currentId});
        }
    }
}