public with sharing class SalesReportController {

        String CurrentStep = '1 - starting';
        
        Date    todaysdate = date.today();
        String  Month      = findmonthname(todaysdate.month());
        String  Year       = string.valueof(todaysdate.year()).substring(2,4);
        String  Issue      = '';
        String  User       = userinfo.getname();
        String  AnyPB      = '';
        String  PBName     = '';
        String  PBNameURL  = '';
        
        boolean renderstep1  = true;
        boolean renderstep2a = false;
        boolean renderstep2b = false;
        boolean renderstep3  = false;
        boolean renderVC     = false; /*Voucher Copy report is not valid for online pricebooks*/
                
        string URLFinance       = 'X';
        string URLProspectRep   = 'X';
        string URLOpRep         = 'X';
        string URLCoversheet    = 'X';
        string URLPrintIOs      = 'X';
        string URLVoucherCopies = 'X';
        string URLerror         = ' ';
        string footer           = '';
        
/*- step 1 find All pricebooks for the form options*/
    public List<SelectOption> getAllPricebookItems() {

        List<SelectOption> AllPBOptions = new List<SelectOption>();

/*- step 1a find the Print pricebooks*/

        List<pricebook2> PrintPBs = [select name, id from pricebook2 where name like '%(Print)' and isactive=true order by Name];

        for (pricebook2 x : PrintPBs) {
                AllPBOptions.add(new SelectOption('P:'+x.id+x.name,x.name));
        }

/*- step 1b put in a dummy spacer*/
                AllPBOptions.add(new SelectOption('', '', true));
              

/*- step 1c find the Online pricebooks */
        List<pricebook2> OLPBs = [select name, id from pricebook2 where name like '%(Online)' and isactive=true order by Name];

        for (pricebook2 y : OLPBs) {
                AllPBOptions.add(new SelectOption('O:'+y.id+y.name, y.name));
            }

/*- step 1d put in another dummy spacer*/
                AllPBOptions.add(new SelectOption('', '', true));

/*- step 1d find the other pricebooks */
        List<pricebook2> otherPBs = [select name, id from pricebook2 where (not name like '%(Online)') and (not name like '%(Print)') and (not name = 'Test') and isactive=true order by Name];

        for (pricebook2 z : otherPBs) {
          if (z.name=='IDG') {AllPBOptions.add(new SelectOption('O:'+z.id+z.name, z.name+' (Note: This is used for combined orders, so will contain duplicates)'));}
           else              {AllPBOptions.add(new SelectOption('O:'+z.id+z.name, z.name));}
            }

        return AllPBOptions;}

/*step 1e find all users*/
        public List<SelectOption> getAllUserItems() {
        
        List<selectoption> AllUserItems   = new List<SelectOption>();
        List<user> AllUsers = [select id, name from user where isactive = true order by name];
        for (user u : AllUsers) {
            AllUserItems.add(new SelectOption(u.name,u.name)); }
        return AllUserItems;}

/* Step 2a create the Issues picklist for print pricebooks */
        public List<SelectOption> getIssueItems() {

      List<Issue__c> AllIssues = [select name, Publication_Name__c, id, issue_id__c from Issue__c where Pricebook__c = :AnyPB.substring(20,anyPB.length()) order by On_Sale_Date__c desc];

        List<SelectOption> IssOptions = new List<SelectOption>();
            Issoptions.add(new SelectOption('','', true));
        for (issue__c x : AllIssues) {
            IssOptions.add(new SelectOption(x.id+x.issue_id__c,x.name));
        }
        return Issoptions;    }

/* Step 2b create the Month and Year picklist options for Print Pricebooks    */           
public List<SelectOption> getMItems() {
        List<SelectOption> Moptions = new List<SelectOption>();
        Moptions.add(new SelectOption(''   ,''   , true));
        Moptions.add(new SelectOption('Jan','Jan'));
        Moptions.add(new SelectOption('Feb','Feb'));
        Moptions.add(new SelectOption('Mar','Mar'));
        Moptions.add(new SelectOption('Apr','Apr'));
        Moptions.add(new SelectOption('May','May'));
        Moptions.add(new SelectOption('Jun','Jun'));
        Moptions.add(new SelectOption('Jul','Jul'));
        Moptions.add(new SelectOption('Aug','Aug'));
        Moptions.add(new SelectOption('Sep','Sep'));
        Moptions.add(new SelectOption('Oct','Oct'));
        Moptions.add(new SelectOption('Nov','Nov'));
        Moptions.add(new SelectOption('Dec','Dec'));
        return Moptions;    }

    public List<SelectOption> getYItems() {
        List<SelectOption> Yoptions = new List<SelectOption>();
        Yoptions.add(new SelectOption('','', true));
        Yoptions.add(new SelectOption('10','2010'));
        Yoptions.add(new SelectOption('11','2011'));
        Yoptions.add(new SelectOption('12','2012'));
        Yoptions.add(new SelectOption('13','2013'));
        Yoptions.add(new SelectOption('14','2014'));
        Yoptions.add(new SelectOption('15','2015'));
        Yoptions.add(new SelectOption('16','2016'));
        Yoptions.add(new SelectOption('17','2017'));
        Yoptions.add(new SelectOption('18','2018'));
        Yoptions.add(new SelectOption('19','2019'));
        Yoptions.add(new SelectOption('20','2020'));
        Yoptions.add(new SelectOption('21','2021'));
        return yoptions;    }

/* Get & Set Pricebooks */
    public String getAnyPB()                { return AnyPB;      }
    public string getPBName()               { return PBName;     }
    public void   setAnyPB(String PBChoice) { AnyPB = PBChoice;  }

/* Get & Set User */
    public String getUser()                 { return User;       }
    public void   setUser(String UserChoice){ User = UserChoice; }

     
/*get the render, readonly and URL variables */
    public string  getCurrentStep()  { return CurrentStep;  }
    public boolean getrenderStep1()  { return renderstep1;  }
    public boolean getrenderStep2a() { return renderstep2a; }
    public boolean getrenderStep2b() { return renderstep2b; }
    public boolean getrenderStep3()  { return renderstep3;  }
    public boolean getrenderVC()     { return renderVC;     }
    public string  getFooter()       { return Footer;       }
    
    public string getURLFinance()       { return URLFinance;       }
    public string getURLOpRep()         { return URLOpRep;         }
    public string getURLProspectRep()   { return URLProspectRep;   }
    public string getURLCoversheet()    { return URLCoversheet;    }
    public string getURLPrintIOs()      { return URLPrintIOs;      }
    public string getURLVoucherCopies() { return URLVoucherCopies; }
    public string getURLerror()         { return URLError;         }
        
/* Get & Set Months and Years */
    public String getMonth() {return Month;}
    public void setMonth(String Monthchoice) {month = monthchoice;}

    public String getYear()  {return Year;}
    public void setYear(String Yearchoice)   {year  = yearchoice;}
        
/* Get & Set Issues */
    public String getIssue() {return Issue;}
    public void setIssue(String Issuechoice) {issue = issuechoice;}
                
/* Button to clear options and start over */                
    public string GoBack() {
    system.debug('go back');
        CurrentStep = '1 - starting';
        Month  = findmonthname(todaysdate.month());
        Year   = string.valueof(todaysdate.year()).substring(2,4);
        Issue  = '';
        AnyPB  = '';
        PBName = '';
        PBNameURL = '';
        renderstep1  = true;
        renderstep2a = false;
        renderstep2b = false;
        renderstep3  = false;
        renderVC     = false;
        URLFinance       = 'X';
        URLOpRep         = 'X';
        URLProspectRep   = 'X';
        URLCoversheet    = 'X';
        URLPrintIOs      = 'X';
        URLVoucherCopies = 'X';
        URLerror         = ' ';
        footer           = '';
    return null;
    }

/*Step1*/
    public PageReference next1() {
/*did they select a pricebook*/
        if(AnyPB != null) {
                   PBName = AnyPB.substring(20,AnyPB.length());
                   PBName = PBName.replace(' & ','_');
                   PBName = PBName.replace(' ','_');
                   PBName = PBName.replace('(','');
                   PBName = PBName.replace(')','');

                   PBNameURL = AnyPB.substring(20,AnyPB.length());
                   PBNameURL = PBNameURL.replace(' ','%20');
                   PBNameURL = PBNameURL.replace('&','%26');
                   PBNameURL = PBNameURL.replace('(','%28');
                   PBNameURL = PBNameURL.replace(')','%29');
                   
                   renderstep1  = false;
             if(AnyPB.startsWith('P'))
                  {CurrentStep = '2a - Showing Print Issues';
                   renderstep2a = true;
                   renderstep2b = false;
                   list<issue__c> previousissue = [select name, Publication_Name__c, id, issue_id__c from Issue__c where Pricebook__c = :AnyPB.substring(20,anyPB.length()) and On_Sale_Date__c < :date.today() order by On_Sale_Date__c desc];
                   issue = previousissue[0].id+previousissue[0].issue_id__c;
                  }
             else {CurrentStep = '2b - Showing Online mon/year';
                   renderstep2a = false;
                   renderstep2b = true;}

             renderstep3  = false;
             renderVC     = false;
                   }
        else {PBName = 'whoops xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';}
    return null;
    }

/*Step2a Print*/
    public PageReference next2a() {

        list<issue__c> selectedIssue = [select id, name, on_sale_date__c from issue__c where id = :Issue.substring(0,15)];
        date   onsaledate = selectedIssue[0].on_sale_date__c;
        string onsaledatestring = onsaledate.format(); /*this will return the on sale date in dd/mm/yyyy format*/
        string onsaledatestringUS = onsaledatestring.substring(3,6)+'01/'+onsaledatestring.substring(6,10);  /*this will convert the date to mm/01/yyyy*/

/*Finance URL*/ 
if (PBNameURL.contains('Print'))
    {
        list<report> FinReps = [select id, name from report where developername = 'XXKeyXFinanceX'];
        if (FinReps.size() == 0) 
              {URLError = URLError+'Unable to find FinanceReport XXKeyXFinanceX \n';}
        else  {URLFinance = FinReps[0].id+
                            '?pv0='+
                            OnSaleDateStringUS+
                            '&pv1='+
                            PBNameURL+
                            '&pv2='+
                            selectedIssue[0].name;}
    }
else
    {
        list<report> FinReps = [select id, name from report where developername = 'XXKeyXFinanceXOnline'];
        if (FinReps.size() == 0) 
              {URLError = URLError+'Unable to find FinanceReport XXKeyXFinanceXOnline \n';}
        else  {URLFinance = FinReps[0].id+
                            '?pv0='+
                            OnSaleDateStringUS+
                            '&pv1='+
                            PBNameURL+
                            '&pv2='+
                            selectedIssue[0].name;}
    }
 
/*OpRep URL*/
        list<report> OpReps = [select id, name from report where developername = 'XXKeyXOpportunityRepX'];
        if (OpReps.size() == 0)
             {URLError = URLError+'Unable to find Opportunity Report XXKeyXOpportunityRepX \n';}
        else {URLOpRep = OpReps[0].id+
                            '?pv0='+
                            OnSaleDateStringUS+
                            '&pv1='+
                            PBNameURL+
                            '&pv2='+
                            selectedIssue[0].name;}

/*ProspectRep URL*/
        list<report> ProspectReps = [select id, name from report where developername = 'XXKeyXProspectRepX'];
        if (ProspectReps.size() == 0)
             {URLError = URLError+'Unable to find Prospect Report XXKeyXProspectRepX \n';}
        else {URLProspectRep = ProspectReps[0].id+
                            '?pv0='+
                            OnSaleDateStringUS+
                            '&pv1='+
                            PBNameURL+
                            '&pv2='+
                            selectedIssue[0].name+
                            '&pv3='+
                            User;}
/*Coversheet URL*/
        list<report> CoverReps = [select id, name from report where developername = 'XXKeyXCoversheetX'];
        if (CoverReps.size() == 0)
             {URLError = URLError+'Unable to find Coversheet Report XXKeyXCoversheetX\n';}
        else {URLCoversheet = CoverReps[0].id+
                              '?pv0='+
                              OnSaleDateStringUS+
                              '&pv1='+
                              PBNameURL+
                              '&pv2='+
                              selectedIssue[0].name;}
                              
/*Did they pick an Issue?*/
     if (Issue!=null) {
         if (URLerror==' ') {
                footer       = 'Your Selections :';
                URLPrintIOs      = 'apex/showinsertionorders?PBtype=Print&PBIssue='+Issue.substring(0,15);
                URLVoucherCopies = 'apex/voucher_copy_report?Issue='+Issue.substring(18,issue.length());
                renderstep1  = false;
                renderstep2a = false;
                renderstep2b = false;
                renderstep3  = true;
                renderVC     = true;
               }
         else {}
         }
     else {}
        return null;
    }

/*Step2b Online*/
    public PageReference next2b() {
    
/*Finance URL*/ 
if (PBNameURL.contains('Print'))
    {
        list<report> FinReps = [select id, name from report where developername = 'XXKeyXFinanceX'];
        if (FinReps.size() == 0) 
              {URLError = URLError+'Unable to find FinanceReport XXKeyXFinanceX \n';}
        else  {URLFinance = FinReps[0].id+
                              '?pv0='+
                              findstartofmonth(Month)+Year+
                              '&pv1='+
                              PBNameURL;}
    }
else {
        list<report> FinReps = [select id, name from report where developername = 'xxKeyxFinancexOnline'];
        if (FinReps.size() == 0) 
              {URLError = URLError+'Unable to find FinanceReport xxKeyxFinancexOnline \n';}
        else  {URLFinance = FinReps[0].id+
                              '?pv0='+
                              findstartofmonth(Month)+Year+
                              '&pv1='+
                              PBNameURL;}
    }
 
/*OpRep URL*/
        list<report> OpReps = [select id, name from report where developername = 'XXKeyXOpportunityRepX'];
        if (OpReps.size() == 0)
             {URLError = URLError+'Unable to find Opportunity Report XXKeyXOpportunityRepX \n';}
        else {URLOpRep = OpReps[0].id+
                              '?pv0='+
                              findstartofmonth(Month)+Year+
                              '&pv1='+
                              PBNameURL;}

/*ProspectRep URL*/
        list<report> ProspectReps = [select id, name from report where developername = 'XXKeyXProspectRepX'];
        if (ProspectReps.size() == 0)
             {URLError = URLError+'Unable to find Prospect Report XXKeyXProspectRepX \n';}
        else {URLProspectRep = ProspectReps[0].id+
                              '?pv0='+
                              findstartofmonth(Month)+Year+
                              '&pv1='+
                              PBNameURL+
                              '&pv3='+
                              User;}

/*Coversheet URL*/

        list<report> CoverReps = [select id, name from report where developername = 'XXKeyXCoversheetX'];
        if (CoverReps.size() == 0)
             {URLError = URLError+'Unable to find Coversheet Report XXKeyXCoversheetX\n';}
        else {URLCoversheet = CoverReps[0].id+
                              '?pv0='+
                              findstartofmonth(Month)+Year+
                              '&pv1='+
                              PBNameURL;}

/*Next*/                
       if (URLerror==' ') {
          footer       = 'Your Selections :';
          URLPrintIOs  = 'apex/showinsertionorders?PBtype=Online&PB='+AnyPB.substring(2,17)+'&PBMonth='+Month+'-'+Year;
          renderstep1  = false;
          if((Year!=null)&&(Month!=null)) {
              renderstep2a = false;
              renderstep2b = false;
              renderstep3  = true;
              renderVC     = false;
              CurrentStep = '3 - Displaying URLs';}
          }
       else {}
          return null;
    }

public string findstartofmonth(string mon) {

Map<string, string> monthstartlookup = new Map<string, string>();
monthstartlookup.put('Jan', '01%2F01%2F');
monthstartlookup.put('Feb', '02%2F01%2F');
monthstartlookup.put('Mar', '03%2F01%2F');
monthstartlookup.put('Apr', '04%2F01%2F');
monthstartlookup.put('May', '05%2F01%2F');
monthstartlookup.put('Jun', '06%2F01%2F');
monthstartlookup.put('Jul', '07%2F01%2F');
monthstartlookup.put('Aug', '08%2F01%2F');
monthstartlookup.put('Sep', '09%2F01%2F');
monthstartlookup.put('Oct', '10%2F01%2F');
monthstartlookup.put('Nov', '11%2F01%2F');
monthstartlookup.put('Dec', '12%2F01%2F');

return monthstartlookup.get(mon);

}

public string findmonthname(integer month_num) {

Map<integer, string> monthlookup = new Map<integer, string>();
monthlookup.put(1, 'Jan');
monthlookup.put(2, 'Feb');
monthlookup.put(3, 'Mar');
monthlookup.put(4, 'Apr');
monthlookup.put(5, 'May');
monthlookup.put(6, 'Jun');
monthlookup.put(7, 'Jul');
monthlookup.put(8, 'Aug');
monthlookup.put(9, 'Sep');
monthlookup.put(10,'Oct');
monthlookup.put(11,'Nov');
monthlookup.put(12,'Dec');

return monthlookup.get(month_num);

}
}