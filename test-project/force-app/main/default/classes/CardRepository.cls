public class CardRepository implements ICardRepository{
    public interface ICardRepository {
        List<DmCardInformation> getDepositCards();
        List<DmCardInformation> getLoanCards();
        List<DmCardInformation> getTmCards();
    }
    
    private string DEPOSIT_CARD = 'Deposit';
    private string LOAN_CARD = 'Loan';
    
    private final AccountNumberGenerator.IDataProvider m_dataProvider;
	
    public CardRepository(AccountNumberGenerator.IDataProvider dataProvider) {
        m_dataProvider = dataProvider;
    }
    public List<DmCardInformation> getDepositCards() {
        return buildDms(DEPOSIT_CARD);
    }
    
    public List<DmCardInformation> getLoanCards() {      
        return buildDms(LOAN_CARD);
    }

    public List<DmCardInformation> getTmCards() {
        List<DmCardInformation> dms = new List<DmCardInformation>();
        List<Card_Information__c> pms = m_dataProvider.getAllActiveCardInformations();
        if(pms == null || pms.size() == 0) {return dms;}

        for(Card_Information__c pm : pms){
            if(pm.From_Tm_Request__c == true) {
                dms.add(buildDm(pm));
            }
        }
        return dms;
    }
    
    private List<DmCardInformation> buildDms(String accountType) {
        List<DmCardInformation> dms = new List<DmCardInformation>();
        for(Card_Information__c pm : m_dataProvider.getActiveCardInformationsByType(accountType)){
            dms.add(buildDm(pm));
        }
        return dms;
    }
    
    private DmCardInformation buildDm(Card_Information__c pm) {
        DmCardInformation dm = new DmCardInformation();
        dm.cardType = pm.Card_Type__c;
        dm.accountType = pm.Account_Type__c;
        dm.apiResource = pm.url__c;
        return dm;
    }
}