@isTest
private class TmOpportunityConverterVmBuilderTests {


    private static TmOpportunityConverterVmBuilder sut;
    private static Mock.ofIUtility mockUtil;

    static {
        mockUtil = new Mock.ofIUtility();
        sut = new TmOpportunityConverterVmBuilder(mockUtil);
    }

    private static testMethod void it_should_build_the_opportunity_vm() { 
        String url = 'http://www.test.salesforce.com';
        String objectName = 'TM_Service_Request_Packet__c';
        String packetBundleTypePickListName = 'Bundle_Type__c';
        String packetClientTypePickListName = 'Client_Type__c';
        String entityRecordTypeId = 'ssdsdsd';
        String entityRecordTypeName = 'Client';
        DmEntity entity = new DmEntity();
        entity.Id = 'tersdf';
        entity.Name = 'entityName';
        DmRecordType entityRecordtype = new DmRecordType();
        entityRecordtype.id = entityRecordTypeId;
        entityRecordtype.Name = entityRecordTypeName;
        entity.recordType = entityRecordtype;

        DmOpportunity opp = new DmOpportunity();
        opp.Id = 'asdfwer';
        opp.Name = 'oppName';
        opp.potentialFeeIncome = 5.6;
        opp.potentialDeposits = 6.5;
        opp.BankProducts = new List<String>{'bankone-do'};
        opp.Entity = entity;

        DmRecordType product = new DmRecordType();
        product.Id = 'bankoneId';
        product.Name = 'bankone';
        List<DmRecordType> products = new List<DmRecordType>{product};

        Map<String, Set<String>> productMapping = new Map<String, Set<String>>();
        Set<String> setList= new Set<String>();
        setList.add('bankone-do');        
        productMapping.put('bankone', setList);

        DmTmPacket packetOne = new DmTmPacket();
        packetOne.Id = 'packetOneId';
        packetOne.Name = 'packetOneName';
        List<DmTmPacket> packets = new List<DmTmPacket>{packetOne};

        List<SelectOption> bundleTypeOptions = new List<SelectOption>{new SelectOption('test1', 'test1')};
        List<SelectOption> clientTypeOptions = new List<SelectOption>{new SelectOption('test2', 'test2')};
        mockUtil.setup('ListValuesFromObject', new List<Object>{objectName, packetBundleTypePickListName}).returns(bundleTypeOptions);
        mockUtil.setup('ListValuesFromObject', new List<Object>{objectName, packetClientTypePickListName}).returns(clientTypeOptions);
        mockUtil.setup('getServerUrl').returns(url);

        TmOpportunityConverter.OpportunityDetails results = sut.buildOpportunityVm(opp, packets, products, productMapping);

        System.assertEquals(12.1, results.PotentialIncome);
        System.assertEquals('oppName', results.OpportunityName);
        System.assertEquals('asdfwer', results.OpportunityId);
        System.assertEquals('tersdf', results.EntityDetail.Identifier);
        System.assertEquals('entityName', results.EntityDetail.Name);
        System.assertEquals(entityRecordTypeId, results.EntityRecordType.Identifier);
        System.assertEquals(entityRecordTypeName, results.EntityRecordType.Name);
        System.assertEquals('bankoneId', results.BankProducts[0].Identifier);
        System.assertEquals('bankone', results.BankProducts[0].Name);
        System.assertEquals('packetOneId', results.ExistingPacketDetails[0].Identifier);
        System.assertEquals('packetOneName', results.ExistingPacketDetails[0].Name);
        System.assertEquals('bankone', results.SelectedBankProducts[0].Name);
        System.assertEquals('bankone-do', results.BankProducts[0].SubProducts[0]);
        System.assertEquals('bankone-do', results.SelectedBankProducts[0].SubProducts[0]);
        System.assertEquals('test1', results.BundleTypes[0]);
        System.assertEquals('test2', results.ClientTypes[0]);
        System.assertEquals(url, results.ServerUrl);
    }

}