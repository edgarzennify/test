@IsTest
private class TmOpportunityConverterDmBuilderTests {

    private static  TmOpportunityConverter.IDmBuilder sut;

    static {
        sut = new TmOpportunityConverterDmBuilder(); 
    }

    private static testMethod void it_should_build_record_type() {
        RecordType r = new RecordType();
        r.Name = 'testName';

        DmRecordType result = sut.build(r);

        System.assertEquals('testName', result.Name);
    }

    private static testMethod void it_should_build_opportunity_type() {
        Account acc = new Account();
        acc.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        acc.Name = 'AccountName';

        RecordType r = new RecordType();
        r.Name = 'rname';

        RecordType entityRecordType = new RecordType();
        entityRecordType.Name = 'Client';
        acc.RecordType = entityRecordType;

        Opportunity opp = new Opportunity();
        opp.Id = ObjectFactory.getFakeId(Opportunity.SObjectType, '1');
        opp.Name = 'testName';
        opp.Products__c = 'obj1;obj3';
        opp.Product__c = 'ACH';
        opp.Potential_Deposits__c = null;
        opp.Potential_Fee_Income__c = 5.4;
        opp.Account = acc;
        opp.RecordType = r;

        DmOpportunity result = sut.build(opp);

        System.assertEquals(opp.Id, result.Id);
        System.assertEquals(opp.Name, result.Name);
        System.assertEquals(acc.Id, result.entity.id);
        System.assertEquals(acc.RecordType.Name, result.entity.recordType.name);
        System.assertEquals('AccountName', result.entity.name);
        System.assertEquals('rname', result.recordType.Name);
        System.assertEquals('obj1', result.BankProducts[0]);
        System.assertEquals('obj3', result.BankProducts[1]);
        System.assertEquals('ACH', result.BankProducts[2]);
        System.assertEquals(5.4, result.potentialFeeIncome);
        System.assertEquals(0.0, result.potentialDeposits);        
    }

    private static testMethod void it_should_build_packet() {
        String packetObjName = 'Tm_Service_Request_Packet__c';
        Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c();
        packet.Name = 'packetName';
        packet.Id = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '1');
        
        DmTmPacket result = sut.build(packet);

        System.assertEquals(packet.Id, result.Id);
        System.assertEquals('packetName', result.Name);
    }
}