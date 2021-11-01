//NOTE: This unit test is a temporary measure to just cover the code in UserTrigger. It will be replaced in a future version

@isTest
public with sharing class TestUserTrigger 
{
	static testMethod void testInsertNewUser()
	{
		User newUser = new User();
		newUser.FirstName = 'John';
		newUser.LastName = 'Smith';
		newUser.Distribution_Channel__c = 'Consumer Banking';
		newUser.Referral_Routing_Team__c = 'Team 1';
		try
		{
			insert newUser;
			
			List<User> users = [SELECT Id FROM User WHERE Id =: newUser.Id];
			
			if(!users.isEmpty())
				System.debug('NEW USER: ' + users);
			else
				System.debug('NO USERS');
		}
		catch(DmlException e) 
		{
	    	System.debug('The following exception has occurred: ' + e.getMessage());
		}
		
		
	}
}