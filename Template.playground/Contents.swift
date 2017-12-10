/*:
 # Swift Playground to demonstrate bluetooth communication with the micro:bit
 Use this playground as a template for creating playgrounds that demonstrate the Microbit class.
 The playground's Sources folder contains:
 - Microbit.swift - a class that uses the core bluetooth api to communicate with a micro:bit
 - MicrobitUI.swift - a set of classes for building a user interface.
*/
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
//: This extension implements MicrobitUI functions specified by the MicrobitUIDelegate protocol
extension MyViewController : MicrobitUIDelegate {
    func startScanning() {
        
    }
    
    func stopScanning() {
        
    }
    
    func disconnect() {
        
    }
    
    func uartSend(message: String) {
        
    }
    
    func pinSetfor(read: [UInt8 : Bool]) {
        
    }
    
    func pinSetfor(analogue: [UInt8 : Bool]) {
        
    }
    
    func pinWrite(value: [UInt8 : UInt8]) {
        
    }
    
    func accelerometerSet(period: PeriodType) {
        
    }
    
    func magnetometerSet(period: PeriodType) {
        
    }
    
    func temperatureSet(period: UInt16) {
        
    }
    
    func ledSet(matrix: [UInt8]) {
        
    }
    
    func ledText(message: String, scrollRate: Int16) {
        
    }
    
    func event(register: [Int16]) {
        
    }
    
    func raiseEvent(event: MicrobitEvent, value: UInt16) {
        
    }
    
    
}
//: This extension implements Microbit functions specified by the Microbit protocol
extension MyViewController : MicrobitDelegate {
    func logUpdated(_ log: [String]) {
        
    }
    
    func advertisementData(url: String, namespace: Int64, instance: Int32, RSSI: Int) {
        
    }
    
    func serviceAvailable(service: ServiceName) {
        
    }
    
    func uartReceived(message: String) {
        
    }
    
    func pinGet(pins: [UInt8 : UInt8]) {
        
    }
    
    func buttonPressed(button: String, action: MicrobitButtonType) {
        
    }
    
    func accelerometerData(x: Int16, y: Int16, z: Int16) {
        
    }
    
    func magnetometerData(x: Int16, y: Int16, z: Int16) {
        
    }
    
    func compass(bearing: Int16) {
        
    }
    
    func microbitEvent(type: Int16, value: Int16) {
        
    }
    
    func temperature(value: Int16) {
        
    }
    
    
}
