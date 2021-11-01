@IsTest
private class DrawerPrivilegeTests{
    static testMethod void it_should_be_able_to_get_key_for_email(){
        String key = DrawerPrivilege.GetKey('test@enterprisebank.com');
        system.assert(key.contains('test@enterprisebank.com'));
    }
    static testMethod void it_should_return_a_DocumentPrivilege_type(){
        DrawerPrivilege dp = new DrawerPrivilege();
        Type t = dp.classType();
        system.assert(t == DrawerPrivilege.Class);
    }
    static testMethod void it_should_be_able_to_get_an_item_from_cache(){
        DrawerPrivilege dp = new DrawerPrivilege();
        Documents.ICacheable cacheitem = dp.FromCacheItem(new wsCacheItem__c(key__c = 'testkey'));
        system.assert(cacheitem.classtype() == DrawerPrivilege.class);
    }
    static testMethod void it_should_be_able_to_get_field_name_for_variable(){
         DrawerPrivilege dp = new DrawerPrivilege();
         String emailreturned = dp.ToCacheFieldName('Email');
         system.assert(emailreturned == 'Text0__c');
         String drawerreturned = dp.ToCacheFieldName('DrawerName');
         system.assert(drawerreturned == 'Text1__c');
         String emptyreturned = dp.ToCacheFieldName('test');
         system.assert(emptyreturned == '');
    }
    
    
}