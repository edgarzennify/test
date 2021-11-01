public class SL_Greetings {
	@AuraEnabled
    public static User getUser() {
        Id userId = UserInfo.getUserId();
        return [SELECT FirstName, LastName FROM User WHERE Id=:userId];
    }
}