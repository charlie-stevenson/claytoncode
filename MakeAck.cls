Global class MakeAck {

webService static string MakeDetail(string OID) {
{

list<opportunitylineitem> thisOLI = [select id,
                                     opportunityid, 
                                     unitprice, 
                                     quantity, 
                                     description, 
                                     lineissuedate__c, 
                                     productname__c,
                                     position__c,
                                     OLI_Sort_Order__c
                                     from OpportunityLineItem 
                                     where opportunityid = :OID
                                     ];

string world = 'Hello World!!!';
integer counter = 0;

for (opportunitylineitem loopOLI : thisOLI)
{

//opportunitylineitem parentOpp = thisOLI.get(0);
//integer count_IO_Items = [select count() from Ack_Detail__c where Opportunity__c = :parentOpp.opportunityid];
//counter = counter + 1;

string product_name_for_ack;

if(loopOLI.position__c == null)
    product_name_for_ack = loopOLI.productname__c;
else 
    product_name_for_ack = loopOLI.productname__c+' ('+loopOLI.position__c+')';

Ack_Detail__c Ack_New = new Ack_Detail__c
    (Opportunity__c       = loopOLI.opportunityid,
     Ack_product__c       = product_name_for_ack,
     Ack_UnitPrice__c     = loopOLI.UnitPrice,
     Ack_Quantity__c      = loopOLI.quantity,
     Ack_LineComments__c  = loopOLI.description,
     Ack_LineIssueDate__c = loopOLI.LineIssueDate__c,
     Ack_Sort_Order__c    = loopOLI.OLI_Sort_Order__c
);
    
Insert Ack_New;

}
return World;

}
}

webService static string MakeSummary(string OID) {

string               product_name_for_ack;
integer              counter;
opportunitylineitem  last_OLI;
ID                   OpportunityID    ;
string               Ack_product      ;
decimal              initialprice     ;
decimal              initialquantity  ;
string               Ack_LineComments ;
string               Ack_LineIssueDate;
string               Ack_Sort_Order   ;
decimal              finalprice       ;
decimal              finalquantity    ;
string               startD;
string               endD;
string               ackD;
string               issuename;

list<AggregateResult> All_OLIs =    [select opportunityid, 
                                             sum(totalprice)              sumt,
                                             sum(quantity)                sumq,
                                             max(description)             maxdesc, 
                                             min(servicedate)             minstart,
                                             max(end_date__c)             maxend, 
                                             PricebookEntry.product2.name pname,
                                             max(position__c)             maxpos,
                                             min(OLI_Sort_Order__c)       minsort,
                                             issue__r.name                iss
                                     from OpportunityLineItem 
                                     where opportunityid = :OID
                                     group by opportunityid,
                                              PricebookEntry.product2.name,
                                              issue__r.name
                                     ];

for (AggregateResult this_OLI : All_OLIs) {

if (this_OLI.get('maxend') != null)
         {ackD = date.valueof(this_OLI.get('minstart')).format() + ' - ' + date.valueof(this_OLI.get('maxend')).format();}
    else {ackD = date.valueof(this_OLI.get('minstart')).format();}

issuename = string.valueof(this_OLI.get('iss'));
if (issuename != null)
    {ackD = issuename;}

if (string.valueof(this_OLI.get('maxpos')) != null)
         {Ack_Product = string.valueof(this_OLI.get('pname')) + ' (' + string.valueof(this_OLI.get('maxpos')) + ')';}
    else {Ack_Product = string.valueof(this_OLI.get('pname'));}


          Ack_Detail__c Ack_New = new Ack_Detail__c
             (Opportunity__c       = string.valueof(this_OLI.get('opportunityid')),
              Ack_product__c       = Ack_Product,
              Ack_UnitPrice__c     = double.valueof(this_OLI.get('sumt')) / double.valueof(this_OLI.get('sumq')),
              Ack_Quantity__c      = double.valueof(this_OLI.get('sumq')),
              Ack_LineComments__c  = string.valueof(this_OLI.get('maxdesc')),
              Ack_LineIssueDate__c = ackD,
              Ack_Sort_Order__c    = string.valueof(this_OLI.get('minsort')));
          Insert Ack_New;
     
}                                     

string world = 'Hello World!!!';
return World;
}
}