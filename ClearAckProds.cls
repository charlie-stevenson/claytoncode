Global class ClearAckProds {

webService static ID deleteall(string url) {

string[] finddotcom = url.split('.com',0);
string ThisOpp = finddotcom[1].substring(1,16);

list<Ack_Detail__c> AckItems;

AckItems     = [select Opportunity__c
              from   Ack_Detail__c 
              where OppID__c = :ThisOpp];

for (Ack_Detail__c ALI: AckItems) { 

delete ALI;
}

return ThisOpp;

}
}