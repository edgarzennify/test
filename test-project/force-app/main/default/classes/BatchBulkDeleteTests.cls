@isTest
private class BatchBulkDeleteTests{
    static testMethod void it_should_remove_expired_wscache_items(){
        WsCache__c c1 = new WsCache__c();
        c1.Override_Lifespan_Minutes__c = 0;
        WsCache__c c2 = new WsCache__c();
        c2.Override_Lifespan_Minutes__c = 0;
        WsCache__c c3 = new WsCache__c();
        c3.Override_Lifespan_Minutes__c = 1000;
        insert new List<WsCache__c>{c1, c2, c3};
        String query = 'SELECT Id FROM wscache__c WHERE IsExpired__c=1 ORDER BY CreatedDate ASC';
    
        Test.startTest();
        BatchBulkDelete b = new BatchBulkDelete(query);
        Database.executeBatch(b);
        Test.stopTest();
        
        List<WsCache__c> requery = [SELECT Id FROM WsCache__c];
        System.assertEquals(1, requery.size());
        System.assertEquals(c3.Id, requery[0].Id);
    }
    
    static testMethod void it_should_throw_an_exception_when_the_given_query_is_empty(){
        String query = '';
    
        try{
            Test.startTest();
            BatchBulkDelete b = new BatchBulkDelete(query);
            Database.executeBatch(b);
            Test.stopTest();
            System.assert(false);
        }catch(Exception ex){
            System.assert(true);
        }  
    }

    static testMethod void it_should_throw_an_exception_when_the_given_query_is_not_well_formed(){
        String query = 'SELECT * FROM Bogus';
    
        try{
            Test.startTest();
            BatchBulkDelete b = new BatchBulkDelete(query);
            Database.executeBatch(b);
            Test.stopTest();
            System.assert(false);
        }catch(Exception ex){
            System.assert(true);
        } 
    }
}