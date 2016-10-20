public with sharing class ListVoucherContacts {

contact[] IDList       = new list<contact>();
contact[] FirstIDList  = new list<contact>();
contact[] SecondIDList = new list<contact>();
contact[] ThirdIDList  = new list<contact>();

private final Contact cntct;

public ListVoucherContacts(ApexPages.StandardSetController controller) {
    this.cntct = (Contact)controller.getRecord();
}

public List<Contact> getListVoucherContacts() {
    return (List<Contact>) contactRecords.getRecords();
}

public ApexPages.StandardSetController contactRecords {

get {
// find all OLIs where issue = thisissue
   {

    string issuenum            = System.currentPagereference().getParameters().get('issue');
    Opportunitylineitem[] OLIs = new list<OpportunityLineItem>();
    Opportunity[] Opps         = new list<Opportunity>();

    if (issuenum!=null) 
    {

// find the Opp Line Items that include thisissuenumber
    OLIs = [select id from opportunitylineitem where Issue_ID__c = :issuenum and Opportunity_Stage__c = 'Closed Won'];

// find the Opportunities that include the OLIs from above
    if(OLIs.size()>0)
        {Opps = [select id from opportunity where id in (select opportunityid from opportunitylineitem where OpportunityLineItem.id in :OLIs)];

// find the 1st contacts
        FirstIDList  = ([select name, account.name, title,
                         mailingcity, MailingCountry,  MailingState,  MailingStreet,  MailingPostalCode, Voucher_Copies_needed__c,
                         account.billingcity, account.billingcountry, account.billingstate, account.billingstreet, account.billingPostalCode
                         from contact where id in (
                             select First_Account_Rep__c
                             from Opportunity
                             where id in :opps
                             and Voucher_Copy_1st_account__c = true
                             and First_Account_Rep__c != '')]);

// find the 2nd  contacts
        SecondIDList = ([select name, account.name, title, MailingCity,  MailingCountry,  MailingState,  MailingStreet,  MailingPostalCode, Voucher_Copies_needed__c,
                         account.billingcity, account.billingcountry, account.billingstate, account.billingstreet, account.billingPostalCode
                         from contact where id in (select Second_Account_Contact__c
                             from Opportunity
                             where id in :opps
                             and Voucher_Copy_2nd_account__c = true
                             and Second_Account_Contact__c!= '')]);

// find the 3rd contacts
        ThirdIDList  = ([select name, account.name, title, MailingCity,  MailingCountry,  MailingState,  MailingStreet,  MailingPostalCode, Voucher_Copies_needed__c,
                         account.billingcity, account.billingcountry, account.billingstate, account.billingstreet, account.billingPostalCode
                         from contact where id in (select Third_Account_Contact__c
                             from Opportunity
                             where id in :opps
                             and Voucher_Copy_3rd_account__c = true
                             and Third_Account_Contact__c!= '')]);

        }

    }
        
//join together

IDList.addall(FirstIDList);
IDList.addall(SecondIDList);
IDList.addall(ThirdIDList);

//        return contactRecords;

    }
        return new ApexPages.StandardSetController (IDList);
}
    set;
}
}