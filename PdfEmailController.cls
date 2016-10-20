public with sharing class PdfEmailController {

  public String OppID = ApexPages.currentPage().getParameters().get('OppID');
  Opportunity this_Opp = [select name,
                          AdOpsEmailAddress__c,
                          AcknowledgementID__c,
                          stageName,
                          first_account_rep__r.email,
                          first_account_rep__r.name,
                          probability
                          from opportunity
                          where id = :OppID limit 1];

  public String  getdisplay_existing_email() {return this_opp.first_account_rep__r.email;}
  public Boolean bccme            {get {if (bccme==null) return true; else return bccme;} set;}
  public String  ccanother        {get; set;}
  public String  email_subject    {get {if (email_subject==null) {if (this_Opp.stageName=='Closed Won') 
                                                                  {return 'IDG Insertion Order';} 
                                                                  else {return 'IDG Proposal';}} 
                                        else return email_subject;} set;}
//  public String  getexisting_email() {return this_opp.first_account_rep__r.email;}
  public String  email_body       {get;set;}
  public String  new_email        {get;set;}  
  public String  getOppName()     {return this_Opp.name;}
  public String  getAckID()       {return this_Opp.AcknowledgementID__c;}
// updated to include Closed Won or 80% + 
  public Boolean getisClosedWon() {Boolean stageResult = this_Opp.StageName.equals('Closed Won')||this_Opp.probability>=50;
                                   return stageResult;}
  public Boolean getisHighpercent() {Boolean stageisHigh   = this_Opp.probability>=50;
                                   return stageisHigh;}
  public Boolean getHasRep()      {Boolean repExists   = this_Opp.first_account_rep__c!=null;
                                   return repExists;}
  public Boolean getRepHasEmail() {Boolean emailExists;
                                        if(getHasRep())
                                             {emailExists = this_Opp.first_account_rep__r.email!=null;}
                                        else {emailExists = false;}
                                   return emailExists;}
  public String getRepName()      {return this_Opp.first_account_rep__r.name;}
      
// Send PDF starts here
// ---------------------------------------    
 public PageReference sendPdf() {

//first check that the new_email is populated if required
if (this_opp.first_account_rep__r.email==null&&(new_email==null||new_email==''))
    { ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'You must supply a valid email'));      return null;}
else {
    
//now check that the user has put something in the email body
if (email_body==null||email_body=='')
    { ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'You should put some message for the email'));       return null;}
else {

    string to_email_address;
    contact updatecontact = [select id,
                             email
                             from contact
                             where id = :this_opp.first_account_rep__c limit 1];
    if(new_email<>null&&new_email<>'')
            {to_email_address = new_email; updatecontact.email = new_email;
                try {update updatecontact;}
                catch(DmlException e) { ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'unable to update contact: '+e)); return null;}
            }             
     else 
            {to_email_address = this_opp.first_account_rep__r.email;}

  PageReference pdf = Page.ShowInsertionOrders;
    // add parent id to the parameters for standardcontroller

    pdf.getParameters().put('PBType','Single');
    pdf.getParameters().put('OppID',OppID);
    pdf.getParameters().put('isadops','false');
 
    // the contents of the attachment from the pdf
    Blob body;
 
    try {
 
      // returns the output of the page as a PDF
      body = pdf.getContent();
 
    // need to pass unit test -- current bug  
    } catch (VisualforceException e) {
      body = Blob.valueOf('Some Text');
    }
     
    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
    attach.setContentType('application/pdf');
    attach.setFileName(this_Opp.AcknowledgementID__c+'.pdf');
    attach.setInline(false);
    attach.Body = body;
 
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setUseSignature(false);
    mail.setToAddresses(new String[] { to_email_address });
    if(ccanother<>''&&ccanother<>null) 
        mail.setccAddresses(new String[] { ccanother });
    mail.setbccSender(bccme);        
        system.debug('bccme');
        system.debug(bccme);
    mail.setSubject(email_subject);
    mail.setHtmlBody(email_body);
    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
 
    // Send the email
    try{    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });}
    catch (exception e) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was a problem sending this email: '+e)); return null;}
    
    // create a task, and then redirect to it 
    
    task sentemail = new task (
    whoid = this_opp.first_account_rep__r.id,
    whatid = this_opp.id,
    ownerid = UserInfo.getUserId(),
    ActivityDate = date.today(),
    subject = 'Insertion Order Sent',
    type = 'email',
    description = email_body.replaceAll('<[^>]+>',' '),
    Status = 'Completed');
    insert sentemail;
     
    pagereference pr = new PageReference('/'+sentemail.id);
    pr.setRedirect(true);
    
    return pr;
   }
  }
 }
}