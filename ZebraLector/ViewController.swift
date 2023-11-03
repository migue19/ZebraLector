//
//  ViewController.swift
//  ZebraLector
//
//  Created by Miguel Mexicano Herrera on 02/11/23.
//

import UIKit
class ViewController: UIViewController {
    var m_ReaderList: [String] = []
    var api = srfidSdkFactory.createRfidSdkApiInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startScanner(_ sender: Any) {
        showMessageBox(message: "text", title: "hola")
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
