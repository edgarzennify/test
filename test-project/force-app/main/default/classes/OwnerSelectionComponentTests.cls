@IsTest
private class OwnerSelectionComponentTests {

    @IsTest
    static void it_should_call_the_default_constructor_without_error() {
        OwnerSelectionComponent sut = new OwnerSelectionComponent();
    }

    @IsTest
    static void it_should_set_owner_info_list_on_initialization() {
        User testUser = new User();
        List<User> ownerDetails = new List<User>{testUser};
        MockofIOwnerSelectionComponentDataProv mockData = new MockofIOwnerSelectionComponentDataProv();
        mockData.setup('getOwners').returns(ownerDetails);

        OwnerSelectionComponent sut = new OwnerSelectionComponent(mockData);

        System.assertEquals(ownerDetails, sut.owners);
        mockData.verify('getOwners', Times.Once);
    }

    private class MockofIOwnerSelectionComponentDataProv extends ApexMoq implements OwnerSelectionComponent.IOwnerSelectionComponentDataProv {
        public List<User> getOwners(){
            return (List<User>)handleMethodInvocation('getOwners');
        }
    }
}