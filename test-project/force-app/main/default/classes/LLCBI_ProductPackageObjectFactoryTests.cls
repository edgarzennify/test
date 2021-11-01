@isTest
public class LLCBI_ProductPackageObjectFactoryTests {
    private static LLCBI_ProductPackageObjectFactory sut;
    private static MockofILLCBI_ProductPackageObjectFactory mockDataProvider;
    
    static{
        mockDataProvider = new MockofILLCBI_ProductPackageObjectFactory();
        sut = new LLCBI_ProductPackageObjectFactory(mockDataProvider); 
    }
    private static testMethod void it_should_update_the_material_exceptions_on_the_package_if_the_loan_has_two_or_more_material_exceptions(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c();
        ln1.LLC_BI__Product_Package__c = pack.Id;
        ln1.Policy_Exceptions__c = 'Advance Rate; Loan to Value';
        ln1.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        ln1.Channel__c = 'Commercial Banking';
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{ln1};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(ln1.Id, ln1);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
            
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages); 
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(oldSos);
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(true, results[0].Material_Exceptions_Approval_Required__c);
    }
    private static testMethod void it_should_not_update_the_material_exceptions_on_the_package_if_the_loan_has_less_than_two_material_exceptions(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c();
        ln1.LLC_BI__Product_Package__c = pack.Id;
        ln1.Policy_Exceptions__c = 'Advance Rate';
        ln1.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{ln1};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(ln1.Id, ln1);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
            
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages); 
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(oldSos);
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(false, results[0].Material_Exceptions_Approval_Required__c);
    }
    private static testMethod void it_should_not_return_packages_if_the_loan_does_not_have_exceptions(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Material_Exceptions_Approval_Required__c = false;
        LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c();
        ln1.LLC_BI__Product_Package__c = pack.Id;
        ln1.Policy_Exceptions__c = 'N/A';
        ln1.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        ln1.Channel__c = 'Commercial Banking';
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{ln1};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(ln1.Id, ln1);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
            
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages); 
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(oldSos);
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(null, results);
    }
    private static testMethod void it_should_not_update_the_material_exceptions_on_the_package_if_the_loan_is_not_commercial(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c();
        ln1.LLC_BI__Product_Package__c = pack.Id;
        ln1.Policy_Exceptions__c = 'Advance Rate; Term';
        ln1.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        ln1.Channel__c = 'Consumer Banking';
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{ln1};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(ln1.Id, ln1);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
            
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages); 
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(oldSos);
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(false, results[0].Material_Exceptions_Approval_Required__c);
    }
    private static testMethod void it_should_set_material_exceptions_to_false_if_it_was_true_and_policy_exceptions_no_longer_require_it(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Material_Exceptions_Approval_Required__c = true;
        LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c();
        ln1.LLC_BI__Product_Package__c = pack.Id;
        ln1.Policy_Exceptions__c = 'Advance Rate';
        ln1.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        ln1.Channel__c = 'Commercial Banking';
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{ln1};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(ln1.Id, ln1);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
            
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages); 
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(oldSos);
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(false, results[0].Material_Exceptions_Approval_Required__c);
    }
    private static testMethod void it_should_update_contains_policy_exceptions_on_the_package_when_updatePackages_is_called_with_loans(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Contains_Policy_Exceptions__c = false;
        LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c();
        ln1.LLC_BI__Product_Package__c = pack.Id;
        ln1.Policy_Exceptions__c = 'Term; Amortization; Out of market collateral / borrower';
        ln1.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LLC_BI__Loan__c ln2 = new LLC_BI__Loan__c();
        ln2.LLC_BI__Product_Package__c = pack.Id;
        ln2.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{ln1, ln2};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(ln1.Id, ln1);
        newSosMap.put(ln2.Id, ln2);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
                
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages);
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(oldSos);
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(true, results[0].Contains_Policy_Exceptions__c);
        system.assertEquals(1, results.size());
    }
    private static testMethod void it_should_not_return_updated_packages_when_updatePackages_is_called_with_loans_that_dont_have_exceptions(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c();
        ln1.LLC_BI__Product_Package__c = pack.Id;
        ln1.Policy_Exceptions__c = 'N/A';
        ln1.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LLC_BI__Loan__c ln2 = new LLC_BI__Loan__c();
        ln2.LLC_BI__Product_Package__c = pack.Id;
        ln1.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{ln1, ln2};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(ln1.Id, ln1);
        newSosMap.put(ln2.Id, ln2);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
                
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages);
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(oldSos);
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(null, results);
    }
    private static testMethod void it_should_update_the_pass_recommendation_on_the_package_when_updatePackages_is_called_with_a_single_loan(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.LLC_BI__TCE__c = 25000;
        pack.Channel__c = 'Business Banking';
        pack.PASS_Recommendation__c = null;
        LLC_BI__Loan__c oldLoan = new LLC_BI__Loan__c();
        oldLoan.LLC_BI__Product_Package__c = pack.Id;
        oldLoan.Underwriting_Complete__c = false;
        LLC_BI__Loan__c newLoan = new LLC_BI__Loan__c();
        newLoan.LLC_BI__Product_Package__c = pack.Id;
        newLoan.Underwriting_Complete__c = true;
        newLoan.Policy_Exceptions__c = 'N/A';
        newLoan.PASS_Recommendation__c = 'Approve';
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{oldLoan};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(newLoan.Id, newLoan);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
                
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages);
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(newSosMap.values());
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals('Approve', results[0].PASS_Recommendation__c);
    }
    private static testMethod void it_should_not_return_updated_packages_when_updatePackages_is_called_with_a_single_loan_that_doesnt_need_exceptions_or_pass(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Channel__c = 'Commercial Banking';
        LLC_BI__Loan__c oldLoan = new LLC_BI__Loan__c();
        oldLoan.LLC_BI__Product_Package__c = pack.Id;
        LLC_BI__Loan__c newLoan = new LLC_BI__Loan__c();
        newLoan.LLC_BI__Product_Package__c = pack.Id;
        newLoan.Policy_Exceptions__c = 'N/A';
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{oldLoan};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(newLoan.Id, newLoan);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
                
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages);
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(newSosMap.values());
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(null, results);
    }
    private static testMethod void it_should_update_the_pass_recommendation_on_the_package_when_updatePackages_is_called_with_multiple_loans_related_to_package_ready_for_pass_update(){
        Id loanId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id loanId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.LLC_BI__TCE__c = 25000;
        pack.Channel__c = 'Commercial Banking';
        pack.New_Money_Renewal__c = 'New Money';
        pack.New_Money_Amt__c = 25000;
        pack.PASS_Recommendation__c = null;
        LLC_BI__Loan__c oldLoan1 = new LLC_BI__Loan__c();
        oldLoan1.Id = loanId1;
        oldLoan1.LLC_BI__Product_Package__c = pack.Id;
        oldLoan1.Underwriting_Complete__c = false;
        oldLoan1.LLC_BI__Product__c = 'Credit Card';
        LLC_BI__Loan__c oldLoan2 = new LLC_BI__Loan__c();
        oldLoan2.Id = loanId2;
        oldLoan2.LLC_BI__Product_Package__c = pack.Id;
        oldLoan2.Underwriting_Complete__c = true;
        oldLoan2.LLC_BI__Product__c = 'Credit Card';
        LLC_BI__Loan__c newLoan1 = new LLC_BI__Loan__c();
        newLoan1.Id = loanId1;
        newLoan1.LLC_BI__Product_Package__c = pack.Id;
        newLoan1.Underwriting_Complete__c = true;
        newLoan1.Policy_Exceptions__c = 'N/A';
        newLoan1.PASS_Recommendation__c = 'Approve';
        newLoan1.LLC_BI__Product__c = 'Credit Card';
        LLC_BI__Loan__c newLoan2 = new LLC_BI__Loan__c();
        newLoan2.Id = loanId2;
        newLoan2.LLC_BI__Product_Package__c = pack.Id;
        newLoan2.Underwriting_Complete__c = true;
        newLoan2.Policy_Exceptions__c = 'N/A';
        newLoan2.PASS_Recommendation__c = 'Approve';
        newLoan2.LLC_BI__Product__c = 'Credit Card';
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{oldLoan1, oldLoan2};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(newLoan1.Id, newLoan1);
        newSosMap.put(newLoan2.Id, newLoan2);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
                
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages);
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(newSosMap.values());
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals('Approve', results[0].PASS_Recommendation__c);
    }
    private static testMethod void it_should_not_update_the_pass_recommendation_on_the_package_when_updatePackages_is_called_with_multiple_loans_and_one_is_not_ready(){
        Id loanId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id loanId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.LLC_BI__TCE__c = 25000;
        pack.Channel__c = 'Commercial Banking';
        pack.New_Money_Renewal__c = 'New Money';
        pack.New_Money_Amt__c = 25000;
        pack.PASS_Recommendation__c = null;
        LLC_BI__Loan__c oldLoan1 = new LLC_BI__Loan__c();
        oldLoan1.Id = loanId1;
        oldLoan1.LLC_BI__Product_Package__c = pack.Id;
        oldLoan1.Underwriting_Complete__c = false;
        oldLoan1.LLC_BI__Product__c = 'Credit Card';
        LLC_BI__Loan__c oldLoan2 = new LLC_BI__Loan__c();
        oldLoan2.Id = loanId2;
        oldLoan2.LLC_BI__Product_Package__c = pack.Id;
        oldLoan2.Underwriting_Complete__c = false;
        oldLoan2.LLC_BI__Product__c = 'Credit Card';
        LLC_BI__Loan__c newLoan1 = new LLC_BI__Loan__c();
        newLoan1.Id = loanId1;
        newLoan1.LLC_BI__Product_Package__c = pack.Id;
        newLoan1.Underwriting_Complete__c = true;
        newLoan1.Policy_Exceptions__c = 'N/A';
        newLoan1.PASS_Recommendation__c = 'Approve';
        newLoan1.LLC_BI__Product__c = 'Credit Card';
        LLC_BI__Loan__c newLoan2 = new LLC_BI__Loan__c();
        newLoan2.Id = loanId2;
        newLoan2.LLC_BI__Product_Package__c = pack.Id;
        newLoan2.Underwriting_Complete__c = false;
        newLoan2.Policy_Exceptions__c = 'N/A';
        newLoan2.PASS_Recommendation__c = 'Approve';
        newLoan2.LLC_BI__Product__c = 'Credit Card';
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{oldLoan1, oldLoan2};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(newLoan1.Id, newLoan1);
        newSosMap.put(newLoan2.Id, newLoan2);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
                
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages);
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(newSosMap.values());
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(null, results);
    }
    private static testMethod void it_should_code_cover_constructor(){
        LLCBI_ProductPackageObjectFactory ppof = new LLCBI_ProductPackageObjectFactory();
    }
    private static testMethod void it_should_not_return_anything_and_not_error_if_called_with_a_basic_loan(){
        LLC_BI__Loan__c ln = new LLC_BI__Loan__c();
        ln.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{ln};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(ln.Id, ln);
                
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(null, results);
    }
    private static testMethod void it_should_set_ready_for_takedown_to_true_when_package_has_been_approved_with_a_related_main_guidance_line(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        oldPack.LLC_BI__Status__c = 'New';
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.LLC_BI__Status__c = 'Approved';
        newPack.Ready_for_Takedown_Approval__c = false;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        Set<Id> packageIds = new Set<Id>{newPack.Id};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = newPack.Id;
        loan.LLC_BI__Structure_Hierarchy__c = 'Main';
        List<LLC_BI__Loan__c> relatedLoans = new List<LLC_BI__Loan__c>{loan};
        
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(relatedLoans);
        sut.setGuidanceLineTakedownApproval(oldSos, newSosMap);
        system.assertEquals(true, newPack.Ready_for_Takedown_Approval__c);
    }
    private static testMethod void it_should_not_set_ready_for_takedown_to_true_when_package_has_not_been_approved_with_a_related_main_guidance_line(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        oldPack.LLC_BI__Status__c = 'New';
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.LLC_BI__Status__c = 'New';
        newPack.Ready_for_Takedown_Approval__c = false;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        Set<Id> packageIds = new Set<Id>{newPack.Id};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = newPack.Id;
        loan.LLC_BI__Structure_Hierarchy__c = 'Main';
        List<LLC_BI__Loan__c> relatedLoans = new List<LLC_BI__Loan__c>{loan};
        
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(relatedLoans);
        sut.setGuidanceLineTakedownApproval(oldSos, newSosMap);
        system.assertEquals(false, newPack.Ready_for_Takedown_Approval__c);
    }
    private static testMethod void it_should_not_set_ready_for_takedown_to_true_when_package_has_been_approved_with_no_related_main_guidance_line(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        oldPack.LLC_BI__Status__c = 'New';
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.LLC_BI__Status__c = 'Approved';
        newPack.Ready_for_Takedown_Approval__c = false;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        Set<Id> packageIds = new Set<Id>{newPack.Id};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = newPack.Id;
        loan.LLC_BI__Structure_Hierarchy__c = null;
        List<LLC_BI__Loan__c> relatedLoans = new List<LLC_BI__Loan__c>{loan};
        
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(relatedLoans);
        sut.setGuidanceLineTakedownApproval(oldSos, newSosMap);
        system.assertEquals(false, newPack.Ready_for_Takedown_Approval__c);
    }
    private static testMethod void it_should_set_all_facilities_approved_if_all_related_loans_are_approved(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = pack.Id;
        loan.LLC_BI__Stage__c = 'Post-Approval Review';
        List<LLC_BI__Loan__c> relatedLoans = new List<LLC_BI__Loan__c>{loan};
            
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(relatedLoans);
        sut.setAllFacilitiesApproved(newSosMap);
        LLC_BI__Product_Package__c updatedPack = (LLC_BI__Product_Package__c)newSosMap.get(pack.Id);
        system.assertEquals(true, updatedPack.All_Facilities_Approved__c);
    }
    private static testMethod void it_should_not_set_all_facilities_approved_if_all_related_loans_are_approved(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack.Id, pack);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = pack.Id;
        loan.LLC_BI__Stage__c = 'Credit Request';
        List<LLC_BI__Loan__c> relatedLoans = new List<LLC_BI__Loan__c>{loan};
            
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(relatedLoans);
        sut.setAllFacilitiesApproved(newSosMap);
        LLC_BI__Product_Package__c updatedPack = (LLC_BI__Product_Package__c)newSosMap.get(pack.Id);
        system.assertEquals(false, updatedPack.All_Facilities_Approved__c);
    }
    private static testMethod void it_should_return_a_list_of_approval_submission_requests_when_gatherPackagesAndLoansThatNeedAutoApproval_is_called_with_a_package_that_has_received_the_recommendation_of_approve(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        oldPack.PASS_Recommendation__c = null;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.PASS_Recommendation__c = 'Approve';
        newPack.LLC_BI__TCE__c = 25000;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        Set<Id> packageIds = new Set<Id>{newPack.Id};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        loan.LLC_BI__Product_Package__c = newPack.Id;
        List<LLC_BI__Loan__c> relatedLoans = new List<LLC_BI__Loan__c>{loan};
            
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(relatedLoans);
        List<Approval.ProcessSubmitRequest> results = sut.gatherPackagesAndLoansThatNeedAutoApproval(oldSos, newSosMap);
        system.assertEquals(2, results.size());
        system.assertEquals(true, results[0].ObjectId == newPack.Id || results[0].ObjectId == loan.Id);
    }
    private static testMethod void it_should_not_return_a_list_of_approval_submission_requests_when_gatherPackagesAndLoansThatNeedAutoApproval_is_called_with_a_package_that_has_not_received_the_recommendation_of_approve(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        oldPack.PASS_Recommendation__c = null;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.PASS_Recommendation__c = 'Deny';
        newPack.LLC_BI__TCE__c = 25000;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        Set<Id> packageIds = new Set<Id>{newPack.Id};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        loan.LLC_BI__Product_Package__c = newPack.Id;
        List<LLC_BI__Loan__c> relatedLoans = new List<LLC_BI__Loan__c>{loan};
            
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(relatedLoans);
        List<Approval.ProcessSubmitRequest> results = sut.gatherPackagesAndLoansThatNeedAutoApproval(oldSos, newSosMap);
        system.assertEquals(null, results);
    }
    private static testMethod void it_should_set_rmg_approvers_when_updatePackageApprovers_is_called_for_a_rmg_package(){
        User officer = [SELECT Id FROM User WHERE Level_A_Approver__c = true LIMIT 1];
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.Channel__c = 'Resolution Management Group (RMG)';
        newPack.Originating_Officer__c = officer.Id;
        newPack.First_Approver__c = null;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        
        sut.updatePackageApprovers(oldSos, newSosMap);
        system.assertEquals(officer.Id, newPack.First_Approver__c);
        system.assertEquals('005a00000089F93', newPack.Second_Approver__c);
    }
    private static testMethod void it_should_not_set_rmg_approvers_when_updatePackageApprovers_is_called_for_a_rmg_package(){
        User officer = [SELECT Id FROM User WHERE Level_A_Approver__c = true LIMIT 1];
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.Channel__c = 'Commercial Banking';
        newPack.Originating_Officer__c = officer.Id;
        newPack.First_Approver__c = null;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        
        sut.updatePackageApprovers(oldSos, newSosMap);
        system.assertNotEquals(officer.Id, newPack.First_Approver__c);
        system.assertNotEquals('005a00000089F93', newPack.Second_Approver__c);
    }
    private static testMethod void it_should_set_approver_type_to_level_a_when_updatePackageApprovers_is_called_with_a_package_that_contains_employee_loans(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.Contains_Employee_Loans__c = true;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        
        sut.updatePackageApprovers(oldSos, newSosMap);
        system.assertEquals(newPack.Approver_Type__c, 'Level A');
    }
    private static testMethod void it_should_set_approver_type_to_level_b_when_updatePackageApprovers_is_called_with_a_consumer_package_with_tce_less_than_or_equal_to_1000000(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.LLC_BI__TCE__c = 25000;
        newPack.Channel__c = 'Consumer Banking';
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        
        sut.updatePackageApprovers(oldSos, newSosMap);
        system.assertEquals(newPack.Approver_Type__c, 'Level B');
    }
    private static testMethod void it_should_set_approver_type_to_level_a_when_updatePackageApprovers_is_called_with_a_consumer_package_with_tce_greater_than_1000000(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.LLC_BI__TCE__c = 2500000;
        newPack.Channel__c = 'Consumer Banking';
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        
        sut.updatePackageApprovers(oldSos, newSosMap);
        system.assertEquals(newPack.Approver_Type__c, 'Level A');
    }
    private static testMethod void it_should_set_approver_type_to_level_a_when_updatePackageApprovers_is_called_with_a_bb_package_that_has_orange_approval(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.BB_Approval_Path__c = 'Orange';
        newPack.Channel__c = 'Business Banking';
        newPack.Override_Recommended_Approval_Path__c = false;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        
        sut.updatePackageApprovers(oldSos, newSosMap);
        system.assertEquals(newPack.Approver_Type__c, 'Level A');
    }
    private static testMethod void it_should_set_approver_type_to_level_B_when_updatePackageApprovers_is_called_with_a_bb_package_that_has_override(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        oldPack.Channel__c = 'Business Banking';
        oldPack.Override_Recommended_Approval_Path__c = false;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.BB_Approval_Path__c = 'Yellow';
        newPack.Channel__c = 'Business Banking';
        newPack.Override_Recommended_Approval_Path__c = true;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        
        sut.updatePackageApprovers(oldSos, newSosMap);
        system.assertEquals(newPack.Approver_Type__c, 'Level B');
    }
    private static testMethod void it_should_set_approver_type_to_RMGApprover_when_updatePackageApprovers_is_called_with_a_rmg_package(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.Channel__c = 'Resolution Management Group (RMG)';
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        
        sut.updatePackageApprovers(oldSos, newSosMap);
        system.assertEquals(newPack.Approver_Type__c, 'RMGApprover');
    }
    private static testMethod void it_should_set_approver_type_to_level_b_when_updatePackageApprovers_is_called_with_a_commercial_package(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.Channel__c = 'Commercial Banking';
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        
        sut.updatePackageApprovers(oldSos, newSosMap);
        system.assertEquals(newPack.Approver_Type__c, 'Level B');
    }
    private static testMethod void it_should_set_approver_type_to_na_if_no_channel(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.LLC_BI__TCE__c = 25000;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        
        sut.updatePackageApprovers(oldSos, newSosMap);
        system.assertEquals(newPack.Approver_Type__c, 'N/A');
    }
    private static testMethod void it_should_return_a_single_package_when_updatePackages_is_called_with_a_multiple_loans_related_to_the_same_package_that_need_separate_updates(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Contains_Policy_Exceptions__c = false;
        pack.LLC_BI__TCE__c = 25000;
        pack.Channel__c = 'Business Banking';
        LLC_BI__Loan__c oldLoan1 = new LLC_BI__Loan__c();
        oldLoan1.LLC_BI__Product_Package__c = pack.Id;
        oldLoan1.Policy_Exceptions__c = 'Advance Rate';
        oldLoan1.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        oldLoan1.Underwriting_Complete__c = true;
        LLC_BI__Loan__c newLoan1 = new LLC_BI__Loan__c();
        newLoan1.LLC_BI__Product_Package__c = pack.Id;
        newLoan1.Policy_Exceptions__c = 'Advance Rate';
        newLoan1.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        newLoan1.Underwriting_Complete__c = true;
        LLC_BI__Loan__c oldLoan2 = new LLC_BI__Loan__c();
        oldLoan2.LLC_BI__Product_Package__c = pack.Id;
        oldLoan2.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        oldLoan2.Underwriting_Complete__c = false;
        oldLoan2.Policy_Exceptions__c = 'N/A';
        LLC_BI__Loan__c newLoan2 = new LLC_BI__Loan__c();
        newLoan2.LLC_BI__Product_Package__c = pack.Id;
        newLoan2.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        newLoan2.Underwriting_Complete__c = true;
        newLoan2.Policy_Exceptions__c = 'N/A';
        List<LLC_BI__Loan__c> oldSos = new List<LLC_BI__Loan__c>{oldLoan1, oldLoan2};
        Map<Id, LLC_BI__Loan__c> newSosMap = new Map<Id, LLC_BI__Loan__c>();
        newSosMap.put(newLoan1.Id, newLoan1);
        newSosMap.put(newLoan2.Id, newLoan2);
        Set<Id> packageIds = new Set<Id>{pack.Id};
        List<LLC_BI__Product_Package__c> packages = new List<LLC_BI__Product_Package__c>{pack};
                
        mockDataProvider.setup('getProductPackages', new List<Object>{packageIds}).returns(packages);
        mockDataProvider.setup('getLoansRelatedToPackages', new List<Object>{packageIds}).returns(oldSos);
        List<LLC_BI__Product_Package__c> results = sut.updatePackages(oldSos, newSosMap);
        system.assertEquals(1, results.size());
    }
    
    public class MockofILLCBI_ProductPackageObjectFactory extends ApexMoq implements LLCBI_ProductPackageObjectFactory.IProductPackageFactoryDataProvider {
        public List<LLC_BI__Product_Package__c> getProductPackages(Set<Id> packageIds) {
			return (List<LLC_BI__Product_Package__c>)handleMethodInvocation('getProductPackages', new List<Object>{packageIds});
		}
        public List<LLC_BI__Loan__c> getLoansRelatedToPackages(Set<Id> packageIds) {
			return (List<LLC_BI__Loan__c>)handleMethodInvocation('getLoansRelatedToPackages', new List<Object>{packageIds});
		}
    }
}