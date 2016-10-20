@isTest (seeAllData=true)

private with sharing class OnlineSplitTestsPrice {

    static testMethod void testOnlineSplitting() {

//create opportunity

//Test Account
account testAccount = new Account
        (Name = 'testaccount123478612345');
        
   insert testaccount;
        
Opportunity testOpportunity = new Opportunity
        (Name                = 'test name for apex testing',
         Account             = TestAccount,
         CloseDate           = System.today(),
         Agency_or_Direct__c = 'Direct to Client',
         StageName           = 'Needs Analysis');
         
        insert testOpportunity;

// create products, pricebook

// create Issue
Issue__c newIssue = new Issue__c
    (name = 'this is just a test issue 2395123y95',
        On_Sale_Date__c = Date.newInstance(2010,02,02),
        Issue_Year_Calendar__c = 2011,
        Issue_Year_Financial__c = 2011,
        Issue_Number__c = '32144');
insert newIssue;     
        
// add products...

    Pricebook2 testPricebook = new Pricebook2
        (Name = 'Custom Pricebook',
         IsActive = true);

    insert testPricebook;

    Product2 testProduct = new Product2
        (IsActive = true,
         Name = 'TestProduct',
         space__c = 1,
         family = 'Old'
         );
    
    insert testProduct;

    Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
    insert new PricebookEntry(pricebook2id = stdPb.id, product2id = testproduct.id,unitprice=1.0, isActive=true);

    pricebookentry testPbe = new PricebookEntry
        (Pricebook2ID = testpricebook.id,
         Product2ID = testproduct.id,
         IsActive = true,
         UnitPrice = 100,
         UseStandardPrice = false
         );
    
    insert testPbe;        
        
        
PricebookEntry  testPricebookEntry = testpbe;
Issue__c        testFirstIssue     = newissue;

OpportunityLineItem testOpportunityLineItem = new OpportunityLineItem
        (OpportunityID = TestOpportunity.id,
         PriceBookEntryID = testpricebookentry.id,
         Quantity = 1,
         UnitPrice = 321,
         description = 'anything',
         ServiceDate = date.valueof('2000-01-01'),
         End_Date__c  = date.valueof('2000-02-15')
         );
         
         insert testOpportunityLineItem;

//test that the opportunity exists

List<Opportunity> resultOpportunity = [select id
                                       from Opportunity
                                       where id = :TestOpportunity.id];
integer oppCounter = 0;

for (Opportunity opps : resultOpportunity) {
oppCounter++;
}

system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxx How Many Opportunities?');
system.debug(oppCounter);

System.assertEquals(oppCounter, 1);

//test that the 2 line items exists
List<OpportunityLineItem> resultOpportunityLineItem = [select id
                                                        from OpportunityLineItem
                                                        where OpportunityID = :TestOpportunity.id];

system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxx How Many LineItems?');
system.debug(LiCounter);

system.assertEquals(2, resultOpportunityLineItem.size());

}
}
