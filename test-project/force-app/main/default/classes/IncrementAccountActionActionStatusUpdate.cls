public class IncrementAccountActionActionStatusUpdate {
    
 	private static IUpdateActionStatusDataProvider m_dataProvider;
    private static IApexPages m_apexPages;
    
    public interface IUpdateActionStatusDataProvider extends DataProvider.IDataProvider{
        EB_Loan_Action__c getAccountAction (String curId);
    }  
    
    public IncrementAccountActionActionStatusUpdate(){  
    	m_dataProvider = new IncrementAccountActionActionStatus_DP(); 
        m_apexPages = new ApexPagesWrapper();
    }  
    
    public IncrementAccountActionActionStatusUpdate(IupdateActionStatusDataProvider dataProvider, IApexPages apexPages){  
    	m_dataProvider = dataProvider;
        m_apexPages = apexPages;
    }    

    Public PageReference IncrementActionStatusUpdate(){
        String currentId = m_apexPages.getParameter('id');
        EB_Loan_Action__c currentAction = m_dataProvider.getAccountAction(currentId);
        determineNewActionStatusUpdate(currentAction);
        return new PageReference ('/'+ currentId);
    }
    
    private void determineNewActionStatusUpdate(EB_Loan_Action__c action){
        if(!action.On_Hold__c){
            if(action.Action_Status_Update__c == null){
                action.Action_Status_Update__c = 0;
            }else{
                action.Action_Status_Update__c++;
            }   
            m_dataProvider.Save(action);
        }        
    }
}