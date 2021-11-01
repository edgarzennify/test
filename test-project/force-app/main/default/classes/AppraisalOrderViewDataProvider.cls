public class AppraisalOrderViewDataProvider implements IAppraisalOrderViewDataProvider {
    
    public interface IAppraisalOrderViewDataProvider{
        EB_Appraisal_Order__c getAppraisalOrderForId(Id orderId);
        //EB_Appraisal_Order__c getAppraisalOrderFromCollateralId(Id collateralId);
        //EB_Appraisal_Order__c getAppraisalOrderFromOREOId(Id oreoId);
        void save(EB_Appraisal_Order__c appraisalOrder);
        String collateralOwner(EB_Appraisal_Order__c appraisalOrder);
    }

    public EB_Appraisal_Order__c getAppraisalOrderForId(Id orderId){
        return [SELECT Id, Name,CreatedBy.Name,CreatedDate, LastModifiedDate,LastModifiedBy.Name, OREO_Account__c, Order_Type__c, Date_Appraisal_Needed__c, Last_Appraisal_Date__c, 
                Last_Appraisal_Company__c, Is_SBA__c, Relationship_Manager__r.Name,Loan_Coordinator__r.Name, Relationship_Manager__c,
                Loan_Coordinator__c, Related_Entities_to_Be_Addressed__c, Appraisal_Order_Scope__c,Is_Forclosure_or_OREO__c,
                Property_Ownership__c, Details_Related_to_Subject__c,Special_Instructions_to_Bank_Officer__c, Appraisal_Company_Used__c,
                Loan_Exceeds_2M__c, Will_RM_Seek_Waiver__c, USPAP_Compliant__c, Estimated_Closing_Date__c,
                Transaction_Type__c,  Appraisal_User_Other__c,          
                Specify_Other_User__c, Occupancy_Relationship__c, Occupancy_Status__c ,Property_Status__c,Tax_Abatement__c,
                
                Related_Collateral__c,Related_Collateral__r.Appraisal_Order_Summary__c,
                OREO_Account__r.Appraisal_Order_Summary__c,Related_Collateral__r.Collateral_Owner__r.Name,
                Related_Collateral__r.Address__c, Related_Collateral__r.Zip_Code__c,Related_Collateral__r.City__c ,
                Related_Collateral__r.State__c ,Related_Collateral__r.EB_Appraisal_County__r.Name ,Related_Collateral__r.Inspection_Contact_Name__c,
                Related_Collateral__r.Inspection_Contact_Phone__c,Related_Collateral__r.Inspection_Contact_Sec_Phone__c ,Related_Collateral__r.Inspection_Contact_Email_Address__c,
                As_Completed_Value__c, As_Is_Value__c, As_Liquidated_Value__c,As_Stabilized_Value__c, Appraised_Value_reviewed__c,
                Oasis_Order_Number__c,Related_Collateral__r.Collateral_Code__r.Name, Related_Collateral__r.Collateral_Code__r.Collateral_Code_Id__c, OREO_Account__r.OREO_Address__c,
                OREO_Account__r.OREO_Collateral_Code__r.Name,OREO_Account__r.OREO_Collateral_Code__r.Collateral_Code_Id__c,Related_Collateral__r.Collateral_Owner__r.EB_UnitID__r.Name, OREO_Account__r.EB_Unit__r.Name,
                Tax_Increment_Financing_TIF__c,Tax_Credit_Involved__c, Related_Collateral__r.Street__c, FDIC_Valuation_Type__c, Valuation_Date__c,
                Reference__c, RM_Reviewed_OK_to_Order__c,Cost_Center__c,
                OREO_Account__r.Inspection_Contact_Name__c,OREO_Account__r.Inspection_Contact_Phone__c,
                OREO_Account__r.Inspection_Contact_Sec_Phone__c,OREO_Account__r.Inspection_Contact_Email_Address__c,
                OREO_Account__r.Appraisal_Company_Used__c,
                OREO_Account__r.FDIC_Valuation_Type__c, OREO_Account__r.Valuation_Date__c, 
                OREO_Account__r.As_Completed_Value__c, OREO_Account__r.As_Is_Value__c, OREO_Account__r.As_Liquidated_Value__c,OREO_Account__r.Appraised_Value__c,
                OREO_Account__r.As_Stabilized_Value__c, OREO_Account__r.Oasis_Order_Number__c,

                Related_Collateral__r.FDIC_Valuation_Type__c, Related_Collateral__r.Valuation_Date__c, Related_Collateral__r.As_Completed_Value__c, 
                Related_Collateral__r.As_Is_Value__c, Related_Collateral__r.As_Liquidated_Value__c,Related_Collateral__r.As_Stabilized_Value__c , Related_Collateral__r.Appraised_Value__c,
                Related_Collateral__r.Oasis_Order_Number__c,Related_Collateral__r.Appraisal_Company_Used__c, Related_Collateral__r.Name, 
                Related_Collateral__r.Key__c

                FROM EB_Appraisal_Order__c WHERE Id =:orderId];
    }  

    //public EB_Appraisal_Order__c getAppraisalOrderFromCollateralId(Id CollateralId)
 //   {
 //       EB_Collateral__c collateral = [SELECT ID, Name , Collateral_Code__r.Name , Collateral_Code__r.Collateral_Code_ID__c, 
 //               Type_of_Car_Wash__c,
 //               Collateral_Owner__r.Name, OwnerId, Street__c, Address__c,City__c,State__c, Zip_Code__c, EB_Appraisal_County__c,
 //               Inspection_Contact_Name__c,Inspection_Contact_Email_Address__c,Inspection_Contact_Phone__c,Inspection_Contact_Sec_Phone__c,
 //               Sub_Category__c, Retail_Building_Area_Sq_Ft__c,Commercial_Building_Area_Sq_Ft__c, Number_of_Units__c,Number_of_Out_Lots__c,Out_Lot_1_Size_Sq_Ft__c,
 //               Out_Lot_2_Size_Sq_Ft__c,Out_Lot_3_Size_Sq_Ft__c,Percent_Pre_Leased__c,Car_Wash_Equipment_Type__c,Number_of_Bays__c, Total_Land_Area_Acres__c,Legal_Description__c,EB_Appraisal_County__r.Name,
 //               Number_of_Mobile_Home_Pads__c, Mobile_Home_Park_Rating__c,Septic_Tank__c,City_Sewer__c,
 //               City_Water__c,Well_Water__c,Type_of_Pad__c,Other_Type_of_Pad__c,Number_of_Buildings__c,Single_Level__c,
 //               Townhouse__c,Sq_Ft_One_Bedroom_Units__c,Sq_Ft_Two_Bedroom_Units__c,Sq_Ft_Three_Bedroom_Units__c,Sq_Ft_Four_Bedroom_Units__c,Number_of_One_BR_Units__c,Number_of_Two_BR_Units__c,Number_of_Three_BR_Units__c,Number_of_Four_BR_Units__c,
 //               Excess_Land_Acreage__c,Amenities__c,Sq_Ft_of_House__c,Estimate_Value_of_House__c,
 //               Scope_of_Rehab_Details__c,Legal_Name_of_Subdivision__c,Lot_Number__c,Lot_Size__c,Corner_Lot__c,Cul_de_Sac_Lot__c,
 //               Sq_Ft_Unit_1__c,Sq_Ft_Unit_2__c,Sq_Ft_Unit_3__c,Sq_Ft_Unit_4__c,
 //               Estimated_Value_Unit_1__c,
 //               Estimated_Value_Unit_2__c,
 //               Estimated_Value_Unit_3__c,Estimated_Value_Unit_4__c,Name_of_Subdivision_Development__c,Land_Size_Acreage__c,
 //               Rental_Property__c,For_Sale_Property__c,Tax_Credit_Involved__c,Section_8_Housing_Vouchers__c,Sq_Ft_of_Building__c,Existing__c,
 //               New_Construction__c,Denomination__c,Tax_Exempt_Status__c,Type_of_School__c,Sq_Ft_of_Unit__c,Estimate_Value_of_Unit__c,
 //               Flag_Brand_of_Store__c,Car_Wash__c,Gas_Pumps__c,Renovation__c,Number_of_Acres_Res_Single_Fam__c,
 //               Number_of_Acres_Com_Office__c,Number_of_Acres_Industrial__c,Number_of_Acres_Retail__c,Land_Improvements__c,Describe_Improvements__c,
 //               Flag_Brand_of_Hotel_Motel__c,Number_of_Rooms__c,Free_Standing__c,Limited_Service__c,
 //               Full_Service__c,Resort__c,Rehabilitation__c,Number_of_Commercial_Lots__c,Number_of_Storage_Units__c,Sq_Ft_of_all_Buildings__c,
 //               Electric_Utilities_Provided_for_ea_Unit__c,Outside_Storage__c,Number_of_Units_of_Outside_Storage__c,Type_of_Use__c,Rentable_Sq_Ft__c,
 //               Number_of_Stories__c, Number_of_Beds__c,Private_Pay__c,Medicare__c,Medicaid__c,Veterans_Administration_Beds__c,
 //               Dementia_Alzheimers__c,Percent_of_Office_Finish__c,Year_Built__c,Number_of_Residential_Units__c,Number_of_Assisted_Living_Units__c,Number_of_Independent_Living_Units__c,Number_of_Skilled_Nursing_Beds__c,
 //               Seating_Capacity__c,Chain_Restaurant__c,Name_of_Chain_Restaurant__c,Utilities__c,Total_Sq_Ft_of_Building_Area__c,
 //               Number_of_Improved_Lots__c,Number_of_Acres_Excess_Unimproved_Land__c,Excess_Unimproved_Land__c,
 //               Number_of_Residential_Lots__c,Zoning_Classification__c,Projected_Number_of_Residential_Lots__c,Are_Utilities_in_the_Area__c,
 //               Gross_Bldg_Area__c,Percent_Occupied__c,Number_of_Tenants__c,Percent_Office__c,Plot_of_Lots__c,Percent_of_Office_Space__c,
 //               Name_of_Golf_Course__c,Contract_Amount_of_House__c,Appraisal_Order_Summary__c, Number_Of_Holes__c,Percent_Warehouse_Mfg_Space__c,
 //               Restricted_Rents__c,Privacy__c,Amenities_for_Golf_Course__c,Collateral_Owner__r.EB_UnitID__r.Name, Projected_Number_of_Commercial_Lots__c

 //               FROM EB_Collateral__c WHERE Id=: collateralId];
 //       return new EB_Appraisal_Order__c(Related_Collateral__c=collateral.Id, Related_Collateral__r = collateral);
 //   }

 //   public EB_Appraisal_Order__c getAppraisalOrderFromOREOId(Id oreoId)
 //   {
 //       EB_Account__c oreoAcct = [SELECT ID, Name , OREO_Collateral_Code__r.Name , OREO_Collateral_Code__r.Collateral_Code_ID__c, 
 //               Type_of_Car_Wash__c,
 //               OREO_Address__c,
 //               Inspection_Contact_Name__c,Inspection_Contact_Email_Address__c,Inspection_Contact_Phone__c,Inspection_Contact_Sec_Phone__c,
 //               Sub_Category__c, Retail_Building_Area_Sq_Ft__c,Commercial_Building_Area_Sq_Ft__c, Number_of_Units__c,Number_of_Out_Lots__c,Out_Lot_1_Size_Sq_Ft__c,
 //               Out_Lot_2_Size_Sq_Ft__c,Out_Lot_3_Size_Sq_Ft__c,Percent_Pre_Leased__c,Car_Wash_Equipment_Type__c,Number_of_Bays__c, Total_Land_Area_Acres__c,Legal_Description__c,
 //               Number_of_Mobile_Home_Pads__c, Mobile_Home_Park_Rating__c,Septic_Tank__c,City_Sewer__c,
 //               City_Water__c,Well_Water__c,Type_of_Pad__c,Other_Type_of_Pad__c,Number_of_Buildings__c,Single_Level__c,
 //               Townhouse__c,Sq_Ft_One_Bedroom_Units__c,Sq_Ft_Two_Bedroom_Units__c,Sq_Ft_Three_Bedroom_Units__c,Sq_Ft_Four_Bedroom_Units__c,Number_of_One_BR_Units__c,Number_of_Two_BR_Units__c,Number_of_Three_BR_Units__c,Number_of_Four_BR_Units__c,
 //               Excess_Land_Acreage__c,Amenities__c,Sq_Ft_of_House__c,Estimate_Value_of_House__c,
 //               Scope_of_Rehab_Details__c,Legal_Name_of_Subdivision__c,Lot_Number__c,Lot_Size__c,Corner_Lot__c,Cul_de_Sac_Lot__c,
 //               Sq_Ft_Unit_1__c,Sq_Ft_Unit_2__c,Sq_Ft_Unit_3__c,Sq_Ft_Unit_4__c,
 //               Estimated_Value_Unit_1__c,
 //               Estimated_Value_Unit_2__c,
 //               Estimated_Value_Unit_3__c,Estimated_Value_Unit_4__c,Name_of_Subdivision_Development__c,Land_Size_Acreage__c,
 //               Rental_Property__c,For_Sale_Property__c,Tax_Credit_Involved__c,Section_8_Housing_Vouchers__c,Sq_Ft_of_Building__c,Existing__c,
 //               New_Construction__c,Denomination__c,Tax_Exempt_Status__c,Type_of_School__c,Sq_Ft_of_Unit__c,Estimate_Value_of_Unit__c,
 //               Flag_Brand_of_Store__c,Car_Wash__c,Gas_Pumps__c,Renovation__c,Number_of_Acres_Res_Single_Fam__c,
 //               Number_of_Acres_Com_Office__c,Number_of_Acres_Industrial__c,Number_of_Acres_Retail__c,Land_Improvements__c,Describe_Improvements__c,
 //               Flag_Brand_of_Hotel_Motel__c,Number_of_Rooms__c,Free_Standing__c,Limited_Service__c,
 //               Full_Service__c,Resort__c,Rehabilitation__c,Number_of_Commercial_Lots__c,Number_of_Storage_Units__c,Sq_Ft_of_all_Buildings__c,
 //               Electric_Utilities_Provided_for_ea_Unit__c,Outside_Storage__c,Number_of_Units_of_Outside_Storage__c,Type_of_Use__c,Rentable_Sq_Ft__c,
 //               Number_of_Stories__c, Number_of_Beds__c,Private_Pay__c,Medicare__c,Medicaid__c,Veterans_Administration_Beds__c,
 //               Dementia_Alzheimers__c,Percent_of_Office_Finish__c,Year_Built__c,Number_of_Residential_Units__c,Number_of_Assisted_Living_Units__c,Number_of_Independent_Living_Units__c,Number_of_Skilled_Nursing_Beds__c,
 //               Seating_Capacity__c,Chain_Restaurant__c,Name_of_Chain_Restaurant__c,Utilities__c,
 //               Number_of_Improved_Lots__c,Number_of_Acres_Excess_Unimproved_Land__c,Excess_Unimproved_Land__c,Percent_of_Office_Space__c,
 //               Number_of_Residential_Lots__c,Zoning_Classification__c,Projected_Number_of_Residential_Lots__c,Are_Utilities_in_the_Area__c,
 //               Gross_Bldg_Area__c,Percent_Occupied__c,Number_of_Tenants__c,Percent_Office__c,Plot_of_Lots__c,Total_Sq_Ft_of_Building_Area__c,
 //               Name_of_Golf_Course__c,Contract_Amount_of_House__c,Appraisal_Order_Summary__c, Number_Of_Holes__c,Percent_Warehouse_Mfg_Space__c,
 //               Restricted_Rents__c,Privacy__c,Amenities_for_Golf_Course__c,EB_Unit__r.Name, Projected_Number_of_Commercial_Lots__c

 //               FROM EB_Account__c WHERE Id=: oreoId];
 //       return new EB_Appraisal_Order__c(OREO_Account__c=oreoAcct.Id, OREO_Account__r = oreoAcct);
 //   }

    public void save(EB_Appraisal_Order__c appraisalOrder){
        if(appraisalOrder.Id!=null){
            update appraisalOrder;
        }else{
            insert appraisalOrder;
        }
        if(appraisalOrder.OREO_Account__c != null){
            appraisalOrder.OREO_Account__r.USPAP_Compliant__c = appraisalOrder.USPAP_Compliant__c;
            appraisalOrder.OREO_Account__r.FDIC_Valuation_Type__c = appraisalOrder.FDIC_Valuation_Type__c;
            appraisalOrder.OREO_Account__r.Valuation_Date__c = appraisalOrder.Valuation_Date__c;
            appraisalOrder.OREO_Account__r.As_Completed_Value__c = appraisalOrder.As_Completed_Value__c; 
            appraisalOrder.OREO_Account__r.As_Is_Value__c = appraisalOrder.As_Is_Value__c;
            appraisalOrder.OREO_Account__r.As_Liquidated_Value__c = appraisalOrder.As_Liquidated_Value__c;
            appraisalOrder.OREO_Account__r.As_Stabilized_Value__c = appraisalOrder.As_Stabilized_Value__c;
            appraisalOrder.OREO_Account__r.Appraised_Value__c = appraisalOrder.Appraised_Value_reviewed__c;
            appraisalOrder.OREO_Account__r.Appraisal_Company_Used__c = appraisalOrder.Appraisal_Company_Used__c;
            appraisalOrder.OREO_Account__r.Oasis_Order_Number__c = appraisalOrder.Oasis_Order_Number__c;
            update appraisalOrder.OREO_Account__r;
        }else{
            appraisalOrder.Related_Collateral__r.USPAP_Compliant__c = appraisalOrder.USPAP_Compliant__c;
            appraisalOrder.Related_Collateral__r.FDIC_Valuation_Type__c = appraisalOrder.FDIC_Valuation_Type__c;
            appraisalOrder.Related_Collateral__r.Valuation_Date__c = appraisalOrder.Valuation_Date__c;
            appraisalOrder.Related_Collateral__r.As_Completed_Value__c = appraisalOrder.As_Completed_Value__c; 
            appraisalOrder.Related_Collateral__r.As_Is_Value__c = appraisalOrder.As_Is_Value__c;
            appraisalOrder.Related_Collateral__r.As_Liquidated_Value__c = appraisalOrder.As_Liquidated_Value__c;
            appraisalOrder.Related_Collateral__r.As_Stabilized_Value__c = appraisalOrder.As_Stabilized_Value__c;
            appraisalOrder.Related_Collateral__r.Appraisal_Company_Used__c = appraisalOrder.Appraisal_Company_Used__c;
            appraisalOrder.Related_Collateral__r.Oasis_Order_Number__c = appraisalOrder.Oasis_Order_Number__c;
            appraisalOrder.Related_Collateral__r.Appraised_Value__c = appraisalOrder.Appraised_Value_reviewed__c;
            update appraisalOrder.Related_Collateral__r;
        }
    }

    public String collateralOwner(EB_Appraisal_Order__c appraisalOrder){
        if(appraisalOrder.Related_Collateral__c!=null){
            if( appraisalOrder.Related_Collateral__r.Collateral_Owner__c==null){
                List<EB_Collateral_Client_Relationship__c> owners = [SELECT Entity_Name__c FROM EB_Collateral_Client_Relationship__c WHERE EB_Collateral_ID__c =: appraisalOrder.Related_Collateral__c limit 1];
                 return String.valueOf(owners.get(0).Entity_Name__c); 
            }else{
                return appraisalOrder.Related_Collateral__r.Collateral_Owner__r.Name;
            }
        }
        return '';
    }
}