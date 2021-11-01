public class TmBoardingDataProvider extends DataProvider implements TmBoarding.IDataprovider {
        
        public TmBoarding.requestPm getRequest(Id requestId, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields) {
            String req = String.Join(requestFields, ',');
            String con = String.Join(contactFields, ',');
            String acct = String.Join(accountFields, ',');
            String format = 'SELECT {0} ';
                   format += ',(SELECT {1} FROM TM_Service_Request_Contacts__r ORDER BY CreatedDate, Contact__r.FirstName, Contact__r.LastName)';
                   format += ',(SELECT {2} FROM TM_Service_Request_Accounts__r) ';
                   format += ' FROM TM_Service_Request__c WHERE Id = \'\'{3}\'\'';

            return buildPm(requestFields, contactAccountFields ,contactCoreFields ,accountCoreFields , Database.query(String.Format(format, new List<String>{req, con, acct, requestId})));
        }

        public TmBoarding.requestPm getRequestWithRelatedEbAccounts(Id requestId, List<String> entityIds, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields) {
            String req = String.Join(requestFields, ',');
            String con = String.Join(contactFields, ',');
            String acct = String.Join(accountFields, ',');
            String format = 'SELECT {0} ';
                   format += ',(SELECT {1} FROM TM_Service_Request_Contacts__r ORDER BY CreatedDate, Contact__r.FirstName, Contact__r.LastName)';
                   format += ',(SELECT {2} FROM TM_Service_Request_Accounts__r) ';
                   format += ' FROM TM_Service_Request__c WHERE Id = \'\'{3}\'\'';

            return buildPmWithRelatedEbAccounts(entityIds, requestFields, contactAccountFields ,contactCoreFields ,accountCoreFields , Database.query(String.Format(format, new List<String>{req, con, acct, requestId})));
        }

        public TmBoarding.requestPm getRequestFromPacket(TM_Service_Request__c request){

            TmBoarding.requestPm requestPm = new TmBoarding.requestPm();
            TM_service_Request_Packet__c packet = getPacket(request);
            Account entity = getEntity(packet.Entity__r.Id);
            requestPm.requestPm = request;
            requestPm.packetPm = packet;
            requestPm.packetRequestsPm = getRequestsForPacket(packet.Id);
            requestPm.entityPm = new Account(Id=entity.Id, Name = entity.Name);
            requestPm.contactPms = entity.Contacts;
            requestPm.accountPms = getEbAccounts(entity.EB_Account_Relationships__r);
            requestPm.serviceContactPms = new List<TM_Service_Request_Contact__c>();
            requestPm.serviceAccountPms = new List<TM_Service_Request_Account__c>();
            requestPm.serviceContactAccountPms = new List<TM_Service_Request_Contact_Account__c>();

            return requestPm;       
        }

        public List<Tm_Service_Request__c> getRequestsForPacket(Id packetId) {
            return [
                SELECT
                    Id
                    ,Name
                    ,RecordTypeId
                    ,RecordType.Name
                    ,Stage__c
                    ,Stage__r.Id
                    ,Stage__r.Name
                    ,Stage__r.Type__c
                    ,Stage__r.Permission__c
                    ,Stage__r.Auto_Forward_Stage__c
                    ,Stage__r.Auto_Forward_Stage__r.Name
                    ,Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__c
                    ,Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__r.Name
                    ,TM_Service_Request_Packet__c
                    ,TM_Service_Request_Packet__r.Id
                    ,TM_Service_Request_Packet__r.Name
                    ,TM_Service_Request_Packet__r.Opportunity__c
                FROM
                    Tm_Service_Request__c
                WHERE
                    TM_Service_Request_Packet__c =: packetId
                ORDER BY
                    RecordType.Name
            ];
        }

        public List<TM_Service_Configuration__c> getAllConfigurations() {
            return [
                SELECT
                    Id
                    ,Product_Name__c
                    ,Template_Folder__c
                    ,Template_File__c
                    ,TM_Screen_Template__c
                    ,Contact_Summary_Report_Template__c
                    ,User_Boarding_Template2__c
                    ,Master_Service_Agreement__c
                    ,Footer_Template__c
                    ,Digital_Signature_Primary_Signer_Code__c
                    ,Digital_Signature_Secondary_Signer_Code__c
                    ,Digital_Signature_Tmo_Signer_Code__c
                    ,Digital_Signature_Requires_Initial__c
                FROM
                    TM_Service_Configuration__c
            ];
        }

        public List<Eb_Account__c> getEbAccount(Decimal app, String accountNumber) {

            return [
                SELECT
                    Id
                    ,Account_Number__c
                    ,Application__c
                    ,Fee_Master_Account__c
                    ,Account_Line_1__c
                    ,Account_Name__c
                    ,ApplicationDescription__c
                FROM
                    Eb_Account__c
                WHERE
                    Application__c =: app
                    AND Account_Number__c =: accountNumber
                LIMIT 1
            ];
        }

        public Eb_Account__c getEbAccount(String ebaccountId) {
            List<Eb_Account__c> accounts =  [
                SELECT
                    Id
                    ,Account_Number__c
                    ,Application__c
                    ,Account_Line_1__c
                    ,Account_Name__c
                    ,ApplicationDescription__c
                    ,Fee_Master_Account__c
                FROM
                    Eb_Account__c
                WHERE
                    Id =:ebaccountId
                LIMIT 1
            ];

            return accounts == null || accounts.size() == 0 ? null : accounts[0];
        }

        public TmBoarding.RequestConfigPm getPageFieldConfigurationsByServiceType(string recordTypeName){

            TM_Service_Configuration__c config = getConfigurationsByServiceType(recordTypeName);
            List<TM_Service_Configuration_Schedule__c> schedules = getSchedulesByScheduleTypes(config.TM_Service_Configuration_Field_Details__r);
            
            TmBoarding.RequestConfigPm metadataPm = new TmBoarding.RequestConfigPm(); 
            metadataPm.productPm = config;          
            metadataPm.serviceOptionPms = config.Service_Options__r;
            metadataPm.contactOptionPms = config.Contact_Options__r;
            metadataPm.accountOptionPms = config.Account_Options__r;
            metadataPm.contactAccountOptionPms = config.Contact_Account_Options__r;
            metadataPm.schedulePms = getSchedulesByType(schedules);
            metadataPm.sectionOptionPms = getConfigSections();
            metadataPm.sectionGroupOptionPms = getConfigSectionGroups();

            return metadataPm;
        }

        public Opportunity getOpportunity(String opportunityId) {
            return [
                SELECT
                    Id
                    ,Name
                    ,Product_Line__c
                    ,Account.Id
                    ,Account.Name
                    ,Account.RecordTypeId
                    ,Account.RecordType.Name
                    ,RecordType.Id
                    ,RecordType.Name
                    ,RecordTypeId
                    ,Potential_Fee_Income__c
                    ,Potential_Deposits__c
                    ,Products__c
                    ,Product__c
                FROM
                    Opportunity
                WHERE
                    Id =: opportunityId
                LIMIT 1
            ];
        }

        public List<Tm_Service_Request_Packet__c> getPacketsFromEntity(String entityId) {
            return [
                SELECT
                    Id
                    ,Name
                    ,Entity__c
                    ,Opportunity__c
                    ,Bundle_Type__c
                FROM
                    Tm_Service_Request_Packet__c
                WHERE
                    Entity__r.Id =: entityId
            ];
        }

        public Tm_Service_Request_Stage__c getStageForRequest(String requestId) {

            TM_Service_Request__c req =
            [
                SELECT
                    Id
                    ,Stage__c
                    ,Stage__r.Name
                    ,Stage__r.Id
                    ,Stage__r.Type__c
                    ,Stage__r.Permission__c
                    ,Stage__r.Auto_Forward_Stage__c
                    ,Stage__r.Auto_Forward_Stage__r.Name
                    ,Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__c
                    ,Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__r.Name
                FROM
                    TM_Service_Request__c
                WHERE
                    Id =: requestId
                LIMIT 1
            ];

            return req == null ?null : req.Stage__r;

        }

        public List<Tm_Service_Request_Stage_Relationships__c> getValidStages(Tm_Service_Request_Stage__c parent) {

            List<Tm_Service_Request_Stage_Relationships__c> related = [
                SELECT
                    Id
                   ,Name
                   ,Parent_Stage__c
                   ,Parent_Stage__r.Id
                   ,Parent_Stage__r.Name
                   ,Parent_Stage__r.Type__c
                   ,Parent_Stage__r.Permission__c
                   ,Parent_Stage__r.Auto_Forward_Stage__c
                   ,Parent_Stage__r.Auto_Forward_Stage__r.Name
                   ,Parent_Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__c
                   ,Parent_Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__r.Name
                   ,Child_Stage__c
                   ,Child_Stage__r.Id
                   ,Child_Stage__r.Name
                   ,Child_Stage__r.Type__c
                   ,Child_Stage__r.Permission__c
                   ,Child_Stage__r.Auto_Forward_Stage__c
                   ,Child_Stage__r.Auto_Forward_Stage__r.Name
                   ,Child_Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__c
                   ,Child_Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__r.Name
                FROM
                    Tm_Service_Request_Stage_Relationships__c
                WHERE
                    Parent_Stage__c =: parent.Id
                ORDER BY
                    Parent_Stage__r.Sort_Order__c,Child_Stage__r.Sort_Order__c
            ];
            return related == null? new List<Tm_Service_Request_Stage_Relationships__c>()
                                 : related;
        }

        public Tm_Service_Request_Stage__c getStageByName(String stageName) {
            return [
                SELECT
                    Id
                    ,Name
                    ,Type__c
                    ,Permission__c
                    ,Auto_Forward_Stage__c
                    ,Auto_Forward_Stage__r.Name
                    ,Auto_Forward_Stage__r.Auto_Forward_Stage__c
                    ,Auto_Forward_Stage__r.Auto_Forward_Stage__r.Name
                FROM
                    Tm_Service_Request_Stage__c
                WHERE
                    Name =: stageName
                LIMIT 1
            ];
        }

        public Tm_Service_Request_Stage__c getDefaultStage() {
            List<TM_Service_Request_Stage__c> defaultStage = [
                SELECT
                    Id
                    ,Name
                    ,Type__c
                    ,Permission__c
                    ,Auto_Forward_Stage__c
                    ,Auto_Forward_Stage__r.Name
                    ,Auto_Forward_Stage__r.Auto_Forward_Stage__c
                    ,Auto_Forward_Stage__r.Auto_Forward_Stage__r.Name
                FROM
                    Tm_Service_Request_Stage__c
                WHERE
                    Type__c =: 'Default'
                LIMIT 1
            ];

            return (defaultStage == null || defaultStage.size() == 0) ? null : defaultStage[0];
        }

        public List<Tm_Service_Request_Stage__c> getAllStages() {
            return [
                SELECT
                    Id
                    ,Name
                    ,Type__c
                    ,Permission__c
                    ,Auto_Forward_Stage__c
                    ,Auto_Forward_Stage__r.Name
                    ,Auto_Forward_Stage__r.Auto_Forward_Stage__c
                    ,Auto_Forward_Stage__r.Auto_Forward_Stage__r.Name
                    ,(
                        SELECT
                            Id
                           ,Name
                           ,Parent_Stage__c
                           ,Parent_Stage__r.Id
                           ,Parent_Stage__r.Name
                           ,Parent_Stage__r.Type__c
                           ,Parent_Stage__r.Permission__c
                           ,Parent_Stage__r.Auto_Forward_Stage__c
                           ,Parent_Stage__r.Auto_Forward_Stage__r.Name
                           ,Parent_Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__c
                           ,Parent_Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__r.Name
                           ,Child_Stage__c
                           ,Child_Stage__r.Id
                           ,Child_Stage__r.Name
                           ,Child_Stage__r.Type__c
                           ,Child_Stage__r.Permission__c
                           ,Child_Stage__r.Auto_Forward_Stage__c
                           ,Child_Stage__r.Auto_Forward_Stage__r.Name
                           ,Child_Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__c
                           ,Child_Stage__r.Auto_Forward_Stage__r.Auto_Forward_Stage__r.Name
                        FROM
                            Tm_Service_Request_Stage_Relationships__r
                     )
                FROM
                    Tm_Service_Request_Stage__c
                ORDER BY
                    Sort_Order__c
            ];
        }

        public List<Eb_Account__c> getEbAccountSearchResults(String param) {
            return [
                SELECT 
                    Id 
                   ,Name
                   ,Account_Line_1__c
                   ,Account_Line_2__c
                   ,Account_Line_3__c
                   ,Account_Name__c
                   ,Primary_Owner_Id__r.Id
                   ,Primary_Owner_Id__r.Name
                   ,Account_Number__c
                   ,ApplicationDescription__c
                FROM 
                    Eb_Account__c 
                WHERE 
                    Account_Status__c NOT IN ('C','R','P')
                    AND Account_Number__c LIKE : param 
                LIMIT 25
            ];
        }

        public TM_Service_Request_Packet__c getPacket(TM_Service_Request__c request) {
            return [
                SELECT
                    Id
                    ,Name
                    ,Entity__r.Id
                    ,Entity__r.Name
                    ,Entity__r.Date_TM_Master_Agmt_Signed__c
                    ,Entity__c
                    ,Opportunity__c
                FROM
                    TM_Service_Request_Packet__c
                WHERE
                     Id =: request.TM_Service_Request_Packet__c
            ];
        }

        public TM_Service_Request__c getPacketFromRequest(TM_Service_Request__c request){
            return [
                SELECT
                    Id
                    ,Name
                    ,TM_Service_Request_Packet__c
                    ,TM_Service_Request_Packet__r.Name
                    ,TM_Service_Request_Packet__r.Entity__r.Id
                    ,TM_Service_Request_Packet__r.Entity__r.Name
                    ,TM_Service_Request_Packet__r.Entity__r.Date_TM_Master_Agmt_Signed__c
                    ,TM_Service_Request_Packet__r.Entity__c
                    ,TM_Service_Request_Packet__r.Opportunity__c
                FROM
                    TM_Service_Request__c
                WHERE
                     Id =: request.Id
                LIMIT 1
            ];
        }

        public Map<Id,TM_Service_Configuration_Section__c> getConfigSections() {
            return new Map<Id,TM_Service_Configuration_Section__c>( [
                SELECT
                    Id
                    ,Name
                    ,Label__c
                    ,Number_Of_Columns__c
                    ,Show__c
                    ,Placement__c
                FROM
                    TM_Service_Configuration_Section__c
            ]);
        }

        public Map<Id, Tm_Service_Configuration_Section_Group__c> getConfigSectionGroups() {

            Map<Id, Tm_Service_Configuration_Section_Group__c> sectionGroups = new Map<Id, Tm_Service_Configuration_Section_Group__c>(
            [
                SELECT
                    Id
                    ,Name
                    ,Label__c
                    ,Type__c
                FROM
                    Tm_Service_Configuration_Section_Group__c
            ]);

            return sectionGroups == null ? new Map<Id, Tm_Service_Configuration_Section_Group__c>() : sectionGroups;
        }

        public Map<string, TmBoarding.RequestConfigPm> getAllPageFieldConfigurationsByServiceType(){
            
            Map<string, TmBoarding.RequestConfigPm> fieldConfigurations = new Map<string, TmBoarding.RequestConfigPm>();
            List<TM_Service_Configuration__c> configs = getConfigurationsByServiceTypes();
            
            Map<Id,TM_Service_Configuration_Section__c> configSections = getConfigSections();
            Map<Id, Tm_Service_Configuration_Section_Group__c> configSectionGroups = getConfigSectionGroups();
            for(TM_Service_Configuration__c config : configs) {
                TmBoarding.RequestConfigPm metadataPm = new TmBoarding.RequestConfigPm();
                metadataPm.productPm = config;          
                metadataPm.serviceOptionPms = config.Service_Options__r;
                metadataPm.contactOptionPms = config.Contact_Options__r;
                metadataPm.accountOptionPms = config.Account_Options__r;
                metadataPm.contactAccountOptionPms = config.Contact_Account_Options__r;
                List<TM_Service_Configuration_Schedule__c> schedulesCfg = getSchedulesByScheduleTypes(config.TM_Service_Configuration_Field_Details__r);
                metadataPm.schedulePms = getSchedulesByType(schedulesCfg);
                metadataPm.sectionOptionPms = configSections;
                metadataPm.sectionGroupOptionPms = configSectionGroups;
                fieldConfigurations.put(config.Product_Name__c, metadataPm);
            }

            return fieldConfigurations;
        }

        public Map<Id, TmBoarding.requestPm> getAllRequests(List<Id> requestIds, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields) {
            String req = String.Join(requestFields, ',');
            String con = String.Join(contactFields, ',');
            String acct = String.Join(accountFields, ',');
            List<string> updatedRequestIds = new List<string>();
            for(Id i : requestIds) {
                String idStr = '\'' + string.valueOf(i) + '\'';
                updatedRequestIds.add(idStr);
            }
            String reqs = '(' + String.Join(updatedRequestIds, ',') + ') ';
            String format = 'SELECT {0} ';
                   format += ',(SELECT {1} FROM TM_Service_Request_Contacts__r ORDER BY CreatedDate, Contact__r.FirstName, Contact__r.LastName)';
                   format += ',(SELECT {2} FROM TM_Service_Request_Accounts__r) ';
                   format += ' FROM TM_Service_Request__c WHERE Id in {3}';

            return buildAllPms(requestFields, contactAccountFields ,contactCoreFields ,accountCoreFields , Database.query(String.Format(format, new List<String>{req, con, acct, reqs})));
        }

        public List<TmBoarding.RequestPm> getUserCentricAccountsForPacket(Id packetId) {
            List<Tm_Service_Request__c> requests = 
            [
                SELECT
                    Id
                    ,Name
                    ,RecordTypeId
                    ,RecordType.Name
                    ,(SELECT
                        Id
                        ,Contact__c
                        ,Contact__r.Id
                        ,Contact__r.Name
                        ,Contact__r.FirstName
                        ,Contact__r.LastName
                        ,Contact__r.Primary_TM_Contact__c
                        ,Contact__r.Secondary_TM_Contact__c
                        ,Tm_Service_Request__c
                     FROM
                        Tm_Service_Request_Contacts__r
                    )
                    ,(SELECT
                        Id
                        ,Eb_Account__c
                        ,Eb_Account__r.Id
                        ,Eb_Account__r.Name
                        ,Eb_Account__r.Fee_Master_Account__c
                        ,Eb_Account__r.Account_Line_1__c
                        ,Eb_Account__r.Account_Name__c
                        ,Eb_Account__r.ApplicationDescription__c
                        ,Tm_Service_Request__c
                     FROM
                        Tm_Service_Request_Accounts__r
                    )
                FROM
                    TM_Service_Request__c
                WHERE
                    TM_Service_Request_Packet__c =:packetId
            ];

            List<TmBoarding.RequestPm> requestPms = new List<TmBoarding.RequestPm>();
            for(Tm_Service_Request__c r: requests) {
                TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
                pm.contactPms = new List<Contact>();
                pm.accountPms = new List<Eb_Account__c>();
                pm.requestPm = r;
                for(Tm_Service_Request_Contact__c c: r.Tm_Service_Request_Contacts__r){
                    pm.contactPms.add(c.Contact__r);
                }
                for(Tm_Service_Request_Account__c a: r.TM_Service_Request_Accounts__r){
                    pm.accountPms.add(a.Eb_Account__r);
                }
                requestPms.add(pm);
            }

            return requestPms;
        }

        private TmBoarding.requestPm buildPm(List<string> requestFields, List<string> contactAccountFields, List<string> coreContacts, List<string> coreEbAccounts, Tm_Service_Request__c req) {

            TmBoarding.requestPm requestPm = new TmBoarding.requestPm();
            Account entity = getEntity2(req.TM_Service_Request_Packet__r.Entity__r.Id,coreContacts, coreEbAccounts);
  
            requestPm.requestPm = buildLevelOneRequest(requestFields, req);
            requestPm.packetPm = req.TM_Service_Request_Packet__r;
            requestPm.packetRequestsPm = getRequestsForPacket(req.TM_Service_Request_Packet__r.Id);
            requestPm.entityPm = new Account(Id=entity.Id, Name = entity.Name, Date_TM_Master_Agmt_Signed__c = entity.Date_TM_Master_Agmt_Signed__c);
            requestPm.contactPms = entity.Contacts;
            requestPm.accountPms = getEbAccounts(entity.EB_Account_Relationships__r);
            requestPm.serviceContactPms = req.TM_Service_Request_Contacts__r;
            requestPm.serviceAccountPms = req.TM_Service_Request_Accounts__r;
            requestPm.serviceContactAccountPms = getRequestContactAccounts(contactAccountFields, req);
            return requestPm;
        }

        private TmBoarding.requestPm buildPmWithRelatedEbAccounts(List<string> entityIds, List<string> requestFields, List<string> contactAccountFields, List<string> coreContacts, List<string> coreEbAccounts, Tm_Service_Request__c req) {

            TmBoarding.requestPm requestPm = new TmBoarding.requestPm();

            List<Account> entities = getEntity3(entityIds, coreContacts, coreEbAccounts);
            
            Account entity = new Account();
            for(Account a : entities){
                if(a.Id == req.TM_Service_Request_Packet__r.Entity__r.Id){
                    entity = a;
                }
            }
  
            requestPm.requestPm = buildLevelOneRequest(requestFields, req);
            requestPm.packetPm = req.TM_Service_Request_Packet__r;
            requestPm.packetRequestsPm = getRequestsForPacket(req.TM_Service_Request_Packet__r.Id);
            requestPm.entityPm = new Account(Id=entity.Id, Name = entity.Name, Date_TM_Master_Agmt_Signed__c = entity.Date_TM_Master_Agmt_Signed__c);
            requestPm.contactPms = entity.Contacts;
            requestPm.accountPms = getEbAccountsIncludeRelated(entities);
            requestPm.serviceContactPms = req.TM_Service_Request_Contacts__r;
            requestPm.serviceAccountPms = req.TM_Service_Request_Accounts__r;
            requestPm.serviceContactAccountPms = getRequestContactAccounts(contactAccountFields, req);
            return requestPm;
        }

        private Tm_Service_Request__c buildLevelOneRequest(List<string> requestFields, Tm_Service_Request__c req) {

            Tm_Service_Request__c r = new Tm_Service_Request__c();
            String query = String.Join(requestFields, ',');
            String format = 'SELECT {0} ';
                   format += ' FROM TM_Service_Request__c WHERE Id = \'\'{1}\'\'';

            return Database.query(String.Format(format, new List<String>{query, req.Id}));
        }
 
        private Account getEntity(Id entityId){

            return [
                SELECT
                    Id
                    ,Name
                    ,Date_TM_Master_Agmt_Signed__c
                    ,(
                        SELECT 
                            Id
                            ,Name
                            ,AccountId
                            ,Email
                            ,FirstName
                            ,LastName
                            ,Phone
                            ,MobilePhone
                            ,Fax
                            ,Primary_TM_Contact__c
                            ,Secondary_TM_Contact__c
                        FROM
                            Contacts
                        ORDER BY FirstName, LastName
                    )
                   ,(
                        SELECT
                            Account_Title__c
                            ,EB_Account_Id__c
                            ,EB_Account_Id__r.Id
                            ,EB_Account_Id__r.Name
                            ,EB_Account_Id__r.Account_Number__c
                            ,EB_Account_Id__r.Fee_Master_Account__c
                            ,EB_Account_Id__r.Account_Line_1__c
                            ,Eb_Account_Id__r.Account_Name__c
                            ,EB_Account_Id__r.ApplicationDescription__c
                        FROM
                            EB_Account_Relationships__r
                        ORDER BY EB_Account_Id__r.Name
                        LIMIT 25
                    )
                FROM
                    Account
                WHERE
                    Id =: entityId
                LIMIT 1
            ];
        }

        private  Account getEntity2(Id entityId, List<String> contactFields, List<String> relatedEbAccountFields) {
            List<String> entityFields = new List<String>{'Id', 'Name', 'EB_Customer_Number__c', 'Date_TM_Master_Agmt_Signed__c', 'BillingAddress'};
            String e = String.Join(entityFields, ',');
            String c = String.Join(contactFields, ',');
            String eb = String.Join(relatedEbAccountFields, ',');

            String format = 'SELECT {0} ';
                   format += ',(SELECT {1} FROM Contacts WHERE Active_Contact__c = true ORDER BY FirstName, LastName )';
                   format += ',(SELECT {2} FROM EB_Account_Relationships__r WHERE Account_Status__c NOT IN (\'\'C\'\',\'\'R\'\',\'\'P\'\') ORDER BY EB_Account_Id__r.Name limit 25) ';
                   format += ' FROM Account WHERE Id = \'\'{3}\'\' LIMIT 1';

            String query = String.format(format, new LIST<String>{e,c,eb, entityId});

            return Database.Query(query);
        }

        public  List<Account> getEntity3(List<String> entityIds , List<String> contactFields, List<String> relatedEbAccountFields) {
            List<String> entityFields = new List<String>{'Id', 'Name', 'EB_Customer_Number__c', 'Date_TM_Master_Agmt_Signed__c', 'BillingAddress'};
            String e = String.Join(entityFields, ',');
            String c = String.Join(contactFields, ',');
            String eb = String.Join(relatedEbAccountFields, ',');
            String entities = String.Join(entityIds, ',');
            Set<Id> entityIdSet = new Set<Id>();
            for(String s: entityIds){
                entityIdSet.add(Id.valueOf(s));
            }

           
            String format = 'SELECT {0} ';
                   format += ',(SELECT {1} FROM Contacts WHERE Active_Contact__c = true ORDER BY FirstName, LastName )';
                   format += ',(SELECT {2} FROM EB_Account_Relationships__r WHERE Account_Status__c NOT IN (\'\'C\'\',\'\'R\'\',\'\'P\'\') ORDER BY EB_Account_Id__r.Name limit 25) ';
                   format += ' FROM Account WHERE Id in :entityIdSet';
            
            String query = String.format(format, new LIST<String>{e,c,eb});

            return Database.Query(query);
        }

        private List<Eb_Account__c> getEbAccounts(List<EB_Account_Relationship__c> ebAccountRelationships) {

            List<Eb_Account__c> ebAccounts = new List<Eb_Account__c>();
            for(EB_Account_Relationship__c r : ebAccountRelationships) {
                    ebAccounts.add(r.EB_Account_Id__r);
            }

            return ebAccounts;
        }

        private List<Eb_Account__c> getEbAccountsIncludeRelated(List<Account> entities){
             List<Eb_Account__c> ebAccounts = new List<Eb_Account__c>();
             Map<Id, Eb_Account__c> ebAccountMap = new Map<Id, Eb_Account__c>();
             for(Account e : entities){
                if(e.EB_Account_Relationships__r != null){
                    for(EB_Account_Relationship__c a : e.EB_Account_Relationships__r){
                        if(!ebAccountMap.containsKey(a.EB_Account_Id__c)){
                            ebAccounts.add(a.EB_Account_Id__r);
                            ebAccountMap.put(a.EB_Account_Id__c, a.EB_Account_Id__r);
                        }
                    }
                }
             }
             return ebAccounts;
        }

        private List<TM_Service_Request_Contact_Account__c> getRequestContactAccounts( List<string> contactAccountFields, Tm_Service_Request__c req) {
            
            TM_Service_Request_Contact_Account__c r = new TM_Service_Request_Contact_Account__c();
            String query = String.Join(contactAccountFields, ',');
            String format = 'SELECT {0} ';
                   format += ' FROM TM_Service_Request_Contact_Account__c WHERE TM_Service_Request_Account__r.TM_Service_Request__c = \'\'{1}\'\'';

            return Database.query(String.Format(format, new List<String>{query, req.Id}));
        }

        private List<TmBoarding.RequestScheduleConfigPm> getSchedulesByType(List<TM_Service_Configuration_Schedule__c> schedules) {

            List<TmBoarding.RequestScheduleConfigPm> pms = new List<TmBoarding.RequestScheduleConfigPm>();

            for(TM_Service_Configuration_Schedule__c s : schedules) {
                TmBoarding.RequestScheduleConfigPm pm = new TmBoarding.RequestScheduleConfigPm();
                pm.ScheduleName = s.Name;
                pm.ScheduleLabel = s.Label__c;
                pm.ScheduleSection = s.Section__c;
                pm.ScheduleType = s.Type__c;
                pm.serviceSchedulePms = s.Service_Schedule__r;
                pm.accountServiceSchedulePms = s.Account_Service_Schedule__r;
                pms.add(pm);
            }

            return pms;
        }

        private TM_Service_Configuration__c getConfigurationsByServiceType(String recordTypeName) {
            
            return [
                SELECT
                    Id
                    ,Name
                    ,Product_Name__c
                    ,Template_Folder__c
                    ,Template_File__c
                    ,Contact_Summary_Report_Template__c
                    ,Related_To_Opportunity_Products__c
                    ,TM_Screen_Template__c
                    ,User_Boarding_Template2__c
                    ,Master_Service_Agreement__c
                    ,Footer_Template__c
                    ,Digital_Signature_Primary_Signer_Code__c
                    ,Digital_Signature_Secondary_Signer_Code__c
                    ,Digital_Signature_Tmo_Signer_Code__c
                    ,Digital_Signature_Requires_Initial__c               
                    ,(
                        SELECT
                            Name
                            ,Field_Name__c
                            ,Object_Name__c
                            ,Title__c
                            ,View__c
                            ,Edit__c
                            ,Report__c
                            ,Section__c
                            ,Columns__c
                            ,Correlated__c
                            ,Alternate_Field_Name__c
                            ,TM_Section__r.Name
                            ,TM_Section__r.Label__c
                            ,TM_Section__r.Number_Of_Columns__c
                            ,TM_Section__r.Show__c
                            ,TM_Section_Group__c
                            ,TM_Section_Group__r.Id
                            ,TM_Section_Group__r.Name
                            ,TM_Section_Group__r.Label__c
                            ,TM_Section_Group__r.Type__c
                            ,View_Placement__c
                            ,Edit_Placement__c
                            ,Report_Placement__c
                            ,Readonly__c
                        FROM
                            Service_Options__r
                        ORDER BY
                            Edit_Placement__c,View_Placement__c
                    )
                    ,(
                        SELECT
                            Name 
                            ,Field_Name__c
                            ,Object_Name__c
                            ,Title__c
                            ,View__c
                            ,Edit__c
                            ,Report__c
                            ,Section__c
                            ,Columns__c
                            ,Correlated__c
                            ,Alternate_Field_Name__c
                            ,TM_Section__r.Name
                            ,TM_Section__r.Label__c
                            ,TM_Section__r.Number_Of_Columns__c
                            ,TM_Section__r.Show__c
                            ,TM_Section_Group__c
                            ,TM_Section_Group__r.Id
                            ,TM_Section_Group__r.Name
                            ,TM_Section_Group__r.Label__c
                            ,TM_Section_Group__r.Type__c
                            ,View_Placement__c
                            ,Edit_Placement__c
                            ,Report_Placement__c
                            ,Readonly__c
                        FROM
                            Contact_Options__r
                        ORDER BY
                            Edit_Placement__c,View_Placement__c
                    )
                    ,(
                        SELECT
                            Name
                            ,Field_Name__c
                            ,Object_Name__c
                            ,Title__c
                            ,View__c
                            ,Edit__c
                            ,Report__c
                            ,Section__c
                            ,Columns__c
                            ,Correlated__c
                            ,Alternate_Field_Name__c
                            ,TM_Section__r.Name
                            ,TM_Section__r.Label__c
                            ,TM_Section__r.Number_Of_Columns__c
                            ,TM_Section__r.Show__c
                            ,TM_Section_Group__c
                            ,TM_Section_Group__r.Id
                            ,TM_Section_Group__r.Name
                            ,TM_Section_Group__r.Label__c
                            ,TM_Section_Group__r.Type__c
                            ,View_Placement__c
                            ,Edit_Placement__c
                            ,Report_Placement__c
                            ,Readonly__c
                        FROM
                            Account_Options__r
                        ORDER BY
                            Edit_Placement__c,View_Placement__c
                    )
                    ,(
                        SELECT
                            Name
                            ,Field_Name__c
                            ,Object_Name__c
                            ,Title__c
                            ,View__c
                            ,Edit__c
                            ,Report__c
                            ,Section__c
                            ,Columns__c
                            ,Correlated__c
                            ,Alternate_Field_Name__c
                            ,TM_Section__r.Name
                            ,TM_Section__r.Label__c
                            ,TM_Section__r.Number_Of_Columns__c
                            ,TM_Section__r.Show__c
                            ,TM_Section_Group__c
                            ,TM_Section_Group__r.Id
                            ,TM_Section_Group__r.Name
                            ,TM_Section_Group__r.Label__c
                            ,TM_Section_Group__r.Type__c
                            ,View_Placement__c
                            ,Edit_Placement__c
                            ,Report_Placement__c
                            ,Readonly__c
                        FROM
                            Contact_Account_Options__r
                        ORDER BY
                            Edit_Placement__c,View_Placement__c
                    )
                    ,(
                        SELECT
                            Id
                            ,Name
                            ,Label__c
                            ,Section__c
                            ,Type__c
                            ,TM_Service_Configuration__c
                            ,TM_Service_Configuration__r.Product_Name__c
                        FROM
                            TM_Service_Configuration_Field_Details__r
                        ORDER BY
                            Name
                    )                   
                FROM
                    TM_Service_Configuration__c
                WHERE
                    Product_Name__c =: recordTypeName
                LIMIT 1
            ];
        }

        private List<TM_Service_Configuration_Schedule__c> getSchedulesByScheduleTypes(List<TM_Service_Configuration_Schedule__c> schedules) {
            
            return [
                SELECT
                    Name
                    ,Label__c
                    ,Section__c
                    ,Type__c
                    ,TM_Service_Configuration__c
                    ,(
                        SELECT
                            Name
                            ,Field_Name__c
                            ,Object_Name__c
                            ,Title__c
                            ,View__c
                            ,Edit__c
                            ,Report__c
                            ,Section__c
                            ,Columns__c
                            ,Correlated__c
                            ,Alternate_Field_Name__c
                            ,TM_Section__r.Name
                            ,TM_Section__r.Label__c
                            ,TM_Section__r.Number_Of_Columns__c
                            ,TM_Section__r.Show__c
                            ,TM_Section_Group__c
                            ,TM_Section_Group__r.Id
                            ,TM_Section_Group__r.Name
                            ,TM_Section_Group__r.Label__c
                            ,TM_Section_Group__r.Type__c
                            ,View_Placement__c
                            ,Edit_Placement__c
                            ,Report_Placement__c
                            ,Readonly__c
                        FROM
                            Account_Service_Schedule__r
                        ORDER BY
                            Edit_Placement__c,View_Placement__c
                    )
                    ,(
                        SELECT
                            Name
                            ,Field_Name__c
                            ,Object_Name__c
                            ,Title__c
                            ,View__c
                            ,Edit__c
                            ,Report__c
                            ,Section__c
                            ,Columns__c
                            ,Correlated__c
                            ,Alternate_Field_Name__c
                            ,TM_Section__r.Name
                            ,TM_Section__r.Label__c
                            ,TM_Section__r.Number_Of_Columns__c
                            ,TM_Section__r.Show__c
                            ,TM_Section_Group__c
                            ,TM_Section_Group__r.Id
                            ,TM_Section_Group__r.Name
                            ,TM_Section_Group__r.Label__c
                            ,TM_Section_Group__r.Type__c
                            ,View_Placement__c
                            ,Edit_Placement__c
                            ,Report_Placement__c
                            ,Readonly__c
                        FROM
                            Service_Schedule__r
                        ORDER BY
                            Edit_Placement__c,View_Placement__c
                    )
                FROM
                    TM_Service_Configuration_Schedule__c
                WHERE
                    Id in: schedules
            ];
        }

        private List<TM_Service_Configuration__c> getConfigurationsByServiceTypes() {
            return [
                SELECT
                    Id
                    ,Name
                    ,Product_Name__c
                    ,Template_Folder__c
                    ,Template_File__c
                    ,Contact_Summary_Report_Template__c
                    ,Related_To_Opportunity_Products__c
                    ,TM_Screen_Template__c
                    ,User_Boarding_Template2__c
                    ,Master_Service_Agreement__c 
                    ,Footer_Template__c 
                    ,Digital_Signature_Primary_Signer_Code__c
                    ,Digital_Signature_Secondary_Signer_Code__c
                    ,Digital_Signature_Tmo_Signer_Code__c
                    ,Digital_Signature_Requires_Initial__c                
                    ,(
                        SELECT
                            Name
                            ,Field_Name__c
                            ,Object_Name__c
                            ,Title__c
                            ,View__c
                            ,Edit__c
                            ,Report__c
                            ,Section__c
                            ,Columns__c
                            ,Correlated__c
                            ,Alternate_Field_Name__c
                            ,TM_Section__r.Name
                            ,TM_Section__r.Label__c
                            ,TM_Section__r.Number_Of_Columns__c
                            ,TM_Section__r.Show__c
                            ,TM_Section_Group__c
                            ,TM_Section_Group__r.Id
                            ,TM_Section_Group__r.Name
                            ,TM_Section_Group__r.Label__c
                            ,TM_Section_Group__r.Type__c
                            ,View_Placement__c
                            ,Edit_Placement__c
                            ,Report_Placement__c
                            ,Readonly__c
                        FROM
                            Service_Options__r
                        ORDER BY
                            Edit_Placement__c,View_Placement__c
                    )
                    ,(
                        SELECT
                            Name 
                            ,Field_Name__c
                            ,Object_Name__c
                            ,Title__c
                            ,View__c
                            ,Edit__c
                            ,Report__c
                            ,Section__c
                            ,Columns__c
                            ,Correlated__c
                            ,Alternate_Field_Name__c
                            ,TM_Section__r.Name
                            ,TM_Section__r.Label__c
                            ,TM_Section__r.Number_Of_Columns__c
                            ,TM_Section__r.Show__c
                            ,TM_Section_Group__c
                            ,TM_Section_Group__r.Id
                            ,TM_Section_Group__r.Name
                            ,TM_Section_Group__r.Label__c
                            ,TM_Section_Group__r.Type__c
                            ,View_Placement__c
                            ,Edit_Placement__c
                            ,Report_Placement__c
                            ,Readonly__c
                        FROM
                            Contact_Options__r
                        ORDER BY
                            Edit_Placement__c,View_Placement__c
                    )
                    ,(
                        SELECT
                            Name
                            ,Field_Name__c
                            ,Object_Name__c
                            ,Title__c
                            ,View__c
                            ,Edit__c
                            ,Report__c
                            ,Section__c
                            ,Columns__c
                            ,Correlated__c
                            ,Alternate_Field_Name__c
                            ,TM_Section__r.Name
                            ,TM_Section__r.Label__c
                            ,TM_Section__r.Number_Of_Columns__c
                            ,TM_Section__r.Show__c
                            ,TM_Section_Group__c
                            ,TM_Section_Group__r.Id
                            ,TM_Section_Group__r.Name
                            ,TM_Section_Group__r.Label__c
                            ,TM_Section_Group__r.Type__c
                            ,View_Placement__c
                            ,Edit_Placement__c
                            ,Report_Placement__c
                            ,Readonly__c
                        FROM
                            Account_Options__r
                        ORDER BY
                            Edit_Placement__c,View_Placement__c
                    )
                    ,(
                        SELECT
                            Name
                            ,Field_Name__c
                            ,Object_Name__c
                            ,Title__c
                            ,View__c
                            ,Edit__c
                            ,Report__c
                            ,Section__c
                            ,Columns__c
                            ,Correlated__c
                            ,Alternate_Field_Name__c
                            ,TM_Section__r.Name
                            ,TM_Section__r.Label__c
                            ,TM_Section__r.Number_Of_Columns__c
                            ,TM_Section__r.Show__c
                            ,TM_Section_Group__c
                            ,TM_Section_Group__r.Id
                            ,TM_Section_Group__r.Name
                            ,TM_Section_Group__r.Label__c
                            ,TM_Section_Group__r.Type__c
                            ,View_Placement__c
                            ,Edit_Placement__c
                            ,Report_Placement__c
                            ,Readonly__c
                        FROM
                            Contact_Account_Options__r
                        ORDER BY
                            Edit_Placement__c,View_Placement__c
                    )
                    ,(
                        SELECT
                            Id
                            ,Name
                            ,Label__c
                            ,Section__c
                            ,Type__c
                            ,TM_Service_Configuration__c
                            ,TM_Service_Configuration__r.Product_Name__c
                        FROM
                            TM_Service_Configuration_Field_Details__r
                        ORDER BY
                            Name
                    )                   
                FROM
                    TM_Service_Configuration__c
                ORDER BY
                    Product_Name__c
            ];
        }

        private Map<Id, TmBoarding.requestPm> buildAllPms(List<string> requestFields, List<string> contactAccountFields, List<string> coreContacts, List<string> coreEbAccounts, List<Tm_Service_Request__c> reqs) {
            Map<Id, TmBoarding.requestPm> requestMap = new Map<Id, TmBoarding.requestPm>();
            Account entity = getEntity2(reqs[0].TM_Service_Request_Packet__r.Entity__r.Id,coreContacts, coreEbAccounts);
            Account entityPm = new Account(Id=entity.Id, Name = entity.Name, Date_TM_Master_Agmt_Signed__c = entity.Date_TM_Master_Agmt_Signed__c);
            List<TM_Service_Request__c> packetRequestPms = getRequestsForPacket(reqs[0].TM_Service_Request_Packet__r.Id);
            Tm_Service_Request_Packet__c packetPm = reqs[0].TM_Service_Request_Packet__r;
            List<Eb_Account__c> accountPms = getEbAccounts(entity.EB_Account_Relationships__r);
            List<Contact> contactPms = entity.Contacts;

            for(TM_Service_Request__c req : reqs) {
                TmBoarding.requestPm requestPm = new TmBoarding.requestPm();
                requestPm.requestPm = req;
                requestPm.packetPm = packetPm;
                requestPm.packetRequestsPm = packetRequestPms;
                requestPm.entityPm = entityPm;
                requestPm.contactPms = contactPms;
                requestPm.accountPms = accountPms;
                requestPm.serviceContactPms = req.TM_Service_Request_Contacts__r;
                requestPm.serviceAccountPms = req.TM_Service_Request_Accounts__r;
                requestPm.serviceContactAccountPms = new List<TM_Service_Request_Contact_Account__c>();
                requestMap.put(req.Id, requestPm);
            }
            return requestMap;
        } 

}