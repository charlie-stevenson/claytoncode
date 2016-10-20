Global class calculateNewBusiness implements Schedulable{

global void execute(SchedulableContext SC) {
//    ClearAll();
    Go();
    Rollup();
}

public static void Go() {

//useful dates
date twelvemonthsago = date.today().addYears(-1)-1;
date twoyearsago     = date.today().addYears(-2)-1;

//get All Clients
recordtype AdSalesAccRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];
map <id,account> allClientsMap = new Map<Id,Account>([select id, business_type__c, name from account where recordtypeid = :AdSalesAccRT.id and isAgency__c = false]);

    
//get the line items from 24+ months ago
AggregateResult[] twentyFourMonthsOrOlder = [select opportunity.account.id                    a1id, 
                                                    opportunity.account.isagency__c           a1ia, 
                                                    opportunity.second_account__c             a2id, 
                                                    opportunity.second_account__r.isagency__c a2ia, 
                                                    opportunity.third_account__c              a3id, 
                                                    opportunity.third_account__r.isagency__c  a3ia, 
                                                    min(servicedate)
        from opportunitylineitem 
        where opportunity.stagename = 'closed won' 
        and servicedate < :twoyearsago
        group by opportunity.account.id, 
                 opportunity.account.isagency__c, 
                 opportunity.second_account__c, 
                 opportunity.second_account__r.isagency__c, 
                 opportunity.third_account__c, 
                 opportunity.third_account__r.isagency__c];
    
//get the last line item from more than 12 months ago        
AggregateResult[] twelveto24monthsAgo = [select opportunity.account.id                        a1id, 
                                                    opportunity.account.isagency__c           a1ia, 
                                                    opportunity.second_account__c             a2id, 
                                                    opportunity.second_account__r.isagency__c a2ia, 
                                                    opportunity.third_account__c              a3id, 
                                                    opportunity.third_account__r.isagency__c  a3ia, 
                                                    min(servicedate)
        from opportunitylineitem 
        where opportunity.stagename = 'closed won' 
        and servicedate <  :twelvemonthsago
        and servicedate >= :twoyearsago
        group by opportunity.account.id, 
                 opportunity.account.isagency__c, 
                 opportunity.second_account__c, 
                 opportunity.second_account__r.isagency__c, 
                 opportunity.third_account__c, 
                 opportunity.third_account__r.isagency__c];

//get the last line item from the last 12 months
AggregateResult[] moreRecentthan12Months = [select opportunity.account.id                     a1id, 
                                                    opportunity.account.isagency__c           a1ia, 
                                                    opportunity.second_account__c             a2id, 
                                                    opportunity.second_account__r.isagency__c a2ia, 
                                                    opportunity.third_account__c              a3id, 
                                                    opportunity.third_account__r.isagency__c  a3ia,
                                                    min(servicedate)
        from opportunitylineitem 
        where opportunity.stagename = 'closed won' 
        and servicedate >= :twelvemonthsago
        group by opportunity.account.id, 
                 opportunity.account.isagency__c, 
                 opportunity.second_account__c, 
                 opportunity.second_account__r.isagency__c, 
                 opportunity.third_account__c, 
                 opportunity.third_account__r.isagency__c];
   
// build result set
// 
// structure is Account, last12, 12-24, 24plus
//              Account,  <bool,  bool,   bool>

map <account, list<boolean>> clientsresults = new map <account,list<boolean>>();

// set allClients to "Never"
for (account thisClientNever : allClientsMap.values())
    {list<boolean> neverbought = new list<boolean>();
     neverbought.add(false);
     neverbought.add(false);
     neverbought.add(false);
    clientsresults.put(thisClientnever, neverbought);}

// go through the 24month+ aggregate results

list<boolean> thisbools24 = new list<boolean>(); account thisClient24 = new account(); id a1_client_id24;

for (AggregateResult ar24M : twentyFourMonthsOrOlder )  {
a1_client_id24 = null;
if (ar24M.get('a1ia')==false && ar24M.get('a1id')!=null) {a1_client_id24 = string.valueof(ar24M.get('a1id'));}
if (ar24M.get('a2ia')==false && ar24M.get('a2id')!=null) {a1_client_id24 = string.valueof(ar24M.get('a2id'));}
if (ar24M.get('a3ia')==false && ar24M.get('a3id')!=null) {a1_client_id24 = string.valueof(ar24M.get('a3id'));}

thisclient24 = allclientsmap.get(a1_client_id24);
if(thisclient24 != null)
{thisbools24 = clientsresults.get(thisclient24);

 thisbools24[2]=true;
 clientsresults.put(thisclient24,thisbools24);
}
}

// go through the 12-24m results

list<boolean> thisbools12 = new list<boolean>(); account thisClient12 = new account(); id a1_client_id12;

for (AggregateResult ar12_24M : twelveto24monthsago )  {
a1_client_id12 = null;
if (ar12_24M.get('a1ia')==false && ar12_24M.get('a1id')!=null) {a1_client_id12 = string.valueof(ar12_24M.get('a1id'));}
if (ar12_24M.get('a2ia')==false && ar12_24M.get('a2id')!=null) {a1_client_id12 = string.valueof(ar12_24M.get('a2id'));}
if (ar12_24M.get('a3ia')==false && ar12_24M.get('a3id')!=null) {a1_client_id12 = string.valueof(ar12_24M.get('a3id'));}

thisclient12 = allclientsmap.get(a1_client_id12);
if(thisclient12 != null)
{thisbools12 = clientsresults.get(thisclient12);

 thisbools12[1]=true;
 clientsresults.put(thisclient12,thisbools12);
}
}

// go through the Recent results

list<boolean> thisboolsRec = new list<boolean>(); account thisClientRec = new account(); id a1_client_idRec;

for (AggregateResult lessThan12M : moreRecentthan12Months )  {
a1_client_idRec = null;
if (lessThan12M.get('a1ia')==false && lessThan12M.get('a1id')!=null) {a1_client_idRec = string.valueof(lessThan12M.get('a1id'));}
if (lessThan12M.get('a2ia')==false && lessThan12M.get('a2id')!=null) {a1_client_idRec = string.valueof(lessThan12M.get('a2id'));}
if (lessThan12M.get('a3ia')==false && lessThan12M.get('a3id')!=null) {a1_client_idRec = string.valueof(lessThan12M.get('a3id'));}

thisclientRec = allclientsmap.get(a1_client_idRec);
if(thisclientRec != null)
{thisboolsRec = clientsresults.get(thisclientRec);

 thisboolsRec[0]=true;
 clientsresults.put(thisclientRec,thisboolsRec);
}
}

// So we should now have a map of every client parent id and 3 booleans
// next step is to go through and compare to the existing value and build an update set if changed

// Make a new map of <account, string> to store the account and the new business type

map<account,string> clientsOutput = new map<account,string> ();
list<boolean> resultbools = new list<boolean>();

system.debug(clientsresults);

for (account this_client : clientsresults.keyset()) {
 resultbools.clear();
 resultbools = clientsresults.get(this_client);

 if (resultbools[0] == false && resultbools[1] == false && resultbools[2] == false) {clientsOutput.put(this_client,'Never');}// 'Never'
 if (resultbools[0] == false && resultbools[1] == false && resultbools[2] == true ) {clientsOutput.put(this_client,'Lapsed');}// Lapsed
 if (resultbools[0] == false && resultbools[1] == true  && resultbools[2] == false) {clientsOutput.put(this_client,'Lapsed');}// Lapsed
 if (resultbools[0] == false && resultbools[1] == true  && resultbools[2] == true ) {clientsOutput.put(this_client,'Lapsed');}// Lapsed
 if (resultbools[0] == true  && resultbools[1] == false && resultbools[2] == false) {clientsOutput.put(this_client,'New');}// New
 if (resultbools[0] == true  && resultbools[1] == false && resultbools[2] == true ) {clientsOutput.put(this_client,'Reactivated');}// Reactivated
 if (resultbools[0] == true  && resultbools[1] == true  && resultbools[2] == false) {clientsOutput.put(this_client,'Existing');}// Existing
 if (resultbools[0] == true  && resultbools[1] == true  && resultbools[2] == true ) {clientsOutput.put(this_client,'Existing');}// Existing
}

// now compare this with the initial type, and if different, then add to an update list

list<account> updateAccountSet = new list<account>();

for (account this_client : clientsOutput.keyset()) {
    if (clientsOutput.get(this_client) == allClientsMap.get(this_client.id).business_type__c) {} //do nothing, same as before
    else {this_client.business_type__c = clientsOutput.get(this_client);
          updateAccountSet.add(this_client);}
} 

update updateAccountSet;

}
public static void Rollup() {
// find all the child accounts
// find all their parent
// create a family

// for each family pool the results and pick the 'best' business type
// update all parents and children with the same status

id AdSalesAccRTid = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1].id;

map <id, account> everyone           = new map <id, account>([select id, business_type__c, parentid, parent.name from account where recordtype.id = :AdSalesAccRTid limit 50000]);
map <id, account> all_children       = new map <id, account>([select id, business_type__c, parentid, parent.name from account where parent.name <> null and business_type__c <> null limit 50000]);
map <id, account> all_parents        = new map <id, account>([select id, business_type__c, parentid, parent.name from account where id not in :all_children.keyset() and business_type__c <> null limit 50000]);
map <id, list<account>> all_families = new map <id, list<account>>();

// setup the family map with the parent ids as the key, and the parent as the first member
for (id this_childid : all_children.keyset()) {
    list <account> parentlist = new list <account>();
    parentlist.add(everyone.get(all_children.get(this_childid).parentid));
    all_families.put(all_children.get(this_childid).parentid, parentlist);
}

// now add the children
list<account> current_members = new list<account> ();
for (account this_child : all_children.values()) {
    current_members = all_families.get(this_child.parentid);
    current_members.add(this_child);
    all_families.put(this_child.parentid, current_members);
}

// that should mean we have a map of families
// now loop through those families, for each, find the best type and update all members of the family

integer maxtypescore = 0;
map<string, integer> typescores = new map<string, integer> {
    'Never'=>1,
    'Lapsed'=>2,
    'New'=>3,
    'Reactivated'=>4,
    'Existing'=>5};
map<integer, string> scoretypes = new map<integer, string> {
    1=>'Never',
    2=>'Lapsed',
    3=>'New',
    4=>'Reactivated',
    5=>'Existing'};

map  <id, account> upd_accountmap   = new map <id, account>();
list <account> this_familys_members = new list <account>();
// first, do the grandchildren
for (id this_family : all_families.keyset()) 
if (everyone.get(this_family).parent.name!=null)
{
    this_familys_members = all_families.get(this_family);
    maxtypescore = 0;
    // get this family's maxscore
    for (account this_member : this_familys_members) {
        if (typescores.get(this_member.business_type__c)>maxtypescore) {maxtypescore=typescores.get(this_member.business_type__c);}
    }
    //update all members of the same family with the max score
    for (account this_member : this_familys_members) {
        if (this_member.business_type__c<>scoretypes.get(maxtypescore)) {this_member.business_type__c = scoretypes.get(maxtypescore); upd_accountmap.put(this_member.id, this_member);}
    }
}
// now do the rest
for (id this_family : all_families.keyset()) {
if (everyone.get(this_family).parent.name==null)
    this_familys_members = all_families.get(this_family);
    maxtypescore = 0;
    // get this family's maxscore
    for (account this_member : this_familys_members) {
        if (typescores.get(this_member.business_type__c)>maxtypescore) {maxtypescore=typescores.get(this_member.business_type__c);}
    }
    //update all members of the same family with the max score
    for (account this_member : this_familys_members) {
        if (this_member.business_type__c<>scoretypes.get(maxtypescore)) {this_member.business_type__c = scoretypes.get(maxtypescore); upd_accountmap.put(this_member.id, this_member);}
    }
}
update upd_accountmap.values();

}

}