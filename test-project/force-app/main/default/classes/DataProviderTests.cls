@IsTest
private class DataProviderTests {
	
    private final static DataProvider sut;
    
    static {
        sut = new DataProvider();
    }
    
    @IsTest
    static void it_should_save_one_item() {
        Account a = new Account(Name = '1');
        
        sut.save(a);
        
        System.assertNotEquals(null, a.Id);
        System.assertEquals('1', a.Name);
    }
    
    @IsTest
    static void it_should_save_two_items() {
        Account a1 = new Account(Name = '1');
        Account a2 = new Account(Name = '2');
        List<Account> accounts = new List<Account>{a1,a2};
        
        sut.save(accounts);
        
        List<Account> requery = [SELECT Id FROM Account];
        System.assertEquals(2, requery.size()); 
        System.assertNotEquals(null, a1.Id);
        System.assertNotEquals(null, a2.Id);
    }
    
    @IsTest
    static void it_should_update_one_item() {
        Account a = new Account(Name = '1');
		insert a;
		a.Name = '11';        
        sut.save(a);
        
        System.assertNotEquals(null, a.Id);
        System.assertEquals('11', a.Name);
    }
    
    @IsTest
    static void it_should_update_two_items() {
        Account a1 = new Account(Name = '1');
        Account a2 = new Account(Name = '2');
        List<Account> accounts = new List<Account>{a1,a2};
        insert accounts;
        a1.Name = '11';
        a2.Name = '22';
        
        sut.save(accounts);
        
        List<Account> requery = [SELECT Id FROM Account];
        System.assertEquals(2, requery.size()); 
        System.assertNotEquals(null, a1.Id);
        System.assertNotEquals(null, a2.Id);
        System.assertEquals('11', a1.Name);
        System.assertEquals('22', a2.Name);
    }


    @IsTest
    static void it_should_remove_one_item() {
        Account a = new Account(Name='1');
        insert a;

        sut.remove(a);

        List<Account> requery = [SELECT Id FROM Account];
        System.assertEquals(0, requery.size());
    }

    @IsTest
    static void it_should_remove_two_item() {
        Account a1 = new Account(Name='1');
        insert a1;
        Account a2 = new Account(Name='2');
        insert a2;
        List<Account> accounts = new List<Account>{a1, a2};

        sut.remove(accounts);

        List<Account> requery = [SELECT Id FROM Account];
        System.assertEquals(0, requery.size());
    }

    @IsTest
    static void it_should_execute_dynamic_query_and_get_results() {
        Account a = new Account(Name='1');
        insert a;
        String identifier = String.ValueOf(a.Id );
        String query = 'SELECT Id, Name FROM Account WHERE Id = ' + '\'' + identifier + '\' ORDER BY Name';
        List<String> fieldNames = new List<String>{'Id', 'Name'};

        List<DataProvider.DynamicQueryResult> result =  sut.executeDynamicQuery(query, fieldNames);

        System.assertEquals(1, result.size());
        System.assertEquals('Id', (String)result[0].fieldValues[0].fieldName);
        System.assertEquals(identifier, (String)result[0].fieldValues[0].fieldValue);
    }

    @IsTest
    static void it_should_execute_dynamic_query_and_get_related_field() {
        Account a = new Account(Name='1');
        insert a;
        Contact c = new Contact(LastName=' lname ');
        c.AccountId = a.Id;
        insert c;
        String identifier = String.ValueOf(c.Id );
        String query = 'SELECT Id, Name, Account.Name FROM Contact WHERE Id = ' + '\'' + identifier + '\' ORDER BY Name';
        List<String> fieldNames = new List<String>{'Account.Name'};

        List<DataProvider.DynamicQueryResult> result =  sut.executeDynamicQuery(query, fieldNames);

        System.assertEquals(1, result.size());
        System.assertEquals('Account.Name', (String)result[0].fieldValues[0].fieldName);
        System.assertEquals('1', (String)result[0].fieldValues[0].fieldValue);
    }

    @IsTest
    static void it_should_insert_and_update_objects_without_errors() {
        Account a1 = new Account(Name = '1');
        insert a1;
        Account ua1 = [SELECT Id FROM Account WHERE Id =: a1.Id];
        Account a2 = new Account(Name = '2');

        List<SObject> sobjs = new List<SObject>{ua1, a2};

        List<String> results = sut.saveObjects(sobjs);

        System.assert(results.isEmpty());
    }
}