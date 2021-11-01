@isTest
public class LLCBI_ProductPackageFactoryDataProvTests {
    private static LLCBI_ProductPackageFactoryDataProvider sut;
    static{
        sut = new LLCBI_ProductPackageFactoryDataProvider();
    }
    private static testMethod void it_should_call_getProductPackages_with_a_list_of_package_ids_and_return_a_list_of_product_packages(){
        List<User> levelAUsers = [SELECT Id FROM User WHERE Level_A_Approver__c = true AND isActive = true LIMIT 3];
        User firstApprover = levelAUsers[0];
        User secondApprover = levelAUsers[1];
        User thirdApprover = levelAUsers[2];
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.LLC_BI__TCE__c = 100000;
        pack.First_Approver__c = firstApprover.Id;
        pack.Second_Approver__c = secondApprover.Id;
        pack.Third_Approver__c = thirdApprover.Id;
        pack.Channel__c = 'Business Banking';
        pack.New_Money_Renewal__c = 'New Money';
        pack.New_Money_Amt__c = 10000;
        pack.PASS_Recommendation__c = 'Approve';
        pack.Contains_Policy_Exceptions__c = false;
        insert pack;
        
        Set<Id> packageIds = new Set<Id>{pack.Id};
		
        List<LLC_BI__Product_Package__c> results = sut.getProductPackages(packageIds);
        system.assertEquals(pack.Id, results[0].Id);
        system.assertEquals(pack.LLC_BI__TCE__c, results[0].LLC_BI__TCE__c);
        system.assertEquals(pack.First_Approver__c, results[0].First_Approver__c);
        system.assertNotEquals(null, results[0].Second_Approver__c);
        system.assertEquals(pack.Third_Approver__c, results[0].Third_Approver__c);
        system.assertEquals(pack.Channel__c, results[0].Channel__c);
        system.assertEquals(pack.New_Money_Renewal__c, results[0].New_Money_Renewal__c);
        system.assertEquals(pack.PASS_Recommendation__c, results[0].PASS_Recommendation__c);
        system.assertEquals(pack.Contains_Policy_Exceptions__c, results[0].Contains_Policy_Exceptions__c);
        system.assertEquals(pack.Material_Exceptions_Approval_Required__c, results[0].Material_Exceptions_Approval_Required__c);
        
    }
    private static testMethod void it_should_call_getLoansRelatedToPackages_with_a_list_of_package_ids_and_return_a_list_of_loans(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.LLC_BI__TCE__c = 100000;
        insert pack;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = pack.Id;
        loan.LLC_BI__Product_Package__r = pack;
        loan.Underwriting_Complete__c = false;
        loan.LLC_BI__Stage__c = 'Credit Request';
        loan.LLC_BI__Structure_Hierarchy__c = 'Current Takedown';
        insert loan;
        Set<Id> packageIds = new Set<Id>{pack.Id};
		
        List<LLC_BI__Loan__c> results = sut.getLoansRelatedToPackages(packageIds);
        
        system.assertEquals(loan.Id, results[0].Id);
        system.assertEquals(loan.LLC_BI__Product_Package__c, results[0].LLC_BI__Product_Package__c);
        system.assertEquals(loan.Underwriting_Complete__c, results[0].Underwriting_Complete__c);
        system.assertEquals(loan.LLC_BI__Stage__c, results[0].LLC_BI__Stage__c);
        system.assertEquals(loan.LLC_BI__Structure_Hierarchy__c, results[0].LLC_BI__Structure_Hierarchy__c);
    }

}