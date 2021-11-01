@IsTest
private class PricingWkstComponentAcctRemovalTests {
    
    private final static Mock.ofIApexPages mockApexPages;
    private final static Mock.ofIPricingWkstDataProv mockDataProvider;
    private final static Pricing_Worksheet__c wkst;
    private final static PricingWkstComponentAcctRemovals sut;

    static {
        wkst = new Pricing_Worksheet__c(Id=ObjectFactory.getFakeId(Pricing_Worksheet__c.SObjectType, '1'));
        mockDataProvider = new Mock.ofIPricingWkstDataProv();
        sut = new PricingWkstComponentAcctRemovals(mockApexPages, mockDataProvider);
        sut.currentWorksheet = wkst;
    }

    @IsTest
    static void it_should_call_the_default_constructor_without_error() {
        PricingWkstComponentAcctRemovals sutDef = new PricingWkstComponentAcctRemovals();
    }

    @IsTest
    static void it_should_set_popup_data_to_an_empty_list_and_show_popup_for_add() {
        sut.popupData = new List<Pricing_Proposed_Account_Removal__c>{new Pricing_Proposed_Account_Removal__c(), new Pricing_Proposed_Account_Removal__c()};

        sut.showAddPopup();

        System.assertEquals(0, sut.popupData.size());
        System.assertEquals(true, sut.popupDisplayed);
        System.assertEquals('add', sut.popupType);
    }

    @IsTest
    static void it_should_display_all_available_accounts_that_are_not_already_flagged_for_removal() {
        EB_Account__c testEBAccount1 = new EB_Account__c(Id=ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1'), Name='1');
        EB_Account__c testEBAccount2 = new EB_Account__c(Id=ObjectFactory.getFakeId(EB_Account__c.SObjectType, '2'), Name='2');
        EB_Account__c testEBAccount3 = new EB_Account__c(Id=ObjectFactory.getFakeId(EB_Account__c.SObjectType, '3'), Name='3');
        EB_Account__c testEBAccount4 = new EB_Account__c(Id=ObjectFactory.getFakeId(EB_Account__c.SObjectType, '4'), Name='4');
        List<EB_Account__c> testEBAccts = new List<EB_Account__c>{testEBAccount1, testEBAccount2, testEBAccount3, testEBAccount4};
        Pricing_Proposed_Account_Removal__c item2 = new Pricing_Proposed_Account_Removal__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '2'), EB_Account__c = testEBAccount2.Id);
        Pricing_Proposed_Account_Removal__c item3 = new Pricing_Proposed_Account_Removal__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '3'), EB_Account__c = testEBAccount3.Id);
        Map<Id, Pricing_Proposed_Account_Removal__c> itemsRemoved = new Map<Id, Pricing_Proposed_Account_Removal__c>{item2.Id => item2, item3.Id => item3};
        sut.pricingRequest = new PricingWkstRequest();
        sut.pricingRequest.existingAccounts = testEBAccts;
        sut.pricingRequest.proposedAccountRemovals = itemsRemoved;

        List<SelectOption> acctsAvailableToRemove = sut.accountsAvailableToRemove;

        Boolean foundItem1 = false;
        Boolean foundItem4 = false;
        for (SelectOption option : acctsAvailableToRemove) {
            if (option.getValue() == testEBAccount1.Id) {
                foundItem1 = true;
            }
            if (option.getValue() == testEBAccount4.Id) {
                foundItem4 = true;
            }
        }

        System.assertEquals(2, acctsAvailableToRemove.size());
        System.assertEquals(true, foundItem1);  
        System.assertEquals(true, foundItem4);
    }

    @IsTest
    static void it_should_make_call_to_add_new_items_and_refresh_page() {
        String item1 = ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '1');
        String item2 = ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '2');
        List<String> items = new List<String>{item1, item2};
        sut.accountsSelectedToRemove = items;

        PageReference returnedURL = sut.addNewItems();

        mockDataProvider.verify('addPricingProposedAcctRemovals', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        System.assertEquals('/apex/pricingwkst?id='+wkst.Id, returnedURL.getUrl());
    }

    @IsTest
    static void it_should_set_popup_data_to_selected_item_and_show_popup_for_deletesingle() {
        sut.popupData = new List<Pricing_Proposed_Account_Removal__c>{new Pricing_Proposed_Account_Removal__c(), new Pricing_Proposed_Account_Removal__c()};
        Pricing_Proposed_Account_Removal__c item1 = new Pricing_Proposed_Account_Removal__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '1'));
        sut.selectedId = item1.Id;
        mockDataProvider.setup('getPricingProposedAcctRemoval', new List<Object>{item1.Id}).returns(item1);

        sut.showDeletePopupForSingleItem();

        mockDataProvider.verify('getPricingProposedAcctRemoval', new List<Object>{item1.Id}, Times.Once);
        System.assertEquals(1, sut.popupData.size());
        System.assertEquals(item1.Id, sut.popupData[0].Id);
        System.assertEquals(true, sut.popupDisplayed);
        System.assertEquals('deletesingle', sut.popupType);
    }

    @IsTest
    static void it_should_set_popup_data_to_all_items_and_show_popup_for_deleteall() {
        Pricing_Proposed_Account_Removal__c item1 = new Pricing_Proposed_Account_Removal__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '1'));
        Pricing_Proposed_Account_Removal__c item2 = new Pricing_Proposed_Account_Removal__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '2'));
        Map<Id, Pricing_Proposed_Account_Removal__c> items = new Map<Id, Pricing_Proposed_Account_Removal__c>{item1.Id => item1, item2.Id => item2};
        sut.pricingRequest = new PricingWkstRequest();
        sut.pricingRequest.proposedAccountRemovals = items;
            
        sut.showDeletePopupForAllItems();

        System.assertEquals(2, sut.popupData.size());
        System.assertEquals(true, sut.popupDisplayed);
        System.assertEquals('deleteall', sut.popupType);
    }

    @IsTest
    static void it_should_make_call_to_delete_items_and_refresh_page() {
        Pricing_Proposed_Account_Removal__c item1 = new Pricing_Proposed_Account_Removal__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '1'));
        Pricing_Proposed_Account_Removal__c item2 = new Pricing_Proposed_Account_Removal__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '2'));
        List<Pricing_Proposed_Account_Removal__c> items = new List<Pricing_Proposed_Account_Removal__c>{item1, item2};
        sut.popupData = items;

        PageReference returnedURL = sut.deleteItems();

        mockDataProvider.verify('deletePricingProposedAcctRemovals', new List<Object>{items}, Times.Once);
        System.assertEquals('/apex/pricingwkst?id='+wkst.Id, returnedURL.getUrl());
    }

    @IsTest
    static void it_should_set_popupDisplayed_to_false() {
        sut.popupDisplayed = true;

        sut.hidePopup();

        System.assertEquals(false, sut.popupDisplayed);
    }
}