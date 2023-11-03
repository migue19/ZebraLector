//
//  ViewController.swift
//  ZebraLector
//
//  Created by Miguel Mexicano Herrera on 02/11/23.
//

import UIKit
class ViewController: UIViewController {
    var m_ReaderList: [String] = []
    var apiInstance: srfidISdkApi = srfidSdkFactory.createRfidSdkApiInstance()
    var eventListener: EventReceiver = EventReceiver()
    var available_readers: NSMutableArray?
    var active_readers: NSMutableArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSDK()
    }
    func setupSDK() {
        apiInstance.srfidSetDelegate(eventListener)
        apiInstance.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_READ | SRFID_EVENT_MASK_STATUS))
        apiInstance.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_BATTERY | SRFID_EVENT_MASK_TRIGGER))
        apiInstance.srfidSetOperationalMode(Int32(SRFID_OPMODE_MFI))
        
        apiInstance.srfidSubsribe(forEvents: Int32(SRFID_EVENT_READER_APPEARANCE | SRFID_EVENT_READER_DISAPPEARANCE))
        apiInstance.srfidEnableAvailableReadersDetection(true)
    }
    @IBAction func startScanner(_ sender: Any) {
        let sdkVersion = apiInstance.srfidGetSdkVersion()
        showMessageBox(message: "Version: \(sdkVersion ?? "")", title: "hola")
    }
    @IBAction func showList(_ sender: Any) {
        apiInstance.srfidGetAvailableReadersList(&available_readers)
        apiInstance.srfidGetActiveReadersList(&active_readers)
        showAvailableList()
        showActiveList()
    }
    func showAvailableList() {
        print("Disponibles")
        guard let available_readers = available_readers else {
            return
        }
        for info in available_readers {
            if let info = info as? srfidReaderInfo {
                print("RFID reader is \(info.isActive() ? "active" : "available"): ID = \(info.getReaderID()) name = \(info.getReaderName() ?? "")")
            }
        }
    }
    func showActiveList() {
        print("Activos")
        guard let available_readers = active_readers else {
            return
        }
        for info in available_readers {
            if let info = info as? srfidReaderInfo {
                print("RFID reader is \(info.isActive() ? "active" : "available"): ID = \(info.getReaderID()) name = \(info.getReaderName() ?? "")")
            }
        }
    }
    func showMessageBox(message: String, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
    }
    func startNFCReading() {
        
    }
}
extension ViewController: zt_IRfidAppEngineDevListDelegate {
    func deviceListHasBeenUpdated() -> Bool {
        return true
    }

}
protocol zt_IRfidAppEngineDevListDelegate: AnyObject {
    func deviceListHasBeenUpdated() -> Bool
}

