@isTest
public inherited sharing class tableHeaderAura2ControllerTest {
    @isTest
    public static void createNewTripTest() {
        String newTripId = tableHeaderAura2Controller.createNewTrip(123, 321);
        Test.StartTest();
        Trip__c insertedTrip = [
            SELECT Id
            FROM Trip__c
            WHERE Id = :newTripId
        ];
        System.AssertEquals((String)insertedTrip.Id, newTripId);
        Test.StopTest();
    }

    @isTest
    public static void getPriceForTripTest(){
        Test.StartTest();
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
        List<Price__c> result = tableHeaderAura2Controller.getPricesForTrip('One-room', 'testHotel', System.today() - 1, System.today() + 1);
        System.AssertEquals(result.size(), 1);
        result = tableHeaderAura2Controller.getPricesForTrip('One-room', 'testHotel', System.today() - 100, System.today() + 100);
        System.AssertEquals(result.size(), 0);
        Test.StopTest();
    }

    @isTest 
    public static void createBookedRoomTest(){
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
        tableHeaderAura2Controller.createBookedRoom(testPrice.Id, testRoom.Id, testTrip.Id);
        List<Booked_Room__c> createdPrice = [
            SELECT Room__c, Trip__c, Hotel__c
            FROM Booked_Room__c
            WHERE (Room__c = :testRoom.Id) AND (Trip__c = :testTrip.Id) AND(Hotel__c = :testHotel.Id)
        ];
        System.AssertEquals(createdPrice.size(), 1);
        Test.StopTest();
    }
}
