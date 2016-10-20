@isTest
private class test_IDGRegHandler {
static testMethod void testCreateAndUpdateUser() {
    IDGRegHandler handler = new IDGRegHandler();
  
    Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
    User existinguser = new User( email='exist-user@fakeemail.com', UserName='exist-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',
    TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',
    LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User', initials__c = '9x', profileid = p.id, isactive = true );

    insert existinguser;
	String exist_uid = existinguser.id;
    
    Auth.UserData good_sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
        'testNewFirst testNewLast', 'new-user@fakeemail.com', null, 'testnewuserlong', 'en_US', 'OpenID',
        null, new Map<String, String>{});

/*1. try to create a user - should not work*/    
    
    user created_user = handler.createUser(null, good_sampledata);
    system.assertEquals(null, created_user);

/* try the update user - doesn't actually do anything but should work*/
        
    handler.updateUser(exist_uid, null, good_sampleData);
    
    User updatedUser = [SELECT userName, email, firstName, lastName, alias FROM user WHERE id=:exist_uid];
    System.assertEquals('exist-user@fakeemail.com', updatedUser.email);
}
}