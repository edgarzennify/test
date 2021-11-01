@isTest
public class TMPacketStageCalculatorHelperTests {
    private static final TMPacketStageCalculatorHelper sut;
    private static final Mock.ofISystem mockSystem;

    static{
        mockSystem = new Mock.ofISystem();
        sut = new TMPacketStageCalculatorHelper(mockSystem);
    }

    @isTest
    static void it_should_return_a_list_of_ids(){
        Id packetId01 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        TM_Service_Request_Packet__c packet01 = new TM_Service_Request_Packet__c();
        packet01.Id = packetId01;
        packet01.Name = 'test name 1';
        Id packetId02 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '2');
        TM_Service_Request_Packet__c packet02 = new TM_Service_Request_Packet__c();
        packet02.Id = packetId02;
        packet02.Name = 'test name 2';

        Id requestId01 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c request01 = new TM_Service_Request__c(Id = requestId01, TM_Service_Request_Packet__c = packetId01);
        Id requestId02 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '2');
        TM_Service_Request__c request02 = new TM_Service_Request__c(Id = requestId02, TM_Service_Request_Packet__c = packetId02);

        List<TM_Service_Request__c> requests = new List<TM_Service_Request__c>{request01,request02};
        List<Id> expectedResults = new List<Id>{packetId01,packetId02};
        //act
        List<Id> results = sut.buildParentIdsList(requests);
        //assert
        System.assertEquals(expectedResults, results);
    }

    @isTest
    static void it_should_return_a_map_of_id_and_list_of_requests(){
        Id packetId01 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        TM_Service_Request_Packet__c packet01 = new TM_Service_Request_Packet__c();
        packet01.Id = packetId01;
        packet01.Name = 'test name 1';
        Id packetId02 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '2');
        TM_Service_Request_Packet__c packet02 = new TM_Service_Request_Packet__c();
        packet02.Id = packetId02;
        packet02.Name = 'test name 2';

        Id requestId01 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c request01 = new TM_Service_Request__c();
        request01.Id = requestId01;
        request01.TM_Service_Request_Packet__r = packet01;
        Id requestId02 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '2');
        TM_Service_Request__c request02 = new TM_Service_Request__c();
        request02.Id = requestId02;
        request02.TM_Service_Request_Packet__r = packet01;
        Id requestId03 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '3');
        TM_Service_Request__c request03 = new TM_Service_Request__c();
        request03.Id = requestId03;
        request03.TM_Service_Request_Packet__r = packet02;
        Id requestId04 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '4');
        TM_Service_Request__c request04 = new TM_Service_Request__c();
        request04.Id = requestId04;
        request04.TM_Service_Request_Packet__r = packet02;
        
        List<TM_Service_Request__c> reqList01 = new List<TM_Service_Request__c>{request01,request02};
        List<TM_Service_Request__c> reqList02 = new List<TM_Service_Request__c>{request03,request04};
        List<TM_Service_Request__c> requests = new List<TM_Service_Request__c>{request01,request02,request03,request04};
        
        Map<Id, List<TM_Service_Request__c>> expectedMap = new Map<Id, List<TM_Service_Request__c>>();
        expectedMap.put(packetId01, reqList01);
        expectedMap.put(packetId02, reqList02);
        //act
        Map<Id, List<TM_Service_Request__c>> results = sut.buildPacketRequestMap(requests);
        //assert
        System.assertEquals(expectedMap, results);
    }

    @isTest
    static void it_should_return_a_set_of_strings(){
        Id newStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        TM_Service_Request_Stage__c newStage = new TM_Service_Request_Stage__c();
        newStage.Name = 'New';
        Id docStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '2');
        TM_Service_Request_Stage__c docStage = new TM_Service_Request_Stage__c();
        docStage.Name = 'Documentation Cycle';

        Id req01Id = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c req01 = new TM_Service_Request__c();
        req01.Id = req01Id;
        req01.Stage__r = newStage;
        Id req02Id = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '2');
        TM_Service_Request__c req02 = new TM_Service_Request__c();
        req02.Id = req02Id;
        req02.Stage__r = docStage;

        List<TM_Service_Request__c> requests = new List<TM_Service_Request__c>{req01,req02};
        Set<String> expectedResults = new Set<String>{'New','Documentation Cycle'};
        //act
        Set<String> results = sut.getPacketState(requests);
        //assert
        System.assertEquals(expectedResults, results);
    }

    @isTest
    static void it_should_return_a_list_of_tm_packets(){
        Id packetId01 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        TM_Service_Request_Packet__c packet01 = new TM_Service_Request_Packet__c();
        packet01.Id = packetId01;
        packet01.Name = 'test name 1';
        packet01.Stage__c = 'Documentation';
        Id packetId02 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '2');
        TM_Service_Request_Packet__c packet02 = new TM_Service_Request_Packet__c();
        packet02.Id = packetId02;
        packet02.Name = 'test name 2';
        packet02.Stage__c = 'Ops Product Setup';

        Id requestId01 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c request01 = new TM_Service_Request__c();
        request01.Id = requestId01;
        request01.TM_Service_Request_Packet__r = packet01;
        Id requestId02 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '2');
        TM_Service_Request__c request02 = new TM_Service_Request__c();
        request02.Id = requestId02;
        request02.TM_Service_Request_Packet__r = packet01;
        Id requestId03 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '3');
        TM_Service_Request__c request03 = new TM_Service_Request__c();
        request03.Id = requestId03;
        request03.TM_Service_Request_Packet__r = packet02;
        Id requestId04 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '4');
        TM_Service_Request__c request04 = new TM_Service_Request__c();
        request04.Id = requestId04;
        request04.TM_Service_Request_Packet__r = packet02;

        List<TM_Service_Request__c> requests = new List<TM_Service_Request__c>{request01,request02,request03,request04};
        List<TM_Service_Request_Packet__c> expectedPackets = new List<TM_Service_Request_Packet__c>{packet01,packet02};        
        //act
        List<TM_Service_Request_Packet__c> results = sut.buildPacketList(requests);
        //assert
        System.assertEquals(expectedPackets, results);
        System.assertEquals('Documentation', results[0].Stage__c);
        System.assertEquals('Ops Product Setup', results[1].Stage__c);
    }

    @isTest
    static void it_should_return_the_given_packets_with_updated_stages(){
        Id packetId01 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        TM_Service_Request_Packet__c packet01 = new TM_Service_Request_Packet__c();
        packet01.Id = packetId01;
        packet01.Stage__c = 'test stage 1';
        Id packetId02 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '2');
        TM_Service_Request_Packet__c packet02 = new TM_Service_Request_Packet__c();
        packet02.Id = packetId02;
        packet02.Stage__c = 'test stage 2';

        List<TM_Service_Request_Packet__c> packetList = new List<TM_Service_Request_Packet__c>{packet01,packet02};

        Map<Id, String> packetStageMap = new Map<Id, String>();
        packetStageMap.put(packetId01, 'New');
        packetStageMap.put(packetId02, 'Ops Product Setup');
        //act
        List<TM_Service_Request_Packet__c> results = sut.buildUpdatedPacketList(packetStageMap, packetList);
        //assert
        System.assertEquals('New', results[0].Stage__C);
        System.assertEquals('Ops Product Setup', results[1].Stage__C);
    }

    @isTest
    static void it_should_timestamp_the_date_only_when_then_packet_stage_is_updated(){
        Id packetId01 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        TM_Service_Request_Packet__c packet01 = new TM_Service_Request_Packet__c();
        packet01.Id = packetId01;
        packet01.Stage__c = 'Documentation';
        packet01.Last_Stage_Change_Date__c = null;
        Id packetId02 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '2');
        TM_Service_Request_Packet__c packet02 = new TM_Service_Request_Packet__c();
        packet02.Id = packetId02;
        packet02.Stage__c = 'Documentation';
        packet02.Last_Stage_Change_Date__c = null;

        List<TM_Service_Request_Packet__c> packetList = new List<TM_Service_Request_Packet__c>{packet01,packet02};

        Map<Id, String> packetStageMap = new Map<Id, String>();
        packetStageMap.put(packetId01, 'Documentation');
        packetStageMap.put(packetId02, 'Ops Product Setup');

        dateTime now = dateTime.newInstance(2000,9,1);
        mockSystem.setup('now').returns(now);
        //act
        List<TM_Service_Request_Packet__c> results = sut.buildUpdatedPacketList(packetStageMap, packetList);
        //assert
        System.assertEquals(1, results.size());
        System.assertEquals('Ops Product Setup', results[0].Stage__c);
        System.assertEquals(now, results[0].Last_Stage_Change_Date__c);
    }
///////////////
    @isTest
    static void it_should_return_the_correct_stage_scenario_01(){
        Set<String> givenSet = buildGivenSet(new List<String>{'New','Ops Review'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Documentation';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_02(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Documentation Cycle','Ops Review'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Documentation';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_03(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Out For Signature','Ops Review'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Documentation';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_04(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Signature Complete','Ops Review'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Documentation';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_05(){
        Set<String> givenSet = buildGivenSet(new List<String>{'New','Awaiting Client Response'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Documentation';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_06(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Awaiting Test Files','Ops Product Setup'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Pending';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_07(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Awaiting Client Response','Ops Product Setup'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Pending';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_08(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Awaiting Approval','Ops Product Setup'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Pending';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_09(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Awaiting Analysis','Ops Product Setup'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Pending';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_10(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Awaiting Live Date','Complete'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Pending';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_11(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Ops Product Setup','Withdrawn'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Ops Product Setup';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_12(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Awaiting Live Date','Ops Product Setup','Withdrawn'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Pending';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_13(){
        Set<String> givenSet = buildGivenSet(new List<String>{'New','New'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Documentation';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_14(){
        Set<String> givenSet = buildGivenSet('Ops Review');
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Ops Review';
        System.assertEquals(expectedResult, result);
    }
    
    @isTest
    static void it_should_return_the_correct_stage_scenario_15(){
        Set<String> givenSet = buildGivenSet('Ops Product Setup');
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Ops Product Setup';
        System.assertEquals(expectedResult, result);
    }
    
    @isTest
    static void it_should_return_the_correct_stage_scenario_16(){
        Set<String> givenSet = buildGivenSet('Awaiting Analysis');
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Awaiting Analysis';
        System.assertEquals(expectedResult, result);
    }

    @isTest        
    static void it_should_return_the_correct_stage_scenario_17(){
        Set<String> givenSet = buildGivenSet('Complete');
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Archived';
        System.assertEquals(expectedResult, result);
    }
    
    @isTest
    static void it_should_return_the_correct_stage_scenario_18(){
        Set<String> givenSet = buildGivenSet('Withdrawn');
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Withdrawn';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_19(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Ops Review','Ops Review'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Ops Review';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_20(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Documentation Cycle','Out For Signature'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Documentation';
        System.assertEquals(expectedResult, result);
    }

    @isTest
    static void it_should_return_the_correct_stage_scenario_21(){
        Set<String> givenSet = buildGivenSet(new List<String>{'Out For Signature','Ops Review', 'Documentation Cycle'});
        //act
        String result = sut.getStatus(givenSet);
        //assert
        String expectedResult = 'Documentation';
        System.assertEquals(expectedResult, result);
    }
///////////////////////////
    private static Set<String> buildGivenSet(String s1){
        return buildGivenSet(new List<String>{s1});
    }
    
    private static Set<String> buildGivenSet(List<String> strings){
        return new Set<String>(strings);        
    }
}