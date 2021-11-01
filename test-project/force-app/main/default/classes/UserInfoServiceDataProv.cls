public class UserInfoServiceDataProv extends DataProvider implements UserInfoService.IUserInfoServiceDataProv{
	
    public Profile getUserProfile(Id userId){
        return [SELECT Id, Name FROM Profile WHERE Id IN (SELECT ProfileId FROM User WHERE Id =: userId)];
    }
    public List<PermissionSetAssignment> getPermissionSetAssignments(String permissionSetLabel){
        return [SELECT AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId IN (SELECT Id FROM PermissionSet WHERE Label =: permissionSetLabel)];
    }
    public List<User> getUsersWithPermissionSet(List<Id> userIds){
        return [SELECT Id, Name FROM User WHERE Id IN: userIds];
    }
    public List<User> getUsers(){
        return [SELECT Id, Name, ProfileId, UserRoleId FROM User];
    }
    public Map<Id, UserRole> getUserRoles(){
        List<UserRole> roleList = [SELECT Id, Name FROM UserRole];
        Map<Id, UserRole> roleMap = new Map<Id, UserRole>();
        roleMap.putAll(roleList);
        return roleMap;
    }
    public List<PermissionSet> getPermissionSetsToLoad(Id userId){
        return [SELECT Id, Label, Name, Description FROM PermissionSet WHERE Id IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: userId)];
    }
}