@istest

private class testInsertionOrdersController {

static testMethod void myPage_Test()

{

//Test converage for the myPage visualforce page

PageReference pageRef = Page.ShowInsertionOrders;

Test.setCurrentPageReference(pageRef);

Pricebook2 newPB2 = new Pricebook2 (
    name       = 'testPB');

insert newPB2;    

system.debug('pricebook');
system.debug(newPB2.id);

Product2 newProd = new Product2(
    name='testprod',
    IsActive=true,
    units__c = 1
    );

insert newProd;    

system.debug('product');
system.debug(newprod.id);

//add standard PB entry

pricebook2 stdPB = [select id from pricebook2 where name = 'Standard Price Book' limit 1];

pricebookentry newPB2E2 = new pricebookentry (
    pricebook2id = stdPB.id,
    product2id   = newProd.id,
    UnitPrice  = 7,
    IsActive   = true,
    UseStandardPrice = false);

insert newPB2E2;    

system.debug('PB entry std');
system.debug(newPB2E2.id);

pricebookentry newPB2E1 = new pricebookentry (
    pricebook2id = newPB2.id,
    product2id   = newProd.id,
    UnitPrice  = 7,
    IsActive   = true,
    UseStandardPrice = false);

insert newPB2E1;

system.debug('PB entry new');
system.debug(newPB2E1.id);

list<recordtype> AdSalesRT;
AdSalesRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];

Account newAccount = new Account (
    name='testaccount17393',
    credit_rating__c = 'green',
    account_code__c = '123',
    recordtypeid = AdSalesRT[0].id);

insert newAccount;    

system.debug('Account');
system.debug(newAccount.id);
    
Opportunity newOpp = new Opportunity (
    name='testing IO form 123987',
    StageName='Closed Won',
    CloseDate=date.valueof('2010-01-01'),
    AccountID=NewAccount.id);

insert newOpp;

Issue__c NewIssue = new Issue__c (
    Issue_Number__c         = 'test issue',
    On_Sale_Date__c         = date.valueof('2010-01-01'),
    Issue_Year_Calendar__c  = 2010,
    Issue_Year_Financial__c = 2010
    );
    
insert NewIssue;    

system.debug('Issue');
system.debug(newIssue.id);

List<Opportunity>op=new List<Opportunity>();
op.add(NewOpp);

system.debug('Opportunity');
system.debug(newOpp.id);

OpportunityLineItem NewOLI = new OpportunityLineItem (
    OpportunityId    = newOpp.ID,
    PricebookEntryId = newPB2E1.id,
    Quantity         = 1,
    UnitPrice        = 100,
    Issue__c         = newIssue.id);

insert newOLI;

system.debug('OLI');
system.debug(newOLI.id);

//set<Opportunity>op1=new set<Opportunity>();
//op1.add(NewOpp);

//ApexPages.CustomController cc = new ApexPages.CustomController(opp);

// create an instance of the controller

System.currentPagereference().getParameters().put('PBType','Single');
System.currentPagereference().getParameters().put('OppID',NewOpp.id);

Multi_IO myPageCon = new Multi_IO();
list<multi_IO.Masterwrapper> xyz = myPageCon.getMasters();

//try calling methods/properties of the controller in all possible scenarios

// to get the best coverage.

}
}