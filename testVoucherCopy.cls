@istest

private class testVoucherCopy {

static testMethod void myPage_Test()

{

//Test coverage for the Voucher Copy Page visualforce page

PageReference pageRef = Page.Voucher_Copy_Report;
Test.setCurrentPage(pageRef);
ApexPages.currentpage().getParameters().put('issue', '1234'); /*NEWNEWNEWNEWNEWNEWNEWNEWNEWNEWNEWNEW*/

list<recordtype> AdSalesRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];
list<recordtype> AdSalesContactRT = [select id from recordtype where sobjecttype = 'Contact' and name = 'Ad Sales' limit 1];

Account newAccount = new Account (name='XYZ Organization', Credit_Rating__c = 'Green',recordtypeid = AdSalesRT[0].id);

insert newAccount;

Issue__c newIssue = new Issue__c (name                    = 'CIO Aug 1900',
                                  Issue_number__c         = '1234',
                                  publication_name__c     = 'CIO',
                                  on_sale_date__c         = date.valueof('1900-01-01'),
                                  deadline__c             = date.today(),
                                  issue_year_calendar__c  = 1900,
                                  issue_year_financial__c = 1900,
                                  Pricebook__c            = 'CIO (Print)'
                                  );
insert newIssue;

//create first contact

Contact myContact = new Contact (FirstName='Joe',
LastName='Schmoe',
AccountId=newAccount.id,
recordtypeid = AdSalesContactRT[0].id);

List<contact>c=new List<contact>();
c.add(mycontact);

insert myContact;

Opportunity newOpp = new Opportunity(
                      name      = 'testopp987dfs867dfs86fas',
                      closedate = date.today(),
                      stagename = 'Closed Won',
                      AccountId = newAccount.Id,
                      First_Account_Rep__c = mycontact.Id,
                      Added_Value__c    = 'No',
                      IP_Targeting__c   = 'Global',
                      Site_Targeting__c = 'Run of Site');
insert newOpp;

    Pricebook2 testpricebook = new Pricebook2
        (Name = 'Custom Pricebook',
         IsActive = true);

    insert testpricebook;

    Product2 testproduct = new Product2
        (IsActive = true,
         Name = 'TestProduct',
         space__c = 1,
         family = 'Old'
         );
    
    insert testproduct;

    Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
    insert new PricebookEntry(pricebook2id = stdPb.id, product2id = testproduct.id,unitprice=1.0, isActive=true);

    pricebookentry testpbe = new PricebookEntry
        (Pricebook2ID = testpricebook.id,
         Product2ID = testproduct.id,
         IsActive = true,
         UnitPrice = 100,
         UseStandardPrice = false
         );
    
    insert testpbe;    
    
OpportunityLineItem newOLI= new OpportunityLineItem(opportunityid=newopp.id,
                                                     servicedate =date.today(),
                                                     quantity    =1,
                                                     unitprice   =2,
                                                     issue__c    =newIssue.id,
                                                     PriceBookEntryID = testpbe.id);
insert newOLI;

//ApexPages.StandardController sc = new ApexPages.standardController(c);

// create an instance of the controller

ListVoucherContacts myPageCon = new ListVoucherContacts(new ApexPages.StandardsetController(c));
List<contact> ce=myPageCon.getListVoucherContacts();
//try calling methods/properties of the controller in all possible scenarios

// to get the best coverage.

}

}