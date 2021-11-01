@IsTest
private class AccountNumberGeneratorTests{

	private static MockOfIDataProvider mockDataProvider;
	private static Mock.ofIApexPages mockApexPages;
	private static MockOfIAccountNumberGeneratorHelper mockHelper;
	private static AccountNumberGenerator sut;

	static {
		mockDataProvider = new MockOfIDataProvider();
		mockApexPages = new Mock.ofIApexPages();
		mockHelper = new MockOfIAccountNumberGeneratorHelper();
		sut = new AccountNumberGenerator(mockDataProvider, mockApexPages, mockHelper);
	}


	@IsTest
    static void it_should_get_the_card_information_for_the_selected_generateId(){
		Id testId = ObjectFactory.getFakeId(Card_Information__c.SObjectType, '1');
		Card_Information__c card = new Card_Information__c();
		mockDataProvider.setup('getCardInformationById', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(card);

		sut.generateId = testId;
		 sut.Generate();
		
		mockDataProvider.verify('getCardInformationById', new List<Object>{testId}, Times.Once);
	}

	
	@IsTest
    static void it_should_get_one_card_number_from_the_account_service_when_generate_is_called(){
		Integer numberOfAccounts = 1;
		Id testId = ObjectFactory.getFakeId(Card_Information__c.SObjectType, '1');
		Card_Information__c card = new Card_Information__c();
		card.Id = testId;
		card.url__c = 'bogus';
		mockDataProvider.setup('getCardInformationById', new List<Object>{testId}).returns(card);

		sut.generateId = testId;
		sut.numberOfAccounts = string.valueof(numberOfAccounts);
		sut.Generate();
		
		mockHelper.verify('getNewAccountNumber', new List<Object>{card.url__c,numberOfAccounts}, Times.Once);
	}

	@IsTest
    static void it_should_get_multiple_card_number_from_the_account_service_when_generate_is_called(){
		Integer numberOfAccounts = 2;
		Id testId = ObjectFactory.getFakeId(Card_Information__c.SObjectType, '1');
		Card_Information__c card = new Card_Information__c();
		card.Id = testId;
		card.url__c = 'bogus';
		mockDataProvider.setup('getCardInformationById', new List<Object>{testId}).returns(card);

		sut.generateId = testId;
		sut.numberOfAccounts =  String.valueOf(numberOfAccounts);
		sut.Generate();
		
		mockHelper.verify('getNewAccountNumber', new List<Object>{card.url__c,numberOfAccounts}, Times.Once);
	}

	@IsTest
    static void it_should_get_the_id_parameter_from_apex_pages(){
		sut.Generate();

		mockApexPages.verify('getParameter', new List<Object>{'id'});
	}

	@IsTest
    static void it_should_save_the_given_loan_and_return_its_url(){
		Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		mockApexPages.setup('getParameter', new List<Object>{'id'}).returns(loanId);

		PageReference result = sut.Generate();

		mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		System.assertEquals('/' + loanId, result.getUrl());
	}

	@IsTest
    static void code_coverage_call_standard_constructor(){
		AccountNumberGenerator xsut = new AccountNumberGenerator();
	}

	////////////////////////////////

	private class MockOfIDataProvider extends ApexMoq implements AccountNumberGenerator.IDataProvider {
		public Card_Information__c getCardInformationById(Id objectId){
			return (Card_Information__c)handleMethodInvocation('getCardInformationById', new List<Object>{objectId});
		}
        public List<Card_Information__c> getActiveCardInformationsByType(String accountType){
        	return (List<Card_Information__c>)handleMethodInvocation('getActiveCardInformationsByType', new List<Object>{accountType});
        }
        public List<Card_Information__c> getAllActiveCardInformations() {
        	return (List<Card_Information__c>)handleMethodInvocation('getAllActiveCardInformations');
        }
        public void save(SObject so){
        	handleMethodInvocation('save', new List<Object>{so});
        }
	}

	private class MockOfIAccountNumberGeneratorHelper extends ApexMoq implements AccountNumberGeneratorHelper.IAccountNumberGeneratorHelper{

		public List<SelectOption> GetAccountTypes(List<Card_Information__c> accountTypes, string selectItemKey, Id generateId){
			return (List<SelectOption>)handleMethodInvocation('GetAccountTypes', new List<Object>{accountTypes,selectItemKey,generateId});
		}
		public AccountNumberGenerator.AccountSvcDetail getNewAccountNumber(String cardIdentifier, Integer numberOfAccounts){
			return (AccountNumberGenerator.AccountSvcDetail)handleMethodInvocation('getNewAccountNumber', new List<Object>{cardIdentifier, numberOfAccounts});
		}
		public string getBlobLineItems(List<string> lines){
			return (string)handleMethodInvocation('getBlobLineItems', new List<Object>{lines});
		}
		public Integer getNumberGeneratorMax(){
			return (integer)handleMethodInvocation('getNumberGeneratorMax');
		}
	}
}