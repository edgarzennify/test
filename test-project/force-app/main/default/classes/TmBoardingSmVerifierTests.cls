@IsTest
private class TmBoardingSmVerifierTests {
	private static TmBoardingSmVerifier sut;
    
    static{
        sut = new TmBoardingSmVerifier();
    }

    @isTest
    private static void it_should_verify_that_no_contacts_are_in_insert_save_list_if_request_pm_has_a_existing_record() {
        Id relRequestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Id relContactId = ObjectFactory.getFakeId(Tm_Service_Request_Contact__c.SObjectType, '1');
        Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        Tm_Service_Request_Contact__c relContactSm1 = new Tm_Service_Request_Contact__c(Tm_Service_Request__c=relRequestId, Contact__c=contactId);
        Tm_Service_Request_Contact__c relContactSm2 = new Tm_Service_Request_Contact__c(Tm_Service_Request__c=relRequestId, Contact__c=contactId);
        Tm_Service_Request_Contact__c relContactPm = new Tm_Service_Request_Contact__c(Id=relContactId, Tm_Service_Request__c=relRequestId, Contact__c=contactId);
    
        TmBoarding.RelatedSm sm = new TmBoarding.RelatedSm();
        sm.contactRelationships = new List<Tm_Service_Request_Contact__c>{relContactSm1, relContactSm2};
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = new Tm_Service_Request__c(Id=relRequestId);
        requestPm.serviceContactPms = new List<Tm_Service_Request_Contact__c>{relContactPm};

        TmBoarding.RelatedSm result = sut.verifyRelatedSm(sm, requestPm);

        System.assertEquals(1 , result.contactRelationships.size());
        System.assertEquals(relContactId , result.contactRelationships[0].id);
    }

    @isTest
    private static void it_should_verify_that_no_accounts_are_in_insert_save_list_if_request_pm_has_a_existing_record() {
        Id relRequestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Id relAccountId = ObjectFactory.getFakeId(Tm_Service_Request_Account__c.SObjectType, '1');
        Id relEbAccountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        Tm_Service_Request_Account__c relAccountSm1 = new Tm_Service_Request_Account__c(Tm_Service_Request__c=relRequestId, Eb_Account__c=relEbAccountId);
        Tm_Service_Request_Account__c relAccountSm2 = new Tm_Service_Request_Account__c(Tm_Service_Request__c=relRequestId, Eb_Account__c=relEbAccountId);
        Tm_Service_Request_Account__c relAccountPm = new Tm_Service_Request_Account__c(Id=relAccountId, Tm_Service_Request__c=relRequestId, Eb_Account__c=relEbAccountId);
    
        TmBoarding.RelatedSm sm = new TmBoarding.RelatedSm();
        sm.accountRelationships = new List<Tm_Service_Request_Account__c>{relAccountSm1, relAccountSm2};
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = new Tm_Service_Request__c(Id=relRequestId);
        requestPm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{relAccountPm};

        TmBoarding.RelatedSm result = sut.verifyRelatedSm(sm, requestPm);

        System.assertEquals(1 , result.accountRelationships.size());
        System.assertEquals(relAccountId , result.accountRelationships[0].id);
    }

    @isTest
    private static void it_should_verify_that_if_there_are_two_same_contact_related_record_they_should_be_reconciled() {
        Id relRequestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Id relContactId = ObjectFactory.getFakeId(Tm_Service_Request_Contact__c.SObjectType, '1');
        Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        Tm_Service_Request_Contact__c relContactSm1 = new Tm_Service_Request_Contact__c(Tm_Service_Request__c=relRequestId, Contact__c=contactId);
        Tm_Service_Request_Contact__c relContactSm2 = new Tm_Service_Request_Contact__c(Tm_Service_Request__c=relRequestId, Contact__c=contactId,Primary_Product_Contact__c=true);
    
        TmBoarding.RelatedSm sm = new TmBoarding.RelatedSm();
        sm.contactRelationships = new List<Tm_Service_Request_Contact__c>{relContactSm1, relContactSm2};
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = new Tm_Service_Request__c(Id=relRequestId);

        TmBoarding.RelatedSm result = sut.verifyRelatedSm(sm, requestPm);

        System.assertEquals(1 , result.contactRelationships.size());
        System.assertEquals(true , result.contactRelationships[0].Primary_Product_Contact__c);
    }

    @isTest
    private static void it_should_verify_that_if_there_are_two_same_account_related_record_they_should_be_reconciled() {
        Id relRequestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Id relAccountId = ObjectFactory.getFakeId(Tm_Service_Request_Account__c.SObjectType, '1');
        Id relEbAccountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        Tm_Service_Request_Account__c relAccountSm1 = new Tm_Service_Request_Account__c(Tm_Service_Request__c=relRequestId, Eb_Account__c=relEbAccountId);
        Tm_Service_Request_Account__c relAccountSm2 = new Tm_Service_Request_Account__c(Tm_Service_Request__c=relRequestId, Eb_Account__c=relEbAccountId, ACH_Originator_ID__c='test');
    
        TmBoarding.RelatedSm sm = new TmBoarding.RelatedSm();
        sm.accountRelationships = new List<Tm_Service_Request_Account__c>{relAccountSm1, relAccountSm2};
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = new Tm_Service_Request__c(Id=relRequestId);

        TmBoarding.RelatedSm result = sut.verifyRelatedSm(sm, requestPm);

        System.assertEquals(1 , result.accountRelationships.size());
        System.assertEquals('test' , result.accountRelationships[0].ACH_Originator_ID__c);
    }
}