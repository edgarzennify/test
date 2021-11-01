@isTest
public class ObjectFactory {   
    
    private static Integer RandomNumber(Integer lower, Integer upper){
        return Math.round(Math.random() * (upper - lower)) + lower;
    }

    private static String uniqueTeamMemberName(){
        return String.valueof(RandomNumber(10000000, 99999999)).left(8);
    }

    // Dates    
    public static Date getDate(){
        Datetime dT = System.now();
        return getDate(dT.year(), dT.month(), dT.day());
    }

    public static Date getDate(Integer year, Integer month, Integer day){
        Date d = date.newinstance(year,month,day);
        return d;
    }

    public static Id getFakeId(Schema.SObjectType objectType, String postfix){
        String keyPrefix = objectType.getDescribe().getKeyPrefix();
        String basePostfix = '000000000000';
        String keyPostfix = basePostfix.substring(postfix.length()) + postfix;
        return keyPrefix + keyPostfix;
    }

    // Record Type
    public static Id getRecordTypeIdByNameAndObject(String RecordTypeName, String SobjectType){
        List<RecordType> recordTypeList = utility.recordTypeMap.get(SobjectType);       
        for (RecordType r : recordTypeList){
            if(r != null){
                if(r.Name == RecordTypeName) return r.Id;
            }
        }
        system.debug('#####ObjectFactory.getRecordTypeIdByNameAndObject');
        return null;
    }

    public static RecordType getRecordTypeObjByNameAndObject(String RecordTypeName, String SobjectType){
        List<RecordType> recordTypeList = utility.recordTypeMap.get(SobjectType);
        for (RecordType r : recordTypeList){
            if(r != null){
                if(r.Name == RecordTypeName) return r;
            }
        }
        system.debug('#####ObjectFactory.getRecordTypeObjByNameAndObject');
        return null;
    }

    public static Map<id,RecordType> getRecordTypeMap(String SObjectType){
        Map<Id,RecordType>recMap = new Map<Id,RecordType>();
        for(RecordType rt : utility.recordTypeMap.get(SobjectType)){
            recMap.put(rt.Id,rt);
        }
        return recMap;
    }
    
    // Branch
    public static EB_Unit__c getUnit(String name, Integer branchCode){
         EB_Unit__c unit = (EB_Unit__c)SmartFactory.createSObject('EB_Unit__c');
         unit.Name = name;
         unit.Branch_Number__c = branchCode;
         unit.Unit_Reporting_Label__c = 'test report label';
         unit.Phone_Number__c = '123-123-1234';
         insert unit;
         return unit; 
    }
    
    public static EB_Unit__c getUnit(String name, Integer branchCode, String centerNumber){
         EB_Unit__c unit = (EB_Unit__c)SmartFactory.createSObject('EB_Unit__c');
         unit.Name = name;
         unit.Branch_Number__c = branchCode;
         unit.Center__c = centerNumber;
         unit.Unit_Reporting_Label__c = 'test report label';
         unit.Phone_Number__c = '123-123-1234';
         insert unit;
         return unit; 
    }
    
    // EB Account
    public static EB_Account__c getEBAccount(String accountTitle,String accountNumber,Account leadEntity){
        EB_Account__c newObj = (EB_Account__c)SmartFactory.createSObject('EB_Account__c');
        
        newObj.Account_Line_1__c = accountTitle;
        newObj.Account_Number__c = accountNumber;
        newObj.Primary_Owner_Id__c = leadEntity.Id;
        newObj.EB_Unit__c = getUnit('Test', 4001).Id;
        newObj.Account_Status__c = 'A';
        newObj.Application__c = 15;
        insert newObj;
        return newObj;
    }

    public static EB_Account__c getEBAccountWithoutInsert(String accountTitle,String accountNumber,Account leadEntity){
        EB_Account__c newObj = (EB_Account__c)SmartFactory.createSObject('EB_Account__c');
        
        newObj.Account_Line_1__c = accountTitle;
        newObj.Account_Number__c = accountNumber;
        newObj.Primary_Owner_Id__c = leadEntity.Id;
        newObj.EB_Unit__c = getUnit('Test', 4001).Id;
        newObj.Account_Status__c = 'A';
        newObj.Application__c = 15;
        return newObj;
    }

    public static EB_Account__c getEBAccount(String accountTitle,String accountNumber,Account leadEntity,EB_Team_Member__c relationshipManager){
        EB_Account__c newObj = (EB_Account__c)SmartFactory.createSObject('EB_Account__c');
        
        newObj.Account_Line_1__c = accountTitle;
        newObj.Account_Number__c = accountNumber;
        newObj.Primary_Owner_Id__c = leadEntity.Id;
        newObj.EB_Unit__c = getUnit('Test', 4001).Id;
        newObj.Account_Status__c = 'A';
        newObj.Application__c = 15;
        newObj.EB_Team_Member__r = relationshipManager;
        newObj.EB_Team_Member__c = relationshipManager.Id;
        insert newObj;
        return newObj;
    }

    public static EB_Account__c getOREOAccount(String accountTitle, String accountNumber){
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember(uniqueTeamMemberName());
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount(accountTitle,accountNumber, newEntity);
        newEBAccount.recordtypeId = Utility.recordTypeObject('EB_Account__c', 'OREO').Id;
        newEBAccount.OREO_FDIC_Reference_Number__c = '0000000000000';
        update newEBAccount;
        return newEBAccount;
    }
    
    public static EB_Account__c getTrustEBAccount(String accountTitle,String accountNumber,Account leadEntity){
        EB_Account__c newObj = (EB_Account__c)SmartFactory.createSObject('EB_Account__c');
        
        newObj.Account_Line_1__c = accountTitle;
        newObj.Account_Number__c = accountNumber;
        newObj.Primary_Owner_Id__c = leadEntity.Id;
        newObj.EB_Unit__c = getUnit('Test', 4001).Id;
        newObj.Account_Status__c = 'A';
        newObj.Application__c = 1;
        newObj.recordtypeId = Utility.recordTypeObject('EB_Account__c', 'Wealth Management').Id;
        insert newObj;
        return newObj;
    }
    
    public static EB_Account__c getAccount(String accountTitle, String accountNumber){
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember(uniqueTeamMemberName());
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount(accountTitle,accountNumber, newEntity);
        newEBAccount.recordtypeId = Utility.recordTypeObject('EB_Account__c', 'Loan').Id;
        update newEBAccount;
        return newEBAccount;
    }

    public static AccountTeamMember getAccountTeam(Account entity){
        AccountTeamMember atm = new AccountTeamMember();
        atm.AccountId = entity.Id;
        insert atm;
        return atm;
    }

    public static EB_Loan_Packet__c getLoanPacket(Account leadEntity){
        return getLoanPacket(leadEntity,true);
    }
    
    public static EB_Loan_Packet__c getLoanPacket(Account leadEntity, Boolean doInsert){
        EB_Loan_Packet__c newObj = new EB_Loan_Packet__c();
        newObj.Lead_Entity__c = leadEntity.Id;
        newObj.Lead_Entity__r = leadEntity;
        if(doInsert){insert newObj;}
        return newObj;
    }
    
    public static EB_Loan_Application__c getLoanApplication(String EntityName , String EBAccountName, String EBAccountNumber ,String LoanAppName){
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember(uniqueTeamMemberName());
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');        
        Account newEntity = ObjectFactory.getEntity(EntityName,newClinetRecordTypeId, newMember);
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount(EBAccountName,EBAccountNumber, newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication(newPacket, newEBAccount, LoanAppName);
        return newLoanApplication;
    }
    
    public static EB_Loan_Application__c getLoanApplication(EB_Loan_Packet__c loanPacket,EB_Account__c ebAccount,String loanNumber){
        EB_Loan_Application__c newObj = (EB_Loan_Application__c)SmartFactory.createSObject('EB_Loan_Application__c');
        newObj.EB_Loan_Packet__c = loanPacket.Id;
        newObj.EB_Loan_Packet__r = loanPacket;
        newObj.Maturity_Term_In_Months__c = 12;
        Id newRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('New','EB_Loan_Application__c');
        if(ebAccount<>null){
            newRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Renewal','EB_Loan_Application__c');
            newObj.Account_Number__c = ebAccount.Id;
        }
        newObj.RecordTypeId = newRecordTypeId;
        newObj.Account_Number_Assigned__c = loanNumber;
        newObj.Application_Stage__c = null;
        try{
        insert newObj;
        }catch(exception ex){
            system.debug('#objfactoryapp' +ex.getmessage());
        }
        return newObj;
    }

    public static EB_Loan_Application__c getLoanApplication(EB_Loan_Packet__c loanPacket,EB_Account__c ebAccount,String loanNumber, Boolean doInsert){
        EB_Loan_Application__c newObj = (EB_Loan_Application__c)SmartFactory.createSObject('EB_Loan_Application__c');
        newObj.EB_Loan_Packet__c = loanPacket.Id;
        newObj.EB_Loan_Packet__r = loanPacket;
        newObj.Maturity_Term_In_Months__c = 12;
        Id newRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('New','EB_Loan_Application__c');
        if(ebAccount<>null){
            newRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Renewal','EB_Loan_Application__c');
            newObj.Account_Number__c = ebAccount.Id;
        }
        newObj.RecordTypeId = newRecordTypeId;
        newObj.Account_Number_Assigned__c = loanNumber;
        newObj.Application_Stage__c = null;

        if(doInsert) {insert newObj;}
        return newObj;
    }

    public static EB_Loan_Application__c getLoanApplication(EB_Loan_Packet__c loanPacket,EB_Account__c ebAccount,String loanNumber,String businessPurpose){
        EB_Loan_Application__c newObj = (EB_Loan_Application__c)SmartFactory.createSObject('EB_Loan_Application__c');
        newObj.EB_Loan_Packet__c = loanPacket.Id;
        newObj.Maturity_Term_In_Months__c = 12;
        newObj.Business_Purpose__c = businessPurpose;
        Id newRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('New','EB_Loan_Application__c');
        if(ebAccount<>null){
            newRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Renewal','EB_Loan_Application__c');
            newObj.Account_Number__c = ebAccount.Id;
        }
        newObj.RecordTypeId = newRecordTypeId;
        newObj.Account_Number_Assigned__c = loanNumber;
        newObj.Application_Stage__c = null;
        try{
        insert newObj;
        }catch(exception ex){
            system.debug('##objfactoryapp' +ex.getmessage());
        }
        return newObj;
    }

    public static List<EB_Loan_Application__c> getLoanApplications(Integer numberOfApps, EB_Loan_Packet__c loanPacket,EB_Account__c ebAccount,String loanNumber){
        List<EB_Loan_Application__c>appList = new List<EB_Loan_Application__c>();
        EB_Loan_Application__c newTemplate = (EB_Loan_Application__c)SmartFactory.createSObject('EB_Loan_Application__c');
        Id newRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('New','EB_Loan_Application__c');
        Id renewalRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Renewal','EB_Loan_Application__c');      
        try{            
            Integer appCounter = 0;
            for(appCounter=0;appCounter<numberOfApps;++appCounter){
                EB_Loan_Application__c newObj = newTemplate;
                newObj.EB_Loan_Packet__c = loanPacket.Id;
                newObj.Maturity_Term_In_Months__c = 12;             
                if(ebAccount<>null){
                    newObj.RecordTypeId = renewalRecordTypeId;
                    newObj.Account_Number__c = ebAccount.Id;
                }
                newObj.RecordTypeId = newRecordTypeId;              
                newObj.Account_Number_Assigned__c = loanNumber + String.valueOf(appCounter);        
                appList.add(newObj);
            }
            insert appList;
        }catch(exception ex){
            system.debug('#objfactoryapp' +ex.getmessage());
        }
        return appList;
    }
    
    // Team Member
    private static Map<String,User> userMap{
        get{
            if(userMap == null){
                userMap = new Map<String,User>();
            }
            return userMap;
        }
        set;
    }

    public static EB_Team_Member__c getTeamMember(String name){
        return getTeamMember(name,true);
    }

    public static EB_Team_Member__c getTeamMember(String name, Boolean doInsert){
        EB_Team_Member__c newObj = new EB_Team_Member__c();
        newObj.Name = name;
        newObj.User__r = getUser();
        newObj.User__c = newObj.User__r.Id;
        newObj.Officer_Code__c = uniqueTeamMemberName();
        if(doInsert){insert newObj;}
        return newObj;
    }

    public static EB_Team_Member__c getTeamMember(User usr, Boolean doInsert){
        EB_Team_Member__c newObj = new EB_Team_Member__c();
        newObj.Name = usr.LastName;
        newObj.User__r = usr;
        newObj.User__c = usr.Id;
        newObj.Officer_Code__c = uniqueTeamMemberName();
        if(doInsert){insert newObj;}
        return newObj;
    }

    public static Profile GetProfileByName(String profileName){
        return [SELECT Id, Name FROM Profile WHERE Name =: profileName];
    }

    public static User getUser(String userAlias){
        if(!userMap.containsKey(userAlias)){
            User usr = [SELECT Id, Name, Alias FROM User WHERE alias =: userAlias LIMIT 1];
            userMap.put(usr.Alias,usr);
        }
        return userMap.get(userAlias);
    }

    public static User getUser(){
        if(userMap.size() > 0){
            return userMap.values()[0];
        }
        User usr = [    SELECT
                            Id, Name, Alias, ProfileId, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, LanguageLocaleKey
                        FROM User 
                        WHERE IsActive=true
                        AND
                        Profile.Name IN ('System Administrator','EB Base User')
                        LIMIT 1
                    ];
        userMap.put(usr.Alias,usr);
        return usr;
    }

    public static User getUser(String firstName, String lastName, String email, Boolean doInsert){
        User someUser = ObjectFactory.getUser();
        Profile sysAdminProfile = GetProfileByName('System Administrator');
        User u = new User();
        u.Email = email;
        u.Username = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.Alias = (firstName.Left(1) + lastName).Left(7);
        u.CommunityNickname = u.Alias;
        u.TimeZoneSidKey = someUser.TimeZoneSidKey;
        u.LocaleSidKey = someUser.LocaleSidKey;
        u.EmailEncodingKey = someUser.EmailEncodingKey;
        u.ProfileId = sysAdminProfile.Id;
        u.LanguageLocaleKey = someUser.LanguageLocaleKey;
        
        if(doInsert){insert u;}
        return u;
    }
    
    // Entity
    public static Account getEntity(String name, Id recordTypeId, EB_Team_Member__c relationshipManager){
        Account newObj = (Account)SmartFactory.createSObject('Account');
        newObj.Name = name;
        newObj.RecordTypeId = recordTypeId;
        newObj.BillingStreet = '123 Test Street';
        newObj.BillingCity = 'Testville';
        newObj.BillingPostalCode = '12345';
        newObj.Team_Relationship_Manager__c = relationshipManager.Id;
        //Fields relevent to validation rules
        newObj.Net_Worth__c = 757834;
        newObj.OFAC_Verified__c = 'Yes';
        newObj.Liquid_Assets__c = 107143;
        newObj.Tax_Returns__c = 'Yes';
        newObj.Tax_Return_Days_Due_After_Filing__c = 90;
        newObj.Tax_Include_in_Loan_Agreement__c = 'No';
        newObj.Annual_Financial_Statements__c = 'No';
        newObj.Annual_Statement_Quality__c = null;
        newObj.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = 0;
        newObj.Annual_Stmt_Include_in_Loan_Agreement__c = null;
        newObj.Interim_Statements__c = 'Quarterly';
        newObj.Interim_Stm_Prepared_By__c = 'Prepared by Borrower';
        newObj.Interim_Stmt_Days_Due_After_Period_End__c = 60;
        newObj.Interim_Stmt_Include_in_Loan_Agreement__c = 'No';
        newObj.Reg_O_Qualifications__c = null;
        newObj.Reg_O_Foreign_Insitution__c = null;
        newObj.Reg_O_Foreign_Insitution_Title__c = null;
        newObj.BillingCountry = 'test country';
        insert newObj;
        return newObj;
    } 

    public static Account getValidEntity(String name){
        Account newObj = (Account)SmartFactory.createSObject('Account');
        newObj.Name = name;
        //Fields relevent to validation rules
        newObj.Reg_O_Qualifications__c = null;
        newObj.Reg_O_Foreign_Insitution__c = null;
        newObj.Reg_O_Foreign_Insitution_Title__c = null;
        newObj.BillingCountry = 'test country';
        insert newObj;
        return newObj;
    }

    public static void relateEntityToLoanApp(Account entity, EB_Loan_Application__c loanApp){
        EB_Loan_App_Entity_Relationship__c newObj = new EB_Loan_App_Entity_Relationship__c();
        newObj.Entity_Name__c = entity.Id;
        newObj.Loan_Application_ID__c = loanApp.Id;
        newObj.Relationship_Type__c = 'Co-Borrower';
        newObj.Limited_or_Unlimited__c = 'No';
        newObj.Limitation__c = 2000;
        newObj.Loan_App_Net_Worth__c = 3000;
        insert newObj;
    }

    public static EB_Loan_App_Entity_Relationship__c getLoanAppEntityRelationship(Account entity, EB_Loan_Application__c loanApp){
        EB_Loan_App_Entity_Relationship__c newObj = new EB_Loan_App_Entity_Relationship__c();
        newObj.Entity_Name__c = entity.Id;
        newObj.Loan_Application_ID__c = loanApp.Id;
        newObj.Relationship_Type__c = 'Co-Borrower';
        newObj.Limited_or_Unlimited__c = 'No';
        newObj.Limitation__c = 2000;
        newObj.Loan_App_Net_Worth__c = 3000;
        insert newObj;
        return newObj;
    }

    public static void relateEntityToEBAccount(Account entity, EB_Account__c ebAccount){
        EB_Account_Relationship__c newObj = new EB_Account_Relationship__c();
        newObj.Client_Id__c = entity.Id;
        newObj.EB_Account_Id__c = ebAccount.Id;
        newObj.Relationship__c = 'Primary Owner';
        insert newObj;
    }

    public static EB_Account_Relationship__c relateEntityToEBAccountObj(Account entity, EB_Account__c ebAccount){
        EB_Account_Relationship__c newObj = new EB_Account_Relationship__c();
        newObj.Client_Id__c = entity.Id;
        newObj.EB_Account_Id__c = ebAccount.Id;
        newObj.Relationship__c = 'Primary Owner';
        insert newObj;
        return newObj;
    }
    
    // Collateral
    public static EB_Collateral__c getCollateral(String description, Boolean bExisting){
        Collateral_Code__c testCollateralCode = ObjectFactory.getCollateralCode('test ccode', '4000');
        EB_Collateral__c testEBCollateral = ObjectFactory.getCollateral(description, testCollateralCode , bExisting);
        return testEBCollateral;
    }

    public static EB_Collateral__c getCollateral(String description, Collateral_Code__c collateralCode, Boolean bExisting){
        EB_Collateral__c newObj = new EB_Collateral__c();
        newObj.Name = description;
        if(bExisting==true){
            newObj.Key__c = '123';
        }
        newObj.Collateral_Code__c = collateralCode.Id;
        insert newObj;
        return newObj;
    }

    public static Collateral_Code__c getCollateralCode(String name, String collateralCode){
        Collateral_Code__c newObj = new Collateral_Code__c();
        newObj.Name = name;
        newObj.Collateral_Code_ID__c = collateralCode;
        insert newObj;
        return newObj;
    }
    
    public static LLC_BI__Collateral_Type__c getNcinoCollateralCode(String name, String collateralCode){
        LLC_BI__Collateral_Type__c newObj = new LLC_BI__Collateral_Type__c();
        newObj.Name = name;
        newObj.LLC_BI__Collateral_Code__c = collateralCode;
        insert newObj;
        return newObj;
    }
    
    public static void relateCollateralToLoanApp(EB_Collateral__c collateral, EB_Loan_Application__c loanApp, Id recordTypeId){
        EB_Loan_App_Collateral_Relationship__c newObj = new EB_Loan_App_Collateral_Relationship__c();
        newObj.EB_Collateral_ID__c = collateral.Id;
        newObj.EB_Loan_Application_ID__c = loanApp.Id;
        newObj.RecordTypeId = recordTypeId;
        newObj.Purpose_of_Collateral__c = 'Additional';
        newObj.Abundance_of_Caution__c = 'No';
        insert newObj;
    }

    public static EB_Loan_App_Collateral_Relationship__c relateCollateralToLoanAppObj(EB_Collateral__c collateral, EB_Loan_Application__c loanApp, Id recordTypeId){
        EB_Loan_App_Collateral_Relationship__c newObj = new EB_Loan_App_Collateral_Relationship__c();
        newObj.EB_Collateral_ID__c = collateral.Id;
        newObj.EB_Loan_Application_ID__c = loanApp.Id;
        newObj.RecordTypeId = recordTypeId;
        newObj.Purpose_of_Collateral__c = 'Additional';
        newObj.Abundance_of_Caution__c = 'No';
        insert newObj;
        return newObj;
    }

    public static EB_Loan_App_Collateral_Relationship__c relateCollateralToLoanAppreturnObj(EB_Collateral__c collateral, EB_Loan_Application__c loanApp, Id recordTypeId){
        EB_Loan_App_Collateral_Relationship__c newObj = new EB_Loan_App_Collateral_Relationship__c();
        newObj.EB_Collateral_ID__c = collateral.Id;
        newObj.EB_Loan_Application_ID__c = loanApp.Id;
        newObj.RecordTypeId = recordTypeId;
        newObj.Purpose_of_Collateral__c = 'Additional';
        newObj.Abundance_of_Caution__c = 'No';
        insert newObj;
        return newObj;
    }

    public static void relateCollateralToEBAccount(EB_Collateral__c collateral, EB_Account__c ebAccount){
        EB_Collateral_Account_Relationship__c newObj = new EB_Collateral_Account_Relationship__c();
        newObj.EB_Collateral_ID__c = collateral.Id;
        newObj.EB_Account_ID__c = ebAccount.Id;
        insert newObj;
    }

    public static void relateCollateralToEntity(EB_Collateral__c collateral, Account entity){
        EB_Collateral_Client_Relationship__c newObj = new EB_Collateral_Client_Relationship__c();
        newObj.EB_Collateral_ID__c = collateral.Id;
        newObj.Client_ID__c = entity.Id;
        insert newObj;
    }

    public static EB_Collateral_Client_Relationship__c relateCollateralToEntityObj(EB_Collateral__c collateral, Account entity){
        EB_Collateral_Client_Relationship__c newObj = new EB_Collateral_Client_Relationship__c();
        newObj.EB_Collateral_ID__c = collateral.Id;
        newObj.Client_ID__c = entity.Id;
        insert newObj;
        return newObj;
    }
    
    public static Board__c getBoard(String name){
        Board__c newObj = new Board__c(  
            Name = name         
        );
        insert newObj;
        return newObj;
    }

    public static Board_Meeting__c getBoardMeeting(Id boardId){
        Board_Meeting__c newObj = new Board_Meeting__c(
            Board__c = boardId,
            Date__c = getDate()
            );
        insert newObj;
        return newObj;
    }

    public static Board_Director_Association__c getBoardMembership(Id directorId, Id boardId, String compType, String role){
        Board_Director_Association__c newObj = new Board_Director_Association__c(
                        EB_Team_Member__c = directorId,
                        Compensation_Type__c = compType,
                        Date_Elected__c = getDate(),
                        Role__c = role,
                        Board__c = boardId

        );
        insert newObj;
        return newObj;      
    }

    public static Board_Meeting_Attendance__c getBoardMeetingAttendance(Id directorId, Id boardMtngId, String attMtng, String howAtt, string compType){
        Board_Meeting_Attendance__c newObj = new Board_Meeting_Attendance__c(
            Board_Meeting__c = boardMtngId,
            Attended_Meeting__c = attMtng,
            How_Attended__c = howAtt,
            Associate_Director__c = directorId,
            Compensation_Type__c = compType         
                    
        );
        insert newObj;
        return newObj;  
    }
    
    public static Charge_Off_Recovery__c getChargeOffRecoveryObj(Id recordtypeId, Id ebaccountid){
        Charge_Off_Recovery__c  newObj = (Charge_Off_Recovery__c)SmartFactory.createSObject('Charge_Off_Recovery__c'); 
        newObj.RecordTypeId = recordtypeId;
        newObj.EB_Account__c = ebaccountid;
        insert newObj;
        return newObj;
    }

    public static EB_Loan_Action__c getAccountActionObj(EB_Account__c ebaccount, RecordType recordtype){
        EB_Loan_Action__c  newObj = (EB_Loan_Action__c)SmartFactory.createSObject('EB_Loan_Action__c');
        newObj.RecordTypeId = recordtype.id;
        ebaccount.Account_Status__c = 'A';
        ebaccount.Application__c = 15;           
        ebaccount.Unadvanced_Loan_Amount__c = 1000000;
        update ebaccount;
        newObj.EB_Account__c = ebaccount.id; 
        insert newObj;
        return newObj;
    }

    public static EB_Loan_Action__c getAccountActionObj(){
        EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);  
            Id recoveryId = objectFactory.getRecordTypeIdByNameAndObject('Recovery', 'EB_Loan_Action__c');
            Id chargeOffId = objectFactory.getRecordTypeIdByNameAndObject('Charge-Off', 'EB_Loan_Action__c');
                
            EB_Team_Member__c team = objectFactory.getTeamMember(uniqueTeamMemberName());
            Integer numEntities = 1;
            Integer numCollateral = 50;
            Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
            Id ProspectRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
            Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
            List<EB_Account__c> accounts = new List<EB_Account__c>();
            
            EB_Account__c ebaccount = ObjectFactory.getEBAccount('Account Title', '11120300-15', leadEntity);
             ebaccount.EB_Unit__c = branch.Id;
             ebaccount.Account_Status__c = 'A';
             ebaccount.Application__c = 15;
             ebaccount.Unadvanced_Loan_Amount__c = 1000000;
            update ebaccount;
            EB_Account__c offsetAcct = (EB_Account__c)SmartFactory.createSObject('EB_Account__c');
            offsetAcct.Account_Line_1__c = 'Test';
            offsetAcct.Account_Status__c = 'A';
            offsetAcct.Account_Number__c = '10120300';
            offsetAcct.Primary_Owner_Id__c = leadEntity.Id;
            offsetAcct.EB_Unit__c = objectfactory.getUnit('Test', 4001).Id;
            offsetAcct.name = '10120300-GL';
            insert offsetAcct;
          
            EB_Account__c offset_Account = ObjectFactory.getEBAccount('10120300-GL', '10120300', leadEntity);
            offset_Account.Account_Status__c = 'A';
            
            update offset_Account;
            //Loan Transaction
           
            Borrowing_Base__c bb = new Borrowing_Base__c();
            bb.Loan_Number__c =ebaccount.id;
            insert bb;
            Borrowing_Base_Collateral__c bbc = new Borrowing_Base_Collateral__c();
            bbc.Borrowing_Base_Report__c = bb.id;
            bbc.Advance_Rate__c = 70;
            bbc.Eligible_Amount__c=100000;
            bbc.Details__c = 'This is only a test.';
            insert bbc;
            system.debug('##Total'  +string.valueof(bb.Total_Availability_Transition__c));
           
            RecordType rectype = ObjectFactory.getRecordTypeObjByNameAndObject('Loan Debit', 'EB_Loan_Action__c');
            EB_Loan_Action__c  newObj = (EB_Loan_Action__c)SmartFactory.createSObject('EB_Loan_Action__c');
            newObj.EB_Account__c = ebaccount.id;
            newObj.RecordTypeId = rectype.id;
            newObj.Transaction_Type__c = 'Loan Advance';
            datetime dT = system.now();
            Date d = date.newinstance(dT.year(), dT.month(), dT.day());
            newObj.Transaction_Effective_Date__c = d;
            newObj.Wire_Transaction__c = 'No';
            newObj.Offset_Account__c = offsetAcct.id;
            newObj.center_Num__c = '2001';
            User u = getUser('phoban');//[SELECT Id FROM User WHERE alias =: 'phoban' limit 1];
            newObj.Transaction_Amount__c = 1000;    
            newObj.Transaction_Approver__c = u.id;
            insert newObj;
            return newObj;
    }

    public static List<EB_Loan_Action__c> getAccountActionObj(EB_Account__c ebaccount, RecordType recordtype,Integer numOfActionObjsRequired){
        ebaccount.Account_Status__c = 'A';
        ebaccount.Application__c = 15;           
        ebaccount.Unadvanced_Loan_Amount__c = 1000000;
        update ebaccount;
        List<EB_Loan_Action__c> insertActionList = new List<EB_Loan_Action__c>();
        for(Integer i=0; i<numOfActionObjsRequired; i++){
            EB_Loan_Action__c  newObj = new EB_Loan_Action__c(RecordTypeId = recordtype.id,EB_Account__c = ebaccount.id,Comments__c = String.ValueOf(i) );
            insertActionList.add(newObj);
        }
        System.assertEquals(numOfActionObjsRequired, insertActionList.size());
        insert insertActionList;
        return insertActionList;
    }

    public static Borrowing_Base__c getBorrowingBaseReportObj(Account entity, EB_Account__c ebaccount){
        Borrowing_Base__c  newObj = (Borrowing_Base__c)SmartFactory.createSObject('Borrowing_Base__c');
        newObj.Account__c = entity.id;
        newObj.Loan_Number__c = ebaccount.id; 
        insert newObj;
        return newObj;
    }

    public static Borrowing_Base_Collateral__c getBorrowingBaseCollateral(Borrowing_Base__c borrowingbase){
        Borrowing_Base_Collateral__c  newObj = (Borrowing_Base_Collateral__c)SmartFactory.createSObject('Borrowing_Base_Collateral__c');
        newObj.Borrowing_Base_Report__c = borrowingbase.id;     
        insert newObj;
        return newObj;
    }

    public static EB_Appraisal_County__c getEbAppraisalCounty(String countyname){
        EB_Appraisal_County__c county = new EB_Appraisal_County__c();
        county.County_FIPS__c = 5;
        county.FIPS_Class__c = 'NA';
        county.Name = countyname;
        county.State__c = 'MO';
        insert county;
        return county;
    }

    //Agreement
    public static Agreement__c getAgreement(string agreementStatus, string primaryBorrower, string comments){
        Agreement__c newObj = new Agreement__c();
        newObj.Agreement_Status__c = agreementStatus;
        newObj.Primary_Borrower__c = primaryBorrower;
        newObj.Comments__c = comments;
        insert newObj;
        system.debug('### Agreement - new Agreement is created');
        return newObj;
    }
    
    //AgreementClientRelationship
    public static Agreement_Client_Relationships__c getAgreementClientRelationships(string borrowerRel, Agreement__c agreement, Account entity){
        Agreement_Client_Relationships__c newObj = new Agreement_Client_Relationships__c();
         
        newObj.Entity__c = entity.Id;
        newObj.Agreement__c = agreement.Id;
        newObj.Relationship__c = borrowerRel;
        
        insert newObj;
        system.debug('### AgreementClientRelationship - new AgreementClientRelationship is created');
        return newObj;
    }
    
    //Agreement Financial Covenant
    public static Agreement_Financial_Covenant__c getAgreementFinancialCovenant(Agreement__c agreement, string covenantType, string testingFrequency){
        Agreement_Financial_Covenant__c newobj = new Agreement_Financial_Covenant__c();
        newObj.Agreement__c= agreement.Id;
        newObj.Covenant_Type__c = covenantType;
        newObj.Testing_Frequency__c = testingFrequency;
        newObj.Start_Date__c = date.today();
        
        insert newObj;
        system.debug('### AgreementFinancialCovenant - new AgreementFinancialCovenant is created');
        return newObj;
    }
    
    //Agreement Borrowing Base
    public static Agreement_Borrowing_Base_Relationship__c getAgreementBorrowingBaseRelationship(Agreement__c agreement, string Status, string Frequency){
        Agreement_Borrowing_Base_Relationship__c newobj = new Agreement_Borrowing_Base_Relationship__c();
        newObj.Agreement__c= agreement.Id;
        newObj.Status__c = Status;
        
        insert newObj;
        system.debug('### AgreementBorrowingBaseRelationship - new AgreementBorrowingBaseRelationship is created');
        return newObj;
    }
    
    //Agreement EB Account Relationship
    public static Agreement_EB_Account_Relationship__c getAgreementEBAccountRelationship(Agreement__c agreement, EB_Account__c loanAccount){
        Agreement_EB_Account_Relationship__c newObj = new Agreement_EB_Account_Relationship__c();
        newObj.Agreement__c = agreement.Id;
        newObj.Loan_Account__c = loanAccount.Id;
        insert newObj;
        system.debug('### AgreementEBAccountRelationship - new AgreementEBAccountRelationship is created');
        return newObj;
    }
    
   public static Agreement_Loan_Application_Relationship__c getAgreementLoanApplicationRelationship(Agreement__c agreement, EB_Loan_Application__c ebLoanApp){
        Agreement_Loan_Application_Relationship__c newObj = new Agreement_Loan_Application_Relationship__c();
        newObj.Agreement__c = agreement.Id;
        newObj.Loan_Application__c = ebLoanApp.Id;
        insert newObj;
        system.debug('### getAgreementLoanApplicationRelationship - new getAgreementLoanApplicationRelationship is created');
        return newObj;
   }

   // Users
    public static User getUser(String fName,String lName ,String email, Id UserRoleId, Id ProfileId){
        User testUser = new User();
        testUser.Username= email ;//fName + ' ' + lName;
        testUser.Email = email;
        testUser.Lastname = lName;
        testUser.Firstname = fName;
        testUser.Alias = fName;
        testUser.CommunityNickname = fName + '1';
        testUser.UserRoleId = UserRoleId;
        testUser.ProfileId = ProfileId;
        
        testUser.TimeZoneSidKey = 'GMT';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.UserPermissionsMobileUser = false;
        
        System.debug ( JSON.serializePretty( testUser ) );
        
        insert testUser;
        return testUser;
    }

    //Test User class creates a test user dynamicaaly with permissionSets
    public class TestUser
    {
        private String m_firstName;
        private String m_lastName;
        private String m_email;
        private String m_roleName;
        private String m_profileName;
        private List<String> m_permissionSets; 

        public TestUser(String firstName,String lastName,String email,String roleName,String profileName, List<String> permissionSets) {
            m_firstName = firstName;
            m_lastName = lastName;
            m_email = email;
            m_roleName = roleName;
            m_profileName = profileName;
            m_permissionSets = permissionSets;
        }

        public User CreateUser() {
            User user = BuildUser(m_firstName, m_lastName, m_email, GetUserRoleBy(m_roleName).Id, GetProfileBy(m_profileName).Id);
            
            if(HasPermissions){SetPermissionsFor(user);}

            return user;
        }

        private Boolean HasPermissions{get{return m_permissionSets == null?false:true;}}

        private  void SetPermissionsFor(User testUser) {
            List<PermissionSet> permissionSets = [SELECT ID FROM PermissionSet WHERE Name in: m_permissionSets];
            List<PermissionSetAssignment> assigments = new List<PermissionSetAssignment>();
            for(PermissionSet ps: permissionSets)
            {
                assigments.add(new PermissionSetAssignment(AssigneeId=testUser.Id,PermissionsetId=ps.Id));
            }
            insert assigments;
        }

        private  Profile GetProfileBy(String ProfileName) {
            return [SELECT id, Name FROM Profile WHERE Name =: ProfileName LIMIT 1];
        }

        private  UserRole GetUserRoleBy(String RoleName) {
            return [SELECT id, Name FROM UserRole WHERE Name =: RoleName LIMIT 1];
        }

        private User BuildUser(String fname, String lname, String Email, Id UserRoleId, Id ProfileId) {
            User testUser = new User();
            testUser.Username= Email;
            testUser.Email = Email;
            testUser.Lastname = lname;
            testUser.Firstname = fname;
            testUser.Alias = fname;
            testUser.CommunityNickname = fName + '1';
            testUser.UserRoleId = UserRoleId;
            testUser.ProfileId = ProfileId;
            
            testUser.TimeZoneSidKey = 'GMT';
            testUser.LocaleSidKey = 'en_US';
            testUser.EmailEncodingKey = 'ISO-8859-1';
            testUser.LanguageLocaleKey = 'en_US';
            testUser.UserPermissionsMobileUser = false;
            insert testUser;

            return testUser;
        }
    }
}