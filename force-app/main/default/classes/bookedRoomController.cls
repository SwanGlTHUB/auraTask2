public with sharing class bookedRoomController {
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
                                                          Purchase_Price__c = relatedRoom.Purchase_Price__c,
                                                          Selling_Price__c = relatedRoom.Selling_Price__c );

        insert newBookedRoom;
    }
}
