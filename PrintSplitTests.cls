@isTest (seeAllData=true)

private class PrintSplitTests {

    static testMethod void runPositiveTestCases() {

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
// create Issues
Issue__c newissue1 = new Issue__c
    (name = 'this is just a test issue 2395123y95',
        On_Sale_Date__c = Date.newInstance(2010,02,02),
        Issue_Year_Calendar__c = 2011,
        Issue_Year_Financial__c = 2011,
        Issue_Number__c = '32144');
insert newissue1;     

Issue__c newissue2 = new Issue__c
    (name = 'this is just a test issue 2395123y96',
        On_Sale_Date__c = Date.newInstance(2010,03,03),
        Issue_Year_Calendar__c = 2011,
        Issue_Year_Financial__c = 2011,
        Issue_Number__c = '32145');
insert newissue2;     
        
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
    insert new PricebookEntry(pricebook2id = stdPb.id, product2id = testproduct.id,unitprice=1.0, isActive=true);

    pricebookentry testpbe = new PricebookEntry
        (Pricebook2ID = testpricebook.id,
         Product2ID = testproduct.id,
         IsActive = true,
         UnitPrice = 100,
         UseStandardPrice = false
         );
    
    insert testpbe;        
        
        
PricebookEntry  TestPricebookEntry = testpbe;
Issue__c        TestFirstIssue     = newissue1;

//create opportunity
        
OpportunityLineItem TestOpportunityLineItem = new OpportunityLineItem
        (OpportunityID = TestOpportunity.id,
         PriceBookEntryID = testpricebookentry.id,
         Quantity = 2,
         UnitPrice = 100,
         description = 'series',
         issue__c = TestFirstIssue.id
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