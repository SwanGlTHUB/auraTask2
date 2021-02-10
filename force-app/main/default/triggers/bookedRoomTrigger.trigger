trigger bookedRoomTrigger on Booked_Room__c (before insert, after delete) {
    List<Id> allBookedRoomsId = new List<Id>();
    for(Booked_Room__c bookedRoom : Trigger.New){
        allBookedRoomsId.add(bookedRoom.Id);
    }
    List<AggregateResult> numberOfBookedRoomsInTrip = new List<AggregateResult>();
    numberOfBookedRoomsInTrip = [
        SELECT Trip__r.Id,  COUNT(Id)
        FROM Booked_Room__c
        WHERE Trip__r.Id IN :allBookedRoomsId
        GROUP BY Trip__r.Id
    ];

    for(Booked_Room__c bookedRoom : Trigger.New){
        bookedRoom.Rented_Rooms__c = numberOfBookedRoomsInTrip[bookedRoom.Trip__c].get('value');
    }
}