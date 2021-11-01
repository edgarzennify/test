@IsTest
private class AccountTeamHelperTests {
    static testMethod void verifyValidationForRelatedEntities(){
     	TestUtilities.createLoanAppStages();
     	TestUtilities.createValidationRules();

        System.debug('#################' + 'START: ' + 'verifyValidationForRelatedEntities()');
        EB_Unit__c branch = ObjectFactory.getUnit('testBranch', 4001);
        EB_Team_Member__c teamRM = ObjectFactory.getTeamMember('Team1');
        Id ClientRecordTypeId = Utility.recordTypeObject('Account', 'Client').Id;
        
        //Parent insert
        Account leadEntity  = ObjectFactory.getEntity('Test account 1', ClientRecordTypeId, teamRM);
        leadEntity.EB_UnitId__c = branch.Id;
        
        leadEntity.OFAC_Verified__c = null;// this will cause a validation error (which is what we want)
        leadentity.State_Of_Incorporation__c = 'MO';
        leadentity.Net_Worth__c = 1;
        leadentity.Liquid_Assets__c = 2;
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        leadentity.Last_Financial_Statement__c = d;
        leadentity.Tax_Returns__c = 'Yes';
        leadentity.Annual_Financial_Statements__c = 'No';
        leadentity.Interim_Statements__c = 'Monthly';
        
        leadentity.BillingStreet = '1647 Sauget Business st';
        leadentity.BillingCity = 'Sauget';
        leadentity.BillingStreet = '111 street';
        leadentity.BillingState = 'MO';
        leadentity.BillingPostalCode = '60000';
        leadentity.Phone = '6183371700';
        leadentity.SSNTIN_Encrypted__c = '000000000';
        leadentity.SSN_TIN_Has_Value__c = true;
        leadentity.Reg_O_Qualifications__c = 'Not Applicable';
        update leadEntity;
        //Account testAccount = [SELECT SSN_TIN_Has_Value__c FROM Account WHERE id =:leadentity.id limit 1];
        //system.debug('#################SSN' + leadentity.SSN_TIN_Has_Value__c);
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Accouny','12345',leadEntity);
        EB_Loan_Packet__c packet = ObjectFactory.getLoanPacket(leadEntity);     
        
        //Child inserts
        EB_Loan_App_Entity_Relationship__c lastRel = new EB_Loan_App_Entity_Relationship__c();
        for(integer i = 0;i<4;i++){
            EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(packet,null,'12345' + String.valueOf(i));
            EB_Loan_App_Entity_Relationship__c rel = Objectfactory.getLoanAppEntityRelationship(leadEntity, loanApp);
             System.debug('################# ' + string.valueof(i)+ ' : ' + rel.id);
             EB_Loan_App_Entity_Relationship__c testrel = [select id,Missing_Required_For_Doc_Fields__c,Missing_Required_For_Approval_Fields__c,Missing_Required_Fields_Description__c FROM EB_Loan_App_Entity_Relationship__c WHERE id =:rel.id limit 1 ];
            System.debug('#################' + testrel.Missing_Required_Fields_Description__c);
            lastRel = testrel;
        }
        EB_Loan_App_Entity_Relationship__c testrel1 = [select id,Missing_Required_For_Doc_Fields__c,Missing_Required_For_Approval_Fields__c,Missing_Required_Fields_Description__c FROM EB_Loan_App_Entity_Relationship__c WHERE id =:lastRel.id limit 1 ];
        
        //Assert 1
        System.assertNotEquals(testrel1.Missing_Required_Fields_Description__c, '');
        
        leadEntity.OFAC_Verified__c = 'No';
        test.startTest();
        update leadEntity;
        test.stopTest();
        Account test2Entity = [SELECT OFAC_Verified__c FROM Account WHERE id=:leadentity.id];
        
        EB_Loan_App_Entity_Relationship__c testrel11 = [select id,Missing_Required_For_Doc_Fields__c,Missing_Required_For_Approval_Fields__c FROM EB_Loan_App_Entity_Relationship__c WHERE id =:lastRel.id limit 1 ];
        EB_Loan_App_Entity_Relationship__c testrel12 = [select id,Missing_Required_For_Doc_Fields__c,Missing_Required_For_Approval_Fields__c,Missing_Required_Fields_Description__c FROM EB_Loan_App_Entity_Relationship__c WHERE id =:lastRel.id limit 1 ];
        
        //Assert 2
        System.assertEquals(testrel12.Missing_Required_Fields_Description__c, null); //formula evaluates '' as null
        
        System.debug('#################' + testrel11.Missing_Required_For_Approval_Fields__c);
        System.debug('#################' + testrel11.Missing_Required_For_Doc_Fields__c);  
        System.debug('#################' + testrel12.Missing_Required_Fields_Description__c);
        System.debug('#################' + 'END: ' + 'verifyValidationForRelatedEntities()');       
    }
    
    static testMethod void verifyAccountTeamTriggerCode(){
	           
          Id record_typeProspectId = Utility.recordTypeObject('Account', 'Prospect').Id;
          Id record_typeClientId = Utility.recordTypeObject('Account', 'Client').Id;
          Id record_typetmId = Utility.recordTypeObject('Treasury_Management__c', 'ACH').Id;
          Id record_typepipelineId =  Utility.recordTypeObject('Opportunity', 'Consumer').Id;
          
          EB_Unit__c branch = ObjectFactory.getUnit('testBranch', 4001);
          EB_Team_Member__c teamRM = ObjectFactory.getTeamMember('Team1');
          
          //Parent insert
          Account leadEntity  = ObjectFactory.getEntity('Test account 1', record_typeClientId, teamRM);
          leadEntity.EB_UnitId__c = branch.Id;
          
          leadEntity.OFAC_Verified__c = 'No';
          leadentity.State_Of_Incorporation__c = 'MO';
          leadentity.Net_Worth__c = 1;
          leadentity.Liquid_Assets__c = 2;
          Datetime dT = System.now();
          Date d = date.newinstance(dT.year(), dT.month(), dT.day());
          leadentity.Last_Financial_Statement__c = d;
          leadentity.Tax_Returns__c = 'Yes';
          leadentity.Annual_Financial_Statements__c = 'No';
          leadentity.Interim_Statements__c = 'Monthly';
          
          leadentity.BillingStreet = '1647 Sauget Business st';
          leadentity.BillingCity = 'Sauget';
          leadentity.BillingStreet = '111 street';
          leadentity.BillingState = 'MO';
          leadentity.BillingPostalCode = '60000';
          leadentity.Phone = '6183371700';
          leadentity.SSNTIN_Encrypted__c = '000000000';
          leadentity.SSN_TIN_Has_Value__c = true;
          leadentity.Reg_O_Qualifications__c = 'Not Applicable';
          leadentity.RecordTypeId = record_typeProspectId;
          leadentity.Team_Private_Banker__c = teamRM.Id;
          test.startTest();
          update leadEntity;
          //Account testAccount = [SELECT SSN_TIN_Has_Value__c FROM Account WHERE id =:leadentity.id limit 1];
          //EB_Team_Member__c ebTeamMember = [SELECT id, User__c FROM EB_Team_Member__c WHERE Name =: 'Mark Lawson' limit 1 ];
          EB_Team_Member__c ebTeamMember = new EB_Team_Member__c(Name='Mark Lawson');
          insert ebTeamMember;
          leadentity.Team_Private_Banker__c = ebTeamMember.id;
          leadentity.Team_Relationship_Manager__c = ebTeamMember.id;
          leadentity.Team_Treasury_Management_Representative__c = ebTeamMember.id;
          leadentity.Team_Wealth_Management_Advisor__c = ebTeamMember.id;
          
          update leadentity;
          test.stopTest();	
	}
    
    static testMethod void it_should_update_unittext_field_on_packet_when_a_entity_is_updated(){
        TestUtilities.createLoanAppStages();
        Id record_typeClientId = Utility.recordTypeObject('Account', 'Client').Id;
        EB_Unit__c branch = ObjectFactory.getUnit('testBranch', 4001);
        EB_Team_Member__c teamRM = ObjectFactory.getTeamMember('Team1');
        Account leadEntity  = ObjectFactory.getEntity('Test account 1', record_typeClientId, teamRM);        leadEntity.EB_UnitID__r = branch;
        leadEntity.EB_UnitID__c = branch.Id;
        update leadEntity;
        Account requeryEntity = [SELECT  EB_UnitID__r.Name , EB_UnitID__c FROM Account WHERE id =:leadEntity.Id];

        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Accouny','12345',requeryEntity);
        EB_Loan_Packet__c packet = ObjectFactory.getLoanPacket(requeryEntity);     
        EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(packet,null,'12345');
        
        //New Entity is created followed by new packet and loan app
        EB_Loan_Packet__c requerypacket = [SELECT Id, Unit_Text__c FROM EB_Loan_Packet__c WHERE id =:packet.Id];
        EB_Loan_Application__c requeryLoanApp = [SELECT unit__c FROM EB_Loan_Application__c WHERE id =:loanApp.Id];
        system.assertEquals('testBranch', branch.Name);
        system.assertEquals('testBranch', requeryEntity.EB_UnitID__r.Name);
        system.assertEquals('testBranch', requerypacket.Unit_Text__c);
        system.assertEquals('testBranch', requeryLoanApp.Unit__c);
        
        //Existing entity is updated with a different branch
        branch = ObjectFactory.getUnit('testBranch1', 4002);
        leadEntity.EB_UnitID__r = branch;
        leadEntity.EB_UnitID__c = branch.Id;
        update leadEntity;
        
        requeryEntity = [SELECT  EB_UnitID__r.Name , EB_UnitID__c FROM Account WHERE id =:leadEntity.Id];
        requerypacket = [SELECT Id, Unit_Text__c FROM EB_Loan_Packet__c WHERE id =:packet.Id];
        requeryLoanApp = [SELECT unit__c FROM EB_Loan_Application__c WHERE id =:loanApp.Id];
        system.assertEquals('testBranch1', branch.Name);
        system.assertEquals('testBranch1', requeryEntity.EB_UnitID__r.Name);
        system.assertEquals('testBranch1', requerypacket.Unit_Text__c);
        system.assertEquals('testBranch1', requeryLoanApp.Unit__c);           
    }

    static testMethod void it_should_update_RM_with_associate_director_id_of_the_record_owner_for_prospect(){
              
        TestUtilities.createLoanAppStages();
        Id record_typeClientId = Utility.recordTypeObject('Account', 'Prospect').Id;
        EB_Unit__c branch = ObjectFactory.getUnit('testBranch', 4001);

        User user1 = ObjectFactory.getUser('test5', 'user1', 'user1@enterprisebankstl.sfdc.test', true);
        User user2 = ObjectFactory.getUser('test7', 'user2', 'user2@enterprisebankstl.sfdc.test', true);
        EB_Team_Member__c teamRM1 = ObjectFactory.getTeamMember('TeamRM1');
        teamRM1.User__c=user1.Id;
        update teamRM1;

        Account entity  = ObjectFactory.getEntity('Test account 1', record_typeClientId, teamRM1);
     
        EB_Team_Member__c teamRM2 = ObjectFactory.getTeamMember('TeamRM2');
        teamRM2.User__c=user2.Id;
        update teamRM2;

        entity.OwnerId = user2.Id;
        update entity;

        Account requeryEntity = [SELECT  Team_Relationship_Manager__c , Id FROM Account WHERE id =:entity.Id];

        system.assertEquals(teamRM2.Id, requeryEntity.Team_Relationship_Manager__c);  

    }

     static testMethod void it_should_update_RM_with_associate_director_id_of_the_record_owner_for_client(){
       
        TestUtilities.createLoanAppStages();
        Id record_typeClientId = Utility.recordTypeObject('Account', 'Client').Id;
        EB_Unit__c branch = ObjectFactory.getUnit('testBranch', 4001);

        User user1 = ObjectFactory.getUser('test5', 'user1', 'user1@enterprisebankstl.sfdc.test', true);
        User user2 = ObjectFactory.getUser('test7', 'user2', 'user2@enterprisebankstl.sfdc.test', true);
        EB_Team_Member__c teamRM1 = ObjectFactory.getTeamMember('TeamRM1');
        teamRM1.User__c=user1.Id;
        update teamRM1;

        Account entity  = ObjectFactory.getEntity('Test account 1', record_typeClientId, teamRM1);
     
        EB_Team_Member__c teamRM2 = ObjectFactory.getTeamMember('TeamRM2');
        teamRM2.User__c=user2.Id;
        update teamRM2;

        entity.OwnerId = user2.Id;
        update entity;

        Account requeryEntity = [SELECT  Team_Relationship_Manager__c , Id FROM Account WHERE id =:entity.Id];

        system.assertEquals(teamRM2.Id, requeryEntity.Team_Relationship_Manager__c);  

    }
}