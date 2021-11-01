public with sharing class AuditFieldPermissionsCtrl {

    private AuditFieldPermissions.IAuditFieldPermissionsCtrlDataProv m_dataProv;
    private AuditFieldPermissions.IAuditFieldPermissionsHelper m_helper;

    public List<SelectOption> m_namespaceList {get; set;}
    public String m_selectedNamespace {get; set;}
    
    public List<SelectOption> m_objectList {get; set;}
    public String m_selectedObject {get; set;}

    public List<SelectOption> m_fieldList {get; set;}
    public String m_selectedField {get; set;}

    public List<AuditPermissionSetDetails> m_permissionSetsWithAccess {get; set;}
    public List<AuditProfileDetails> m_profilesWithAccess {get; set;}

    private Map<Id, AuditUserDetails> m_usersWithAccessMap {get; set;}
    public List<AuditUserDetails> m_usersWithAccess {
        get {
            if (m_usersWithAccessMap == null) {
                return new List<AuditUserDetails>();
            }
            List<AuditUserDetails> usersWithAccessReturn = m_usersWithAccessMap.values();
            usersWithAccessReturn.sort();
            return usersWithAccessReturn;
        } 
    }
    public Integer m_usersWithAccessCount {
        get {
            return m_usersWithAccess.size();
        } 
    }

    private final String SELECT_NAMESPACE_LABEL = ' --- SELECT NAMESPACE --- ';
    private final String SELECT_OBJECT_LABEL = ' --- SELECT OBJECT --- ';
    private final String SELECT_FIELD_LABEL = ' --- SELECT FIELD --- ';
    private final String SELECT_EMPTY_VALUE = '';
    private final String SELECT_STANDARD_NAMESPACE = 'Standard and Unmanaged Objects';

    public AuditFieldPermissionsCtrl() {
        m_dataProv = new AuditFieldPermissionsCtrlDataProv();
        m_helper = new AuditFieldPermissionsHelper();
    }

    public AuditFieldPermissionsCtrl(AuditFieldPermissions.IAuditFieldPermissionsCtrlDataProv dataProv, AuditFieldPermissions.IAuditFieldPermissionsHelper helper) {
        m_dataProv = dataProv;
        m_helper = helper;
    }

    public void initialize() {
        populateNamespaceList();
    }

    public void namespaceSelectedEvent() {
        m_selectedObject = SELECT_EMPTY_VALUE;
        m_selectedField = SELECT_EMPTY_VALUE;
        populateObjectList();
    }

    public void objectSelectedEvent() {
        m_selectedField = SELECT_EMPTY_VALUE;
        initializeAccessLists();
        populateFieldList();
    }

    public void fieldSelectedEvent() {
        initializeAccessLists();
        retrieveFieldSecurityDetails();
        sortAccessLists();
    }

    private void populateNamespaceList() {
        Set<String> namespaces = m_dataProv.getNamespaces();
        List<SelectOption> namespacesSelectOptions = new List<SelectOption>();
        namespacesSelectOptions.add(new SelectOption(SELECT_NAMESPACE_LABEL, SELECT_NAMESPACE_LABEL));
        namespacesSelectOptions.add(new SelectOption(SELECT_EMPTY_VALUE, SELECT_STANDARD_NAMESPACE));
        for (String namespace : namespaces) {
            namespacesSelectOptions.add(new SelectOption(namespace, namespace));
        }
        m_namespaceList = namespacesSelectOptions;   
    }

    private void populateObjectList() {
        List<PM_EntityDefinition> objs = m_dataProv.getObjects(m_selectedNamespace);
        List<SelectOption> objectListOptions = new List<SelectOption>();
        objectListOptions.add(new SelectOption(SELECT_OBJECT_LABEL, SELECT_OBJECT_LABEL));
        for (PM_EntityDefinition obj : objs) {
            objectListOptions.add(new SelectOption(obj.QualifiedApiName, obj.DeveloperName));
        }
        m_objectList = sortSelectOptionsByLabel(objectListOptions);
    }

    private void populateFieldList() {
        List<PM_FieldDefinition> fields = m_dataProv.getFields(m_selectedObject);
        List<SelectOption> fieldListSelectOptions = new List<SelectOption>();
        fieldListSelectOptions.add(new SelectOption(SELECT_FIELD_LABEL, SELECT_FIELD_LABEL));
        for (PM_FieldDefinition f : fields) {
                fieldListSelectOptions.add(new SelectOption(m_selectedObject + '.' + f.QualifiedApiName, f.DeveloperName));
            }
        m_fieldList = sortSelectOptionsByLabel(fieldListSelectOptions);
    }

    private List<SelectOption> sortSelectOptionsByLabel(List<SelectOption> selectOptionList) {
        List<SelectOption> selectOptionListLabelFirst = swapLabelAndValuePositions(selectOptionList);
        selectOptionListLabelFirst.sort();
        return swapLabelAndValuePositions(selectOptionListLabelFirst);
    }

    private List<SelectOption> swapLabelAndValuePositions(List<SelectOption> selectOptionList) {
        List<SelectOption> selectOptionListReversed = new List<SelectOption>();
        for (SelectOption option : selectOptionList) {
            selectOptionListReversed.add(new SelectOption(option.getLabel(), option.getValue()));
        }
        return selectOptionListReversed;
    }

    private void initializeAccessLists() {
        m_permissionSetsWithAccess = new List<AuditPermissionSetDetails>();
        m_profilesWithAccess = new List<AuditProfileDetails>();
        m_usersWithAccessMap = new Map<Id, AuditUserDetails>();
    }

    private void retrieveFieldSecurityDetails() {
        List<PM_PermissionSet> permissionInfoForField = m_dataProv.getFieldAccessInformation(m_selectedField);
        
        for (PM_PermissionSet permissionSetInfo : permissionInfoForField) {
            String profileName = m_helper.getProfileName(permissionSetInfo);
            PM_FieldPermissions permissionForField = m_helper.getPermissionForField(permissionSetInfo, m_selectedField);

            if (permissionForField.PermissionsRead == true || permissionForField.PermissionsEdit == true) {
                List<PM_PermissionSetAssignment> usersWithPermissions = m_helper.getAssignedUsers(permissionSetInfo);
                if (profileName == null) {
                    AuditPermissionSetDetails permissionSetDetailsItem = new AuditPermissionSetDetails(permissionSetInfo, permissionForField);
                    addPermissionSetWithAccess(permissionSetDetailsItem);
                    addUsersWithAccessByPermissionSet(usersWithPermissions, permissionSetDetailsItem);
                } else {
                    Boolean profileObjectReadPermission = m_helper.getProfileObjectReadPermission(permissionSetInfo);
                    Boolean profileObjectEditPermission = m_helper.getProfileObjectEditPermission(permissionSetInfo);
                    if (profileObjectReadPermission || profileObjectEditPermission) {
                        Id profileId = permissionSetInfo.Label;
                        updateFieldPermissionsForProfile(permissionForField, profileObjectReadPermission, profileObjectEditPermission);
                        AuditProfileDetails profileDetailsItem = new AuditProfileDetails(profileId, profileName, permissionForField);
                        addProfileWithAccess(profileDetailsItem);
                        addUsersWithAccessByProfile(usersWithPermissions, profileDetailsItem);
                    }
                }
            }
        }
    }

    private void addPermissionSetWithAccess(AuditPermissionSetDetails permissionSetDetailsItem) {
        m_permissionSetsWithAccess.add(permissionSetDetailsItem);
    }

    private void addUsersWithAccessByPermissionSet(List<PM_PermissionSetAssignment> userAssignments, AuditPermissionSetDetails permissionSet) {
        for (PM_PermissionSetAssignment assignedUser : userAssignments) {
            AuditUserDetails userToUpdate = createOrLocateUserDetailsItem(assignedUser);
            if (permissionSet.readAccess) { userToUpdate.readAccess = true; }
            if (permissionSet.editAccess) { userToUpdate.editAccess = true; }
            userToUpdate.permissionSets.add(permissionSet);
        }
    }

    private void updateFieldPermissionsForProfile(PM_FieldPermissions permissionForField, Boolean profileObjectReadPermission, Boolean profileObjectEditPermission) {
        permissionForField.PermissionsRead = (permissionForField.PermissionsRead && profileObjectReadPermission);
        permissionForField.PermissionsEdit = (permissionForField.PermissionsEdit && profileObjectEditPermission);
    }

    private void addProfileWithAccess(AuditProfileDetails profileDetailsItem) {
        m_profilesWithAccess.add(profileDetailsItem);
    }

    private void addUsersWithAccessByProfile(List<PM_PermissionSetAssignment> userAssignments, AuditProfileDetails profile) {
        for (PM_PermissionSetAssignment assignedUser : userAssignments) {
            AuditUserDetails userToUpdate = createOrLocateUserDetailsItem(assignedUser);
            if (profile.readAccess) { userToUpdate.readAccess = true; }
            if (profile.editAccess) { userToUpdate.editAccess = true; }
            userToUpdate.profile = profile;
        }
    }
    
    private AuditUserDetails createOrLocateUserDetailsItem(PM_PermissionSetAssignment assignedUserInfo) {
        if (!m_usersWithAccessMap.containsKey(assignedUserInfo.Assignee.Id)) {
            AuditUserDetails newUserDetailItem = new AuditUserDetails(assignedUserInfo);
            m_usersWithAccessMap.put(assignedUserInfo.Assignee.Id, newUserDetailItem);
        } 
        return m_usersWithAccessMap.get(assignedUserInfo.Assignee.Id);
    }

    private void sortAccessLists() {
        m_permissionSetsWithAccess.sort();
        m_profilesWithAccess.sort();
    }
}