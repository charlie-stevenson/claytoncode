@istest(SeeAllData=true)

public class test_delete_tasks {

public testMethod static void create_task_try_delete() {

recordtype MAPRT = [select id from recordtype where sobjecttype = 'Contact' and name = 'MAP' limit 1];

contact c = new contact (lastname = 'smith2153135', recordtypeid = MAPRT.id);

profile userprofile = [select name, id from profile where name = 'MAP TM Team' limit 1];

User u1 = new User( email='test-user@fakeemail.com', UserName='test-user321123212313@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',
TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',
LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User', initials__c = '9x', profileid = userprofile.id, isactive = true );

insert u1; 

task t = new task
    (whatid  = c.id,
     subject = 'hello');

system.runas(u1) {insert t;}

try {system.runas(u1) {delete t;}}
catch (System.DmlException e){

System.assertequals(string.valueof(e).contains('cant delete tasks'),true);
}
}
}