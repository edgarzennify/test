global class BatchBulkDeleteProcessor implements IBatchBulkDeleteProcessor {
    global interface IBatchBulkDeleteProcessor{
        void startBulkDeleteBatch(String selectionQuery);
    }

    global void startBulkDeleteBatch(String selectionQuery){
        BatchBulkDelete b = new BatchBulkDelete(selectionQuery);
        Database.executeBatch(b);
    }
}