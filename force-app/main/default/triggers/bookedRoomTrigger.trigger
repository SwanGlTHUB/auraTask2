trigger bookedRoomTrigger on Booked_Room__c (before insert, after delete) {
    List<Id> allBookedRoomsId = new List<Id>();
    for(Booked_Room__c bookedRoom : Trigger.New){
        allBookedRoomsId.add(bookedRoom.Id);
    }
    List<AggregateResult> numberOfBookedRoomsInTrip = new List<AggregateResult>();
    numberOfBookedRoomsInTrip = [
        SELECT Trip__r.Id id,  COUNT(Id)value
        FROM Booked_Room__c
        WHERE Trip__r.Id IN :allBookedRoomsId
        GROUP BY Trip__r.Id
    ];

    Map<String, Integer> getNumberOfBookedRoomsByTrip = new Map<String, Integer>();

    for(AggregateResult aggResult : numberOfBookedRoomsInTrip){
        getNumberOfBookedRoomsByTrip.put((String)aggResult.get('id'), (Integer)aggResult.get('value'));
    }

    for(Booked_Room__c bookedRoom : Trigger.New){
        bookedRoom.Rooms_Rented__c = getNumberOfBookedRoomsByTrip.get((String)bookedRoom.Trip__c);
    }
    
}