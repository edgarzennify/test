@IsTest
public with sharing class AppraisalOrderComponentTests {
	
	private static final Map<String, Schema.SobjectField> fieldMap = Schema.getGlobalDescribe().get('EB_Collateral__c').getDescribe().fields.getMap();
	private static final EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c();

	private static Integer countNumberOfOccurrencesOfHandlerForCollateralCode(String collateralCode) {
		Integer numberOfOccurrences = 0;
		for(AppraisalOrderComponent.IAppraisalOrderComponent c : AppraisalOrderComponent.getComponents()){
			if(c.handlesCollateralCode(collateralCode)){
				numberOfOccurrences += 1;
			}
		}
		return numberOfOccurrences;
	}

	///////////////////////////////////////////////////////////////////////////////////

	private static testMethod void it_should_return_instance_of_appraisal_order_subGC_GD() {	
		AppraisalOrderComponent.GC_GD sut = new AppraisalOrderComponent.GC_GD();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_GC_GD);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_GC_GD_false_otherwise() {	
		AppraisalOrderComponent.GC_GD sut = new AppraisalOrderComponent.GC_GD();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('GC'));
		system.assertEquals(true , sut.handlesCollateralCode('GD'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_GC_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('GC'));
	}	

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_GD_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('GD'));
	}
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCG() {	
		AppraisalOrderComponent.CG sut = new AppraisalOrderComponent.CG();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CG);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CG_false_otherwise() {	
		AppraisalOrderComponent.CG sut = new AppraisalOrderComponent.CG();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CG'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CG_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CG'));
	}	
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCJ_IJ() {	
		AppraisalOrderComponent.CJ_IJ sut = new AppraisalOrderComponent.CJ_IJ();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CJ_IJ);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CJ_IJ_false_otherwise() {	
		AppraisalOrderComponent.CJ_IJ sut = new AppraisalOrderComponent.CJ_IJ();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CJ'));
		system.assertEquals(true , sut.handlesCollateralCode('IJ'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CJ_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CJ'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IJ_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IJ'));
	}	

	
	private static testMethod void it_should_return_true_for_collateral_codes_CK_IK_false_otherwise() {	
		AppraisalOrderComponent.CK_IK sut = new AppraisalOrderComponent.CK_IK();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CK'));
		system.assertEquals(true , sut.handlesCollateralCode('IK'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CK_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CK'));
	}	

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IK_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IK'));
	}
		
	
	private static testMethod void it_should_return_instance_of_appraisal_order_subQC_QD_QI_QJ() {	
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_QC_QD_QI_QJ);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_QC_QD_QI_QJ_false_otherwise() {	
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('QC'));
		system.assertEquals(true , sut.handlesCollateralCode('QD'));
		system.assertEquals(true , sut.handlesCollateralCode('QI'));
		system.assertEquals(true , sut.handlesCollateralCode('QJ'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QC_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QC'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QD_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QD'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QI_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QI'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QJ_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QJ'));
	}	
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCN_IN() {	
		AppraisalOrderComponent.CN_IN sut = new AppraisalOrderComponent.CN_IN();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CN_IN);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CN_IN_false_otherwise() {	
		AppraisalOrderComponent.CN_IN sut = new AppraisalOrderComponent.CN_IN();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CN'));
		system.assertEquals(true , sut.handlesCollateralCode('IN'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CN_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CN'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IN_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IN'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subAC() {	
		AppraisalOrderComponent.AC sut = new AppraisalOrderComponent.AC();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_AC);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_AC_false_otherwise() {	
		AppraisalOrderComponent.AC sut = new AppraisalOrderComponent.AC();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('AC'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_AC_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('AC'));
	}	
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCC_CD() {	
		AppraisalOrderComponent.CC_CD sut = new AppraisalOrderComponent.CC_CD();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CC_CD);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_codes_CC_CD_false_otherwise() {	
		AppraisalOrderComponent.CC_CD sut = new AppraisalOrderComponent.CC_CD();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CC'));
		system.assertEquals(true , sut.handlesCollateralCode('CD'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CC_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CC'));
	}	

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CD_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CD'));
	}		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subBC() {	
		AppraisalOrderComponent.BC sut = new AppraisalOrderComponent.BC();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_BC);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_BC_false_otherwise() {	
		AppraisalOrderComponent.BC sut = new AppraisalOrderComponent.BC();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('BC'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_BC_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('BC'));
	}	
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCF() {	
		AppraisalOrderComponent.CF sut = new AppraisalOrderComponent.CF();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CF);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CF_false_otherwise() {	
		AppraisalOrderComponent.CF sut = new AppraisalOrderComponent.CF();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CF'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CF_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CF'));
	}	
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCB_CQ_IQ_CT_IT() {	
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CB_CQ_IQ_CT_IT);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CB_CQ_IQ_CT_IT_false_otherwise() {	
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CB'));
		system.assertEquals(true , sut.handlesCollateralCode('CQ'));
		system.assertEquals(true , sut.handlesCollateralCode('IQ'));
		system.assertEquals(true , sut.handlesCollateralCode('CT'));
		system.assertEquals(true , sut.handlesCollateralCode('IT'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CB_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CB'));
	}	

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CQ_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CQ'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IQ_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IQ'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CT_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CT'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IT_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IT'));
	}
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCO() {	
		AppraisalOrderComponent.CO sut = new AppraisalOrderComponent.CO();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CO);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CO_false_otherwise() {	
		AppraisalOrderComponent.CO sut = new AppraisalOrderComponent.CO();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CO'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CO_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CO'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCE_IE() {	
		AppraisalOrderComponent.CE_IE sut = new AppraisalOrderComponent.CE_IE();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CE_IE);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CE_IE_false_otherwise() {	
		AppraisalOrderComponent.CE_IE sut = new AppraisalOrderComponent.CE_IE();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CE'));
		system.assertEquals(true , sut.handlesCollateralCode('IE'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CE_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CE'));
	}	

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IE_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IE'));
	}
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subRA_RB_RC_RD() {	
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_RA_RB_RC_RD);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_RA_RB_RC_RD_false_otherwise() {	
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('RA'));
		system.assertEquals(true , sut.handlesCollateralCode('RB'));
		system.assertEquals(true , sut.handlesCollateralCode('RC'));
		system.assertEquals(true , sut.handlesCollateralCode('RD'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_RA_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('RA'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_RB_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('RB'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_RC_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('RC'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_RD_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('RD'));
	}	
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCI_II() {	
		AppraisalOrderComponent.CI_II sut = new AppraisalOrderComponent.CI_II();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CI_II);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CI_II_false_otherwise() {	
		AppraisalOrderComponent.CI_II sut = new AppraisalOrderComponent.CI_II();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CI'));
		system.assertEquals(true , sut.handlesCollateralCode('II'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CI_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CI'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_II_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('II'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subAA() {	
		AppraisalOrderComponent.AA sut = new AppraisalOrderComponent.AA();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_AA);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_AA_false_otherwise() {	
		AppraisalOrderComponent.AA sut = new AppraisalOrderComponent.AA();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('AA'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_AA_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('AA'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCP_IP() {	
		AppraisalOrderComponent.CP_IP sut = new AppraisalOrderComponent.CP_IP();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CP_IP);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CP_IP_false_otherwise() {	
		AppraisalOrderComponent.CP_IP sut = new AppraisalOrderComponent.CP_IP();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CP'));
		system.assertEquals(true , sut.handlesCollateralCode('IP'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CP_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CP'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IP_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IP'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subGA_GB() {	
		AppraisalOrderComponent.GA_GB sut = new AppraisalOrderComponent.GA_GB();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_GA_GB);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_GA_GB_false_otherwise() {	
		AppraisalOrderComponent.GA_GB sut = new AppraisalOrderComponent.GA_GB();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('GA'));
		system.assertEquals(true , sut.handlesCollateralCode('GB'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_GA_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('GA'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_GB_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('GB'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subEC() {	
		AppraisalOrderComponent.EC sut = new AppraisalOrderComponent.EC();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_EC);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_EC_false_otherwise() {	
		AppraisalOrderComponent.EC sut = new AppraisalOrderComponent.EC();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('EC'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_EC_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('EC'));
	}	
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subIS() {	
		AppraisalOrderComponent.IS sut = new AppraisalOrderComponent.IS();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_IS);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_IS_false_otherwise() {	
		AppraisalOrderComponent.IS sut = new AppraisalOrderComponent.IS();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('IS'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IS_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IS'));
	}	
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subFA_FB() {	
		AppraisalOrderComponent.FA_FB sut = new AppraisalOrderComponent.FA_FB();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_FA_FB);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_FA_FB_false_otherwise() {	
		AppraisalOrderComponent.FA_FB sut = new AppraisalOrderComponent.FA_FB();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('FA'));
		system.assertEquals(true , sut.handlesCollateralCode('FB'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_FA_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('FA'));
	}	
		
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_FB_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('FB'));
	}	
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subQA_QB_QE_QF_QG_QH_QK_QL() {	
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_QAQBQEQFQGQHQKQL);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_QA_QB_QE_QF_QG_QH_QK_QL_false_otherwise() {	
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('QA'));
		system.assertEquals(true , sut.handlesCollateralCode('QB'));
		system.assertEquals(true , sut.handlesCollateralCode('QE'));
		system.assertEquals(true , sut.handlesCollateralCode('QF'));
		system.assertEquals(true , sut.handlesCollateralCode('QG'));
		system.assertEquals(true , sut.handlesCollateralCode('QH'));
		system.assertEquals(true , sut.handlesCollateralCode('QK'));
		system.assertEquals(true , sut.handlesCollateralCode('QL'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QA_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QA'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QB_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QB'));
	}	

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QE_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QE'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QF_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QF'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QG_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QG'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QH_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QH'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QK_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QK'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_QL_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('QL'));
	}
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subDA() {	
		AppraisalOrderComponent.DA sut = new AppraisalOrderComponent.DA();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_DA);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_DA_false_otherwise() {	
		AppraisalOrderComponent.DA sut = new AppraisalOrderComponent.DA();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('DA'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_DA_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('DA'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCH_IH() {	
		AppraisalOrderComponent.CH_IH sut = new AppraisalOrderComponent.CH_IH();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CH_IH);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CH_IH_false_otherwise() {	
		AppraisalOrderComponent.CH_IH sut = new AppraisalOrderComponent.CH_IH();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CH'));
		system.assertEquals(true , sut.handlesCollateralCode('IH'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CH_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CH'));
	}	

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IH_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IH'));
	}
		
    private static testMethod void it_should_return_instance_of_appraisal_order_subAB() {	
		AppraisalOrderComponent.AB sut = new AppraisalOrderComponent.AB();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_AB);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_AB_false_otherwise() {	
		AppraisalOrderComponent.AB sut = new AppraisalOrderComponent.AB();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('AB'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_AB_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('AB'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCL_IL() {	
		AppraisalOrderComponent.CL_IL sut = new AppraisalOrderComponent.CL_IL();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CL_IL);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CL_IL_false_otherwise() {	
		AppraisalOrderComponent.CL_IL sut = new AppraisalOrderComponent.CL_IL();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CL'));
		system.assertEquals(true , sut.handlesCollateralCode('IL'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CL_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CL'));
	}	

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IL_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IL'));
	}
		
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subFC() {	
		AppraisalOrderComponent.FC sut = new AppraisalOrderComponent.FC();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_FC);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_FC_false_otherwise() {	
		AppraisalOrderComponent.FC sut = new AppraisalOrderComponent.FC();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('FC'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_FC_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('FC'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCV_IV() {	
		AppraisalOrderComponent.CV_IV sut = new AppraisalOrderComponent.CV_IV();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CV_IV);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CV_IV_false_otherwise() {	
		AppraisalOrderComponent.CV_IV sut = new AppraisalOrderComponent.CV_IV();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CV'));
		system.assertEquals(true , sut.handlesCollateralCode('IV'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CV_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CV'));
	}

	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_IV_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('IV'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_subCA() {	
		AppraisalOrderComponent.CA sut = new AppraisalOrderComponent.CA();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CA);
	}	
		
	private static testMethod void it_should_return_true_for_collateral_code_CA_false_otherwise() {	
		AppraisalOrderComponent.CA sut = new AppraisalOrderComponent.CA();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		system.assertEquals(true , sut.handlesCollateralCode('CA'));
		system.assertEquals(false , sut.handlesCollateralCode('XX'));
	}	
		
	private static testMethod void it_should_contain_one_and_only_one_handler_for_collateral_code_CA_in_component_list() {	
		system.assertEquals(1, countNumberOfOccurrencesOfHandlerForCollateralCode('CA'));
	}	
		
	private static testMethod void it_should_return_instance_of_appraisal_order_sub_CK_IK() {	
		AppraisalOrderComponent.CK_IK sut = new AppraisalOrderComponent.CK_IK();
		
		ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);
		
		System.assertEquals(true , returnedComponent instanceof Component.c.AppraisalOrderSub_CK_IK);
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_GC_GD() {
		AppraisalOrderComponent.GC_GD sut = new AppraisalOrderComponent.GC_GD();

		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);

		system.assertEquals(14, returnedList.size());
	}

	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CG() {	
		AppraisalOrderComponent.CG sut = new AppraisalOrderComponent.CG();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(17, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CJ_IJ() {	
		AppraisalOrderComponent.CJ_IJ sut = new AppraisalOrderComponent.CJ_IJ();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(6, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CK_IK() {	
		AppraisalOrderComponent.CK_IK sut = new AppraisalOrderComponent.CK_IK();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(6, returnedList.size());
	}	
		
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_QC_QD_QI_QJ() {	
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(5, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CN_IN() {	
		AppraisalOrderComponent.CN_IN sut = new AppraisalOrderComponent.CN_IN();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(8, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_AC() {	
		AppraisalOrderComponent.AC sut = new AppraisalOrderComponent.AC();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(7, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CC_CD() {	
		AppraisalOrderComponent.CC_CD sut = new AppraisalOrderComponent.CC_CD();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(11, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_BC() {	
		AppraisalOrderComponent.BC sut = new AppraisalOrderComponent.BC();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(5, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CF() {	
		AppraisalOrderComponent.CF sut = new AppraisalOrderComponent.CF();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(7, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CB_CQ_IQ_CT_IT() {	
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(6, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CO() {	
		AppraisalOrderComponent.CO sut = new AppraisalOrderComponent.CO();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(10, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CE_IE() {	
		AppraisalOrderComponent.CE_IE sut = new AppraisalOrderComponent.CE_IE();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(10, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_RA_RB_RC_RD() {	
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(1, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CI_II() {	
		AppraisalOrderComponent.CI_II sut = new AppraisalOrderComponent.CI_II();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(9, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_AA() {	
		AppraisalOrderComponent.AA sut = new AppraisalOrderComponent.AA();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(2, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CP_IP() {	
		AppraisalOrderComponent.CP_IP sut = new AppraisalOrderComponent.CP_IP();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(5, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_GA_GB() {	
		AppraisalOrderComponent.GA_GB sut = new AppraisalOrderComponent.GA_GB();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(2, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_EC() {	
		AppraisalOrderComponent.EC sut = new AppraisalOrderComponent.EC();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(6, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_IS() {	
		AppraisalOrderComponent.IS sut = new AppraisalOrderComponent.IS();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(2, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_FA_FB() {	
		AppraisalOrderComponent.FA_FB sut = new AppraisalOrderComponent.FA_FB();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(7, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_QA_QB_QE_QF_QG_QH_QK_QL() {	
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(2, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_DA() {	
		AppraisalOrderComponent.DA sut = new AppraisalOrderComponent.DA();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(4, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CH_IH() {	
		AppraisalOrderComponent.CH_IH sut = new AppraisalOrderComponent.CH_IH();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(8, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_AB() {	
		AppraisalOrderComponent.AB sut = new AppraisalOrderComponent.AB();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(4, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CL_IL() {	
		AppraisalOrderComponent.CL_IL sut = new AppraisalOrderComponent.CL_IL();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(4, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_FC() {	
		AppraisalOrderComponent.FC sut = new AppraisalOrderComponent.FC();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(4, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CV_IV() {	
		AppraisalOrderComponent.CV_IV sut = new AppraisalOrderComponent.CV_IV();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(4, returnedList.size());
	}	
		
	private static testMethod void it_should_return_a_list_of_fields_for_collateral_code_CA() {	
		AppraisalOrderComponent.CA sut = new AppraisalOrderComponent.CA();
		
		List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedList = sut.getAppraisalOrderSummary(testAppraisalOrder);
		
		system.assertEquals(9, returnedList.size());
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_GC_GD(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.GC_GD sut = new AppraisalOrderComponent.GC_GD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_1__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_1__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_2__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_2__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_3__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_3__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_4__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_4__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Lot_Number__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Land_Size_Acreage__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_GC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'GC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.GC_GD sut = new AppraisalOrderComponent.GC_GD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_1__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_1__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_2__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_2__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_3__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_3__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_4__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_4__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Lot_Number__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Land_Size_Acreage__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_GD(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'GD');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.GC_GD sut = new AppraisalOrderComponent.GC_GD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_1__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_1__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_2__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_2__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_3__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_3__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Unit_4__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimated_Value_Unit_4__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Lot_Number__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Land_Size_Acreage__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_GC_GD(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.GC_GD sut = new AppraisalOrderComponent.GC_GD();
		
		oreo.put('Number_of_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units__c').getDescribe().getType()));
		oreo.put('Sq_Ft_Unit_1__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_1__c').getDescribe().getType()));
		oreo.put('Estimated_Value_Unit_1__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_1__c').getDescribe().getType()));
		oreo.put('Sq_Ft_Unit_2__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_2__c').getDescribe().getType()));
		oreo.put('Estimated_Value_Unit_2__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_2__c').getDescribe().getType()));
		oreo.put('Sq_Ft_Unit_3__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_3__c').getDescribe().getType()));
		oreo.put('Estimated_Value_Unit_3__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_3__c').getDescribe().getType()));
		oreo.put('Sq_Ft_Unit_4__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_4__c').getDescribe().getType()));
		oreo.put('Estimated_Value_Unit_4__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_4__c').getDescribe().getType()));
		oreo.put('Name_of_Subdivision_Development__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getType()));
		oreo.put('Lot_Number__c', Utility.getValidFieldValue(fieldMap.get('Lot_Number__c').getDescribe().getType()));
		oreo.put('Land_Size_Acreage__c', Utility.getValidFieldValue(fieldMap.get('Land_Size_Acreage__c').getDescribe().getType()));
		oreo.put('Amenities__c', Utility.getValidFieldValue(fieldMap.get('Amenities__c').getDescribe().getType()));
		oreo.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_GC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'GC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.GC_GD sut = new AppraisalOrderComponent.GC_GD();
		
		testCollateral.put('Number_of_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Unit_1__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_1__c').getDescribe().getType()));
		testCollateral.put('Estimated_Value_Unit_1__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_1__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Unit_2__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_2__c').getDescribe().getType()));
		testCollateral.put('Estimated_Value_Unit_2__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_2__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Unit_3__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_3__c').getDescribe().getType()));
		testCollateral.put('Estimated_Value_Unit_3__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_3__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Unit_4__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_4__c').getDescribe().getType()));
		testCollateral.put('Estimated_Value_Unit_4__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_4__c').getDescribe().getType()));
		testCollateral.put('Name_of_Subdivision_Development__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getType()));
		testCollateral.put('Lot_Number__c', Utility.getValidFieldValue(fieldMap.get('Lot_Number__c').getDescribe().getType()));
		testCollateral.put('Land_Size_Acreage__c', Utility.getValidFieldValue(fieldMap.get('Land_Size_Acreage__c').getDescribe().getType()));
		testCollateral.put('Amenities__c', Utility.getValidFieldValue(fieldMap.get('Amenities__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));

		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_GD(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'GD');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.GC_GD sut = new AppraisalOrderComponent.GC_GD();
		
		testCollateral.put('Number_of_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Unit_1__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_1__c').getDescribe().getType()));
		testCollateral.put('Estimated_Value_Unit_1__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_1__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Unit_2__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_2__c').getDescribe().getType()));
		testCollateral.put('Estimated_Value_Unit_2__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_2__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Unit_3__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_3__c').getDescribe().getType()));
		testCollateral.put('Estimated_Value_Unit_3__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_3__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Unit_4__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Unit_4__c').getDescribe().getType()));
		testCollateral.put('Estimated_Value_Unit_4__c', Utility.getValidFieldValue(fieldMap.get('Estimated_Value_Unit_4__c').getDescribe().getType()));
		testCollateral.put('Name_of_Subdivision_Development__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getType()));
		testCollateral.put('Lot_Number__c', Utility.getValidFieldValue(fieldMap.get('Lot_Number__c').getDescribe().getType()));
		testCollateral.put('Land_Size_Acreage__c', Utility.getValidFieldValue(fieldMap.get('Land_Size_Acreage__c').getDescribe().getType()));
		testCollateral.put('Amenities__c', Utility.getValidFieldValue(fieldMap.get('Amenities__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));

		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CG(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CG sut = new AppraisalOrderComponent.CG();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_One_Bedroom_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_One_BR_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Two_Bedroom_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Two_BR_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Three_Bedroom_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Three_BR_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Four_Bedroom_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Four_BR_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rental_Property__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('For_Sale_Property__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Tax_Credit_Involved__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Restricted_Rents__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CG(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CG');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CG sut = new AppraisalOrderComponent.CG();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_One_Bedroom_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_One_BR_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Two_Bedroom_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Two_BR_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Three_Bedroom_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Three_BR_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_Four_Bedroom_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Four_BR_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rental_Property__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('For_Sale_Property__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Tax_Credit_Involved__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Restricted_Rents__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CG(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CG sut = new AppraisalOrderComponent.CG();
		
		oreo.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		oreo.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Number_of_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units__c').getDescribe().getType()));
		oreo.put('Sq_Ft_One_Bedroom_Units__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_One_Bedroom_Units__c').getDescribe().getType()));
		oreo.put('Number_of_One_BR_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_One_BR_Units__c').getDescribe().getType()));
		oreo.put('Sq_Ft_Two_Bedroom_Units__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Two_Bedroom_Units__c').getDescribe().getType()));
		oreo.put('Number_of_Two_BR_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Two_BR_Units__c').getDescribe().getType()));
		oreo.put('Sq_Ft_Three_Bedroom_Units__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Three_Bedroom_Units__c').getDescribe().getType()));
		oreo.put('Number_of_Three_BR_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Three_BR_Units__c').getDescribe().getType()));
		oreo.put('Sq_Ft_Four_Bedroom_Units__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Four_Bedroom_Units__c').getDescribe().getType()));
		oreo.put('Number_of_Four_BR_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Four_BR_Units__c').getDescribe().getType()));
		oreo.put('Rental_Property__c', Utility.getValidFieldValue(fieldMap.get('Rental_Property__c').getDescribe().getType()));
		oreo.put('For_Sale_Property__c', Utility.getValidFieldValue(fieldMap.get('For_Sale_Property__c').getDescribe().getType()));
		oreo.put('Tax_Credit_Involved__c', Utility.getValidFieldValue(fieldMap.get('Tax_Credit_Involved__c').getDescribe().getType()));
		oreo.put('Restricted_Rents__c', Utility.getValidFieldValue(fieldMap.get('Restricted_Rents__c').getDescribe().getType()));
		oreo.put('Amenities__c', Utility.getValidFieldValue(fieldMap.get('Amenities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CG(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CG');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CG sut = new AppraisalOrderComponent.CG();
		
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Number_of_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_One_Bedroom_Units__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_One_Bedroom_Units__c').getDescribe().getType()));
		testCollateral.put('Number_of_One_BR_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_One_BR_Units__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Two_Bedroom_Units__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Two_Bedroom_Units__c').getDescribe().getType()));
		testCollateral.put('Number_of_Two_BR_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Two_BR_Units__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Three_Bedroom_Units__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Three_Bedroom_Units__c').getDescribe().getType()));
		testCollateral.put('Number_of_Three_BR_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Three_BR_Units__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_Four_Bedroom_Units__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_Four_Bedroom_Units__c').getDescribe().getType()));
		testCollateral.put('Number_of_Four_BR_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Four_BR_Units__c').getDescribe().getType()));
		testCollateral.put('Rental_Property__c', Utility.getValidFieldValue(fieldMap.get('Rental_Property__c').getDescribe().getType()));
		testCollateral.put('For_Sale_Property__c', Utility.getValidFieldValue(fieldMap.get('For_Sale_Property__c').getDescribe().getType()));
		testCollateral.put('Tax_Credit_Involved__c', Utility.getValidFieldValue(fieldMap.get('Tax_Credit_Involved__c').getDescribe().getType()));
		testCollateral.put('Restricted_Rents__c', Utility.getValidFieldValue(fieldMap.get('Restricted_Rents__c').getDescribe().getType()));
		testCollateral.put('Amenities__c', Utility.getValidFieldValue(fieldMap.get('Amenities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CJ_IJ(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CJ_IJ sut = new AppraisalOrderComponent.CJ_IJ();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Denomination__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CJ(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CJ');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CJ_IJ sut = new AppraisalOrderComponent.CJ_IJ();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Denomination__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IJ(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IJ');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CJ_IJ sut = new AppraisalOrderComponent.CJ_IJ();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Denomination__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CJ_IJ(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CJ_IJ sut = new AppraisalOrderComponent.CJ_IJ();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		oreo.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		oreo.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		oreo.put('Denomination__c', Utility.getValidFieldValue(fieldMap.get('Denomination__c').getDescribe().getType()));
		oreo.put('Tax_Exempt_Status__c', Utility.getValidFieldValue(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CJ(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CJ');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CJ_IJ sut = new AppraisalOrderComponent.CJ_IJ();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Denomination__c', Utility.getValidFieldValue(fieldMap.get('Denomination__c').getDescribe().getType()));
		testCollateral.put('Tax_Exempt_Status__c', Utility.getValidFieldValue(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IJ(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IJ');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CJ_IJ sut = new AppraisalOrderComponent.CJ_IJ();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Denomination__c', Utility.getValidFieldValue(fieldMap.get('Denomination__c').getDescribe().getType()));
		testCollateral.put('Tax_Exempt_Status__c', Utility.getValidFieldValue(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_codes_CK_IK(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CK_IK sut = new AppraisalOrderComponent.CK_IK();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_School__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CK(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CK');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CK_IK sut = new AppraisalOrderComponent.CK_IK();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_School__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IK(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IK');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CK_IK sut = new AppraisalOrderComponent.CK_IK();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_School__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_codes_CK_IK(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CK_IK sut = new AppraisalOrderComponent.CK_IK();
		
		oreo.put('Type_of_School__c', Utility.getValidFieldValue(fieldMap.get('Type_of_School__c').getDescribe().getType()));
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		oreo.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		oreo.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		oreo.put('Tax_Exempt_Status__c', Utility.getValidFieldValue(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CK(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CK');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CK_IK sut = new AppraisalOrderComponent.CK_IK();
		
		testCollateral.put('Type_of_School__c', Utility.getValidFieldValue(fieldMap.get('Type_of_School__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Tax_Exempt_Status__c', Utility.getValidFieldValue(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IK(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IK');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CK_IK sut = new AppraisalOrderComponent.CK_IK();
		
		testCollateral.put('Type_of_School__c', Utility.getValidFieldValue(fieldMap.get('Type_of_School__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Tax_Exempt_Status__c', Utility.getValidFieldValue(fieldMap.get('Tax_Exempt_Status__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}
		
		
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_QC_QD_QI_QJ(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QD(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QD');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QI(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QI');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QJ(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QJ');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_QC_QD_QI_QJ(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		oreo.put('Sq_Ft_of_Unit__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Unit__c').getDescribe().getType()));
		oreo.put('Estimate_Value_of_Unit__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_Unit__c').getDescribe().getType()));
		oreo.put('Name_of_Subdivision_Development__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getType()));
		oreo.put('Number_of_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units__c').getDescribe().getType()));
		oreo.put('Amenities__c', Utility.getValidFieldValue(fieldMap.get('Amenities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		testCollateral.put('Sq_Ft_of_Unit__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Unit__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_Unit__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_Unit__c').getDescribe().getType()));
		testCollateral.put('Name_of_Subdivision_Development__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getType()));
		testCollateral.put('Number_of_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units__c').getDescribe().getType()));
		testCollateral.put('Amenities__c', Utility.getValidFieldValue(fieldMap.get('Amenities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QD(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QD');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		testCollateral.put('Sq_Ft_of_Unit__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Unit__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_Unit__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_Unit__c').getDescribe().getType()));
		testCollateral.put('Name_of_Subdivision_Development__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getType()));
		testCollateral.put('Number_of_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units__c').getDescribe().getType()));
		testCollateral.put('Amenities__c', Utility.getValidFieldValue(fieldMap.get('Amenities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QI(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QI');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		testCollateral.put('Sq_Ft_of_Unit__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Unit__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_Unit__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_Unit__c').getDescribe().getType()));
		testCollateral.put('Name_of_Subdivision_Development__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getType()));
		testCollateral.put('Number_of_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units__c').getDescribe().getType()));
		testCollateral.put('Amenities__c', Utility.getValidFieldValue(fieldMap.get('Amenities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QJ(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QJ');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QC_QD_QI_QJ sut = new AppraisalOrderComponent.QC_QD_QI_QJ();
		
		testCollateral.put('Sq_Ft_of_Unit__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Unit__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_Unit__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_Unit__c').getDescribe().getType()));
		testCollateral.put('Name_of_Subdivision_Development__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getType()));
		testCollateral.put('Number_of_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units__c').getDescribe().getType()));
		testCollateral.put('Amenities__c', Utility.getValidFieldValue(fieldMap.get('Amenities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}
		
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CN_IN(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CN_IN sut = new AppraisalOrderComponent.CN_IN();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Flag_Brand_of_Store__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Car_Wash__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Gas_Pumps__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Renovation__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CN(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CN');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CN_IN sut = new AppraisalOrderComponent.CN_IN();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Flag_Brand_of_Store__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Car_Wash__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Gas_Pumps__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Renovation__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IN(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IN');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CN_IN sut = new AppraisalOrderComponent.CN_IN();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Flag_Brand_of_Store__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Car_Wash__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Gas_Pumps__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Renovation__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CN_IN(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CN_IN sut = new AppraisalOrderComponent.CN_IN();
		
		oreo.put('Flag_Brand_of_Store__c', Utility.getValidFieldValue(fieldMap.get('Flag_Brand_of_Store__c').getDescribe().getType()));
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		oreo.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		oreo.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		oreo.put('Car_Wash__c', Utility.getValidFieldValue(fieldMap.get('Car_Wash__c').getDescribe().getType()));
		oreo.put('Gas_Pumps__c', Utility.getValidFieldValue(fieldMap.get('Gas_Pumps__c').getDescribe().getType()));
		oreo.put('Renovation__c', Utility.getValidFieldValue(fieldMap.get('Renovation__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CN(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CN');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CN_IN sut = new AppraisalOrderComponent.CN_IN();
		
		testCollateral.put('Flag_Brand_of_Store__c', Utility.getValidFieldValue(fieldMap.get('Flag_Brand_of_Store__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Car_Wash__c', Utility.getValidFieldValue(fieldMap.get('Car_Wash__c').getDescribe().getType()));
		testCollateral.put('Gas_Pumps__c', Utility.getValidFieldValue(fieldMap.get('Gas_Pumps__c').getDescribe().getType()));
		testCollateral.put('Renovation__c', Utility.getValidFieldValue(fieldMap.get('Renovation__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IN(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IN');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CN_IN sut = new AppraisalOrderComponent.CN_IN();
		
		testCollateral.put('Flag_Brand_of_Store__c', Utility.getValidFieldValue(fieldMap.get('Flag_Brand_of_Store__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Car_Wash__c', Utility.getValidFieldValue(fieldMap.get('Car_Wash__c').getDescribe().getType()));
		testCollateral.put('Gas_Pumps__c', Utility.getValidFieldValue(fieldMap.get('Gas_Pumps__c').getDescribe().getType()));
		testCollateral.put('Renovation__c', Utility.getValidFieldValue(fieldMap.get('Renovation__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_AC(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.AC sut = new AppraisalOrderComponent.AC();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Acres_Res_Single_Fam__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Acres_Com_Office__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Acres_Industrial__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Acres_Retail__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Land_Improvements__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Describe_Improvements__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_AC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'AC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.AC sut = new AppraisalOrderComponent.AC();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Acres_Res_Single_Fam__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Acres_Com_Office__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Acres_Industrial__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Acres_Retail__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Land_Improvements__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Describe_Improvements__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_AC(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.AC sut = new AppraisalOrderComponent.AC();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Number_of_Acres_Res_Single_Fam__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Acres_Res_Single_Fam__c').getDescribe().getType()));
		oreo.put('Number_of_Acres_Com_Office__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Acres_Com_Office__c').getDescribe().getType()));
		oreo.put('Number_of_Acres_Industrial__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Acres_Industrial__c').getDescribe().getType()));
		oreo.put('Number_of_Acres_Retail__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Acres_Retail__c').getDescribe().getType()));
		oreo.put('Land_Improvements__c', Utility.getValidFieldValue(fieldMap.get('Land_Improvements__c').getDescribe().getType()));
		oreo.put('Describe_Improvements__c', Utility.getValidFieldValue(fieldMap.get('Describe_Improvements__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_AC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'AC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.AC sut = new AppraisalOrderComponent.AC();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Number_of_Acres_Res_Single_Fam__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Acres_Res_Single_Fam__c').getDescribe().getType()));
		testCollateral.put('Number_of_Acres_Com_Office__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Acres_Com_Office__c').getDescribe().getType()));
		testCollateral.put('Number_of_Acres_Industrial__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Acres_Industrial__c').getDescribe().getType()));
		testCollateral.put('Number_of_Acres_Retail__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Acres_Retail__c').getDescribe().getType()));
		testCollateral.put('Land_Improvements__c', Utility.getValidFieldValue(fieldMap.get('Land_Improvements__c').getDescribe().getType()));
		testCollateral.put('Describe_Improvements__c', Utility.getValidFieldValue(fieldMap.get('Describe_Improvements__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CC_CD(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CC_CD sut = new AppraisalOrderComponent.CC_CD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Flag_Brand_of_Hotel_Motel__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Rooms__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Free_Standing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Limited_Service__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Full_Service__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Resort__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rehabilitation__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CC_CD sut = new AppraisalOrderComponent.CC_CD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Flag_Brand_of_Hotel_Motel__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Rooms__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Free_Standing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Limited_Service__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Full_Service__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Resort__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rehabilitation__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CD(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CD');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CC_CD sut = new AppraisalOrderComponent.CC_CD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Flag_Brand_of_Hotel_Motel__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Rooms__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Free_Standing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Limited_Service__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Full_Service__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Resort__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rehabilitation__c').getDescribe().getLabel()));
	}		
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CC_CD(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CC_CD sut = new AppraisalOrderComponent.CC_CD();
		
		oreo.put('Flag_Brand_of_Hotel_Motel__c', Utility.getValidFieldValue(fieldMap.get('Flag_Brand_of_Hotel_Motel__c').getDescribe().getType()));
		oreo.put('Number_of_Rooms__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Rooms__c').getDescribe().getType()));
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		oreo.put('Free_Standing__c', Utility.getValidFieldValue(fieldMap.get('Free_Standing__c').getDescribe().getType()));
		oreo.put('Limited_Service__c', Utility.getValidFieldValue(fieldMap.get('Limited_Service__c').getDescribe().getType()));
		oreo.put('Full_Service__c', Utility.getValidFieldValue(fieldMap.get('Full_Service__c').getDescribe().getType()));
		oreo.put('Resort__c', Utility.getValidFieldValue(fieldMap.get('Resort__c').getDescribe().getType()));
		oreo.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		oreo.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		oreo.put('Rehabilitation__c', Utility.getValidFieldValue(fieldMap.get('Rehabilitation__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CC_CD sut = new AppraisalOrderComponent.CC_CD();
		
		testCollateral.put('Flag_Brand_of_Hotel_Motel__c', Utility.getValidFieldValue(fieldMap.get('Flag_Brand_of_Hotel_Motel__c').getDescribe().getType()));
		testCollateral.put('Number_of_Rooms__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Rooms__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		testCollateral.put('Free_Standing__c', Utility.getValidFieldValue(fieldMap.get('Free_Standing__c').getDescribe().getType()));
		testCollateral.put('Limited_Service__c', Utility.getValidFieldValue(fieldMap.get('Limited_Service__c').getDescribe().getType()));
		testCollateral.put('Full_Service__c', Utility.getValidFieldValue(fieldMap.get('Full_Service__c').getDescribe().getType()));
		testCollateral.put('Resort__c', Utility.getValidFieldValue(fieldMap.get('Resort__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		testCollateral.put('Rehabilitation__c', Utility.getValidFieldValue(fieldMap.get('Rehabilitation__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CD(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CD');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CC_CD sut = new AppraisalOrderComponent.CC_CD();
		
		testCollateral.put('Flag_Brand_of_Hotel_Motel__c', Utility.getValidFieldValue(fieldMap.get('Flag_Brand_of_Hotel_Motel__c').getDescribe().getType()));
		testCollateral.put('Number_of_Rooms__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Rooms__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_Building__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_Building__c').getDescribe().getType()));
		testCollateral.put('Free_Standing__c', Utility.getValidFieldValue(fieldMap.get('Free_Standing__c').getDescribe().getType()));
		testCollateral.put('Limited_Service__c', Utility.getValidFieldValue(fieldMap.get('Limited_Service__c').getDescribe().getType()));
		testCollateral.put('Full_Service__c', Utility.getValidFieldValue(fieldMap.get('Full_Service__c').getDescribe().getType()));
		testCollateral.put('Resort__c', Utility.getValidFieldValue(fieldMap.get('Resort__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		testCollateral.put('Rehabilitation__c', Utility.getValidFieldValue(fieldMap.get('Rehabilitation__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_BC(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.BC sut = new AppraisalOrderComponent.BC();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Commercial_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Zoning_Classification__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Land_Improvements__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Describe_Improvements__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_BC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'BC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.BC sut = new AppraisalOrderComponent.BC();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Commercial_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Zoning_Classification__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Land_Improvements__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Describe_Improvements__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_BC(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.BC sut = new AppraisalOrderComponent.BC();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Number_of_Commercial_Lots__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Commercial_Lots__c').getDescribe().getType()));
		oreo.put('Zoning_Classification__c', Utility.getValidFieldValue(fieldMap.get('Zoning_Classification__c').getDescribe().getType()));
		oreo.put('Land_Improvements__c', Utility.getValidFieldValue(fieldMap.get('Land_Improvements__c').getDescribe().getType()));
		oreo.put('Describe_Improvements__c', Utility.getValidFieldValue(fieldMap.get('Describe_Improvements__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_BC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'BC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.BC sut = new AppraisalOrderComponent.BC();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Number_of_Commercial_Lots__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Commercial_Lots__c').getDescribe().getType()));
		testCollateral.put('Zoning_Classification__c', Utility.getValidFieldValue(fieldMap.get('Zoning_Classification__c').getDescribe().getType()));
		testCollateral.put('Land_Improvements__c', Utility.getValidFieldValue(fieldMap.get('Land_Improvements__c').getDescribe().getType()));
		testCollateral.put('Describe_Improvements__c', Utility.getValidFieldValue(fieldMap.get('Describe_Improvements__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CF(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CF sut = new AppraisalOrderComponent.CF();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Storage_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Electric_Utilities_Provided_for_ea_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Outside_Storage__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units_of_Outside_Storage__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CF(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CF');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CF sut = new AppraisalOrderComponent.CF();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Storage_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Electric_Utilities_Provided_for_ea_Unit__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Outside_Storage__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Units_of_Outside_Storage__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CF(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CF sut = new AppraisalOrderComponent.CF();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Number_of_Storage_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Storage_Units__c').getDescribe().getType()));
		oreo.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		oreo.put('Sq_Ft_of_all_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getType()));
		oreo.put('Electric_Utilities_Provided_for_ea_Unit__c', Utility.getValidFieldValue(fieldMap.get('Electric_Utilities_Provided_for_ea_Unit__c').getDescribe().getType()));
		oreo.put('Outside_Storage__c', Utility.getValidFieldValue(fieldMap.get('Outside_Storage__c').getDescribe().getType()));
		oreo.put('Number_of_Units_of_Outside_Storage__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units_of_Outside_Storage__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CF(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CF');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CF sut = new AppraisalOrderComponent.CF();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Number_of_Storage_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Storage_Units__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_all_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getType()));
		testCollateral.put('Electric_Utilities_Provided_for_ea_Unit__c', Utility.getValidFieldValue(fieldMap.get('Electric_Utilities_Provided_for_ea_Unit__c').getDescribe().getType()));
		testCollateral.put('Outside_Storage__c', Utility.getValidFieldValue(fieldMap.get('Outside_Storage__c').getDescribe().getType()));
		testCollateral.put('Number_of_Units_of_Outside_Storage__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Units_of_Outside_Storage__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CB_CQ_IQ_CT_IT(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Use__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Use__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CQ(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CQ');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Use__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IQ(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IQ');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Use__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CT(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CT');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Use__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IT(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IT');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Use__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('New_Construction__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Existing__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CB_CQ_IQ_CT_IT(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		oreo.put('Type_of_Use__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Use__c').getDescribe().getType()));
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Sq_Ft_of_all_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getType()));
		oreo.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		oreo.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		oreo.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		testCollateral.put('Type_of_Use__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Use__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_all_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CQ(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CQ');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		testCollateral.put('Type_of_Use__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Use__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_all_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IQ(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IQ');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		testCollateral.put('Type_of_Use__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Use__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_all_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CT(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CT');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		testCollateral.put('Type_of_Use__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Use__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_all_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IT(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IT');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CB_CQ_IQ_CT_IT sut = new AppraisalOrderComponent.CB_CQ_IQ_CT_IT();
		
		testCollateral.put('Type_of_Use__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Use__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Sq_Ft_of_all_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_all_Buildings__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('New_Construction__c', Utility.getValidFieldValue(fieldMap.get('New_Construction__c').getDescribe().getType()));
		testCollateral.put('Existing__c', Utility.getValidFieldValue(fieldMap.get('Existing__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CO(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CO sut = new AppraisalOrderComponent.CO();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Skilled_Nursing_Beds__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Assisted_Living_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Independent_Living_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Private_Pay__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Medicare__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Medicaid__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Veterans_Administration_Beds__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Dementia_Alzheimers__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CO(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CO');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CO sut = new AppraisalOrderComponent.CO();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Skilled_Nursing_Beds__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Assisted_Living_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Independent_Living_Units__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Private_Pay__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Medicare__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Medicaid__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Veterans_Administration_Beds__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Dementia_Alzheimers__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CO(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CO sut = new AppraisalOrderComponent.CO();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		oreo.put('Number_of_Skilled_Nursing_Beds__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Skilled_Nursing_Beds__c').getDescribe().getType()));
		oreo.put('Number_of_Assisted_Living_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Assisted_Living_Units__c').getDescribe().getType()));
		oreo.put('Number_of_Independent_Living_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Independent_Living_Units__c').getDescribe().getType()));
		oreo.put('Private_Pay__c', Utility.getValidFieldValue(fieldMap.get('Private_Pay__c').getDescribe().getType()));
		oreo.put('Medicare__c', Utility.getValidFieldValue(fieldMap.get('Medicare__c').getDescribe().getType()));
		oreo.put('Medicaid__c', Utility.getValidFieldValue(fieldMap.get('Medicaid__c').getDescribe().getType()));
		oreo.put('Veterans_Administration_Beds__c', Utility.getValidFieldValue(fieldMap.get('Veterans_Administration_Beds__c').getDescribe().getType()));
		oreo.put('Dementia_Alzheimers__c', Utility.getValidFieldValue(fieldMap.get('Dementia_Alzheimers__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CO(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CO');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CO sut = new AppraisalOrderComponent.CO();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		testCollateral.put('Number_of_Skilled_Nursing_Beds__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Skilled_Nursing_Beds__c').getDescribe().getType()));
		testCollateral.put('Number_of_Assisted_Living_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Assisted_Living_Units__c').getDescribe().getType()));
		testCollateral.put('Number_of_Independent_Living_Units__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Independent_Living_Units__c').getDescribe().getType()));
		testCollateral.put('Private_Pay__c', Utility.getValidFieldValue(fieldMap.get('Private_Pay__c').getDescribe().getType()));
		testCollateral.put('Medicare__c', Utility.getValidFieldValue(fieldMap.get('Medicare__c').getDescribe().getType()));
		testCollateral.put('Medicaid__c', Utility.getValidFieldValue(fieldMap.get('Medicaid__c').getDescribe().getType()));
		testCollateral.put('Veterans_Administration_Beds__c', Utility.getValidFieldValue(fieldMap.get('Veterans_Administration_Beds__c').getDescribe().getType()));
		testCollateral.put('Dementia_Alzheimers__c', Utility.getValidFieldValue(fieldMap.get('Dementia_Alzheimers__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CE_IE(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CE_IE sut = new AppraisalOrderComponent.CE_IE();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_of_Office_Space__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_Warehouse_Mfg_Space__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Outside_Storage__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_Occupied__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Tenants__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CE(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CE');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CE_IE sut = new AppraisalOrderComponent.CE_IE();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_of_Office_Space__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_Warehouse_Mfg_Space__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Outside_Storage__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_Occupied__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Tenants__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IE(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IE');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CE_IE sut = new AppraisalOrderComponent.CE_IE();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_of_Office_Space__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_Warehouse_Mfg_Space__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Outside_Storage__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_Occupied__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Tenants__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CE_IE(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CE_IE sut = new AppraisalOrderComponent.CE_IE();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Total_Sq_Ft_of_Building_Area__c', Utility.getValidFieldValue(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getType()));
		oreo.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		oreo.put('Rentable_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getType()));
		oreo.put('Percent_of_Office_Space__c', Utility.getValidFieldValue(fieldMap.get('Percent_of_Office_Space__c').getDescribe().getType()));
		oreo.put('Percent_Warehouse_Mfg_Space__c', Utility.getValidFieldValue(fieldMap.get('Percent_Warehouse_Mfg_Space__c').getDescribe().getType()));
		oreo.put('Outside_Storage__c', Utility.getValidFieldValue(fieldMap.get('Outside_Storage__c').getDescribe().getType()));
		oreo.put('Percent_Occupied__c', Utility.getValidFieldValue(fieldMap.get('Percent_Occupied__c').getDescribe().getType()));
		oreo.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		oreo.put('Number_of_Tenants__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Tenants__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CE(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CE');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CE_IE sut = new AppraisalOrderComponent.CE_IE();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Total_Sq_Ft_of_Building_Area__c', Utility.getValidFieldValue(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('Rentable_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getType()));
		testCollateral.put('Percent_of_Office_Space__c', Utility.getValidFieldValue(fieldMap.get('Percent_of_Office_Space__c').getDescribe().getType()));
		testCollateral.put('Percent_Warehouse_Mfg_Space__c', Utility.getValidFieldValue(fieldMap.get('Percent_Warehouse_Mfg_Space__c').getDescribe().getType()));
		testCollateral.put('Outside_Storage__c', Utility.getValidFieldValue(fieldMap.get('Outside_Storage__c').getDescribe().getType()));
		testCollateral.put('Percent_Occupied__c', Utility.getValidFieldValue(fieldMap.get('Percent_Occupied__c').getDescribe().getType()));
		testCollateral.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		testCollateral.put('Number_of_Tenants__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Tenants__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IE(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IE');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CE_IE sut = new AppraisalOrderComponent.CE_IE();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Total_Sq_Ft_of_Building_Area__c', Utility.getValidFieldValue(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('Rentable_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getType()));
		testCollateral.put('Percent_of_Office_Space__c', Utility.getValidFieldValue(fieldMap.get('Percent_of_Office_Space__c').getDescribe().getType()));
		testCollateral.put('Percent_Warehouse_Mfg_Space__c', Utility.getValidFieldValue(fieldMap.get('Percent_Warehouse_Mfg_Space__c').getDescribe().getType()));
		testCollateral.put('Outside_Storage__c', Utility.getValidFieldValue(fieldMap.get('Outside_Storage__c').getDescribe().getType()));
		testCollateral.put('Percent_Occupied__c', Utility.getValidFieldValue(fieldMap.get('Percent_Occupied__c').getDescribe().getType()));
		testCollateral.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		testCollateral.put('Number_of_Tenants__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Tenants__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_RA_RB_RC_RD(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_RA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'RA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_RB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'RB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_RC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'RC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_RD(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'RD');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_RA_RB_RC_RD(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_RA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'RA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_RB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'RB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_RC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'RC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_RD(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'RD');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.RA_RB_RC_RD sut = new AppraisalOrderComponent.RA_RB_RC_RD();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}		
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CI_II(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CI_II sut = new AppraisalOrderComponent.CI_II();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Out_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Out_Lot_1_Size_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Out_Lot_2_Size_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Out_Lot_3_Size_Sq_Ft__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CI(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CI');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CI_II sut = new AppraisalOrderComponent.CI_II();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Out_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Out_Lot_1_Size_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Out_Lot_2_Size_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Out_Lot_3_Size_Sq_Ft__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_II(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'II');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CI_II sut = new AppraisalOrderComponent.CI_II();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Out_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Out_Lot_1_Size_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Out_Lot_2_Size_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Out_Lot_3_Size_Sq_Ft__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CI_II(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CI_II sut = new AppraisalOrderComponent.CI_II();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		oreo.put('Total_Sq_Ft_of_Building_Area__c', Utility.getValidFieldValue(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getType()));
		oreo.put('Rentable_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getType()));
		oreo.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		oreo.put('Number_of_Out_Lots__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Out_Lots__c').getDescribe().getType()));
		oreo.put('Out_Lot_1_Size_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Out_Lot_1_Size_Sq_Ft__c').getDescribe().getType()));
		oreo.put('Out_Lot_2_Size_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Out_Lot_2_Size_Sq_Ft__c').getDescribe().getType()));
		oreo.put('Out_Lot_3_Size_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Out_Lot_3_Size_Sq_Ft__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CI(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CI');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CI_II sut = new AppraisalOrderComponent.CI_II();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('Total_Sq_Ft_of_Building_Area__c', Utility.getValidFieldValue(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getType()));
		testCollateral.put('Rentable_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getType()));
		testCollateral.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		testCollateral.put('Number_of_Out_Lots__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Out_Lots__c').getDescribe().getType()));
		testCollateral.put('Out_Lot_1_Size_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Out_Lot_1_Size_Sq_Ft__c').getDescribe().getType()));
		testCollateral.put('Out_Lot_2_Size_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Out_Lot_2_Size_Sq_Ft__c').getDescribe().getType()));
		testCollateral.put('Out_Lot_3_Size_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Out_Lot_3_Size_Sq_Ft__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_II(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'II');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CI_II sut = new AppraisalOrderComponent.CI_II();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		testCollateral.put('Total_Sq_Ft_of_Building_Area__c', Utility.getValidFieldValue(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getType()));
		testCollateral.put('Rentable_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getType()));
		testCollateral.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		testCollateral.put('Number_of_Out_Lots__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Out_Lots__c').getDescribe().getType()));
		testCollateral.put('Out_Lot_1_Size_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Out_Lot_1_Size_Sq_Ft__c').getDescribe().getType()));
		testCollateral.put('Out_Lot_2_Size_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Out_Lot_2_Size_Sq_Ft__c').getDescribe().getType()));
		testCollateral.put('Out_Lot_3_Size_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Out_Lot_3_Size_Sq_Ft__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_AA(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.AA sut = new AppraisalOrderComponent.AA();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Zoning_Classification__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_AA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = '65');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.AA sut = new AppraisalOrderComponent.AA();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Zoning_Classification__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_AA(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.AA sut = new AppraisalOrderComponent.AA();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Zoning_Classification__c', Utility.getValidFieldValue(fieldMap.get('Zoning_Classification__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_AA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = '65');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.AA sut = new AppraisalOrderComponent.AA();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Zoning_Classification__c', Utility.getValidFieldValue(fieldMap.get('Zoning_Classification__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CP_IP(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CP_IP sut = new AppraisalOrderComponent.CP_IP();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Seating_Capacity__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Chain_Restaurant__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Chain_Restaurant__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CP(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CP');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CP_IP sut = new AppraisalOrderComponent.CP_IP();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Seating_Capacity__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Chain_Restaurant__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Chain_Restaurant__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IP(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IP');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CP_IP sut = new AppraisalOrderComponent.CP_IP();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Seating_Capacity__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Chain_Restaurant__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Chain_Restaurant__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CP_IP(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CP_IP sut = new AppraisalOrderComponent.CP_IP();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Total_Sq_Ft_of_Building_Area__c', Utility.getValidFieldValue(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getType()));
		oreo.put('Seating_Capacity__c', Utility.getValidFieldValue(fieldMap.get('Seating_Capacity__c').getDescribe().getType()));
		oreo.put('Chain_Restaurant__c', Utility.getValidFieldValue(fieldMap.get('Chain_Restaurant__c').getDescribe().getType()));
		oreo.put('Name_of_Chain_Restaurant__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Chain_Restaurant__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CP(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CP');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CP_IP sut = new AppraisalOrderComponent.CP_IP();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Total_Sq_Ft_of_Building_Area__c', Utility.getValidFieldValue(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getType()));
		testCollateral.put('Seating_Capacity__c', Utility.getValidFieldValue(fieldMap.get('Seating_Capacity__c').getDescribe().getType()));
		testCollateral.put('Chain_Restaurant__c', Utility.getValidFieldValue(fieldMap.get('Chain_Restaurant__c').getDescribe().getType()));
		testCollateral.put('Name_of_Chain_Restaurant__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Chain_Restaurant__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IP(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IP');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CP_IP sut = new AppraisalOrderComponent.CP_IP();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Total_Sq_Ft_of_Building_Area__c', Utility.getValidFieldValue(fieldMap.get('Total_Sq_Ft_of_Building_Area__c').getDescribe().getType()));
		testCollateral.put('Seating_Capacity__c', Utility.getValidFieldValue(fieldMap.get('Seating_Capacity__c').getDescribe().getType()));
		testCollateral.put('Chain_Restaurant__c', Utility.getValidFieldValue(fieldMap.get('Chain_Restaurant__c').getDescribe().getType()));
		testCollateral.put('Name_of_Chain_Restaurant__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Chain_Restaurant__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_GA_GB(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.GA_GB sut = new AppraisalOrderComponent.GA_GB();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_GA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'GA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.GA_GB sut = new AppraisalOrderComponent.GA_GB();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_GB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'GB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.GA_GB sut = new AppraisalOrderComponent.GA_GB();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_GA_GB(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.GA_GB sut = new AppraisalOrderComponent.GA_GB();
		
		oreo.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		oreo.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_GA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'GA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.GA_GB sut = new AppraisalOrderComponent.GA_GB();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_GB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'GB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.GA_GB sut = new AppraisalOrderComponent.GA_GB();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_EC(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.EC sut = new AppraisalOrderComponent.EC();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Improved_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Excess_Unimproved_Land__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Acres_Excess_Unimproved_Land__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Describe_Improvements__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_EC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'EC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.EC sut = new AppraisalOrderComponent.EC();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Improved_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Excess_Unimproved_Land__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Acres_Excess_Unimproved_Land__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Describe_Improvements__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_EC(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.EC sut = new AppraisalOrderComponent.EC();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Number_of_Improved_Lots__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Improved_Lots__c').getDescribe().getType()));
		oreo.put('Name_of_Subdivision_Development__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getType()));
		oreo.put('Excess_Unimproved_Land__c', Utility.getValidFieldValue(fieldMap.get('Excess_Unimproved_Land__c').getDescribe().getType()));
		oreo.put('Number_of_Acres_Excess_Unimproved_Land__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Acres_Excess_Unimproved_Land__c').getDescribe().getType()));
		oreo.put('Describe_Improvements__c', Utility.getValidFieldValue(fieldMap.get('Describe_Improvements__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_EC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'EC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.EC sut = new AppraisalOrderComponent.EC();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Number_of_Improved_Lots__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Improved_Lots__c').getDescribe().getType()));
		testCollateral.put('Name_of_Subdivision_Development__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Subdivision_Development__c').getDescribe().getType()));
		testCollateral.put('Excess_Unimproved_Land__c', Utility.getValidFieldValue(fieldMap.get('Excess_Unimproved_Land__c').getDescribe().getType()));
		testCollateral.put('Number_of_Acres_Excess_Unimproved_Land__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Acres_Excess_Unimproved_Land__c').getDescribe().getType()));
		testCollateral.put('Describe_Improvements__c', Utility.getValidFieldValue(fieldMap.get('Describe_Improvements__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_IS(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.IS sut = new AppraisalOrderComponent.IS();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		//system.assert(errorMsg.contains(fieldMap.get('Legal_Description__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IS(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IS');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.IS sut = new AppraisalOrderComponent.IS();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		//system.assert(errorMsg.contains(fieldMap.get('Legal_Description__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_IS(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.IS sut = new AppraisalOrderComponent.IS();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Legal_Description__c', Utility.getValidFieldValue(fieldMap.get('Legal_Description__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IS(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IS');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.IS sut = new AppraisalOrderComponent.IS();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Legal_Description__c', Utility.getValidFieldValue(fieldMap.get('Legal_Description__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_FA_FB(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.FA_FB sut = new AppraisalOrderComponent.FA_FB();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Legal_Name_of_Subdivision__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Lot_Number__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Lot_Size__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Corner_Lot__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Cul_de_Sac_Lot__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_FA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'FA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.FA_FB sut = new AppraisalOrderComponent.FA_FB();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Legal_Name_of_Subdivision__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Lot_Number__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Lot_Size__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Corner_Lot__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Cul_de_Sac_Lot__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_FB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'FB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.FA_FB sut = new AppraisalOrderComponent.FA_FB();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Legal_Name_of_Subdivision__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Lot_Number__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Lot_Size__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Corner_Lot__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Cul_de_Sac_Lot__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_FA_FB(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.FA_FB sut = new AppraisalOrderComponent.FA_FB();
		
		oreo.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		oreo.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		oreo.put('Legal_Name_of_Subdivision__c', Utility.getValidFieldValue(fieldMap.get('Legal_Name_of_Subdivision__c').getDescribe().getType()));
		oreo.put('Lot_Number__c', Utility.getValidFieldValue(fieldMap.get('Lot_Number__c').getDescribe().getType()));
		oreo.put('Lot_Size__c', Utility.getValidFieldValue(fieldMap.get('Lot_Size__c').getDescribe().getType()));
		oreo.put('Corner_Lot__c', Utility.getValidFieldValue(fieldMap.get('Corner_Lot__c').getDescribe().getType()));
		oreo.put('Cul_de_Sac_Lot__c', Utility.getValidFieldValue(fieldMap.get('Cul_de_Sac_Lot__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_FA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'FA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.FA_FB sut = new AppraisalOrderComponent.FA_FB();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		testCollateral.put('Legal_Name_of_Subdivision__c', Utility.getValidFieldValue(fieldMap.get('Legal_Name_of_Subdivision__c').getDescribe().getType()));
		testCollateral.put('Lot_Number__c', Utility.getValidFieldValue(fieldMap.get('Lot_Number__c').getDescribe().getType()));
		testCollateral.put('Lot_Size__c', Utility.getValidFieldValue(fieldMap.get('Lot_Size__c').getDescribe().getType()));
		testCollateral.put('Corner_Lot__c', Utility.getValidFieldValue(fieldMap.get('Corner_Lot__c').getDescribe().getType()));
		testCollateral.put('Cul_de_Sac_Lot__c', Utility.getValidFieldValue(fieldMap.get('Cul_de_Sac_Lot__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_FB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'FB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.FA_FB sut = new AppraisalOrderComponent.FA_FB();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		testCollateral.put('Legal_Name_of_Subdivision__c', Utility.getValidFieldValue(fieldMap.get('Legal_Name_of_Subdivision__c').getDescribe().getType()));
		testCollateral.put('Lot_Number__c', Utility.getValidFieldValue(fieldMap.get('Lot_Number__c').getDescribe().getType()));
		testCollateral.put('Lot_Size__c', Utility.getValidFieldValue(fieldMap.get('Lot_Size__c').getDescribe().getType()));
		testCollateral.put('Corner_Lot__c', Utility.getValidFieldValue(fieldMap.get('Corner_Lot__c').getDescribe().getType()));
		testCollateral.put('Cul_de_Sac_Lot__c', Utility.getValidFieldValue(fieldMap.get('Cul_de_Sac_Lot__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}
	
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_QA_QB_QE_QF_QG_QH_QK_QL(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QE(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QE');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QF(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QF');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QG(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QG');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QH(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QH');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QK(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QK');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_QL(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QL');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_QA_QB_QE_QF_QG_QH_QK_QL(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		oreo.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		oreo.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QE(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QE');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QF(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QF');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QG(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QG');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QH(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QH');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QK(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QK');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_QL(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'QL');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL sut = new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Estimate_Value_of_House__c', Utility.getValidFieldValue(fieldMap.get('Estimate_Value_of_House__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_DA(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.DA sut = new AppraisalOrderComponent.DA();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		//system.assert(errorMsg.contains(fieldMap.get('Zoning_Classification__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Projected_Number_of_Residential_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Utilities__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_DA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'DA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.DA sut = new AppraisalOrderComponent.DA();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		//system.assert(errorMsg.contains(fieldMap.get('Zoning_Classification__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Projected_Number_of_Residential_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Utilities__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_DA(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.DA sut = new AppraisalOrderComponent.DA();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		//oreo.put('Zoning_Classification__c', Utility.getValidFieldValue(fieldMap.get('Zoning_Classification__c').getDescribe().getType()));
		oreo.put('Projected_Number_of_Residential_Lots__c', Utility.getValidFieldValue(fieldMap.get('Projected_Number_of_Residential_Lots__c').getDescribe().getType()));
		oreo.put('Utilities__c', Utility.getValidFieldValue(fieldMap.get('Utilities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_DA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'DA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.DA sut = new AppraisalOrderComponent.DA();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		//testCollateral.put('Zoning_Classification__c', Utility.getValidFieldValue(fieldMap.get('Zoning_Classification__c').getDescribe().getType()));
		testCollateral.put('Projected_Number_of_Residential_Lots__c', Utility.getValidFieldValue(fieldMap.get('Projected_Number_of_Residential_Lots__c').getDescribe().getType()));
		testCollateral.put('Utilities__c', Utility.getValidFieldValue(fieldMap.get('Utilities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CH_IH(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CH_IH sut = new AppraisalOrderComponent.CH_IH();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Gross_Bldg_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Stories__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_Occupied__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Tenants__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CH(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CH');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CH_IH sut = new AppraisalOrderComponent.CH_IH();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Gross_Bldg_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Stories__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_Occupied__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Tenants__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IH(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IH');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CH_IH sut = new AppraisalOrderComponent.CH_IH();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Gross_Bldg_Area__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Stories__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Percent_Occupied__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Tenants__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Year_Built__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Buildings__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CH_IH(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CH_IH sut = new AppraisalOrderComponent.CH_IH();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Gross_Bldg_Area__c', Utility.getValidFieldValue(fieldMap.get('Gross_Bldg_Area__c').getDescribe().getType()));
		oreo.put('Rentable_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getType()));
		oreo.put('Number_of_Stories__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Stories__c').getDescribe().getType()));
		oreo.put('Percent_Occupied__c', Utility.getValidFieldValue(fieldMap.get('Percent_Occupied__c').getDescribe().getType()));
		oreo.put('Number_of_Tenants__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Tenants__c').getDescribe().getType()));
		oreo.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		oreo.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CH(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CH');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CH_IH sut = new AppraisalOrderComponent.CH_IH();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Gross_Bldg_Area__c', Utility.getValidFieldValue(fieldMap.get('Gross_Bldg_Area__c').getDescribe().getType()));
		testCollateral.put('Rentable_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getType()));
		testCollateral.put('Number_of_Stories__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Stories__c').getDescribe().getType()));
		testCollateral.put('Percent_Occupied__c', Utility.getValidFieldValue(fieldMap.get('Percent_Occupied__c').getDescribe().getType()));
		testCollateral.put('Number_of_Tenants__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Tenants__c').getDescribe().getType()));
		testCollateral.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));

		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IH(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IH');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CH_IH sut = new AppraisalOrderComponent.CH_IH();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Gross_Bldg_Area__c', Utility.getValidFieldValue(fieldMap.get('Gross_Bldg_Area__c').getDescribe().getType()));
		testCollateral.put('Rentable_Sq_Ft__c', Utility.getValidFieldValue(fieldMap.get('Rentable_Sq_Ft__c').getDescribe().getType()));
		testCollateral.put('Number_of_Stories__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Stories__c').getDescribe().getType()));
		testCollateral.put('Percent_Occupied__c', Utility.getValidFieldValue(fieldMap.get('Percent_Occupied__c').getDescribe().getType()));
		testCollateral.put('Number_of_Tenants__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Tenants__c').getDescribe().getType()));
		testCollateral.put('Year_Built__c', Utility.getValidFieldValue(fieldMap.get('Year_Built__c').getDescribe().getType()));
		testCollateral.put('Number_of_Buildings__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Buildings__c').getDescribe().getType()));

		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_AB(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.AB sut = new AppraisalOrderComponent.AB();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		//system.assert(errorMsg.contains(fieldMap.get('Zoning_Classification__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Projected_Number_of_Commercial_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Utilities__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_AB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'AB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.AB sut = new AppraisalOrderComponent.AB();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		//system.assert(errorMsg.contains(fieldMap.get('Zoning_Classification__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Projected_Number_of_Commercial_Lots__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Utilities__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_AB(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.AB sut = new AppraisalOrderComponent.AB();
		
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		//oreo.put('Zoning_Classification__c', Utility.getValidFieldValue(fieldMap.get('Zoning_Classification__c').getDescribe().getType()));
		oreo.put('Projected_Number_of_Commercial_Lots__c', Utility.getValidFieldValue(fieldMap.get('Projected_Number_of_Commercial_Lots__c').getDescribe().getType()));
		oreo.put('Utilities__c', Utility.getValidFieldValue(fieldMap.get('Utilities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_AB(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'AB');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.AB sut = new AppraisalOrderComponent.AB();
		
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		//testCollateral.put('Zoning_Classification__c', Utility.getValidFieldValue(fieldMap.get('Zoning_Classification__c').getDescribe().getType()));
		testCollateral.put('Projected_Number_of_Commercial_Lots__c', Utility.getValidFieldValue(fieldMap.get('Projected_Number_of_Commercial_Lots__c').getDescribe().getType()));
		testCollateral.put('Utilities__c', Utility.getValidFieldValue(fieldMap.get('Utilities__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CL_IL(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CL_IL sut = new AppraisalOrderComponent.CL_IL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Golf_Course__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_Of_Holes__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Privacy__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities_for_Golf_Course__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CL(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CL');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CL_IL sut = new AppraisalOrderComponent.CL_IL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Golf_Course__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_Of_Holes__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Privacy__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities_for_Golf_Course__c').getDescribe().getLabel()));
	}	
	
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IL(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IL');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CL_IL sut = new AppraisalOrderComponent.CL_IL();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Name_of_Golf_Course__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_Of_Holes__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Privacy__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Amenities_for_Golf_Course__c').getDescribe().getLabel()));
	}

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CL_IL(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CL_IL sut = new AppraisalOrderComponent.CL_IL();
		
		oreo.put('Name_of_Golf_Course__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Golf_Course__c').getDescribe().getType()));
		oreo.put('Number_Of_Holes__c', Utility.getValidFieldValue(fieldMap.get('Number_Of_Holes__c').getDescribe().getType()));
		oreo.put('Privacy__c', Utility.getValidFieldValue(fieldMap.get('Privacy__c').getDescribe().getType()));
		oreo.put('Amenities_for_Golf_Course__c', Utility.getValidFieldValue(fieldMap.get('Amenities_for_Golf_Course__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CL(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CL');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CL_IL sut = new AppraisalOrderComponent.CL_IL();
		
		testCollateral.put('Name_of_Golf_Course__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Golf_Course__c').getDescribe().getType()));
		testCollateral.put('Number_Of_Holes__c', Utility.getValidFieldValue(fieldMap.get('Number_Of_Holes__c').getDescribe().getType()));
		testCollateral.put('Privacy__c', Utility.getValidFieldValue(fieldMap.get('Privacy__c').getDescribe().getType()));
		testCollateral.put('Amenities_for_Golf_Course__c', Utility.getValidFieldValue(fieldMap.get('Amenities_for_Golf_Course__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	
		
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IL(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IL');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CL_IL sut = new AppraisalOrderComponent.CL_IL();
		
		testCollateral.put('Name_of_Golf_Course__c', Utility.getValidFieldValue(fieldMap.get('Name_of_Golf_Course__c').getDescribe().getType()));
		testCollateral.put('Number_Of_Holes__c', Utility.getValidFieldValue(fieldMap.get('Number_Of_Holes__c').getDescribe().getType()));
		testCollateral.put('Privacy__c', Utility.getValidFieldValue(fieldMap.get('Privacy__c').getDescribe().getType()));
		testCollateral.put('Amenities_for_Golf_Course__c', Utility.getValidFieldValue(fieldMap.get('Amenities_for_Golf_Course__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_FC(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.FC sut = new AppraisalOrderComponent.FC();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Contract_Amount_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Legal_Name_of_Subdivision__c').getDescribe().getLabel()));
		//system.assert(errorMsg.contains(fieldMap.get('Lot_Number__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_FC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'FC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.FC sut = new AppraisalOrderComponent.FC();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Contract_Amount_of_House__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Legal_Name_of_Subdivision__c').getDescribe().getLabel()));
		//system.assert(errorMsg.contains(fieldMap.get('Lot_Number__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_FC(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.FC sut = new AppraisalOrderComponent.FC();
		
		oreo.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		oreo.put('Contract_Amount_of_House__c', Utility.getValidFieldValue(fieldMap.get('Contract_Amount_of_House__c').getDescribe().getType()));
		oreo.put('Legal_Name_of_Subdivision__c', Utility.getValidFieldValue(fieldMap.get('Legal_Name_of_Subdivision__c').getDescribe().getType()));
		oreo.put('Lot_Number__c', Utility.getValidFieldValue(fieldMap.get('Lot_Number__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_FC(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'FC');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.FC sut = new AppraisalOrderComponent.FC();
		
		testCollateral.put('Sq_Ft_of_House__c', Utility.getValidFieldValue(fieldMap.get('Sq_Ft_of_House__c').getDescribe().getType()));
		testCollateral.put('Contract_Amount_of_House__c', Utility.getValidFieldValue(fieldMap.get('Contract_Amount_of_House__c').getDescribe().getType()));
		testCollateral.put('Legal_Name_of_Subdivision__c', Utility.getValidFieldValue(fieldMap.get('Legal_Name_of_Subdivision__c').getDescribe().getType()));
		testCollateral.put('Lot_Number__c', Utility.getValidFieldValue(fieldMap.get('Lot_Number__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CV_IV(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CV_IV sut = new AppraisalOrderComponent.CV_IV();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Car_Wash__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Car_Wash_Equipment_Type__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Bays__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CV(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CV');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CV_IV sut = new AppraisalOrderComponent.CV_IV();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Car_Wash__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Car_Wash_Equipment_Type__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Bays__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
	}	

	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_IV(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IV');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CV_IV sut = new AppraisalOrderComponent.CV_IV();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Car_Wash__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Car_Wash_Equipment_Type__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Bays__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
	}
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CV_IV(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CV_IV sut = new AppraisalOrderComponent.CV_IV();
		
		oreo.put('Type_of_Car_Wash__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Car_Wash__c').getDescribe().getType()));
		oreo.put('Car_Wash_Equipment_Type__c', Utility.getValidFieldValue(fieldMap.get('Car_Wash_Equipment_Type__c').getDescribe().getType()));
		oreo.put('Number_of_Bays__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Bays__c').getDescribe().getType()));
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CV(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CV');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CV_IV sut = new AppraisalOrderComponent.CV_IV();
		
		testCollateral.put('Type_of_Car_Wash__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Car_Wash__c').getDescribe().getType()));
		testCollateral.put('Car_Wash_Equipment_Type__c', Utility.getValidFieldValue(fieldMap.get('Car_Wash_Equipment_Type__c').getDescribe().getType()));
		testCollateral.put('Number_of_Bays__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Bays__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	

	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_IV(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'IV');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CV_IV sut = new AppraisalOrderComponent.CV_IV();
		
		testCollateral.put('Type_of_Car_Wash__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Car_Wash__c').getDescribe().getType()));
		testCollateral.put('Car_Wash_Equipment_Type__c', Utility.getValidFieldValue(fieldMap.get('Car_Wash_Equipment_Type__c').getDescribe().getType()));
		testCollateral.put('Number_of_Bays__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Bays__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}
		
		
	private static testMethod void it_should_return_error_for_missing_data_for_OREO_for_collat_code_CA(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CA sut = new AppraisalOrderComponent.CA();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Mobile_Home_Pads__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Mobile_Home_Park_Rating__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Septic_Tank__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('City_Sewer__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('City_Water__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Well_Water__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Pad__c').getDescribe().getLabel()));
		//system.assert(errorMsg.contains(fieldMap.get('Other_Type_of_Pad__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_return_error_for_missing_data_for_collat_code_CA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CA sut = new AppraisalOrderComponent.CA();
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assert(errorMsg.contains(fieldMap.get('Number_of_Mobile_Home_Pads__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Mobile_Home_Park_Rating__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Septic_Tank__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('City_Sewer__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('City_Water__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Well_Water__c').getDescribe().getLabel()));
		system.assert(errorMsg.contains(fieldMap.get('Type_of_Pad__c').getDescribe().getLabel()));
		//system.assert(errorMsg.contains(fieldMap.get('Other_Type_of_Pad__c').getDescribe().getLabel()));
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_OREO_for_collat_code_CA(){	
		EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
		testAppraisalOrder.OREO_Account__c = oreo.Id;
		testAppraisalOrder.OREO_Account__r = oreo;
		AppraisalOrderComponent.CA sut = new AppraisalOrderComponent.CA();
		
		oreo.put('Number_of_Mobile_Home_Pads__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Mobile_Home_Pads__c').getDescribe().getType()));
		oreo.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		oreo.put('Mobile_Home_Park_Rating__c', Utility.getValidFieldValue(fieldMap.get('Mobile_Home_Park_Rating__c').getDescribe().getType()));
		oreo.put('Septic_Tank__c', Utility.getValidFieldValue(fieldMap.get('Septic_Tank__c').getDescribe().getType()));
		oreo.put('City_Sewer__c', Utility.getValidFieldValue(fieldMap.get('City_Sewer__c').getDescribe().getType()));
		oreo.put('City_Water__c', Utility.getValidFieldValue(fieldMap.get('City_Water__c').getDescribe().getType()));
		oreo.put('Well_Water__c', Utility.getValidFieldValue(fieldMap.get('Well_Water__c').getDescribe().getType()));
		oreo.put('Type_of_Pad__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Pad__c').getDescribe().getType()));
		oreo.put('Other_Type_of_Pad__c', Utility.getValidFieldValue(fieldMap.get('Other_Type_of_Pad__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
		
	private static testMethod void it_should_not_return_error_if_no_missing_data_for_collat_code_CA(){	
		Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
		Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'CA');
		EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
		testAppraisalOrder.Related_Collateral__r = testCollateral;
		AppraisalOrderComponent.CA sut = new AppraisalOrderComponent.CA();
		
		testCollateral.put('Number_of_Mobile_Home_Pads__c', Utility.getValidFieldValue(fieldMap.get('Number_of_Mobile_Home_Pads__c').getDescribe().getType()));
		testCollateral.put('Total_Land_Area_Acres__c', Utility.getValidFieldValue(fieldMap.get('Total_Land_Area_Acres__c').getDescribe().getType()));
		testCollateral.put('Mobile_Home_Park_Rating__c', Utility.getValidFieldValue(fieldMap.get('Mobile_Home_Park_Rating__c').getDescribe().getType()));
		testCollateral.put('Septic_Tank__c', Utility.getValidFieldValue(fieldMap.get('Septic_Tank__c').getDescribe().getType()));
		testCollateral.put('City_Sewer__c', Utility.getValidFieldValue(fieldMap.get('City_Sewer__c').getDescribe().getType()));
		testCollateral.put('City_Water__c', Utility.getValidFieldValue(fieldMap.get('City_Water__c').getDescribe().getType()));
		testCollateral.put('Well_Water__c', Utility.getValidFieldValue(fieldMap.get('Well_Water__c').getDescribe().getType()));
		testCollateral.put('Type_of_Pad__c', Utility.getValidFieldValue(fieldMap.get('Type_of_Pad__c').getDescribe().getType()));
		testCollateral.put('Other_Type_of_Pad__c', Utility.getValidFieldValue(fieldMap.get('Other_Type_of_Pad__c').getDescribe().getType()));
		
		String errorMsg = sut.getComponentFieldValidationError(testAppraisalOrder);
		
		system.assertEquals('',errorMsg);
	}	
}