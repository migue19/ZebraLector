//
//  Protocols.swift
//  ZebraLector
//
//  Created by Miguel Mexicano Herrera on 03/11/23.
//
import Foundation
protocol EventReceiverDelegate: AnyObject {
    func establishConnection(readerID: Int32)
}
