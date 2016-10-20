Global class CalculateCurrentIssues implements Schedulable{

global void execute(SchedulableContext SC) {
     ClearAllIssueStatuses();
     SetNewIssueStatuses();
  }

public static void ClearAllIssueStatuses() {
 list<issue__c> all_current_issues = [select id from issue__c where issue_status__c != ''];

 for (issue__c this_issue : all_current_issues) {
     this_issue.issue_Status__c  = '';
     }
 update all_current_issues;
}

public static void SetNewIssueStatuses() {

Set<string> pub_names = new Set<string>();

list<AggregateResult> find_publications = [select publication_name__c from issue__c where deadline__c >= :date.today() group by publication_name__c];

for (AggregateResult pub_list : find_publications) {
 pub_names.add((string)pub_list.get('publication_name__c'));
}

system.debug(pub_names);

for (string this_pub : pub_names ) {

 list<issue__c> all_pub_new_issues = [select id
                                 from issue__c
                                 where publication_name__c = :this_pub
                                 and deadline__c >= :date.today()
                                 order by deadline__c];

 all_pub_new_issues[0].issue_status__c = 'Current';
 if (all_pub_new_issues.size()>1) {all_pub_new_issues[1].issue_status__c = 'Next';}
 if (all_pub_new_issues.size()>2) {all_pub_new_issues[2].issue_status__c = 'Next+1';}
 if (all_pub_new_issues.size()>3) {all_pub_new_issues[3].issue_status__c = 'Next+2';}
 if (all_pub_new_issues.size()>4) {all_pub_new_issues[4].issue_status__c = 'Next+3';}
 if (all_pub_new_issues.size()>5) {all_pub_new_issues[5].issue_status__c = 'Next+4';}
 if (all_pub_new_issues.size()>7) {all_pub_new_issues[6].issue_status__c = 'Next+5';}
 if (all_pub_new_issues.size()>8) {all_pub_new_issues[7].issue_status__c = 'Next+6';}
 if (all_pub_new_issues.size()>9) {all_pub_new_issues[8].issue_status__c = 'Next+7';}
 if (all_pub_new_issues.size()>10) {all_pub_new_issues[9].issue_status__c = 'Next+8';}
 if (all_pub_new_issues.size()>11) {all_pub_new_issues[10].issue_status__c = 'Next+9';}
 if (all_pub_new_issues.size()>12) {all_pub_new_issues[11].issue_status__c = 'Next+10';}
 if (all_pub_new_issues.size()>13) {all_pub_new_issues[12].issue_status__c = 'Next+11';}
 
 update all_pub_new_issues;

 list<issue__c> last2_pub_old_issues = [select id
                                 from issue__c
                                 where publication_name__c = :this_pub
                                 and deadline__c < :date.today()
                                 order by deadline__c desc
                                 limit 2];

    if(last2_pub_old_issues.size()>=1) {last2_pub_old_issues[0].issue_status__c = 'Previous';}
    if(last2_pub_old_issues.size()>=2) {last2_pub_old_issues[1].issue_status__c = 'Previous-1';}
update last2_pub_old_issues;
}
}

public static testMethod void TestClearAllCurrentIssues() {

Issue__c TestOldIssue = new Issue__c
        (Name                    = 'test one',
         Publication_name__c     = 'CIO',
         on_sale_date__c         = date.valueof('2000-01-01'),
         issue_year_calendar__c  = 2001,
         issue_year_financial__c = 2002,
         issue_number__c         = '15376',
         pricebook__c            = 'CIO (Online)',
         deadline__c             = date.valueof('2000-01-01')
         );
         insert TestOldIssue;

Issue__c TestNewIssue = new Issue__c
        (Name                    = 'test two',
         Publication_name__c     = 'CIO',
         on_sale_date__c         = date.today().addDays(3),
         issue_year_calendar__c  = 2011,
         issue_year_financial__c = 2012,
         issue_number__c         = '15377',
         pricebook__c            = 'CIO (Online)',
         deadline__c             = date.today().addDays(2)
         );
         insert TestNewIssue;

CalculateCurrentIssues.ClearAllIssueStatuses();

list<issue__c> current_issues = [select id from issue__c where issue_status__c != ''];
system.debug(current_issues.size());
system.assertequals(0,current_issues.size());

}

public static testMethod void TestSetNewIssueStatuses() {

Issue__c TestOldIssue = new Issue__c
        (Name                    = 'test one',
         Publication_name__c     = 'CIO',
         on_sale_date__c         = date.valueof('2000-01-01'),
         issue_year_calendar__c  = 2001,
         issue_year_financial__c = 2002,
         issue_number__c         = '15376',
         pricebook__c            = 'CIO (Online)',
         deadline__c             = date.valueof('2000-01-01')
         );
         insert TestOldIssue;

Issue__c TestNewIssue = new Issue__c
        (Name                    = 'test two',
         Publication_name__c     = 'CIO',
         on_sale_date__c         = date.today().addDays(3),
         issue_year_calendar__c  = 2011,
         issue_year_financial__c = 2012,
         issue_number__c         = '15377',
         pricebook__c            = 'CIO (Online)',
         deadline__c             = date.today().addDays(2)
         );
         insert TestNewIssue;

Issue__c TestNextIssue = new Issue__c
        (Name                    = 'test three',
         Publication_name__c     = 'CIO',
         on_sale_date__c         = date.today().addDays(33),
         issue_year_calendar__c  = 2011,
         issue_year_financial__c = 2012,
         issue_number__c         = '15378',
         pricebook__c            = 'CIO (Online)',
         deadline__c             = date.today().addDays(32)
         );
         insert TestNextIssue;

CalculateCurrentIssues.SetNewIssueStatuses();

list<issue__c> current_issues = [select id from issue__c where issue_status__c != ''];
system.debug(current_issues.size());
system.assertnotequals(0,current_issues.size());
}
}
