public inherited sharing class priceControllerAura {
    @AuraEnabled
    public static List<Price__c> getPricesForTrip(String quantity, String hotelName, Date startTrip, Date endTrip) {
        List<Price__c> prices = [
            SELECT Room__r.Hotel__r.Name, Room__r.Quantity__c, Selling_Price__c, Purchase_price__c, Sales_Start__c, Sales_Stop__c, Room__r.Name
            FROM Price__c
            WHERE ((Room__r.Hotel__r.Name = :hotelName) AND (Room__r.Quantity__c = :quantity))
        ];
        List<Price__c> goodPrices = new List<Price__c>();
        for(Price__c price: prices){
            if(price.Sales_Start__c <= startTrip && price.Sales_Stop__c >= endTrip){
                goodPrices.add(price);
            }
        }
        return goodPrices;
    }
}
