public class LoanBoardingDataProvider implements LoanBoarding.IDataProvider {
    
    public PM_LLCBI_Loan_c getnCinoLoan(Id loanId) {
        LLC_BI__Loan__c ln = [
            SELECT 
                Id, 
                Name,
                LLC_BI__Product_Type__c,
                LLC_BI__Product_Line__c,
                LLC_BI__Product__c,
                LLC_BI__Amount_Available__c,
                LLC_BI__Amount__c,
                Application__c,
                Account_Number__c,
                LLC_BI__lookupKey__c,
                LLC_BI__Account__c,
                LLC_BI__isRenewal__c,
                LLC_BI__Is_Modification__c,
                Channel__c,
                Reg_O_Loan__c,
                Employee_Loan__c,
                LLC_BI__Risk_Grade__c,
                Niche_Products__c,
                Niche_Products_fx__c,
                Loan_Characteristics__c,
                Use_of_Funds_Purpose__c,
                Other_Purpose_Description__c,
                LC_Comments__c,
                RM_Comments__c,
                Lending_Strategy__c,
                LLC_BI__InterestRate__c,
                LLC_BI__First_Payment_Date__c,
                LLC_BI__Amortized_Term_Months__c,
                LLC_BI__Term_Months__c,
                LLC_BI__Maturity_Date__c,
                LLC_BI__Pricing_Basis__c,
                LLC_BI__Payment_Type__c,
                LLC_BI__Payment_Schedule__c,
                LLC_BI__Index__c,
                LLC_BI__Spread__c,
                LLC_BI__Rate_Floor__c,
                LLC_BI__Rate_Ceiling__c,
                LLC_BI__Monthly_Payment__c,
                LLC_BI__Interest_Rate_Adjustment_Frequency__c,
                Application_Number__c,
            	Military_Lending_Act__c,
            	Is_Loan_to_Gov_t_Related_Entity__c,
                Is_Repayment_Reliant_on_Ag_Income__c,
            	Is_Loan_to_Financial_Institution__c,
            	Financial_Institution_Accept_Deposits__c,
            	Immediate_Funding__c,
            	Wire_Amount__c,
                Disbursing_Instructions__c,
                COVID_19_Related_Loan__c,
                EB_Industry_Code__r.Name,
                Originating_Officer__r.Name,
                LLC_BI__Loan_Officer__r.Name,
                Unit__r.Name,
            	Unit__r.Branch_Number__c,
                LLC_BI__Account__r.Id,
                LLC_BI__Account__r.Name,
                LLC_BI__Account__r.Type,
                LLC_BI__Account__r.RecordType.Name,
                LLC_BI__Account__r.BillingStreet,
                LLC_BI__Account__r.BillingCity,
                LLC_BI__Account__r.BillingPostalCode,
                LLC_BI__Account__r.BillingState,
            	CreatedBy.Name,
                (
                    SELECT
                        Id,
                        Name, 
                        Description__c,
                        LLC_BI__Lien_Position__c,
                        LLC_BI__Collateral_Type__c,
                        LLC_BI__Current_Lendable_Value__c,
                        LLC_BI__Is_Primary__c,
                        LLC_BI__Loan__c,
                        LLC_BI__Loan__r.Name,
                        LLC_BI__Loan__r.LLC_BI__lookupKey__c,
                        Abundance_of_Caution__c,                        
                        LLC_BI__Collateral__r.Id,
                        LLC_BI__Collateral__r.Name,                     
                        LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c,
                        LLC_BI__Collateral__r.Change_Collateral_Code__c,
                        LLC_BI__Collateral__r.Sync_Key__c,
                        LLC_BI__Collateral__r.LLC_BI__Description__c,
                        LLC_BI__Collateral__r.CreatedDate,
                        LLC_BI__Collateral__r.LLC_BI__Lendable_Value__c,
                        LLC_BI__Collateral__r.Assignment_of_Rent__c,
                        LLC_BI__Collateral__r.Flood_Insurance_Required__c,
                        LLC_BI__Collateral__r.Appraised_Value_reviewed__c,
                        LLC_BI__Collateral__r.Valuation_Date__c,
                        LLC_BI__Collateral__r.LLC_BI__Street_Address__c,
                        LLC_BI__Collateral__r.LLC_BI__City__c,
                        LLC_BI__Collateral__r.LLC_BI__State__c,
                        LLC_BI__Collateral__r.LLC_BI__Zip_Code__c,
                        LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Name,
                        LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.LLC_BI__Collateral_Code__c,
                        LLC_BI__Collateral__r.Modified_Collateral_Type__r.Name,
                        LLC_BI__Collateral__r.Modified_Collateral_Type__r.LLC_BI__Collateral_Code__c,
                        LLC_BI__Collateral__r.Primary_Owner__r.Id,
                        LLC_BI__Collateral__r.Primary_Owner__r.Name,
                        LLC_BI__Collateral__r.Primary_Owner__r.EB_Client_Name__c,
                        LLC_BI__Collateral__r.Primary_Owner__r.RecordType.Name,
                        LLC_BI__Collateral__r.Primary_Owner__r.BillingStreet,
                        LLC_BI__Collateral__r.Primary_Owner__r.BillingCity,
                        LLC_BI__Collateral__r.Primary_Owner__r.BillingPostalCode,
                        LLC_BI__Collateral__r.Primary_Owner__r.BillingState,
                    	LLC_BI__Collateral__r.LLC_BI__Parcel_Number__c
                    FROM 
                        LLC_BI__Loan_Collateral__r
                    ORDER BY
                        LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c
                ),
                (
                    SELECT
                        Id,
                        Name,
                        LLC_BI__Tax_ID__c,
                        LLC_BI__Relationship_Type__c,
                        LLC_BI__Borrower_Type__c,
                        Liabilities__c,
                    	Limitations__c,
                        LLC_BI__Address__c,
                    	LLC_BI__Contingent_Type__c,
                    	LLC_BI__Ownership__c,
                        LLC_BI__Account__r.Id,
                        LLC_BI__Account__r.Name,
                        LLC_BI__Account__r.Entity_Name__c,
                        LLC_BI__Account__r.EB_Client_Name__c,
                        LLC_BI__Account__r.RecordType.Name,
                        LLC_BI__Account__r.CreatedDate,
                        LLC_BI__Account__r.BillingStreet,
                        LLC_BI__Account__r.BillingCity,
                        LLC_BI__Account__r.BillingPostalCode,
                        LLC_BI__Account__r.BillingState,
                        LLC_BI__Account__r.Phone,
                        LLC_BI__Account__r.Sic,
                        LLC_BI__Account__r.Sub_Type__c,
                        LLC_BI__Account__r.TIN_SSN__c,
                        LLC_BI__Account__r.SSNTIN_Encrypted__c,
                        LLC_BI__Account__r.SSN_TIN_Has_Value__c,
                    	LLC_BI__Account__r.Birthdate__c,
                    	LLC_BI__Account__r.Reg_O_Code__c,
                        LLC_BI__Loan__r.Id,
                        LLC_BI__Loan__r.Name
                    FROM
                        LLC_BI__Legal_Entities__r
                    ORDER BY
                        LLC_BI__Account__r.Entity_Name__c
                ),
                (  
                    SELECT
                    	Id,
                        Name,
                        LLC_BI__Participated__c,
                        Bank__c,
                        Participation_Sold__c,
                        Amount__c,
                        LLC_BI__Loan__r.Id,
                        LLC_BI__Loan__r.Name
                    FROM
                    	LLC_BI__Participations__r
                ),
            	(  
                    SELECT
                        Id,
                        Primary__c,
                    	LLC_BI__User__r.Name,
                    	LLC_BI__Assigned_Role__r.Name
                    FROM
                    	LLC_BI__Loan_Teams__r 
                ),
                (
                    SELECT
                        Id,
                        Name,
                        LLC_BI__Memo_Type__c,
                        LLC_BI__Description__c,
                        Add_Collateral__c,
                        LLC_BI__Approval_Required__c,
                        Changing_Borrower_s_Name_Address_or_Tax__c,
                        LLC_BI__Collateral_Change__c,
                        Collateral_going_from_lesser_position_to__c,
                        Covenant_Changes__c,
                        LLC_BI__Equity_Injection_Change__c,
                        Fees_Change__c,
                        LLC_BI__Guarantor_Added__c,
                        LLC_BI__Guarantor_Removed__c,
                        LLC_BI__Life_Insurance_Change__c,
                        LLC_BI__Amount_Change__c,
                        LLC_BI__Loan_Term_Change__c,
                        Maturity_Date_Change__c,
                        LLC_BI__New_Rate_Requested__c,
                        LLC_BI__Notify_Attorney__c,
                        LLC_BI__Other__c,
                        Post_Approval_Requirements_changes__c,
                        LLC_BI__Post_Close_Items__c,
                        LLC_BI__Ready_for_Approval__c,
                        LLC_BI__Re_approval_After_Expiration__c,
                        LLC_BI__Seller_Note_Change__c,
                        Shortening_Maturity_Date_or_Amortization__c,
                        LLC_BI__Use_of_Proceeds_Change__c,
                        LLC_BI__User_Initiated__c,
                        LLC_BI__Loan__r.Id,
                        LLC_BI__Loan__r.Name,
                        Loan_Officer__r.Id,
                        Loan_Officer__r.Name
                    FROM
                        LLC_BI__Change_Memos__r
                )
            FROM 
                LLC_BI__Loan__c 
            WHERE 
                Id=:loanId
        ];

        PM_LLCBI_Loan_c pm = new PM_LLCBI_Loan_c();
        pm.Id = ln.Id; 
        pm.Name = ln.Name;
        pm.LLCBI_Product_Type_c = ln.LLC_BI__Product_Type__c;
        pm.LLCBI_Product_Line_c = ln.LLC_BI__Product_Line__c;
        pm.LLCBI_Product_c = ln.LLC_BI__Product__c;
        pm.LLCBI_Amount_Available_c = ln.LLC_BI__Amount_Available__c;
        pm.LLCBI_Amount_c = ln.LLC_BI__Amount__c;
        pm.Application_c = ln.Application__c;
        pm.Account_Number_c = ln.Account_Number__c;
        pm.LLCBI_lookupKey_c = ln.LLC_BI__lookupKey__c;
        pm.LLCBI_isRenewal_c = ln.LLC_BI__isRenewal__c;
        pm.LLCBI_Is_Modification_c = ln.LLC_BI__Is_Modification__c;
        pm.Channel_c = ln.Channel__c;
        pm.Reg_O_Loan_c = ln.Reg_O_Loan__c;
        pm.Employee_Loan_c = ln.Employee_Loan__c;
        pm.LLCBI_Risk_Grade_c = ln.LLC_BI__Risk_Grade__c;
        pm.Niche_Products_c = ln.Niche_Products__c;
        pm.Niche_Products_fx_c = ln.Niche_Products_fx__c;
        pm.Loan_Characteristics_c = ln.Loan_Characteristics__c;
        pm.Use_of_Funds_Purpose_c = ln.Use_of_Funds_Purpose__c;
        pm.Other_Purpose_Description_c = ln.Other_Purpose_Description__c;
        pm.LC_Comments_c = ln.LC_Comments__c;
        pm.RM_Comments_c = ln.RM_Comments__c;
        pm.Lending_Strategy_c = ln.Lending_Strategy__c;
        pm.LLCBI_InterestRate_c = ln.LLC_BI__InterestRate__c;
        pm.LLCBI_First_Payment_Date_c = ln.LLC_BI__First_Payment_Date__c;
        pm.LLCBI_Amortized_Term_Months_c = ln.LLC_BI__Amortized_Term_Months__c;
        pm.LLCBI_Term_Months_c = ln.LLC_BI__Term_Months__c;
        pm.LLCBI_Maturity_Date_c = ln.LLC_BI__Maturity_Date__c;
        pm.LLCBI_Pricing_Basis_c = ln.LLC_BI__Pricing_Basis__c;
        pm.LLCBI_Payment_Type_c = ln.LLC_BI__Payment_Type__c;
        pm.LLCBI_Payment_Schedule_c = ln.LLC_BI__Payment_Schedule__c;
        pm.LLCBI_Index_c = ln.LLC_BI__Index__c;
        pm.LLCBI_Spread_c = ln.LLC_BI__Spread__c;
        pm.LLCBI_Rate_Floor_c = ln.LLC_BI__Rate_Floor__c;
        pm.LLCBI_Rate_Ceiling_c = ln.LLC_BI__Rate_Ceiling__c;
        pm.LLCBI_Monthly_Payment_c = ln.LLC_BI__Monthly_Payment__c;
        pm.LLCBI_Interest_Rate_Adjustment_Frequency_c = ln.LLC_BI__Interest_Rate_Adjustment_Frequency__c;
        pm.Application_Number_c = ln.Application_Number__c;
        pm.Military_Lending_Act_c = ln.Military_Lending_Act__c;
        pm.Is_Loan_to_Gov_t_Related_Entity_c = ln.Is_Loan_to_Gov_t_Related_Entity__c;
        pm.Is_Repayment_Reliant_on_Ag_Income_c = ln.Is_Repayment_Reliant_on_Ag_Income__c;
        pm.Is_Loan_to_Financial_Institution_c = ln.Is_Loan_to_Financial_Institution__c;
        pm.Financial_Institution_Accept_Deposits_c = ln.Financial_Institution_Accept_Deposits__c;
        pm.Immediate_Funding_c = ln.Immediate_Funding__c;
        pm.Wire_Amount_c = ln.Wire_Amount__c;
        pm.Disbursing_Instructions_c = ln.Disbursing_Instructions__c;
        pm.COVID_19_Related_Loan_c = ln.COVID_19_Related_Loan__c;

        pm.EB_Industry_Code_r = new PM_EB_Industry_Code_c();
        pm.EB_Industry_Code_r.Name = ln.EB_Industry_Code__r.Name;

        pm.Originating_Officer_r = new PM_User();
        pm.Originating_Officer_r.Name = ln.Originating_Officer__r.Name;

        pm.LLCBI_Loan_Officer_r = new PM_User();
        pm.LLCBI_Loan_Officer_r.Name = ln.LLC_BI__Loan_Officer__r.Name;

        pm.CreatedBy = new PM_User();
        pm.CreatedBy.Name = ln.CreatedBy.Name;

        pm.Unit_r = new PM_EB_Unit_c();
        pm.Unit_r.Name = ln.Unit__r.Name;
        pm.Unit_r.Branch_Number_c = ln.Unit__r.Branch_Number__c;

        pm.LLCBI_Account_r = new PM_Account();
        pm.LLCBI_Account_r.Id = ln.LLC_BI__Account__c;
        pm.LLCBI_Account_r.Name = ln.LLC_BI__Account__r.Name;
        pm.LLCBI_Account_r.Type = ln.LLC_BI__Account__r.Type;
        pm.LLCBI_Account_r.BillingStreet = ln.LLC_BI__Account__r.BillingStreet;
        pm.LLCBI_Account_r.BillingCity = ln.LLC_BI__Account__r.BillingCity;
        pm.LLCBI_Account_r.BillingPostalCode = ln.LLC_BI__Account__r.BillingPostalCode;
        pm.LLCBI_Account_r.BillingState = ln.LLC_BI__Account__r.BillingState;

        pm.LLCBI_Account_r.RecordType = new PM_RecordType();
        pm.LLCBI_Account_r.RecordType.Name = ln.LLC_BI__Account__r.RecordType.Name;
            
        pm.LLCBI_Loan_Collateral_r = new List<PM_LLCBI_Loan_Collateral2_c>();
        for (LLC_BI__Loan_Collateral2__c pledge : ln.LLC_BI__Loan_Collateral__r) {
            PM_LLCBI_Loan_Collateral2_c pmPledge = new PM_LLCBI_Loan_Collateral2_c();
            pmPledge.Id = pledge.Id;
            pmPledge.Name = pledge.Name;
            pmPledge.Description_c = pledge.Description__c;
            pmPledge.LLCBI_Lien_Position_c = pledge.LLC_BI__Lien_Position__c;
            pmPledge.LLCBI_Collateral_Type_c = pledge.LLC_BI__Collateral_Type__c;
            pmPledge.LLCBI_Current_Lendable_Value_c = pledge.LLC_BI__Current_Lendable_Value__c;
            pmPledge.LLCBI_Is_Primary_c = pledge.LLC_BI__Is_Primary__c;
            pmPledge.Abundance_of_Caution_c = pledge.Abundance_of_Caution__c;

            pmPledge.LLCBI_Loan_r = new PM_LLCBI_Loan_c();
            pmPledge.LLCBI_Loan_r.Id = pledge.LLC_BI__Loan__c;
            pmPledge.LLCBI_Loan_r.Name = pledge.LLC_BI__Loan__r.Name;
            pmPledge.LLCBI_Loan_r.LLCBI_lookupKey_c = pledge.LLC_BI__Loan__r.LLC_BI__lookupKey__c;

            pmPledge.LLCBI_Collateral_r = new PM_LLCBI_Collateral_c();
            pmPledge.LLCBI_Collateral_r.Id = pledge.LLC_BI__Collateral__r.Id;
            pmPledge.LLCBI_Collateral_r.Name = pledge.LLC_BI__Collateral__r.Name;
            pmPledge.LLCBI_Collateral_r.LLCBI_Collateral_Name_c = pledge.LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c;
            pmPledge.LLCBI_Collateral_r.Change_Collateral_Code_c = pledge.LLC_BI__Collateral__r.Change_Collateral_Code__c;
            pmPledge.LLCBI_Collateral_r.Sync_Key_c = pledge.LLC_BI__Collateral__r.Sync_Key__c;
            pmPledge.LLCBI_Collateral_r.LLCBI_Description_c = pledge.LLC_BI__Collateral__r.LLC_BI__Description__c;
            pmPledge.LLCBI_Collateral_r.LLCBI_Lendable_Value_c = pledge.LLC_BI__Collateral__r.LLC_BI__Lendable_Value__c;
            pmPledge.LLCBI_Collateral_r.Assignment_of_Rent_c = pledge.LLC_BI__Collateral__r.Assignment_of_Rent__c;
            pmPledge.LLCBI_Collateral_r.Flood_Insurance_Required_c = pledge.LLC_BI__Collateral__r.Flood_Insurance_Required__c;
            pmPledge.LLCBI_Collateral_r.Appraised_Value_reviewed_c = pledge.LLC_BI__Collateral__r.Appraised_Value_reviewed__c;
            pmPledge.LLCBI_Collateral_r.Valuation_Date_c = pledge.LLC_BI__Collateral__r.Valuation_Date__c;
            pmPledge.LLCBI_Collateral_r.LLCBI_Street_Address_c = pledge.LLC_BI__Collateral__r.LLC_BI__Street_Address__c;
            pmPledge.LLCBI_Collateral_r.LLCBI_City_c = pledge.LLC_BI__Collateral__r.LLC_BI__City__c;
            pmPledge.LLCBI_Collateral_r.LLCBI_State_c = pledge.LLC_BI__Collateral__r.LLC_BI__State__c;
            pmPledge.LLCBI_Collateral_r.LLCBI_Zip_Code_c = pledge.LLC_BI__Collateral__r.LLC_BI__Zip_Code__c;
            pmPledge.LLCBI_Collateral_r.CreatedDate = pledge.LLC_BI__Collateral__r.CreatedDate;
            pmPledge.LLCBI_Collateral_r.LLC_BI_Parcel_Number_c = pledge.LLC_BI__Collateral__r.LLC_BI__Parcel_Number__c;

            pmPledge.LLCBI_Collateral_r.LLCBI_Collateral_Type_r = new PM_LLCBI_Collateral_Type_c();
            pmPledge.LLCBI_Collateral_r.LLCBI_Collateral_Type_r.Name = pledge.LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Name;
            pmPledge.LLCBI_Collateral_r.LLCBI_Collateral_Type_r.LLCBI_Collateral_Code_c = pledge.LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.LLC_BI__Collateral_Code__c;

            pmPledge.LLCBI_Collateral_r.Modified_Collateral_Type_r = new PM_LLCBI_Collateral_Type_c();
            pmPledge.LLCBI_Collateral_r.Modified_Collateral_Type_r.Name = pledge.LLC_BI__Collateral__r.Modified_Collateral_Type__r.Name;
            pmPledge.LLCBI_Collateral_r.Modified_Collateral_Type_r.LLCBI_Collateral_Code_c = pledge.LLC_BI__Collateral__r.Modified_Collateral_Type__r.LLC_BI__Collateral_Code__c;

            pmPledge.LLCBI_Collateral_r.Primary_Owner_r = new PM_Account();
            pmPledge.LLCBI_Collateral_r.Primary_Owner_r.Id = pledge.LLC_BI__Collateral__r.Primary_Owner__r.Id;
            pmPledge.LLCBI_Collateral_r.Primary_Owner_r.Name = pledge.LLC_BI__Collateral__r.Primary_Owner__r.Name;
            pmPledge.LLCBI_Collateral_r.Primary_Owner_r.EB_Client_Name_c = pledge.LLC_BI__Collateral__r.Primary_Owner__r.EB_Client_Name__c;
            pmPledge.LLCBI_Collateral_r.Primary_Owner_r.BillingStreet = pledge.LLC_BI__Collateral__r.Primary_Owner__r.BillingStreet;
            pmPledge.LLCBI_Collateral_r.Primary_Owner_r.BillingCity = pledge.LLC_BI__Collateral__r.Primary_Owner__r.BillingCity;
            pmPledge.LLCBI_Collateral_r.Primary_Owner_r.BillingState = pledge.LLC_BI__Collateral__r.Primary_Owner__r.BillingState;
            pmPledge.LLCBI_Collateral_r.Primary_Owner_r.BillingPostalCode = pledge.LLC_BI__Collateral__r.Primary_Owner__r.BillingPostalCode;

            pmPledge.LLCBI_Collateral_r.Primary_Owner_r.RecordType = new PM_RecordType();
            pmPledge.LLCBI_Collateral_r.Primary_Owner_r.RecordType.Name = pledge.LLC_BI__Collateral__r.Primary_Owner__r.RecordType.Name;
            pm.LLCBI_Loan_Collateral_r.add(pmPledge);
        }
        
        pm.LLCBI_Legal_Entities_r = new List<PM_LLCBI_Legal_Entities_c>();
        for (LLC_BI__Legal_Entities__c le : ln.LLC_BI__Legal_Entities__r) {
            PM_LLCBI_Legal_Entities_c pmLe = new PM_LLCBI_Legal_Entities_c();
            pmLe.Id = le.Id;
            pmLe.Name = le.Name;
            pmLe.LLCBI_Tax_ID_c = le.LLC_BI__Tax_ID__c;
            pmLe.LLCBI_Relationship_Type_c = le.LLC_BI__Relationship_Type__c;
            pmLe.LLCBI_Borrower_Type_c = le.LLC_BI__Borrower_Type__c;
            pmLe.Liabilities_c = le.Liabilities__c;
            pmLe.LLCBI_Address_c = le.LLC_BI__Address__c;
            pmLe.LLCBI_Contingent_Type_c = le.LLC_BI__Contingent_Type__c;
            pmLe.LLCBI_Ownership_c = le.LLC_BI__Ownership__c;
            pmLe.Limitations_c = le.Limitations__c;

            pmLe.LLCBI_Account_r = new PM_Account();
            pmLe.LLCBI_Account_r.Id = le.LLC_BI__Account__r.Id;
            pmLe.LLCBI_Account_r.Name = le.LLC_BI__Account__r.Name;
            pmLe.LLCBI_Account_r.Entity_Name_c = le.LLC_BI__Account__r.Entity_Name__c;
            pmLe.LLCBI_Account_r.EB_Client_Name_c = le.LLC_BI__Account__r.EB_Client_Name__c;
            pmLe.LLCBI_Account_r.CreatedDate = le.LLC_BI__Account__r.CreatedDate;
            pmLe.LLCBI_Account_r.BillingStreet = le.LLC_BI__Account__r.BillingStreet;
            pmLe.LLCBI_Account_r.BillingCity = le.LLC_BI__Account__r.BillingCity;
            pmLe.LLCBI_Account_r.BillingState = le.LLC_BI__Account__r.BillingState;
            pmLe.LLCBI_Account_r.BillingPostalCode = le.LLC_BI__Account__r.BillingPostalCode;
            pmLe.LLCBI_Account_r.Phone = le.LLC_BI__Account__r.Phone;
            pmLe.LLCBI_Account_r.Sic = le.LLC_BI__Account__r.Sic;
            pmLe.LLCBI_Account_r.Sub_Type_c = le.LLC_BI__Account__r.Sub_Type__c;
            pmLe.LLCBI_Account_r.TIN_SSN_c = le.LLC_BI__Account__r.TIN_SSN__c;
            pmLe.LLCBI_Account_r.SSNTIN_Encrypted_c = le.LLC_BI__Account__r.SSNTIN_Encrypted__c;
            pmLe.LLCBI_Account_r.SSN_TIN_Has_Value_c = le.LLC_BI__Account__r.SSN_TIN_Has_Value__c;
            pmLe.LLCBI_Account_r.Birthdate_c = le.LLC_BI__Account__r.Birthdate__c;
            pmLe.LLCBI_Account_r.Reg_O_Code_c = le.LLC_BI__Account__r.Reg_O_Code__c;
            
            pmLe.LLCBI_Account_r.RecordType = new PM_RecordType();
            pmLe.LLCBI_Account_r.RecordType.Name = le.LLC_BI__Account__r.RecordType.Name;
            
            pmLe.LLCBI_Loan_r = new PM_LLCBI_Loan_c();
            pmLe.LLCBI_Loan_r.Id = le.LLC_BI__Loan__r.Id;
            pmLe.LLCBI_Loan_r.Name = le.LLC_BI__Loan__r.Name;

            pm.LLCBI_Legal_Entities_r.add(pmLe);
        }
        
        pm.LLCBI_Participations_r = new List<PM_LLCBI_Participation_c>();
        for (LLC_BI__Participation__c p : ln.LLC_BI__Participations__r) {
            PM_LLCBI_Participation_c pmp = new PM_LLCBI_Participation_c();
            pmp.Id = p.Id;
            pmp.Name = p.Name;
            pmp.LLCBI_Participated_c = p.LLC_BI__Participated__c;
            pmp.Bank_c = p.Bank__c;
            pmp.Participation_Sold_c = p.Participation_Sold__c;
            pmp.Amount_c = p.Amount__c;

            pmp.LLCBI_Loan_r = new PM_LLCBI_Loan_c();
            pmp.LLCBI_Loan_r.Id = p.LLC_BI__Loan__r.Id;
            pmp.LLCBI_Loan_r.Name = p.LLC_BI__Loan__r.Name;
            pm.LLCBI_Participations_r.add(pmp);
        }
       
        pm.LLCBI_Loan_Teams_r = new List<PM_LLCBI_LoanTeam_c>();
        for (LLC_BI__LoanTeam__c lt : ln.LLC_BI__Loan_Teams__r) {
            PM_LLCBI_LoanTeam_c pmLt = new PM_LLCBI_LoanTeam_c();
            pmLt.Id = lt.Id;
            pmLt.Primary_c = lt.Primary__c;

            pmLt.LLCBI_User_r = new PM_User();
            pmLt.LLCBI_User_r.Name = lt.LLC_BI__User__r.Name;

            pmLt.LLCBI_Assigned_Role_r = new PM_LLCBI_Role_c();
            pmlt.LLCBI_Assigned_Role_r.Name = lt.LLC_BI__Assigned_Role__r.Name;

            pm.LLCBI_Loan_Teams_r.add(pmLt);
        }
        
        pm.LLCBI_Change_Memos_r = new List<PM_LLCBI_Change_Memo_c>();
        for (LLC_BI__Credit_Memo_Modifcation__c memo : ln.LLC_BI__Change_Memos__r) {
            PM_LLCBI_Change_Memo_c pmMemo = new PM_LLCBI_Change_Memo_c();
            pmMemo.Id = memo.Id;
            pmMemo.Name = memo.Name;
            pmMemo.LLCBI_Memo_Type_c = memo.LLC_BI__Memo_Type__c;
            pmMemo.LLCBI_Description_c = memo.LLC_BI__Description__c;
            pmMemo.Add_Collateral_c = memo.Add_Collateral__c;
            pmMemo.LLCBI_Approval_Required_c = memo.LLC_BI__Approval_Required__c;
            pmMemo.Changing_Borrower_s_Name_Address_or_Tax_c = memo.Changing_Borrower_s_Name_Address_or_Tax__c;
            pmMemo.LLCBI_Collateral_Change_c = memo.LLC_BI__Collateral_Change__c;
            pmMemo.Collateral_going_from_lesser_position_to_c = memo.Collateral_going_from_lesser_position_to__c;
            pmMemo.Covenant_Changes_c = memo.Covenant_Changes__c;
            pmMemo.LLCBI_Equity_Injection_Change_c = memo.LLC_BI__Equity_Injection_Change__c;
            pmMemo.Fees_Change_c = memo.Fees_Change__c;
            pmMemo.LLCBI_Guarantor_Added_c = memo.LLC_BI__Guarantor_Added__c;
            pmMemo.LLCBI_Guarantor_Removed_c = memo.LLC_BI__Guarantor_Removed__c;
            pmMemo.LLCBI_Life_Insurance_Change_c = memo.LLC_BI__Life_Insurance_Change__c;
            pmMemo.LLCBI_Amount_Change_c = memo.LLC_BI__Amount_Change__c;
            pmMemo.LLCBI_Loan_Term_Change_c = memo.LLC_BI__Loan_Term_Change__c;
            pmMemo.Maturity_Date_Change_c = memo.Maturity_Date_Change__c;
            pmMemo.LLCBI_New_Rate_Requested_c = memo.LLC_BI__New_Rate_Requested__c;
            pmMemo.LLCBI_Notify_Attorney_c = memo.LLC_BI__Notify_Attorney__c;
            pmMemo.LLCBI_Other_c = memo.LLC_BI__Other__c;
            pmMemo.Post_Approval_Requirements_changes_c = memo.Post_Approval_Requirements_changes__c;
            pmMemo.LLCBI_Post_Close_Items_c = memo.LLC_BI__Post_Close_Items__c;
            pmMemo.LLCBI_Ready_for_Approval_c = memo.LLC_BI__Ready_for_Approval__c;
            pmMemo.LLCBI_Re_approval_After_Expiration_c = memo.LLC_BI__Re_approval_After_Expiration__c;
            pmMemo.LLCBI_Seller_Note_Change_c = memo.LLC_BI__Seller_Note_Change__c;
            pmMemo.Shortening_Maturity_Date_or_Amortization_c = memo.Shortening_Maturity_Date_or_Amortization__c;
            pmMemo.LLCBI_Use_of_Proceeds_Change_c = memo.LLC_BI__Use_of_Proceeds_Change__c;
            pmMemo.LLCBI_User_Initiated_c = memo.LLC_BI__User_Initiated__c;

            pmMemo.LLCBI_Loan_r = new PM_LLCBI_Loan_c();
            pmMemo.LLCBI_Loan_r.Id = memo.LLC_BI__Loan__r.Id;
            pmMemo.LLCBI_Loan_r.Name = memo.LLC_BI__Loan__r.Name;

            pmMemo.Loan_Officer_r = new PM_User();
            pmMemo.Loan_Officer_r.Id = memo.Loan_Officer__r.Id;
            pmMemo.Loan_Officer_r.Name = memo.Loan_Officer__r.Name;

            pm.LLCBI_Change_Memos_r.add(pmMemo);
        }
        return pm;  
    }

    public PM_EB_Loan_Application_c getLoanForceLoan(Id loanId) {
        EB_Loan_Application__c ebLoanApp = [
            SELECT 
                Id,
                Name,
                Account_Number_Assigned__c,
                Total_Loan_Amount__c,
                Use_of_Funds__c,
                Maturity_Term_In_Months__c,
                Loan_Type__c,
                Credit_Rating__c,
                Niche_Products__c,
                Purpose_Of_Loan__c,
                Maturity_Date__c,
                Application_Stage__c,
                RM__c,
                Account_Number__c,
                Account_Number__r.Name,
                RecordType.Name,
                EB_Account_Industry_Code__r.Name,
                Eb_Loan_Packet__r.Channel__c,
                Eb_Loan_Packet__r.RM_Commentary__c,
                Eb_Loan_Packet__r.Lead_Entity__r.EB_UnitID__r.Name,
                (
                    SELECT
                        Id,
                        Name,
                        Lendable_Equity__c,
                        Loan_Value__c,
                        Description__c,
                        Purpose_Of_Collateral__c,
                        Abundance_Of_Caution__c,
                        Collateral_Code__c,
                        EB_Loan_Application_ID__c,
                        EB_Loan_Application_ID__r.Name,
                        EB_Collateral_ID__c,
                        EB_Collateral_ID__r.Name,
                        EB_Collateral_ID__r.Street__c,
                        EB_Collateral_ID__r.City__c,
                        EB_Collateral_ID__r.State__c,
                        EB_Collateral_ID__r.Zip_Code__c,
                        EB_Collateral_ID__r.Lien_Position__c,
                        EB_Collateral_ID__r.Collateral_Owner__c,
                        EB_Collateral_ID__r.Collateral_Owner__r.Name,
                        EB_Collateral_ID__r.Collateral_Owner__r.EB_Client_Name__c,
                        EB_Collateral_ID__r.Collateral_Owner__r.BillingStreet,
                        EB_Collateral_ID__r.Collateral_Owner__r.BillingCity,
                        EB_Collateral_ID__r.Collateral_Owner__r.BillingState,
                        EB_Collateral_ID__r.Collateral_Owner__r.BillingPostalCode
                    FROM
                        EB_Loan_App_Collateral_Relationships__r
                ),
                (
                    SELECT
                        Id,
                        Name,
                        Participating_Institution__c,
                        Participated_Amount__c,
                        Loan_Application_ID__c,
                        Loan_Application_ID__r.Name,
                        RecordType.Name
                    FROM
                        EB_Loan_Participations__r
                ),
                (
                    SELECT
                        Id,
                        Name,
                        Relationship_Type__c,
                        Loan_Application_ID__c,
                        Loan_Application_ID__r.Name,
                        Entity_Name__c,
                        Entity_Name__r.Name,
                        Entity_Name__r.Sub_Type__c,
                        Entity_Name__r.TIN_SSN__c,
                        Entity_Name__r.SSN_TIN_Has_Value__c,
                        Entity_Name__r.SSNTIN_Encrypted__c,
                        Entity_Name__r.BillingStreet,
                        Entity_Name__r.BillingCity,
                        Entity_Name__r.BillingState,
                        Entity_Name__r.BillingPostalCode,
                        Entity_Name__r.Phone,
                        Entity_Name__r.Sic
                    FROM
                        EB_Loan_App_Entity_Relationships__r
                ),
                (
                    SELECT
                        Id,
                        Name,
                        Fixed_Interest_Rate__c,
                        Index_Variance_Code__c,
                        Interest_Rate_Ceiling__c,
                        Interest_Rate_Floor__c,
                        Rate_Subject_To_Change__c,
                        Rate_Index_Variance__c,
                        EB_Floating_Rate__r.Name
                    FROM
                        EB_Loan_App_Rate_Streams__r
                    WHERE
                        Stream_Number__c = '1'
                    LIMIT 1
                ),
                (
                    SELECT
                        Id,
                        Name,
                        Amortization_Schedule_in_Months__c,
                        Amount__c,
                        Frequency__c,
                        RecordType.Name
                    FROM
                        EB_Loan_Application_Payment_Streams__r
                    WHERE
                        Stream_Number__c = '1'
                    LIMIT 1
                )
            FROM
                EB_Loan_Application__c
            WHERE
                Id =:loanId
        ];

        PM_EB_Loan_Application_c pm = new PM_EB_Loan_Application_c();
        pm.Id = ebLoanApp.Id;
        pm.Name = ebLoanApp.Name;
        pm.Account_Number_Assigned_c = ebLoanApp.Account_Number_Assigned__c;
        pm.Total_Loan_Amount_c = ebLoanApp.Total_Loan_Amount__c;
        pm.Use_of_Funds_c = ebLoanApp.Use_of_Funds__c;
        pm.Maturity_Term_In_Months_c = ebLoanApp.Maturity_Term_In_Months__c;
        pm.Loan_Type_c = ebLoanApp.Loan_Type__c;
        pm.Credit_Rating_c = ebLoanApp.Credit_Rating__c;
        pm.Niche_Products_c = ebLoanApp.Niche_Products__c;
        pm.Purpose_Of_Loan_c = ebLoanApp.Purpose_Of_Loan__c;
        pm.Maturity_Date_c = ebLoanApp.Maturity_Date__c;
        pm.RM_c = ebLoanApp.RM__c;

        pm.Application_Stage_r = new PM_EB_Loan_App_Stage_c();
        pm.Application_Stage_r.Id = ebLoanApp.Application_Stage__c;

        pm.Account_Number_r = new PM_EB_Account_c();
        pm.Account_Number_r.Id = ebLoanApp.Account_Number__c;
        pm.Account_Number_r.Name = ebLoanApp.Account_Number__r.Name;

        pm.RecordType = new PM_RecordType();
        pm.RecordType.Name = ebLoanApp.RecordType.Name;

        pm.EB_Account_Industry_Code_r = new PM_EB_Industry_Code_c();
        pm.EB_Account_Industry_Code_r.Name = ebLoanApp.EB_Account_Industry_Code__r.Name;

        pm.EB_Loan_Packet_r = new PM_EB_Loan_Packet_c();
        pm.EB_Loan_Packet_r.Channel_c = ebLoanApp.Eb_Loan_Packet__r.Channel__c;
        pm.EB_Loan_Packet_r.RM_Commentary_c = ebLoanApp.Eb_Loan_Packet__r.RM_Commentary__c;

        pm.EB_Loan_Packet_r.Lead_Entity_r = new PM_Account();
        pm.EB_Loan_Packet_r.Lead_Entity_r.EB_UnitID_r = new PM_EB_Unit_c();
        pm.EB_Loan_Packet_r.Lead_Entity_r.EB_UnitID_r.Name = ebLoanApp.Eb_Loan_Packet__r.Lead_Entity__r.EB_UnitID__r.Name;
        
        pm.EB_Loan_App_Collateral_Relationships_r = new List<PM_EB_Loan_App_Collateral_Relationship_c>();
        for (EB_Loan_App_Collateral_Relationship__c rel : ebLoanApp.EB_Loan_App_Collateral_Relationships__r) {
            PM_EB_Loan_App_Collateral_Relationship_c pmColRel = new PM_EB_Loan_App_Collateral_Relationship_c();
            pmColRel.Id = rel.Id;
            pmColRel.Name = rel.Name;
            pmColRel.Lendable_Equity_c = rel.Lendable_Equity__c;
            pmColRel.Loan_Value_c = rel.Loan_Value__c;
            pmColRel.Description_c = rel.Description__c;
            pmColRel.Purpose_Of_Collateral_c = rel.Purpose_Of_Collateral__c;
            pmColRel.Abundance_Of_Caution_c = rel.Abundance_Of_Caution__c;
            pmColRel.Collateral_Code_c = rel.Collateral_Code__c;

            pmColRel.EB_Loan_Application_ID_r = new PM_EB_Loan_Application_c();
            pmColRel.EB_Loan_Application_ID_r.Id = rel.EB_Loan_Application_ID__c;
            pmColRel.EB_Loan_Application_ID_r.Name = rel.EB_Loan_Application_ID__r.Name;

            pmColRel.EB_Collateral_ID_r = new PM_EB_Collateral_c();
            pmColRel.EB_Collateral_ID_r.Id = rel.EB_Collateral_ID__c;
            pmColRel.EB_Collateral_ID_r.Name = rel.EB_Collateral_ID__r.Name;
            pmColRel.EB_Collateral_ID_r.Street_c = rel.EB_Collateral_ID__r.Street__c;
            pmColRel.EB_Collateral_ID_r.City_c = rel.EB_Collateral_ID__r.City__c;
            pmColRel.EB_Collateral_ID_r.State_c = rel.EB_Collateral_ID__r.State__c;
            pmColRel.EB_Collateral_ID_r.Zip_Code_c = rel.EB_Collateral_ID__r.Zip_Code__c;
            pmColRel.EB_Collateral_ID_r.Lien_Position_c = rel.EB_Collateral_ID__r.Lien_Position__c;

            pmColRel.EB_Collateral_ID_r.Collateral_Owner_r = new PM_Account();
            pmColRel.EB_Collateral_ID_r.Collateral_Owner_r.Id = rel.EB_Collateral_ID__r.Collateral_Owner__c;
            pmColRel.EB_Collateral_ID_r.Collateral_Owner_r.Name = rel.EB_Collateral_ID__r.Collateral_Owner__r.Name;
            pmColRel.EB_Collateral_ID_r.Collateral_Owner_r.EB_Client_Name_c = rel.EB_Collateral_ID__r.Collateral_Owner__r.EB_Client_Name__c;
            pmColRel.EB_Collateral_ID_r.Collateral_Owner_r.BillingStreet = rel.EB_Collateral_ID__r.Collateral_Owner__r.BillingStreet;
            pmColRel.EB_Collateral_ID_r.Collateral_Owner_r.BillingCity = rel.EB_Collateral_ID__r.Collateral_Owner__r.BillingCity;
            pmColRel.EB_Collateral_ID_r.Collateral_Owner_r.BillingState = rel.EB_Collateral_ID__r.Collateral_Owner__r.BillingState;
            pmColRel.EB_Collateral_ID_r.Collateral_Owner_r.BillingPostalCode = rel.EB_Collateral_ID__r.Collateral_Owner__r.BillingPostalCode;
            pm.EB_Loan_App_Collateral_Relationships_r.add(pmColRel);
        }

        pm.EB_Loan_Participations_r = new List<PM_EB_Loan_Participation_c>();
        for (EB_Loan_Participation__c p : ebLoanApp.EB_Loan_Participations__r) {
            PM_EB_Loan_Participation_c pmPart = new PM_EB_Loan_Participation_c();
            pmPart.Id = p.Id;
            pmPart.Name = p.Name;
            pmPart.Participating_Institution_c = p.Participating_Institution__c;
            pmPart.Participated_Amount_c = p.Participated_Amount__c;

            pmPart.Loan_Application_ID_r = new PM_EB_Loan_Application_c();
            pmPart.Loan_Application_ID_r.Id = p.Loan_Application_ID__c;
            pmPart.Loan_Application_ID_r.Name = p.Loan_Application_ID__r.Name;

            pmPart.RecordType = new PM_RecordType();
            pmPart.RecordType.Name = p.RecordType.Name;
            pm.EB_Loan_Participations_r.add(pmPart);
        }

        pm.EB_Loan_App_Entity_Relationships_r = new List<PM_EB_Loan_App_Entity_Relationship_c>();
        for (EB_Loan_App_Entity_Relationship__c r : ebLoanApp.EB_Loan_App_Entity_Relationships__r) {
            PM_EB_Loan_App_Entity_Relationship_c pmEntRel = new PM_EB_Loan_App_Entity_Relationship_c();
            pmEntRel.Id = r.Id;
            pmEntRel.Name = r.Name;
            pmEntRel.Relationship_Type_c = r.Relationship_Type__c;

            pmEntRel.Loan_Application_ID_r = new PM_EB_Loan_Application_c();
            pmEntRel.Loan_Application_ID_r.Id = r.Loan_Application_ID__c;
            pmEntRel.Loan_Application_ID_r.Name = r.Loan_Application_ID__r.Name;

            pmEntRel.Entity_Name_r = new PM_Account();
            pmEntRel.Entity_Name_r.Id = r.Entity_Name__c;
            pmEntRel.Entity_Name_r.Name = r.Entity_Name__r.Name;
            pmEntRel.Entity_Name_r.Sub_Type_c = r.Entity_Name__r.Sub_Type__c;
            pmEntRel.Entity_Name_r.TIN_SSN_c = r.Entity_Name__r.TIN_SSN__c;
            pmEntRel.Entity_Name_r.SSN_TIN_Has_Value_c = r.Entity_Name__r.SSN_TIN_Has_Value__c;
            pmEntRel.Entity_Name_r.SSNTIN_Encrypted_c = r.Entity_Name__r.SSNTIN_Encrypted__c;
            pmEntRel.Entity_Name_r.BillingStreet = r.Entity_Name__r.BillingStreet;
            pmEntRel.Entity_Name_r.BillingCity = r.Entity_Name__r.BillingCity;
            pmEntRel.Entity_Name_r.BillingState = r.Entity_Name__r.BillingState;
            pmEntRel.Entity_Name_r.BillingPostalCode = r.Entity_Name__r.BillingPostalCode;
            pmEntRel.Entity_Name_r.Phone = r.Entity_Name__r.Phone;
            pmEntRel.Entity_Name_r.Sic = r.Entity_Name__r.Sic;
            pm.EB_Loan_App_Entity_Relationships_r.add(pmEntRel);
        }

        pm.EB_Loan_App_Rate_Streams_r = new List<PM_EB_Loan_App_Rate_Stream_c>();
        for (EB_Loan_App_Rate_Stream__c rStream : ebLoanApp.EB_Loan_App_Rate_Streams__r) {
            PM_EB_Loan_App_Rate_Stream_c pmRStream = new PM_EB_Loan_App_Rate_Stream_c();
            pmRStream.Id = rStream.Id;
            pmRStream.Name = rStream.Name;
            pmRStream.Fixed_Interest_Rate_c = rStream.Fixed_Interest_Rate__c;
            pmRStream.Index_Variance_Code_c = rStream.Index_Variance_Code__c;
            pmRStream.Interest_Rate_Ceiling_c = rStream.Interest_Rate_Ceiling__c;
            pmRStream.Interest_Rate_Floor_c = rStream.Interest_Rate_Floor__c;
            pmRStream.Rate_Subject_To_Change_c = rStream.Rate_Subject_To_Change__c;
            pmRStream.Rate_Index_Variance_c = rStream.Rate_Index_Variance__c;

            pmRStream.EB_Floating_Rate_r = new PM_EB_Floating_Rate_c();
            pmRStream.EB_Floating_Rate_r.Name = rStream.EB_Floating_Rate__r.Name;
            pm.EB_Loan_App_Rate_Streams_r.add(pmRStream);
        }

        pm.EB_Loan_Application_Payment_Streams_r = new List<PM_EB_Loan_Application_Payment_Stream_c>();
        for (EB_Loan_Application_Payment_Stream__c pStream : ebLoanApp.EB_Loan_Application_Payment_Streams__r) {
            PM_EB_Loan_Application_Payment_Stream_c pmPStream = new PM_EB_Loan_Application_Payment_Stream_c();
            pmPStream.Id = pStream.Id;
            pmPStream.Name = pStream.Name;
            pmPStream.Amortization_Schedule_in_Months_c = pStream.Amortization_Schedule_in_Months__c;
            pmPStream.Amount_c = pStream.Amount__c;
            pmPStream.Frequency_c = pStream.Frequency__c;

            pmPStream.RecordType = new PM_RecordType();
            pmPStream.RecordType.Name = pStream.RecordType.Name;
            pm.EB_Loan_Application_Payment_Streams_r.add(pmPStream);
        }
        return pm;
    }

    public List<PM_EB_Collateral_Client_Relationship_c> getLoanForceCollateralEntityRelationships(List<Id> collateralIds) {
        List<EB_Collateral_Client_Relationship__c> ebColRels = [
            SELECT
                Id,
                Name,
                Description__c,
                Key__c,
                Client_ID__c,
                Client_ID__r.Name,
                Client_ID__r.EB_Client_Name__c,
                Client_ID__r.BillingStreet,
                Client_ID__r.BillingCity,
                Client_ID__r.BillingState,
                Client_ID__r.BillingPostalCode,
                EB_Collateral_ID__c,
                EB_Collateral_ID__r.Name
            FROM
                EB_Collateral_Client_Relationship__c
            WHERE
                EB_Collateral_ID__c IN: collateralIds
        ];
        
        List<PM_EB_Collateral_Client_Relationship_c> pmColRels = new List<PM_EB_Collateral_Client_Relationship_c>();
        for (EB_Collateral_Client_Relationship__c cr : ebColRels) {
            PM_EB_Collateral_Client_Relationship_c pm = new PM_EB_Collateral_Client_Relationship_c();
            pm.Id = cr.Id;
            pm.Name = cr.Name;
            pm.Description_c = cr.Description__c;
            pm.Key_c = cr.Key__c;

            pm.Client_ID_r = new PM_Account();
            pm.Client_ID_r.Id = cr.Client_ID__c;
            pm.Client_ID_r.Name = cr.Client_ID__r.Name;
            pm.Client_ID_r.EB_Client_Name_c = cr.Client_ID__r.EB_Client_Name__c;
            pm.Client_ID_r.BillingStreet = cr.Client_ID__r.BillingStreet;
            pm.Client_ID_r.BillingCity = cr.Client_ID__r.BillingCity;
            pm.Client_ID_r.BillingState = cr.Client_ID__r.BillingState;
            pm.Client_ID_r.BillingPostalCode = cr.Client_ID__r.BillingPostalCode;

            pm.EB_Collateral_ID_r = new PM_EB_Collateral_c();
            pm.EB_Collateral_ID_r.Id = cr.EB_Collateral_ID__c;
            pm.EB_Collateral_ID_r.Name = cr.EB_Collateral_ID__r.Name;
            pmColRels.add(pm);
        }
        return pmColRels;
    }

    public List<EB_Industry_Code__c> getIndustryCodes() {
        return [
            SELECT
                Id,
                Name,
                Industry_Code__c
            FROM
                EB_Industry_Code__c
        ];
    }

    public List<PM_LLCBI_Pricing_Payment_Component_c> getnCinoPayStreams(String loanId) {
        List<LLC_BI__Pricing_Payment_Component__c> sobjs = new List<LLC_BI__Pricing_Payment_Component__c>();
        
        sobjs = [
            SELECT
                Id
                ,Name
                ,LLC_BI__Amount__c
                ,LLC_BI__Type__c
                ,LLC_BI__Pricing_Stream__r.Id
                ,LLC_BI__Pricing_Stream__r.Name
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Effective_Date__c
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Sequence__c
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Term_Length__c
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Term_Unit__c
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Is_Payment_Stream__c
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Is_Rate_Stream__c
            FROM 
                LLC_BI__Pricing_Payment_Component__c
            WHERE
                LLC_BI__Pricing_Stream__r.LLC_BI__Context_Id__c =: loanId
        ];

        List<PM_LLCBI_Pricing_Payment_Component_c> pms = new List<PM_LLCBI_Pricing_Payment_Component_c>();
        for (LLC_BI__Pricing_Payment_Component__c s : sobjs) {
            PM_LLCBI_Pricing_Payment_Component_c pm = new PM_LLCBI_Pricing_Payment_Component_c();
            pm.Id = s.Id;
            pm.Name = s.Name;
            pm.LLCBI_Amount_c = s.LLC_BI__Amount__c;
            pm.LLCBI_Type_c = s.LLC_BI__Type__c;
            pm.LLCBI_Pricing_Stream_r = new PM_LLCBI_Pricing_Stream_c();
            pm.LLCBI_Pricing_Stream_r.Id = s.LLC_BI__Pricing_Stream__r.Id;
            pm.LLCBI_Pricing_Stream_r.Name = s.LLC_BI__Pricing_Stream__r.Name;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Effective_Date_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Effective_Date__c;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Sequence_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Sequence__c;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Term_Length_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Term_Length__c;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Term_Unit_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Term_Unit__c;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Is_Payment_Stream_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Is_Payment_Stream__c;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Is_Rate_Stream_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Is_Rate_Stream__c;
            pms.add(pm);
        }
        return pms;
    }

    public List<PM_LLCBI_Pricing_Rate_Component_c> getnCinoRateStreams(String loanId) {
        List<LLC_BI__Pricing_Rate_Component__c> sobjs = new List<LLC_BI__Pricing_Rate_Component__c>();
        sobjs = [
            SELECT
                Id
                ,Name
                ,LLC_BI__Applied_Loan_Percentage__c
                ,LLC_BI__Is_Fixed__c
                ,LLC_BI__Rate__c
                ,LLC_BI__Pricing_Stream__r.Id
                ,LLC_BI__Pricing_Stream__r.Name
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Effective_Date__c
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Sequence__c
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Term_Length__c
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Term_Unit__c
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Is_Payment_Stream__c
                ,LLC_BI__Pricing_Stream__r.LLC_BI__Is_Rate_Stream__c
                ,(  SELECT
                        Id
                        ,Name
                        ,LLC_BI__Rules__c
                        ,LLC_BI__Pricing_Rate_Component__c
                    FROM
                        LLC_BI__Pricing_Covenants__r                    
                )
            FROM 
                LLC_BI__Pricing_Rate_Component__c
            WHERE
                LLC_BI__Pricing_Stream__r.LLC_BI__Context_Id__c =: loanId
        ];

        List<PM_LLCBI_Pricing_Rate_Component_c> pms = new List<PM_LLCBI_Pricing_Rate_Component_c>();
        for (LLC_BI__Pricing_Rate_Component__c s : sobjs) {
            PM_LLCBI_Pricing_Rate_Component_c pm = new PM_LLCBI_Pricing_Rate_Component_c();
            pm.Id = s.Id;
            pm.Name = s.Name;
            pm.LLCBI_Applied_Loan_Percentage_c = s.LLC_BI__Applied_Loan_Percentage__c;
            pm.LLCBI_Is_Fixed_c = s.LLC_BI__Is_Fixed__c;
            pm.LLCBI_Rate_c = s.LLC_BI__Rate__c;
            pm.LLCBI_Pricing_Stream_r = new PM_LLCBI_Pricing_Stream_c();
            pm.LLCBI_Pricing_Stream_r.Id = s.LLC_BI__Pricing_Stream__r.Id;
            pm.LLCBI_Pricing_Stream_r.Name = s.LLC_BI__Pricing_Stream__r.Name;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Effective_Date_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Effective_Date__c;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Sequence_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Sequence__c;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Term_Length_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Term_Length__c;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Term_Unit_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Term_Unit__c;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Is_Payment_Stream_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Is_Payment_Stream__c;
            pm.LLCBI_Pricing_Stream_r.LLCBI_Is_Rate_Stream_c = s.LLC_BI__Pricing_Stream__r.LLC_BI__Is_Rate_Stream__c;
            pm.LLCBI_Pricing_Covenants_r = new List<PM_LLCBI_Pricing_Covenant_c>();

            for (LLC_BI__Pricing_Covenant__c c : s.LLC_BI__Pricing_Covenants__r) {
                PM_LLCBI_Pricing_Covenant_c pmCov = new PM_LLCBI_Pricing_Covenant_c();
                pmCov.Id = c.Id;
                pmCov.Name = c.Name;
                pmCov.LLCBI_Rules_c = c.LLC_BI__Rules__c;
                pm.LLCBI_Pricing_Covenants_r.add(pmCov);
            }
            pms.add(pm);
        }
        return pms;
    }
}