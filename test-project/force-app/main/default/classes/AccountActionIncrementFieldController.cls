public class AccountActionIncrementFieldController {
    
 	private static IAccountActionIncrementFieldDataProvider m_dataProvider;
    private static IApexPages m_apexPages;
    
    public interface IAccountActionIncrementFieldDataProvider extends DataProvider.IDataProvider{
        EB_Loan_Action__c getAccountAction (String curId);
    }  
    
    public AccountActionIncrementFieldController(){  
    	m_dataProvider = new AccountActionIncrementFieldDataProvider();
        m_apexPages = new ApexPagesWrapper();
    }  
    
    public AccountActionIncrementFieldController(IAccountActionIncrementFieldDataProvider dataProvider, IApexPages apexPages){  
    	m_dataProvider = dataProvider;
        m_apexPages = apexPages;
    }    
    
    Public PageReference init(){
        String currentId = m_apexPages.getParameter('id');
        String incrementField = m_apexPages.getParameter('Increment_Field__c');
        EB_Loan_Action__c currentAction = m_dataProvider.getAccountAction(currentId);
        determineNewActionStatusUpdate(currentAction, incrementField);
        return new PageReference ('/'+ currentId);
    }
    
    private void determineNewActionStatusUpdate(EB_Loan_Action__c action, String incrementField){
        if(!action.On_Hold__c){
            if(Integer.valueOf(action.get(incrementField)) == null){
                action.put(incrementField, 0);
            }else{
                action.put(incrementField, Integer.valueOf(action.get(incrementField)) + 1);
            }   
            m_dataProvider.Save(action);
        }     
    }
}