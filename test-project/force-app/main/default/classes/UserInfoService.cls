public class UserInfoService implements IUserInfoService{
    
    public interface IUserInfoServiceDataProv{
        Profile getUserProfile(Id userId);
        List<PermissionSetAssignment> getPermissionSetAssignments(String permissionSetLabel);
        List<User> getUsersWithPermissionSet(List<Id> userIds);
        List<User> getUsers();
        Map<Id , UserRole> getUserRoles();
        List<PermissionSet> getPermissionSetsToLoad(Id userId);
    }
    
    private Configurations.IConfigurations m_config;
    private UserInfoService.IUserInfoServiceDataProv m_dataProv; 
    
    public UserInfoService(Configurations.IConfigurations config, UserInfoService.IUserInfoServiceDataProv dataProv){
        m_config = config;
        m_dataProv = dataProv;
    }
    
    Map<Id, Profile> m_cachedProfilesByUserId {
        get{
            if(m_cachedProfilesByUserId == null){
                m_cachedProfilesByUserId = new Map<Id, Profile>();
            }
            return m_cachedProfilesByUserId;
        }
        set;
    }
    
    Map<Id, Map<String, PermissionSet>> m_cachedPermissionSetsByUserId{
        get{
            if(m_cachedPermissionSetsByUserId == null){
                m_cachedPermissionSetsByUserId = new Map<Id, Map<String, PermissionSet>>();
            }
            return m_cachedPermissionSetsByUserId;
        }
        set;
    }

    private Map<User, UserRole> m_userRoles;
    

    public Id getCurrentUserId(){
        return UserInfo.getUserId();
    }

    public Boolean isSystemAdministrator(){
       return isSystemAdministrator(getCurrentUserId());
    }
    
    
    public Boolean isSystemAdministrator(Id userId){
       Profile p = getProfile(userId);
       String adminString = m_config.get('System Administrator Profiles');
       return (adminString.contains(p.Name)) ? true : false;
    }

    public Boolean hasPermissionSet(String permissionSetLabel){
        return hasPermissionSet(getCurrentUserId(), permissionSetLabel);
    }
    
    public Boolean hasPermissionSet(Id userId, String permissionSetLabel){
        Boolean userHasPermissionSet = false;
        Map<String, PermissionSet> userPermissions = getPermissionSets(userId);
        if(userPermissions != null){
            PermissionSet targetPermission = userPermissions.get(permissionSetLabel);
            if(targetPermission != null){
                userHasPermissionSet = true;
            }
        }
        return userHasPermissionSet;
    }

    public Profile getProfile(){
        return getProfile(getCurrentUserId());
    }
    
    public Profile getProfile(Id userId){
        if(m_cachedProfilesByUserId.containsKey(userId)){
            return m_cachedProfilesByUserId.get(userId);
        }       
        return loadProfile(userId);
    }

    public Map<String,PermissionSet> getPermissionSets(){
        return getPermissionSets(getCurrentUserId());      
    }

    public Map<String,PermissionSet> getPermissionSets(Id userId){
        if(m_cachedPermissionSetsByUserId.containsKey(userId)){
            return m_cachedPermissionSetsByUserId.get(userId);
        }
        return loadPermissionSets(userId);        
    }
    
    public List<User> getUsersWithPermissionSet(String permissionSetLabel){
        List<PermissionSetAssignment> assignments = m_dataProv.getPermissionSetAssignments(permissionSetLabel);
        List<User> usersWithPermissionSet = new List<User>();
        List<Id> userIds = new List<Id>();
        if(assignments != null){
            for(PermissionSetAssignment a : assignments){
                userIds.add(a.AssigneeId);
            }
            usersWithPermissionSet = m_dataProv.getUsersWithPermissionSet(userIds);
        }
        return usersWithPermissionSet;
    }

    public Boolean isCurrentUserLicensed(String namespace){
        if(namespace == '') return true;
        return UserInfo.isCurrentUserLicensed(namespace);
    }

    public Map<User, UserRole> getUserRoleRelationship() {
        if(m_userRoles == null) {
            m_userRoles = new Map<User, UserRole>();
            List<User> users = m_dataProv.getUsers();
            Map<Id , UserRole> roles = m_dataProv.getUserRoles();
            for(User u : users) {
                if(roles.containsKey(u.UserRoleId)){
                    m_userRoles.put(u, roles.get(u.UserRoleId));
                }
            }
        }
        return m_userRoles;
    }
    
    private Profile loadProfile(Id userId){
        Profile p = m_dataProv.getUserProfile(userId);
        m_cachedProfilesByUserId.put(userId,p);        
        return p;
    }

    private Map<String,PermissionSet> loadPermissionSets(Id userId){
        Map<String, PermissionSet> permissionSetMap = new Map<String, PermissionSet>();
        List<PermissionSet> permissionSets = m_dataProv.getPermissionSetsToLoad(userId);
        for(PermissionSet pSet : permissionSets){
            permissionSetMap.put(pSet.Label, pSet);
        }
        m_cachedPermissionSetsByUserId.put(userId,permissionSetMap);
        
        return permissionSetMap;
    }

    public static IUserInfoService bootstrap() {
        Configurations.IConfigurations config = new Configurations(new KeyValueDataProvider(CachedMap.getInstance()));
        UserInfoService.IUserInfoServiceDataProv dataProvider = new UserInfoServiceDataProv();
    
        return new UserInfoService(config, dataProvider);
    }
}