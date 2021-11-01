public class LoanDocPrepDataProvider implements LoanDocPrep.IDataProvider {
    public LLC_BI__Loan__c getLoan(Id loanId){
    	return [
			SELECT
			    Id
				,Application__c  
				,Application_Date__c  
				,Application_Number__c   
				,Close_Date__c  
				,Employee_Loan__c  
				,Interest_Rate_Type_Description__c  
				,LLC_BI__Amount__c
				,LLC_BI__lookupKey__c  
				,LLC_BI__Index__c   
				,LLC_BI__Interest_Rate_Adjustment_Frequency__c  
				,LLC_BI__InterestRate__c				
				,LLC_BI__Is_Modification__c
				,LLC_BI__isRenewal__c
				,LLC_BI__Maturity_Date__c 
				,LLC_BI__Payment_Type__c  
				,LLC_BI__Rate_Ceiling__c  
				,LLC_BI__Rate_Floor__c  
				,LLC_BI__Spread__c  
				,LLC_BI__Term_Months__c  
				,Name  
				,Reg_O_Loan__c  
				,Unit__r.Name
				,Unit__r.Branch_Number__c
				,Use_of_Funds_Purpose__c
			FROM   
				LLC_BI__Loan__c   
			WHERE   
				Id =: loanId 
		];
    }

    public List<LLC_BI__Loan_Collateral2__c> getLoanCollateral(Id loanId){
    	return [
    		SELECT  
    		    LLC_BI__Collateral__c
				,LLC_BI__Collateral__r.Change_Collateral_Code__c	 
				,LLC_BI__Collateral__r.LLC_BI__City__c  	
				,LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.LLC_BI__Collateral_Code__c  	
				,LLC_BI__Collateral__r.LLC_BI__County__c  	
				,LLC_BI__Collateral__r.LLC_BI__Description__c  	
				,LLC_BI__Collateral__r.LLC_BI__State__c  	
				,LLC_BI__Collateral__r.LLC_BI__Street_Address__c  	
				,LLC_BI__Collateral__r.LLC_BI__Value__c  	
				,LLC_BI__Collateral__r.LLC_BI__Zip_Code__c
				,LLC_BI__Collateral__r.Modified_Collateral_Type__r.LLC_BI__Collateral_Code__c	
				,LLC_BI__Is_Primary__c  		 	
			FROM  
				LLC_BI__Loan_Collateral2__c   
			WHERE  
				LLC_BI__Loan__c =: loanId  
    	];
    }

    public List<LLC_BI__Account_Collateral__c> getLoanCollateralOwnerships(Id loanId){
    	return [
    		SELECT 
				LLC_BI__Primary_Owner__c
				,LLC_BI__Relationship_Type__c 
				,LLC_BI__Account__r.Name
				,LLC_BI__Collateral__c
			FROM 
				LLC_BI__Account_Collateral__c 
			WHERE  
				LLC_BI__Collateral__c IN (
					SELECT LLC_BI__Collateral__c FROM LLC_BI__Loan_Collateral2__c WHERE LLC_BI__Loan__c =: loanId
				)
    	];
    }

    public List<LLC_BI__Legal_Entities__c> getLoanEntities(Id loanId){
    	return [
    		SELECT 
				LLC_BI__Account__r.BillingCity
				,LLC_BI__Account__r.BillingPostalCode
				,LLC_BI__Account__r.BillingState
				,LLC_BI__Account__r.BillingStreet
				,LLC_BI__Account__r.Birthdate__c
				,LLC_BI__Account__r.EB_Customer_Number__c
				,LLC_BI__Account__r.Email__c 
				,LLC_BI__Account__r.Name
				,LLC_BI__Account__r.Phone
				,LLC_BI__Account__r.Sic
				,LLC_BI__Account__r.SSNTIN_Encrypted__c
				,LLC_BI__Account__r.Sub_type__c
				,LLC_BI__Account__r.TIN_SSN__c
				,LLC_BI__Borrower_Type__c
			FROM 
				LLC_BI__Legal_Entities__c 
			WHERE 
				LLC_BI__Loan__c =: loanId
			ORDER BY
				CreatedDate
    	];
    }

    public List<LLC_BI__Fee__c> getLoanFees(Id loanId){
    	return  [
    		SELECT
				LLC_BI__Fee_Type__c
				,LLC_BI__Amount__c
				,LLC_BI__Collection_Method__c
				,Custom_Fee_Payable_To__c
				,Fee_Waived__c
            	,EB_Paid_Status__c
			FROM 
				LLC_BI__Fee__c 
			WHERE 
				LLC_BI__Loan__c =: loanId
    	];
    }

    public EB_Team_Member__c getLoanOfficer(Id loanId) {

    	LLC_BI__Loan__c loan = [
    		SELECT
    			LLC_BI__Loan_Officer__c
    		FROM
    			LLC_BI__Loan__c
    		WHERE
    		    Id =: loanId
    	];

    	List<EB_Team_Member__c> tms = [
    		SELECT 
    			Officer_Code__c 
    		FROM 
    			EB_Team_Member__c 
    		WHERE 
    			User__c =: loan.LLC_BI__Loan_Officer__c
    		LIMIT 1
    	];

    	return tms.size() > 0 ? tms[0] : new EB_Team_Member__c();
    }
}