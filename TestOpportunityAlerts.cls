@istest(SeeAllData=true)

public class TestOpportunityAlerts{

    static testmethod void Atttests(){
    //create opp
    // make it 'sent to ad ops'
    // attach a file

list<recordtype> AdSalesRT;
AdSalesRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];

Account newAccount = new Account (
    name='testaccount17393',
    credit_rating__c = 'green',
    account_code__c = '123',
    recordtypeid = AdSalesRT[0].id);

insert newAccount;    
    
Opportunity newOpp = new Opportunity (
    name='testing IO form 123987',
    StageName='Closed Won',
    CloseDate=date.valueof('2010-01-01'),
    AccountID=NewAccount.id,
	IP_Targeting__c='Global',
	Added_Value__c='No',
	Site_Targeting__c='Run of Site',
	AdOpsStatus__c='New');

insert newOpp;

        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=newOpp.id;
        insert attach;
        
        Note newNote=new Note();   	
    	newNote.title='testing';
    	newNote.body ='test body';
        newNote.parentId=newOpp.id;
        system.debug('banjo');
        system.debug(newOpp.id);
        insert newNote;
        
    list<feeditem> lastfeed = [SELECT Id, body FROM Feeditem WHERE ParentId = :newopp.id order by createddate desc];
    system.debug('feed size');
    system.debug(lastfeed.size());
    system.debug(lastfeed[0].body);    
    }
}