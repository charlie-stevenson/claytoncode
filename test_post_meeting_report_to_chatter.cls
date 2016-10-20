@istest(seeAllData=true)
public class test_post_meeting_report_to_chatter {

public testMethod static void go() {

/*make a test account & contact */

        list<recordtype> AdSalesRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];

        Account newAdSalesAccount = new Account (
            name='testaccount17393',
            recordtypeid = AdSalesRT[0].id,
            Credit_Rating__c = 'Green');

        insert newAdSalesAccount;    

		list<recordtype> AdSalesContactRT = [select id from recordtype where sobjecttype = 'Contact' and name = 'Ad Sales' limit 1];
    
		contact firstrep = new contact (
            lastname='kgkjhkjh21',
            accountid = NewAdSalesAccount.id,
            recordtypeid = AdSalesContactRT[0].id,
            email = 'sdfkjhsdafkjhy@ksdeyhfiewh524.com',
            title = 'asfkjhasf',
            account_type__c = 'Client',
            Role__c         = 'Marketing Manager (Media Facing)',
            Seniority__c    = 'Executive');
        insert firstrep;

/*create a test user*/
profile userprofile = [select name, id from profile where name = 'MAP TM Team' limit 1];
    
User u1 = new User( email='test-user@fakeemail.com', UserName='test-user32dh212313@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',
		TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',
		LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User', initials__c = '9x', profileid = userprofile.id, isactive = true );
insert u1;

/* make a test event (meeting)	*/
        event new_event = new event(
        	subject = 'something',
        	ActivityDate = date.today(),
        	whoid = firstrep.id,
            whatid = newAdSalesAccount.id,
        	description = 'some description',
        	meeting_summary__c = 'a summary',
            follow_up_actions__c = 'do these tasks',
            Who_would_you_like_to_inform__c = 'Test User',
            DurationInMinutes = 1,
            ActivityDateTime = date.today()
        );
        insert new_event;
    
/*Run the Post*/
        list<string> eventids = new list<string> ();
		eventids.add(new_event.Id);
		Post_Meeting_Report_to_Chatter.Post_Me(eventids);
    
/*Did it work*/

list<EventFeed> test_feeditems = [SELECT Id, Type, Body 
				FROM EventFeed
				WHERE ParentId = :new_event.Id
				ORDER BY CreatedDate DESC];

    system.assertEquals(false,test_feeditems[0].body==null);
    system.assertEquals(true,test_feeditems[0].body.contains('kgkjhkjh21'));
    system.assertEquals(true,test_feeditems[0].body.contains('@Test User'));

/*Make a test task (email)*/
        task new_task = new task(
            subject = 'something',
            ActivityDate = date.today(),
            whoid = firstrep.id,
            whatid = newAdSalesAccount.id,
            description = 'some description',
            Who_would_you_like_to_inform__c = 'Test User'
            );
        insert new_task;

/*Run the Post*/
        list<string> taskids = new list<string> ();
        taskids.add(new_task.Id);
        Post_Call_Email_to_Chatter.Post_Me(taskids);

/*Did it work*/

list<TaskFeed> test_taskfeeditems = [SELECT Id, Type, Body 
                FROM TaskFeed
                WHERE ParentId = :new_task.Id
                ORDER BY CreatedDate DESC];

    system.assertEquals(false,test_taskfeeditems[0].body==null);
    system.assertEquals(true,test_taskfeeditems[0].body.contains('kgkjhkjh21'));
    system.assertEquals(true,test_taskfeeditems[0].body.contains('@Test User'));

    }
}