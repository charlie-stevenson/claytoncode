@istest

public class Test_setup_master_data {

public static testmethod Opportunity create()

{
list<recordtype> AdSalesRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];

Account newAdSalesAccount = new Account (
    name='testaccount17393',
    recordtypeid = AdSalesRT[0].id,
    Credit_Rating__c = 'Green');

insert newAdSalesAccount;    

list<recordtype> MAPRT = [select id from recordtype where sobjecttype = 'Account' and name = 'MAP' limit 1];

Account newMAPAccount = new Account (
    name='testaccount173543',
    recordtypeid = MAPRT[0].id,
    Credit_Rating__c = 'Green');

insert newMAPAccount;

list<recordtype> MAPcontactRT = [select id from recordtype where sobjecttype = 'Contact' and name = 'MAP' limit 1];

Contact newMAPContact = new Contact (
    lastname='testaccount173543',
    account_type__c = 'Client',
    Role__c         = 'Marketing Manager (Media Facing)',
    Seniority__c    = 'Executive',
    email           = 'testaccount173543@testaccount173543asdrf.com',
    recordtypeid = MAPcontactRT[0].id);

insert newMAPContact;

list<recordtype> AdSalesContactRT = [select id from recordtype where sobjecttype = 'Contact' and name = 'Ad Sales' limit 1];
    
contact firstrep = new contact (
    lastname='kgkjhkjh21',
    email = 'kgkjhkjh21@2354jhgtestacco.com',
    title = 'manager',
    account_type__c = 'Client',
    Role__c         = 'Marketing Manager (Media Facing)',
    Seniority__c    = 'Executive',
    accountid = NewAdSalesAccount.id,
    recordtypeid = AdSalesContactRT[0].id);
    insert firstrep;
    
list<recordtype> OnlineOppRT = [select id from recordtype where sobjecttype = 'Opportunity' and name = '3 Online' limit 1];
    
Opportunity newOpp = new Opportunity (
    recordtypeid = OnlineOppRT[0].id,
    name='testing IO form 123987',
    StageName='Closed Won',
    CloseDate=date.valueof('2010-01-01'),
    AccountID=NewAdSalesAccount.id,
    first_account_rep__c = firstrep.id,
    Added_Value__c    = 'No',
    IP_Targeting__c   = 'Global',
    Site_Targeting__c = 'Run of Site'
    );
system.debug(newopp);
insert newOpp;

return newOpp;

}
}