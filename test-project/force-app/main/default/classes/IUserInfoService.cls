public interface IUserInfoService {
    Id getCurrentUserId();
    Boolean isSystemAdministrator();
    Boolean isSystemAdministrator(Id userId);
    Boolean hasPermissionSet(String permissionSetLabel);
    Boolean hasPermissionSet(Id userId, String permissionSetLabel);
    Profile getProfile();
    Profile getProfile(Id userId);
    Map<String,PermissionSet> getPermissionSets();
    Map<String,PermissionSet> getPermissionSets(Id userId);
    List<User> getUsersWithPermissionSet(String permissionSetLabel);
    Boolean isCurrentUserLicensed(String namespace);
    Map<User, UserRole> getUserRoleRelationship();
    //UserRole getRoleForUser(Id userId);
    //List<User> getUsersForRole(String roleName);
}