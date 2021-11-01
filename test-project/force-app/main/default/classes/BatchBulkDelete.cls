global class BatchBulkDelete implements Database.Batchable<sObject>{
    private String m_selectionQuery;

    global BatchBulkDelete(String selectionQuery){
        m_selectionQuery = selectionQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(m_selectionQuery);
    }
   
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        delete scope;
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}