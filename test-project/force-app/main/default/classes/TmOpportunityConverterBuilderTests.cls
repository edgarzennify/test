@isTest
private class TmOpportunityConverterBuilderTests {

    private static final TmOpportunityConverterBuilder sut;
    
    static {
        sut = new TmOpportunityConverterBuilder();
    }

    private static testMethod void it_should_get_opportunity_products() {
        String productName = 'ProductName';
        List<String> products = new List<String>{productName};

        TM_Service_Configuration__c serviceConfig = new TM_Service_Configuration__c();
        serviceConfig.Related_To_Opportunity_Products__c = 'relatedProduct';
        TmBoarding.RequestConfigPm rPm = new TmBoarding.RequestConfigPm();
        rPm.productPm = serviceConfig;
        Map<String, TmBoarding.RequestConfigPm> cfgMap = new  Map<String, TmBoarding.RequestConfigPm>();
        cfgMap.put(productName, rPm);

        Map<String, Set<String>> results = sut.getOpportunityProducts(products, cfgMap);

        Set<String> getProduct = results.get('ProductName');
        System.assert(results.containsKey('ProductName'));
        System.assert(getProduct.contains('relatedProduct'));
    }

    private static testMethod void it_should_get_opportunity_products_empty_opportunity_products() {
        String productName = 'ProductName';
        List<String> products = new List<String>{productName};

        TM_Service_Configuration__c serviceConfig = new TM_Service_Configuration__c();
        serviceConfig.Related_To_Opportunity_Products__c = '';
        TmBoarding.RequestConfigPm rPm = new TmBoarding.RequestConfigPm();
        rPm.productPm = serviceConfig;
        Map<String, TmBoarding.RequestConfigPm> cfgMap = new  Map<String, TmBoarding.RequestConfigPm>();
        cfgMap.put(productName, rPm);

        Map<String, Set<String>> results = sut.getOpportunityProducts(products, cfgMap);

        Set<String> getProduct = results.get('ProductName');
        System.assert(results.containsKey('ProductName'));
    }

    private static testMethod void it_should_get_updated_opportunity_and_return_null() {
        DmOpportunity opportunityDm = new DmOpportunity();
        Map<String,Set<String>> productMap = new Map<String,Set<String>>();
        List<string> selectedProducts = new List<string>();

        Opportunity results = sut.getUpdatedOpportunity(opportunityDm, productMap, selectedProducts);

        System.assert(results == null);
    }

    private static testMethod void it_should_get_updated_opportunity_and_return() {
        DmOpportunity opportunityDm = new DmOpportunity();
        Map<String,Set<String>> productMap = new Map<String,Set<String>>();

        List<string> selectedProducts = new List<String>{'fers'};

        opportunityDm.BankProducts = new List<String>{'wilkd'};
        opportunityDm.Id = ObjectFactory.getFakeId(Opportunity.SObjectType, '1');

        Set<String> products = new Set<String>();
        products.add('wilkd');
        productMap.put('wilkd', products);


        Opportunity results = sut.getUpdatedOpportunity(opportunityDm, productMap, selectedProducts);
        
        System.assertEquals(opportunityDm.Id, results.Id);
        System.assertEquals('wilkd', results.Products__c);
    }

    private static testMethod void it_should_get_updated_opportunity_and_gets_items_to_update() {
        DmOpportunity opportunityDm = new DmOpportunity();
        Map<String,Set<String>> productMap = new Map<String,Set<String>>();

        List<string> selectedProducts = new List<String>{'fers'};

        opportunityDm.BankProducts = new List<String>{'wikd'};
        opportunityDm.Id = ObjectFactory.getFakeId(Opportunity.SObjectType, '1');

        Set<String> products = new Set<String>();
        products.add('any');
        productMap.put('fers', products);


        Opportunity results = sut.getUpdatedOpportunity(opportunityDm, productMap, selectedProducts);
        
        System.assertEquals(opportunityDm.Id, results.Id);
        System.assertEquals('wikd;any', results.Products__c);
    }

}