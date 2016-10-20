public class AssignAdOpsProcessor{
        
    public static custom_user__c pick()
    {
    custom_user__c allocatedUser;
    list<custom_user__c> allAdOpsUsers = [select id, name, AdOpsSequence__c from custom_user__c where isactive__c=true and ad_ops_user__c=true];
//first allocate the person with sequence=1 to the opportunity
         if (allAdOpsUsers.size() > 0) {
         for (custom_user__c this_user : allAdOpsUsers)
         {if (this_user.AdOpsSequence__c == 1)
         {allocatedUser = this_user;}
//Now decrement all sequences
         this_user.AdOpsSequence__c=this_user.AdOpsSequence__c-1;
         }
//Finally change the allocated user to the highest value
		 allocatedUser.AdOpsSequence__c = allAdOpsUsers.size();
//Update them all
         update allAdOpsUsers;
         }
        return allocatedUser;}
}