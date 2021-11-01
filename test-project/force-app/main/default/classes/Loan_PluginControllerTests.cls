@IsTest
private class Loan_PluginControllerTests {

   private static SObject record;
   private static final Mock.ofIStandardController mockStandardController;
   private static Loan_PluginController sut;
   private final static PluginMock.ofILoan_PluginDataProvider mockDataProvider;

   static {
      mockStandardController = new Mock.ofIStandardController();
      mockDataProvider = new PluginMock.ofILoan_PluginDataProvider();
      sut = new Loan_PluginController(mockDataProvider, mockStandardController);
   }

   @IsTest
   static void it_should_display_related_records_of_the_ebAccount() {
      Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
      Id ebAccountId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');

      LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
      loan.Id = loanId;
      loan.LLC_BI__lookupKey__c = 'TestKey';

      EB_Account__c ebAccount = new EB_Account__c();
      ebAccount.Id = ebAccountId;
      ebAccount.Key__c = 'TestKey';
      
      PM_EB_Account_c pmEbAccount = new PM_EB_Account_c();
      pmEbAccount.Id = ebAccountId;
      pmEbAccount.Key_c = 'TestKey';
      pmEbAccount.OriginalSObject = ebAccount;

      mockStandardController.setup('getRecord')
         .returns(loan);
      mockDataProvider.setup('getNcinoLoanById', new List<Object>{loan.Id})
         .returns(loan);
      mockDataProvider.setup('getEbAccountByKey', new List<Object>{loan.LLC_BI__lookupKey__c})
         .returns(new List<PM_EB_Account_c>{pmEbAccount});
      //act
      sut.initialize();
      //assert
      System.assertEquals(ebAccountId, sut.ebAccount.Id);
      System.assertEquals(false, sut.displayLoanList);
      System.assertEquals(true, sut.displayEbAccountList);
   }

   @IsTest
   static void it_should_display_related_records_of_the_parent_ebAccount() {
      Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
      Id parentLoanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
      Id parentEbAccountId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');

      LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
      loan.Id = loanId;
      loan.LLC_BI__lookupKey__c = 'TestKey';
      LLC_BI__Loan__c parentLoan = new LLC_BI__Loan__c();
      parentLoan.Id = parentLoanId;
      parentLoan.LLC_BI__lookupKey__c = 'ParentTestKey';

      PM_Agreement_EB_Account_Relationship_c agreementRel = new PM_Agreement_EB_Account_Relationship_c();
      agreementRel.Loan_Account_c = parentEbAccountId;

      EB_Account__c parentEbAccount = new EB_Account__c();
      parentEbAccount.Id = parentEbAccountId;
      parentEbAccount.Key__c = 'ParentTestKey';

      PM_EB_Account_c pmParentEbAccount = new PM_EB_Account_c();
      pmParentEbAccount.Id = parentEbAccountId;
      pmParentEbAccount.Key_c = 'ParentTestKey';
      pmParentEbAccount.Agreement_EB_Account_Relationship_r = new List<PM_Agreement_EB_Account_Relationship_c>{agreementRel};
      pmParentEbAccount.OriginalSObject = parentEbAccount;

      LLC_BI__LoanRenewal__c rel = new LLC_BI__LoanRenewal__c();
      rel.LLC_BI__RenewalLoanId__c = loanId;
      rel.LLC_BI__ParentLoanId__r = parentLoan;
      rel.LLC_BI__ParentLoanId__c = parentLoanId;

      mockStandardController.setup('getRecord')
         .returns(loan);
      mockDataProvider.setup('getNcinoLoanById', new List<Object>{loan.Id})
         .returns(loan);
      mockDataProvider.setup('getEbAccountByKey', new List<Object>{loan.LLC_BI__lookupKey__c})
         .returns(new List<PM_EB_Account_c>());
      mockDataProvider.setup('getParentLoanRelationship', new List<Object>{loanId})
         .returns(new List<LLC_BI__LoanRenewal__c>{rel});
      mockDataProvider.setup('getEbAccountByKey', new List<Object>{parentLoan.LLC_BI__lookupKey__c})
         .returns(new List<PM_EB_Account_c>{pmParentEbAccount});
      //act
      sut.initialize();
      //assert
      System.assertEquals(parentEbAccountId, sut.ebAccount.Id);
      System.assertEquals(false, sut.displayLoanList);
      System.assertEquals(true, sut.displayEbAccountList);
   }

   @IsTest
   static void it_should_display_related_recrods_of_the_loan_when_the_parent_loan_does_not_have_an_ebAccount() {
      Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
      Id parentLoanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
      Id parentEbAccountId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');

      LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
      loan.Id = loanId;
      loan.LLC_BI__lookupKey__c = 'TestKey';
      LLC_BI__Loan__c parentLoan = new LLC_BI__Loan__c();
      parentLoan.Id = parentLoanId;
      parentLoan.LLC_BI__lookupKey__c = 'ParentTestKey';

      PM_Agreement_EB_Account_Relationship_c agreementRel = new PM_Agreement_EB_Account_Relationship_c();
      agreementRel.Loan_Account_c = parentEbAccountId;

      EB_Account__c parentEbAccount = new EB_Account__c();
      parentEbAccount.Id = parentEbAccountId;
      parentEbAccount.Key__c = 'ParentTestKey';

      LLC_BI__LoanRenewal__c rel = new LLC_BI__LoanRenewal__c();
      rel.LLC_BI__RenewalLoanId__c = loanId;
      rel.LLC_BI__ParentLoanId__r = parentLoan;
      rel.LLC_BI__ParentLoanId__c = parentLoanId;

      mockStandardController.setup('getRecord')
         .returns(loan);
      mockDataProvider.setup('getNcinoLoanById', new List<Object>{loan.Id})
         .returns(loan);
      mockDataProvider.setup('getEbAccountByKey', new List<Object>{loan.LLC_BI__lookupKey__c})
         .returns(new List<PM_EB_Account_c>());
      mockDataProvider.setup('getParentLoanRelationship', new List<Object>{loanId})
         .returns(new List<LLC_BI__LoanRenewal__c>{rel});
      mockDataProvider.setup('getEbAccountByKey', new List<Object>{parentLoan.LLC_BI__lookupKey__c})
         .returns(new List<PM_EB_Account_c>());
      //act
      sut.initialize();
      //assert
      System.assertEquals(false, sut.displayEbAccountList);
      System.assertEquals(true, sut.displayLoanList);
      System.assertEquals(null, sut.ebAccount);
   }

   @IsTest
   static void it_should_display_related_records_of_the_loan_when_both_the_loan_and_parent_do_not_have_ebAccounts() {
      Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');

      LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
      loan.Id = loanId;
      loan.LLC_BI__lookupKey__c = 'TestKey';

      mockStandardController.setup('getRecord')
         .returns(loan);
      mockDataProvider.setup('getNcinoLoanById', new List<Object>{loan.Id})
         .returns(loan);
      mockDataProvider.setup('getEbAccountByKey', new List<Object>{loan.LLC_BI__lookupKey__c})
         .returns(new List<PM_EB_Account_c>());
      mockDataProvider.setup('getParentLoanRelationship', new List<Object>{loanId})
         .returns(new List<LLC_BI__LoanRenewal__c>());
      //act
      sut.initialize();
      //assert
      System.assertEquals(false, sut.displayEbAccountList);
      System.assertEquals(true, sut.displayLoanList);
      System.assertEquals(null, sut.ebAccount);
   }
   
   @IsTest
   static void code_coverage_for_constructor() {
      sut = new Loan_PluginController(null);
   }       
}