public class CachedMap implements ICachedMap {

    public interface ICachedMap {
        void put(String key, Object value);
        Object get(String key);
        Boolean containsKey(String key);
        Integer size();
        void remove(String key);
        List<Object> values();
        void clear();
    }

    private static ICachedMap m_singleton;
    private Map<String, Object> m_map;

    private CachedMap(){
        m_map = new Map<String, Object>();
    }

    public static ICachedMap getInstance(){
        if(m_singleton == null) {
            m_singleton = new CachedMap();
        } return m_singleton;
    }

    public void put(String key, Object value){
        m_map.put(key, value);
    }

    public Object get(String key){
        return m_map.get(key);
    }

    public Boolean containsKey(String key){
        return m_map.containsKey(key);
    }

    public Integer size(){
        return m_map.size();
    }

    public void remove(String key){
        m_map.remove(key);
    }

    public List<Object> values(){
        return m_map.values();
    }

    public void clear(){
        m_map.clear();
    }
}