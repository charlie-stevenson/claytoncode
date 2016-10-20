@istest(seealldata=true)
public class TestProspectOpportunity{
  static testMethod void testprospect() {
    
list<recordtype> AdSalesRT = [select id from recordtype where sobjecttype = 'Account' and name = 'Ad Sales' limit 1];

Account newAdSalesClient = new Account (
    name='testClient17393',
    recordtypeid = AdSalesRT[0].id,
    Credit_Rating__c = 'Green',
    isAgency__c=false);

insert newAdSalesClient;    

Account newAdSalesAgency = new Account (
    name='testAgency223876',
    recordtypeid = AdSalesRT[0].id,
    Credit_Rating__c = 'Green',
    isAgency__c=true);

insert newAdSalesAgency;         

Account newAdSalesPRAgency = new Account (
    name='testPRAgency223876',
    recordtypeid = AdSalesRT[0].id,
    Credit_Rating__c = 'Green',
    isAgency__c=true,
    is_PR_agency__c=true);

insert newAdSalesPRAgency;         
      
list<recordtype> ProspectRT = [select id from recordtype where sobjecttype = 'Opportunity' and name = '1.Need Established' limit 1];
  
//test single client prospect
Opportunity newprospect1 = new Opportunity (
    name='testprospect23487623',
    amount=100,
    planned_start_date__c=date.today()+7,
    planned_end_date__c=date.today()+8,
    idg_unit__c='PC Advisor (Online)',
    accountid=newAdSalesClient.id,
    stagename='1. Need or Requirement Established',
    is_quick_prospect__c=true,
    is_quick_prospect_2__c=true,
    IP_Targeting__c='global',
    Site_targeting__c='Run of Site',
    closedate=date.today()+14);
insert newprospect1;

list<OpportunityLineItem> OLIs1 = [select id from OpportunityLineItem where Opportunityid = :newprospect1.id];
      system.assert(OLIs1.size()==0);

//test single PR Agency prospect
Opportunity newprospect7 = new Opportunity (
    name='testPRprospect23487623',
    amount=100,
    planned_start_date__c=date.today()+7,
    planned_end_date__c=date.today()+8,
    idg_unit__c='PC Advisor (Online)',
    accountid=newAdSalesPRAgency.id,
    stagename='1. Need or Requirement Established',
    is_quick_prospect__c=true,
    is_quick_prospect_2__c=true,
    IP_Targeting__c='global',
    Site_targeting__c='Run of Site',
    closedate=date.today()+14);
insert newprospect7;

list<Opportunity> Opp7 = [select id, First_Account_Commission__c from Opportunity where id = :newprospect7.id];
      system.assert(Opp7[0].First_Account_Commission__c == 0);

//test single Agency prospect
Opportunity newprospect6 = new Opportunity (
    name='testprospect23666623',
    amount=100,
    planned_start_date__c=date.today()+7,
    planned_end_date__c=date.today()+8,
    idg_unit__c='PC Advisor (Online)',
    accountid=newAdSalesAgency.id,
    stagename='1. Need or Requirement Established',
    is_quick_prospect__c=true,
    is_quick_prospect_2__c=true,
    IP_Targeting__c='global',
    Site_targeting__c='Run of Site',
    closedate=date.today()+14);
insert newprospect6;

list<OpportunityLineItem> OLIs6 = [select id, Opportunity.First_Account_Commission__c from OpportunityLineItem where Opportunityid = :newprospect6.id];
      system.assert(OLIs6.size()==0);      

list<Opportunity> Opp6 = [select id, First_Account_Commission__c from Opportunity where id = :newprospect6.id];
      system.assert(Opp6[0].First_Account_Commission__c == 15);

// test 2 agencies
Opportunity newprospect2 = new Opportunity (
    name='testprospect2235623',
    amount=100,
    planned_start_date__c=date.today()+7,
    planned_end_date__c=date.today()+8,
    idg_unit__c='PC Advisor (Online)',
    accountid=newAdSalesAgency.id,
    second_account__c=newAdSalesAgency.id,
    stagename='1. Need or Requirement Established',
    is_quick_prospect__c=true,
    is_quick_prospect_2__c=true,    
    IP_Targeting__c='global',
    Site_targeting__c='Run of Site',
    closedate=date.today()+14);
      try {insert newprospect2;}
      catch (DmlException e2) { System.assert( e2.getMessage().contains('You must list the Client Account')); }      

      // test 2 clients
Opportunity newprospect3 = new Opportunity (
    name='testprospect223574743',
    amount=100,
    planned_start_date__c=date.today()+7,
    planned_end_date__c=date.today()+8,
    idg_unit__c='PC Advisor (Online)',
    accountid=newAdSalesClient.id,
    second_account__c=newAdSalesClient.id,
    stagename='1. Need or Requirement Established',
    is_quick_prospect__c=true,
    is_quick_prospect_2__c=true,
    IP_Targeting__c='global',
    Site_targeting__c='Run of Site',
    closedate=date.today()+14);
try {insert newprospect3;}
catch (DmlException e3) { system.debug(e3); System.assert( e3.getMessage().contains('Both accounts are Clients')); }      
      
// test agency-client
    Opportunity newprospect4 = new Opportunity (
    name='testprospect2235213743',
    amount=100,
    planned_start_date__c=date.today()+7,
    planned_end_date__c=date.today()+8,
    idg_unit__c='PC Advisor (Online)',
    accountid=newAdSalesAgency.id,
    second_account__c=newAdSalesClient.id,
    stagename='1. Need or Requirement Established',
    is_quick_prospect__c=true,
    is_quick_prospect_2__c=true,
    IP_Targeting__c='global',
    Site_targeting__c='Run of Site',
    closedate=date.today()+14);
insert newprospect4;
list<OpportunityLineItem> OLIs4 = [select id from OpportunityLineItem where Opportunityid = :newprospect4.id];
      system.assert(OLIs4.size()==0);

      // test client-agency
    Opportunity newprospect5 = new Opportunity (
    name='testprospect2231113',
    amount=100,
    planned_start_date__c=date.today()+7,
    planned_end_date__c=date.today()+8,
    idg_unit__c='PC Advisor (Online)',
    accountid=newAdSalesClient.id,
    second_account__c=newAdSalesAgency.id,
    stagename='1. Need or Requirement Established',
    is_quick_prospect__c=true,
    is_quick_prospect_2__c=true,
    IP_Targeting__c='global',
    Site_targeting__c='Run of Site',
    closedate=date.today()+14);
insert newprospect5;
list<OpportunityLineItem> OLIs5 = [select id from OpportunityLineItem where Opportunityid = :newprospect5.id];
      system.assert(OLIs5.size()==0);  
  
  }
}