Global with sharing class CalculateCurrentIssues implements Schedulable{

global void execute(SchedulableContext sc) {
     clearAllIssueStatuses();
     setNewIssueStatuses();
  }

public static void ClearAllIssueStatuses() {
 list<issue__c> allCurrentIssues = [select id from issue__c where issue_status__c != ''];

 for (issue__c thisIssue : allCurrentIssues) {
     thisIssue.issue_Status__c  = '';
     }
try{ update allCurrentIssues;}
     catch(exception e){system.debug(e);}
}

public static void SetNewIssueStatuses() {

Set<string> pubNames = new Set<string>();

list<AggregateResult> findPublications = [select publication_name__c from issue__c where deadline__c >= :date.today() group by publication_name__c];

for (AggregateResult pubList : findPublications) {
 pubNames.add((string)pubList.get('publication_name__c'));
}

system.debug(pubNames);

for (string thisPub : pubNames) {

 list<issue__c> allPubNewIssues = [select id
                                 from issue__c
                                 where publication_name__c = :thisPub
                                 and deadline__c >= :date.today()
                                 order by deadline__c];

 allPubNewIssues[0].issue_status__c = 'Current';
 if (allPubNewIssues.size()>1) {allPubNewIssues[1].issue_status__c = 'Next';}
 if (allPubNewIssues.size()>2) {allPubNewIssues[2].issue_status__c = 'Next+1';}
 if (allPubNewIssues.size()>3) {allPubNewIssues[3].issue_status__c = 'Next+2';}
 if (allPubNewIssues.size()>4) {allPubNewIssues[4].issue_status__c = 'Next+3';}
 if (allPubNewIssues.size()>5) {allPubNewIssues[5].issue_status__c = 'Next+4';}
 if (allPubNewIssues.size()>7) {allPubNewIssues[6].issue_status__c = 'Next+5';}
 if (allPubNewIssues.size()>8) {allPubNewIssues[7].issue_status__c = 'Next+6';}
 if (allPubNewIssues.size()>9) {allPubNewIssues[8].issue_status__c = 'Next+7';}
 if (allPubNewIssues.size()>10) {allPubNewIssues[9].issue_status__c = 'Next+8';}
 if (allPubNewIssues.size()>11) {allPubNewIssues[10].issue_status__c = 'Next+9';}
 if (allPubNewIssues.size()>12) {allPubNewIssues[11].issue_status__c = 'Next+10';}
 if (allPubNewIssues.size()>13) {allPubNewIssues[12].issue_status__c = 'Next+11';}
 
try{update allPubNewIssues;}
     catch(exception e){system.debug(e);}

 list<issue__c> lastTwoPubOldIssues = [select id
                                 from issue__c
                                 where publication_name__c = :thisPub
                                 and deadline__c < :date.today()
                                 order by deadline__c desc
                                 limit 2];

    if(lastTwoPubOldIssues.size()>=1) {lastTwoPubOldIssues[0].issue_status__c = 'Previous';}
    if(lastTwoPubOldIssues.size()>=2) {lastTwoPubOldIssues[1].issue_status__c = 'Previous-1';}
try{update lastTwoPubOldIssues;}
     catch(exception e){system.debug(e);}
}
}

public static testMethod void TestClearAllCurrentIssues() {

Issue__c testOldIssue = new Issue__c
        (Name                    = 'test one',
         Publication_name__c     = 'CIO',
         on_sale_date__c         = date.valueof('2000-01-01'),
         issue_year_calendar__c  = 2001,
         issue_year_financial__c = 2002,
         issue_number__c         = '15376',
         pricebook__c            = 'CIO (Online)',
         deadline__c             = date.valueof('2000-01-01')
         );
         try{insert testOldIssue;}
     catch(exception e){system.debug(e);}

Issue__c testNewIssue = new Issue__c
        (Name                    = 'test two',
         Publication_name__c     = 'CIO',
         on_sale_date__c         = date.today().addDays(3),
         issue_year_calendar__c  = 2011,
         issue_year_financial__c = 2012,
         issue_number__c         = '15377',
         pricebook__c            = 'CIO (Online)',
         deadline__c             = date.today().addDays(2)
         );
         try{insert testNewIssue;}
     catch(exception e){system.debug(e);}

CalculateCurrentIssues.ClearAllIssueStatuses();

list<issue__c> currentIssues = [select id from issue__c where issue_status__c != ''];
system.debug(currentIssues.size());
system.assertequals(0,currentIssues.size());

}

public static testMethod void TestSetNewIssueStatuses() {

Issue__c testOldIssue = new Issue__c
        (Name                    = 'test one',
         Publication_name__c     = 'CIO',
         on_sale_date__c         = date.valueof('2000-01-01'),
         issue_year_calendar__c  = 2001,
         issue_year_financial__c = 2002,
         issue_number__c         = '15376',
         pricebook__c            = 'CIO (Online)',
         deadline__c             = date.valueof('2000-01-01')
         );
         try{insert testOldIssue;}
     catch(exception e){system.debug(e);}

Issue__c testNewIssue = new Issue__c
        (Name                    = 'test two',
         Publication_name__c     = 'CIO',
         on_sale_date__c         = date.today().addDays(3),
         issue_year_calendar__c  = 2011,
         issue_year_financial__c = 2012,
         issue_number__c         = '15377',
         pricebook__c            = 'CIO (Online)',
         deadline__c             = date.today().addDays(2)
         );
         try{insert testNewIssue;}
     catch(exception e){system.debug(e);}

Issue__c testNextIssue = new Issue__c
        (Name                    = 'test three',
         Publication_name__c     = 'CIO',
         on_sale_date__c         = date.today().addDays(33),
         issue_year_calendar__c  = 2011,
         issue_year_financial__c = 2012,
         issue_number__c         = '15378',
         pricebook__c            = 'CIO (Online)',
         deadline__c             = date.today().addDays(32)
         );
         try{insert testNextIssue;}
     catch(exception e){system.debug(e);}

CalculateCurrentIssues.SetNewIssueStatuses();

list<issue__c> currentIssues = [select id from issue__c where issue_status__c != ''];
system.debug(currentIssues.size());
system.assertnotequals(0,currentIssues.size());
}
}
