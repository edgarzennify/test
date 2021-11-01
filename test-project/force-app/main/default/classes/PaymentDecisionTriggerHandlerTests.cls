@IsTest
private class PaymentDecisionTriggerHandlerTests {

    private static String opsAdminPermission = 'Function - Payment Decision - Admin';
    private static String selectPermission = 'Function - Payment Decision - Select Actions';
    private static String statusProcessed = 'Processed';
    private static String statusNotProcessed = 'Not Processed';

    private static final Mock.ofIUserInfoService mockUserInfoService;
    private static final Mock.ofISystem mockSystem;
    private static final PaymentDecisionTriggerHandler sut;

    static{
        mockUserInfoService = new Mock.ofIUserInfoService();
        mockSystem = new  Mock.ofISystem();

        sut = new PaymentDecisionTriggerHandler(mockUserInfoService, mockSystem);
    }

    @IsTest
    private static void it_should_set_processed_date_to_today_date_if_processed_is_selected(){
        Id recordId = Objectfactory.getFakeId(Payment_Decision__c.SobjectType, '1');
        Id userId = Objectfactory.getFakeId(User.SobjectType, '1');
        List<Payment_Decision__c> oldSos = new List<Payment_Decision__c>();
        Payment_Decision__c oldP = new Payment_Decision__c();
        oldP.Id = recordId;
        oldP.Status__c = '';
        oldSos.add(oldP);
        Payment_Decision__c newP = new Payment_Decision__c();
        newP.Id = recordId;
        newP.Action__c = 'test';
        newP.Status__c = statusProcessed;
        Map<Id,Payment_Decision__c> newSosMap = new Map<Id,Payment_Decision__c>{recordId => newP};
        Date dt = Date.newInstance(2021,1,2);
        mockUserInfoService.setup('getCurrentUserId').returns(userId);
        mockUserInfoService.setup('isSystemAdministrator', new List<object>{userId}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,selectPermission}).returns(true);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,opsAdminPermission}).returns(false);
        mockSystem.setup('today').returns(dt);

        sut.bulkbeforeUpdate(oldSos, newSosMap);

        Payment_Decision__c result = ((Payment_Decision__c)newSosMap.get(recordId));      
        System.assertEquals(dt, result.Processed_Date__c);
    }

    @IsTest
    private static void it_should_set_null_to_processed_date_if_Not_processed_is_selected(){
        Id recordId = Objectfactory.getFakeId(Payment_Decision__c.SobjectType, '1');
        Id userId = Objectfactory.getFakeId(User.SobjectType, '1');
        List<Payment_Decision__c> oldSos = new List<Payment_Decision__c>();
        Payment_Decision__c oldP = new Payment_Decision__c();
        oldP.Id = recordId;
        oldSos.add(oldP);
        Payment_Decision__c newP = new Payment_Decision__c();
        newP.Id = recordId;
        newP.Status__c = statusNotProcessed;
        newP.Action__c = 'test';
        Map<Id,Payment_Decision__c> newSosMap = new Map<Id,Payment_Decision__c>{recordId => newP};
        Date dt = Date.newInstance(2021,1,2);
        mockSystem.setup('today').returns(dt);
        mockUserInfoService.setup('getCurrentUserId').returns(userId);
        mockUserInfoService.setup('isSystemAdministrator', new List<object>{userId}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,selectPermission}).returns(true);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,opsAdminPermission}).returns(false);

        sut.bulkbeforeUpdate(oldSos, newSosMap);

        System.assertEquals(null, ((Payment_Decision__c)newSosMap.get(recordId)).Processed_Date__c);
    }

    @IsTest
    private static void it_should_be_able_to_change_action_if_old_action_is_null_when_permission_is_ops_admin(){
        Id recordId = Objectfactory.getFakeId(Payment_Decision__c.SobjectType, '1');
        Id userId = Objectfactory.getFakeId(User.SobjectType, '1');
        List<Payment_Decision__c> oldSos = new List<Payment_Decision__c>();
        Payment_Decision__c oldP = new Payment_Decision__c();
        oldP.Id = recordId;
        oldSos.add(oldP);
        Payment_Decision__c newP = new Payment_Decision__c();
        newP.Id = recordId;
        newP.Action__c = 'test';
        Map<Id,Payment_Decision__c> newSosMap = new Map<Id,Payment_Decision__c>{recordId => newP};
        mockUserInfoService.setup('getCurrentUserId').returns(userId);
        mockUserInfoService.setup('isSystemAdministrator', new List<object>{userId}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,selectPermission}).returns(true);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,opsAdminPermission}).returns(false);
        Date dt = Date.newInstance(2021,1,2);
        mockSystem.setup('today').returns(dt);


        sut.bulkbeforeUpdate(oldSos, newSosMap);

        System.assertEquals('test', ((Payment_Decision__c)newSosMap.get(recordId)).Action__c);
    
    }

    @IsTest
    private static void it_should_not_be_able_to_change_action_if_old_action_is_not_null_when_permission_is_select(){
        Id recordId = Objectfactory.getFakeId(Payment_Decision__c.SobjectType, '1');
        Id userId = Objectfactory.getFakeId(User.SobjectType, '1');
        List<Payment_Decision__c> oldSos = new List<Payment_Decision__c>();
        Payment_Decision__c oldP = new Payment_Decision__c();
        oldP.Id = recordId;
        oldP.Action__c = 'test';
        oldSos.add(oldP);
        Payment_Decision__c newP = new Payment_Decision__c();
        newP.Id = recordId;
        newP.Action__c = 'test-2';
        Map<Id,Payment_Decision__c> newSosMap = new Map<Id,Payment_Decision__c>{recordId => newP};
        mockUserInfoService.setup('getCurrentUserId').returns(userId);
        mockUserInfoService.setup('isSystemAdministrator', new List<object>{userId}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,selectPermission}).returns(true);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,opsAdminPermission}).returns(false);
        Date dt = Date.newInstance(2021,1,2);
        mockSystem.setup('today').returns(dt);


        sut.bulkbeforeUpdate(oldSos, newSosMap);

        System.assertEquals('test', ((Payment_Decision__c)newSosMap.get(recordId)).Action__c);
    
    }

    @IsTest
    private static void it_should_be_able_to_change_action_if_old_action_is_null_when_permission_is_admin(){
        Id recordId = Objectfactory.getFakeId(Payment_Decision__c.SobjectType, '1');
        Id userId = Objectfactory.getFakeId(User.SobjectType, '1');
        List<Payment_Decision__c> oldSos = new List<Payment_Decision__c>();
        Payment_Decision__c oldP = new Payment_Decision__c();
        oldP.Id = recordId;
        oldSos.add(oldP);
        Payment_Decision__c newP = new Payment_Decision__c();
        newP.Id = recordId;
        newP.Action__c = 'test';
        Map<Id,Payment_Decision__c> newSosMap = new Map<Id,Payment_Decision__c>{recordId => newP};
        mockUserInfoService.setup('getCurrentUserId').returns(userId);
        mockUserInfoService.setup('isSystemAdministrator', new List<object>{userId}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,selectPermission}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,opsAdminPermission}).returns(true);
        Date dt = Date.newInstance(2021,1,2);
        mockSystem.setup('today').returns(dt);


        sut.bulkbeforeUpdate(oldSos, newSosMap);

        System.assertEquals('test', ((Payment_Decision__c)newSosMap.get(recordId)).Action__c);
    
    }

    @IsTest
    private static void it_should_be_able_to_change_action_if_old_action_is_not_null_when_permission_is_ops_admin(){
        Id recordId = Objectfactory.getFakeId(Payment_Decision__c.SobjectType, '1');
        Id userId = Objectfactory.getFakeId(User.SobjectType, '1');
        List<Payment_Decision__c> oldSos = new List<Payment_Decision__c>();
        Payment_Decision__c oldP = new Payment_Decision__c();
        oldP.Id = recordId;
        oldP.Action__c = 'test';
        oldSos.add(oldP);
        Payment_Decision__c newP = new Payment_Decision__c();
        newP.Id = recordId;
        newP.Action__c = 'test-2';
        Map<Id,Payment_Decision__c> newSosMap = new Map<Id,Payment_Decision__c>{recordId => newP};
        mockUserInfoService.setup('getCurrentUserId').returns(userId);
        mockUserInfoService.setup('isSystemAdministrator', new List<object>{userId}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,selectPermission}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,opsAdminPermission}).returns(true);
        Date dt = Date.newInstance(2021,1,2);
        mockSystem.setup('today').returns(dt);


        sut.bulkbeforeUpdate(oldSos, newSosMap);

        System.assertEquals('test-2', ((Payment_Decision__c)newSosMap.get(recordId)).Action__c);
    
    }

    @IsTest
    private static void it_should_be_able_to_change_action_if_old_action_is_not_null_when_permission_is_sys_admin(){
        Id recordId = Objectfactory.getFakeId(Payment_Decision__c.SobjectType, '1');
        Id userId = Objectfactory.getFakeId(User.SobjectType, '1');
        List<Payment_Decision__c> oldSos = new List<Payment_Decision__c>();
        Payment_Decision__c oldP = new Payment_Decision__c();
        oldP.Id = recordId;
        oldP.Action__c = 'test';
        oldSos.add(oldP);
        Payment_Decision__c newP = new Payment_Decision__c();
        newP.Id = recordId;
        newP.Action__c = 'test-2';
        Map<Id,Payment_Decision__c> newSosMap = new Map<Id,Payment_Decision__c>{recordId => newP};
        mockUserInfoService.setup('getCurrentUserId').returns(userId);
        mockUserInfoService.setup('isSystemAdministrator', new List<object>{userId}).returns(true);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,selectPermission}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<object>{userId,opsAdminPermission}).returns(false);
        Date dt = Date.newInstance(2021,1,2);
        mockSystem.setup('today').returns(dt);


        sut.bulkbeforeUpdate(oldSos, newSosMap);

        System.assertEquals('test-2', ((Payment_Decision__c)newSosMap.get(recordId)).Action__c);
    
    }

    @IsTest
    private static void integration_test(){
        Payment_Decision__c p = new Payment_Decision__c();
        insert p;
        update p;
    } 
}