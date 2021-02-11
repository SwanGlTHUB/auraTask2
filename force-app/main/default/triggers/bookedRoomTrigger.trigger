trigger BookedRoomTrigger on Booked_Room__c (before insert) {
    Set<Id> allTripsId = new Set<Id>();
    Map<String, Integer> roomsInTrip = new Map<String, Integer>();
    List<AggregateResult> numberOfRoomsInTrip;
    List<Booked_Room__c> allBookedRoomsRelatedToTrips;
    List<Booked_Room__c> bookedRoomsToUpdate = new List<Booked_Room__c>();
    
    for(Booked_Room__c bookedRoom : Trigger.New){
        allTripsId.add(bookedRoom.Trip__c);
    }

    numberOfRoomsInTrip = [
        SELECT Trip__c , COUNT(Id)value
        FROM Booked_Room__c
        WHERE Trip__c IN :allTripsId
        GROUP BY Trip__c
    ];

    allBookedRoomsRelatedToTrips = [
        SELECT Trip__c, Id, Rooms_Rented__c
        FROM Booked_Room__c
        WHERE Id IN :allTripsId
    ];

    for(AggregateResult aggResult : numberOfRoomsInTrip){
        roomsInTrip.put((String)aggResult.get('Trip__c'), (Integer)aggResult.get('value'));
    }
    for(Booked_Room__c bookedRoom: Trigger.New){
        String relatedTrip = (String)bookedRoom.Trip__c;
        Integer numberOfRoomsInTrip = roomsInTrip.get(relatedTrip);
        roomsInTrip.put(relatedTrip, numberOfRoomsInTrip + 1);
    }
    for(Booked_Room__c bookedRoom: Trigger.New){
        String relatedTrip = (String)bookedRoom.Trip__c;
        Integer numberOfRoomsInTrip = roomsInTrip.get(relatedTrip);
        bookedRoom.Rooms_Rented__c = numberOfRoomsInTrip;
    }

    for(Booked_Room__c bookedRoom: allBookedRoomsRelatedToTrips){
        String relatedTrip = (String)bookedRoom.Trip__c;
        Integer numberOfRoomsInTrip = roomsInTrip.get(relatedTrip);
        bookedRoom.Rooms_Rented__c = numberOfRoomsInTrip;
        bookedRoomsToUpdate.add(bookedRoom);
    }

    update bookedRoomsToUpdate;
}