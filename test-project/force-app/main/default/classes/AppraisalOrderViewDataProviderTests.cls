@isTest
public class AppraisalOrderViewDataProviderTests {

    private static final AppraisalOrderViewDataProvider sut = new AppraisalOrderViewDataProvider();

    private static testMethod void it_should_get_an_appraisal_order_for_given_id() {
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Collateral_Code_ID__c = '63');
        insert testCollateralCode;
        EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
        insert testCollateral;
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c(Related_Collateral__c=testCollateral.Id, Is_SBA__c='No');
        insert testAppraisalOrder;

        EB_Appraisal_Order__c returnedAppraisalOrder = sut.getAppraisalOrderForId(testAppraisalOrder.Id);

		system.assertEquals('No', returnedAppraisalOrder.Is_SBA__c );      
    }

    private static testMethod void it_should_save_changes_to_an_existing_appraisalorder()
    {
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Collateral_Code_ID__c = '63');
        insert testCollateralCode;
        EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
        insert testCollateral;
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c(Is_SBA__c='No');
        testAppraisalOrder.Related_Collateral__r=testCollateral;
        insert testAppraisalOrder;
        EB_Appraisal_Order__c returnedAppraisalOrderPreChange = [SELECT Id,Is_SBA__c FROM EB_Appraisal_Order__c WHERE Id=: testAppraisalOrder.Id ];
        testAppraisalOrder.Is_SBA__c = 'Yes';

        sut.save(testAppraisalOrder);

        EB_Appraisal_Order__c returnedAppraisalOrder = [SELECT Id,Is_SBA__c FROM EB_Appraisal_Order__c WHERE Id=: testAppraisalOrder.Id ];
        system.assertEquals('No', returnedAppraisalOrderPreChange.Is_SBA__c );
        system.assertEquals('Yes', returnedAppraisalOrder.Is_SBA__c );
    }


    private static testMethod void it_should_insert_a_new_appraisalorder_if_Id_of_appraisalorder_given_is_null()
    {
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Collateral_Code_ID__c = '63');
        insert testCollateralCode;
        EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
        insert testCollateral;
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c();
        testAppraisalOrder.FDIC_Valuation_Type__c = 'FDICTest';
        testAppraisalOrder.Related_Collateral__r=testCollateral;

        sut.save(testAppraisalOrder);

        EB_Appraisal_Order__c returnedAppraisalOrder = [SELECT Id,FDIC_Valuation_Type__c FROM EB_Appraisal_Order__c WHERE FDIC_Valuation_Type__c='FDICTest' ];
        system.assertNotEquals(null, returnedAppraisalOrder.Id );
    }

    private static testMethod void it_should_update_OREO_fields_on_save() {
    	Account testAcct = ObjectFactory.getValidEntity('name');
    	EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Account','12345',testAcct);
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c();
        testAppraisalOrder.OREO_Account__c = ebAccount.Id;
        testAppraisalOrder.OREO_Account__r = ebAccount;
        testAppraisalOrder.FDIC_Valuation_Type__c = 'FDIC';
        testAppraisalOrder.Valuation_Date__c = Date.today();
        testAppraisalOrder.As_Completed_Value__c = 200;
        testAppraisalOrder.As_Is_Value__c = 100;
        testAppraisalOrder.As_Liquidated_Value__c = 150;
        testAppraisalOrder.As_Stabilized_Value__c = 175;
        testAppraisalOrder.Oasis_Order_Number__c = '1234';
        testAppraisalOrder.USPAP_Compliant__c = 'Yes';

        sut.save(testAppraisalOrder);

        EB_Account__c returnedOREO = [SELECT USPAP_Compliant__c, FDIC_Valuation_Type__c, Valuation_Date__c, As_Completed_Value__c, As_Is_Value__c, As_Liquidated_Value__c, As_Stabilized_Value__c, Oasis_Order_Number__c FROM EB_Account__c WHERE Id =: ebAccount.Id LIMIT 1];

        system.assertEquals('FDIC', returnedOREO.FDIC_Valuation_Type__c);
        system.assertEquals(Date.today(), returnedOREO.Valuation_Date__c);
        system.assertEquals(200, returnedOREO.As_Completed_Value__c);
        system.assertEquals(100, returnedOREO.As_Is_Value__c);
        system.assertEquals(150, returnedOREO.As_Liquidated_Value__c);
        system.assertEquals(175, returnedOREO.As_Stabilized_Value__c);
        system.assertEquals('1234', returnedOREO.Oasis_Order_Number__c);
        system.assertEquals('Yes', returnedOREO.USPAP_Compliant__c);
    }

    private static testMethod void it_should_update_collateral_fields_on_save() {
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Collateral_Code_ID__c = '63');
        insert testCollateralCode;
        EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
        insert testCollateral;
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c();
		testAppraisalOrder.Related_Collateral__r=testCollateral;
        testAppraisalOrder.FDIC_Valuation_Type__c = 'FDIC';
        testAppraisalOrder.Valuation_Date__c = Date.today();
        testAppraisalOrder.As_Completed_Value__c = 200;
        testAppraisalOrder.As_Is_Value__c = 100;
        testAppraisalOrder.As_Liquidated_Value__c = 150;
        testAppraisalOrder.As_Stabilized_Value__c = 175;
        testAppraisalOrder.Appraised_Value_reviewed__c = 165;
        testAppraisalOrder.Oasis_Order_Number__c = '1234';
        testAppraisalOrder.USPAP_Compliant__c = 'Yes';

        sut.save(testAppraisalOrder);

        EB_Collateral__c returnedCollat = [SELECT USPAP_Compliant__c, FDIC_Valuation_Type__c, Valuation_Date__c,Appraised_Value__c, As_Completed_Value__c, As_Is_Value__c, As_Liquidated_Value__c, As_Stabilized_Value__c, Oasis_Order_Number__c FROM EB_Collateral__c WHERE Id =: testCollateral.Id LIMIT 1];

        system.assertEquals('FDIC', returnedCollat.FDIC_Valuation_Type__c);
        system.assertEquals(Date.today(), returnedCollat.Valuation_Date__c);
        system.assertEquals(200, returnedCollat.As_Completed_Value__c);
        system.assertEquals(100, returnedCollat.As_Is_Value__c);
        system.assertEquals(150, returnedCollat.As_Liquidated_Value__c);
        system.assertEquals(175, returnedCollat.As_Stabilized_Value__c);
        system.assertEquals(165, returnedCollat.Appraised_Value__c);
        system.assertEquals('1234', returnedCollat.Oasis_Order_Number__c);
        system.assertEquals('Yes', returnedCollat.USPAP_Compliant__c);
    }
    private static testMethod void it_should_return_the_collateral_owner_from_collateral_client_rel_when_appraisal_order_is_pulled_from_order_with_collateral(){
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Collateral_Code_ID__c = 'CM');
        insert testCollateralCode;
        EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
        testCollateral.Collateral_Owner__c=null;
        insert testCollateral;
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        testEntity.EB_Client_Name__c='testOwner';
        update testEntity;
        EB_Collateral_Client_Relationship__c testCollAcctRel = new EB_Collateral_Client_Relationship__c(EB_Collateral_ID__c = testCollateral.Id, Client_ID__c=testEntity.Id);
        insert testCollAcctRel;

        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c();
        testAppraisalOrder.Related_Collateral__c=testCollateral.Id;
        insert testAppraisalOrder;

        String returnResult = sut.collateralOwner(testAppraisalOrder);
      
        System.assertEquals('testOwner',returnResult);
    }
    private static testMethod void it_should_return_the_collateral_owner_from_collateral_when_appraisal_order_is_pulled_from_order_with_collateral(){
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Collateral_Code_ID__c = 'CM');
        insert testCollateralCode;
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode, Collateral_Owner__c = testEntity.Id, Collateral_Owner__r=testEntity);
        insert testCollateral;
       
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c();
        testAppraisalOrder.Related_Collateral__r = testCollateral;
        testAppraisalOrder.Related_Collateral__c = testCollateral.Id;
        insert testAppraisalOrder;

        String returnResult = sut.collateralOwner(testAppraisalOrder);

        System.assertEquals('testEntity',returnResult);
    }
    private static testMethod void it_should_return_empty_collateral_owner_when_appraisal_order_is_pulled_from_order_with_oreo(){
        EB_Account__c oreo = new EB_Account__c();       
        insert oreo;
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c();
        testAppraisalOrder.OREO_Account__c = oreo.Id;
        insert testAppraisalOrder;

        String returnResult = sut.collateralOwner(testAppraisalOrder);

        System.assertEquals('',returnResult);
    }
	private static testMethod void it_should_return_expected_fields_in_SOQL_for_getAppraisalOrderForId() {
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c(Is_SBA__c='No');
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Collateral_Code_ID__c = '63');
        insert testCollateralCode;
        EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
        insert testCollateral;
        testAppraisalOrder.Related_Collateral__r=testCollateral;
        insert testAppraisalOrder;

		EB_Appraisal_Order__c returnResult = sut.getAppraisalOrderForId(testAppraisalOrder.Id);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Name;
		wasFieldInSOQL = returnResult.OREO_Account__c;
		wasFieldInSOQL = returnResult.Order_Type__c;
		wasFieldInSOQL = returnResult.Date_Appraisal_Needed__c;
		wasFieldInSOQL = returnResult.Last_Appraisal_Date__c;
		wasFieldInSOQL = returnResult.Last_Appraisal_Company__c;
		wasFieldInSOQL = returnResult.Is_SBA__c;
		wasFieldInSOQL = returnResult.Relationship_Manager__r.Name;
		wasFieldInSOQL = returnResult.Loan_Coordinator__r.Name;
		wasFieldInSOQL = returnResult.Relationship_Manager__c;
		wasFieldInSOQL = returnResult.Loan_Coordinator__c;
		wasFieldInSOQL = returnResult.Related_Entities_to_Be_Addressed__c;
		wasFieldInSOQL = returnResult.Is_Forclosure_or_OREO__c;
		wasFieldInSOQL = returnResult.Property_Ownership__c;
		wasFieldInSOQL = returnResult.Details_Related_to_Subject__c;
		wasFieldInSOQL = returnResult.Special_Instructions_to_Bank_Officer__c;
		wasFieldInSOQL = returnResult.Loan_Exceeds_2M__c;
		wasFieldInSOQL = returnResult.Will_RM_Seek_Waiver__c;
		wasFieldInSOQL = returnResult.Related_Collateral__c;
		wasFieldInSOQL = returnResult.Related_Collateral__r.Appraisal_Order_Summary__c;
		wasFieldInSOQL = returnResult.OREO_Account__r.Appraisal_Order_Summary__c;
		wasFieldInSOQL = returnResult.Related_Collateral__r.Collateral_Owner__r.Name;
		wasFieldInSOQL = returnResult.Related_Collateral__r.Address__c;
		wasFieldInSOQL = returnResult.Related_Collateral__r.Zip_Code__c;
		wasFieldInSOQL = returnResult.Related_Collateral__r.City__c;
		wasFieldInSOQL = returnResult.Related_Collateral__r.State__c;
		wasFieldInSOQL = returnResult.Related_Collateral__r.EB_Appraisal_County__r.Name;
		wasFieldInSOQL = returnResult.Related_Collateral__r.Inspection_Contact_Name__c;
		wasFieldInSOQL = returnResult.Related_Collateral__r.Inspection_Contact_Phone__c;
		wasFieldInSOQL = returnResult.Related_Collateral__r.Inspection_Contact_Sec_Phone__c;
		wasFieldInSOQL = returnResult.Related_Collateral__r.Inspection_Contact_Email_Address__c;
        wasFieldInSOQL = returnResult.OREO_Account__r.Inspection_Contact_Name__c;
        wasFieldInSOQL = returnResult.OREO_Account__r.Inspection_Contact_Phone__c;
        wasFieldInSOQL = returnResult.OREO_Account__r.Inspection_Contact_Sec_Phone__c;
        wasFieldInSOQL = returnResult.OREO_Account__r.Inspection_Contact_Email_Address__c;
		wasFieldInSOQL = returnResult.As_Completed_Value__c;
		wasFieldInSOQL = returnResult.As_Is_Value__c;
		wasFieldInSOQL = returnResult.As_Liquidated_Value__c;
		wasFieldInSOQL = returnResult.As_Stabilized_Value__c;
		wasFieldInSOQL = returnResult.Oasis_Order_Number__c;
		wasFieldInSOQL = returnResult.Related_Collateral__r.Collateral_Code__r.Name;
		wasFieldInSOQL = returnResult.OREO_Account__r.OREO_Address__c;
		wasFieldInSOQL = returnResult.OREO_Account__r.OREO_Collateral_Code__r.Name;
        wasFieldInSOQL = returnResult.Appraisal_Company_Used__c;
        wasFieldInSOQL = returnResult.Reference__c;
        wasFieldInSOQL = returnResult.RM_Reviewed_OK_to_Order__c;
        wasFieldInSOQL = returnResult.USPAP_Compliant__c;
        wasFieldInSOQL = returnResult.Estimated_Closing_Date__c;
	}
}