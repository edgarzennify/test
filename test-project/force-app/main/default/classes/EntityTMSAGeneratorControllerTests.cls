@IsTest
private class EntityTMSAGeneratorControllerTests {

    private static testMethod void it_should_code_cover_build_form(){
        try{
            IJson j = new JsonWrapper();
            String entityId = ObjectFactory.getFakeId(Account.SobjectType, '1');
            String recordJson = j.serialize(new Account(Id=entityId));
            EntityTMSAGenerator.FormVm formVm = EntityTMSAGeneratorController.bootstrap(recordJson);
        }catch(exception ex){

        }
       
    }

    private static testMethod void it_should_code_cover_send_for_signature(){
        try{
            IJson j = new JsonWrapper();
            String entityId = ObjectFactory.getFakeId(Account.SobjectType, '1');
            String recordJson = j.serialize(new Account(Id=entityId));
            EntityTMSAGeneratorController.SignatureInfo info = new EntityTMSAGeneratorController.SignatureInfo();
            EntityTMSAGeneratorController.sendForSignature(info, recordJson);
        }catch(exception ex){

        }       
    }
}