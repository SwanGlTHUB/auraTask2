({
    handleCheckboxChange : function(component, event, helper) {
        let isSelected = event.target.checked
        let selectRoomEvent = component.getEvent("roomSelect");
        let relatedRoom = component.get('v.room')
        if(isSelected){
            relatedRoom.actionType = 'add'
            selectRoomEvent.setParams({room: relatedRoom})
        }else{
            relatedRoom.actionType = 'remove'
            selectRoomEvent.setParams({room: relatedRoom})
        }
        console.log('go')
        selectRoomEvent.fire()
    }
})
