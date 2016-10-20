@isTest (seeAllData=true)

private class OnlineSplitTests {

    static testMethod void TestOnlineSplitting() {

//create opportunity

//Test Account
account testaccount = new Account
        (Name = 'testaccount123478612345');
        
   insert testaccount;

Opportunity TestOpportunity = new Opportunity
        (Name                = 'test name for apex testing',
         Account             = TestAccount,
         CloseDate           = System.today(),
         Agency_or_Direct__c = 'Direct to Client',
         StageName           = 'Needs Analysis');
         
        insert TestOpportunity;

// add products...
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

// asf
system.debug(stdPb.id);
    insert new PricebookEntry(pricebook2id = stdPb.id, product2id = testproduct.id, unitprice=1.0, isActive=true);
    
    PricebookEntry testpricebookentry = new PricebookEntry
        (pricebook2id = testpricebook.id,
         product2id = testproduct.id,
         unitprice = 1.0,
         isActive=true
         );
    insert testpricebookentry;


Issue__c        TestFirstIssue     = new issue__c
        (name = 'CIO Jan 2007',
        On_Sale_Date__c = Date.newInstance(2007,02,02),
        publication_name__c = 'CIO',
        pricebook__c = 'CIO (Print)',
        Issue_Year_Calendar__c = 2007,
        Issue_Year_Financial__c = 2007,
        Issue_Number__c = '32144');
        
        insert testfirstissue;

OpportunityLineItem TestOpportunityLineItem = new OpportunityLineItem
        (OpportunityID = TestOpportunity.id,
         PriceBookEntryID = testpricebookentry.id,
         Quantity = 1,
         UnitPrice = 321,
         description = 'anything',
         ServiceDate = date.valueof('2000-01-01'),
         End_Date__c  = date.valueof('2000-02-15')
         );
         
         insert TestOpportunityLineItem;

//test that the opportunity exists

List<Opportunity> ResultOpportunity = [select id
                                       from Opportunity
                                       where id = :TestOpportunity.id];
integer OppCounter = 0;

for (Opportunity Opps : ResultOpportunity) {
OppCounter++;
}

system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxx How Many Opportunities?');
system.debug(OppCounter);

System.assertEquals(OppCounter, 1);

//test that the 2 line items exists
List<OpportunityLineItem> ResultOpportunityLineItem = [select id
                                                        from OpportunityLineItem
                                                        where OpportunityID = :TestOpportunity.id];
integer LiCounter = 0;

for (OpportunityLineItem OppLI : ResultOpportunityLineItem) {
LiCounter++;
}

system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxx How Many LineItems?');
system.debug(LiCounter);

system.assertEquals(2, liCounter);

// tidy up

//delete opportunity

}
}