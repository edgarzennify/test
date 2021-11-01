public class CPDocsNcinoDataProvider implements CPDocs.INcinoDataProvider {
    public List<PM_LLCBI_Legal_Entities_c> getLegalEntities(String entityId){
        List<LLC_BI__Legal_Entities__c> pms = [
            SELECT
                        Id,
                        Name,
                        LLC_BI__Tax_ID__c,
                        LLC_BI__Relationship_Type__c,
                        LLC_BI__Borrower_Type__c,
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
                        LLC_BI__Loan__r.Id,
                        LLC_BI__Loan__r.Name,
                        LLC_BI__Loan__r.RecordTypeId,
                        LLC_BI__Loan__r.RecordType.Name
                    FROM
                        LLC_BI__Legal_Entities__c
                    WHERE
                        LLC_BI__Account__c =: entityId
        ];

        return buildlegalEntities(pms);
    }

    public List<PM_LLCBI_Loan_c> getLoans(List<string> loanIds) {
        List<LLC_BI__Loan__c> loans = [
            SELECT 
                Id, 
                Name,
                LLC_BI__Product_Type__c,
                LLC_BI__Product_Line__c,
                LLC_BI__Product__c,
                LLC_BI__Amount_Available__c,
                LLC_BI__Amount__c,
                Account_Number__c,
                LLC_BI__lookupKey__c,
                LLC_BI__Account__c,
                LLC_BI__isRenewal__c,
                LLC_BI__Is_Modification__c,
                Channel__c,            
                Unit__r.Name,
            	Unit__r.Branch_Number__c,
                LLC_BI__Account__r.Id,
                LLC_BI__Account__r.Name,
                LLC_BI__Account__r.Type,
                LLC_BI__Account__r.RecordType.Name,
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
                        LLC_BI__Collateral__r.LLC_BI__Description__c,
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
                        LLC_BI__Collateral__r.Primary_Owner__r.Name
                    FROM 
                        LLC_BI__Loan_Collateral__r
                    ORDER BY
                        LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c
                )             
            FROM 
                LLC_BI__Loan__c 
            WHERE 
                Id in:loanIds
        ];

        List<PM_LLCBI_Loan_c> pms = new List<PM_LLCBI_Loan_c>();
        for(LLC_BI__Loan__c ln: loans){

        
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

            pm.Unit_r = new PM_EB_Unit_c();
            pm.Unit_r.Name = ln.Unit__r.Name;
            pm.Unit_r.Branch_Number_c = ln.Unit__r.Branch_Number__c;

            pm.LLCBI_Account_r = new PM_Account();
            pm.LLCBI_Account_r.Id = ln.LLC_BI__Account__c;
            pm.LLCBI_Account_r.Name = ln.LLC_BI__Account__r.Name;
            pm.LLCBI_Account_r.Type = ln.LLC_BI__Account__r.Type;

            pm.LLCBI_Account_r.RecordType = new PM_RecordType();
            pm.LLCBI_Account_r.RecordType.Name = ln.LLC_BI__Account__r.RecordType.Name;
                
            pm.LLCBI_Loan_Collateral_r = new List<PM_LLCBI_Loan_Collateral2_c>();
                for (LLC_BI__Loan_Collateral2__c pledge : ln.LLC_BI__Loan_Collateral__r) {
                    PM_LLCBI_Loan_Collateral2_c pmPledge = new PM_LLCBI_Loan_Collateral2_c();
                    pmPledge.Id = pledge.Id;
                    pmPledge.Name = pledge.Name;

                    pmPledge.LLCBI_Collateral_r = new PM_LLCBI_Collateral_c();
                    pmPledge.LLCBI_Collateral_r.Id = pledge.LLC_BI__Collateral__r.Id;
                    pmPledge.LLCBI_Collateral_r.Name = pledge.LLC_BI__Collateral__r.Name;
                    pmPledge.LLCBI_Collateral_r.LLCBI_Collateral_Name_c = pledge.LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c;
                    pmPledge.LLCBI_Collateral_r.Change_Collateral_Code_c = pledge.LLC_BI__Collateral__r.Change_Collateral_Code__c;
                

                    pmPledge.LLCBI_Collateral_r.LLCBI_Collateral_Type_r = new PM_LLCBI_Collateral_Type_c();
                    pmPledge.LLCBI_Collateral_r.LLCBI_Collateral_Type_r.Name = pledge.LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Name;
                    pmPledge.LLCBI_Collateral_r.LLCBI_Collateral_Type_r.LLCBI_Collateral_Code_c = pledge.LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.LLC_BI__Collateral_Code__c;

                    pmPledge.LLCBI_Collateral_r.Modified_Collateral_Type_r = new PM_LLCBI_Collateral_Type_c();
                    pmPledge.LLCBI_Collateral_r.Modified_Collateral_Type_r.Name = pledge.LLC_BI__Collateral__r.Modified_Collateral_Type__r.Name;
                    pmPledge.LLCBI_Collateral_r.Modified_Collateral_Type_r.LLCBI_Collateral_Code_c = pledge.LLC_BI__Collateral__r.Modified_Collateral_Type__r.LLC_BI__Collateral_Code__c;

                    pmPledge.LLCBI_Collateral_r.Primary_Owner_r = new PM_Account();
                    pmPledge.LLCBI_Collateral_r.Primary_Owner_r.Id = pledge.LLC_BI__Collateral__r.Primary_Owner__r.Id;
                    pmPledge.LLCBI_Collateral_r.Primary_Owner_r.Name = pledge.LLC_BI__Collateral__r.Primary_Owner__r.Name;
                

                    pmPledge.LLCBI_Collateral_r.Primary_Owner_r.RecordType = new PM_RecordType();
                    pmPledge.LLCBI_Collateral_r.Primary_Owner_r.RecordType.Name = pledge.LLC_BI__Collateral__r.Primary_Owner__r.RecordType.Name;
                    pm.LLCBI_Loan_Collateral_r.add(pmPledge);
                }
            pms.add(pm);
        }
        return pms;  
    }

    public List<PM_LLCBI_AccountDocument_c> getAccountDocuments(List<string> entityIds){
        List<LLC_BI__AccountDocument__c> docs = [
            SELECT
                Id
                ,Name
                ,LLC_BI__Account__c
                ,LLC_BI__Account__r.Name
                ,LLC_BI__Portal_Enabled__c
                ,LLC_BI__Portal_Doc_Description__c
                ,LLC_BI__Portal_Doc_Name__c
                ,Document_Due_Date__c
                ,LLC_BI__Document_Store_Index__c
                ,LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c
                ,LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__r.Name
                ,CreatedDate
            FROM
                LLC_BI__AccountDocument__c
            WHERE
                LLC_BI__Account__c in: entityIds
            ORDER BY
                Name,LLC_BI__Portal_Doc_Name__c
        ];
        return buildAccountDocumentPms(docs);
    }

    public List<PM_LLCBI_LLC_LoanDocument_c> getLoanDocuments(List<string> loanIds){
            List<LLC_BI__LLC_LoanDocument__c> docs = [
                SELECT
                    Id
                    ,Name
                    ,LLC_BI__Loan__c
                    ,LLC_BI__Loan__r.Name
                    ,LLC_BI__Portal_Enabled__c
                    ,LLC_BI__Portal_Doc_Description__c
                    ,LLC_BI__Portal_Doc_Name__c
                    ,Document_Due_Date__c
                    ,LLC_BI__Document_Store_Index__c
                    ,LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c
                    ,LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__r.Name
                    ,CreatedDate
                FROM
                    LLC_BI__LLC_LoanDocument__c
                WHERE
                    LLC_BI__Loan__c in: loanIds
                ORDER BY
                    Name,LLC_BI__Portal_Doc_Name__c
            ];
            
            List<PM_LLCBI_LLC_LoanDocument_c> pms = new List<PM_LLCBI_LLC_LoanDocument_c>();
            for(LLC_BI__LLC_LoanDocument__c doc: docs){
                PM_LLCBI_LLC_LoanDocument_c pm = new PM_LLCBI_LLC_LoanDocument_c();
                pm.Id = pm.Id;
                pm.Name = pm.Name;
                pm.LLCBI_Loan_r = new PM_LLCBI_Loan_c();
                pm.LLCBI_Loan_r.Id = doc.LLC_BI__Loan__c;
                pm.LLCBI_Loan_r.Name = doc.LLC_BI__Loan__r.Name;
                pm.LLCBI_Portal_Enabled_c = doc.LLC_BI__Portal_Enabled__c;
                pm.LLCBI_Portal_Doc_Description_c = doc.LLC_BI__Portal_Doc_Description__c;
                pm.LLCBI_Portal_Doc_Name_c = doc.LLC_BI__Portal_Doc_Name__c;
                pm.Document_Due_Date_c = doc.Document_Due_Date__c;
                pm.LLCBI_Document_Store_r = new PM_LLCBI_Document_Store_c();
                if(String.isNotBlank(doc.LLC_BI__Document_Store_Index__c) && String.isNotBlank(doc.LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c)){
                    pm.LLCBI_Document_Store_r.Id = doc.LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c;
                    pm.LLCBI_Document_Store_r.Name = doc.LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__r.Name;
                }
                pm.CreatedDate = doc.CreatedDate;
                pms.add(pm);
            }
        return pms;
    }

    public List<PM_LLCBI_Document_PlaceHolder_c> getCollateralDocuments(List<string> collateralIds){
        List<LLC_BI__Document_PlaceHolder__c> docs = [
            SELECT
                Id
                ,Name
                ,LLC_BI__External_Id__c
                ,LLC_BI__Description__c
                ,LLC_BI__Portal_Enabled__c
                ,LLC_BI__Portal_Doc_Description__c
                ,LLC_BI__Portal_Doc_Name__c
                ,LLC_BI__Document_Store_Index__c
                ,LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c
                ,LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__r.Name
                ,Document_Due_Date__c
                ,CreatedDate
            FROM
                LLC_BI__Document_Placeholder__c
            WHERE
                LLC_BI__External_Id__c in:collateralIds
            ORDER BY
                Name,LLC_BI__Portal_Doc_Name__c
        ];
        return buildCollateralPms(docs);
    }

    public List<PM_EB_Account_c> getRelatedEbAccounts(String entityId){
        List<integer> apps = new List<Integer>();
        apps.add(2);apps.add(4);

        List<Eb_Account__c> accts = [
            SELECT
                Id
                ,Name
                ,Application__c
                ,Account_Number__c
                ,Account_Line_1__c
            FROM 
                EB_Account__c 
            WHERE
                Application__c in: apps
                AND Primary_Owner_Id__c  =: entityId

        ];
        return buildEbAccounts(accts);
    }

    public List<PM_LLCBI_LoanRenewal_c> getRenewals(List<string> loanIds){
        List<PM_LLCBI_LoanRenewal_c> pms = new List<PM_LLCBI_LoanRenewal_c>();
        List<LLC_BI__LoanRenewal__c> roots = [
            SELECT
                Id
                ,LLC_BI__RootLoanId__c
            FROM 
                LLC_BI__LoanRenewal__c
            WHERE 
                LLC_BI__RenewalLoanId__c =: loanIds
        ];

        if(roots == null || roots.size() == 0) return pms;
        List<Id> rootIds = new List<Id>();
        for(LLC_BI__LoanRenewal__c root: roots){
            rootIds.add(root.Id);
        }


        List<LLC_BI__LoanRenewal__c> allLoanRels = [
            SELECT 
                Id
                ,LLC_BI__RenewalLoanId__c
                ,LLC_BI__RenewalLoanId__r.Name
                ,LLC_BI__RenewalLoanId__r.LLC_BI__lookupKey__c
                ,LLC_BI__RootLoanId__c
                ,LLC_BI__ParentLoanId__c
                ,LLC_BI__RevisionNumber__c
                ,LLC_BI__RevisionStatus__c
            FROM 
                LLC_BI__LoanRenewal__c
            WHERE 
                LLC_BI__RootLoanId__c =: rootIds
        ];

        for(LLC_BI__LoanRenewal__c rel: allLoanRels){
            PM_LLCBI_LoanRenewal_c pm = new PM_LLCBI_LoanRenewal_c();
            pm.LLCBI_ParentLoanId_r = new PM_LLCBI_Loan_c();
            pm.LLCBI_ParentLoanId_r.Id = rel.LLC_BI__ParentLoanId__c;
            pm.LLCBI_RenewalLoanId_r = new PM_LLCBI_Loan_c();
            pm.LLCBI_RenewalLoanId_r.Id = rel.LLC_BI__RenewalLoanId__c;
            pm.LLCBI_RenewalLoanId_r.Id = rel.LLC_BI__RenewalLoanId__r.Name;
            pm.LLCBI_RenewalLoanId_r.LLCBI_lookupKey_c = rel.LLC_BI__RenewalLoanId__r.LLC_BI__lookupKey__c;
            pm.LLCBI_RootLoanId_r = new PM_LLCBI_Loan_c();
            pm.LLCBI_RootLoanId_r.Id = rel.LLC_BI__RootLoanId__c;
            pms.add(pm);
        }
        return pms;
    }

    private List<PM_EB_Account_c> buildEbAccounts(List<Eb_Account__c> accts){
        List<PM_EB_Account_c> pms = new List<PM_EB_Account_c>();
        if(accts == null || accts.size() == 0) return pms;
        for(Eb_Account__c acct: accts){
            PM_EB_Account_c pm = new PM_EB_Account_c();
            pm.Id = acct.Id;
            pm.Name = acct.Name;
            pm.Application_c = acct.Application__c;
            pm.Account_Number_c = acct.Account_Number__c;
            pm.Account_Line_1_c = acct.Account_Line_1__c;
            pms.add(pm);
        }
        return pms;
    }

    private List<PM_LLCBI_Legal_Entities_c> buildlegalEntities(List<LLC_BI__Legal_Entities__c> legalEntities){
        List<PM_LLCBI_Legal_Entities_c> pms = new List<PM_LLCBI_Legal_Entities_c>();

        for(LLC_BI__Legal_Entities__c le : legalEntities){
            PM_LLCBI_Legal_Entities_c pmLe = new PM_LLCBI_Legal_Entities_c();
            pmLe.Id = le.Id;
            pmLe.Name = le.Name;
            pmLe.LLCBI_Tax_ID_c = le.LLC_BI__Tax_ID__c;
            pmLe.LLCBI_Relationship_Type_c = le.LLC_BI__Relationship_Type__c;
            pmLe.LLCBI_Borrower_Type_c = le.LLC_BI__Borrower_Type__c;

            pmLe.LLCBI_Account_r = new PM_Account();
            pmLe.LLCBI_Account_r.Id = le.LLC_BI__Account__r.Id;
            pmLe.LLCBI_Account_r.Name = le.LLC_BI__Account__r.Name;
            
            pmLe.LLCBI_Account_r.RecordType = new PM_RecordType();
            pmLe.LLCBI_Account_r.RecordType.Name = le.LLC_BI__Account__r.RecordType.Name;
            
            pmLe.LLCBI_Loan_r = new PM_LLCBI_Loan_c();
            pmLe.LLCBI_Loan_r.Id = le.LLC_BI__Loan__r.Id;
            pmLe.LLCBI_Loan_r.Name = le.LLC_BI__Loan__r.Name;

            pms.add(pmLe);
        }

        return pms;
    }

    private List<PM_LLCBI_AccountDocument_c> buildAccountDocumentPms(List<LLC_BI__AccountDocument__c> adocs){
        List<PM_LLCBI_AccountDocument_c> pms = new List<PM_LLCBI_AccountDocument_c>();
        for(LLC_BI__AccountDocument__c adoc: adocs){
            pms.add(buildOneAccountDocumentPm(adoc));
        }
        return pms;
    }

    private PM_LLCBI_AccountDocument_c buildOneAccountDocumentPm(LLC_BI__AccountDocument__c adoc){
        PM_LLCBI_AccountDocument_c pm = new PM_LLCBI_AccountDocument_c();
        pm.Id = adoc.Id;
        pm.Name = adoc.Name;
        pm.LLCBI_Account_r = new PM_Account();
        if(String.isNotBlank(adoc.LLC_BI__Account__c)){
            pm.LLCBI_Account_r.Id = adoc.LLC_BI__Account__c;
            pm.LLCBI_Account_r.Name = adoc.LLC_BI__Account__r.Name;
        }
        pm.LLCBI_Portal_Doc_Description_c = adoc.LLC_BI__Portal_Doc_Description__c;
        pm.LLCBI_Portal_Doc_Name_c = adoc.LLC_BI__Portal_Doc_Name__c;
        pm.CreatedDate = adoc.CreatedDate;
        pm.LLCBI_Portal_Enabled_c = adoc.LLC_BI__Portal_Enabled__c;
        pm.Document_Due_Date_c = adoc.Document_Due_Date__c;
        pm.LLCBI_Document_Store_r = new PM_LLCBI_Document_Store_c();
        if(String.isNotBlank(adoc.LLC_BI__Document_Store_Index__c) && String.isNotBlank(adoc.LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c)){
            pm.LLCBI_Document_Store_r.Id = adoc.LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c;
            pm.LLCBI_Document_Store_r.Name = adoc.LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__r.Name;
        }
        return pm;
    }

    private List<PM_LLCBI_Document_PlaceHolder_c> buildCollateralPms(List<LLC_BI__Document_Placeholder__c> docs){
        List<PM_LLCBI_Document_PlaceHolder_c> pms = new List<PM_LLCBI_Document_PlaceHolder_c>();
        for(LLC_BI__Document_Placeholder__c d: docs){
            PM_LLCBI_Document_PlaceHolder_c pm = new PM_LLCBI_Document_PlaceHolder_c();
            pm.Id = d.Id;
            pm.Name = d.Name;
            pm.LLCBI_External_Id_c = d.LLC_BI__External_Id__c;
            pm.LLCBI_Portal_Enabled_c = d.LLC_BI__Portal_Enabled__c;
            pm.LLCBI_Portal_Doc_Name_c = d.LLC_BI__Portal_Doc_Name__c;
            pm.LLCBI_Portal_Doc_Description_c = d.LLC_BI__Portal_Doc_Description__c;
            pm.Document_Due_Date_c = d.Document_Due_Date__c;
            pm.LLCBI_Document_Store_r = new PM_LLCBI_Document_Store_c();
            if(String.isNotBlank(d.LLC_BI__Document_Store_Index__c) && String.isNotBlank(d.LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c)){
                pm.LLCBI_Document_Store_r.Id = d.LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c;
                pm.LLCBI_Document_Store_r.Name = d.LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__r.Name;
            }
            pm.CreatedDate = d.CreatedDate;
            pms.add(pm);
        }
        return pms;
    }
}