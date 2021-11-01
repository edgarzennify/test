@isTest
public with sharing class TestEntityNewRedirectCont 
{
    static testMethod void testConstructor()
    {
        String accRecTypeId = [select Id from RecordType where SObjectType = 'Account' AND DeveloperName = 'Prospect'].Id;

        Account acc = new Account();
        acc.RecordTypeId = accRecTypeId;
        acc.Name = 'Test Acc';
        insert acc;
        
        ApexPages.StandardController std = new ApexPages.StandardController(acc);
        EntityNewRedirectCont enrc = new EntityNewRedirectCont(std);
        System.assertEquals(acc.Id, enrc.acct.Id);

    }
    
    static testMethod void testAllowedNewEntity()
    {
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User ADMIN_USER = [Select Id from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
        
        
        String accRecTypeId = [select Id from RecordType where SObjectType = 'Account' AND DeveloperName = 'Prospect'].Id;

        Account acc = new Account();
        acc.RecordTypeId = accRecTypeId;
        acc.Name = 'Test Acc';
        insert acc;
        
        System.runAs(ADMIN_USER)
        {
            ApexPages.StandardController std = new ApexPages.StandardController(acc);
            EntityNewRedirectCont enrc = new EntityNewRedirectCont(std);
            
            System.debug('RETURNED URL: ' + enrc.notAllowedToCreateEntities().getUrl());
            
            //System Admins are redirected to the Account edit page
            System.assertEquals('/001/e?nooverride=1&RecordType=null', enrc.notAllowedToCreateEntities().getUrl());
        }
    }
    
    static testMethod void testRestrictedNewEntity()
    {
        Id TEST_PROFILE_ID = [ SELECT Id FROM Profile Where Name = 'EB Base User' ].Id;
        Id RW_ACCT_PERMISSION_ID = [SELECT Id FROM PermissionSet WHERE Name = 'Function_Entity_ReadWrite_Acct_Read'].Id;
        User TEST_USER = [Select Id from User where ProfileId = :TEST_PROFILE_ID and IsActive = true and Id in (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId =: RW_ACCT_PERMISSION_ID) LIMIT 1];
        System.debug('TEST USING USER: ' + TEST_USER.Id);
        
        String accRecTypeId = [select Id from RecordType where SObjectType = 'Account' AND DeveloperName = 'Prospect'].Id;

        Account acc = new Account();
        acc.RecordTypeId = accRecTypeId;
        acc.Name = 'Test Acc';
        insert acc;
        
        System.runAs(TEST_USER)
        {
            ApexPages.StandardController std = new ApexPages.StandardController(acc);
            EntityNewRedirectCont enrc = new EntityNewRedirectCont(std);
            
            System.debug('RETURNED URL: ' + enrc.notAllowedToCreateEntities().getUrl());
            
            //User without the permission set are redirected to the EntityNewRestricted page
            System.assertEquals('/apex/entitynewrestricted', enrc.notAllowedToCreateEntities().getUrl());
        }
    }
}