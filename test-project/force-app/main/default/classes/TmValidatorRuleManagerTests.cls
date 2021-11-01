@IsTest
private class TmValidatorRuleManagerTests {

	private static TmValidatorRuleManager sut;

	static {
		sut= new TmValidatorRuleManager();
	}

	private static testMethod void it_should_group_rules_when_one_parent_and_one_child_is_present() {
		String parentId = 'aasx123';
		String parentField = 'parent-field';
		String childId = 'child-id';
		String objectName = 'object-name';

		//Parent - list<child>
		DmTmRule parent = new DmTmRule();
		parent.Id = parentId;
		parent.objectName = objectName;
		parent.FieldName = parentField;
		parent.Operand = '1';
		parent.Operation = '>'; 
		parent.parentId = parentId;

		DmTmRule child = new DmTmRule();
		child.objectName = objectName;
		child.Id = childId;
		child.ParentId = parentId;

		List<DmTmRule> dms = new List<DmTmRule>{parent, child};

		Map<DmTmRule, List<DmTmRule>> result =  sut.getGrouped(dms);

		Set<DmTmRule> keys = result.keySet();
		List<DmTmRule> resultKeys = new List<DmTmRule>();
		resultKeys.addAll(keys);

		List<DmTmRule> resultChildren = result.get(parent);

		System.assertEquals(parentId, resultKeys[0].Id);
		System.assertEquals(childId, resultChildren[0].Id);
		System.assertEquals(parentId, resultChildren[0].ParentId);
	}

	private static testMethod void it_should_group_rules_when_one_parent_and_two_child_is_present() {
		String parentId = 'aasx123';
		String parentField = 'parent-field';
		String childId1 = 'child-id1';
		String childId2 = 'child-id2';
		String objectName = 'object-name';

		//Parent - list<child>
		DmTmRule parent = new DmTmRule();
		parent.Id = parentId;
		parent.objectName = objectName;
		parent.FieldName = parentField;
		parent.Operand = '1';
		parent.Operation = '>'; 
		parent.parentId = parentId;

		DmTmRule child1 = new DmTmRule();
		child1.objectName = objectName;
		child1.Id = childId1;
		child1.ParentId = parentId;

		DmTmRule child2 = new DmTmRule();
		child2.objectName = objectName;
		child2.Id = childId2;
		child2.ParentId = parentId;

		List<DmTmRule> dms = new List<DmTmRule>{parent, child1, child2};

		Map<DmTmRule, List<DmTmRule>> result =  sut.getGrouped(dms);

		Set<DmTmRule> keys = result.keySet();
		List<DmTmRule> resultKeys = new List<DmTmRule>();
		resultKeys.addAll(keys);

		List<DmTmRule> resultChildren = result.get(parent);

		System.assertEquals(parentId, resultKeys[0].Id);
		System.assertEquals(childId1, resultChildren[0].Id);
		System.assertEquals(parentId, resultChildren[0].ParentId);

		System.assertEquals(childId2, resultChildren[1].Id);
		System.assertEquals(parentId, resultChildren[1].ParentId);
	}

	private static testMethod void it_should_group_rules_when_one_parent_and_two_child_is_present_and_one_parent_with_no_children_available() {
		String parentId1 = 'aasx123';
		String parentField1 = 'parent-field1';
		String parentId2 = 'aasx1231';
		String parentField2 = 'parent-field2';
		String childId1 = 'child-id1';
		String childId2 = 'child-id2';
		String objectName = 'object-name';

		//Parent - list<child>
		DmTmRule parent1 = new DmTmRule();
		parent1.Id = parentId1;
		parent1.objectName = objectName;
		parent1.FieldName = parentField1;
		parent1.Operand = '1';
		parent1.Operation = '>';
		parent1.parentId = parentId1;

		DmTmRule parent2 = new DmTmRule();
		parent2.Id = parentId2;
		parent2.objectName = objectName;
		parent2.FieldName = parentField2;
		parent2.Operand = '1';
		parent2.Operation = '>'; 
		parent2.parentId = parentId2; 

		DmTmRule child1 = new DmTmRule();
		child1.objectName = objectName;
		child1.Id = childId1;
		child1.ParentId = parentId1;

		DmTmRule child2 = new DmTmRule();
		child2.objectName = objectName;
		child2.Id = childId2;
		child2.ParentId = parentId1;

		List<DmTmRule> dms = new List<DmTmRule>{parent2, parent1, child1, child2};

		Map<DmTmRule, List<DmTmRule>> result =  sut.getGrouped(dms);

		Set<DmTmRule> keys = result.keySet();
		List<DmTmRule> resultKeys = new List<DmTmRule>();
		resultKeys.addAll(keys);

		List<DmTmRule> resultChildren1 = result.get(parent2);
		List<DmTmRule> resultChildren2 = result.get(parent1);

		System.assertEquals(parentId2, resultKeys[0].Id);
		System.assertEquals(0, resultChildren1.size());

		System.assertEquals(parentId1, resultKeys[1].Id);
		System.assertEquals(2, resultChildren2.size());

		System.assertEquals(childId1, resultChildren2[0].Id);
		System.assertEquals(parentId1, resultChildren2[0].ParentId);
		System.assertEquals(childId2, resultChildren2[1].Id);
		System.assertEquals(parentId1, resultChildren2[1].ParentId);
	}
}