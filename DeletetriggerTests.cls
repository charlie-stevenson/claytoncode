@isTest

private class DeletetriggerTests {

    static testMethod void TestDeleteTrigger() {

//create opportunity

//Test Account
list<recordtype> AdSalesRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];
        
account testaccount = new Account
        (Name = 'testaccount123478612345',
        isagency__c = false,
        recordtypeid = AdSalesRT[0].id,
        Credit_Rating__c = 'Green');
   insert testaccount;

list<recordtype> AdSalesContactRT = [select id from recordtype where sobjecttype = 'Contact' and name = 'Ad Sales' limit 1];
    
contact firstrep = new contact (
    lastname='kgkjhkjh21',
    email = 'kgkjhkjh21@23h23jhg234jhg234.com',
    title = 'director',
    account_type__c = 'Client',
    Role__c         = 'Marketing Manager (Media Facing)',
    Seniority__c    = 'Executive',
    accountid = testaccount.id,
    recordtypeid = AdSalesContactRT[0].id);
    insert firstrep;
        
Opportunity TestOpportunity = new Opportunity
        (Name                 = 'test name for apex testing',
         Account              = TestAccount,
         CloseDate            = System.today(),
         Agency_or_Direct__c  = 'Direct to Client',
         StageName            = 'Closed Won');
         
        insert TestOpportunity;


//test that the opportunity exists

List<Opportunity> ResultOpportunityBeforeDelete = [select id
                                       from Opportunity
                                       where id = :TestOpportunity.id];
integer OppCounter = 0;

for (Opportunity Opps : ResultOpportunityBeforeDelete) {
OppCounter++;
}

system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxx How Many Opportunities?');
system.debug(OppCounter);

System.assertEquals(OppCounter, 1);

// try to delete it

    try{
        delete testopportunity;
    }catch (exception e){
        // Exit the test if the expected NullValueNotAllowedException is thrown.
        return;
    }
    // Fail the test if the expected NullValueNotAllowedException is not thrown.
    System.assert(false, 
            'A NullValueNotAllowedException was expected, but was not thrown.');

}
}