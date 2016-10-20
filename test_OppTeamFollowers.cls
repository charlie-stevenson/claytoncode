@istest(SeeAllData=true)
public class test_OppTeamFollowers {
    
    static testMethod void createData() {

// create an Oppty
        
    Opportunity newOpp = Test_setup_master_data.create();
    Opportunity this_Opp = [select id, AcknowledgementID__c, name, first_account_rep__c, first_account_rep__r.id from opportunity where id = :newOpp.id limit 1];

// it should have no followers
    list<entitysubscription> prefollowers = [select parentid from entitysubscription where parentid = :this_Opp.id];
    system.assert(prefollowers.size()==0);
        
// add a user to the OpptyTeam for this_Opp
    
    user this_u = [select id from user where isactive = true and email like '%idg.co.uk' limit 1];

    OpportunityTeamMember newOTM = new OpportunityTeamMember(opportunityid = this_Opp.id, userid = this_u.id);
    insert newOTM;

// the trigger should have added user this_U as a follower to the Opp this_Opp
    
    list<entitysubscription> postfollowers = [select parentid from entitysubscription where parentid = :this_Opp.id];
	system.assert(postfollowers.size()!=0);
}}