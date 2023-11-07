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
        eventListener.delegate = self
        apiInstance.srfidSetDelegate(eventListener)
        apiInstance.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_READ | SRFID_EVENT_MASK_STATUS))
        apiInstance.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_BATTERY | SRFID_EVENT_MASK_TRIGGER))
        apiInstance.srfidSetOperationalMode(Int32(SRFID_OPMODE_MFI))
        
        apiInstance.srfidSubsribe(forEvents: Int32(SRFID_EVENT_READER_APPEARANCE | SRFID_EVENT_READER_DISAPPEARANCE))
        apiInstance.srfidEnableAvailableReadersDetection(true)
        
        apiInstance.srfidSubsribe(forEvents: Int32(SRFID_EVENT_SESSION_ESTABLISHMENT | SRFID_EVENT_SESSION_TERMINATION))
        apiInstance.srfidEnableAutomaticSessionReestablishment(true)
        apiInstance.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_BATTERY))
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
    func establishCommunication(readerID: Int) {
        apiInstance.srfidEstablishCommunicationSession(Int32(readerID))
    }
    func endCommunication(readerID: Int) {
        apiInstance.srfidTerminateCommunicationSession(Int32(readerID))
    }
    func getCapabilities(readerID: Int32) {
        var capabilities: srfidReaderCapabilitiesInfo? = srfidReaderCapabilitiesInfo()
        var error_response: NSString?
        let result: SRFID_RESULT = apiInstance.srfidGetReaderCapabilitiesInfo(readerID, aReaderCapabilitiesInfo: &capabilities, aStatusMessage: &error_response)
        if SRFID_RESULT_SUCCESS == result {
            guard let capabilities = capabilities else {
                return
            }
            print("Serial number: \(capabilities.getSerialNumber() ?? "")")
            print("Model: \(capabilities.getModel() ?? "")")
            print("Manufacturer: \(capabilities.getManufacturer() ?? "")")
            print("Manufacturing date: \(capabilities.getManufacturingDate() ?? "")")
            print("Scanner name: \(capabilities.getScannerName() ?? "")")
            print("Ascii version: \(capabilities.getAsciiVersion() ?? "")")
            print("Air version: \(capabilities.getAirProtocolVersion() ?? "")")
            print("Bluetooth address: \(capabilities.getBDAddress() ?? "")")
            print("Select filters number: \(capabilities.getSelectFilterNum())")
            print("Max access sequence: \(capabilities.getMaxAccessSequence())")
            print("Power level: min = \(capabilities.getMinPower()); max = \(capabilities.getMaxPower()); step = \(capabilities.getPowerStep())")
        } else if SRFID_RESULT_RESPONSE_ERROR == result {
            print("Error response from RFID reader: \(error_response ?? "")")
        } else if SRFID_RESULT_RESPONSE_TIMEOUT == result {
            print("Timeout occurs during communication with RFID reader")
        } else if SRFID_RESULT_READER_NOT_AVAILABLE == result {
            print("RFID reader with id = %d is not available \(readerID)")
        } else {
            print("Request failed")
        }
    }
    func batteryStatus(readerID: Int32) {
        let result = apiInstance.srfidRequestBatteryStatus(readerID)
        if SRFID_RESULT_SUCCESS == result {
            print("Request succeed")
        } else {
            print("Request failed")
        }
    }
    func antenaConfiguration(readerID: Int32) {
        var antenna_cfg: srfidAntennaConfiguration?
        var error_response: NSString?
        let result = apiInstance.srfidGetAntennaConfiguration(readerID, aAntennaConfiguration: &antenna_cfg, aStatusMessage: &error_response)
        if SRFID_RESULT_SUCCESS == result {
            guard let antenna_cfg = antenna_cfg else {
                return
            }
            let power: Double = Double(antenna_cfg.getPower())
            let linkProfileIdx = antenna_cfg.getLinkProfileIdx()
            let antenaTari = antenna_cfg.getTari()
            let prefilters = antenna_cfg.getDoSelect()
            print("Antenna power level: \(power/10.0)")
            print("Antenna RF mode index: \(linkProfileIdx)")
            print("Antenna tari: \(antenaTari)")
            print("Antenna pre-filters application \(prefilters == false ? "No" : "Si")")
        } else if SRFID_RESULT_RESPONSE_ERROR == result {
            print("Error response from RFID reader: \(error_response ?? "")")
        } else if SRFID_RESULT_RESPONSE_TIMEOUT == result {
            print("Timeout occurs during communication with RFID reader")
        } else if SRFID_RESULT_READER_NOT_AVAILABLE == result {
            print("RFID reader with id = %d is not available \(readerID)")
        } else {
            print("Request failed")
        }
    }
    /// Metodo para obtener el perfil
    /// RfMode, Max Tari
    func getProfile(readerID: Int32) -> srfidLinkProfile? {
        var profiles: NSMutableArray?
        var error_response: NSString?
        let result = apiInstance.srfidGetSupportedLinkProfiles(readerID, aLinkProfilesList: &profiles, aStatusMessage: &error_response)
        if SRFID_RESULT_SUCCESS == result {
            if let profiles = profiles, profiles.count > 0 {
                let profile = profiles.lastObject as? srfidLinkProfile
                return profile
    //            link_profile_idx = profile?.getRFModeIndex() ?? 0
    //            tari = profile?.getMaxTari() ?? 0
            }
        }
        return nil
    }
    /// Singulation Configuration
}
extension ViewController: EventReceiverDelegate {
    func establishConnection(readerID: Int32) {
        let password = "ascii password"
        let result = apiInstance.srfidEstablishAsciiConnection(readerID, aPassword: password)
        if result == SRFID_RESULT_SUCCESS {
            print("ASCII connection has been established")
        } else if SRFID_RESULT_WRONG_ASCII_PASSWORD == result {
            print("Incorrect ASCII connection password")
        } else {
            print("Failed to establish ASCII connection")
        }
    }
}
