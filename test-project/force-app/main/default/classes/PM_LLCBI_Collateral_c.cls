public class PM_LLCBI_Collateral_c extends PM_SObject {
    public String LLCBI_Collateral_Name_c {get;set;}
    public String Change_Collateral_Code_c {get;set;}
    public String Sync_Key_c {get;set;}
    public String LLCBI_Description_c {get;set;}
    public Decimal LLCBI_Lendable_Value_c {get;set;}
    public String Assignment_of_Rent_c {get;set;}
    public String Flood_Insurance_Required_c {get;set;}
    public Decimal Appraised_Value_reviewed_c {get;set;}
    public Date Valuation_Date_c {get;set;}
    public String LLCBI_Street_Address_c {get;set;}
    public String LLCBI_City_c {get;set;}
    public String LLCBI_State_c {get;set;}
    public String LLCBI_Zip_Code_c {get;set;}
    public PM_Account Primary_Owner_r {get;set;}
    public PM_LLCBI_Collateral_Type_c LLCBI_Collateral_Type_r {get;set;}
    public PM_LLCBI_Collateral_Type_c Modified_Collateral_Type_r {get;set;}
    public String LLC_BI_Parcel_Number_c {get;set;}
}