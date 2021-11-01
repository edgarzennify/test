@IsTest
private class LoanDocPrepDmBuilderHelperTests {

	private static final LoanDocPrepDmBuilderHelper sut;

	static {
		sut = new LoanDocPrepDmBuilderHelper();
	}

	private static testMethod void it_should_build_a_loan_without_relationships_when_pm_is_provided() {
		
		LoanDocPrep.NcinoLoanPm pm = new LoanDocPrep.NcinoLoanPm();
		Date applicationDate = Date.newInstance(2017, 1, 31);
		Date closingDate = Date.newInstance(2017, 2,30);
		Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		pm.loanApplication = new LLC_BI__Loan__c();
		pm.loanApplication.id = loanId;
		pm.loanApplication.Name = '123456-13';
		pm.loanApplication.LLC_BI__lookupKey__c = '123456';
		pm.loanApplication.Application__c = 13;
		pm.loanApplication.LLC_BI__Amount__c = 50.25;
		pm.loanApplication.Application_Date__c = applicationDate;
		pm.loanApplication.LLC_BI__InterestRate__c = 2.303;
		pm.loanApplication.LLC_BI__Interest_Rate_Adjustment_Frequency__c = '12';
		pm.loanApplication.Close_Date__c = closingDate;
		pm.loanApplication.Unit__r = new EB_Unit__c(Name = 'test-unit');
		pm.loanApplication.Use_of_Funds_Purpose__c = 'test-fund';
		pm.loanApplication.LLC_BI__Payment_Type__c = 'test-payment-type';
		pm.loanApplication.Interest_Rate_Type_Description__c = 'test-interest-rate-desc';
		pm.loanApplication.LLC_BI__Index__c = '1234-20';
		pm.loanApplication.LLC_BI__Term_Months__c = 20;
		pm.loanAppOfficer = new EB_Team_Member__c(officer_code__c = 'test-officer-code');
		pm.loanApplication.LLC_BI__Rate_Ceiling__c = 1.02;
		pm.loanApplication.LLC_BI__Rate_Floor__c = 2.0345;
		pm.loanApplication.Reg_O_Loan__c = true;
		pm.loanApplication.LLC_BI__Spread__c = 123.23;
		pm.loanApplication.Employee_Loan__c = false;
		pm.loanApplication.LLC_BI__isRenewal__c = false;
		pm.loanApplication.LLC_BI__Is_Modification__c = true;

		DmLoan result = sut.buildLoan(pm);

		System.assertEquals(loanId, result.id);
		System.assertEquals('123456-13' , result.name);
		System.assertEquals('13' , result.application);
		System.assertEquals('123456' , result.accountNumber);
		System.assertEquals(50.25 , result.originalAmount);
		System.assertEquals(applicationDate ,result.applicationDate);
		System.assertEquals(2.303 , result.interestRate);
		System.assertEquals('12' ,result.interestRateAdjustmentFrequency);
		System.assertEquals(null , result.loanApplicationNumber);
		System.assertEquals(closingDate , result.closingDate);
		System.assertEquals('test-unit' , result.unit.name);
		System.assertEquals('test-fund' , result.useOfFunds);
		System.assertEquals('test-payment-type' , result.paymentType);
		System.assertEquals('test-interest-rate-desc' , result.rateType);
		System.assertEquals(20 , result.indexRateId);
		System.assertEquals('test-officer-code' , result.servicingOfficer.officerCode);
		System.assertEquals(1.02 , result.rateCeiling );
		System.assertEquals(2.0345 , result.rateFloor);
		System.assertEquals(true , result.regOloan);
		System.assertEquals(123.23 , result.spread);
		System.assertEquals(false , result.isEmployeeLoan);
		System.assertEquals(true , result.regOLoan);
		System.assertEquals(false , result.isRenewal);
		System.assertEquals(true , result.isModification);
	}

	private static testMethod void it_should_build_a_related_entity() {

		LLC_BI__Legal_Entities__c pm = new LLC_BI__Legal_Entities__c();
		Date birthDate = Date.newInstance(2017, 1, 30);
		Account entity = new Account();
		entity.Name = 'test-entity';
		entity.BillingStreet = 'test-street';
		entity.BillingCity = 'test-city';
		entity.BillingState = 'test-state';
		entity.BillingPostalCode = 'test-code';
		entity.EB_Customer_Number__c = '616-1234';
		entity.Phone = '123-34-3344';
		entity.TIN_SSN__c = '0000';
		entity.SSNTIN_Encrypted__c = '1234567';
		entity.Birthdate__c = birthDate;
		entity.Sic = '20';
		entity.Sub_Type__c = 'business-type';
		entity.Email__c = 'example@test.com';

		LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
		loan.Name = 'test-loan';
		pm.LLC_BI__Borrower_Type__c = 'test-type';
		pm.LLC_BI__Account__r = entity;
		pm.LLC_BI__Loan__r = loan;

		DmLoanEntityRelationship result = sut.buildRelatedEntity(pm);

		System.assertEquals('test-type' ,result.relationshipType);
		System.assertEquals('test-entity' , result.entity.name);
		System.assertEquals('test-street' , result.entity.billingStreet);
		System.assertEquals('test-city', result.entity.billingCity);
		System.assertEquals('test-state' , result.entity.billingState);
		System.assertEquals('test-code' , result.entity.billingPostalCode);
		System.assertEquals('616-1234' , result.entity.customerNumber);
		System.assertEquals('123-34-3344', result.entity.phone);	
		System.assertEquals(birthDate, result.entity.birthDate);
		System.assertEquals('20' , result.entity.sicCode);
		System.assertEquals('business-type' , result.entity.entityType);
		System.assertEquals('example@test.com' , result.entity.email);
	}

	private static testMethod void it_should_build_a_related_collateral() {

		Id collateralId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType , '1'); 
		Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '2');
		Id loanId  = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '3');
		Account entity = new Account(Name='test-entity');
		insert entity;

		LLC_BI__Collateral_Type__c collType = new LLC_BI__Collateral_Type__c();
		collType.LLC_BI__Collateral_Code__c = 'test-coll-type';
		insert collType;
		LLC_BI__Collateral_Type__c modifiedCollType = new LLC_BI__Collateral_Type__c();
		modifiedCollType.LLC_BI__Collateral_Code__c = 'modified-coll-type';
		insert modifiedCollType;

		LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
		collateral.LLC_BI__Street_Address__c = 'test-street';
		collateral.LLC_BI__City__c = 'test-city';
		collateral.LLC_BI__State__c = 'test-state';
		collateral.LLC_BI__Zip_Code__c = 'test-zip';
		collateral.LLC_BI__County__c = 'test-county';
		collateral.LLC_BI__Value__c = 1200.00;
		collateral.LLC_BI__Description__c = 'test-description';
		collateral.LLC_BI__Collateral_Type__r = collType;
		collateral.LLC_BI__Collateral_Type__c = collType.id;
		collateral.Modified_Collateral_Type__c = modifiedCollType.Id;
		collateral.Modified_Collateral_Type__r = modifiedCollType;
		//collateral.Modified_Collateral_Type__r.Id = modifiedCollType.Id;
        collateral.LLC_BI__Collateral_Name__c = '1122';
        collateral.Sync_Key__c = '1122';
        collateral.Change_Collateral_Code__c = 'yes';
		insert collateral;

		LLC_BI__Account_Collateral__c ownership = new LLC_BI__Account_Collateral__c();
		ownership.LLC_BI__Collateral__c = collateral.id;
		ownership.LLC_BI__Account__c = entity.id;
		ownership.LLC_BI__Account__r = entity;
		ownership.LLC_BI__Primary_Owner__c = true;
		insert ownership;

		LLC_BI__Loan__c loan = new LLC_BI__Loan__c(id=loanid);
        loan.TDR_Determination_1__c = 'Borrower is not experiencing financial difficulty';
        loan.TDR_Detail_Justification__c = 'justified';
        //insert loan;
		LLC_BI__Loan_Collateral_Aggregate__c agg = new LLC_BI__Loan_Collateral_Aggregate__c();
        insert agg;
		List<LLC_BI__Account_Collateral__c> ownerships = new List<LLC_BI__Account_Collateral__c>{ownership};
		LLC_BI__Loan_Collateral2__c pm = new LLC_BI__Loan_Collateral2__c();
		pm.LLC_BI__Collateral__r = collateral;
		pm.LLC_BI__Collateral__r.Id = collateral.Id;
		pm.LLC_BI__Loan__c = loan.id;
		pm.LLC_BI__Loan__r = loan;
		pm.LLC_BI__Is_Primary__c = true;
		pm.LLC_BI__Loan_Collateral_Aggregate__c = agg.Id;

		DmLoanCollateralRelationship result = sut.buildRelatedCollateral(pm,ownerships);

		System.assertEquals(true , result.isPrimary);
		System.assertEquals('test-street' , result.collateral.street);
		System.assertEquals('test-city' , result.collateral.city);
		System.assertEquals('test-state' , result.collateral.state);
		System.assertEquals('test-zip' , result.collateral.postalCode);
		System.assertEquals('test-county' , result.collateral.county);
		System.assertEquals(1200.00 , result.collateral.marketValue);
		System.assertEquals('test-description' , result.collateral.description);
		System.assertEquals('modified-coll-type' , result.collateral.collateralType.collateralCode);
	}

	private static testMethod void it_should_build_the_fee() {
		LLC_BI__Fee__c fee = new LLC_BI__Fee__c();
		fee.LLC_BI__Fee_Type__c = 'test-type';
		fee.LLC_BI__Amount__c = 2500.00;

		DmFee result = sut.buildFee(fee);

		System.assertEquals('test-type' , result.feeType);
		System.assertEquals(2500.00 , result.amount);
	}

	private static testMethod void it_should_extract_the_loan_number_from_the_given_name1() {
		LoanDocPrep.NcinoLoanPm pm = new LoanDocPrep.NcinoLoanPm();
		pm.loanApplication = new LLC_BI__Loan__c();
		pm.loanApplication.LLC_BI__lookupKey__c = '616-11-9037918R-3';
		pm.loanApplication.Unit__r = new EB_Unit__c(Name = 'test-unit');
		pm.loanAppOfficer = new EB_Team_Member__c(officer_code__c = 'test-officer-code');		

		DmLoan result = sut.buildLoan(pm);

		System.assertEquals('9037918' , result.accountNumber);
	}

	private static testMethod void it_should_extract_the_loan_number_from_the_given_name2() {
		LoanDocPrep.NcinoLoanPm pm = new LoanDocPrep.NcinoLoanPm();
		pm.loanApplication = new LLC_BI__Loan__c();
		pm.loanApplication.LLC_BI__lookupKey__c = null;
		pm.loanApplication.Unit__r = new EB_Unit__c(Name = 'test-unit');
		pm.loanAppOfficer = new EB_Team_Member__c(officer_code__c = 'test-officer-code');		

		DmLoan result = sut.buildLoan(pm);

		System.assertEquals('' , result.accountNumber);
	}

	private static testMethod void it_should_extract_the_loan_number_from_the_given_name3() {
		LoanDocPrep.NcinoLoanPm pm = new LoanDocPrep.NcinoLoanPm();
		pm.loanApplication = new LLC_BI__Loan__c();
		pm.loanApplication.LLC_BI__lookupKey__c = '616-15-8211793';
		pm.loanApplication.Unit__r = new EB_Unit__c(Name = 'test-unit');
		pm.loanAppOfficer = new EB_Team_Member__c(officer_code__c = 'test-officer-code');		

		DmLoan result = sut.buildLoan(pm);

		System.assertEquals('8211793' , result.accountNumber);
	}
}