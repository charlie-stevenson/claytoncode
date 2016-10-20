Public class SplitPrintOppLineItem {

public static void addSplitPrintOppLineItem(OpportunityLineItem OLI) {

system.debug('Hello world');

OpportunityLineItem o_orig = OLI;

decimal numofissues = o_orig.Quantity;
list<Issue__c> issues;
list<Issue__c> Next_Issue;
string iss_id = o_orig.Issue__c;

// Is this Line Item for more than one Issue?

if (numofissues>1){

// find the first issue number

issues     = [select issue__c.id,
                     issue__c.issue_id__c,
                     issue__c.issue_number__c,
                     issue__c.Publication_Name__c
              from   Issue__c 
              where Issue__c.id = :iss_id];

for (issue__c iss: issues) { 

string NextIssNumber = iss.issue_number__c;
string ThisPublication = iss.Publication_Name__c;
decimal NextIssNumberNum = decimal.valueof(NextIssNumber)+1;

next_issue =  [select issue__c.id,
                      issue__c.issue_id__c,
                      issue__c.publication_name__c
               from   Issue__c
               where  Issue_number__c = :string.valueof(NextIssNumberNum)
               and    Publication_Name__c = :thispublication];

for (issue__c next_iss: next_issue) { 

// update the the original to become the First Issue with Quantity = 1

    o_orig.Quantity   = 1;

//create the new remainder

    OpportunityLineItem o_new = new OpportunityLineItem (

    OpportunityID    = o_orig.OpportunityID,
    PriceBookEntryID = o_orig.PriceBookEntryID,
    description      = o_orig.description,
//    description      = next_iss.publication_name__c,
    UnitPrice        = o_orig.UnitPrice,
//    UnitPrice        = NextIssIDNum, 
    Quantity         = numofissues - 1,
    Issue__c         = next_iss.id,
    Position__c      = o_orig.Position__c,
    copied_to_ack__c = true
    );

    insert o_new;

    }
   }
  }
 }
}