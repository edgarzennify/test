@IsTest
private class CardRepositoryTests {
	
    private static CardRepository sut;
    private static final MockOfIDataProvider mockDataProvider;
    
    static {
        mockDataProvider = new MockOfIDataProvider();
        sut = new CardRepository(mockDataProvider);
    }
    
    @IsTest
    static void it_should_get_all_loan_accounts() {
        Card_Information__c c1 = new Card_Information__c();
        c1.Account_Type__c = 'Deposit';
        c1.Active__c = true;
        Card_Information__c c2 = new Card_Information__c();
        c2.Account_Type__c = 'Loan';
        c2.Active__c = true;
        List<Card_Information__c> pms = new List<Card_Information__c>{c2};
        
        mockDataProvider.setup('getActiveCardInformationsByType', new List<Object>{'Loan'}).returns(pms);
        
        List<DmCardInformation> result = sut.getLoanCards();
        
        mockDataProvider.verify('getActiveCardInformationsByType' , new List<Object>{'Loan'}, Times.Once);
        System.assertEquals(1, result.size());
        System.assertEquals('Loan', result[0].AccountType);
    }
    
    @IsTest
    static void it_should_get_all_deposit_accounts() {
        Card_Information__c c1 = new Card_Information__c();
        c1.Account_Type__c = 'Deposit';
        c1.Active__c = true;
        Card_Information__c c2 = new Card_Information__c();
        c2.Account_Type__c = 'Loan';
        c2.Active__c = true;
        List<Card_Information__c> pms = new List<Card_Information__c>{c1};
        
        mockDataProvider.setup('getActiveCardInformationsByType', new List<Object>{'Deposit'}).returns(pms);
        
        List<DmCardInformation> result = sut.getDepositCards();
        
        mockDataProvider.verify('getActiveCardInformationsByType' , new List<Object>{'Deposit'}, Times.Once);
        System.assertEquals(1, result.size());
        System.assertEquals('Deposit', result[0].AccountType);
    }
    
    @IsTest
    static void it_should_get_all_tm_accounts() {
        Card_Information__c c1 = new Card_Information__c();
        c1.From_Tm_Request__c = true;
        c1.Account_Type__c = 'Deposit';
        c1.Active__c = true;
        Card_Information__c c2 = new Card_Information__c();
        c2.From_Tm_Request__c = false;
        c2.Account_Type__c = 'loan';
        c2.Active__c = true;
        List<Card_Information__c> pms = new List<Card_Information__c>{c1, c2};
        
        mockDataProvider.setup('getAllActiveCardInformations').returns(pms);
        
        List<DmCardInformation> result = sut.getTmCards();
        
        mockDataProvider.verify('getAllActiveCardInformations', Times.Once);
        System.assertEquals(1, result.size());
        System.assertEquals('Deposit', result[0].AccountType);
    }
    
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
}