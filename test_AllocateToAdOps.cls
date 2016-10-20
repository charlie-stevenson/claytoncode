@isTest

public class test_AllocateToAdOps{

static testMethod void testAllocateToAdOps() {

custom_user__c newuser1 = new custom_user__c (name = 'bob', Initials__c='a656', adopssequence__c=1, isActive__c=true, ad_ops_user__c=true);
    insert newuser1;
custom_user__c newuser2 = new custom_user__c (name = 'jim', Initials__c='b374', adopssequence__c=2, isActive__c=true, ad_ops_user__c=true);
    insert newuser2;

//insert/update the opportunity, but try not to trigger the pick..
Opportunity newOpp = Test_setup_master_data.create();
newOpp.SendingToAdOps__c = false;
    update newOpp;
    
Opportunity testOpp1 = [select id, processed_by_lookup__c from opportunity where id = :newOpp.id];
system.assert(testOpp1.Processed_by_lookup__c==null);

//Now update it and try to trigger the pick    

//newOpp.SendingToAdOps__c = true;
//    update newOpp;
    
Opportunity testOpp2 = [select id, processed_by_lookup__c, processed_by_lookup__r.id, processed_by_lookup__r.name from opportunity where id = :newOpp.id];
system.debug(testOpp2.Processed_by_lookup__r.id);
system.debug(testOpp2.Processed_by_lookup__r.name);
//system.assert(testOpp2.Processed_by_lookup__r.id!=null);
    
//repeatedly get the next one, and it should rotate

custom_user__c user1 = assignadopsprocessor.pick();
custom_user__c user2 = assignadopsprocessor.pick();
custom_user__c user3 = assignadopsprocessor.pick();

system.assertNotEquals(user1, user2);
system.assertNotEquals(user2, user3);
    
}
}