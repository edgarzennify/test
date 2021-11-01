@IsTest
private class TMPacketStageCalculatorTests {

    private static final TMPacketStageCalculator sut;
    private static final MockOfIDataProvider mockDataProvider;
    private static final MockOfITMPacketStageCalculatorHelper mockHelper;

    static {
        mockDataProvider = new MockOfIDataProvider();
        mockHelper = new MockOfITMPacketStageCalculatorHelper();
        sut = new TMPacketStageCalculator(mockHelper, mockDataProvider);
    }

    @IsTest
    static void it_should_call_getAllRequests_on_the_data_provider_once() {
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
        List<Id> parentIds = new List<Id>{packetId01,packetId02};
        List<TM_Service_Request_Packet__c> packetList = new List<TM_Service_Request_Packet__c>{packet01,packet02};
        
        Map<Id, List<TM_Service_Request__c>> packetRequestMap = new Map<Id, List<TM_Service_Request__c>>();
        packetRequestMap.put(packetId01, reqList01);
        packetRequestMap.put(packetId02, reqList02);
        
        Map<Id, String> packetStageMap = new Map<Id, String>();
        packetStageMap.put(packetId01, 'New');
        packetStageMap.put(packetId02, 'Ops Product Setup');

        mockHelper.setup('buildParentIdsList', new List<Object>{requests}).returns(parentIds);
        mockDataProvider.setup('getAllRequests', new List<Object>{parentIds}).returns(requests);
        mockHelper.setup('buildPacketList', new List<Object>{requests}).returns(packetList);
        mockHelper.setup('buildPacketRequestMap', new List<Object>{requests}).returns(packetRequestMap);
        //act
        sut.calculate(requests);
        //assert
        mockDataProvider.verify('getAllRequests', new List<Object>{parentIds}, Times.Once);
    }

    @IsTest
    static void it_should_call_buildUpdatedPacketList_on_the_helper_with_the_correct_args() {
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
        List<Id> parentIds = new List<Id>{packetId01,packetId02};
        List<TM_Service_Request_Packet__c> packetList = new List<TM_Service_Request_Packet__c>{packet01,packet02};
        
        Map<Id, List<TM_Service_Request__c>> packetRequestMap = new Map<Id, List<TM_Service_Request__c>>();
        packetRequestMap.put(packetId01, reqList01);
        packetRequestMap.put(packetId02, reqList02);
        
        Map<Id, String> packetStageMap = new Map<Id, String>();
        packetStageMap.put(packetId01, 'New');
        packetStageMap.put(packetId02, 'Ops Product Setup');

        mockHelper.setup('buildParentIdsList', new List<Object>{requests}).returns(parentIds);
        mockDataProvider.setup('getAllRequests', new List<Object>{parentIds}).returns(requests);
        mockHelper.setup('buildPacketList', new List<Object>{requests}).returns(packetList);
        mockHelper.setup('buildPacketRequestMap', new List<Object>{requests}).returns(packetRequestMap);
        //act
        sut.calculate(requests);
        //assert
        mockHelper.verify('buildUpdatedPacketList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);

        List<Object> arguments = mockHelper.getArgumentsFromCall('buildUpdatedPacketList');
        Map<Id, String> calledPacketStageMap = (Map<Id, String>)arguments[0];
        List<TM_Service_Request_Packet__c> calledPacketList = (List<TM_Service_Request_Packet__c>)arguments[1];

        System.assertEquals(2, arguments.size());
        System.assertEquals(packetList, calledPacketList);
        System.assertEquals(2, calledPacketStageMap.keySet().size());
        System.assertEquals(true, calledPacketStageMap.containsKey(packetId01));
        System.assertEquals(true, calledPacketStageMap.containsKey(packetId02));
    }

    @IsTest
    static void it_should_return_a_list_of_updated_tm_packets() {
        Id packetId01 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        TM_Service_Request_Packet__c packet01 = new TM_Service_Request_Packet__c();
        packet01.Id = packetId01;
        packet01.Name = 'test name 1';
        packet01.Stage__c = 'New';

        Id requestId01 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c request01 = new TM_Service_Request__c();
        request01.Id = requestId01;
        request01.TM_Service_Request_Packet__r = packet01;
        Id requestId02 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '2');
        TM_Service_Request__c request02 = new TM_Service_Request__c();
        request02.Id = requestId02;
        request02.TM_Service_Request_Packet__r = packet01;
        
        List<TM_Service_Request__c> reqList01 = new List<TM_Service_Request__c>{request01,request02};
        List<Id> parentIds = new List<Id>{packetId01};
        List<TM_Service_Request_Packet__c> packetList = new List<TM_Service_Request_Packet__c>{packet01};

        Map<Id, List<TM_Service_Request__c>> packetRequestMap = new Map<Id, List<TM_Service_Request__c>>();
        packetRequestMap.put(packetId01, reqList01);
        
        Map<Id, String> packetStageMap = new Map<Id, String>();
        packetStageMap.put(packetId01, 'New');

        mockHelper.setup('buildParentIdsList', new List<Object>{reqList01}).returns(parentIds);
        mockDataProvider.setup('getAllRequests', new List<Object>{parentIds}).returns(reqList01);
        mockHelper.setup('buildPacketList', new List<Object>{reqList01}).returns(packetList);
        mockHelper.setup('buildPacketRequestMap', new List<Object>{reqList01}).returns(packetRequestMap);
        mockHelper.setup('buildUpdatedPacketList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(packetList);
        //act
        List<TM_Service_Request_Packet__c> results = sut.calculate(reqList01);
        //assert
        System.assertEquals(packetList, results);
    }

    public class MockOfIDataProvider extends ApexMoq implements TMPacketStageCalculator.ITMPacketStageCalculatorDataProvider {
        public List<Tm_Service_Request__c> getAllRequests(List<Id> parentIds) {
            return (List<Tm_Service_Request__c>)handleMethodInvocation('getAllRequests', new List<Object>{parentIds});
        }
    }

    public class MockOfITMPacketStageCalculatorHelper extends ApexMoq implements TMPacketStageCalculator.ITMPacketStageCalculatorHelper {
        public List<Id> buildParentIdsList(List<TM_Service_Request__c> requests) {
            return (List<Id>)handleMethodInvocation('buildParentIdsList', new List<Object>{requests});
        }
        public Map<Id, List<TM_Service_Request__c>> buildPacketRequestMap(List<TM_Service_Request__c> requests) {
            return (Map<Id, List<TM_Service_Request__c>>)handleMethodInvocation('buildPacketRequestMap', new List<Object>{requests});
        }
        public Set<String> getPacketState(List<TM_Service_Request__c> requests) {
            return (Set<String>)handleMethodInvocation('getPacketState', new List<Object>{requests});
        }
        public List<Tm_Service_Request_Packet__c> buildPacketList(List<TM_Service_Request__c> requests) {
            return (List<Tm_Service_Request_Packet__c>)handleMethodInvocation('buildPacketList', new List<Object>{requests});
        }
        public String getStatus(Set<String> packetSet) {
            return (String)handleMethodInvocation('getStatus', new List<Object>{packetSet});
        }
        public List<TM_Service_Request_Packet__c> buildUpdatedPacketList(Map<Id, String> packetStageMap, List<TM_Service_Request_Packet__c> packetList) {
            return (List<TM_Service_Request_Packet__c>)handleMethodInvocation('buildUpdatedPacketList', new List<Object>{packetStageMap, packetList});
        }
    }
}