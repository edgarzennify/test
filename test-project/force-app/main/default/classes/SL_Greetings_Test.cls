@isTest
public class SL_Greetings_Test {
    @isTest
    static void testGetUser() {
        User curUser = new User(
            FirstName='Testovich', 
            LastName='Testerenko',
            Username='testerTest@test-company.com', 
            Email='testerTest@test.com', 
            Alias='testic', 
            CommunityNickname='testic', 
            TimeZoneSidKey='Europe/Rome', 
            LocaleSidKey='en_US ', 
            EmailEncodingKey='UTF-8', 
            ProfileId='00e30000001AjxHAAS', 
            LanguageLocaleKey='en_US'
        );
        insert curUser;

        User getCurUser;

        System.runAs(curUser) {
            Test.startTest();
            getCurUser = SL_Greetings.getUser();
            Test.stopTest();
        }

        System.assertEquals('Testovich', getCurUser.FirstName);
    }
}