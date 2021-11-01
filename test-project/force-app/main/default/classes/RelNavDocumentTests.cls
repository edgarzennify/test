@isTest
private class RelNavDocumentTests{
     static testMethod void TestRelNavDocumentMethods_bruteforce1_Tests(){
        
        RelNavDocument testclass = new RelNavDocument();
        testclass.Name = 'My Account';
        testclass.ObjectType = 'Account';
        testclass.Application = '20';
        testClass.DocTypeName = 'Legal';
        testClass.DrawerName = 'Drawer';
        testClass.DocumentDate = RelNavDocument.defaultDate;
        testClass.CreatedDate = RelNavDocument.defaultDate;
        testClass.DocumentURL = 'http://www.google.com';
        testClass.Comment = 'Test';
        testClass.Key = '616-2121';
        testClass.RelationshipName = 'RelName';
        testClass.RecordRelationship = 'Record';
        testClass.Inactive = '1';
        
        
        RelNavDocument.RelNavDocumentFilter testInnerClass = new RelNavDocument.RelNavDocumentFilter();
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        testInnerClass.add('DocTypeName','<>','');
        testInnerClass.add('DocumentDate',d,d.addDays(-30));
        
        
        testInnerClass.addOr('DocumentDate',d,d.addDays(-30),'eDocumentDate',d,d.addDays(-30));
        testInnerClass.addConditionOR('DocumentDate','=',String.valueOf(d.addDays(-30)),'DocumentDate','=',String.valueOf(d.addDays(-30)));
        String d2 = testInnerClass.FormattedDateTime(d);
        
        Integer iapp = testclass.iApplication;
        iapp = testclass.iRecordRelationship;
        List<RelNavDocument> relnavs = RelNavDocument.LoadList('616-11223');
        relnavs = RelNavDocument.LoadList('616-11223', 'DocTypeName', 'ASC', 0, 0, testInnerClass);
        string s = RelNavDocument.ToCacheFieldName('');
        s = RelNavDocument.ToCacheFieldName('Key__c');
        s = RelNavDocument.ToCacheFieldName('Text0__c');
        s = RelNavDocument.ToCacheFieldName('Text1__c'); 
        s = RelNavDocument.ToCacheFieldName('Number0__c');
        s = RelNavDocument.ToCacheFieldName('Text2__c'); 
        s = RelNavDocument.ToCacheFieldName('Text3__c');
        s = RelNavDocument.ToCacheFieldName('DateTime0__c'); 
        s = RelNavDocument.ToCacheFieldName('Text4__c'); 
        s = RelNavDocument.ToCacheFieldName('Text5__c'); 
        s = RelNavDocument.ToCacheFieldName('Text6__c'); 
        s = RelNavDocument.ToCacheFieldName('Number1__c');
        s = RelNavDocument.ToCacheFieldName('Number2__c');
        s = RelNavDocument.ToCacheFieldName('Number3__c');
        RestUtility.Result TestList = RelNavDocument.TestList('616-4902');
        wsCacheItem__c  wc = testclass.ToCacheItem();
        RelNavDocument rnv = RelNavDocument.FromCacheItem(wc);
        List<RelNavDocument> RetrieveList = RelNavDocument.RetrieveList('616-4902');
        RetrieveList = RelNavDocument.RetrieveList('616-20-30475');
        RetrieveList = RelNavDocument.RetrieveList('gimme1001');
        
        
        RelNavDocument.SortParameter = 'Name';
        RetrieveList.sort();
        RelNavDocument.SortParameter = 'RelationshipName';
        RetrieveList.sort();
        RelNavDocument.SortParameter = 'Inactive';
        RetrieveList.sort();
        RelNavDocument.SortParameter = 'DocumentCount';
        RetrieveList.sort(); 
        
        testClass.compare(1, 2);
        testClass.compare('1', 'b');
        
        RelNavDocument.sortDirection='DESC';
        testClass.compare(1, 2);
        testClass.compare('1', 'b');
        
        TestList = RelNavDocument.TestList('616-4902');
        
        TestList = RelNavDocument.TestList('616-15-1700008219');
        
        TestList = RelNavDocument.TestList('gimme3001');
        TestList = RelNavDocument.TestList('gimme2501');
        TestList = RelNavDocument.TestList('gimme2001');        
    }
    
    static testMethod void TestRelNavDocumentMethods_bruteforce2_Tests(){
        RelNavDocument testRelNavDocument = new RelNavDocument();
        List<wsCacheItem__c> wsCacheList = RelNavDocument.ToCacheItems(new List<RelNavDocument>{testRelNavDocument});
        system.assertEquals(true, wsCacheList.size() > 0);
        
        String formatdate = RelNavDocument.FormatDate('1900-01-01 00:00:00.000');
        system.assertEquals(true, formatdate.contains('1900'));
    }
}