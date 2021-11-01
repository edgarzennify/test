public class TmFeeCalculatorDataProvider implements TmFeeCalculator.IDataProvider {
    
    public List<Tm_fee__c> getAllFees(){ 
        return [
            SELECT
            	Id
                ,Fee_Amount__c
                ,Fee_API_Name__c
                ,TM_Fee_Schedule__c
            	,Feature_Fee_Dependency__c
            	,TM_Fee_Schedule__r.TM_Product__r.Name
            	,TM_Fee_Schedule__r.bundle_type__c
            	,TM_Fee_Schedule__r.Client_type__c
            FROM
            	TM_Fee__c                
        ];        
    }   
    public List<Tm_Service_Request_Packet__c> getAllPackets(){
    	return [
            SELECT
            	Id
                ,Client_Type__c
                ,Bundle_Type__c
            FROM
            	Tm_Service_Request_Packet__c               
        ];        
    }
    public List<Tm_Fee_Schedule__c> getAllSchedules(){ 
    	return [
            SELECT
            	Id
                ,Client_Type__c
                ,Bundle_Type__c
            	,Tm_Product__c
            	,Tm_Product__r.Name
            FROM
            	Tm_Fee_Schedule__c               
        ];        
    }
    public List<Tm_Product__c> getAllProducts(){ 
    	return [
            SELECT
            	Id
                ,Name
            FROM
            	Tm_Product__c               
        ];        
    }
    public List<Tm_Service_Request__c> getAllRequests(){ 
        return [
            SELECT
            	Id
            	,RecordType.Name
            	,Tm_Service_Request_Packet__c
            	,Tm_Service_Request_Packet__r.Client_Type__c
            	,Tm_Service_Request_Packet__r.Bundle_Type__c
            	,Tm_Fee__c
            	,Stage__c
            	,ACH_Pass_Thru__c
            	,fieldValue_Cycle_Monthly__c
            	,fieldValue_Cycle_Annual__c
            	,Commercial_Bill_Pay__c
            	,Corporate_OLB_fx__c
            	,Domestic_Wires__c
            	,International_Wires__c
            	,RemoteDeposit_Desktop__c
            	,RemoteDeposit_Mobile__c
            	,fieldValue_PP_Type_Reverse__c
            	,fieldValue_PP_Type_Conventional__c
            	,fieldValue_PP_Type_Payee__c
            	,Remittance_Imaging__c
            	,Data_Entry__c
            	,Data_Extract__c
            	,fieldValue_Sweep_Type_Goldman_Sachs__c
            	,fieldValue_Sweep_Type_Money_Market__c
            	,fieldValue_Sweep_Type_Repo__c
            	,fieldValue_Sweep_Type_Optima_Plus__c
            	,Loan_Sweep__c
	            ,LoanInvestment_Sweep__c
            	,PP_Automation_Setup_Fee__c
            	,File_Automation_Wizard_Set_Up__c
            	,Automated_File_Creation_Set_Up__c
            	,Commercial_Banking_fx__c
            	,Business_Banking_fx__c
            	,ACH_FTP__c
            	,Same_Day_ACH_Addendum__c
            	,fieldValue_Accounting_Package_None__c
            	,fieldValue_Accounting_Package_50_250__c
            	,fieldValue_Accounting_Package_150_2500__c
            	,Check_EAP_Payment_Method__c
            	,Credit_P_Card_EAP_Payment_Method__c
            	,ACH_EAP_Payment_Method__c
            	,fieldValue_Invoice_Capture_Full_Capture__c
            	,fieldValue_Invoice_Capture_HeaderCapture__c
            	,fieldValue_Cycle_Semi_Annually__c
            	,Enroll_in_text_message_notifications__c
            	,fieldValue_Other_Product_Custom_FTP__c
            	
            FROM
            	Tm_Service_Request__c                
        ];        
    }
    public List<TM_Service_Request_Stage__c> getAllStages(){ 
    	return [
            SELECT
            	Id
                ,Name
            FROM
            	TM_Service_Request_Stage__c               
        ];        
    }
}