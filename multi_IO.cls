public class multi_IO {

    public List<MasterWrapper> getMasters()
    {
    String PB = System.currentPagereference().getParameters().get('PB');
    system.debug('PB='+PB);
    String PBtype = System.currentPagereference().getParameters().get('PBType');
    system.debug('PBType='+PBType);
    String PBMonth = System.currentPagereference().getParameters().get('PBMonth');
    system.debug('PBMonth='+PBMonth);
    String PBIssue = System.currentPagereference().getParameters().get('PBIssue');
    system.debug('PBIssue='+PBIssue);
    String OppID = System.currentPagereference().getParameters().get('OppID');
    system.debug('OppID='+OppID);

           List<MasterWrapper> masters=new List<MasterWrapper>();
           string querystring = '';

           if (PBType == 'Print')  {querystring = 'SELECT source__c, client_account_name__c, AcknowledgementID__c, amount, Clients_PO__c, Acknowledgement_total_amount__c, StageName , pricebook_logo__c , pricebook_name_2__c, CloseDate, Added_value__c, Site_Targeting__c, IP_Targeting__c, above_the_fold__c, advertising_tiling_warning__c, First_Account_Rep__r.Full_name__c, Account.name, Second_Account__r.Name, Third_Account__r.Name, Account.BillingStreet,Account.BillingPostalCode, Account.BillingCity, Second_Account_Contact__r.full_name__c, Third_Account_Contact__r.full_name__c, Pricebook2.description, First_Account_Fee__c, first_account_commission__c, second_account_commission__c, Second_Account_Fee__c, Net__c, Description, Owner.title, Owner.firstname, Owner.lastname, Owner.user_signature__c, First_Account_Rep__r.Phone, First_Account_Rep__r.Email, Second_Account_Contact__r.Phone, Second_Account_Contact__r.Email, Third_Account_Contact__r.Phone, Third_Account_Contact__r.Email, Name, do_not_invoice__c, Allow_Tiling__c FROM Opportunity where don_t_print_this_io__c = false and stagename = \'Closed Won\' and id in (select Opportunityid from OpportunityLineItem where issue__c = :PBIssue) order by AcknowledgementID__c';}
      else if (PBType == 'Online') {querystring = 'SELECT source__c, client_account_name__c, AcknowledgementID__c, amount, Clients_PO__c, Acknowledgement_total_amount__c, StageName , pricebook_logo__c , pricebook_name_2__c, CloseDate, Added_value__c, Site_Targeting__c, IP_Targeting__c, above_the_fold__c, advertising_tiling_warning__c, First_Account_Rep__r.Full_name__c, Account.name, Second_Account__r.Name, Third_Account__r.Name, Account.BillingStreet,Account.BillingPostalCode, Account.BillingCity, Second_Account_Contact__r.full_name__c, Third_Account_Contact__r.full_name__c, Pricebook2.description, First_Account_Fee__c, first_account_commission__c, second_account_commission__c, Second_Account_Fee__c, Net__c, Description, Owner.title, Owner.firstname, Owner.lastname, Owner.user_signature__c, First_Account_Rep__r.Phone, First_Account_Rep__r.Email, Second_Account_Contact__r.Phone, Second_Account_Contact__r.Email, Third_Account_Contact__r.Phone, Third_Account_Contact__r.Email, Name, do_not_invoice__c, Allow_Tiling__c FROM Opportunity where don_t_print_this_io__c = false and stagename = \'Closed Won\' and id in (select Opportunityid from OpportunityLineItem where issue__c = \'\' and Finance_Month__c = :PBMonth and IDG_PriceBook_Property__c=:PB) order by AcknowledgementID__c';}
      else if (PBType == 'Single') {querystring = 'SELECT source__c, client_account_name__c, AcknowledgementID__c, amount, Clients_PO__c, Acknowledgement_total_amount__c, StageName , pricebook_logo__c , pricebook_name_2__c, CloseDate, Added_value__c, Site_Targeting__c, IP_Targeting__c, above_the_fold__c, advertising_tiling_warning__c, First_Account_Rep__r.Full_name__c, Account.name, Second_Account__r.Name, Third_Account__r.Name, Account.BillingStreet,Account.BillingPostalCode, Account.BillingCity, Second_Account_Contact__r.full_name__c, Third_Account_Contact__r.full_name__c, Pricebook2.description, First_Account_Fee__c, first_account_commission__c, second_account_commission__c, Second_Account_Fee__c, Net__c, Description, Owner.title, Owner.firstname, Owner.lastname, Owner.user_signature__c, First_Account_Rep__r.Phone, First_Account_Rep__r.Email, Second_Account_Contact__r.Phone, Second_Account_Contact__r.Email, Third_Account_Contact__r.Phone, Third_Account_Contact__r.Email, Name, do_not_invoice__c, Allow_Tiling__c FROM Opportunity where id = :OppID';}
                 
           List<Opportunity> Opps = Database.query(querystring);
           for (Opportunity master : Opps)
           {
               masters.add(new MasterWrapper(master));
           }

       return masters;
       }
    
    public class MasterWrapper
    {
        public Opportunity master {get; set;}
        public List<Ack_Detail__c> related;
        
        public MasterWrapper(Opportunity theMaster)
        {
            master =theMaster;
        }
        
        public List<Ack_Detail__c> getRelated()
        {
            if (null==related)
            {
               related = [SELECT id, Name,
                       Ack_Display_Brand__c, 
                       Ack_UnitPrice__c,
                       Ack_LinePrice__c,
                       Ack_Product__c,
                       Ack_LineIssueDate__c,
                       Ack_LineComments__c,
                       Ack_Quantity__c,
                       Ack_Sort_Order__c
                           FROM Ack_Detail__c
                           WHERE Opportunity__c=:master.id
                           order by Ack_Sort_Order__c];
            }
            return related; 
        }
    }
}