@IsTest
public class ObjectForwardDataProviderTests {

    private static ObjectForwardDataProvider sut;
    private static final MockOfIDmBuilder mockDmBuilder;
    
    static {
        mockDmBuilder = new MockOfIDmBuilder();
        sut = new ObjectForwardDataProvider(mockDmBuilder);
    }
    
    @IsTest
    static void it_should_call_the_dm_builder_to_get_dm_forwards() {
        String origObjName = 'EB_Account__c'; 
        String origObjRecordTypeName = 'Loan';
        List<ObjectForward.DmForward> dmForwards = new List<ObjectForward.DmForward>();

        mockDmBuilder.setup('buildDmForwards', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(dmForwards);
        
        List<ObjectForward.DmForward> result = sut.getForwards(origObjName, origObjRecordTypeName);
            
        mockDmBuilder.verify('buildDmForwards', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_query_one_record_dynamically() {
        Account t = new Account(Name='test entity');
        insert t;
        String dsoql = 'SELECT Id, Name FROM Account WHERE Id=\'' + t.Id + '\'';
        
        Account result = (Account)sut.queryOne(dsoql);
            
        System.assertEquals(t.Name, result.Name);
        System.assertEquals(t.Id, result.Id);
    }

    @IsTest
    static void it_should_query_multiple_records_dynamically() {
        Account t1 = new Account(Name='test entity 1');
        Account t2 = new Account(Name='test entity 2');
        insert new List<SObject>{t1, t2};
        String dsoql = 'SELECT Id, Name FROM Account';
        
        List<Account> result = (List<Account>)sut.query(dsoql);
            
        System.assertEquals(2, result.size());
        System.assertEquals(t1.Name, result[0].Name);
        System.assertEquals(t1.Id, result[0].Id);
        System.assertEquals(t2.Name, result[1].Name);
        System.assertEquals(t2.Id, result[1].Id);
    }
    
    public class MockOfIDmBuilder extends ApexMoq implements ObjectForward.IDmBuilder {
        public List<ObjectForward.DmForward> buildDmForwards(List<Object_Forward__mdt> objForwards){
            return (List<ObjectForward.DmForward>)handleMethodInvocation('buildDmForwards', new List<Object>{objForwards});
        }
    }   
}