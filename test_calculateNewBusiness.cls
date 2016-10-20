@istest
public class test_calculateNewBusiness {

/*

    1. setup all 8 possible scenarios:
        1)Never
        2,3,4)Lapsed
        5)Reactivated
        6)New
        7,8)Existing
    2. Run the logic
    3. Clear all the previous statuses
*/    
static testmethod void RunCalculateTests(){

    // 1. setup some test data :-)
    // Eight accounts - one for each of the statuses

recordtype AdSalesAccRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];
recordtype AdSalesConRT = [select id from recordtype where sobjecttype = 'Contact' and name = 'Ad Sales' limit 1];

list <account> NewAccs = new list <account> ();
    
Account A_NeverBought   = new Account (Name = 'NeverBought',  credit_rating__c = 'green', recordtypeid=AdSalesAccRT.id); NewAccs.add(A_Neverbought);
Account A_Lapsed_old    = new Account (Name = 'Lapsed_old',   credit_rating__c = 'green', recordtypeid=AdSalesAccRT.id); NewAccs.add(A_Lapsed_old);
Account A_Lapsed_last   = new Account (Name = 'Lapsed_last',  credit_rating__c = 'green', recordtypeid=AdSalesAccRT.id); NewAccs.add(A_Lapsed_last);
Account A_Lapsed_both   = new Account (Name = 'Lapsed_both',  credit_rating__c = 'green', recordtypeid=AdSalesAccRT.id); NewAccs.add(A_Lapsed_both);
Account A_Reactivated   = new Account (Name = 'Reactivated',  credit_rating__c = 'green', recordtypeid=AdSalesAccRT.id); NewAccs.add(A_Reactivated);
Account A_NewCustomer   = new Account (Name = 'NewCustomer',  credit_rating__c = 'green', recordtypeid=AdSalesAccRT.id); NewAccs.add(A_NewCustomer);
Account A_Existing_last = new Account (Name = 'Existing_last',credit_rating__c = 'green', recordtypeid=AdSalesAccRT.id); NewAccs.add(A_Existing_last);
Account A_Existing_both = new Account (Name = 'Existing_both',credit_rating__c = 'green', recordtypeid=AdSalesAccRT.id); NewAccs.add(A_Existing_both);

insert NewAccs;

    // 8 contacts
    
list <contact> NewContacts = new list <contact> ();
Contact C_NeverBought   = new Contact (lastName = 'NeverBought',   account = A_NeverBought,   recordtypeid=AdSalesConRT.id,  Email = 'testemail23984kjb23jg34@sdic89y7.com', title = 'director', account_type__c = 'Client', Role__c = 'Marketing Manager (Media Facing)', Seniority__c = 'Executive'); NewContacts.add(C_Neverbought);
Contact C_Lapsed_old    = new Contact (lastName = 'Lapsed_old',    account = A_Lapsed_old,    recordtypeid=AdSalesConRT.id,  Email = 'testemail23984kjb23jg34@sdic89y7.com', title = 'director', account_type__c = 'Client', Role__c = 'Marketing Manager (Media Facing)', Seniority__c = 'Executive'); NewContacts.add(C_Lapsed_old);
Contact C_Lapsed_last   = new Contact (lastName = 'Lapsed_last',   account = A_Lapsed_last,   recordtypeid=AdSalesConRT.id,  Email = 'testemail23984kjb23jg34@sdic89y7.com', title = 'director', account_type__c = 'Client', Role__c = 'Marketing Manager (Media Facing)', Seniority__c = 'Executive'); NewContacts.add(C_Lapsed_last);
Contact C_Lapsed_both   = new Contact (lastName = 'Lapsed_both',   account = A_Lapsed_both,   recordtypeid=AdSalesConRT.id,  Email = 'testemail23984kjb23jg34@sdic89y7.com', title = 'director', account_type__c = 'Client', Role__c = 'Marketing Manager (Media Facing)', Seniority__c = 'Executive'); NewContacts.add(C_Lapsed_both);
Contact C_Reactivated   = new Contact (lastName = 'Reactivated',   account = A_Reactivated,   recordtypeid=AdSalesConRT.id,  Email = 'testemail23984kjb23jg34@sdic89y7.com', title = 'director', account_type__c = 'Client', Role__c = 'Marketing Manager (Media Facing)', Seniority__c = 'Executive'); NewContacts.add(C_Reactivated);
Contact C_NewCustomer   = new Contact (lastName = 'NewCustomer',   account = A_NewCustomer,   recordtypeid=AdSalesConRT.id,  Email = 'testemail23984kjb23jg34@sdic89y7.com', title = 'director', account_type__c = 'Client', Role__c = 'Marketing Manager (Media Facing)', Seniority__c = 'Executive'); NewContacts.add(C_NewCustomer);
Contact C_Existing_last = new Contact (lastName = 'Existing_last', account = A_Existing_last, recordtypeid=AdSalesConRT.id,  Email = 'testemail23984kjb23jg34@sdic89y7.com', title = 'director', account_type__c = 'Client', Role__c = 'Marketing Manager (Media Facing)', Seniority__c = 'Executive'); NewContacts.add(C_Existing_last);
Contact C_Existing_both = new Contact (lastName = 'Existing_both', account = A_Existing_both, recordtypeid=AdSalesConRT.id,  Email = 'testemail23984kjb23jg34@sdic89y7.com', title = 'director', account_type__c = 'Client', Role__c = 'Marketing Manager (Media Facing)', Seniority__c = 'Executive'); NewContacts.add(C_Existing_both);
    
insert NewContacts;

// 7 Opportunities - no need to do for the Neverbought account
// a) Lapsed longtime ago
// b) Lapsed last year
// c) Lapsed both
// d) New
// e) Reactivated
// f) Existing since last year
// g) Existing for longer

list <Opportunity> NewOpps = new list <Opportunity> ();
date closingdate = date.valueof('2000-01-01');
    Opportunity Opp_a = new Opportunity (name='a', stagename='closed won', accountid=A_Lapsed_old.id,    first_account_rep__r = C_Lapsed_old,    closedate = closingdate); NewOpps.add(Opp_a);
    Opportunity Opp_b = new Opportunity (name='b', stagename='closed won', accountid=A_Lapsed_last.id,   first_account_rep__r = C_Lapsed_last,   closedate = closingdate); NewOpps.add(Opp_b);
    Opportunity Opp_c = new Opportunity (name='c', stagename='closed won', accountid=A_Lapsed_both.id,   first_account_rep__r = C_Lapsed_both,   closedate = closingdate); NewOpps.add(Opp_c);
    Opportunity Opp_d = new Opportunity (name='d', stagename='closed won', accountid=A_NewCustomer.id,   first_account_rep__r = C_NewCustomer,   closedate = closingdate); NewOpps.add(Opp_d);
    Opportunity Opp_e = new Opportunity (name='e', stagename='closed won', accountid=A_Reactivated.id,   first_account_rep__r = C_Reactivated,   closedate = closingdate); NewOpps.add(Opp_e);
    Opportunity Opp_f = new Opportunity (name='f', stagename='closed won', accountid=A_Existing_last.id, first_account_rep__r = C_Existing_last, closedate = closingdate); NewOpps.add(Opp_f);
    Opportunity Opp_g = new Opportunity (name='g', stagename='closed won', accountid=A_Existing_both.id, first_account_rep__r = C_Existing_both, closedate = closingdate); NewOpps.add(Opp_g);

insert NewOpps;

    // find a randomproduct

Pricebook2 newPB2 = new Pricebook2 (name = 'testPB');
insert newPB2;    

Product2 newProd = new Product2(    name='testprod',    IsActive=true,    units__c = 1    );
insert newProd;    

id stdPBid = Test.getStandardPricebookId();

pricebookentry newStdPB2E2 = new pricebookentry (    pricebook2id = stdPBid,    product2id   = newProd.id,    UnitPrice  = 7,    IsActive   = true,    UseStandardPrice = false);
insert newStdPB2E2;
    
pricebookentry newPBE = new pricebookentry (    pricebook2id = newPB2.id,    product2id   = newProd.id,    UnitPrice  = 7,    IsActive   = true,    UseStandardPrice = false);
insert newPBE;
    
    // Add Line Items
date veryOldDate = date.valueof('2000-01-01');
date this12MDate = date.today()-7;  // last week
date last12MDate = this12Mdate.addYears(-1); // 53 weeks ago
    
list <OpportunityLineItem> NewOLIs = new list <OpportunityLineItem> ();

    // a - just one long time ago
opportunitylineitem a_newOLI = new opportunitylineitem(OpportunityId=Opp_a.ID, servicedate=veryolddate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(a_newOLI);

    // b - just one, prior to 12 months ago
opportunitylineitem b_newOLI = new opportunitylineitem(OpportunityId=Opp_b.ID, servicedate=last12MDate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(b_newOLI);    

    // c - two, one prior to 12 months ago, and one very old
opportunitylineitem c1_newOLI = new opportunitylineitem(OpportunityId=Opp_c.ID, servicedate=last12MDate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(c1_newOLI); 
opportunitylineitem c2_newOLI = new opportunitylineitem(OpportunityId=Opp_c.ID, servicedate=veryolddate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(c2_newOLI);

    // d - one recently
opportunitylineitem d_newOLI = new opportunitylineitem(OpportunityId=Opp_d.ID, servicedate=this12Mdate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(d_newOLI); 

    // e - one recent and one very old
opportunitylineitem e1_newOLI = new opportunitylineitem(OpportunityId=Opp_e.ID, servicedate=this12Mdate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(e1_newOLI); 
opportunitylineitem e2_newOLI = new opportunitylineitem(OpportunityId=Opp_e.ID, servicedate=veryolddate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(e2_newOLI); 
    
    // f - one recent and one last year
opportunitylineitem f1_newOLI = new opportunitylineitem(OpportunityId=Opp_f.ID, servicedate=this12Mdate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(f1_newOLI); 
opportunitylineitem f2_newOLI = new opportunitylineitem(OpportunityId=Opp_f.ID, servicedate=last12MDate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(f2_newOLI); 
    
    // g - one recent, one last year, one older
opportunitylineitem g1_newOLI = new opportunitylineitem(OpportunityId=Opp_g.ID, servicedate=this12Mdate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(g1_newOLI); 
opportunitylineitem g2_newOLI = new opportunitylineitem(OpportunityId=Opp_g.ID, servicedate=last12MDate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(g2_newOLI); 
opportunitylineitem g3_newOLI = new opportunitylineitem(OpportunityId=Opp_g.ID, servicedate=veryolddate, PricebookEntryId=newPBE.id, Quantity=1, UnitPrice=1); newolis.add(g3_newOLI); 

insert NewOLIs;



// 2. Do the Actual logic
    calculateNewBusiness.go();
    
// 3. Now assert that the business types are what you would expect
    
list <account> AccountsWithBusinessTypes = [select id, name, business_type__c from account where business_type__c <> ''];
    for (account thisacc : AccountsWithBusinessTypes) {
        if (thisacc.name == 'NeverBought')   {system.debug('Never');       system.debug(thisacc.business_type__c); system.assertequals('Never',       thisacc.business_type__c);}
        if (thisacc.name == 'Lapsed_old')    {system.debug('Lapsed');     system.debug(thisacc.business_type__c); system.assertequals('Lapsed',      thisacc.business_type__c);}
        if (thisacc.name == 'Lapsed_last')   {system.debug('Lapsed');      system.debug(thisacc.business_type__c); system.assertequals('Lapsed',      thisacc.business_type__c);}
        if (thisacc.name == 'Lapsed_both')   {system.debug('Lapsed');      system.debug(thisacc.business_type__c); system.assertequals('Lapsed',      thisacc.business_type__c);}
        if (thisacc.name == 'Reactivated')   {system.debug('Reactivated'); system.debug(thisacc.business_type__c); system.assertequals('Reactivated', thisacc.business_type__c);}
        if (thisacc.name == 'NewCustomer')   {system.debug('New');         system.debug(thisacc.business_type__c); system.assertequals('New',         thisacc.business_type__c);}
        if (thisacc.name == 'Existing_last') {system.debug('Existing');    system.debug(thisacc.business_type__c); system.assertequals('Existing',    thisacc.business_type__c);}
        if (thisacc.name == 'Existing_both') {system.debug('Existing');    system.debug(thisacc.business_type__c); system.assertequals('Existing',    thisacc.business_type__c);}
        }
    
//3. clear previous statuses    
//CalculateNewBusiness.ClearAll();

//list <account> emptybusinesstypes = [select id from account where business_type__c <> ''];
//system.assertequals(0,emptybusinesstypes.size());

}

static testmethod void RunRollupTests(){
    //2 scenarios higher parent, and higher child
    
    recordtype AdSalesAccRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];

    Account A_1_Parent_higher = new Account (Name = 'A_test2_1_Parent_higher dfs7896fkj', Business_type__c = 'New', recordtypeid = AdSalesAccRT.Id);                                        insert A_1_Parent_higher;
    Account A_1_Child_lower   = new Account (Name = 'A_test2_1_Child_lower 9786fakjh8',   Business_type__c = 'Lapsed',      parentid=A_1_Parent_higher.id, recordtypeid = AdSalesAccRT.Id); insert A_1_Child_lower;
    Account A_1_Child_lower2  = new Account (Name = 'A_test2_1_Child_lower2 as876as',  Business_type__c = 'Never' ,      parentid=A_1_Parent_higher.id, recordtypeid = AdSalesAccRT.Id); insert A_1_Child_lower2;
    
    Account A_2_Parent_lower  = new Account (Name = 'A_test2_2_Parent_lower df987fss',  Business_type__c = 'Never', recordtypeid = AdSalesAccRT.Id);                                      insert A_2_Parent_lower;
    Account A_2_Child_higher  = new Account (Name = 'A_test2_2_Child_higher fas97f7s',  Business_type__c = 'Reactivated', parentid=A_2_Parent_lower.id, recordtypeid = AdSalesAccRT.Id);  insert A_2_Child_higher;
    Account A_2_Child_lower2  = new Account (Name = 'A_test2_2_Child_lower2 qo8as8f',  Business_type__c = 'Never',       parentid=A_2_Parent_lower.id, recordtypeid = AdSalesAccRT.Id);  insert A_2_Child_lower2;
    
    //// what about grandparents ?
    Account A_3_Grand_Parent_higher = new Account (Name = 'A_test3_1_Grand_Parent_higher 8s8d56g', Business_type__c = 'New',                                           recordtypeid = AdSalesAccRT.Id); insert A_3_Grand_Parent_higher;
    Account A_3_Parent_lower        = new Account (Name = 'A_test3_1_Parent_lower',        Business_type__c = 'Lapsed',   parentid=A_3_Grand_Parent_higher.id, recordtypeid = AdSalesAccRT.Id); insert A_3_Parent_lower;
    Account A_3_Child_lower2        = new Account (Name = 'A_test3_1_Child_higher',        Business_type__c = 'Existing', parentid=A_3_Parent_lower.id,        recordtypeid = AdSalesAccRT.Id); insert A_3_Child_lower2;

    // what about orphans ?
    Account A_4_orphan        = new Account (Name = 'A_test4_1_Orphan ptg3h383h',        Business_type__c = 'Never', recordtypeid = AdSalesAccRT.Id);   insert A_4_Orphan;

    calculateNewBusiness.Rollup();

list<account> test2results = [select id, name, business_type__c from account where name like 'A_test2%'];
    for (account test2result : test2results) {
        if (test2result.name == 'A_test2_1_Parent_higher dfs7896fkj') {system.assertEquals('New', test2result.business_type__c);}
        if (test2result.name == 'A_test2_1_Child_lower 9786fakjh8')   {system.assertEquals('New', test2result.business_type__c);}
        if (test2result.name == 'A_test2_1_Child_lower2 as876as')  {system.assertEquals('New', test2result.business_type__c);}

        if (test2result.name == 'A_test2_2_Parent_lower df987fss')  {system.assertEquals('Reactivated', test2result.business_type__c);}
        if (test2result.name == 'A_test2_2_Child_higher fas97f7s')  {system.assertEquals('Reactivated', test2result.business_type__c);}
        if (test2result.name == 'A_test2_2_Child_lower2 qo8as8f')  {system.assertEquals('Reactivated', test2result.business_type__c);}

        if (test2result.name == 'A_test3_1_Grand_Parent_higher 8s8d56g') {system.assertEquals('Existing', test2result.business_type__c);}

        if (test2result.name == 'A_test4_1_Orphan ptg3h383h')        {system.assertEquals('Never', test2result.business_type__c);}
    }

}

}