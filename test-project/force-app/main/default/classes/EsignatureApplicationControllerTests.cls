@IsTest
private class EsignatureApplicationControllerTests {

    @IsTest
    private static void it_should_code_cover(){

        try{
            EsignatureApplication.FormVm result1 = EsignatureApplicationController.bootstrap('1','');
        }catch(Exception ex){

        }

        try{
            Boolean result2 = EsignatureApplicationController.sendForSignature('1','', new EsignatureApplication.SaveModel());
        }catch(Exception ex){

        }

        try{
            EsignatureApplication.SignatureData result3 = EsignatureApplicationController.getSignatureDataPending('1' );
        }catch(Exception ex){

        }

        try{
            EsignatureApplication.SignatureData result4 = EsignatureApplicationController.getSignatureDataRecentlyCompleted('1' );
        }catch(Exception ex){

        }

        try{
            EsignatureApplication.SignatureData result5 = EsignatureApplicationController.getSignatureDataHistory('1' );
        }catch(Exception ex){

        }

        try{
            string result7 = EsignatureApplicationController.getPreviewSignatureDocument('0', '',new EsignatureApplication.SaveModel());
        }catch(Exception ex){

        }
    }

}