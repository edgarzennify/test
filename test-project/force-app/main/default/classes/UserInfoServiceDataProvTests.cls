@isTest
public class UserInfoServiceDataProvTests {
	private static final UserInfoService.IUserInfoServiceDataProv sut;
    static{
        sut = new UserInfoServiceDataProv();
    }
    private static testMethod void it_should_return_a_profile_when_getUserProfile_is_called_with_a_user_id(){
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
        User u = [SELECT Id, ProfileId FROM User WHERE ProfileId =: p.Id LIMIT 1];
        
        Profile results = sut.getUserProfile(u.Id);
        
        system.assertEquals(u.ProfileId, results.Id);
    }
    private static testMethod void it_should_call_getPermissionSetAssignments_and_return_a_list_of_permissionSetAssignments(){
        PermissionSetAssignment psa = [SELECT Id, PermissionSetId FROM PermissionSetAssignment LIMIT 1];
        PermissionSet ps = [SELECT Id, Label FROM PermissionSet WHERE Id =: psa.PermissionSetId];
        String permissionSetLabel = ps.Label;
        
        List<PermissionSetAssignment> results = sut.getPermissionSetAssignments(permissionSetLabel);
        
        system.assertEquals(ps.Id, results[0].PermissionSetId);
    }
    private static testMethod void it_should_return_a_list_of_users_when_getUsersWithPermissionSet_is_called_with_a_list_of_userIds(){
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Label = 'Function - Loan Force Read/Write'];
        PermissionSetAssignment psa = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId =: ps.Id LIMIT 1];
        User u = [SELECT Id FROM User WHERE Id =: psa.AssigneeId];
        
        List<Id> userIds = new List<Id>();
        userIds.add(u.Id);
        
        List<User> results = sut.getUsersWithPermissionSet(userIds);
        
        system.assertEquals(u.Id, results[0].Id);
        
    }
    private static testMethod void it_should_return_a_list_of_users_when_getUsers_is_called_with_no_arguments(){
        List<User> results = new List<User>();
        
        results = sut.getUsers();
        
        system.assertEquals(true, results.size()>0);
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Name;
        fieldInResult = results[0].ProfileId;
        fieldInResult = results[0].UserRoleId;
    }
    private static testMethod void it_should_return_a_map_when_getUserRoles_is_called_with_no_arguments(){
        Map<Id, UserRole> results = sut.getUserRoles();
        system.assertEquals(true, results.size() > 0);
    }
    private static testMethod void it_should_return_a_list_of_permission_sets_when_getPermissionSetsToLoad_is_called_with_a_userId(){
        PermissionSetAssignment psa = [SELECT Id, AssigneeId FROM PermissionSetAssignment LIMIT 1];
        User u = [SELECT Id FROM User WHERE Id=: psa.AssigneeId LIMIT 1];
        List<PermissionSet> results = sut.getPermissionSetsToLoad(u.Id);
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Name;
        fieldInResult = results[0].Label;
        fieldInResult = results[0].Description;
    }
}