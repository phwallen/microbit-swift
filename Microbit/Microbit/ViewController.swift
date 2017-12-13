//
//  ViewController.swift
//  Microbit
//
//  Created by Peter Wallen on 27/10/2017.
//  Copyright © 2017 Peter Wallen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let microbit = Microbit("BBC micro:bit [tizip]")
    //let microbit = Microbit("BBC micro:bit")
    var microbitControl:MicrobitControl?
    var microbitLogView:MicrobitLogView?
    var microbitUART:MicrobitUART?
    var microbitPinIO:MicrobitPinIO?
    var microbitAccelerometer:MicrobitAccelerometer?
    var microbitMagnetometer:MicrobitMagnetometer?
    var microbitTemperature:MicrobitTemperature?
    var microbitButtons:MicrobitButtons?
    var microbitLED:MicrobitLED?
    var microbitUIEvent:MicrobitUIEvent?
    var microbitUIAdvertisement:MicrobitUIAdvertisement?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        microbit.delegate = self
        microbitControl = MicrobitControl(view: view)
        microbitControl?.delegate = self
        microbitLogView = MicrobitLogView(view:view)
        //microbitUART = MicrobitUART(view: view)
        //microbitUART?.delegate = self
        //microbitPinIO = MicrobitPinIO(view:view)
        //microbitPinIO?.delegate = self
        //microbitAccelerometer = MicrobitAccelerometer(view: view)
        //microbitAccelerometer?.delegate = self
        //microbitMagnetometer = MicrobitMagnetometer(view:view)
        //microbitMagnetometer?.delegate = self
        //microbitTemperature = MicrobitTemperature(view: view)
        //microbitTemperature?.delegate = self
        //microbitButtons = MicrobitButtons(view:view)
        //microbitLED = MicrobitLED(view:view)
        //microbitLED?.delegate = self
        microbitUIEvent = MicrobitUIEvent(view:view)
        microbitUIEvent?.delegate = self
        //microbitUIAdvertisement = MicrobitUIAdvertisement(view:view)
    }
    override func viewWillDisappear(_ animated: Bool) {
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController:MicrobitUIDelegate {
    
    func raiseEvent(event: MicrobitEvent, value: UInt16) {
        microbit.raiseEvent(event: event, value: value)
    }
    
    func event(register: [Int16]) {
        microbit.registerEvents(events: register)
    }
    
    func ledText(message: String, scrollRate: Int16) {
        microbit.ledText(message: message, scrollRate: scrollRate)
    }
    
    func ledSet(matrix: [UInt8]) {
        microbit.ledWrite(matrix: matrix)
    }
    
    func temperatureSet(period: UInt16) {
        microbit.temperature(period: period)
    }
    
    func magnetometerSet(period: PeriodType) {
        microbit.magnetometer(period: period)
    }
    
    func accelerometerSet(period: PeriodType) {
        microbit.accelerometer(period: period)
    }
    
    func pinWrite(value: [UInt8 : UInt8]) {
        microbit.pinSet(pinValues: value)
    }
    
    func pinSetfor(read:[UInt8:Bool]) {
        microbit.pinConfigure(readPins:read)
    }
    
    func pinSetfor(analogue: [UInt8:Bool]) {
        microbit.pinConfigure(analougePins:analogue)
    }
    
    func startScanning() {
        microbit.startScanning()
    }
    
    func stopScanning() {
        microbit.stopScanning()
    }
    
    func disconnect() {
        microbit.disconnect()
    }
    
    func uartSend(message: String) {
        microbit.uartSend(message: message)
    }
}
extension ViewController:MicrobitDelegate {
    func serviceAvailable(service: ServiceName) {
        switch service {
        case .Event :
            microbitUIEvent?.registerEvents(events: [9010,9011,9012,9013,9014,9015])
            print("Event service available")
        case .Accelerometer :
            print("Accelerometer service available")
        case .Button :
            print ("Button service available")
        case .DeviceInfo :
            print ("Device Information service Available")
        case .IOPin :
            print ("IO Pin service available")
        case .LED :
            print ("LED service available")
        case .Magnetometer :
            print ("Magnetometer service available")
        case .UART :
            print ("UART service available")
        case .Temperature:
            print ("Temperature service available")
        }
    }
    
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
    
    func advertisementData(url: String, namespace: Int64, instance: Int32, RSSI: Int) {
        microbitUIAdvertisement?.upadateAdverisementData(url: url, namespace: namespace, instance: instance, RSSI: RSSI)
    }
    
    func uartReceived(message: String) {
        microbitUART?.outputField.text = message
    }
    
    func pinGet(pins: [UInt8 : UInt8]) {
        microbitPinIO?.update(pins: pins)
    }
    
    func buttonPressed(button: String, action: MicrobitButtonType) {
        microbitButtons?.update(button: button, action: action)
    }
    
    func accelerometerData(x: Int16, y: Int16, z: Int16) {
        microbitAccelerometer?.update(x:x,y:y,z:z)
    }
    
    func magnetometerData(x: Int16, y: Int16, z: Int16) {
        microbitMagnetometer?.updateData(x: x, y: y, z: z)
    }
    
    func compass(bearing: Int16) {
        microbitMagnetometer?.updateBearing(bearing: bearing)
    }
    
    func microbitEvent(type: Int16, value: Int16) {
        microbitUIEvent?.update(type: type, value: value)
    }
    
    func temperature(value: Int16) {
        microbitTemperature?.update(temperature: value)
    }
}
