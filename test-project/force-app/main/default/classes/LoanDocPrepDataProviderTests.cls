@IsTest
public class LoanDocPrepDataProviderTests {

	private static final LoanDocPrepDataProvider sut;

	static {
		sut = new LoanDocPrepDataProvider();
	}

	private static testMethod void it_should_get_a_loan_when_loan_id_is_provided() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        insert loan;

		LLC_BI__Loan__c result = sut.getLoan(loan.Id);

		Object fieldObject;
		fieldObject = result.Id;
		fieldObject = result.Application__c;
		fieldObject = result.Application_Number__c;
		fieldObject = result.Close_Date__c;
		fieldObject = result.Employee_Loan__c;
		fieldObject = result.Interest_Rate_Type_Description__c;
		fieldObject = result.LLC_BI__Amount__c;
		fieldObject = result.LLC_BI__Index__c;
		fieldObject = result.LLC_BI__Interest_Rate_Adjustment_Frequency__c;
		fieldObject = result.LLC_BI__InterestRate__c;
		fieldObject = result.LLC_BI__Is_Modification__c;
		fieldObject = result.LLC_BI__isRenewal__c;
		fieldObject = result.LLC_BI__Maturity_Date__c;
		fieldObject = result.LLC_BI__Payment_Type__c;
		fieldObject = result.LLC_BI__Rate_Ceiling__c;
		fieldObject = result.LLC_BI__Rate_Floor__c;
		fieldObject = result.LLC_BI__Spread__c;
		fieldObject = result.LLC_BI__Term_Months__c;
		fieldObject = result.Name;
		fieldObject = result.Reg_O_Loan__c;
		fieldObject = result.Unit__r.Name;
		fieldObject = result.Use_of_Funds_Purpose__c;
	}

	private static testMethod void it_should_get_a_list_of_loan_collateral_when_loan_id_is_provided() {
		LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
		insert loan;
		LLC_BI__Collateral_Type__c colType = new LLC_BI__Collateral_Type__c();
		insert colType;
		LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
		collateral.LLC_BI__Collateral_Type__c = colType.Id;
		insert collateral;
		LLC_BI__Loan_Collateral_Aggregate__c agg = new LLC_BI__Loan_Collateral_Aggregate__c();
        insert agg;
		LLC_BI__Loan_Collateral2__c loanCollateral = new LLC_BI__Loan_Collateral2__c();
		loanCollateral.LLC_BI__Loan__c = loan.Id;
		loanCollateral.LLC_BI__Collateral__c = collateral.Id;
		loanCollateral.LLC_BI__Loan_Collateral_Aggregate__c = agg.Id;
		insert loanCollateral;

		List<LLC_BI__Loan_Collateral2__c> result = sut.getLoanCollateral(loan.Id);

		Object fieldObject;
		fieldObject = result[0].LLC_BI__Collateral__c;
		fieldObject = result[0].LLC_BI__Collateral__r.Change_Collateral_Code__c;
		fieldObject = result[0].LLC_BI__Collateral__r.LLC_BI__City__c ;
		fieldObject = result[0].LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.LLC_BI__Collateral_Code__c;
		fieldObject = result[0].LLC_BI__Collateral__r.LLC_BI__County__c;
		fieldObject = result[0].LLC_BI__Collateral__r.LLC_BI__Description__c;
		fieldObject = result[0].LLC_BI__Collateral__r.LLC_BI__State__c;
		fieldObject = result[0].LLC_BI__Collateral__r.LLC_BI__Street_Address__c;
		fieldObject = result[0].LLC_BI__Collateral__r.LLC_BI__Value__c;
		fieldObject = result[0].LLC_BI__Collateral__r.LLC_BI__Zip_Code__c;
		fieldObject = result[0].LLC_BI__Collateral__r.Modified_Collateral_Type__r.LLC_BI__Collateral_Code__c;
		fieldObject = result[0].LLC_BI__Is_Primary__c;
	}

	private static testMethod void it_should_get_collateral_ownerships_when_loan_id_is_provided() {
		LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
		insert loan;
		Account entity = new Account(Name='test-entity');
		insert entity;
		LLC_BI__Collateral_Type__c colType = new LLC_BI__Collateral_Type__c();
		insert colType;
		LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
		collateral.LLC_BI__Collateral_Type__c = colType.Id;
		insert collateral;
		LLC_BI__Loan_Collateral_Aggregate__c agg = new LLC_BI__Loan_Collateral_Aggregate__c();
        insert agg;
		LLC_BI__Loan_Collateral2__c loanCollateral = new LLC_BI__Loan_Collateral2__c();
		loanCollateral.LLC_BI__Loan__c = loan.Id;
		loanCollateral.LLC_BI__Collateral__c = collateral.Id;
		loanCollateral.LLC_BI__Loan_Collateral_Aggregate__c = agg.Id;
		insert loanCollateral;
		LLC_BI__Account_Collateral__c ownership = new LLC_BI__Account_Collateral__c();
		ownership.LLC_BI__Collateral__c = collateral.id;
		ownership.LLC_BI__Account__c = entity.id;
		ownership.LLC_BI__Primary_Owner__c = true;
		insert ownership;

		List<LLC_BI__Account_Collateral__c> result = sut.getLoanCollateralOwnerships(loan.Id);

		Object fieldObject;
		fieldObject = result[0].LLC_BI__Primary_Owner__c;
		fieldObject = result[0].LLC_BI__Relationship_Type__c;
		fieldObject = result[0].LLC_BI__Collateral__c;
	}

	private static testMethod void it_should_get_entity_involvements_when_loan_id_is_provided() {
		LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
		insert loan;
		Account entity = new Account(Name = 'test-entity');
		insert entity;
		LLC_BI__Legal_Entities__c envInv = new LLC_BI__Legal_Entities__c();
		envInv.LLC_BI__Loan__c = loan.Id;
		envInv.LLC_BI__Account__c = entity.Id;
		insert envInv;

		List<LLC_BI__Legal_Entities__c> result = sut.getLoanEntities(loan.Id);

		Object fieldObject;
		fieldObject = result[0].LLC_BI__Account__r.BillingCity;
		fieldObject = result[0].LLC_BI__Account__r.BillingPostalCode;
		fieldObject = result[0].LLC_BI__Account__r.BillingState;
		fieldObject = result[0].LLC_BI__Account__r.BillingStreet;
		fieldObject = result[0].LLC_BI__Account__r.Birthdate__c;
		fieldObject = result[0].LLC_BI__Account__r.EB_Customer_Number__c;
		fieldObject = result[0].LLC_BI__Account__r.Email__c; 
		fieldObject = result[0].LLC_BI__Account__r.Name;
		fieldObject = result[0].LLC_BI__Account__r.Phone;
		fieldObject = result[0].LLC_BI__Account__r.Sic;
		fieldObject = result[0].LLC_BI__Account__r.SSNTIN_Encrypted__c;
		fieldObject = result[0].LLC_BI__Account__r.Sub_type__c;
		fieldObject = result[0].LLC_BI__Account__r.TIN_SSN__c;
		fieldObject = result[0].LLC_BI__Borrower_Type__c;
	}

	private static testMethod void it_should_get_loan_fees_when_loan_id_is_provided() {
		LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
		insert loan;
		LLC_BI__Fee__c fee = new LLC_BI__Fee__c();
		fee.LLC_BI__Loan__c = loan.Id;
		insert fee;

		List<LLC_BI__Fee__c> result =  sut.getLoanFees(loan.Id);

		Object fieldObject;
		fieldObject = result[0].LLC_BI__Fee_Type__c;
		fieldObject = result[0].LLC_BI__Amount__c;
	}

	private static testMethod void it_should_get_a_loan_officer() {
		LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
		loan.LLC_BI__Loan_Officer__c = ObjectFactory.getUser('rupadhya').Id;
		insert loan;

		EB_Team_Member__c result =  sut.getLoanOfficer(loan.Id);

		Object fieldObject;
		fieldObject = result.Officer_Code__c;
	}
}