@IsTest
private class PricingWkstComponentDepositsTests {
    
    private final static Mock.ofIApexPages mockApexPages;
    private final static Mock.ofIPricingWkstDataProv mockDataProvider;
    private final static Pricing_Worksheet__c wkst;
    private final static PricingWkstComponentDeposits sut;

    static {
        wkst = new Pricing_Worksheet__c(Id=ObjectFactory.getFakeId(Pricing_Worksheet__c.SObjectType, '1'));
        mockDataProvider = new Mock.ofIPricingWkstDataProv();
        sut = new PricingWkstComponentDeposits(mockApexPages, mockDataProvider);
        sut.currentWorksheet = wkst;
    }

    @IsTest
    static void it_should_call_the_default_constructor_without_error() {
        PricingWkstComponentDeposits sutDef = new PricingWkstComponentDeposits();
    }

    @IsTest
    static void it_should_set_popup_data_to_one_new_item_and_show_popup_for_add() {
        sut.popupData = new List<Pricing_Proposed_Deposit__c>{new Pricing_Proposed_Deposit__c(), new Pricing_Proposed_Deposit__c()};

        sut.showAddPopup();

        System.assertEquals(1, sut.popupData.size());
        System.assertEquals(null, sut.popupData[0].Id);
        System.assertEquals(wkst.Id, sut.popupData[0].Pricing_Worksheet__c);
        System.assertEquals(true, sut.popupDisplayed);
        System.assertEquals('add', sut.popupType);
    }

    @IsTest
    static void it_should_add_a_new_item_to_popup_data_list() {
        sut.popupData = new List<Pricing_Proposed_Deposit__c>{new Pricing_Proposed_Deposit__c(), new Pricing_Proposed_Deposit__c()};

        sut.createNewItem();

        System.assertEquals(3, sut.popupData.size());
        System.assertEquals(null, sut.popupData[2].Id);
        System.assertEquals(wkst.Id, sut.popupData[2].Pricing_Worksheet__c);
    }

    @IsTest
    static void it_should_make_call_to_add_new_items_and_refresh_page() {
        Pricing_Proposed_Deposit__c item1 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '1'));
        Pricing_Proposed_Deposit__c item2 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '2'));
        List<Pricing_Proposed_Deposit__c> items = new List<Pricing_Proposed_Deposit__c>{item1, item2};
        sut.popupData = items;

        PageReference returnedURL = sut.addNewItems();

        mockDataProvider.verify('addPricingProposedDeposits', new List<Object>{items}, Times.Once);
        System.assertEquals('/apex/pricingwkst?id='+wkst.Id, returnedURL.getUrl());
    }

    @IsTest
    static void it_should_return_the_details_from_the_pricing_results_object() {
        Pricing_Proposed_Deposit__c item1 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '1'));
        item1.Average_Balance__c = 15;
        PricingWkst.ProposedDepositPricingResponse response1 = new PricingWkst.ProposedDepositPricingResponse();
        response1.capitalRequirements = 3;
        response1.income = 4;
        PricingWkst.ProposedDepositsDisplay result1 = new PricingWkst.ProposedDepositsDisplay(item1, response1);
        Pricing_Proposed_Deposit__c item2 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '2'));
        item2.Average_Balance__c = 5;
        PricingWkst.ProposedDepositPricingResponse response2 = new PricingWkst.ProposedDepositPricingResponse();
        response2.capitalRequirements = 6;
        PricingWkst.ProposedDepositsDisplay result2 = new PricingWkst.ProposedDepositsDisplay(item2, response2);
        PricingWkstResults pricResults = new PricingWkstResults();
        pricResults.proposedDepositPricingDetails = new List<PricingWkst.ProposedDepositsDisplay>{result1, result2};
        sut.pricingResults = pricResults;

        System.assertEquals(2, sut.existingItems.size());
        System.assertEquals(item1.Id, sut.existingItems[0].proposedDeposit.Id);
        System.assertEquals(20, sut.avgBalTotal);
        System.assertEquals(9, sut.capitalTotal);
        System.assertEquals(4, sut.incomeTotal);
    }

    @IsTest
    static void it_should_set_popup_data_to_selected_item_and_show_popup_for_update() {
        sut.popupData = new List<Pricing_Proposed_Deposit__c>{new Pricing_Proposed_Deposit__c(), new Pricing_Proposed_Deposit__c()};
        Pricing_Proposed_Deposit__c item1 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '1'));
        sut.selectedId = item1.Id;
        mockDataProvider.setup('getPricingProposedDeposit', new List<Object>{item1.Id}).returns(item1);

        sut.showUpdatePopupForSingleItem();

        mockDataProvider.verify('getPricingProposedDeposit', new List<Object>{item1.Id}, Times.Once);
        System.assertEquals(1, sut.popupData.size());
        System.assertEquals(item1.Id, sut.popupData[0].Id);
        System.assertEquals(true, sut.popupDisplayed);
        System.assertEquals('update', sut.popupType);
    }
    
    @IsTest
    static void it_should_set_popup_data_to_all_items_and_show_popup_for_update() {
        Pricing_Proposed_Deposit__c item1 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '1'));
        Pricing_Proposed_Deposit__c item2 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '2'));
        Map<Id, Pricing_Proposed_Deposit__c> items = new Map<Id, Pricing_Proposed_Deposit__c>{item1.Id => item1, item2.Id => item2};
        sut.pricingRequest = new PricingWkstRequest();
        sut.pricingRequest.proposedDeposits = items;
            
        sut.showUpdatePopupForAllItems();

        System.assertEquals(2, sut.popupData.size());
        System.assertEquals(true, sut.popupDisplayed);
        System.assertEquals('update', sut.popupType);
    }

    @IsTest
    static void it_should_make_call_to_update_items_and_refresh_page() {
        Pricing_Proposed_Deposit__c item1 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '1'));
        Pricing_Proposed_Deposit__c item2 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '2'));
        List<Pricing_Proposed_Deposit__c> items = new List<Pricing_Proposed_Deposit__c>{item1, item2};
        sut.popupData = items;

        PageReference returnedURL = sut.updateItems();

        mockDataProvider.verify('updatePricingProposedDeposits', new List<Object>{items}, Times.Once);
        System.assertEquals('/apex/pricingwkst?id='+wkst.Id, returnedURL.getUrl());
    }

    @IsTest
    static void it_should_set_popup_data_to_selected_item_and_show_popup_for_deletesingle() {
        sut.popupData = new List<Pricing_Proposed_Deposit__c>{new Pricing_Proposed_Deposit__c(), new Pricing_Proposed_Deposit__c()};
        Pricing_Proposed_Deposit__c item1 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '1'));
        sut.selectedId = item1.Id;
        mockDataProvider.setup('getPricingProposedDeposit', new List<Object>{item1.Id}).returns(item1);

        sut.showDeletePopupForSingleItem();

        mockDataProvider.verify('getPricingProposedDeposit', new List<Object>{item1.Id}, Times.Once);
        System.assertEquals(1, sut.popupData.size());
        System.assertEquals(item1.Id, sut.popupData[0].Id);
        System.assertEquals(true, sut.popupDisplayed);
        System.assertEquals('deletesingle', sut.popupType);
    }

    @IsTest
    static void it_should_set_popup_data_to_all_items_and_show_popup_for_deleteall() {
        Pricing_Proposed_Deposit__c item1 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '1'));
        Pricing_Proposed_Deposit__c item2 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '2'));
        Map<Id, Pricing_Proposed_Deposit__c> items = new Map<Id, Pricing_Proposed_Deposit__c>{item1.Id => item1, item2.Id => item2};
        sut.pricingRequest = new PricingWkstRequest();
        sut.pricingRequest.proposedDeposits = items;
            
        sut.showDeletePopupForAllItems();

        System.assertEquals(2, sut.popupData.size());
        System.assertEquals(true, sut.popupDisplayed);
        System.assertEquals('deleteall', sut.popupType);
    }

    @IsTest
    static void it_should_make_call_to_delete_items_and_refresh_page() {
        Pricing_Proposed_Deposit__c item1 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '1'));
        Pricing_Proposed_Deposit__c item2 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '2'));
        List<Pricing_Proposed_Deposit__c> items = new List<Pricing_Proposed_Deposit__c>{item1, item2};
        sut.popupData = items;

        PageReference returnedURL = sut.deleteItems();

        mockDataProvider.verify('deletePricingProposedDeposits', new List<Object>{items}, Times.Once);
        System.assertEquals('/apex/pricingwkst?id='+wkst.Id, returnedURL.getUrl());
    }

    @IsTest
    static void it_should_set_popupDisplayed_to_false() {
        sut.popupDisplayed = true;

        sut.hidePopup();

        System.assertEquals(false, sut.popupDisplayed);
    }
}