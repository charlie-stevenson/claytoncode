@isTest
private class Test_PdfEmailController {
 
  static testMethod void testPdfEmailer() {

    Opportunity newOpp = Test_setup_master_data.create();
// get the fields for testing
    Opportunity this_Opp = [select id, AcknowledgementID__c, name, first_account_rep__c, first_account_rep__r.id, probability from opportunity where id = :newOpp.id limit 1];
      
    PageReference pref = Page.Send_IO_to_rep;
    pref.getParameters().put('OppID',newOpp.id);
    Test.setCurrentPage(pref);

    contact firstrep = [select id, email from contact where id = :this_opp.first_account_rep__r.id limit 1];
    firstrep.email = 'idgdvfsvs456@gmail.com';
    firstrep.account_type__c = 'Client';
    firstrep.Role__c         = 'Marketing Manager (Media Facing)';
    firstrep.Seniority__c    = 'Executive';
    update firstrep;
    
    PdfEmailController con  = new PdfEmailController();    
    con.email_body='hello';
      
    Test.startTest();

    pref.getParameters().put('OppID',newOpp.id);
    pref.getParameters().put('message','hello');
    pref.getParameters().put('bccme','false');
    pref.getParameters().put('setccanother','test.test@testidg.co.uk');     
    Test.setCurrentPage(pref);

    con.email_body='hello';
    system.debug(con.getOppName());
    system.debug(con.getAckid());
    system.debug(con.getisclosedwon());      
    system.debug(con.getisHighpercent());      
    system.debug(con.getrepHasEmail());
    system.debug(con.getHasRep());
    system.debug(con.getdisplay_existing_email());
    system.debug(con.getRepName());
      pref = con.sendPdf();

    system.debug(pref);
      
// if everything is OK, the subject line of the email should be "IDG Insertion Order" 
    string expected_subject = 'IDG Insertion Order';
    string actual_subject = con.email_subject;
 
    System.assertEquals(expected_subject, actual_subject);
 
    Test.stopTest(); 
 
  }
}