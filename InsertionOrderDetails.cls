public with sharing class InsertionOrderDetails {

    public String Name { get; set; }

    public String Opportunity { get; set; }

    public String Opps_Name { get; set; }

    public String getOpportunity_Name() {
        return null;
    }


public Opportunity getOpps() {
        String OppID = System.currentPagereference().getParameters().get('OppID');
        
        return [select
                       Opportunity.AcknowledgementID__c, 
                       Opportunity.amount,
                       Opportunity.Clients_PO__c,
                       Opportunity.Acknowledgement_total_amount__c,
                       Opportunity.StageName ,
                       Opportunity.pricebook_logo__c ,
                       Opportunity.pricebook_name_2__c,
                       Opportunity.CloseDate ,
                       Opportunity.First_Account_Rep__r.Full_name__c,
                       Opportunity.Account.name,
                       Opportunity.Second_Account__r.Name,
                       Opportunity.Third_Account__r.Name,
                       Opportunity.Account.BillingStreet,
                       Opportunity.Account.BillingPostalCode,
                       Opportunity.Account.BillingCity,
                       Opportunity.Second_Account_Contact__r.full_name__c,
                       Opportunity.Third_Account_Contact__r.full_name__c,
                       Opportunity.Pricebook2.description,
                       Opportunity.First_Account_Fee__c,
                       Opportunity.Second_Account_Fee__c,
                       Opportunity.Net__c,
                       Opportunity.Description,
                       Opportunity.Owner.title,
                       Opportunity.Owner.firstname,
                       Opportunity.Owner.lastname,
                       Opportunity.First_Account_Rep__r.Phone,
                       Opportunity.First_Account_Rep__r.Email,
                       Opportunity.Second_Account_Contact__r.Phone,
                       Opportunity.Second_Account_Contact__r.Email,
                       Opportunity.Third_Account_Contact__r.Phone,
                       Opportunity.Third_Account_Contact__r.Email,
                       Opportunity.Name,
                       Opportunity.do_not_invoice__c,
                            (select Ack_UnitPrice__c,
                                    Ack_LinePrice__c,
                                    Ack_Product__c,
                                    Ack_LineIssueDate__c,
                                    Ack_LineComments__c,
                                    Ack_Quantity__c
                             from Opportunity.AcknowledgementDetails__r
                             order by Ack_Sort_Order__c
                             )
                from Opportunity
                where ID = :OppID]
        ;
    }

}