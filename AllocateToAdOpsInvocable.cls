public class AllocateToAdOpsInvocable {
    @InvocableMethod(label='Assign to next AdOps' description='Assigns this opportunity to the next Custom User (Ad Ops)')
    public static void Go(List<Opportunity> these_opps) {
        opportunity this_opp = [select id from opportunity where id = :these_opps[0].id limit 1];
        this_opp.Processed_by_lookup__c = AssignAdOpsProcessor.pick().id;
        update this_opp;
    }
}