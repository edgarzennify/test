@isTest
public class IncrementAccountActionStatus_DPTest {
    
	private static final IncrementAccountActionActionStatus_DP sut;
    
    static{
        sut = new IncrementAccountActionActionStatus_DP();
    }
    
    @isTest
    public Static void testGetAccountAction(){
 		EB_Loan_Action__c LA01 = new EB_Loan_Action__c();
        LA01.Action_Status_Update__c = 1;
        LA01.On_Hold__c = false; 
        insert LA01; 
        String curId = [Select id from EB_Loan_Action__c Where Action_Status_Update__c = 1 LIMIT 1].id;
        //Act 
        EB_Loan_Action__c results = sut.getAccountAction(curId);
        //Assert
        System.assertEquals(LA01.Action_Status_Update__c,results.Action_Status_Update__c);
        System.assertEquals(LA01.On_Hold__c, results.On_Hold__c);
        System.assertEquals(curId, String.valueOf(results.Id));
    }
}