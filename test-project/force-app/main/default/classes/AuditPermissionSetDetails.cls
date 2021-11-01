public class AuditPermissionSetDetails implements Comparable {

	public Id permissionSetId {get; set;}
	public String permissionSetName {get; set;}
	public Boolean readAccess {get; set;}
	public Boolean editAccess {get; set;}

	public Integer compareTo(Object compareTo) {
        AuditPermissionSetDetails compareToRelatedItem = (AuditPermissionSetDetails)compareTo;
        if (permissionSetName < compareToRelatedItem.permissionSetName) { return -1; }
        if (permissionSetName == compareToRelatedItem.permissionSetName) { return 0; }
        return 1;
    }

	public AuditPermissionSetDetails() {
		permissionSetName = '';
		readAccess = false;
		editAccess = false;
	}

	public AuditPermissionSetDetails(PM_PermissionSet permissionSet, PM_FieldPermissions fieldPermission) {
        permissionSetId = permissionSet.Id;
        permissionSetName = permissionSet.Name;
        readAccess = fieldPermission.PermissionsRead;
        editAccess = fieldPermission.PermissionsEdit;
 	}
}