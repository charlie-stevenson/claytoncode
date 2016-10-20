@istest

private class testInsertionOrderController {

static testMethod void myPage_Test()

{

//Test converage for the myPage visualforce page

PageReference pageRef = Page.ShowInsertionOrder;

Test.setCurrentPageReference(pageRef);

list<recordtype> AdSalesRT;
AdSalesRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];

Account newAccount = new Account (
    name='testaccount17393',
    recordtypeid = AdSalesRT[0].id,
    Credit_Rating__c = 'Green');

insert newAccount;    
    
Opportunity newOpp = new Opportunity (
    name='testing IO form 123987',
    StageName='Closed Won',
    CloseDate=date.valueof('2010-01-01'),
    AccountID=NewAccount.id);

insert newOpp;

List<Opportunity>op=new List<Opportunity>();
op.add(NewOpp);

set<Opportunity>op1=new set<Opportunity>();
op1.add(NewOpp);

//ApexPages.CustomController cc = new ApexPages.CustomController(opp);

// create an instance of the controller

System.currentPagereference().getParameters().put('OppID',NewOpp.id);

InsertionOrderDetails myPageCon = new InsertionOrderDetails();
Opportunity xyz = myPageCon.getOpps();

//try calling methods/properties of the controller in all possible scenarios

// to get the best coverage.

}
}