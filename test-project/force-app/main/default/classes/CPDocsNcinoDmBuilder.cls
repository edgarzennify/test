public class CPDocsNcinoDmBuilder implements CPDocs.INcinoDmBuilder{
    public List<DmLoanEntityRelationship> buildLegalEntities(List<PM_LLCBI_Legal_Entities_c> pms){
        List<DmLoanEntityRelationship> dms = new List<DmLoanEntityRelationship>();
        for(PM_LLCBI_Legal_Entities_c pm :pms){
            DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
            dm.Id = pm.Id;
            dm.Name = pm.Name;
            dm.Liabilities = pm.Liabilities_c;
            dm.RelationshipType = pm.LLCBI_Borrower_Type_c;
            dm.ContingentType = pm.LLCBI_Contingent_Type_c;
            dm.ContingentPercentage = pm.LLCBI_Ownership_c;
            dm.Limitations = pm.Limitations_c;
            
            DmLoan loanDm = new DmLoan();
            loanDm.Id = pm.LLCBI_Loan_r.Id;
            loanDm.Name = pm.LLCBI_Loan_r.Name;
            dm.Loan = loanDm;
            
            DmEntity entityDm = new DmEntity();
            entityDm.Id = pm.LLCBI_Account_r.Id;
            entityDm.Name = pm.LLCBI_Account_r.Name;
            entityDm.BillingStreet = pm.LLCBI_Account_r.BillingStreet;
            entityDm.BillingCity = pm.LLCBI_Account_r.BillingCity;
            entityDm.BillingState = pm.LLCBI_Account_r.BillingState;
            entityDm.BillingPostalCode = pm.LLCBI_Account_r.BillingPostalCode;
            entityDm.Phone = pm.LLCBI_Account_r.Phone;
            entityDm.BirthDate = pm.LLCBI_Account_r.Birthdate_c;
            entityDm.RegOCode = pm.LLCBI_Account_r.Reg_O_Code_c;
            dm.entity = entityDm;
    
            dms.add(dm);
        }
        return dms;
    }
    
    public List<DmLoan> buildLoans(List<PM_LLCBI_Loan_c> loans){
        List<DmLoan> dms = new List<DmLoan>();
        
        for(PM_LLCBI_Loan_c pm: loans){
            DmLoan dm = new DmLoan();
            dm.Id = pm.Id;
            dm.Name = pm.Name;
            dm.LookupKey = pm.LLCBI_lookupKey_c;
            dm.ProductLine = pm.LLCBI_Product_Line_c;
            dm.ProductType = pm.LLCBI_Product_Type_c;
            dm.Product = pm.LLCBI_Product_c;
            dm.AccountNumber = pm.Account_Number_c;
            dm.OriginalAmount = pm.LLCBI_Amount_c;
            dm.IsRenewal = pm.LLCBI_isRenewal_c;
            dm.IsModification = pm.LLCBI_Is_Modification_c;
            dm.Channel = pm.Channel_c;
            dm.RegOLoan = pm.Reg_O_Loan_c;
            
            DmUnit dmUnit = new DmUnit();
            dmUnit.Name = pm.Unit_r.Name;
            dmUnit.BranchCode = Integer.valueOf(pm.Unit_r.Branch_Number_c);
            dm.unit = dmUnit;
    		dm.PledgedCollateral = getPledges(pm.LLCBI_Loan_Collateral_r);
            
            dms.add(dm);
        }
        return dms;
    }

    public List<DmNcinoDocumentPlaceHolder> buildAccountDocuments(List<PM_LLCBI_AccountDocument_c> pms){
        List<DmNcinoDocumentPlaceHolder> dms = new List<DmNcinoDocumentPlaceHolder>();
        for(PM_LLCBI_AccountDocument_c pm : pms){
            DmNcinoDocumentPlaceHolder dm = new DmNcinoDocumentPlaceHolder();
            dm.Id = pm.Id;
            dm.name = pm.Name;
            dm.ObjectId = pm.LLCBI_Account_r.Id;
            dm.ObjectName = pm.LLCBI_Account_r.Name;
            dm.IsPortalEnabled = pm.LLCBI_Portal_Enabled_c;
            dm.DocumentName = pm.LLCBI_Portal_Doc_Name_c;
            dm.DocumentDescription = pm.LLCBI_Portal_Doc_Description_c;
            dm.DocumentDueDate = pm.Document_Due_Date_c;
            dm.DocumentStoreId = pm.LLCBI_Document_Store_r.Id;
            dm.CreatedDate = pm.CreatedDate;
            dms.add(dm);
        }
        return dms;
    }

    public List<DmNcinoDocumentPlaceHolder> buildLoanDocuments(List<PM_LLCBI_LLC_LoanDocument_c> pms){
        List<DmNcinoDocumentPlaceHolder> dms = new List<DmNcinoDocumentPlaceHolder>();
        for(PM_LLCBI_LLC_LoanDocument_c pm: pms){
            DmNcinoDocumentPlaceHolder dm = new DmNcinoDocumentPlaceHolder();
            dm.Id = pm.Id;
            dm.name = pm.Name;
            dm.ObjectId = pm.LLCBI_Loan_r.Id;
            dm.ObjectName = pm.LLCBI_Loan_r.Name;
            dm.IsPortalEnabled = pm.LLCBI_Portal_Enabled_c;
            dm.DocumentName = pm.LLCBI_Portal_Doc_Name_c;
            dm.DocumentDescription = pm.LLCBI_Portal_Doc_Description_c;
            dm.DocumentDueDate = pm.Document_Due_Date_c;
            dm.DocumentStoreId = pm.LLCBI_Document_Store_r.Id;
            dm.CreatedDate = pm.CreatedDate;
            dms.add(dm);
        }
        return dms;
    }

    public List<DmNcinoDocumentPlaceHolder> buildCollateralDocuments(List<PM_LLCBI_Document_PlaceHolder_c> pms, Map<String,String> collateralLookup){
        List<DmNcinoDocumentPlaceHolder> dms = new List<DmNcinoDocumentPlaceHolder>();
        for(PM_LLCBI_Document_PlaceHolder_c pm: pms){
            DmNcinoDocumentPlaceHolder dm = new DmNcinoDocumentPlaceHolder();
            dm.Id = pm.Id;
            dm.name = pm.Name;
            dm.ObjectId = pm.LLCBI_External_Id_c;
            dm.ObjectName = collateralLookup.get(pm.LLCBI_External_Id_c);
            dm.DocumentName = pm.LLCBI_Portal_Doc_Name_c;
            dm.IsPortalEnabled = pm.LLCBI_Portal_Enabled_c;
            dm.DocumentDescription = pm.LLCBI_Portal_Doc_Description_c;
            dm.DocumentDueDate = pm.Document_Due_Date_c;
            dm.DocumentStoreId = pm.LLCBI_Document_Store_r.Id;
            dms.add(dm);
        }
        return dms;
    }

    public List<DmEbAccount> buildEbAccounts(List<PM_EB_Account_c> pms){
        List<DmEbAccount> dms = new List<DmEbAccount>();
        for(PM_EB_Account_c pm: pms){
            DmEbAccount dm = new DmEbAccount();
            dm.id = pm.id;
            dm.name = pm.Name;
            dm.application = pm.Application_c == null? 0:Integer.valueof(pm.Application_c);
            dm.accountNumber = pm.Account_Number_c;
            dm.accountLine1 = pm.Account_Line_1_c;
            dms.add(dm);
        }
        return dms;
    }

    public List<DmLoanRenewal> buildLoanRenewals(List<PM_LLCBI_LoanRenewal_c> pms){
        List<DmLoanRenewal> dms = new List<DmLoanRenewal>();
        for(PM_LLCBI_LoanRenewal_c pm: pms){
            DmLoanRenewal dm = new DmLoanRenewal();
            dm.id = pm.id;
            dm.rootLoan = new DmLoan();
            dm.rootLoan.Id = pm.LLCBI_RootLoanId_r.Id;
            dm.parentLoan = new DmLoan();
            dm.parentLoan.id = pm.LLCBI_ParentLoanId_r.id;
            dm.renewalLoan = new DmLoan();
            dm.renewalLoan.id = pm.LLCBI_RenewalLoanId_r.Id;
            dm.renewalLoan.name = pm.LLCBI_RenewalLoanId_r.Name;
            dm.renewalOrder = pm.LLCBI_RevisionNumber_c;
            dm.revisionStatus = pm.LLCBI_RevisionStatus_c;
            dms.add(dm);
        }
        return dms;
    }
    
    private List<DmLoanCollateralRelationship> getPledges(List<PM_LLCBI_Loan_Collateral2_c> pms){
        List<DmLoanCollateralRelationship> dms = new List<DmLoanCollateralRelationship>();
        for(PM_LLCBI_Loan_Collateral2_c pm : pms){
            DmLoanCollateralRelationship dm = new DmLoanCollateralRelationship();
            dm.Id = pm.Id;
            dm.Name = pm.Name;
            dm.LienPosition = pm.LLCBI_Lien_Position_c;
            dm.LendableValue = pm.LLCBI_Current_Lendable_Value_c;
            dm.IsPrimary = pm.LLCBI_Is_Primary_c;
            dm.AbundanceOfCaution = pm.Abundance_Of_Caution_c;
            
            DmLoan dmLoan = new DmLoan();
            dmLoan.Id = pm.LLCBI_Loan_r.Id;
            dmLoan.Name = pm.LLCBI_Loan_r.Name;
            dmLoan.LookupKey = pm.LLCBI_Loan_r.LLCBI_lookupKey_c;
            dm.loan = dmLoan;
                   
            DmEntity entityDm = new DmEntity();
            PM_Account owner = pm.LLCBI_Collateral_r.Primary_Owner_r;
            if(owner != null){
                entityDm.id = owner.Id;
                entityDm.name = owner.Name;
                entityDm.coreName = owner.EB_Client_Name_c;
                entityDm.billingStreet = owner.BillingStreet;
                entityDm.billingCity = owner.BillingCity;
                entityDm.billingState = owner.BillingState; 
                entityDm.billingPostalCode = owner.BillingPostalCode;
    
                DmRecordType recordTypeDm = new DmRecordType();
                recordTypeDm.name = owner.RecordType.Name;
                entityDm.recordType = recordTypeDm;
            }
            
            DmCollateralType colTypeDm = new DmCollateralType(); 
            if (pm.LLCBI_Collateral_r != null && pm.LLCBI_Collateral_r.Change_Collateral_Code_c == 'Yes') {
                colTypeDm.Name = pm.LLCBI_Collateral_r.Modified_Collateral_Type_r.Name;
                colTypeDm.CollateralCode = pm.LLCBI_Collateral_r.Modified_Collateral_Type_r.LLCBI_Collateral_Code_c;
            }
            else {
                colTypeDm.name = pm.LLCBI_Collateral_r.LLCBI_Collateral_Type_r.Name;
                colTypeDm.collateralCode = pm.LLCBI_Collateral_r.LLCBI_Collateral_Type_r.LLCBI_Collateral_Code_c;    
            }
            
            DmCollateral colDm = new DmCollateral();
            colDm.id = pm.LLCBI_Collateral_r.Id;
            colDm.name = pm.LLCBI_Collateral_r.Name;
            colDm.coreName = pm.LLCBI_Collateral_r.LLCBI_Collateral_Name_c;
            colDm.description = pm.LLCBI_Collateral_r.LLCBI_Description_c == null ? pm.Description_c : pm.LLCBI_Collateral_r.LLCBI_Description_c;
            colDm.lendableValue = pm.LLCBI_Collateral_r.LLCBI_Lendable_Value_c; 
            colDm.isModifiedCollateralType = pm.LLCBI_Collateral_r.Change_Collateral_Code_c == 'Yes';
            colDm.assignmentOfRents = pm.LLCBI_Collateral_r.Assignment_of_Rent_c;
            colDm.floodInsuranceRequired = pm.LLCBI_Collateral_r.Flood_Insurance_Required_c;
            colDm.appraisedValue = pm.LLCBI_Collateral_r.Appraised_Value_reviewed_c;
            colDm.appraisedValueDate = pm.LLCBI_Collateral_r.Valuation_Date_c;
            colDm.street = pm.LLCBI_Collateral_r.LLCBI_Street_Address_c;
            colDm.city = pm.LLCBI_Collateral_r.LLCBI_City_c;
            colDm.state = pm.LLCBI_Collateral_r.LLCBI_State_c;
            colDm.postalCode = pm.LLCBI_Collateral_r.LLCBI_Zip_Code_c;
            colDm.collateralType = colTypeDm;
            colDm.primaryOwner = entityDm;
            colDm.parcelNumber = pm.LLCBI_Collateral_r.LLC_BI_Parcel_Number_c;
            
            dm.collateral = colDm;
            
            dms.add(dm);
        }
        return dms;
    }
    
}