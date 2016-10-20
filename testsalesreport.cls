@istest (seealldata=true)

private class testsalesreport {

static testMethod void myPage_Test() {

/*setup some test stuff*/
issue__c newissue = new issue__c 
    (name = 'this is just a test issue 2395123y95',
        On_Sale_Date__c = Date.newInstance(2010,02,02),
        Issue_Year_Calendar__c = 2011,
        Issue_Year_Financial__c = 2011,
        Issue_Number__c = '32144',
    	pricebook__c='CIO (Print)');
    insert newissue;

/*setup the page*/
    PageReference pageRef = Page.SalesReports;
    Test.setCurrentPageReference(pageRef);
    SalesReportController PC = new SalesReportController();
/*----------------------------------------------*/

string a5 = PC.getCurrentStep();                 system.assertEquals(a5, '1 - starting');
boolean a6 = PC.getrenderStep1();
boolean a7 = PC.getrenderStep2a();
boolean a8 = PC.getrenderStep2b();
boolean a9 = PC.getrenderStep3();
boolean a10 = PC.getrenderVC();
string a11 = PC.getFooter();
string a12 = PC.getURLFinance();
string a13 = PC.getURLOpRep();
string a14 = PC.getURLCoversheet();
string a15 = PC.getURLPrintIOs();
string a16 = PC.getURLVoucherCopies();
string a17 = PC.getURLerror();

/*scenarios*/
/*first page*/
/*get the PB picklist values*/



/*press next1*/
/*AnyPB*/
    List<SelectOption> a1 = PC.getAllPricebookItems();
  /*choose a PB*/  
    PC.setAnyPB('P:345678901235467890CIO (Print)');
    String testPB = PC.getAnyPB();
    system.assertEquals(testPB, 'P:345678901235467890CIO (Print)');
  pagereference a18 = PC.next1();

/*User*/
    list<user> someusers = [select id, name from user where isactive=true];
    PC.setUser(someusers[0].name);

/*press next2a*/
    PC.setAnyPB('P:345678901235467890CIO (Print)');
    List<SelectOption> a2 = PC.getIssueItems();
  /*Choose an Issue*/
list<issue__c> testIssueIn= [select id, name from issue__c];  
    PC.setIssue(testissueIn[0].id+':'+testissueIn[0].name);
    String testIssueOut = PC.getIssue();
    system.assertEquals(testIssueOut, testissueIn[0].id+':'+testissueIn[0].name);
  pagereference a19 = PC.next2a();

/*press next2b*/
    PC.setAnyPB('O:345678901235467890CIO (Online)');
    List<SelectOption> a3 = PC.getMItems();
    List<SelectOption> a4 = PC.getYItems();
  /*choose a month and year*/  
    /*Months*/
    PC.setMonth('Jan');
    String testMonth = PC.getMonth();
    system.assertEquals(testMonth, 'Jan');
    /*Years*/
    PC.setYear('10');
    String testYear = PC.getYear();
    system.assertEquals(testYear, '10');
  pagereference a20 = PC.next2b();
  
/*goback*/
string a21 = PC.goback();
}
}