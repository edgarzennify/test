public class AuditFieldPermissions {

    public interface IAuditFieldPermissionsHelper {
        List<PM_PermissionSetAssignment> getAssignedUsers(PM_PermissionSet permissionSet);
    	PM_FieldPermissions getPermissionForField(PM_PermissionSet permissionSet, String fieldName);
    	String getProfileName(PM_PermissionSet permissionSet);
        Boolean getProfileObjectReadPermission(PM_PermissionSet profilePermissionSet);
        Boolean getProfileObjectEditPermission(PM_PermissionSet profilePermissionSet);
    }
    
    public interface IAuditFieldPermissionsCtrlDataProv {
        List<PM_PermissionSet> getFieldAccessInformation(String fieldName);
        Set<String> getNamespaces();
        List<PM_EntityDefinition> getObjects(String namespace);
        List<PM_FieldDefinition> getFields(String selectedObject);
    }
}