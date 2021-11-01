public class Clone_AgreementDataProvider implements Agreements.IClone_AgreementDataProvider{
    private List<Agreement_Borrowing_Base_Relationship__c> bbList;
    private List<Agreement_Financial_Covenant__c> fcList;
    private List<Agreement_Client_Relationships__c> crList;
    private List<Agreement_EB_Account_Relationship__c> arList;
    private List<Agreement_Loan_Application_Relationship__c> lcrList;
    private List<Agreement_Subordination__c> asList;
    
    public Agreement__c GetAgreementById(Id agreementId){
        return [
                SELECT 
                    Id,
                    Name,
                    Loan_Coordinator__c,
                    RecordType.Name,
                    Revision_Number__c,
                    Actual_Approval_Process__c,
                    Agreement_Status__c,
                    Agreement_Sub_Status__c,
                    Borrower__c,
                    Borrower_Name__c,
                    Borrower_Summary__c,
                    Comments__c,
                    Loan_App_Summary__c,
                    Loan_Summary__c,
                    Agreement_Date__c,
                    Primary_Borrower__c,
                    Special_Instructions__c,
                    RecordTypeDescription__c,
                    Last_Amendment_Date__c,
                    Business_Loan_Agreement_Documents__c,
                    Guarantee_Agreement_Documents__c,
                    Subordination_Intercreditor_Documents__c,
                    Loan_Documents_Prepared_By__c,
                    Documentation_Path_Fx__c,
                    Law_Firm__c
                FROM Agreement__c WHERE Id =: agreementId LIMIT 1
                ];
    }
    
    public List<Agreement_Borrowing_Base_Relationship__c> GetAgreementBorrowingBaseRelationships(Id agreementId){
        if(bbList == null){
            bbList = [
                    SELECT 
                        Id, 
                        OwnerId, 
                        IsDeleted, 
                        Name, 
                        CreatedDate, 
                        CreatedById, 
                        LastModifiedDate, 
                        LastModifiedById, 
                        Age_of_Eligible_Accts_Less_Than_in_Days__c, 
                        Agreement__c, 
                        Eligible_Account_Adv_Rate__c, 
                        Equipment_Adv_Rate__c, 
                        Inventory_Adv_Rate__c, 
                        Less__c, 
                        Other_Percent__c, 
                        Other_Restrictions__c, 
                        Other__c, 
                        Status__c, 
                        Subtraction_Description__c, 
                        Rate__c, 
                        Cap__c,Amount__c, 
                        Other_Description__c, 
                        Component__c, 
                        EntitiesInText__c,
                        (SELECT 
                            Id, 
                            Name,
                            Agreement_Related_Borrowing_Base__c, 
                            Entity__c
                        FROM Agreement_Borrowing_Base_Entity_Rels__r)
                FROM Agreement_Borrowing_Base_Relationship__c 
                WHERE Agreement__c =: agreementId
                ];
        }
        return bbList;
    }
    
    public List<Agreement_Financial_Covenant__c> GetAgreementFinancialCovenants(Id agreementId){
        if(fcList == null){
            fcList = [
                    SELECT 
                        Id, 
                        OwnerId, 
                        IsDeleted, 
                        Name, 
                        CreatedDate, 
                        CreatedById, 
                        LastModifiedDate, 
                        LastModifiedById, 
                        Action_Modification__c, 
                        Agreement__c, 
                        Comments__c, 
                        Covenant_Measures__c, 
                        Covenant_Title__c, 
                        Covenant_Type__c, 
                        Standard_Covenant__c, 
                        Start_Date__c, 
                        Testing_Frequency__c, 
                        Testing_Based_On__c, 
                        EntitiesInText__c, 
                        Comments_Long__c, 
                        Covenant_Measures_Long__c,
                        (SELECT 
                            Id, 
                            Name, 
                            Agreement_Financial_Covenant__c, 
                            Entity__c
                        FROM Agreement_Financial_Covenant_Entity_Rels__r)                     
                    FROM Agreement_Financial_Covenant__c 
                    WHERE Agreement__c =: agreementId
                    ];
        }
        return fcList;
    }
    
    public List<Agreement_Client_Relationships__c> GetAgreementClientRelationships(Id agreementId){
        if(crList == null){
            crList = [
                        SELECT 
                            CreatedById, 
                            CreatedDate, 
                            Entity__c, Id, 
                            IsDeleted, 
                            IsLocked, 
                            LastModifiedById, 
                            LastModifiedDate, 
                            Name, 
                            OwnerId, 
                            Relationship__c,
                            (SELECT 
                                Id, 
                                Name, 
                                RecordTypeID, 
                                Agreement_Client_Relationship__r.Entity__c,
                                Agreement_Client_Relationship__r.Name, 
                                Agreement_Client_Relationship__c,
                                Frequency__c,
                                Include_In_Agreement__c,Other_Type__c,
                                Period_Due__c,Period_Due_Override__c 
                            FROM Agreement_Financial_Documents__r),
                            Entity__r.Annual_Financial_Statements__c, 
                            Entity__r.Annual_Statement_Quality__c, 
                            Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c,
                            Entity__r.Interim_Statements__c, 
                            Entity__r.Interim_Stm_Prepared_By__c, 
                            Entity__r.Interim_Stmt_Days_Due_After_Period_End__c,
                            Entity__r.Personal_Financial_Statement__c,
                            Entity__r.Personal_Financial_Statement_Frequency__c,
                            Entity__r.Tax_Returns__c,
                            Entity__r.Tax_Return_Days_Due_After_Filing__c, 
                            Entity__r.Fiscal_Year_End_Date__c
                        FROM Agreement_Client_Relationships__c 
                        WHERE Agreement__c =: agreementId
                    ];
        }
        return crList;
    }
    
    public List<Agreement_EB_Account_Relationship__c> GetAgreementEBAccountRelationships(Id agreementId){
        if(arList == null){
            arList = [
                        SELECT 
                            Agreement__c, 
                            Borrower_Summary__c, 
                            Borrower__c,  
                            Current_Balance__c, 
                            Entity__c, 
                            Id,   
                            Loan__c, 
                            Loan_Account__c, 
                            Name 
                            FROM Agreement_EB_Account_Relationship__c 
                            WHERE Agreement__c =: agreementId
                        ];
        }
        return arList;
    }
    
    public List<Agreement_Loan_Application_Relationship__c> GetAgreementLoanApplicationRelationships(Id agreementId){
        if(lcrList == null){
            lcrList = [
                        SELECT 
                            Id,  
                            Name, 
                            CreatedDate, 
                            CreatedById, 
                            LastModifiedDate, 
                            LastModifiedById, 
                            Agreement__c, 
                            Borrower_Summary__c, 
                            Borrower__c, 
                            EBT_Loan_Amount__c, 
                            EB_Loan_Application__c, 
                            Loan_Application__c, 
                            Loan_Packet__c, 
                            Modification__c, 
                            Record_Type__c, 
                            Total_Amount__c 
                        FROM Agreement_Loan_Application_Relationship__c
                        WHERE Agreement__c =: agreementId
                    ];
        }
        return lcrList;
        
    }
    public List<Agreement_Subordination__c> getAgreementSubordinationRelationships(Id agreementId){
        if(asList == null){
            asList = [
                        SELECT 
                            Agreement__c, 
                            Comments__c, 
                            CreatedById, 
                            CreatedDate, 
                            Creditor__c, 
                            EntitiesInText__c, 
                            Id, 
                            Limitation__c,
                            Name, 
                            Obligation_Amount__c, 
                            Obligation_Type__c, 
                            Payment_Allowed__c, 
                            Payment_Frequency__c, 
                            Payment_Type__c, 
                            Primary_Borrower__c,
                            (SELECT 
                                Id, 
                                Name, 
                                Agreement_Subordination__c,
                                Entity__c
                            FROM Agreement_Subordination_Entity_Rels__r) 
                      FROM Agreement_Subordination__c 
                      WHERE Agreement__c =: agreementId 
                    ];            
        }
        return asList;
    }
    public void RemoveAgreementLoanApps(List<Agreement_Loan_Application_Relationship__c> relatedAgmtLoanApps, Agreement__c original){
        if(relatedAgmtLoanApps != null && relatedAgmtLoanApps.size() > 0 && original != null && original.RecordTypeDescription__c == 'Active'){             
            delete relatedAgmtLoanApps;
        }
    }
    public Integer GetPendingAgreementCountByName(String revisionName){
        return [
                SELECT 
                    count() 
                FROM Agreement__c 
                WHERE Name 
                    LIKE: revisionName.trim() + '%' 
                    AND RecordType.Name = 'Pending'
                ];
    }
}