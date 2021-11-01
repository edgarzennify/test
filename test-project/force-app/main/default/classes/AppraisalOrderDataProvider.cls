public class AppraisalOrderDataProvider implements IAppraisalOrderDataProvider{
    public interface IAppraisalOrderDataProvider{
        EB_Appraisal_Order__c getAppraisalOrderForId(Id orderId);
        EB_Appraisal_Order__c getAppraisalOrderFromCollateralId(Id collateralId);
        EB_Appraisal_Order__c getAppraisalOrderFromOREOId(Id oreoId);
        void save(EB_Appraisal_Order__c appraisalOrder);
        void insertAttachment(Attachment attach);
        String collateralOwner(EB_Appraisal_Order__c appraisalOrder);
        List<EB_Unit__c> getCostCenters();
    }
    public void save(EB_Appraisal_Order__c appraisalOrder){
        upsert appraisalOrder;
        
        if(appraisalOrder.OREO_Account__c != null){
            update appraisalOrder.OREO_Account__r;
        }else{
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

    public List<EB_Unit__c> getCostCenters(){
       return [SELECT Id, Center__c, Name FROM EB_Unit__c Order By Name Limit 500 ];
    }

    public EB_Appraisal_Order__c getAppraisalOrderForId(Id orderId){
        return [SELECT Id, Name, OREO_Account__c, Order_Type__c, Date_Appraisal_Needed__c, Last_Appraisal_Date__c, Last_Appraisal_Company__c,
                Is_SBA__c,Relationship_Manager__r.Name,Loan_Coordinator__r.Name, Relationship_Manager__c,Loan_Coordinator__c, Related_Entities_to_Be_Addressed__c, Appraisal_Order_Scope__c,Is_Forclosure_or_OREO__c,
                Property_Ownership__c, Details_Related_to_Subject__c,Special_Instructions_to_Bank_Officer__c, Loan_Exceeds_2M__c, Will_RM_Seek_Waiver__c, Submit_Order__c,Tax_Increment_Financing_TIF__c,Tax_Credit_Involved__c,
                Related_Collateral__c, Cost_Center__c, Reference__c, RM_Reviewed_OK_to_Order__c,
                Estimated_Closing_Date__c,Transaction_Type__c,  Appraisal_User_Other__c,
                Specify_Other_User__c, Occupancy_Relationship__c, Occupancy_Status__c ,Property_Status__c,Tax_Abatement__c,

                Related_Collateral__r.Type_of_Car_Wash__c, 
                Related_Collateral__r.Collateral_Code__r.Name , Related_Collateral__r.Collateral_Code__r.Collateral_Code_ID__c, 
                Related_Collateral__r.Collateral_Owner__r.Name,Related_Collateral__r.Collateral_Owner__c,
                Related_Collateral__r.Street__c, Related_Collateral__r.Address__c,Related_Collateral__r.City__c,
                Related_Collateral__r.State__c, Related_Collateral__r.Zip_Code__c, Related_Collateral__r.EB_Appraisal_County__c,
                Related_Collateral__r.Inspection_Contact_Name__c,Related_Collateral__r.Inspection_Contact_Email_Address__c,
                Related_Collateral__r.Inspection_Contact_Phone__c,Related_Collateral__r.Inspection_Contact_Sec_Phone__c,
                Related_Collateral__r.Sub_Category__c, Related_Collateral__r.Retail_Building_Area_Sq_Ft__c,Related_Collateral__r.Commercial_Building_Area_Sq_Ft__c, Related_Collateral__r.Number_of_Units__c,
                Related_Collateral__r.Number_of_Out_Lots__c,Related_Collateral__r.Out_Lot_1_Size_Sq_Ft__c,
                Related_Collateral__r.Out_Lot_2_Size_Sq_Ft__c,Related_Collateral__r.Out_Lot_3_Size_Sq_Ft__c,
                Related_Collateral__r.Percent_Pre_Leased__c,Related_Collateral__r.Car_Wash_Equipment_Type__c,Related_Collateral__r.Number_of_Bays__c,
                Related_Collateral__r.Total_Land_Area_Acres__c,Related_Collateral__r.Legal_Description__c,Related_Collateral__r.EB_Appraisal_County__r.Name,
                Related_Collateral__r.Number_of_Mobile_Home_Pads__c, Related_Collateral__r.Mobile_Home_Park_Rating__c,Related_Collateral__r.Septic_Tank__c,
                Related_Collateral__r.City_Sewer__c, Related_Collateral__r.City_Water__c,Related_Collateral__r.Well_Water__c,Related_Collateral__r.Type_of_Pad__c,
                Related_Collateral__r.Other_Type_of_Pad__c,Related_Collateral__r.Number_of_Buildings__c,Related_Collateral__r.Single_Level__c,
                Related_Collateral__r.Townhouse__c,Related_Collateral__r.Sq_Ft_One_Bedroom_Units__c,Related_Collateral__r.Sq_Ft_Two_Bedroom_Units__c,Related_Collateral__r.Sq_Ft_Three_Bedroom_Units__c,
                Related_Collateral__r.Sq_Ft_Four_Bedroom_Units__c,Related_Collateral__r.Utilities__c,
                Related_Collateral__r.Number_of_One_BR_Units__c,Related_Collateral__r.Number_of_Two_BR_Units__c,
                Related_Collateral__r.Number_of_Three_BR_Units__c,Related_Collateral__r.Number_of_Four_BR_Units__c,Related_Collateral__r.Excess_Land_Acreage__c,
                Related_Collateral__r.Amenities__c,Related_Collateral__r.Sq_Ft_of_House__c,Related_Collateral__r.Estimate_Value_of_House__c,
                Related_Collateral__r.Scope_of_Rehab_Details__c,Related_Collateral__r.Legal_Name_of_Subdivision__c,Related_Collateral__r.Lot_Number__c,Related_Collateral__r.Lot_Size__c,
                Related_Collateral__r.Corner_Lot__c,Related_Collateral__r.Cul_de_Sac_Lot__c,Related_Collateral__r.Sq_Ft_Unit_1__c,Related_Collateral__r.Sq_Ft_Unit_2__c,Related_Collateral__r.Sq_Ft_Unit_3__c,
                Related_Collateral__r.Sq_Ft_Unit_4__c,
                Related_Collateral__r.Estimated_Value_Unit_1__c,
                Related_Collateral__r.Estimated_Value_Unit_2__c,Related_Collateral__r.Estimated_Value_Unit_3__c,
                Related_Collateral__r.Estimated_Value_Unit_4__c,Related_Collateral__r.Name_of_Subdivision_Development__c,Related_Collateral__r.Land_Size_Acreage__c,
                Related_Collateral__r.Rental_Property__c,Related_Collateral__r.For_Sale_Property__c,Related_Collateral__r.Tax_Credit_Involved__c,
                Related_Collateral__r.Section_8_Housing_Vouchers__c,Related_Collateral__r.Sq_Ft_of_Building__c,Related_Collateral__r.Existing__c,Related_Collateral__r.New_Construction__c,
                Related_Collateral__r.Denomination__c,Related_Collateral__r.Tax_Exempt_Status__c,Related_Collateral__r.Type_of_School__c,Related_Collateral__r.Sq_Ft_of_Unit__c,
                Related_Collateral__r.Estimate_Value_of_Unit__c,Related_Collateral__r.Flag_Brand_of_Store__c,Related_Collateral__r.Car_Wash__c,Related_Collateral__r.Gas_Pumps__c,
                Related_Collateral__r.Renovation__c,Related_Collateral__r.Number_of_Acres_Res_Single_Fam__c,
                Related_Collateral__r.Number_of_Acres_Com_Office__c,Related_Collateral__r.Number_of_Acres_Industrial__c,Related_Collateral__r.Number_of_Acres_Retail__c,
                Related_Collateral__r.Land_Improvements__c,Related_Collateral__r.Describe_Improvements__c,
                Related_Collateral__r.Flag_Brand_of_Hotel_Motel__c,Related_Collateral__r.Number_of_Rooms__c,Related_Collateral__r.Free_Standing__c,Related_Collateral__r.Limited_Service__c,
                Related_Collateral__r.Full_Service__c,Related_Collateral__r.Resort__c,Related_Collateral__r.Rehabilitation__c,Related_Collateral__r.Number_of_Commercial_Lots__c,
                Related_Collateral__r.Number_of_Storage_Units__c,Related_Collateral__r.Sq_Ft_of_all_Buildings__c,Related_Collateral__r.Electric_Utilities_Provided_for_ea_Unit__c,Related_Collateral__r.Outside_Storage__c,
                Related_Collateral__r.Number_of_Units_of_Outside_Storage__c,Related_Collateral__r.Type_of_Use__c,Related_Collateral__r.Rentable_Sq_Ft__c,Related_Collateral__r.Number_of_Stories__c,
                Related_Collateral__r.Number_of_Beds__c,Related_Collateral__r.Private_Pay__c,Related_Collateral__r.Medicare__c,Related_Collateral__r.Medicaid__c,
                Related_Collateral__r.Veterans_Administration_Beds__c,Related_Collateral__r.Dementia_Alzheimers__c,Related_Collateral__r.Percent_of_Office_Finish__c,
                Related_Collateral__r.Year_Built__c,Related_Collateral__r.Seating_Capacity__c,Related_Collateral__r.Chain_Restaurant__c,Related_Collateral__r.Name_of_Chain_Restaurant__c,Related_Collateral__r.Number_of_Improved_Lots__c,Related_Collateral__r.Number_of_Acres_Excess_Unimproved_Land__c,
                Related_Collateral__r.Excess_Unimproved_Land__c,Related_Collateral__r.Number_of_Residential_Lots__c,Related_Collateral__r.Number_of_Residential_Units__c,
                Related_Collateral__r.Zoning_Classification__c,Related_Collateral__r.Projected_Number_of_Residential_Lots__c,Related_Collateral__r.Are_Utilities_in_the_Area__c,
                Related_Collateral__r.Gross_Bldg_Area__c,Related_Collateral__r.Percent_Occupied__c,Related_Collateral__r.Number_of_Tenants__c,Related_Collateral__r.Percent_Office__c,
                Related_Collateral__r.Plot_of_Lots__c,Related_Collateral__r.Name_of_Golf_Course__c,Related_Collateral__r.Percent_of_Office_Space__c,
                Related_Collateral__r.Contract_Amount_of_House__c,Related_Collateral__r.Appraisal_Order_Summary__c,Related_Collateral__r.Number_Of_Holes__c,
                Related_Collateral__r.Percent_Warehouse_Mfg_Space__c,Related_Collateral__r.Number_of_Assisted_Living_Units__c,Related_Collateral__r.Number_of_Independent_Living_Units__c,Related_Collateral__r.Number_of_Skilled_Nursing_Beds__c,
                Related_Collateral__r.Restricted_Rents__c,Related_Collateral__r.Privacy__c, Related_Collateral__r.Total_Sq_Ft_of_Building_Area__c,
                Related_Collateral__r.Amenities_for_Golf_Course__c,Related_Collateral__r.Collateral_Owner__r.EB_UnitID__r.Name,
                Related_Collateral__r.Projected_Number_of_Commercial_Lots__c,
                
                OREO_Account__r.Type_of_Car_Wash__c, OREO_Account__r.Projected_Number_of_Commercial_Lots__c,
                OREO_Account__r.OREO_Collateral_Code__r.Name , OREO_Account__r.OREO_Collateral_Code__r.Collateral_Code_ID__c, 
                OREO_Account__r.OREO_Address__c,
                OREO_Account__r.Inspection_Contact_Name__c,OREO_Account__r.Inspection_Contact_Email_Address__c,
                OREO_Account__r.Inspection_Contact_Phone__c,OREO_Account__r.Inspection_Contact_Sec_Phone__c,OREO_Account__r.Sub_Category__c, OREO_Account__r.Retail_Building_Area_Sq_Ft__c, 
                OREO_Account__r.Commercial_Building_Area_Sq_Ft__c,OREO_Account__r.Number_of_Units__c, OREO_Account__r.Number_of_Out_Lots__c,OREO_Account__r.Out_Lot_1_Size_Sq_Ft__c, OREO_Account__r.Out_Lot_2_Size_Sq_Ft__c,
                OREO_Account__r.Out_Lot_3_Size_Sq_Ft__c,OREO_Account__r.Percent_Pre_Leased__c,OREO_Account__r.Car_Wash_Equipment_Type__c,
                OREO_Account__r.Number_of_Bays__c,OREO_Account__r.Total_Land_Area_Acres__c,OREO_Account__r.Legal_Description__c,
                OREO_Account__r.Number_of_Mobile_Home_Pads__c, OREO_Account__r.Mobile_Home_Park_Rating__c,OREO_Account__r.Septic_Tank__c,
                OREO_Account__r.City_Sewer__c, OREO_Account__r.City_Water__c,OREO_Account__r.Well_Water__c,OREO_Account__r.Type_of_Pad__c,
                OREO_Account__r.Other_Type_of_Pad__c,OREO_Account__r.Number_of_Buildings__c,OREO_Account__r.Single_Level__c,
                OREO_Account__r.Townhouse__c,OREO_Account__r.Sq_Ft_One_Bedroom_Units__c,OREO_Account__r.Sq_Ft_Two_Bedroom_Units__c,OREO_Account__r.Sq_Ft_Three_Bedroom_Units__c,
                OREO_Account__r.Sq_Ft_Four_Bedroom_Units__c, OREO_Account__r.Utilities__c,
                OREO_Account__r.Number_of_One_BR_Units__c,OREO_Account__r.Number_of_Two_BR_Units__c,
                OREO_Account__r.Number_of_Three_BR_Units__c,OREO_Account__r.Number_of_Four_BR_Units__c,OREO_Account__r.Excess_Land_Acreage__c,OREO_Account__r.Amenities__c,
                OREO_Account__r.Sq_Ft_of_House__c,OREO_Account__r.Estimate_Value_of_House__c,
                OREO_Account__r.Scope_of_Rehab_Details__c,OREO_Account__r.Legal_Name_of_Subdivision__c,OREO_Account__r.Lot_Number__c,OREO_Account__r.Lot_Size__c,
                OREO_Account__r.Corner_Lot__c,OREO_Account__r.Cul_de_Sac_Lot__c,OREO_Account__r.Sq_Ft_Unit_1__c,OREO_Account__r.Sq_Ft_Unit_2__c,OREO_Account__r.Sq_Ft_Unit_3__c,
                OREO_Account__r.Sq_Ft_Unit_4__c,
                OREO_Account__r.Estimated_Value_Unit_1__c,
                OREO_Account__r.Estimated_Value_Unit_2__c,OREO_Account__r.Estimated_Value_Unit_3__c,
                OREO_Account__r.Estimated_Value_Unit_4__c,OREO_Account__r.Name_of_Subdivision_Development__c,OREO_Account__r.Land_Size_Acreage__c,
                OREO_Account__r.Rental_Property__c,OREO_Account__r.For_Sale_Property__c,OREO_Account__r.Tax_Credit_Involved__c,
                OREO_Account__r.Section_8_Housing_Vouchers__c,OREO_Account__r.Sq_Ft_of_Building__c,OREO_Account__r.Existing__c,OREO_Account__r.New_Construction__c,
                OREO_Account__r.Denomination__c,OREO_Account__r.Tax_Exempt_Status__c,OREO_Account__r.Type_of_School__c,OREO_Account__r.Sq_Ft_of_Unit__c,
                OREO_Account__r.Estimate_Value_of_Unit__c,OREO_Account__r.Flag_Brand_of_Store__c,OREO_Account__r.Car_Wash__c,OREO_Account__r.Gas_Pumps__c,
                OREO_Account__r.Renovation__c,OREO_Account__r.Number_of_Acres_Res_Single_Fam__c,
                OREO_Account__r.Number_of_Acres_Com_Office__c,OREO_Account__r.Number_of_Acres_Industrial__c,OREO_Account__r.Number_of_Acres_Retail__c,
                OREO_Account__r.Land_Improvements__c,OREO_Account__r.Describe_Improvements__c, OREO_Account__r.Number_of_Assisted_Living_Units__c,OREO_Account__r.Number_of_Independent_Living_Units__c,OREO_Account__r.Number_of_Skilled_Nursing_Beds__c,
                OREO_Account__r.Flag_Brand_of_Hotel_Motel__c,OREO_Account__r.Number_of_Rooms__c,OREO_Account__r.Free_Standing__c,OREO_Account__r.Limited_Service__c,
                OREO_Account__r.Full_Service__c,OREO_Account__r.Resort__c,OREO_Account__r.Rehabilitation__c,OREO_Account__r.Number_of_Commercial_Lots__c,
                OREO_Account__r.Number_of_Storage_Units__c,OREO_Account__r.Sq_Ft_of_all_Buildings__c,OREO_Account__r.Electric_Utilities_Provided_for_ea_Unit__c,OREO_Account__r.Outside_Storage__c,
                OREO_Account__r.Number_of_Units_of_Outside_Storage__c,OREO_Account__r.Type_of_Use__c,OREO_Account__r.Rentable_Sq_Ft__c,OREO_Account__r.Number_of_Stories__c,
                OREO_Account__r.Number_of_Beds__c,OREO_Account__r.Private_Pay__c,OREO_Account__r.Medicare__c,OREO_Account__r.Medicaid__c,
                OREO_Account__r.Veterans_Administration_Beds__c,OREO_Account__r.Dementia_Alzheimers__c,OREO_Account__r.Percent_of_Office_Finish__c,
                OREO_Account__r.Year_Built__c,OREO_Account__r.Seating_Capacity__c,OREO_Account__r.Chain_Restaurant__c,OREO_Account__r.Name_of_Chain_Restaurant__c,OREO_Account__r.Number_of_Improved_Lots__c,OREO_Account__r.Number_of_Acres_Excess_Unimproved_Land__c,
                OREO_Account__r.Excess_Unimproved_Land__c,OREO_Account__r.Number_of_Residential_Lots__c,OREO_Account__r.Number_of_Residential_Units__c,
                OREO_Account__r.Zoning_Classification__c,OREO_Account__r.Projected_Number_of_Residential_Lots__c,OREO_Account__r.Are_Utilities_in_the_Area__c,
                OREO_Account__r.Gross_Bldg_Area__c,OREO_Account__r.Percent_Occupied__c,OREO_Account__r.Number_of_Tenants__c,OREO_Account__r.Percent_Office__c,
                OREO_Account__r.Plot_of_Lots__c,OREO_Account__r.Name_of_Golf_Course__c, OREO_Account__r.Total_Sq_Ft_of_Building_Area__c,
                OREO_Account__r.Contract_Amount_of_House__c,OREO_Account__r.Appraisal_Order_Summary__c, OREO_Account__r.Number_Of_Holes__c,
                OREO_Account__r.Percent_Warehouse_Mfg_Space__c,OREO_Account__r.Restricted_Rents__c,OREO_Account__r.Percent_of_Office_Space__c,
                OREO_Account__r.Privacy__c,OREO_Account__r.Amenities_for_Golf_Course__c, OREO_Account__r.EB_Unit__r.Name

                FROM EB_Appraisal_Order__c WHERE Id =: orderId];
    }
    public EB_Appraisal_Order__c getAppraisalOrderFromCollateralId(Id CollateralId)
    {
        EB_Collateral__c collateral = [SELECT ID, Name , Collateral_Code__r.Name , Collateral_Code__r.Collateral_Code_ID__c, 
                Type_of_Car_Wash__c,
                Collateral_Owner__r.Name, OwnerId, Street__c, Address__c,City__c,State__c, Zip_Code__c, EB_Appraisal_County__c,
                Inspection_Contact_Name__c,Inspection_Contact_Email_Address__c,Inspection_Contact_Phone__c,Inspection_Contact_Sec_Phone__c,
                Sub_Category__c, Retail_Building_Area_Sq_Ft__c,Commercial_Building_Area_Sq_Ft__c, Number_of_Units__c,Number_of_Out_Lots__c,Out_Lot_1_Size_Sq_Ft__c,
                Out_Lot_2_Size_Sq_Ft__c,Out_Lot_3_Size_Sq_Ft__c,Percent_Pre_Leased__c,Car_Wash_Equipment_Type__c,Number_of_Bays__c, Total_Land_Area_Acres__c,Legal_Description__c,EB_Appraisal_County__r.Name,
                Number_of_Mobile_Home_Pads__c, Mobile_Home_Park_Rating__c,Septic_Tank__c,City_Sewer__c,
                City_Water__c,Well_Water__c,Type_of_Pad__c,Other_Type_of_Pad__c,Number_of_Buildings__c,Single_Level__c,
                Townhouse__c,Sq_Ft_One_Bedroom_Units__c,Sq_Ft_Two_Bedroom_Units__c,Sq_Ft_Three_Bedroom_Units__c,Sq_Ft_Four_Bedroom_Units__c,Number_of_One_BR_Units__c,Number_of_Two_BR_Units__c,Number_of_Three_BR_Units__c,Number_of_Four_BR_Units__c,
                Excess_Land_Acreage__c,Amenities__c,Sq_Ft_of_House__c,Estimate_Value_of_House__c,
                Scope_of_Rehab_Details__c,Legal_Name_of_Subdivision__c,Lot_Number__c,Lot_Size__c,Corner_Lot__c,Cul_de_Sac_Lot__c,
                Sq_Ft_Unit_1__c,Sq_Ft_Unit_2__c,Sq_Ft_Unit_3__c,Sq_Ft_Unit_4__c,
                Estimated_Value_Unit_1__c,
                Estimated_Value_Unit_2__c,
                Estimated_Value_Unit_3__c,Estimated_Value_Unit_4__c,Name_of_Subdivision_Development__c,Land_Size_Acreage__c,
                Rental_Property__c,For_Sale_Property__c,Tax_Credit_Involved__c,Section_8_Housing_Vouchers__c,Sq_Ft_of_Building__c,Existing__c,
                New_Construction__c,Denomination__c,Tax_Exempt_Status__c,Type_of_School__c,Sq_Ft_of_Unit__c,Estimate_Value_of_Unit__c,
                Flag_Brand_of_Store__c,Car_Wash__c,Gas_Pumps__c,Renovation__c,Number_of_Acres_Res_Single_Fam__c,
                Number_of_Acres_Com_Office__c,Number_of_Acres_Industrial__c,Number_of_Acres_Retail__c,Land_Improvements__c,Describe_Improvements__c,
                Flag_Brand_of_Hotel_Motel__c,Number_of_Rooms__c,Free_Standing__c,Limited_Service__c,
                Full_Service__c,Resort__c,Rehabilitation__c,Number_of_Commercial_Lots__c,Number_of_Storage_Units__c,Sq_Ft_of_all_Buildings__c,
                Electric_Utilities_Provided_for_ea_Unit__c,Outside_Storage__c,Number_of_Units_of_Outside_Storage__c,Type_of_Use__c,Rentable_Sq_Ft__c,
                Number_of_Stories__c, Number_of_Beds__c,Private_Pay__c,Medicare__c,Medicaid__c,Veterans_Administration_Beds__c,
                Dementia_Alzheimers__c,Percent_of_Office_Finish__c,Year_Built__c,Number_of_Residential_Units__c,Number_of_Assisted_Living_Units__c,Number_of_Independent_Living_Units__c,Number_of_Skilled_Nursing_Beds__c,
                Seating_Capacity__c,Chain_Restaurant__c,Name_of_Chain_Restaurant__c,Utilities__c,Total_Sq_Ft_of_Building_Area__c,
                Number_of_Improved_Lots__c,Number_of_Acres_Excess_Unimproved_Land__c,Excess_Unimproved_Land__c,
                Number_of_Residential_Lots__c,Zoning_Classification__c,Projected_Number_of_Residential_Lots__c,Are_Utilities_in_the_Area__c,
                Gross_Bldg_Area__c,Percent_Occupied__c,Number_of_Tenants__c,Percent_Office__c,Plot_of_Lots__c,Percent_of_Office_Space__c,
                Name_of_Golf_Course__c,Contract_Amount_of_House__c,Appraisal_Order_Summary__c, Number_Of_Holes__c,Percent_Warehouse_Mfg_Space__c,
                Restricted_Rents__c,Privacy__c,Amenities_for_Golf_Course__c,Collateral_Owner__r.EB_UnitID__r.Name, Projected_Number_of_Commercial_Lots__c

                FROM EB_Collateral__c WHERE Id=: collateralId];
        return new EB_Appraisal_Order__c(Related_Collateral__c=collateral.Id, Related_Collateral__r = collateral);
    }


    public EB_Appraisal_Order__c getAppraisalOrderFromOREOId(Id oreoId)
    {
        EB_Account__c oreoAcct = [SELECT ID, Name , OREO_Collateral_Code__r.Name , OREO_Collateral_Code__r.Collateral_Code_ID__c, 
                Type_of_Car_Wash__c,
                OREO_Address__c,
                Inspection_Contact_Name__c,Inspection_Contact_Email_Address__c,Inspection_Contact_Phone__c,Inspection_Contact_Sec_Phone__c,
                Sub_Category__c, Retail_Building_Area_Sq_Ft__c,Commercial_Building_Area_Sq_Ft__c, Number_of_Units__c,Number_of_Out_Lots__c,Out_Lot_1_Size_Sq_Ft__c,
                Out_Lot_2_Size_Sq_Ft__c,Out_Lot_3_Size_Sq_Ft__c,Percent_Pre_Leased__c,Car_Wash_Equipment_Type__c,Number_of_Bays__c, Total_Land_Area_Acres__c,Legal_Description__c,
                Number_of_Mobile_Home_Pads__c, Mobile_Home_Park_Rating__c,Septic_Tank__c,City_Sewer__c,
                City_Water__c,Well_Water__c,Type_of_Pad__c,Other_Type_of_Pad__c,Number_of_Buildings__c,Single_Level__c,
                Townhouse__c,Sq_Ft_One_Bedroom_Units__c,Sq_Ft_Two_Bedroom_Units__c,Sq_Ft_Three_Bedroom_Units__c,Sq_Ft_Four_Bedroom_Units__c,Number_of_One_BR_Units__c,Number_of_Two_BR_Units__c,Number_of_Three_BR_Units__c,Number_of_Four_BR_Units__c,
                Excess_Land_Acreage__c,Amenities__c,Sq_Ft_of_House__c,Estimate_Value_of_House__c,
                Scope_of_Rehab_Details__c,Legal_Name_of_Subdivision__c,Lot_Number__c,Lot_Size__c,Corner_Lot__c,Cul_de_Sac_Lot__c,
                Sq_Ft_Unit_1__c,Sq_Ft_Unit_2__c,Sq_Ft_Unit_3__c,Sq_Ft_Unit_4__c,
                Estimated_Value_Unit_1__c,
                Estimated_Value_Unit_2__c,
                Estimated_Value_Unit_3__c,Estimated_Value_Unit_4__c,Name_of_Subdivision_Development__c,Land_Size_Acreage__c,
                Rental_Property__c,For_Sale_Property__c,Tax_Credit_Involved__c,Section_8_Housing_Vouchers__c,Sq_Ft_of_Building__c,Existing__c,
                New_Construction__c,Denomination__c,Tax_Exempt_Status__c,Type_of_School__c,Sq_Ft_of_Unit__c,Estimate_Value_of_Unit__c,
                Flag_Brand_of_Store__c,Car_Wash__c,Gas_Pumps__c,Renovation__c,Number_of_Acres_Res_Single_Fam__c,
                Number_of_Acres_Com_Office__c,Number_of_Acres_Industrial__c,Number_of_Acres_Retail__c,Land_Improvements__c,Describe_Improvements__c,
                Flag_Brand_of_Hotel_Motel__c,Number_of_Rooms__c,Free_Standing__c,Limited_Service__c,
                Full_Service__c,Resort__c,Rehabilitation__c,Number_of_Commercial_Lots__c,Number_of_Storage_Units__c,Sq_Ft_of_all_Buildings__c,
                Electric_Utilities_Provided_for_ea_Unit__c,Outside_Storage__c,Number_of_Units_of_Outside_Storage__c,Type_of_Use__c,Rentable_Sq_Ft__c,
                Number_of_Stories__c, Number_of_Beds__c,Private_Pay__c,Medicare__c,Medicaid__c,Veterans_Administration_Beds__c,
                Dementia_Alzheimers__c,Percent_of_Office_Finish__c,Year_Built__c,Number_of_Residential_Units__c,Number_of_Assisted_Living_Units__c,Number_of_Independent_Living_Units__c,Number_of_Skilled_Nursing_Beds__c,
                Seating_Capacity__c,Chain_Restaurant__c,Name_of_Chain_Restaurant__c,Utilities__c,
                Number_of_Improved_Lots__c,Number_of_Acres_Excess_Unimproved_Land__c,Excess_Unimproved_Land__c,Percent_of_Office_Space__c,
                Number_of_Residential_Lots__c,Zoning_Classification__c,Projected_Number_of_Residential_Lots__c,Are_Utilities_in_the_Area__c,
                Gross_Bldg_Area__c,Percent_Occupied__c,Number_of_Tenants__c,Percent_Office__c,Plot_of_Lots__c,Total_Sq_Ft_of_Building_Area__c,
                Name_of_Golf_Course__c,Contract_Amount_of_House__c,Appraisal_Order_Summary__c, Number_Of_Holes__c,Percent_Warehouse_Mfg_Space__c,
                Restricted_Rents__c,Privacy__c,Amenities_for_Golf_Course__c,EB_Unit__r.Name, Projected_Number_of_Commercial_Lots__c

                FROM EB_Account__c WHERE Id=: oreoId];
        return new EB_Appraisal_Order__c(OREO_Account__c=oreoAcct.Id, OREO_Account__r = oreoAcct);
    }

    public void insertAttachment(Attachment attach){
        insert attach;
    }
}