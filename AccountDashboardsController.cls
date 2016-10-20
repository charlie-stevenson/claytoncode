/*Based on Salesforce source code, but ammended by Charles Stevenson Nov 2011
to meet IDG's Opportunity model

--------
Copyright (c) 2011 salesforce.com, inc. All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright   notice, this list of conditions and the following disclaimer in the   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
By: Chris Kemp <ckemp@salesforce.com>
*/

public with sharing class AccountDashboardsController {

    private final Account acct;
    
    // Default number of years shown on the "Account Sales, Year over Year" report
    static final Integer CLOSED_SALES_AMOUNT_YOY_YEARS_SHOWN = 2;
    
    // Default number of years shown on the "Account Sales, Month over Month" report
    static final Integer CLOSED_SALES_AMOUNT_MOM_YEARS_SHOWN = 2;

    
    public AccountDashboardsController(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
    }

    // For test methods
    public AccountDashboardsController(Account acct) {
        this.acct = acct;
    }

    // Controller to generate the data for the "Account Sales, Year over Year" chart
    public String getClosedSalesAmountYoY() {
        String id = this.acct.Id; 
        final Integer firstYear = date.today().year() - CLOSED_SALES_AMOUNT_YOY_YEARS_SHOWN + 1;
        Double monthsum = 0;
        
/* needed to change the next section so that it provides the groupedresults based on ServiceDate / first month of order
   depending on whether it is online or print.
   and need to include opportunities where 2nd or 3rd account
---------------------------------------------------------------------------*/       
/*online*/ AggregateResult[] groupedOLResults = [SELECT FISCAL_YEAR(start_of_first_month__c) YearOfSale,    
            SUM(net_before_igs__c) TotalAmount
            FROM Opportunity 
            WHERE (AccountId = :id or second_account__c = :id or third_account__c = :id)
            AND FISCAL_YEAR(start_of_first_month__c) >= :firstYear 
            AND IsWon = TRUE
            AND Pricebook_name__c <> 'IDG'
            AND (not Pricebook_name__c like '%Print)')
            GROUP BY FISCAL_YEAR(start_of_first_month__c) ORDER BY FISCAL_YEAR(start_of_first_month__c) ASC];

/*print*/ AggregateResult[] groupedPrintResults = [SELECT FISCAL_YEAR(serviceDate) YearOfSale,    
            SUM(line_item_net_value_before_igs__c) TotalAmount
            FROM OpportunityLineItem
            WHERE (Opportunity.AccountId = :id or Opportunity.second_account__c = :id or Opportunity.third_account__c = :id)
            AND FISCAL_YEAR(serviceDate) >= :firstYear 
            AND Opportunity.IsWon = TRUE
            AND Opportunity.Pricebook_name__c <> 'IDG'
            AND Opportunity.Pricebook_name__c like '%Print)'
            GROUP BY FISCAL_YEAR(ServiceDate) ORDER BY FISCAL_YEAR(ServiceDate) ASC];
            
        Integer dataCount = 0;
        Integer resultCount = 0;
        String resultJS = 'data.addRows(' + CLOSED_SALES_AMOUNT_YOY_YEARS_SHOWN + ');\n';
        
        Map<String, Double> resultMap = new Map<String, Double>();
        for (AggregateResult ar : groupedOLResults)  {
            resultMap.put('O'+String.valueOf(ar.get('YearOfSale')), (Double)ar.get('TotalAmount'));
        }

        for (AggregateResult ar : groupedPrintResults)  {
            resultMap.put('P'+String.valueOf(ar.get('YearOfSale')), (Double)ar.get('TotalAmount'));
        }
  
        // We need to do this so we can fill in blank values with a zero and restrict to the
        // number of years specified in the constant CLOSED_SALES_AMOUNT_YOY_YEARS_SHOWN
        Integer count = 0;
        Integer currentYear = firstYear;

        while (currentYear <= date.today().year()) {
            resultJS += 'data.setValue(' + count + ', 0, \'' +   String.valueOf(currentYear) + '\');\n';
        
            if (resultMap.get('O'+String.valueOf(currentYear)) != null) {
                resultJS += 'data.setValue(' + count + ', 1, ';
                    if (resultMap.get('P'+String.valueOf(currentYear)) != null) {
                          monthsum = resultMap.get('O'+String.valueOf(currentYear)) + resultMap.get('P'+String.valueOf(currentYear)) ;}
                    else {monthsum = resultMap.get('O'+String.valueOf(currentYear));}
                resultJS += string.valueof(monthsum) + ');\n';
            } else {
                if (resultMap.get('P'+String.valueOf(currentYear)) != null) {
                resultJS += 'data.setValue(' + count + ', 1, ';
                    if (resultMap.get('O'+String.valueOf(currentYear)) != null) {
                          monthsum = resultMap.get('O'+String.valueOf(currentYear)) + resultMap.get('P'+String.valueOf(currentYear));}
                    else {monthsum = resultMap.get('P'+String.valueOf(currentYear));}
                resultJS += string.valueof(monthsum) + ');\n';

            }
                resultJS += 'data.setValue(' + count + ', 1, 0);\n';
            }

            count++;
            currentYear++;
        }
        return resultJS;
    }


    // Controller to generate the data for the "Account Sales, Month over Month" chart
    public String getClosedSalesAmountMoM() {
        string debugger = 'hello';
        String id = this.acct.Id;
        final Integer firstYear = date.today().year() - CLOSED_SALES_AMOUNT_MOM_YEARS_SHOWN + 1;

/* need to duplicate this so that it provides the groupedresults based on ServiceDate / first month of order
   depending on whether it is online or print.
   and need to include opportunities where 2nd or 3rd account
---------------------------------------------------------------------------*/       
/*online*/ AggregateResult[] groupedOLResults = [SELECT FISCAL_MONTH(start_of_first_month__c) MonthOfSale,
            FISCAL_YEAR(start_of_first_month__c) YearOfSale,    
            SUM(net_before_igs__c) TotalAmount FROM Opportunity 
            WHERE (AccountId = :id or second_account__c = :id or third_account__c = :id)
            AND FISCAL_YEAR(start_of_first_month__c) >= :firstYear
            AND IsWon = TRUE
            AND Pricebook_name__c <> 'IDG'
            AND (not Pricebook_name__c like '%Print)')
            GROUP BY FISCAL_MONTH(start_of_first_month__c), FISCAL_YEAR(start_of_first_month__c) 
            ORDER BY FISCAL_MONTH(start_of_first_month__c), FISCAL_YEAR(start_of_first_month__c)];

/*print*/ AggregateResult[] groupedPrintResults = [SELECT FISCAL_MONTH(serviceDate) MonthOfSale,    
            FISCAL_YEAR(servicedate) YearOfSale,  
            SUM(line_item_net_value_before_igs__c) TotalAmount
            FROM OpportunityLineItem
            WHERE (Opportunity.AccountId = :id or Opportunity.second_account__c = :id or Opportunity.third_account__c = :id)
            AND FISCAL_YEAR(serviceDate) >= :firstYear 
            AND Opportunity.IsWon = TRUE
            AND Opportunity.Pricebook_name__c <> 'IDG'
            AND Opportunity.Pricebook_name__c like '%Print)'
            GROUP BY FISCAL_MONTH(ServiceDate), FISCAL_YEAR(servicedate)
            ORDER BY FISCAL_MONTH(ServiceDate) ASC, FISCAL_YEAR(servicedate) ASC];

        Integer dataCount = 0;
        Integer resultCount = 0;
        
        Map<String, Double> resultMap = new Map<String, Double>();

        for (AggregateResult ar : groupedOLResults)  {
            resultMap.put('O'+String.valueOf(ar.get('YearOfSale')) + '/' + String.valueOf(ar.get('MonthOfSale')), 
                (Double)ar.get('TotalAmount'));
        }
        
        for (AggregateResult ar : groupedPrintResults)  {
            resultMap.put('P'+String.valueOf(ar.get('YearOfSale')) + '/' + String.valueOf(ar.get('MonthOfSale')), 
                (Double)ar.get('TotalAmount'));
        }

/*        Map<String, Double> dataMap = new Map<String, Double>();*/
        Integer currentYear = firstYear;
        Integer currentMonth = 1;

        String resultJS = 'data.addColumn(\'string\', \'Month\');\n';

        while (currentYear <= date.today().year()) {
            resultJS += 'data.addColumn(\'number\', \'' + currentYear + '\');\n';
            currentYear++;
        }

        Boolean isFirstRow = true;
        resultJS += 'data.addRows([';

        // We need to do this so we can fill in blank values with a zero and restrict to the
        // number of years specified in the constant CLOSED_SALES_AMOUNT_MOM_YEARS_SHOWN
        while (currentMonth < 13) {
            currentYear = firstYear;
            Integer yearCount = 1;
            double monthsum = 0;

            if (isFirstRow == false) {
                resultJS += ',';
            }
            isFirstRow = false;

            resultJS += '\n[\'' + currentMonth + '\'';

            while (currentYear <= date.today().year()) {
                monthsum = 0;
                if (resultMap.get('O'+String.valueOf(currentYear) + '/' + String.valueOf(currentMonth)) != null) {
                    monthsum += resultMap.get('O'+String.valueOf(currentYear)+ '/' + String.valueOf(currentMonth));}

                if (resultMap.get('P'+String.valueOf(currentYear) + '/' + String.valueOf(currentMonth)) != null) {
                    monthsum += resultMap.get('P'+String.valueOf(currentYear)+ '/' + String.valueOf(currentMonth));}
                                    
                    resultJS += ', ' + string.valueof(monthsum);
                
                yearCount++;
                currentYear++;
}             
            resultJS += ']\n';
            currentMonth++;
        }

        resultJS += ']);';

     debugger += resultJS;

        return resultJS;
    }
    
    // Controller to generate the data for the "Sales Amount by Pricebook" chart
    public String getSalesAmountByProduct() {
        final Integer firstYear = date.today().year() - CLOSED_SALES_AMOUNT_YOY_YEARS_SHOWN;
        String id = this.acct.Id;
        String result = '';
        Map<String, Double> salesByPricebook = new Map<String, Double>();

        AggregateResult[] groupedOLPricebookResults = [SELECT pricebook_name_2__c PriceBook,
            sum(net_before_igs__c) TotalSales
            FROM Opportunity
            WHERE (AccountId = :id or second_account__c = :id or third_account__c = :id)
            AND fiscal_year(Start_of_first_month__c) > :firstyear
            AND IsWon = TRUE
            AND Pricebook_name__c <> 'IDG'
            GROUP BY pricebook_name_2__c ];
            
            for (AggregateResult arOL : groupedOLPricebookResults)  {

            salesByPricebook.put(String.valueOf(arOL.get('PriceBook')), 
                (Double)arOL.get('TotalSales'));} 

        result += 'data.addRows(' + salesByPricebook.keySet().size() + ');\n';
        
        Integer count = 0;
        for (String PB : salesByPricebook.keySet()) {
            result += 'data.setValue(' + count + ', 0, \'' + PB + '\');\n';
            result += 'data.setValue(' + count + ', 1, ' + salesByPricebook.get(PB) + ');\n';
            count++;
        }
        
        return result;
    }

    // Controller to generate the data for the "Sales Quantity by Product Family" chart
/*    public String getSalesQuantityByProduct() {
        String id = this.acct.Id;
        String result = '';
        Map<String, Double> qtyByProductFamily = new Map<String, Double>();

        // Get all opportunity line items for all Opportunities associated with this account
        // (can't query OpportunityLineItems directly) and tally them up by product family
        for (Opportunity thisOppty : [SELECT Id, Amount, (SELECT Quantity, TotalPrice, PricebookEntry.product2.Family 
            FROM OpportunityLineItems) FROM Opportunity WHERE Opportunity.AccountId = :id AND IsWon = TRUE]) {
        
            for (OpportunityLineItem oli : thisOppty.OpportunityLineItems) {
        
                if (qtyByProductFamily.get(oli.PricebookEntry.product2.Family) != null) {
                    qtyByProductFamily.put(oli.PricebookEntry.product2.Family, 
                        qtyByProductFamily.get(oli.PricebookEntry.product2.Family) + oli.Quantity);
                } else {
                    qtyByProductFamily.put(oli.PricebookEntry.product2.Family, oli.Quantity);
                }
            }
        }
        
        result += 'data.addRows(' + qtyByProductFamily.keySet().size() + ');\n';
        
        Integer count = 0;
        for (String productFamily : qtyByProductFamily.keySet()) {
            result += 'data.setValue(' + count + ', 0, \'' + productFamily + '\');\n';
            result += 'data.setValue(' + count + ', 1, ' + qtyByProductFamily.get(productFamily) + ');\n';
            count++;
        }
        
        return result;
    }*/
}