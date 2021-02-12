({
    handleRoomQuantityChange : function(component, event, helper) {
        component.set('v.roomQuantity', event.getSource().get("v.value"))
    },
    handleStartTripChange : function(component, event, helper) {
        component.set('v.startTrip', event.getSource().get("v.value"))
    },
    handleEndTripChange : function(component, event, helper) {
        component.set('v.endTrip', event.getSource().get("v.value"))
    },
    handleFooterButton : function(component, event, helper) {
        let selectedRooms = component.get('v.selectedRooms')
        if(!Object.keys(selectedRooms).length){
            helper.showMyToast('Choose some room for trip')
            return
        }else{
            helper.createNewTrip(selectedRooms, component)
        }
    },
    handleRoomSelection : function(component, event, helper) {
        let selectedRoom = event.getParam('room')
        if(selectedRoom.actionType == 'add'){
            let selectedRooms = component.get('v.selectedRooms')
            selectedRooms[selectedRoom.priceId] = selectedRoom
            component.set('v.selectedRooms', selectedRooms)
        }
        if(selectedRoom.actionType == 'remove'){
            let selectedRooms = component.get('v.selectedRooms')
            delete selectedRooms[selectedRoom.priceId]
            component.set('v.selectedRooms', selectedRooms)
        }
        //helper.setHeaderCheckboxStatus(component)
    },
    handleSearchBtnClick : function(component, event, helper) {
        let hotel = component.get('v.hotelName')
        let roomQuantity = component.get('v.roomQuantity')
        let startTrip = component.get('v.startTrip')
        let endTrip = component.get('v.endTrip')
        if(hotel == null){
            helper.showMyToast('Hotel Name is required Field')
            return
        }
        if(roomQuantity == 'undefined'){
            helper.showMyToast('Quantity is required Field')
            return
        }
        if(startTrip == 'undefined'){
            helper.showMyToast('Start Date is required Field')
            return
        }
        if(endTrip == 'undefined'){
            helper.showMyToast('End Date is required Field')
            return
        }
        let params = {
            quantity: roomQuantity, 
            hotelName: hotel.Name,
            startTrip: startTrip,
            endTrip: endTrip,
        }
        helper.apex(component, 'getPricesForTrip', params)
        .then((result) => {
            let startDate = new Date(startTrip)
            let endDate = new Date(endTrip)
            let tripDuration = (endDate - startDate) / (60 * 60 * 24 * 1000) + 1
            let roomsToDisplay = result.map((room) => {
                let obj = {
                    totalCostPrice: room.Purchase_Price__c * tripDuration,
                    totalSellPrice: room.Selling_Price__c * tripDuration,
                    roomName: room.Room__r.Name,
                    roomId: room.Room__c,
                    priceId: room.Id,
                    hotelId: room.Room__r.Hotel__c,
                    costPrice: room.Purchase_Price__c,
                    sellPrice: room.Selling_Price__c,
                }
                return obj
            })
            component.set('v.roomsToDisplay', roomsToDisplay)
            component.set('v.selectedRooms', {})
            if(Object.keys(roomsToDisplay).length){
                component.set('v.footerButtonClass', 'footerButton')
            }else{
                component.set('v.footerButtonClass', 'disabled')
            }
        })
        .catch((error) => {
            console.log('bad')
            console.log(error)
        })
    }
})
