@isTest
public class ProductPackageApprovalPathCalculatorTest {
    private static final ProductPackageApprovalPathCalculator sut;
    static{
        sut = new ProductPackageApprovalPathCalculator();
    }
    
    private static testMethod void it_should_change_the_approval_from_2_sig_to_3_sig_if_the_loan_meets_commercial_2_sig_criteria_but_material_exceptions_is_true(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Commercial Banking';
        pack.Risk_Rating_Num__c = 6;
        pack.LLC_BI__TCE__c = 550000;
        pack.Material_Exceptions_Approval_Required__c = true;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('3 Signature', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_change_the_approval_from_3_sig_to_rlc_if_the_loan_meets_commercial_3_sig_criteria_but_material_exceptions_is_true(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Commercial Banking';
        pack.LLC_BI__TCE__c = 4000000;
        pack.Risk_Rating_Num__c = 6;
        pack.Material_Exceptions_Approval_Required__c = true;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('RLC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_change_the_approval_from_rlc_to_elc_if_the_loan_meets_commercial_rlc_criteria_but_material_exceptions_is_true(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Commercial Banking';
        pack.LLC_BI__TCE__c = 7000000;
        pack.Risk_Rating_Num__c = 6;
        pack.Material_Exceptions_Approval_Required__c = true;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature + ELC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_not_change_the_approval_from_elc_if_the_loan_meets_commercial_elc_criteria_and_material_exceptions_is_true_as_there_is_nowhere_to_go_up_from_elc(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Commercial Banking';
        pack.LLC_BI__TCE__c = 15500000;
        pack.Risk_Rating_Num__c = 6;
        pack = (LLC_BI__Product_Package__c)setFormulaField(pack, 'Officer_Region__c', 'STL');
        pack.Material_Exceptions_Approval_Required__c = true;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature + ELC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_reg_o_loans_if_the_package_contains_reg_o_loans(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Package_Contains_Reg_O_Loans__c = true;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Reg-O Loan(s)', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_takedown_approval_if_the_package_is_ready(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Ready_for_Takedown_Approval__c = true;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Takedown Approval - RM Only', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_admin_renewal_if_the_package_contains_any(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.IsAdminRenewal__c = true;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Admin Renewal', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_employee_loans_if_the_package_contains_any(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Contains_Employee_Loans__c = true;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Employee Loan(s)', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_10_percent_rule_if_the_override_is_applied(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Apply_10_Rule_Override__c = true;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('10% Rule', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_2_signature_when_the_number_of_committee_approved_modifications_matches_the_facilities_count(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 1;
        pack.LLC_BI__Loan_Facilities_Count__c = 1;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_2_signature_when_bb_tce_is_less_than_or_equal_to_150000_and_there_are_policy_exceptions(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Contains_Policy_Exceptions__c = true;
        pack.Channel__c = 'Business Banking';
        pack.LLC_BI__TCE__c = 50000;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_2_signature_when_a_new_money_bb_package_has_a_tce_higher_than_150000_and_less_or_equal_than_500000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Business Banking';
        pack.New_Money_Renewal__c = 'New Money';
        pack.LLC_BI__TCE__c = 450000;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_2_signature_when_commercial_banking_channel_tce_less_than_3000000_and_risk_rating_less_than_7(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Commercial Banking';
        pack.Risk_Rating_Num__c = 6;
        pack.LLC_BI__TCE__c = 550000;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_2_signature_when_consumer_banking_less_than_or_equal_to_7000000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Consumer Banking';
        pack.Risk_Rating_Num__c = 6;
        pack.LLC_BI__TCE__c = 550000;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_2_signature_when_private_banking_less_than_or_equal_to_7000000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Private Banking';
        pack.Risk_Rating_Num__c = 6;
        pack.LLC_BI__TCE__c = 550000;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_not_set_the_recommended_approval_path_to_2_signature_if_no_channel_and_tce_provided(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('No Approval Path Found', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_3_signature_when_bb_new_money_over_500000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Business Banking';
        pack.New_Money_Renewal__c = 'New Money';
        pack.LLC_BI__TCE__c = 550000;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('3 Signature', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_3_signature_when_commercial_banking_over_3000000_and_under_5000000_with_risk_rating_under_7(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Commercial Banking';
        pack.LLC_BI__TCE__c = 4000000;
        pack.Risk_Rating_Num__c = 6;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('3 Signature', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_RLC_when_commercial_banking_over_5000000_and_under_10000000_with_risk_rating_under_7(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Commercial Banking';
        pack.LLC_BI__TCE__c = 7000000;
        pack.Risk_Rating_Num__c = 6;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('RLC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_RMG_2_sig_when_rmg_channel_less_than_or_equal_to_750000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Resolution Management Group (RMG)';
        pack.LLC_BI__TCE__c = 750000;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('RMG 2 Sig', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_RMG_3_sig_when_rmg_channel_over_750000_and_less_than_or_equal_to_4000000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Resolution Management Group (RMG)';
        pack.LLC_BI__TCE__c = 1000000;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('RMG 3 Sig', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_RMG_PLC_when_rmg_channel_over_4000000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Resolution Management Group (RMG)';
        pack.LLC_BI__TCE__c = 5000000;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('RMG PLC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_non_rmg_plc_when_non_rmg_channel_has_risk_rating_higher_than_6(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Commercial Banking';
        pack.Risk_Rating_Num__c = 7;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Non-RMG PLC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_elc_when_non_ca_commercial_banking_tce_over_15000000_and_risk_rating_is_under_7(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Commercial Banking';
        pack.LLC_BI__TCE__c = 15500000;
        pack.Risk_Rating_Num__c = 6;
        pack = (LLC_BI__Product_Package__c)setFormulaField(pack, 'Officer_Region__c', 'STL');
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature + ELC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_rlc_when_ca_commercial_banking_tce_over_15000000_and_risk_rating_is_under_7(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Commercial Banking';
        pack.LLC_BI__TCE__c = 5500000;
        pack.Risk_Rating_Num__c = 6;
        pack = (LLC_BI__Product_Package__c)setFormulaField(pack, 'Officer_Region__c', 'CA');
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('RLC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_elc_when_consumer_banking_tce_over_7000000_and_risk_rating_is_under_7(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Consumer Banking';
        pack.LLC_BI__TCE__c = 8000000;
        pack.Risk_Rating_Num__c = 6;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature + ELC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_elc_when_private_banking_tce_over_7000000_and_risk_rating_is_under_7(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Private Banking';
        pack.LLC_BI__TCE__c = 8000000;
        pack.Risk_Rating_Num__c = 6;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature + ELC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_elc_when_niche_products_require_elc(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Niche_Products_Require_ELC__c = true;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('2 Signature + ELC', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_1_signature_when_a_bb_green_deal_has_a_level_a_or_level_b_approver_as_the_officer(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Channel__c = 'Business Banking';
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.New_Money_Renewal__c = 'Renewal';
        pack.BB_Approval_Path__c = 'Green';
        pack.Risk_Rating_Num__c = 6;
        pack = (LLC_BI__Product_Package__c)setFormulaField(pack, 'Officer_is_Level_A_or_B__c', true);
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('1 Signature', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_green_when_bb_renewal_over_150000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Business Banking';
        pack.BB_Approval_Path__c = 'Green';
        pack.LLC_BI__TCE__c = 200000;
        pack.New_Money_Renewal__c = 'Renewal';
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Green', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_yellow_when_bb_renewal_over_150000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Business Banking';
        pack.BB_Approval_Path__c = 'Yellow';
        pack.LLC_BI__TCE__c = 200000;
        pack.New_Money_Renewal__c = 'Renewal';
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Yellow', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_orange_when_bb_renewal_over_150000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Business Banking';
        pack.BB_Approval_Path__c = 'Orange';
        pack.LLC_BI__TCE__c = 200000;
        pack.New_Money_Renewal__c = 'Renewal';
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Orange', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_red_when_bb_renewal_over_150000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Business Banking';
        pack.BB_Approval_Path__c = 'Red';
        pack.LLC_BI__TCE__c = 200000;
        pack.New_Money_Renewal__c = 'Renewal';
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Red', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_awaiting_pass_recommendation_when_pass_recommendation_is_null_for_bb_less_than_or_equal_to_150000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Contains_Policy_Exceptions__c = false;
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Business Banking';
        pack.LLC_BI__TCE__c = 50000;
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Awaiting PASS Recommendation', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_recommend_approve_when_the_pass_recommendation_is_approve_for_bb_less_than_or_equal_to_150000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Contains_Policy_Exceptions__c = false;
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Business Banking';
        pack.LLC_BI__TCE__c = 50000;
        pack.PASS_Recommendation__c = 'Approve';
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Recommend Approve', pack.Recommended_Approval_Path_Apex__c);
    }
    private static testMethod void it_should_set_the_recommended_approval_path_to_recommend_deny_when_the_pass_recommendation_is_deny_for_bb_less_than_or_equal_to_150000(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Contains_Policy_Exceptions__c = false;
        pack.num_of_Committee_Approved_Modifications__c = 0;
        pack.Channel__c = 'Business Banking';
        pack.LLC_BI__TCE__c = 50000;
        pack.PASS_Recommendation__c = 'Deny';
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        
        sut.calculate(newSosMap.values());
        system.assertEquals('Recommend Deny', pack.Recommended_Approval_Path_Apex__c);
    }
    private static SObject setFormulaField(SObject sobj, String fieldName, Object value){
        String jsonString = JSON.serialize(sObj);
        Map<String,Object> dataMap = (Map<String,Object>)JSON.deserializeUntyped(jsonString);
        dataMap.put(fieldName, value);
        jsonString = JSON.serialize(dataMap);
        return (SObject)JSON.deserialize(jsonString, SObject.class);
    }
}