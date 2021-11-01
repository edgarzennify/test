public class LoanDocPrepDmBuilderHelper implements LoanDocPrep.IDmBuilderHelper {
	
	public DmLoan buildLoan(LoanDocPrep.NcinoLoanPm pm) {
		DmLoan loan = new DmLoan();
		loan.id = pm.loanApplication.Id;
		loan.name = pm.loanApplication.Name;
		loan.lookupKey = pm.loanApplication.LLC_BI__lookupKey__c;
		loan.application = string.valueof(pm.loanApplication.Application__c);
		loan.accountNumber = getAccount(pm);
		loan.originalAmount = Double.valueof(pm.loanApplication.LLC_BI__Amount__c);
		loan.applicationDate = cleanDate(pm.loanApplication.Application_Date__c);
		loan.interestRate = cleanDecimal(pm.loanApplication.LLC_BI__InterestRate__c);
		loan.interestRateAdjustmentFrequency = pm.loanApplication.LLC_BI__Interest_Rate_Adjustment_Frequency__c;
		loan.loanApplicationNumber = pm.loanApplication.Application_Number__c;
		loan.closingDate = cleanDate(pm.loanApplication.Close_Date__c);
		loan.maturityDate = cleanDate(pm.loanApplication.LLC_BI__Maturity_Date__c);
		loan.unit =  getUnit(pm.loanApplication.Unit__r);
		loan.useOfFunds = pm.loanApplication.Use_of_Funds_Purpose__c;
		loan.paymentType = pm.loanApplication.LLC_BI__Payment_Type__c;
		loan.rateType = pm.loanApplication.Interest_Rate_Type_Description__c;
		loan.indexRateId = getIndexRateId(pm.loanApplication.LLC_BI__Index__c);
		loan.maturityTermMonths = cleanInteger(Integer.valueof(pm.loanApplication.LLC_BI__Term_Months__c));
		loan.servicingOfficer = getOfficer(pm.loanAppOfficer);
		loan.rateCeiling = cleanDecimal(pm.loanApplication.LLC_BI__Rate_Ceiling__c);
		loan.rateFloor = cleanDecimal(pm.loanApplication.LLC_BI__Rate_Floor__c);
		loan.regOLoan = pm.loanApplication.Reg_O_Loan__c;
		loan.spread = cleanDecimal(pm.loanApplication.LLC_BI__Spread__c);  
		loan.isEmployeeLoan = pm.loanApplication.Employee_Loan__c;
		loan.isRenewal = pm.loanApplication.LLC_BI__isRenewal__c;
		loan.isModification = pm.loanApplication.LLC_BI__Is_Modification__c;
		return loan;
	}

    public DmLoanEntityRelationship buildRelatedEntity(LLC_BI__Legal_Entities__c pm) {
		DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
		dm.relationshipType = pm.LLC_BI__Borrower_Type__c;
		dm.entity = buildEntity(pm.LLC_BI__Account__r);

		return dm;
	}

	public DmLoanCollateralRelationship buildRelatedCollateral(LLC_BI__Loan_Collateral2__c pledge, List<LLC_BI__Account_Collateral__c> ownerships) {
		DmLoanCollateralRelationship dm = new DmLoanCollateralRelationship();
		dm.isPrimary = pledge.LLC_BI__Is_Primary__c;
		dm.collateral = buildCollateral(pledge, ownerships);
		
		return dm;
	}

	public DmFee buildFee(LLC_BI__Fee__c fee) {
		DmFee dm = new DmFee();
		dm.feeType = fee.LLC_BI__Fee_Type__c;
		dm.amount = cleanDecimal(fee.LLC_BI__Amount__c);
		dm.collectionMethod = fee.LLC_BI__Collection_Method__c;
		dm.payableTo = fee.Custom_Fee_Payable_To__c;
		dm.isWaived = fee.EB_Paid_Status__c != null && fee.EB_Paid_Status__c.toUpperCase() == 'WAIVED';

		return dm;
	}

	private DmEntity buildEntity(Account entity) {
		DmEntity dm = new DmEntity();
		dm.name = entity.Name;
		dm.billingStreet = entity.BillingStreet;
		dm.billingCity = entity.BillingCity;
		dm.billingState = entity.BillingState;
		dm.billingPostalCode = entity.BillingPostalCode;
		dm.customerNumber = entity.EB_Customer_Number__c;
		dm.phone = entity.Phone;
		dm.taxId = getTaxId(entity);
		dm.birthDate = cleanDate(entity.Birthdate__c);
		dm.sicCode = entity.Sic;
		dm.entityType = entity.Sub_Type__c;
		dm.email = entity.Email__c;

		return dm;
	}

	private DmCollateral buildCollateral(LLC_BI__Loan_Collateral2__c pledge, List<LLC_BI__Account_Collateral__c> ownerships ) {
		DmCollateral dm = new DmCollateral();
		dm.primaryOwner = buildGrantor(pledge, ownerships);
		dm.street = pledge.LLC_BI__Collateral__r.LLC_BI__Street_Address__c;
		dm.city = pledge.LLC_BI__Collateral__r.LLC_BI__City__c;
		dm.state = pledge.LLC_BI__Collateral__r.LLC_BI__State__c;
		dm.postalCode = pledge.LLC_BI__Collateral__r.LLC_BI__Zip_Code__c;
		dm.county = pledge.LLC_BI__Collateral__r.LLC_BI__County__c;
		dm.marketValue = pledge.LLC_BI__Collateral__r.LLC_BI__Value__c;
		dm.description = pledge.LLC_BI__Collateral__r.LLC_BI__Description__c;
		dm.collateralType = buildCollateralType(pledge);
	
		return dm;
	}

	private DmEntity buildGrantor(LLC_BI__Loan_Collateral2__c pledge, List<LLC_BI__Account_Collateral__c> ownerships) {
		DmEntity dm = new DmEntity();
		for(LLC_BI__Account_Collateral__c o : ownerships) {
			if(o.LLC_BI__Collateral__c == pledge.LLC_BI__Collateral__c && o.LLC_BI__Primary_Owner__c) {
				dm.name = o.LLC_BI__Account__r.Name;
				return dm;
			}
		}
		return dm;
	}

	private DmUnit getUnit(EB_Unit__c unit) {
		DmUnit dm = new DmUnit();
		dm.name = unit.Name;
		dm.branchCode = Integer.valueOf(unit.Branch_Number__c);
		return dm;
	}

	private DmUser getOfficer(EB_Team_Member__c officer) {
		DmUser user = new DmUser();
		user.officerCode = officer.Officer_Code__c;
		return user;
	}

	private Integer getIndexRateId(string index) {
		if(string.isBlank(index)) return 0;
		List<string> parts = index.Split('-');
		return parts.size() > 1 ? Integer.valueof(parts[1])  : 0;
	}

	private string getAccount(LoanDocPrep.NcinoLoanPm pm) {
		return extractLoanNumber(pm.loanApplication.LLC_BI__lookupKey__c);
	}

	private string extractLoanNumber(string input)
    {
    	if(String.isEmpty(input)) return '';

        List<String> parts = input.Split('-');
        
        if (parts.size() > 2)
        {
            return parts[2].replaceAll('[^0-9]', '');
        }

        return input;
    }


	private string getTaxId(Account entity) {
		return string.isBlank(entity.SSNTIN_Encrypted__c)
					 ? entity.TIN_SSN__c
					 : entity.SSNTIN_Encrypted__c ;
	}

	private DmCollateralType buildCollateralType(LLC_BI__Loan_Collateral2__c pledge) {
		DmCollateralType dm = new DmCollateralType();
		dm.collateralCode = getCollateralCode(pledge);
		return dm;
	}

	private string getCollateralCode(LLC_BI__Loan_Collateral2__c pledge) {
		String changeCollateralCode = pledge.LLC_BI__Collateral__r.Change_Collateral_Code__c;
		if( string.isBlank(changeCollateralCode)
			|| changeCollateralCode.toLowerCase() != 'yes') {
			LLC_BI__Collateral_Type__c collType = pledge.LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r;
			if(collType != null) {
				return collType.LLC_BI__Collateral_Code__c;
			}else {
				return '';
			}
		}		
		return pledge.LLC_BI__Collateral__r.Modified_Collateral_Type__r.LLC_BI__Collateral_Code__c;
	}
    
    private Date cleanDate(Date value){
        if(value == null) return Date.newInstance(1900,1,1);
        return value;
    }
    
    private Double cleanDouble(Double value){
        if(value == null) return 0;
        return value;
    }
    
    private Integer cleanInteger(Integer value){
        if(value == null) return 0;
        return value;
    }
    
    private Decimal cleanDecimal(Decimal value){
        if(value == null) return 0;
        if(value < 0.000001) return 0.0;
        return value;
    }
}