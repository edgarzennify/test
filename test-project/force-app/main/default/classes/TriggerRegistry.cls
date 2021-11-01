public class TriggerRegistry {
	private static Map<Schema.SObjectType, Type> registry{
        get{ 
            Map<Schema.SObjectType, Type> reg = new Map<Schema.SObjectType, Type>();

            reg.put(Account.sObjectType, AccountTriggerHandler.class);
            //reg.put(Case.sObjectType, CaseTriggerHandler.class);
            reg.put(Contact.sObjectType, ContactTriggerHandler.class);
            reg.put(Credit_Relationship__c.sObjectType, CreditRelationshipTriggerHandler.class);
            reg.put(EB_Appraisal_Order__c.sObjectType, EbAppraisalOrderTriggerHandler.class);
            reg.put(EB_Collateral__c.sObjectType, CollateralTriggerHandler.class);
            reg.put(Eb_Event_Attendees__c.sObjectType, EventAttendeeTriggerHandler.class); 
            reg.put(EB_Loan_Application__c.sObjectType, LoanApplicationTriggerHandler.class);
            reg.put(EB_Loan_App_Collateral_Relationship__c.sObjectType, LoanAppCollRelTriggerHandler.class);
            reg.put(EB_Loan_Participation__c.sObjectType, LoanParticTriggerHandler.class);
            //reg.put(Implementation_Form__c.sObjectType, ImplementationFormTriggerHandler.class);
            //reg.put(IT_Request__c.sObjectType, ITRequestTriggerHandler.class);
            reg.put(Lead.sObjectType, LeadTriggerHandler.class);
            reg.put(LLC_BI__Collateral__c.sObjectType, LLCBI_CollateralTriggerHandler.class);
            reg.put(LLC_BI__Loan__c.sObjectType, LLCBI_LoanTriggerHandler.class);
            reg.put(LLC_BI__Product_Package__c.sOBjectType, ProductPackageTriggerHandler.class); 
            reg.put(Modification_Request__c.sObjectType, ModificationRequestTriggerHandler.class);
            reg.put(More_Loan__c.SObjectType, MoreLoanTriggerHandler.class);
            reg.put(Opportunity.sObjectType, OpportunityTriggerHandler.class);
            reg.put(Task.sOBjectType, TaskTriggerHandler.class);
            reg.put(TM_Fee__c.sOBjectType, TmFeeTriggerHandler.class);
            reg.put(TM_Fee_Schedule__c.sOBjectType, TmFeeScheduleTriggerHandler.class);
            reg.put(TM_Maintenance__c.sOBjectType, TmMaintenanceTriggerHandler.class);
            reg.put(TM_Service_Request__c.sOBjectType, TmServiceRequestTriggerHandler.class);
            reg.put(TM_Service_Request_Packet__c.sOBjectType, TMServiceRequestPacketTriggerHandler.class);
            reg.put(Entity_Action__c.sOBjectType, EntityActionTriggerHandler.class);
            reg.put(Payment_Decision__c.sObjectType, PaymentDecisionTriggerHandler.class);
            
            

            return reg;
        }
    }
    
    public static ITrigger getHandlerByType(Schema.SObjectType soType){
        Type handlerType = registry.get(soType);
        return (ITrigger)handlerType.newInstance();
    }
}