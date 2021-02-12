@isTest
public inherited sharing class BookedRoomTriggerTest {
    @isTest
    public static void BookedRoomTriggerTestM() {
        Test.StartTest();
        Trip__c testTrip = new Trip__c(Name = 'testTrip', Cost_For_Clients__c = 1, Cost_For_Owner__c = 2);
        insert testTrip;
        Hotel__c testHotel = new Hotel__c(Name = 'testHotel');
        insert testHotel;
        Room__c testRoom = new Room__c(Quantity__c = 'One-room', Hotel__c = testHotel.Id, Name = 'testRoom');
        insert testRoom;
        Price__c testPrice = new Price__c(Room__c = testRoom.Id,
                                          Purchase_Price__c = 10,
                                          Selling_Price__c = 123,
                                          Sales_Start__c = System.today() - 2,
                                          Sales_Stop__c = System.today() + 5);
        insert testPrice;
        Room__c testRoom2 = new Room__c(Quantity__c = 'One-room', Hotel__c = testHotel.Id, Name = 'testRoom2');
        insert testRoom2;
        Price__c testPrice2 = new Price__c(Room__c = testRoom.Id,
                                          Purchase_Price__c = 10,
                                          Selling_Price__c = 123,
                                          Sales_Start__c = System.today() - 2,
                                          Sales_Stop__c = System.today() + 5);
        insert testPrice2;
        tableHeaderAura2Controller.createBookedRoom(testPrice.Id, testRoom.Id, testTrip.Id);
        tableHeaderAura2Controller.createBookedRoom(testPrice2.Id, testRoom2.Id, testTrip.Id);
        List<Booked_Room__c> bookedRooms = [
            SELECT Rooms_Rented__c
            FROM Booked_Room__c
        ];
        System.AssertEquals(bookedRooms[0].Rooms_Rented__c, 2);
        delete bookedRooms[0];
        Booked_Room__c lastBookedRoomInTrip = [
            SELECT Rooms_Rented__c
            FROM Booked_Room__c
        ];
        System.AssertEquals(lastBookedRoomInTrip.Rooms_Rented__c, 1);
        Test.StopTest();
    }
}
