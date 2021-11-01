public with sharing class AppraisalOrderComponent {
    public interface IAppraisalOrderComponent{
        ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder);
        Boolean handlesCollateralCode(String collateralCode);
        List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> getAppraisalOrderSummary(EB_Appraisal_Order__c appraisalOrder);
        String getComponentFieldValidationError(EB_Appraisal_Order__c appraisalOrder);
    }

    public abstract class BaseComponent{
      protected abstract Set<String> handledCollateralCodes();
      protected abstract Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder);
      protected abstract Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder);

      public Boolean handlesCollateralCode(String collateralCode){
          return handledCollateralCodes().contains(collateralCode);
      }  

      public List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> getAppraisalOrderSummary(EB_Appraisal_Order__c appraisalOrder){
        List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnList = new List<AppraisalOrders.AppraisalOrderSummaryFieldDetails>();
        Map<String, Schema.SobjectField> fieldMap = Schema.getGlobalDescribe().get('EB_Collateral__c').getDescribe().fields.getMap();
        Map<String, Object> summaryFieldMap = summaryFields(isOreo(appraisalOrder), appraisalOrder);
        for(String key : summaryFieldMap.keySet()){
          String label = fieldMap.get(key).getDescribe().getLabel();
          String value = String.valueOf(summaryFieldMap.get(key));
          returnList.add(new AppraisalOrders.AppraisalOrderSummaryFieldDetails(label + ' - ', value));
        }
        return returnList;
      } 

      public String getComponentFieldValidationError(EB_Appraisal_Order__c appraisalOrder){ 
        String errorMessage = '';
        Map<String, Schema.SobjectField> fieldMap = Schema.getGlobalDescribe().get('EB_Collateral__c').getDescribe().fields.getMap();   
        Map<String, Object> requiredFieldMap = requiredFields(isOreo(appraisalOrder), appraisalOrder);
        for(String key : requiredFieldMap.keySet()){
            if(Utility.isFieldEmpty(fieldMap.get(key).getDescribe().getType(), requiredFieldMap.get(key))){  
              errorMessage += fieldMap.get(key).getDescribe().getLabel() + ';  ';
            }
        }
        return errorMessage; 
      }  

      private Boolean isOreo(EB_Appraisal_Order__c appraisalOrder){
        return (appraisalOrder.OREO_Account__r != null) ? true : false;   
      }
    }

/////////////////////////////////////////////////////

    public class AA extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_AA(appraisalOrder=appraisalOrder);
      }
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'AA'};
      }
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c, 
            'Zoning_Classification__c' => appraisalOrder.OREO_Account__r.Zoning_Classification__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c, 
            'Zoning_Classification__c' => appraisalOrder.Related_Collateral__r.Zoning_Classification__c
          };
        }
      }
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c, 
            'Zoning_Classification__c' => appraisalOrder.OREO_Account__r.Zoning_Classification__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c, 
            'Zoning_Classification__c' => appraisalOrder.Related_Collateral__r.Zoning_Classification__c
          };
        }
      }
    } 

    public class AB extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_AB(appraisalOrder=appraisalOrder);
      }  

      protected override Set<String> handledCollateralCodes(){    
        return new Set<String>{'AB'};
      }   

      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Zoning_Classification__c' => appraisalOrder.OREO_Account__r.Zoning_Classification__c,
            'Projected_Number_of_Commercial_Lots__c' => appraisalOrder.OREO_Account__r.Projected_Number_of_Commercial_Lots__c,
            'Utilities__c' => appraisalOrder.OREO_Account__r.Utilities__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Zoning_Classification__c' => appraisalOrder.Related_Collateral__r.Zoning_Classification__c,
            'Projected_Number_of_Commercial_Lots__c' => appraisalOrder.Related_Collateral__r.Projected_Number_of_Commercial_Lots__c,
            'Utilities__c' => appraisalOrder.Related_Collateral__r.Utilities__c
          };
        }
      }

      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Projected_Number_of_Commercial_Lots__c' => appraisalOrder.OREO_Account__r.Projected_Number_of_Commercial_Lots__c,
            'Utilities__c' => appraisalOrder.OREO_Account__r.Utilities__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Projected_Number_of_Commercial_Lots__c' => appraisalOrder.Related_Collateral__r.Projected_Number_of_Commercial_Lots__c,
            'Utilities__c' => appraisalOrder.Related_Collateral__r.Utilities__c
          };
        }
      }
    }

    public class AC extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_AC(appraisalOrder=appraisalOrder);
      } 

      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'AC'};
      }

      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Acres_Res_Single_Fam__c' => appraisalOrder.OREO_Account__r.Number_of_Acres_Res_Single_Fam__c,      
            'Number_of_Acres_Com_Office__c' => appraisalOrder.OREO_Account__r.Number_of_Acres_Com_Office__c,
            'Number_of_Acres_Industrial__c' => appraisalOrder.OREO_Account__r.Number_of_Acres_Industrial__c,
            'Number_of_Acres_Retail__c' => appraisalOrder.OREO_Account__r.Number_of_Acres_Retail__c,      
            'Land_Improvements__c' => appraisalOrder.OREO_Account__r.Land_Improvements__c,
            'Describe_Improvements__c' => appraisalOrder.OREO_Account__r.Describe_Improvements__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Acres_Res_Single_Fam__c' => appraisalOrder.Related_Collateral__r.Number_of_Acres_Res_Single_Fam__c,
            'Number_of_Acres_Com_Office__c' => appraisalOrder.Related_Collateral__r.Number_of_Acres_Com_Office__c,
            'Number_of_Acres_Industrial__c' => appraisalOrder.Related_Collateral__r.Number_of_Acres_Industrial__c,
            'Number_of_Acres_Retail__c' => appraisalOrder.Related_Collateral__r.Number_of_Acres_Retail__c,      
            'Land_Improvements__c' => appraisalOrder.Related_Collateral__r.Land_Improvements__c,      
            'Describe_Improvements__c' => appraisalOrder.Related_Collateral__r.Describe_Improvements__c
          };
        }
      }

      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Acres_Res_Single_Fam__c' => appraisalOrder.OREO_Account__r.Number_of_Acres_Res_Single_Fam__c,      
            'Number_of_Acres_Com_Office__c' => appraisalOrder.OREO_Account__r.Number_of_Acres_Com_Office__c,
            'Number_of_Acres_Industrial__c' => appraisalOrder.OREO_Account__r.Number_of_Acres_Industrial__c,
            'Number_of_Acres_Retail__c' => appraisalOrder.OREO_Account__r.Number_of_Acres_Retail__c,      
            'Land_Improvements__c' => appraisalOrder.OREO_Account__r.Land_Improvements__c,
            'Describe_Improvements__c' => appraisalOrder.OREO_Account__r.Describe_Improvements__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Acres_Res_Single_Fam__c' => appraisalOrder.Related_Collateral__r.Number_of_Acres_Res_Single_Fam__c,
            'Number_of_Acres_Com_Office__c' => appraisalOrder.Related_Collateral__r.Number_of_Acres_Com_Office__c,
            'Number_of_Acres_Industrial__c' => appraisalOrder.Related_Collateral__r.Number_of_Acres_Industrial__c,
            'Number_of_Acres_Retail__c' => appraisalOrder.Related_Collateral__r.Number_of_Acres_Retail__c,      
            'Land_Improvements__c' => appraisalOrder.Related_Collateral__r.Land_Improvements__c,      
            'Describe_Improvements__c' => appraisalOrder.Related_Collateral__r.Describe_Improvements__c
          };
        }
      }
    }

    public class BC extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_BC(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'BC'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Commercial_Lots__c' => appraisalOrder.OREO_Account__r.Number_of_Commercial_Lots__c,
            'Zoning_Classification__c' => appraisalOrder.OREO_Account__r.Zoning_Classification__c,
            'Land_Improvements__c' => appraisalOrder.OREO_Account__r.Land_Improvements__c,            
            'Describe_Improvements__c' => appraisalOrder.OREO_Account__r.Describe_Improvements__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Commercial_Lots__c' => appraisalOrder.Related_Collateral__r.Number_of_Commercial_Lots__c,
            'Zoning_Classification__c' => appraisalOrder.Related_Collateral__r.Zoning_Classification__c,
            'Land_Improvements__c' => appraisalOrder.Related_Collateral__r.Land_Improvements__c,            
            'Describe_Improvements__c' => appraisalOrder.Related_Collateral__r.Describe_Improvements__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Commercial_Lots__c' => appraisalOrder.OREO_Account__r.Number_of_Commercial_Lots__c,
            'Zoning_Classification__c' => appraisalOrder.OREO_Account__r.Zoning_Classification__c,
            'Land_Improvements__c' => appraisalOrder.OREO_Account__r.Land_Improvements__c,            
            'Describe_Improvements__c' => appraisalOrder.OREO_Account__r.Describe_Improvements__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Commercial_Lots__c' => appraisalOrder.Related_Collateral__r.Number_of_Commercial_Lots__c,
            'Zoning_Classification__c' => appraisalOrder.Related_Collateral__r.Zoning_Classification__c,
            'Land_Improvements__c' => appraisalOrder.Related_Collateral__r.Land_Improvements__c,            
            'Describe_Improvements__c' => appraisalOrder.Related_Collateral__r.Describe_Improvements__c
          };
        }
      }
    }


    public class CA extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CA(appraisalOrder=appraisalOrder);
      } 
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CA'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Number_of_Mobile_Home_Pads__c' => appraisalOrder.OREO_Account__r.Number_of_Mobile_Home_Pads__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Mobile_Home_Park_Rating__c' => appraisalOrder.OREO_Account__r.Mobile_Home_Park_Rating__c,
            'Septic_Tank__c' => appraisalOrder.OREO_Account__r.Septic_Tank__c,
            'City_Sewer__c' => appraisalOrder.OREO_Account__r.City_Sewer__c,
            'City_Water__c' => appraisalOrder.OREO_Account__r.City_Water__c,
            'Well_Water__c' => appraisalOrder.OREO_Account__r.Well_Water__c,
            'Type_of_Pad__c' => appraisalOrder.OREO_Account__r.Type_of_Pad__c,
            'Other_Type_of_Pad__c' => appraisalOrder.OREO_Account__r.Other_Type_of_Pad__c
          };
        }else{
          return new Map<String, Object>{
            'Number_of_Mobile_Home_Pads__c' => appraisalOrder.Related_Collateral__r.Number_of_Mobile_Home_Pads__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Mobile_Home_Park_Rating__c' => appraisalOrder.Related_Collateral__r.Mobile_Home_Park_Rating__c,
            'Septic_Tank__c' => appraisalOrder.Related_Collateral__r.Septic_Tank__c,
            'City_Sewer__c' => appraisalOrder.Related_Collateral__r.City_Sewer__c,
            'City_Water__c' => appraisalOrder.Related_Collateral__r.City_Water__c,
            'Well_Water__c' => appraisalOrder.Related_Collateral__r.Well_Water__c,
            'Type_of_Pad__c' => appraisalOrder.Related_Collateral__r.Type_of_Pad__c,
            'Other_Type_of_Pad__c' => appraisalOrder.Related_Collateral__r.Other_Type_of_Pad__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Number_of_Mobile_Home_Pads__c' => appraisalOrder.OREO_Account__r.Number_of_Mobile_Home_Pads__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Mobile_Home_Park_Rating__c' => appraisalOrder.OREO_Account__r.Mobile_Home_Park_Rating__c,
            'Septic_Tank__c' => appraisalOrder.OREO_Account__r.Septic_Tank__c,
            'City_Sewer__c' => appraisalOrder.OREO_Account__r.City_Sewer__c,
            'City_Water__c' => appraisalOrder.OREO_Account__r.City_Water__c,
            'Well_Water__c' => appraisalOrder.OREO_Account__r.Well_Water__c,
            'Type_of_Pad__c' => appraisalOrder.OREO_Account__r.Type_of_Pad__c,
            'Other_Type_of_Pad__c' => appraisalOrder.OREO_Account__r.Other_Type_of_Pad__c
          };
        }else{
          return new Map<String, Object>{
            'Number_of_Mobile_Home_Pads__c' => appraisalOrder.Related_Collateral__r.Number_of_Mobile_Home_Pads__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Mobile_Home_Park_Rating__c' => appraisalOrder.Related_Collateral__r.Mobile_Home_Park_Rating__c,
            'Septic_Tank__c' => appraisalOrder.Related_Collateral__r.Septic_Tank__c,
            'City_Sewer__c' => appraisalOrder.Related_Collateral__r.City_Sewer__c,
            'City_Water__c' => appraisalOrder.Related_Collateral__r.City_Water__c,
            'Well_Water__c' => appraisalOrder.Related_Collateral__r.Well_Water__c,
            'Type_of_Pad__c' => appraisalOrder.Related_Collateral__r.Type_of_Pad__c,
            'Other_Type_of_Pad__c' => appraisalOrder.Related_Collateral__r.Other_Type_of_Pad__c
          };
        }
      }
    }

    public class CB_CQ_IQ_CT_IT extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CB_CQ_IQ_CT_IT(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CB','CQ','IQ','CT','IT'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Type_of_Use__c' => appraisalOrder.OREO_Account__r.Type_of_Use__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_all_Buildings__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_all_Buildings__c,
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,            
            'Existing__c' => appraisalOrder.OREO_Account__r.Existing__c
          };
        }else{
          return new Map<String, Object>{
            'Type_of_Use__c' => appraisalOrder.Related_Collateral__r.Type_of_Use__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_all_Buildings__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_all_Buildings__c,
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,            
            'Existing__c' => appraisalOrder.Related_Collateral__r.Existing__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Type_of_Use__c' => appraisalOrder.OREO_Account__r.Type_of_Use__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_all_Buildings__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_all_Buildings__c,
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,            
            'Existing__c' => appraisalOrder.OREO_Account__r.Existing__c
          };
        }else{
          return new Map<String, Object>{
            'Type_of_Use__c' => appraisalOrder.Related_Collateral__r.Type_of_Use__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_all_Buildings__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_all_Buildings__c,
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,            
            'Existing__c' => appraisalOrder.Related_Collateral__r.Existing__c
          };
        }
      }
    }

    public class CC_CD extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CC_CD(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CC','CD'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Flag_Brand_of_Hotel_Motel__c' => appraisalOrder.OREO_Account__r.Flag_Brand_of_Hotel_Motel__c,
            'Number_of_Rooms__c' => appraisalOrder.OREO_Account__r.Number_of_Rooms__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_Building__c,
            'Free_Standing__c' => appraisalOrder.OREO_Account__r.Free_Standing__c,
            'Limited_Service__c' => appraisalOrder.OREO_Account__r.Limited_Service__c,
            'Full_Service__c' => appraisalOrder.OREO_Account__r.Full_Service__c,
            'Resort__c' => appraisalOrder.OREO_Account__r.Resort__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,
            'Existing__c' => appraisalOrder.OREO_Account__r.Existing__c,            
            'Rehabilitation__c' => appraisalOrder.OREO_Account__r.Rehabilitation__c
          };
        }else{
          return new Map<String, Object>{
            'Flag_Brand_of_Hotel_Motel__c' => appraisalOrder.Related_Collateral__r.Flag_Brand_of_Hotel_Motel__c,
            'Number_of_Rooms__c' => appraisalOrder.Related_Collateral__r.Number_of_Rooms__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_Building__c,
            'Free_Standing__c' => appraisalOrder.Related_Collateral__r.Free_Standing__c,
            'Limited_Service__c' => appraisalOrder.Related_Collateral__r.Limited_Service__c,
            'Full_Service__c' => appraisalOrder.Related_Collateral__r.Full_Service__c,
            'Resort__c' => appraisalOrder.Related_Collateral__r.Resort__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,
            'Existing__c' => appraisalOrder.Related_Collateral__r.Existing__c,            
            'Rehabilitation__c' => appraisalOrder.Related_Collateral__r.Rehabilitation__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Flag_Brand_of_Hotel_Motel__c' => appraisalOrder.OREO_Account__r.Flag_Brand_of_Hotel_Motel__c,
            'Number_of_Rooms__c' => appraisalOrder.OREO_Account__r.Number_of_Rooms__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_Building__c,
            'Free_Standing__c' => appraisalOrder.OREO_Account__r.Free_Standing__c,
            'Limited_Service__c' => appraisalOrder.OREO_Account__r.Limited_Service__c,
            'Full_Service__c' => appraisalOrder.OREO_Account__r.Full_Service__c,
            'Resort__c' => appraisalOrder.OREO_Account__r.Resort__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,
            'Existing__c' => appraisalOrder.OREO_Account__r.Existing__c,            
            'Rehabilitation__c' => appraisalOrder.OREO_Account__r.Rehabilitation__c
          };
        }else{
          return new Map<String, Object>{
            'Flag_Brand_of_Hotel_Motel__c' => appraisalOrder.Related_Collateral__r.Flag_Brand_of_Hotel_Motel__c,
            'Number_of_Rooms__c' => appraisalOrder.Related_Collateral__r.Number_of_Rooms__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_Building__c,
            'Free_Standing__c' => appraisalOrder.Related_Collateral__r.Free_Standing__c,
            'Limited_Service__c' => appraisalOrder.Related_Collateral__r.Limited_Service__c,
            'Full_Service__c' => appraisalOrder.Related_Collateral__r.Full_Service__c,
            'Resort__c' => appraisalOrder.Related_Collateral__r.Resort__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,
            'Existing__c' => appraisalOrder.Related_Collateral__r.Existing__c,            
            'Rehabilitation__c' => appraisalOrder.Related_Collateral__r.Rehabilitation__c
          };
        }
      }
    }

    public class CE_IE extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CE_IE(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CE','IE'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.OREO_Account__r.Total_Sq_Ft_of_Building_Area__c,
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Rentable_Sq_Ft__c,
            'Percent_of_Office_Space__c' => appraisalOrder.OREO_Account__r.Percent_of_Office_Space__c,
            'Percent_Warehouse_Mfg_Space__c' => appraisalOrder.OREO_Account__r.Percent_Warehouse_Mfg_Space__c,
            'Outside_Storage__c' => appraisalOrder.OREO_Account__r.Outside_Storage__c,
            'Percent_Occupied__c' => appraisalOrder.OREO_Account__r.Percent_Occupied__c,
            'Year_Built__c' => appraisalOrder.OREO_Account__r.Year_Built__c,            
            'Number_of_Tenants__c' => appraisalOrder.OREO_Account__r.Number_of_Tenants__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.Related_Collateral__r.Total_Sq_Ft_of_Building_Area__c,
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Rentable_Sq_Ft__c,
            'Percent_of_Office_Space__c' => appraisalOrder.Related_Collateral__r.Percent_of_Office_Space__c,
            'Percent_Warehouse_Mfg_Space__c' => appraisalOrder.Related_Collateral__r.Percent_Warehouse_Mfg_Space__c,
            'Outside_Storage__c' => appraisalOrder.Related_Collateral__r.Outside_Storage__c,
            'Percent_Occupied__c' => appraisalOrder.Related_Collateral__r.Percent_Occupied__c,
            'Year_Built__c' => appraisalOrder.Related_Collateral__r.Year_Built__c,            
            'Number_of_Tenants__c' => appraisalOrder.Related_Collateral__r.Number_of_Tenants__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.OREO_Account__r.Total_Sq_Ft_of_Building_Area__c,
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Rentable_Sq_Ft__c,
            'Percent_of_Office_Space__c' => appraisalOrder.OREO_Account__r.Percent_of_Office_Space__c,
            'Percent_Warehouse_Mfg_Space__c' => appraisalOrder.OREO_Account__r.Percent_Warehouse_Mfg_Space__c,
            'Outside_Storage__c' => appraisalOrder.OREO_Account__r.Outside_Storage__c,
            'Percent_Occupied__c' => appraisalOrder.OREO_Account__r.Percent_Occupied__c,
            'Year_Built__c' => appraisalOrder.OREO_Account__r.Year_Built__c,            
            'Number_of_Tenants__c' => appraisalOrder.OREO_Account__r.Number_of_Tenants__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.Related_Collateral__r.Total_Sq_Ft_of_Building_Area__c,
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Rentable_Sq_Ft__c,
            'Percent_of_Office_Space__c' => appraisalOrder.Related_Collateral__r.Percent_of_Office_Space__c,
            'Percent_Warehouse_Mfg_Space__c' => appraisalOrder.Related_Collateral__r.Percent_Warehouse_Mfg_Space__c,
            'Outside_Storage__c' => appraisalOrder.Related_Collateral__r.Outside_Storage__c,
            'Percent_Occupied__c' => appraisalOrder.Related_Collateral__r.Percent_Occupied__c,
            'Year_Built__c' => appraisalOrder.Related_Collateral__r.Year_Built__c,            
            'Number_of_Tenants__c' => appraisalOrder.Related_Collateral__r.Number_of_Tenants__c
          };
        }
      }
    }

    public class CF extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CF(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CF'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Storage_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Storage_Units__c,
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c,
            'Sq_Ft_of_all_Buildings__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_all_Buildings__c,
            'Electric_Utilities_Provided_for_ea_Unit__c' => appraisalOrder.OREO_Account__r.Electric_Utilities_Provided_for_ea_Unit__c,
            'Outside_Storage__c' => appraisalOrder.OREO_Account__r.Outside_Storage__c,            
            'Number_of_Units_of_Outside_Storage__c' => appraisalOrder.OREO_Account__r.Number_of_Units_of_Outside_Storage__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Storage_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Storage_Units__c,
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c,
            'Sq_Ft_of_all_Buildings__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_all_Buildings__c,
            'Electric_Utilities_Provided_for_ea_Unit__c' => appraisalOrder.Related_Collateral__r.Electric_Utilities_Provided_for_ea_Unit__c,
            'Outside_Storage__c' => appraisalOrder.Related_Collateral__r.Outside_Storage__c,            
            'Number_of_Units_of_Outside_Storage__c' => appraisalOrder.Related_Collateral__r.Number_of_Units_of_Outside_Storage__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Storage_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Storage_Units__c,
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c,
            'Sq_Ft_of_all_Buildings__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_all_Buildings__c,
            'Electric_Utilities_Provided_for_ea_Unit__c' => appraisalOrder.OREO_Account__r.Electric_Utilities_Provided_for_ea_Unit__c,
            'Outside_Storage__c' => appraisalOrder.OREO_Account__r.Outside_Storage__c,            
            'Number_of_Units_of_Outside_Storage__c' => appraisalOrder.OREO_Account__r.Number_of_Units_of_Outside_Storage__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Storage_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Storage_Units__c,
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c,
            'Sq_Ft_of_all_Buildings__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_all_Buildings__c,
            'Electric_Utilities_Provided_for_ea_Unit__c' => appraisalOrder.Related_Collateral__r.Electric_Utilities_Provided_for_ea_Unit__c,
            'Outside_Storage__c' => appraisalOrder.Related_Collateral__r.Outside_Storage__c,            
            'Number_of_Units_of_Outside_Storage__c' => appraisalOrder.Related_Collateral__r.Number_of_Units_of_Outside_Storage__c
          };
        }
      }
    }

    public class CG extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CG(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CG'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Units__c,
            'Sq_Ft_One_Bedroom_Units__c' => appraisalOrder.OREO_Account__r.Sq_Ft_One_Bedroom_Units__c,
            'Number_of_One_BR_Units__c' => appraisalOrder.OREO_Account__r.Number_of_One_BR_Units__c,
            'Sq_Ft_Two_Bedroom_Units__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Two_Bedroom_Units__c,
            'Number_of_Two_BR_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Two_BR_Units__c,
            'Sq_Ft_Three_Bedroom_Units__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Three_Bedroom_Units__c,
            'Number_of_Three_BR_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Three_BR_Units__c,
            'Sq_Ft_Four_Bedroom_Units__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Four_Bedroom_Units__c, 
            'Number_of_Four_BR_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Four_BR_Units__c,
            'Rental_Property__c' => appraisalOrder.OREO_Account__r.Rental_Property__c,
            'For_Sale_Property__c' => appraisalOrder.OREO_Account__r.For_Sale_Property__c,
            'Tax_Credit_Involved__c' => appraisalOrder.OREO_Account__r.Tax_Credit_Involved__c,
            'Restricted_Rents__c' => appraisalOrder.OREO_Account__r.Restricted_Rents__c, 
            'Amenities__c' => appraisalOrder.OREO_Account__r.Amenities__c
          };
        }else{
          return new Map<String, Object>{
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Units__c,
            'Sq_Ft_One_Bedroom_Units__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_One_Bedroom_Units__c,
            'Number_of_One_BR_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_One_BR_Units__c,
            'Sq_Ft_Two_Bedroom_Units__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Two_Bedroom_Units__c,
            'Number_of_Two_BR_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Two_BR_Units__c,
            'Sq_Ft_Three_Bedroom_Units__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Three_Bedroom_Units__c,
            'Number_of_Three_BR_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Three_BR_Units__c,
            'Sq_Ft_Four_Bedroom_Units__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Four_Bedroom_Units__c, 
            'Number_of_Four_BR_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Four_BR_Units__c,
            'Rental_Property__c' => appraisalOrder.Related_Collateral__r.Rental_Property__c,
            'For_Sale_Property__c' => appraisalOrder.Related_Collateral__r.For_Sale_Property__c,
            'Tax_Credit_Involved__c' => appraisalOrder.Related_Collateral__r.Tax_Credit_Involved__c,
            'Restricted_Rents__c' => appraisalOrder.Related_Collateral__r.Restricted_Rents__c, 
            'Amenities__c' => appraisalOrder.Related_Collateral__r.Amenities__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Units__c,
            'Sq_Ft_One_Bedroom_Units__c' => appraisalOrder.OREO_Account__r.Sq_Ft_One_Bedroom_Units__c,
            'Number_of_One_BR_Units__c' => appraisalOrder.OREO_Account__r.Number_of_One_BR_Units__c,
            'Sq_Ft_Two_Bedroom_Units__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Two_Bedroom_Units__c,
            'Number_of_Two_BR_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Two_BR_Units__c,
            'Sq_Ft_Three_Bedroom_Units__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Three_Bedroom_Units__c,
            'Number_of_Three_BR_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Three_BR_Units__c,
            'Sq_Ft_Four_Bedroom_Units__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Four_Bedroom_Units__c, 
            'Number_of_Four_BR_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Four_BR_Units__c,
            'Rental_Property__c' => appraisalOrder.OREO_Account__r.Rental_Property__c,
            'For_Sale_Property__c' => appraisalOrder.OREO_Account__r.For_Sale_Property__c,
            'Tax_Credit_Involved__c' => appraisalOrder.OREO_Account__r.Tax_Credit_Involved__c,
            'Restricted_Rents__c' => appraisalOrder.OREO_Account__r.Restricted_Rents__c, 
            'Amenities__c' => appraisalOrder.OREO_Account__r.Amenities__c
          };
        }else{
          return new Map<String, Object>{
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Units__c,
            'Sq_Ft_One_Bedroom_Units__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_One_Bedroom_Units__c,
            'Number_of_One_BR_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_One_BR_Units__c,
            'Sq_Ft_Two_Bedroom_Units__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Two_Bedroom_Units__c,
            'Number_of_Two_BR_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Two_BR_Units__c,
            'Sq_Ft_Three_Bedroom_Units__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Three_Bedroom_Units__c,
            'Number_of_Three_BR_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Three_BR_Units__c,
            'Sq_Ft_Four_Bedroom_Units__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Four_Bedroom_Units__c, 
            'Number_of_Four_BR_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Four_BR_Units__c,
            'Rental_Property__c' => appraisalOrder.Related_Collateral__r.Rental_Property__c,
            'For_Sale_Property__c' => appraisalOrder.Related_Collateral__r.For_Sale_Property__c,
            'Tax_Credit_Involved__c' => appraisalOrder.Related_Collateral__r.Tax_Credit_Involved__c,
            'Restricted_Rents__c' => appraisalOrder.Related_Collateral__r.Restricted_Rents__c, 
            'Amenities__c' => appraisalOrder.Related_Collateral__r.Amenities__c
          };
        }
      }
    }

    public class CH_IH extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CH_IH(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CH','IH'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Gross_Bldg_Area__c' => appraisalOrder.OREO_Account__r.Gross_Bldg_Area__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Rentable_Sq_Ft__c,
            'Number_of_Stories__c' => appraisalOrder.OREO_Account__r.Number_of_Stories__c,
            'Percent_Occupied__c' => appraisalOrder.OREO_Account__r.Percent_Occupied__c,
            'Number_of_Tenants__c' => appraisalOrder.OREO_Account__r.Number_of_Tenants__c,
            'Year_Built__c' => appraisalOrder.OREO_Account__r.Year_Built__c,            
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Gross_Bldg_Area__c' => appraisalOrder.Related_Collateral__r.Gross_Bldg_Area__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Rentable_Sq_Ft__c,
            'Number_of_Stories__c' => appraisalOrder.Related_Collateral__r.Number_of_Stories__c,
            'Percent_Occupied__c' => appraisalOrder.Related_Collateral__r.Percent_Occupied__c,
            'Number_of_Tenants__c' => appraisalOrder.Related_Collateral__r.Number_of_Tenants__c,
            'Year_Built__c' => appraisalOrder.Related_Collateral__r.Year_Built__c,            
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Gross_Bldg_Area__c' => appraisalOrder.OREO_Account__r.Gross_Bldg_Area__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Rentable_Sq_Ft__c,
            'Number_of_Stories__c' => appraisalOrder.OREO_Account__r.Number_of_Stories__c,
            'Percent_Occupied__c' => appraisalOrder.OREO_Account__r.Percent_Occupied__c,
            'Number_of_Tenants__c' => appraisalOrder.OREO_Account__r.Number_of_Tenants__c,
            'Year_Built__c' => appraisalOrder.OREO_Account__r.Year_Built__c,            
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Gross_Bldg_Area__c' => appraisalOrder.Related_Collateral__r.Gross_Bldg_Area__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Rentable_Sq_Ft__c,
            'Number_of_Stories__c' => appraisalOrder.Related_Collateral__r.Number_of_Stories__c,
            'Percent_Occupied__c' => appraisalOrder.Related_Collateral__r.Percent_Occupied__c,
            'Number_of_Tenants__c' => appraisalOrder.Related_Collateral__r.Number_of_Tenants__c,
            'Year_Built__c' => appraisalOrder.Related_Collateral__r.Year_Built__c,            
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c
          };
        }
      }
    }

    public class CI_II extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CI_II(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CI','II'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.OREO_Account__r.Total_Sq_Ft_of_Building_Area__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Rentable_Sq_Ft__c,
            'Year_Built__c' => appraisalOrder.OREO_Account__r.Year_Built__c,
            'Number_of_Out_Lots__c' => appraisalOrder.OREO_Account__r.Number_of_Out_Lots__c,
            'Out_Lot_1_Size_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Out_Lot_1_Size_Sq_Ft__c,      
            'Out_Lot_2_Size_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Out_Lot_2_Size_Sq_Ft__c,            
            'Out_Lot_3_Size_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Out_Lot_3_Size_Sq_Ft__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.Related_Collateral__r.Total_Sq_Ft_of_Building_Area__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Rentable_Sq_Ft__c,
            'Year_Built__c' => appraisalOrder.Related_Collateral__r.Year_Built__c,
            'Number_of_Out_Lots__c' => appraisalOrder.Related_Collateral__r.Number_of_Out_Lots__c,
            'Out_Lot_1_Size_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Out_Lot_1_Size_Sq_Ft__c,      
            'Out_Lot_2_Size_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Out_Lot_2_Size_Sq_Ft__c,            
            'Out_Lot_3_Size_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Out_Lot_3_Size_Sq_Ft__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Buildings__c' => appraisalOrder.OREO_Account__r.Number_of_Buildings__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.OREO_Account__r.Total_Sq_Ft_of_Building_Area__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Rentable_Sq_Ft__c,
            'Year_Built__c' => appraisalOrder.OREO_Account__r.Year_Built__c,
            'Number_of_Out_Lots__c' => appraisalOrder.OREO_Account__r.Number_of_Out_Lots__c,
            'Out_Lot_1_Size_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Out_Lot_1_Size_Sq_Ft__c,      
            'Out_Lot_2_Size_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Out_Lot_2_Size_Sq_Ft__c,            
            'Out_Lot_3_Size_Sq_Ft__c' => appraisalOrder.OREO_Account__r.Out_Lot_3_Size_Sq_Ft__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Buildings__c' => appraisalOrder.Related_Collateral__r.Number_of_Buildings__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.Related_Collateral__r.Total_Sq_Ft_of_Building_Area__c,
            'Rentable_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Rentable_Sq_Ft__c,
            'Year_Built__c' => appraisalOrder.Related_Collateral__r.Year_Built__c,
            'Number_of_Out_Lots__c' => appraisalOrder.Related_Collateral__r.Number_of_Out_Lots__c,
            'Out_Lot_1_Size_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Out_Lot_1_Size_Sq_Ft__c,      
            'Out_Lot_2_Size_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Out_Lot_2_Size_Sq_Ft__c,            
            'Out_Lot_3_Size_Sq_Ft__c' => appraisalOrder.Related_Collateral__r.Out_Lot_3_Size_Sq_Ft__c
          };
        }
      }
    }

    public class CJ_IJ extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CJ_IJ(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CJ','IJ'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.OREO_Account__r.Existing__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,
            'Denomination__c' => appraisalOrder.OREO_Account__r.Denomination__c,            
            'Tax_Exempt_Status__c' => appraisalOrder.OREO_Account__r.Tax_Exempt_Status__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.Related_Collateral__r.Existing__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,
            'Denomination__c' => appraisalOrder.Related_Collateral__r.Denomination__c,            
            'Tax_Exempt_Status__c' => appraisalOrder.Related_Collateral__r.Tax_Exempt_Status__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.OREO_Account__r.Existing__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,
            'Denomination__c' => appraisalOrder.OREO_Account__r.Denomination__c,            
            'Tax_Exempt_Status__c' => appraisalOrder.OREO_Account__r.Tax_Exempt_Status__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.Related_Collateral__r.Existing__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,
            'Denomination__c' => appraisalOrder.Related_Collateral__r.Denomination__c,            
            'Tax_Exempt_Status__c' => appraisalOrder.Related_Collateral__r.Tax_Exempt_Status__c
          };
        }
      }
    }

    public class CK_IK extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CK_IK(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CK','IK'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Type_of_School__c' => appraisalOrder.OREO_Account__r.Type_of_School__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.OREO_Account__r.Existing__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,            
            'Tax_Exempt_Status__c' => appraisalOrder.OREO_Account__r.Tax_Exempt_Status__c
          };
        }else{
          return new Map<String, Object>{
            'Type_of_School__c' => appraisalOrder.Related_Collateral__r.Type_of_School__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.Related_Collateral__r.Existing__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,            
            'Tax_Exempt_Status__c' => appraisalOrder.Related_Collateral__r.Tax_Exempt_Status__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Type_of_School__c' => appraisalOrder.OREO_Account__r.Type_of_School__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.OREO_Account__r.Existing__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,            
            'Tax_Exempt_Status__c' => appraisalOrder.OREO_Account__r.Tax_Exempt_Status__c
          };
        }else{
          return new Map<String, Object>{
            'Type_of_School__c' => appraisalOrder.Related_Collateral__r.Type_of_School__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.Related_Collateral__r.Existing__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,            
            'Tax_Exempt_Status__c' => appraisalOrder.Related_Collateral__r.Tax_Exempt_Status__c
          };
        }
      }
    }

    public class CL_IL extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CL_IL(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CL','IL'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Name_of_Golf_Course__c' => appraisalOrder.OREO_Account__r.Name_of_Golf_Course__c,
            'Number_Of_Holes__c' => appraisalOrder.OREO_Account__r.Number_Of_Holes__c,
            'Privacy__c' => appraisalOrder.OREO_Account__r.Privacy__c,            
            'Amenities_for_Golf_Course__c' => appraisalOrder.OREO_Account__r.Amenities_for_Golf_Course__c
          };
        }else{
          return new Map<String, Object>{
            'Name_of_Golf_Course__c' => appraisalOrder.Related_Collateral__r.Name_of_Golf_Course__c,
            'Number_Of_Holes__c' => appraisalOrder.Related_Collateral__r.Number_Of_Holes__c,
            'Privacy__c' => appraisalOrder.Related_Collateral__r.Privacy__c,            
            'Amenities_for_Golf_Course__c' => appraisalOrder.Related_Collateral__r.Amenities_for_Golf_Course__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Name_of_Golf_Course__c' => appraisalOrder.OREO_Account__r.Name_of_Golf_Course__c,
            'Number_Of_Holes__c' => appraisalOrder.OREO_Account__r.Number_Of_Holes__c,
            'Privacy__c' => appraisalOrder.OREO_Account__r.Privacy__c,            
            'Amenities_for_Golf_Course__c' => appraisalOrder.OREO_Account__r.Amenities_for_Golf_Course__c
          };
        }else{
          return new Map<String, Object>{
            'Name_of_Golf_Course__c' => appraisalOrder.Related_Collateral__r.Name_of_Golf_Course__c,
            'Number_Of_Holes__c' => appraisalOrder.Related_Collateral__r.Number_Of_Holes__c,
            'Privacy__c' => appraisalOrder.Related_Collateral__r.Privacy__c,            
            'Amenities_for_Golf_Course__c' => appraisalOrder.Related_Collateral__r.Amenities_for_Golf_Course__c
          };
        }
      }
    }

    public class CN_IN extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CN_IN(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CN','IN'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Flag_Brand_of_Store__c' => appraisalOrder.OREO_Account__r.Flag_Brand_of_Store__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.OREO_Account__r.Existing__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,
            'Car_Wash__c' => appraisalOrder.OREO_Account__r.Car_Wash__c,
            'Gas_Pumps__c' => appraisalOrder.OREO_Account__r.Gas_Pumps__c,            
            'Renovation__c' => appraisalOrder.OREO_Account__r.Renovation__c
          };
        }else{
          return new Map<String, Object>{
            'Flag_Brand_of_Store__c' => appraisalOrder.Related_Collateral__r.Flag_Brand_of_Store__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.Related_Collateral__r.Existing__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,
            'Car_Wash__c' => appraisalOrder.Related_Collateral__r.Car_Wash__c,
            'Gas_Pumps__c' => appraisalOrder.Related_Collateral__r.Gas_Pumps__c,            
            'Renovation__c' => appraisalOrder.Related_Collateral__r.Renovation__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Flag_Brand_of_Store__c' => appraisalOrder.OREO_Account__r.Flag_Brand_of_Store__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.OREO_Account__r.Existing__c,
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c,
            'Car_Wash__c' => appraisalOrder.OREO_Account__r.Car_Wash__c,
            'Gas_Pumps__c' => appraisalOrder.OREO_Account__r.Gas_Pumps__c,            
            'Renovation__c' => appraisalOrder.OREO_Account__r.Renovation__c
          };
        }else{
          return new Map<String, Object>{
            'Flag_Brand_of_Store__c' => appraisalOrder.Related_Collateral__r.Flag_Brand_of_Store__c,
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Sq_Ft_of_Building__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_Building__c,
            'Existing__c' => appraisalOrder.Related_Collateral__r.Existing__c,
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c,
            'Car_Wash__c' => appraisalOrder.Related_Collateral__r.Car_Wash__c,
            'Gas_Pumps__c' => appraisalOrder.Related_Collateral__r.Gas_Pumps__c,            
            'Renovation__c' => appraisalOrder.Related_Collateral__r.Renovation__c
          };
        }
      }
    }


    public class CO extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CO(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CO'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Year_Built__c' => appraisalOrder.OREO_Account__r.Year_Built__c,
            'Number_of_Skilled_Nursing_Beds__c' => appraisalOrder.OREO_Account__r.Number_of_Skilled_Nursing_Beds__c,
            'Number_of_Assisted_Living_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Assisted_Living_Units__c,
            'Number_of_Independent_Living_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Independent_Living_Units__c,
            'Private_Pay__c' => appraisalOrder.OREO_Account__r.Private_Pay__c,
            'Medicare__c' => appraisalOrder.OREO_Account__r.Medicare__c,
            'Medicaid__c' => appraisalOrder.OREO_Account__r.Medicaid__c,
            'Veterans_Administration_Beds__c' => appraisalOrder.OREO_Account__r.Veterans_Administration_Beds__c,            
            'Dementia_Alzheimers__c' => appraisalOrder.OREO_Account__r.Dementia_Alzheimers__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Year_Built__c' => appraisalOrder.Related_Collateral__r.Year_Built__c,
            'Number_of_Skilled_Nursing_Beds__c' => appraisalOrder.Related_Collateral__r.Number_of_Skilled_Nursing_Beds__c,
            'Number_of_Assisted_Living_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Assisted_Living_Units__c,
            'Number_of_Independent_Living_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Independent_Living_Units__c,
            'Private_Pay__c' => appraisalOrder.Related_Collateral__r.Private_Pay__c,
            'Medicare__c' => appraisalOrder.Related_Collateral__r.Medicare__c,
            'Medicaid__c' => appraisalOrder.Related_Collateral__r.Medicaid__c,
            'Veterans_Administration_Beds__c' => appraisalOrder.Related_Collateral__r.Veterans_Administration_Beds__c,            
            'Dementia_Alzheimers__c' => appraisalOrder.Related_Collateral__r.Dementia_Alzheimers__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Year_Built__c' => appraisalOrder.OREO_Account__r.Year_Built__c,
            'Number_of_Skilled_Nursing_Beds__c' => appraisalOrder.OREO_Account__r.Number_of_Skilled_Nursing_Beds__c,
            'Number_of_Assisted_Living_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Assisted_Living_Units__c,
            'Number_of_Independent_Living_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Independent_Living_Units__c,
            'Private_Pay__c' => appraisalOrder.OREO_Account__r.Private_Pay__c,
            'Medicare__c' => appraisalOrder.OREO_Account__r.Medicare__c,
            'Medicaid__c' => appraisalOrder.OREO_Account__r.Medicaid__c,
            'Veterans_Administration_Beds__c' => appraisalOrder.OREO_Account__r.Veterans_Administration_Beds__c,            
            'Dementia_Alzheimers__c' => appraisalOrder.OREO_Account__r.Dementia_Alzheimers__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Year_Built__c' => appraisalOrder.Related_Collateral__r.Year_Built__c,
            'Number_of_Skilled_Nursing_Beds__c' => appraisalOrder.Related_Collateral__r.Number_of_Skilled_Nursing_Beds__c,
            'Number_of_Assisted_Living_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Assisted_Living_Units__c,
            'Number_of_Independent_Living_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Independent_Living_Units__c,
            'Private_Pay__c' => appraisalOrder.Related_Collateral__r.Private_Pay__c,
            'Medicare__c' => appraisalOrder.Related_Collateral__r.Medicare__c,
            'Medicaid__c' => appraisalOrder.Related_Collateral__r.Medicaid__c,
            'Veterans_Administration_Beds__c' => appraisalOrder.Related_Collateral__r.Veterans_Administration_Beds__c,            
            'Dementia_Alzheimers__c' => appraisalOrder.Related_Collateral__r.Dementia_Alzheimers__c
          };
        }
      }
    }

    public class CP_IP extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CP_IP(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CP','IP'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.OREO_Account__r.Total_Sq_Ft_of_Building_Area__c,
            'Seating_Capacity__c' => appraisalOrder.OREO_Account__r.Seating_Capacity__c,
            'Chain_Restaurant__c' => appraisalOrder.OREO_Account__r.Chain_Restaurant__c,            
            'Name_of_Chain_Restaurant__c' => appraisalOrder.OREO_Account__r.Name_of_Chain_Restaurant__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.Related_Collateral__r.Total_Sq_Ft_of_Building_Area__c,
            'Seating_Capacity__c' => appraisalOrder.Related_Collateral__r.Seating_Capacity__c,
            'Chain_Restaurant__c' => appraisalOrder.Related_Collateral__r.Chain_Restaurant__c,            
            'Name_of_Chain_Restaurant__c' => appraisalOrder.Related_Collateral__r.Name_of_Chain_Restaurant__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.OREO_Account__r.Total_Sq_Ft_of_Building_Area__c,
            'Seating_Capacity__c' => appraisalOrder.OREO_Account__r.Seating_Capacity__c,
            'Chain_Restaurant__c' => appraisalOrder.OREO_Account__r.Chain_Restaurant__c,            
            'Name_of_Chain_Restaurant__c' => appraisalOrder.OREO_Account__r.Name_of_Chain_Restaurant__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Total_Sq_Ft_of_Building_Area__c' => appraisalOrder.Related_Collateral__r.Total_Sq_Ft_of_Building_Area__c,
            'Seating_Capacity__c' => appraisalOrder.Related_Collateral__r.Seating_Capacity__c,
            'Chain_Restaurant__c' => appraisalOrder.Related_Collateral__r.Chain_Restaurant__c,            
            'Name_of_Chain_Restaurant__c' => appraisalOrder.Related_Collateral__r.Name_of_Chain_Restaurant__c
          };
        }
      }
    }

    public class CV_IV extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_CV_IV(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'CV','IV'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Type_of_Car_Wash__c' => appraisalOrder.OREO_Account__r.Type_of_Car_Wash__c,
            'Car_Wash_Equipment_Type__c' => appraisalOrder.OREO_Account__r.Car_Wash_Equipment_Type__c,
            'Number_of_Bays__c' => appraisalOrder.OREO_Account__r.Number_of_Bays__c,            
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c
          };
        }else{
          return new Map<String, Object>{
            'Type_of_Car_Wash__c' => appraisalOrder.Related_Collateral__r.Type_of_Car_Wash__c,
            'Car_Wash_Equipment_Type__c' => appraisalOrder.Related_Collateral__r.Car_Wash_Equipment_Type__c,
            'Number_of_Bays__c' => appraisalOrder.Related_Collateral__r.Number_of_Bays__c,            
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Type_of_Car_Wash__c' => appraisalOrder.OREO_Account__r.Type_of_Car_Wash__c,
            'Car_Wash_Equipment_Type__c' => appraisalOrder.OREO_Account__r.Car_Wash_Equipment_Type__c,
            'Number_of_Bays__c' => appraisalOrder.OREO_Account__r.Number_of_Bays__c,            
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c
          };
        }else{
          return new Map<String, Object>{
            'Type_of_Car_Wash__c' => appraisalOrder.Related_Collateral__r.Type_of_Car_Wash__c,
            'Car_Wash_Equipment_Type__c' => appraisalOrder.Related_Collateral__r.Car_Wash_Equipment_Type__c,
            'Number_of_Bays__c' => appraisalOrder.Related_Collateral__r.Number_of_Bays__c,            
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c
          };
        }
      }
    }

    public class DA extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_DA(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'DA'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Zoning_Classification__c' => appraisalOrder.OREO_Account__r.Zoning_Classification__c,
            'Projected_Number_of_Residential_Lots__c' => appraisalOrder.OREO_Account__r.Projected_Number_of_Residential_Lots__c,
            'Utilities__c' => appraisalOrder.OREO_Account__r.Utilities__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Zoning_Classification__c' => appraisalOrder.Related_Collateral__r.Zoning_Classification__c,
            'Projected_Number_of_Residential_Lots__c' => appraisalOrder.Related_Collateral__r.Projected_Number_of_Residential_Lots__c,
            'Utilities__c' => appraisalOrder.Related_Collateral__r.Utilities__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Projected_Number_of_Residential_Lots__c' => appraisalOrder.OREO_Account__r.Projected_Number_of_Residential_Lots__c,
            'Utilities__c' => appraisalOrder.OREO_Account__r.Utilities__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Projected_Number_of_Residential_Lots__c' => appraisalOrder.Related_Collateral__r.Projected_Number_of_Residential_Lots__c,
            'Utilities__c' => appraisalOrder.Related_Collateral__r.Utilities__c
          };
        }
      }
    }

    public class EC extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_EC(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'EC'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Improved_Lots__c' => appraisalOrder.OREO_Account__r.Number_of_Improved_Lots__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.OREO_Account__r.Name_of_Subdivision_Development__c,
            'Excess_Unimproved_Land__c' => appraisalOrder.OREO_Account__r.Excess_Unimproved_Land__c,
            'Number_of_Acres_Excess_Unimproved_Land__c' => appraisalOrder.OREO_Account__r.Number_of_Acres_Excess_Unimproved_Land__c,      
            'Describe_Improvements__c' => appraisalOrder.OREO_Account__r.Describe_Improvements__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Improved_Lots__c' => appraisalOrder.Related_Collateral__r.Number_of_Improved_Lots__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.Related_Collateral__r.Name_of_Subdivision_Development__c,
            'Excess_Unimproved_Land__c' => appraisalOrder.Related_Collateral__r.Excess_Unimproved_Land__c,
            'Number_of_Acres_Excess_Unimproved_Land__c' => appraisalOrder.Related_Collateral__r.Number_of_Acres_Excess_Unimproved_Land__c,      
            'Describe_Improvements__c' => appraisalOrder.Related_Collateral__r.Describe_Improvements__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Number_of_Improved_Lots__c' => appraisalOrder.OREO_Account__r.Number_of_Improved_Lots__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.OREO_Account__r.Name_of_Subdivision_Development__c,
            'Excess_Unimproved_Land__c' => appraisalOrder.OREO_Account__r.Excess_Unimproved_Land__c,
            'Number_of_Acres_Excess_Unimproved_Land__c' => appraisalOrder.OREO_Account__r.Number_of_Acres_Excess_Unimproved_Land__c,      
            'Describe_Improvements__c' => appraisalOrder.OREO_Account__r.Describe_Improvements__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Number_of_Improved_Lots__c' => appraisalOrder.Related_Collateral__r.Number_of_Improved_Lots__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.Related_Collateral__r.Name_of_Subdivision_Development__c,
            'Excess_Unimproved_Land__c' => appraisalOrder.Related_Collateral__r.Excess_Unimproved_Land__c,
            'Number_of_Acres_Excess_Unimproved_Land__c' => appraisalOrder.Related_Collateral__r.Number_of_Acres_Excess_Unimproved_Land__c,      
            'Describe_Improvements__c' => appraisalOrder.Related_Collateral__r.Describe_Improvements__c
          };
        }
      }
    }

    public class FA_FB extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_FA_FB(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'FA','FB'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_House__c,
            'Estimate_Value_of_House__c' => appraisalOrder.OREO_Account__r.Estimate_Value_of_House__c,
            'Legal_Name_of_Subdivision__c' => appraisalOrder.OREO_Account__r.Legal_Name_of_Subdivision__c,
            'Lot_Number__c' => appraisalOrder.OREO_Account__r.Lot_Number__c,
            'Lot_Size__c' => appraisalOrder.OREO_Account__r.Lot_Size__c,
            'Corner_Lot__c' => appraisalOrder.OREO_Account__r.Corner_Lot__c,            
            'Cul_de_Sac_Lot__c' => appraisalOrder.OREO_Account__r.Cul_de_Sac_Lot__c
          };
        }else{
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_House__c,
            'Estimate_Value_of_House__c' => appraisalOrder.Related_Collateral__r.Estimate_Value_of_House__c,
            'Legal_Name_of_Subdivision__c' => appraisalOrder.Related_Collateral__r.Legal_Name_of_Subdivision__c,
            'Lot_Number__c' => appraisalOrder.Related_Collateral__r.Lot_Number__c,
            'Lot_Size__c' => appraisalOrder.Related_Collateral__r.Lot_Size__c,
            'Corner_Lot__c' => appraisalOrder.Related_Collateral__r.Corner_Lot__c,            
            'Cul_de_Sac_Lot__c' => appraisalOrder.Related_Collateral__r.Cul_de_Sac_Lot__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_House__c,
            'Estimate_Value_of_House__c' => appraisalOrder.OREO_Account__r.Estimate_Value_of_House__c,
            'Legal_Name_of_Subdivision__c' => appraisalOrder.OREO_Account__r.Legal_Name_of_Subdivision__c,
            'Lot_Number__c' => appraisalOrder.OREO_Account__r.Lot_Number__c,
            'Lot_Size__c' => appraisalOrder.OREO_Account__r.Lot_Size__c,
            'Corner_Lot__c' => appraisalOrder.OREO_Account__r.Corner_Lot__c,            
            'Cul_de_Sac_Lot__c' => appraisalOrder.OREO_Account__r.Cul_de_Sac_Lot__c
          };
        }else{
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_House__c,
            'Estimate_Value_of_House__c' => appraisalOrder.Related_Collateral__r.Estimate_Value_of_House__c,
            'Legal_Name_of_Subdivision__c' => appraisalOrder.Related_Collateral__r.Legal_Name_of_Subdivision__c,
            'Lot_Number__c' => appraisalOrder.Related_Collateral__r.Lot_Number__c,
            'Lot_Size__c' => appraisalOrder.Related_Collateral__r.Lot_Size__c,
            'Corner_Lot__c' => appraisalOrder.Related_Collateral__r.Corner_Lot__c,            
            'Cul_de_Sac_Lot__c' => appraisalOrder.Related_Collateral__r.Cul_de_Sac_Lot__c
          };
        }
      }
    }


    public class FC extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_FC(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'FC'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_House__c,
            'Contract_Amount_of_House__c' => appraisalOrder.OREO_Account__r.Contract_Amount_of_House__c,
            'Legal_Name_of_Subdivision__c' => appraisalOrder.OREO_Account__r.Legal_Name_of_Subdivision__c,
            'Lot_Number__c' => appraisalOrder.OREO_Account__r.Lot_Number__c
          };
        }else{
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_House__c,
            'Contract_Amount_of_House__c' => appraisalOrder.Related_Collateral__r.Contract_Amount_of_House__c,
            'Legal_Name_of_Subdivision__c' => appraisalOrder.Related_Collateral__r.Legal_Name_of_Subdivision__c,
            'Lot_Number__c' => appraisalOrder.Related_Collateral__r.Lot_Number__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_House__c,
            'Contract_Amount_of_House__c' => appraisalOrder.OREO_Account__r.Contract_Amount_of_House__c,
            'Legal_Name_of_Subdivision__c' => appraisalOrder.OREO_Account__r.Legal_Name_of_Subdivision__c,
            'Lot_Number__c' => appraisalOrder.OREO_Account__r.Lot_Number__c
          };
        }else{
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_House__c,
            'Contract_Amount_of_House__c' => appraisalOrder.Related_Collateral__r.Contract_Amount_of_House__c,
            'Legal_Name_of_Subdivision__c' => appraisalOrder.Related_Collateral__r.Legal_Name_of_Subdivision__c,
            'Lot_Number__c' => appraisalOrder.Related_Collateral__r.Lot_Number__c
          };
        }
      }
    }

    public class GA_GB extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_GA_GB(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'GA','GB'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_House__c,
            'Estimate_Value_of_House__c' => appraisalOrder.OREO_Account__r.Estimate_Value_of_House__c
          };
        }else{
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_House__c,
            'Estimate_Value_of_House__c' => appraisalOrder.Related_Collateral__r.Estimate_Value_of_House__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_House__c,
            'Estimate_Value_of_House__c' => appraisalOrder.OREO_Account__r.Estimate_Value_of_House__c
          };
        }else{
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_House__c,
            'Estimate_Value_of_House__c' => appraisalOrder.Related_Collateral__r.Estimate_Value_of_House__c
          };
        }
      }
    }

    public class GC_GD extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_GC_GD(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'GC','GD'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Number_of_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Units__c,
            'Sq_Ft_Unit_1__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Unit_1__c,
            'Sq_Ft_Unit_2__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Unit_2__c,
            'Sq_Ft_Unit_3__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Unit_3__c,
            'Sq_Ft_Unit_4__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Unit_4__c,
            'Estimated_Value_Unit_1__c' => appraisalOrder.OREO_Account__r.Estimated_Value_Unit_1__c,
            'Estimated_Value_Unit_2__c' => appraisalOrder.OREO_Account__r.Estimated_Value_Unit_2__c,
            'Estimated_Value_Unit_3__c' => appraisalOrder.OREO_Account__r.Estimated_Value_Unit_3__c,
            'Estimated_Value_Unit_4__c' => appraisalOrder.OREO_Account__r.Estimated_Value_Unit_4__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.OREO_Account__r.Name_of_Subdivision_Development__c,
            'Lot_Number__c' => appraisalOrder.OREO_Account__r.Lot_Number__c,
            'Land_Size_Acreage__c' => appraisalOrder.OREO_Account__r.Land_Size_Acreage__c,
            'Amenities__c' => appraisalOrder.OREO_Account__r.Amenities__c,            
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c
          };
        }else{
          return new Map<String, Object>{
            'Number_of_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Units__c,
            'Sq_Ft_Unit_1__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Unit_1__c,
            'Sq_Ft_Unit_2__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Unit_2__c,
            'Sq_Ft_Unit_3__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Unit_3__c,
            'Sq_Ft_Unit_4__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Unit_4__c,
            'Estimated_Value_Unit_1__c' => appraisalOrder.Related_Collateral__r.Estimated_Value_Unit_1__c,
            'Estimated_Value_Unit_2__c' => appraisalOrder.Related_Collateral__r.Estimated_Value_Unit_2__c,
            'Estimated_Value_Unit_3__c' => appraisalOrder.Related_Collateral__r.Estimated_Value_Unit_3__c,
            'Estimated_Value_Unit_4__c' => appraisalOrder.Related_Collateral__r.Estimated_Value_Unit_4__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.Related_Collateral__r.Name_of_Subdivision_Development__c,
            'Lot_Number__c' => appraisalOrder.Related_Collateral__r.Lot_Number__c,
            'Land_Size_Acreage__c' => appraisalOrder.Related_Collateral__r.Land_Size_Acreage__c,
            'Amenities__c' => appraisalOrder.Related_Collateral__r.Amenities__c,            
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Number_of_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Units__c,
            'Sq_Ft_Unit_1__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Unit_1__c,
            'Sq_Ft_Unit_2__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Unit_2__c,
            'Sq_Ft_Unit_3__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Unit_3__c,
            'Sq_Ft_Unit_4__c' => appraisalOrder.OREO_Account__r.Sq_Ft_Unit_4__c,
            'Estimated_Value_Unit_1__c' => appraisalOrder.OREO_Account__r.Estimated_Value_Unit_1__c,
            'Estimated_Value_Unit_2__c' => appraisalOrder.OREO_Account__r.Estimated_Value_Unit_2__c,
            'Estimated_Value_Unit_3__c' => appraisalOrder.OREO_Account__r.Estimated_Value_Unit_3__c,
            'Estimated_Value_Unit_4__c' => appraisalOrder.OREO_Account__r.Estimated_Value_Unit_4__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.OREO_Account__r.Name_of_Subdivision_Development__c,
            'Lot_Number__c' => appraisalOrder.OREO_Account__r.Lot_Number__c,
            'Land_Size_Acreage__c' => appraisalOrder.OREO_Account__r.Land_Size_Acreage__c,
            'Amenities__c' => appraisalOrder.OREO_Account__r.Amenities__c,            
            'New_Construction__c' => appraisalOrder.OREO_Account__r.New_Construction__c
          };
        }else{
          return new Map<String, Object>{
            'Number_of_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Units__c,
            'Sq_Ft_Unit_1__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Unit_1__c,
            'Sq_Ft_Unit_2__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Unit_2__c,
            'Sq_Ft_Unit_3__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Unit_3__c,
            'Sq_Ft_Unit_4__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_Unit_4__c,
            'Estimated_Value_Unit_1__c' => appraisalOrder.Related_Collateral__r.Estimated_Value_Unit_1__c,
            'Estimated_Value_Unit_2__c' => appraisalOrder.Related_Collateral__r.Estimated_Value_Unit_2__c,
            'Estimated_Value_Unit_3__c' => appraisalOrder.Related_Collateral__r.Estimated_Value_Unit_3__c,
            'Estimated_Value_Unit_4__c' => appraisalOrder.Related_Collateral__r.Estimated_Value_Unit_4__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.Related_Collateral__r.Name_of_Subdivision_Development__c,
            'Lot_Number__c' => appraisalOrder.Related_Collateral__r.Lot_Number__c,
            'Land_Size_Acreage__c' => appraisalOrder.Related_Collateral__r.Land_Size_Acreage__c,
            'Amenities__c' => appraisalOrder.Related_Collateral__r.Amenities__c,            
            'New_Construction__c' => appraisalOrder.Related_Collateral__r.New_Construction__c
          };
        }
      }
    }

    public class IS extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_IS(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'IS'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Legal_Description__c' => appraisalOrder.OREO_Account__r.Legal_Description__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Legal_Description__c' => appraisalOrder.Related_Collateral__r.Legal_Description__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c,
            'Legal_Description__c' => appraisalOrder.OREO_Account__r.Legal_Description__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c,
            'Legal_Description__c' => appraisalOrder.Related_Collateral__r.Legal_Description__c
          };
        }
      }
    }

    public class QA_QB_QE_QF_QG_QH_QK_QL extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_QAQBQEQFQGQHQKQL(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'QA','QB','QE','QF','QG','QH','QK','QL'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_House__c,            
            'Estimate_Value_of_House__c' => appraisalOrder.OREO_Account__r.Estimate_Value_of_House__c
          };
        }else{
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_House__c,            
            'Estimate_Value_of_House__c' => appraisalOrder.Related_Collateral__r.Estimate_Value_of_House__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_House__c,            
            'Estimate_Value_of_House__c' => appraisalOrder.OREO_Account__r.Estimate_Value_of_House__c
          };
        }else{
          return new Map<String, Object>{
            'Sq_Ft_of_House__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_House__c,            
            'Estimate_Value_of_House__c' => appraisalOrder.Related_Collateral__r.Estimate_Value_of_House__c
          };
        }
      }
    }

    public class QC_QD_QI_QJ extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_QC_QD_QI_QJ(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'QC','QD','QI','QJ'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Sq_Ft_of_Unit__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_Unit__c,
            'Estimate_Value_of_Unit__c' => appraisalOrder.OREO_Account__r.Estimate_Value_of_Unit__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.OREO_Account__r.Name_of_Subdivision_Development__c,
            'Number_of_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Units__c,
            'Amenities__c' => appraisalOrder.OREO_Account__r.Amenities__c
          };
        }else{
          return new Map<String, Object>{
            'Sq_Ft_of_Unit__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_Unit__c,
            'Estimate_Value_of_Unit__c' => appraisalOrder.Related_Collateral__r.Estimate_Value_of_Unit__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.Related_Collateral__r.Name_of_Subdivision_Development__c,
            'Number_of_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Units__c,
            'Amenities__c' => appraisalOrder.Related_Collateral__r.Amenities__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Sq_Ft_of_Unit__c' => appraisalOrder.OREO_Account__r.Sq_Ft_of_Unit__c,
            'Estimate_Value_of_Unit__c' => appraisalOrder.OREO_Account__r.Estimate_Value_of_Unit__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.OREO_Account__r.Name_of_Subdivision_Development__c,
            'Number_of_Units__c' => appraisalOrder.OREO_Account__r.Number_of_Units__c,
            'Amenities__c' => appraisalOrder.OREO_Account__r.Amenities__c
          };
        }else{
          return new Map<String, Object>{
            'Sq_Ft_of_Unit__c' => appraisalOrder.Related_Collateral__r.Sq_Ft_of_Unit__c,
            'Estimate_Value_of_Unit__c' => appraisalOrder.Related_Collateral__r.Estimate_Value_of_Unit__c,
            'Name_of_Subdivision_Development__c' => appraisalOrder.Related_Collateral__r.Name_of_Subdivision_Development__c,
            'Number_of_Units__c' => appraisalOrder.Related_Collateral__r.Number_of_Units__c,
            'Amenities__c' => appraisalOrder.Related_Collateral__r.Amenities__c
          };
        }
      }
    }

    public class RA_RB_RC_RD extends BaseComponent implements IAppraisalOrderComponent{     
      public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){   
        return new Component.c.AppraisalOrderSub_RA_RB_RC_RD(appraisalOrder=appraisalOrder);
      }
    
      protected override Set<String> handledCollateralCodes(){
        return new Set<String>{'RA','RB','RC','RD'};
      }
    
      protected override Map<String, Object> summaryFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c
          };
        }
      }
    
      protected override Map<String, Object> requiredFields(Boolean isOreo, EB_Appraisal_Order__c appraisalOrder){
        if(isOreo){
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.OREO_Account__r.Total_Land_Area_Acres__c
          };
        }else{
          return new Map<String, Object>{
            'Total_Land_Area_Acres__c' => appraisalOrder.Related_Collateral__r.Total_Land_Area_Acres__c
          };
        }
      }
    }

            

                  
        
                
    public static List<AppraisalOrderComponent.IAppraisalOrderComponent> getComponents(){
        List<AppraisalOrderComponent.IAppraisalOrderComponent> components = new List<AppraisalOrderComponent.IAppraisalOrderComponent>();
        components.add(new AppraisalOrderComponent.GC_GD());
        components.add(new AppraisalOrderComponent.CG());
        components.add(new AppraisalOrderComponent.CJ_IJ());
        components.add(new AppraisalOrderComponent.CK_IK());
        components.add(new AppraisalOrderComponent.QC_QD_QI_QJ());
        components.add(new AppraisalOrderComponent.CN_IN());
        components.add(new AppraisalOrderComponent.AC());
        components.add(new AppraisalOrderComponent.CC_CD());
        components.add(new AppraisalOrderComponent.BC());
        components.add(new AppraisalOrderComponent.CF());
        components.add(new AppraisalOrderComponent.CB_CQ_IQ_CT_IT());
        components.add(new AppraisalOrderComponent.CO());
        components.add(new AppraisalOrderComponent.CE_IE());
        components.add(new AppraisalOrderComponent.RA_RB_RC_RD());
        components.add(new AppraisalOrderComponent.CI_II());
        components.add(new AppraisalOrderComponent.AA());
        components.add(new AppraisalOrderComponent.CP_IP());
        components.add(new AppraisalOrderComponent.GA_GB());
        components.add(new AppraisalOrderComponent.EC());
        components.add(new AppraisalOrderComponent.IS());
        components.add(new AppraisalOrderComponent.FA_FB());
        components.add(new AppraisalOrderComponent.QA_QB_QE_QF_QG_QH_QK_QL());
        components.add(new AppraisalOrderComponent.DA());
        components.add(new AppraisalOrderComponent.CH_IH());
        components.add(new AppraisalOrderComponent.AB());
        components.add(new AppraisalOrderComponent.CL_IL());
        components.add(new AppraisalOrderComponent.FC());
        components.add(new AppraisalOrderComponent.CV_IV());
        components.add(new AppraisalOrderComponent.CA());
        return components;
    }
}