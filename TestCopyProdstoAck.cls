@isTest

private class TestCopyProdstoAck {

    static testMethod void TestcopytoAck() {

//create opportunity

//Test Account
account testaccount = new Account
        (Name = 'testaccount123478612345');
        
   insert testaccount;


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
   

Opportunity TestOpportunity = new Opportunity
        (Name                = 'test name for apex testing',
         Account             = TestAccount,
         CloseDate           = System.today(),
         Agency_or_Direct__c = 'Direct to Client',
         StageName           = 'Needs Analysis');
         
        insert TestOpportunity;

// add products...

Issue__c        TestFirstIssue     = new issue__c
        (name = 'this is just a test issue 2395123y95',
        On_Sale_Date__c = Date.newInstance(2010,02,02),
        Issue_Year_Calendar__c = 2011,
        Issue_Year_Financial__c = 2011,
        Issue_Number__c = '32144');
        
        insert testfirstissue;

OpportunityLineItem TestPrintOpportunityLineItem = new OpportunityLineItem
        (OpportunityID = TestOpportunity.id,
         PriceBookEntryid = testpbe.id,
         Quantity = 1,
         UnitPrice = 1,
         description = 'something',
         Issue__c = testfirstissue.id);
         
         insert TestPrintOpportunityLineItem;

//test that the Opportunity exists

     List<Opportunity> ResultOpp = [select id
                                       from Opportunity
                                       where id = :TestOpportunity.id];
     integer OppCounter = 0;

     for (Opportunity Opps : ResultOpp) {
          OppCounter++;
     }

     system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxx How Many Opportunities?');
     system.debug(OppCounter);

     System.assertEquals(1, OppCounter);

//test that the OLI exists

     List<OpportunityLineItem> ResultOLI = [select id
                                       from OpportunityLineItem
                                       where OpportunityID = :TestOpportunity.id];
integer OLICounter = 0;

for (OpportunityLineItem OLIs : ResultOLI) {
OLICounter++;
}

system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxx How Many OLIs?');
system.debug(OLICounter);

System.assertEquals(1, OLICounter);

//test that the Ack exists

     List<Ack_Detail__c> ResultAck = [select id
                                       from Ack_Detail__c
                                       where Opportunity__c = :TestOpportunity.id];

integer AckCounter = resultack.size();

system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxx How Many Ack Items?');
system.debug(AckCounter);

//NB there should be 1 Ack Items

System.assertEquals(1, AckCounter);

}
}