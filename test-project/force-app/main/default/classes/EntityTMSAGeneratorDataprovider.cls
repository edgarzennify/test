public class EntityTMSAGeneratorDataprovider extends DataProvider implements EntityTMSAGenerator.IDataprovider {

        public EntityTMSAGenerator.EntityPm  getExtendedEntity(Id entityId){
            Account entity = [
                SELECT
                    Id
                    ,Name
                    ,Date_TM_Master_Agmt_Signed__c
                    ,TMSA_Imaging_Document_Url__c
                    ,TMSA_Signature_Status__c
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
                FROM
                    Account
                WHERE
                    Id =: entityId
                LIMIT 1
            ];

            EntityTMSAGenerator.EntityPm pm = new EntityTMSAGenerator.EntityPm();
            pm.Entity = entity;
            pm.relatedContacts = entity == null?new List<contact>(): entity.Contacts;
            return pm;
        }
    
}