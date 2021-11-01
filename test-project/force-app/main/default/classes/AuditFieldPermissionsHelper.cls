public with sharing class AuditFieldPermissionsHelper implements AuditFieldPermissions.IAuditFieldPermissionsHelper {

    public List<PM_PermissionSetAssignment> getAssignedUsers(PM_PermissionSet permissionSet) {
        return permissionSet.Assignments;
    }

    public PM_FieldPermissions getPermissionForField(PM_PermissionSet permissionSet, String fieldName) {
    	for (PM_FieldPermissions fieldPerm : permissionSet.FieldPerms) {
    		if (fieldPerm.Field == fieldName) { return fieldPerm; }
    	}
    	return new PM_FieldPermissions();
    }

    public String getProfileName(PM_PermissionSet permissionSet) {
    	return permissionSet.Profile.Name;
    }

    public Boolean getProfileObjectReadPermission(PM_PermissionSet profilePermissionSet) {
        Boolean profileObjectReadPermission = false;
        if (profilePermissionSet.Objectperms.size() > 0) {
            profileObjectReadPermission = profilePermissionSet.Objectperms[0].PermissionsRead;
        }
        return profileObjectReadPermission;
    }

    public Boolean getProfileObjectEditPermission(PM_PermissionSet profilePermissionSet) {
        Boolean profileObjectEditPermission = false;
        if (profilePermissionSet.Objectperms.size() > 0) {
            profileObjectEditPermission = profilePermissionSet.Objectperms[0].PermissionsEdit;
        }
        return profileObjectEditPermission;
    }
}