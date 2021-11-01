@IsTest
public class CPDocsNcinoDataProviderTests {

    private static CPDocsNcinoDataProvider sut;

    static{
        sut = new CPDocsNcinoDataProvider();
    }

    @IsTest 
    private static void it_should_get_legal_entities_when_entityId_was_provided_incomplete_test_needs_insert_record(){
        String entityId = ObjectFactory.getFakeId(LLC_BI__Legal_Entities__c.SObjectType, '1');

        List<PM_LLCBI_Legal_Entities_c> result = sut.getLegalEntities(entityId);

        //Object fieldObj = result[0].LLCBI_Tax_ID_c;
    }
    
}