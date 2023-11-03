//
//  EventReceiver.swift
//  ZebraLector
//
//  Created by Miguel Mexicano Herrera on 03/11/23.
//

import Foundation

class EventReceiver: NSObject, srfidISdkApiDelegate {
    func srfidEventReaderAppeared(_ availableReader: srfidReaderInfo!) {
        print("RFID reader has appeared: ID = \(availableReader.getReaderID()) name = \(availableReader.getReaderName() ?? "")")
    }
    
    func srfidEventReaderDisappeared(_ readerID: Int32) {
        print("RFID reader has disappeared: ID = \(readerID)")
    }
    
    func srfidEventCommunicationSessionEstablished(_ activeReader: srfidReaderInfo!) {
        print(activeReader ?? "")
    }
    
    func srfidEventCommunicationSessionTerminated(_ readerID: Int32) {
        
    }
    
    func srfidEventReadNotify(_ readerID: Int32, aTagData tagData: srfidTagData!) {
        
    }
    
    func srfidEventStatusNotify(_ readerID: Int32, aEvent event: SRFID_EVENT_STATUS, aNotification notificationData: Any!) {
        
    }
    
    func srfidEventProximityNotify(_ readerID: Int32, aProximityPercent proximityPercent: Int32) {
        
    }
    
    func srfidEventMultiProximityNotify(_ readerID: Int32, aTagData tagData: srfidTagData!) {
        
    }
    
    func srfidEventTriggerNotify(_ readerID: Int32, aTriggerEvent triggerEvent: SRFID_TRIGGEREVENT) {
        
    }
    
    func srfidEventBatteryNotity(_ readerID: Int32, aBatteryEvent batteryEvent: srfidBatteryEvent!) {
        print(batteryEvent ?? "")
    }
}