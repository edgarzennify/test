public class AgreementStageActionManagerCntr{
    public interface IDataProvider{
        EB_Stage_Action_Controller__c getStageControllerByAgreementId(Id agreementId);
    }
    
 	Id AgreementId;
    IDataprovider m_dataProvider;
    
    public AgreementStageActionManagerCntr(ApexPages.StandardController controller) {
        m_dataProvider = new AgreementStageActionMgr_Dataprovider();
        this.AgreementId = apexpages.currentpage().getparameters().get('id');
    }
    
    public AgreementStageActionManagerCntr(Id agreementId, IDataProvider dataProvider){
        m_dataProvider = dataProvider;
        this.AgreementId = agreementId;
    }
    
    public PageReference RedirectAction(){
        EB_Stage_Action_Controller__c stageActionController = m_dataProvider.getStageControllerByAgreementId(this.AgreementId);
        if(stageActionController != null){
          String newPageUrl = stageActionController.Visual_Force_Action_Page__c + '?id=' + this.AgreementId;
          PageReference newPage = new PageReference(newPageUrl);
          newPage.setRedirect(true);
          return newPage;
        }
        return null;
    }
}