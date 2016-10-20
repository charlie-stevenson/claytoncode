// This is the version that splits an opportunity by splitting the price and keeps the Quantity = 1

Public class SplitOnlineOppLineItemPrice {

public static void addSplitOnlineOppLineItemPrice(OpportunityLineItem OLI) {

OpportunityLineItem o_orig = OLI;

date    originalStartDate = o_orig.ServiceDate;
date    originalEndDate   = o_orig.End_Date__c;
integer DaysInOLI         = originalStartDate.DaysBetween(OriginalEndDate) + 1;
decimal DailyPrice     = o_orig.UnitPrice/DaysinOLI;

// Does this Line Item span more than one month

if (o_orig.ServiceDate.monthsbetween(o_orig.End_Date__c)!=0){

date    FirstStartDate     = originalStartDate;

date    StartofFirstMonth  = FirstStartDate.toStartOfMonth();
date    StartofRemainder   = StartofFirstMonth.addMonths(1);
date    FirstEndDate       = StartofRemainder.addDays(-1);

date    RemainderEndDate   = originalEndDate;



// update the the original to become the First Month

    o_orig.UnitPrice        = DailyPrice * (FirstStartDate.daysbetween(FirstEndDate)+1);
    o_orig.ServiceDate      = FirstStartDate;
    o_orig.End_Date__c      = FirstEndDate;

//create the new remainder

    OpportunityLineItem o_new = new OpportunityLineItem (

    OpportunityID    = o_orig.OpportunityID,
    PriceBookEntryID = o_orig.PriceBookEntryID,
    description      = o_orig.description,
    UnitPrice        = DailyPrice * (StartofRemainder.daysbetween(RemainderEndDate)+1),
    Quantity         = 1,
    ServiceDate      = StartofRemainder,
    End_Date__c      = RemainderEndDate,
    copied_to_ack__c = true
    );

    insert o_new;

    }
   }
  }