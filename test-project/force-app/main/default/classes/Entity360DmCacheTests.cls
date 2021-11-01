@IsTest
private class Entity360DmCacheTests {
	
	private final static Entity360DmCache sut;
	static{
		sut = new Entity360DmCache();
	}

	private static testMethod void it_should_set_dm_entity_map_and_call_get_to_confirm_the_set() {
		String key = 'testEntity';
		DmEntity value = new DmEntity();
		Map<String,DmEntity> entities = new Map<String,DmEntity>();
		entities.put(key, value);

		sut.setEntityDmsMap(entities);

		DmEntity expectedValue = sut.getEntityDmsMap().get(key);
		System.assertEquals(value, expectedValue);
	}
}