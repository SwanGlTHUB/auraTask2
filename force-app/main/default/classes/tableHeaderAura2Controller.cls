public inherited sharing class tableHeaderAura2Controller {
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

    @AuraEnabled
    public static Trip__c createNewTrip(Decimal costForOwner, Decimal costForClients){
        Integer numberOfTripRecords = [
            SELECT COUNT()
            FROM Trip__c
        ];
        Trip__c newTrip = new Trip__c(Name = 'Trip_' + String.valueOf(numberOfTripRecords), Cost_For_Clients__c = costForClients, Cost_For_Owner__c = costForOwner);
        return newTrip;
    }
    
    @AuraEnabled
    public static void createBookedRoom(String relatedPriceId, String relatedRoomId, String relatedTripId) {
        Price__c relatedPrice = [
            SELECT Purchase_Price__c, Selling_Price__c
            FROM Price__c
            WHERE Id = :relatedPriceId
        ];

        Room__c relatedRoom = [
            SELECT Hotel__c
            FROM Room__c
            WHERE Id = : relatedRoomId
        ];

        Booked_Room__c newBookedRoom = new Booked_Room__c(Hotel__c = relatedRoom.Hotel__c,
                                                          Trip__c = relatedTripId,
                                                          Room__c = relatedRoom.Id,
                                                          Purchase_Price__c = relatedPrice.Purchase_Price__c,
                                                          Selling_Price__c = relatedPrice.Selling_Price__c );

        insert newBookedRoom;
    }
}