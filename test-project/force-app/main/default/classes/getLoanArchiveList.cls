global class getLoanArchiveList implements Schedulable{

    private final String CLEANUP_EB_LOAN_APPS_QUERY = 'SELECT Id, Name FROM EB_Loan_Application__c WHERE Delete_Flag__c = true and Delete_Flag_IsSnapshotComplete__c = true ORDER BY LastModifiedDate DESC';
    private final String CLEANUP_EB_COLLATERAL_QUERY = 'SELECT Id, Name FROM EB_Collateral__c WHERE Delete_Flag__c = true ORDER BY LastModifiedDate DESC';
    private final String CLEANUP_WSCACHE_QUERY = 'SELECT Id FROM wscache__c WHERE IsExpired__c=1 ORDER BY CreatedDate ASC';
    private final BatchBulkDeleteProcessor.IBatchBulkDeleteProcessor m_bulkDelete;

    global getLoanArchiveList(){
        m_bulkDelete = new BatchBulkDeleteProcessor();
    }

    global getLoanArchiveList(BatchBulkDeleteProcessor.IBatchBulkDeleteProcessor bulkDelete){
        m_bulkDelete = bulkDelete;
    }

    //private GetLoanArchiveListDataProvider.IGetLoanArchiveListDataProvider m_dataProvider;
    //public getLoanArchiveList()
    //{
    //    m_dataProvider = new GetLoanArchiveListDataProvider();
    //}
    
    //public getLoanArchiveList(GetLoanArchiveListDataProvider.IGetLoanArchiveListDataProvider dataProvider)
    //{
    //    m_dataProvider = dataProvider;
    //}
    
    global void execute(SchedulableContext ctx){
        GetLoanArchiveListDataProvider.updateManualKPIDetails(100);
        GetLoanArchiveListDataProvider.fixWorkflowValidationIssueForEntityandCollateral(100);
        GetLoanArchiveListDataProvider.PurgeOrphanCollateralClientRelationships(100);
        GetLoanArchiveListDataProvider.WithdrawOldApprovedApps(10);
        GetLoanArchiveListDataProvider.WithdrawOldDocumentationApps(10);

        m_bulkDelete.startBulkDeleteBatch(CLEANUP_EB_LOAN_APPS_QUERY);
        m_bulkDelete.startBulkDeleteBatch(CLEANUP_EB_COLLATERAL_QUERY);
        m_bulkDelete.startBulkDeleteBatch(CLEANUP_WSCACHE_QUERY);
    }
    // public void deleteArchivedApps(){
    //    m_dataProvider.deleteArchivedApps();       
    // }
      
    // public void updateManualKPIDetails(){
    //    m_dataProvider.updateManualKPIDetails();
    // }
          
    // public void fixWorkflowValidationIssueForEntityandCollateral(){
    //    m_dataProvider.fixWorkflowValidationIssueForEntityandCollateral();
    // }
     
    // public void PurgeOrphanCollateralClientRelationships(){ 
    //    m_dataProvider.PurgeOrphanCollateralClientRelationships();
    // }

    // public void DeleteExpiredWSCache(){
    //    m_dataProvider.DeleteExpiredWSCache();
    // } 

    // public void WithdrawOldApprovedApps(){
    //    m_dataProvider.WithdrawOldApprovedApps();          
    // }

    // public void WithdrawOldDocumentationApps(){
    //    m_dataProvider.WithdrawOldDocumentationApps();          
    // }
}