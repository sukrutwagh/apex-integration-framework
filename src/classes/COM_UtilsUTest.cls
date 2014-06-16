@isTest
private class COM_UtilsUTest {

    static testMethod void isEmptyTest (){
		system.assertEquals(true, COM_Utils.isEmpty(null));
		system.assertEquals(true, COM_Utils.isEmpty(' '));
		system.assertEquals(false, COM_Utils.isEmpty('asd'));
		//system.assertEquals(true, COM_Utils.isEmpty(new Map<String,String>()));
		//system.assertEquals(true, COM_Utils.isEmpty(new Map<Object,Object>()));
		//system.assertEquals(true, COM_Utils.isEmpty(new Set<String>()));
		//system.assertEquals(true, COM_Utils.isEmpty(new Set<Object>()));
		List<String> strings = new List<String>();
		system.assertEquals(true, COM_Utils.isEmpty(strings));
		strings.add('asd');
		system.assertEquals(false, COM_Utils.isEmpty(strings));
		List<Object> objects = new List<Object>();
		system.assertEquals(true, COM_Utils.isEmpty(objects));
		objects.add('asd');
		system.assertEquals(false, COM_Utils.isEmpty(objects));
	}
	
	static testMethod void isNotEmptyTest (){
		system.assertEquals(true, COM_Utils.isNotEmpty('asd'));
		system.assertEquals(false, COM_Utils.isNotEmpty(' '));
		List<String> strings = new List<String>();
		system.assertEquals(false, COM_Utils.isNotEmpty(strings));
		strings.add('asd');
		system.assertEquals(true, COM_Utils.isNotEmpty(strings));
		List<Object> objects = new List<Object>();
		system.assertEquals(false, COM_Utils.isNotEmpty(objects));
		objects.add('asd');
		system.assertEquals(true, COM_Utils.isNotEmpty(objects));
	}
}