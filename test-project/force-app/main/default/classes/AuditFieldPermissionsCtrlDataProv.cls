public class AuditFieldPermissionsCtrlDataProv implements AuditFieldPermissions.IAuditFieldPermissionsCtrlDataProv {

    public List<PM_PermissionSet> getFieldAccessInformation(String fieldName) {
        String objectName = fieldName.substring(0,fieldName.indexOf('.'));
        List<FieldPermissions> lfp = [SELECT ParentId, Parent.Name FROM FieldPermissions WHERE Field =: fieldName];

        Set<String> Ids = new Set<String>();
        for (FieldPermissions fp : lfp) {
			Ids.add(fp.parentId);
        }
 
        List<PermissionSet> permSets = [
            SELECT
                Id
                ,Name
                ,Label
                ,Profile.Name
                    ,(  SELECT
                            Field,
                            PermissionsRead,
                            PermissionsEdit
                        FROM
                            FieldPerms
                        WHERE
                            Field =: fieldName
                        AND
                            (PermissionsRead = true OR PermissionsEdit = true))
                    ,(  SELECT
                            PermissionsRead,
                            PermissionsEdit
                        FROM
                            Objectperms
                        WHERE
                            SobjectType =: objectName)
                    ,(  SELECT
                            AssigneeId
                            ,Assignee.Name
                        FROM
                            Assignments
                        WHERE
                            Assignee.IsActive = true) 
            FROM
                PermissionSet 
            WHERE
                Id IN : Ids
            LIMIT 10000
        ];

        List<PM_PermissionSet> pmPermSets = new List<PM_PermissionSet>();
        for (PermissionSet ps : permSets) {
            PM_PermissionSet pm = new PM_PermissionSet();
            pm.Id = ps.Id;
            pm.Name = ps.Name;
            pm.Label = ps.Label;
            pm.Profile = new PM_Profile();
            pm.Profile.Name = ps.Profile.Name;
            
            pm.FieldPerms = new List<PM_FieldPermissions>();
            for (FieldPermissions fp : ps.FieldPerms) {
                PM_FieldPermissions pmFp = new PM_FieldPermissions();
                pmFp.Field = fp.Field;
                pmFp.PermissionsRead = fp.PermissionsRead;
                pmFp.PermissionsEdit = fp.PermissionsEdit;
                pmFp.Parent = pm;
                pm.FieldPerms.add(pmFp);
            }

            pm.ObjectPerms = new List<PM_ObjectPermissions>();
            for (ObjectPermissions op : ps.ObjectPerms) {
                PM_ObjectPermissions pmOp = new PM_ObjectPermissions();
                pmOp.PermissionsRead = op.PermissionsRead;
                pmOp.PermissionsEdit = op.PermissionsEdit;
                pmOp.Parent = pm;
                pm.ObjectPerms.add(pmOp);
            }

            pm.Assignments = new List<PM_PermissionSetAssignment>();
            for (PermissionSetAssignment psa : ps.Assignments) {
                PM_PermissionSetAssignment pmPsa = new PM_PermissionSetAssignment();
                pmPsa.Assignee = new PM_User();
                pmPsa.Assignee.Name = psa.Assignee.Name;
                pmPsa.Assignee.Id = psa.Assignee.Id;
                pmPsa.Parent = pm;
                pm.Assignments.add(pmPsa);
            }

            pmPermSets.add(pm);
        }
        return pmPermSets != null ? pmPermSets : new List<PM_PermissionSet>();
    }

    public Set<String> getNamespaces() {
        List<EntityDefinition> eds = [
            SELECT
                NamespacePrefix
            FROM
                EntityDefinition
        ];

        Set<String> output = new Set<String>();
        for (EntityDefinition ed : eds) {
            if (!String.isBlank(ed.NamespacePrefix)) {
                output.add(ed.NamespacePrefix);
            }
        }
        return output;
    }

    public List<PM_EntityDefinition> getObjects(String namespace) {
        List<EntityDefinition> eds = new List<EntityDefinition>();
        if (String.isBlank(namespace)) {
            List<EntityDefinition> allObjs = getAllObjects();
            for (EntityDefinition obj : allObjs) {
                if (obj.NamespacePrefix == null) { eds.add(obj); }
            }
        } else {
            eds = getObjectsByNamespace(namespace);
        }        
        
        List<PM_EntityDefinition> output = new List<PM_EntityDefinition>();
        for (EntityDefinition ed : eds) {
            if (objectNameIsValid(ed.QualifiedApiName)) {
                PM_EntityDefinition pm = new PM_EntityDefinition();
                pm.DeveloperName = ed.DeveloperName;
                pm.QualifiedApiName = ed.QualifiedApiName;
                output.add(pm);
            }
        }
        return output;
    }

    private List<EntityDefinition> getAllObjects() {
        return [
            SELECT
                QualifiedApiName, DeveloperName, NamespacePrefix
            FROM
                EntityDefinition
        ];
    }

    private List<EntityDefinition> getObjectsByNamespace(String namespace) {
        return [
            SELECT
                QualifiedApiName, DeveloperName
            FROM
                EntityDefinition
            WHERE
                NamespacePrefix =: namespace
        ];
    }

    private Boolean objectNameIsValid(String fieldApiName) {
        if (fieldApiName.endsWith('__Tag')
                || fieldApiName.endsWith('__History')
                || fieldApiName.endsWith('__Feed')
                || fieldApiName.endsWith('__ChangeEvent')
                || fieldApiName.endsWith('__Share')) {
            return false;
        }
        return true;
    }

    public List<PM_FieldDefinition> getFields(String selectedObject) {
        List<FieldDefinition> fds = [
            SELECT
                QualifiedApiName, DeveloperName
            FROM
                FieldDefinition
            WHERE
                EntityDefinitionId =: selectedObject
        ];

        List<PM_FieldDefinition> output = new List<PM_FieldDefinition>();
        for (FieldDefinition fd : fds) {
            PM_FieldDefinition pm = new PM_FieldDefinition();
            pm.DeveloperName = fd.DeveloperName;
            pm.QualifiedApiName = fd.QualifiedApiName;
            output.add(pm);
        }
        return output;
    }
}