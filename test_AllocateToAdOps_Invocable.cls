@isTest

public class test_AllocateToAdOps_Invocable{

static testMethod void test() {

custom_user__c newuser1 = new custom_user__c (name = 'bob', Initials__c='a656', adopssequence__c=1, isActive__c=true, ad_ops_user__c=true);
    insert newuser1;
custom_user__c newuser2 = new custom_user__c (name = 'jim', Initials__c='b374', adopssequence__c=2, isActive__c=true, ad_ops_user__c=true);
    insert newuser2;

//insert/update the opportunity, but try not to trigger the pick..
Opportunity newOpp = Test_setup_master_data.create();
newOpp.SendingToAdOps__c = false;
    update newOpp;

list<Opportunity> testOpp_l = [select id, processed_by_lookup__c from opportunity where id = :newOpp.id];
system.assert(testOpp_l[0].Processed_by_lookup__c==null);
    
AllocateToAdOpsInvocable.go(testOpp_l);

Opportunity testOpp_post = [select id, processed_by_lookup__c from opportunity where id = :newOpp.id];
system.assert(testOpp_post.Processed_by_lookup__c<>null);
    
}
}