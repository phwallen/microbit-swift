
/*
 MicrobitUIController.swift
 
 Created by Peter Wallen on 11/12/2017
 Version 1.0
 
 Copyright © 2018 Peter Wallen.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 
 This file contains a number of view controllers used to provide a User Interface for demonstrating the
 Microbit Bluetooth Application Programming Interface (see Microbit.swift)
 */
import UIKit

public class MicrobitUIController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    public var microbit:Microbit?
    var tableView = UITableView()
    var menu = ["Accelerometer",
                "Beacon",
                "Buttons",
                "Events",
                "LED",
                "Magnetometer",
                "Pin IO",
                "Temperature",
                "UART",
                "Log"]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let margins = view.layoutMarginsGuide
        
        let title = UILabel()
        title.text = "Micro:bit Test App."
        title.textAlignment = .center
        let titleFont = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        title.font = titleFont
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        
        Layout.manager(title,margins:margins,left:0,right:0,top:20,bottom:50,pinH:.both,pinV:.top)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        Layout.manager(tableView,margins:margins,left:0,right:0,top:60,bottom:0,pinH:.both,pinV:.both)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menu[indexPath.row]
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menu[indexPath.row] {
        case "Accelerometer" :
            let newViewController = MicrobitAccelerometerController()
            newViewController.microbit = microbit
            present(newViewController, animated: true, completion: nil)
        case "Beacon" :
            let newViewController = MicrobitBeaconController()
            newViewController.microbit = microbit
            present(newViewController, animated: true, completion: nil)
        case "Buttons" :
            let newViewController = MicrobitButtonsController()
            newViewController.microbit = microbit
            present(newViewController, animated: true, completion: nil)
        case "Events" :
            let newViewController = MicrobitEventsController()
            newViewController.microbit = microbit
            present(newViewController, animated: true, completion: nil)
        case "LED" :
            let newViewController = MicrobitLEDController()
            newViewController.microbit = microbit
            present(newViewController, animated: true, completion: nil)
        case "Magnetometer" :
            let newViewController = MicrobitMagnetometerController()
            newViewController.microbit = microbit
            present(newViewController, animated: true, completion: nil)
        case "Pin IO" :
            let newViewController = MicrobitPinIOController()
            newViewController.microbit = microbit
            present(newViewController, animated: true, completion: nil)
        case "Temperature" :
            let newViewController = MicrobitTemperatureController()
            newViewController.microbit = microbit
            present(newViewController, animated: true, completion: nil)
        case "UART" :
            let newViewController = MicrobitUARTController()
            newViewController.microbit = microbit
            present(newViewController, animated: true, completion: nil)
        case "Log" :
            let newViewController = MicrobitLogController()
            newViewController.microbit = microbit
            present(newViewController, animated: true, completion: nil)
        default :
            break
        }
    }
}
class MicrobitLogController:UIViewController,MicrobitUIDelegate,MicrobitDelegate {
    var microbit:Microbit?
    var microbitLogView:MicrobitLogView?
    var microbitControl:MicrobitControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIButton(type:.system)
        backButton.setTitle("Back",for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self,action: #selector(MicrobitLogController.backButton),for: .primaryActionTriggered)
        view.addSubview(backButton)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(backButton,margins:margins,left:-50,right:0,top:20,bottom:40,pinH:.right,pinV:.top)
        
        microbitLogView = MicrobitLogView(view:view,viewSize:.large)
        microbitControl = MicrobitControl(view: view)
        microbitControl?.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        microbit?.delegate = self
        microbitLogView?.updateLogView(log: (microbit?.log)!)
    }
    @objc func backButton(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Implement required MicrobitUIDelegate functions
    func startScanning() {
        microbit?.startScanning()
    }
    func stopScanning() {
        microbit?.stopScanning()
    }
    func disconnect() {
        microbit?.disconnect()
    }
    // MARK: Implement required MicrobitDelegate functions
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
}
class MicrobitAccelerometerController:UIViewController,MicrobitUIDelegate,MicrobitDelegate {
    var microbit:Microbit?
    var microbitLogView:MicrobitLogView?
    var microbitAccelerometer:MicrobitAccelerometer?
    var microbitControl:MicrobitControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIButton(type:.system)
        backButton.setTitle("Back",for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self,action: #selector(MicrobitAccelerometerController.backButton),for: .primaryActionTriggered)
        view.addSubview(backButton)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(backButton,margins:margins,left:-50,right:0,top:20,bottom:40,pinH:.right,pinV:.top)
        
        microbitAccelerometer = MicrobitAccelerometer(view:view)
        microbitAccelerometer?.delegate = self
        microbitControl = MicrobitControl(view: view)
        microbitLogView = MicrobitLogView(view:view,viewSize:.medium)
        microbitControl?.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        microbit?.delegate = self
        microbitLogView?.updateLogView(log: (microbit?.log)!)
    }
    @objc func backButton(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Implement required MicrobitUIDelegate functions
    func startScanning() {
        microbit?.startScanning()
    }
    func stopScanning() {
        microbit?.stopScanning()
    }
    func disconnect() {
        microbit?.disconnect()
    }
    func accelerometerSet(period: PeriodType) {
        microbit?.accelerometer(period: period)
    }
    // MARK: Implement required MicrobitDelegate functions
    func accelerometerData(x: Int16, y: Int16, z: Int16) {
        microbitAccelerometer?.update(x:x,y:y,z:z)
    }
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
    func serviceAvailable(service:ServiceName) {
        if service == .Accelerometer {
            microbitAccelerometer?.setPeriod()
        }
    }
}
class MicrobitMagnetometerController:UIViewController,MicrobitUIDelegate,MicrobitDelegate {
    var microbit:Microbit?
    var microbitMagnetometer:MicrobitMagnetometer?
    var microbitLogView:MicrobitLogView?
    var microbitControl:MicrobitControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIButton(type:.system)
        backButton.setTitle("Back",for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self,action: #selector(MicrobitMagnetometerController.backButton),for: .primaryActionTriggered)
        view.addSubview(backButton)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(backButton,margins:margins,left:-50,right:0,top:20,bottom:40,pinH:.right,pinV:.top)
        
        microbitMagnetometer = MicrobitMagnetometer(view:view)
        microbitMagnetometer?.delegate = self
        microbitControl = MicrobitControl(view: view)
        microbitControl?.delegate = self
        microbitLogView = MicrobitLogView(view:view,viewSize:.small)
    }
    override func viewDidAppear(_ animated: Bool) {
        microbit?.delegate = self
        microbitLogView?.updateLogView(log: (microbit?.log)!)
    }
    @objc func backButton(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Implement required MicrobitUIDelegate functions
    func startScanning() {
        microbit?.startScanning()
    }
    func stopScanning() {
        microbit?.stopScanning()
    }
    func disconnect() {
        microbit?.disconnect()
    }
    func magnetometerSet(period: PeriodType) {
        microbit?.magnetometer(period: period)
    }
    // MARK: Implement required MicrobitDelegate functions
    func magnetometerData(x: Int16, y: Int16, z: Int16) {
        microbitMagnetometer?.updateData(x:x,y:y,z:z)
    }
    func compass(bearing: Int16) {
        microbitMagnetometer?.updateBearing(bearing: bearing)
    }
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
    func serviceAvailable(service:ServiceName) {
        if service == .Magnetometer {
            microbitMagnetometer?.setPeriod()
        }
    }
}
class MicrobitButtonsController:UIViewController,MicrobitUIDelegate,MicrobitDelegate {
    var microbit:Microbit?
    var microbitButtons:MicrobitButtons?
    var microbitControl:MicrobitControl?
    var microbitLogView:MicrobitLogView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIButton(type:.system)
        backButton.setTitle("Back",for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self,action: #selector(MicrobitButtonsController.backButton),for: .primaryActionTriggered)
        view.addSubview(backButton)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(backButton,margins:margins,left:-50,right:0,top:20,bottom:40,pinH:.right,pinV:.top)
        
        microbitButtons = MicrobitButtons(view:view)
        microbitControl = MicrobitControl(view: view)
        microbitControl?.delegate = self
        microbitLogView = MicrobitLogView(view:view,viewSize:.small)
    }
    override func viewDidAppear(_ animated: Bool) {
        microbit?.delegate = self
        microbitLogView?.updateLogView(log: (microbit?.log)!)
    }
    @objc func backButton(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Implement required MicrobitUIDelegate functions
    func startScanning() {
        microbit?.startScanning()
    }
    func stopScanning() {
        microbit?.stopScanning()
    }
    func disconnect() {
        microbit?.disconnect()
    }
    func buttonPressed(button: String, action: MicrobitButtonType) {
        microbitButtons?.update(button: button, action: action)
    }
    // MARK: Implement required MicrobitDelegate functions
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
    func serviceAvailable(service:ServiceName) {
        if service == .Button {

        }
    }
}
class MicrobitTemperatureController:UIViewController,MicrobitUIDelegate,MicrobitDelegate {
    var microbit:Microbit?
    var microbitTemperature:MicrobitTemperature?
    var microbitControl:MicrobitControl?
    var microbitLogView:MicrobitLogView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIButton(type:.system)
        backButton.setTitle("Back",for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self,action: #selector(MicrobitTemperatureController.backButton),for: .primaryActionTriggered)
        view.addSubview(backButton)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(backButton,margins:margins,left:-50,right:0,top:20,bottom:40,pinH:.right,pinV:.top)
        
        microbitTemperature = MicrobitTemperature(view:view)
        microbitTemperature?.delegate = self
        microbitControl = MicrobitControl(view: view)
        microbitControl?.delegate = self
        microbitLogView = MicrobitLogView(view:view,viewSize:.small)
    }
    override func viewDidAppear(_ animated: Bool) {
        microbit?.delegate = self
        microbitLogView?.updateLogView(log: (microbit?.log)!)
    }
    @objc func backButton(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Implement required MicrobitUIDelegate functions
    func startScanning() {
        microbit?.startScanning()
    }
    func stopScanning() {
        microbit?.stopScanning()
    }
    func disconnect() {
        microbit?.disconnect()
    }
    func temperatureSet(period: UInt16) {
        microbit?.temperature(period: period)
    }
    // MARK: Implement required MicrobitDelegate functions
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
    func temperature(value: Int16) {
        microbitTemperature?.update(temperature: value)
    }
    func serviceAvailable(service:ServiceName) {
        if service == .Temperature {
            
        }
    }
}
class MicrobitLEDController:UIViewController,MicrobitUIDelegate,MicrobitDelegate {
    var microbit:Microbit?
    var microbitLED:MicrobitLED?
    var microbitControl:MicrobitControl?
    var microbitLogView:MicrobitLogView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIButton(type:.system)
        backButton.setTitle("Back",for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self,action: #selector(MicrobitTemperatureController.backButton),for: .primaryActionTriggered)
        view.addSubview(backButton)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(backButton,margins:margins,left:-50,right:0,top:20,bottom:40,pinH:.right,pinV:.top)
        
        microbitLED = MicrobitLED(view:view)
        microbitLED?.delegate = self
        microbitControl = MicrobitControl(view: view)
        microbitControl?.delegate = self
        microbitLogView = MicrobitLogView(view:view,viewSize:.small)
    }
    override func viewDidAppear(_ animated: Bool) {
        microbit?.delegate = self
        microbitLogView?.updateLogView(log: (microbit?.log)!)
    }
    @objc func backButton(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Implement required MicrobitUIDelegate functions
    func startScanning() {
        microbit?.startScanning()
    }
    func stopScanning() {
        microbit?.stopScanning()
    }
    func disconnect() {
        microbit?.disconnect()
    }
    func ledText(message: String, scrollRate: Int16) {
        microbit?.ledText(message: message, scrollRate: scrollRate)
    }
    func ledSet(matrix: [UInt8]) {
        microbit?.ledWrite(matrix: matrix)
    }
    // MARK: Implement required MicrobitDelegate functions
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
    func serviceAvailable(service:ServiceName) {
        if service == .LED {
            
        }
    }
}
class MicrobitPinIOController:UIViewController,MicrobitUIDelegate,MicrobitDelegate {
    var microbit:Microbit?
    var microbitPinIO:MicrobitPinIO?
    var microbitControl:MicrobitControl?
    var microbitLogView:MicrobitLogView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIButton(type:.system)
        backButton.setTitle("Back",for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self,action: #selector(MicrobitPinIOController.backButton),for: .primaryActionTriggered)
        view.addSubview(backButton)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(backButton,margins:margins,left:-50,right:0,top:20,bottom:40,pinH:.right,pinV:.top)
        
        microbitPinIO = MicrobitPinIO(view:view)
        microbitPinIO?.delegate = self
        microbitControl = MicrobitControl(view: view)
        microbitControl?.delegate = self
        microbitLogView = MicrobitLogView(view:view,viewSize:.small)
    }
    override func viewDidAppear(_ animated: Bool) {
        microbit?.delegate = self
        microbitLogView?.updateLogView(log: (microbit?.log)!)
    }
    @objc func backButton(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Implement required MicrobitUIDelegate functions
    func startScanning() {
        microbit?.startScanning()
    }
    func stopScanning() {
        microbit?.stopScanning()
    }
    func disconnect() {
        microbit?.disconnect()
    }
    func pinWrite(value: [UInt8 : UInt8]) {
        microbit?.pinSet(pinValues: value)
    }
    func pinSetfor(read:[UInt8:Bool]) {
        microbit?.pinConfigure(readPins:read)
    }
    func pinSetfor(analogue: [UInt8:Bool]) {
        microbit?.pinConfigure(analougePins:analogue)
    }
    // MARK: Implement required MicrobitDelegate functions
    func pinGet(pins: [UInt8 : UInt8]) {
        microbitPinIO?.update(pins: pins)
    }
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
    func serviceAvailable(service:ServiceName) {
        if service == .IOPin {
            
        }
    }
}
class MicrobitEventsController:UIViewController,MicrobitUIDelegate,MicrobitDelegate {
    var microbit:Microbit?
    var microbitUIEvent:MicrobitUIEvent?
    var microbitControl:MicrobitControl?
    var microbitLogView:MicrobitLogView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIButton(type:.system)
        backButton.setTitle("Back",for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self,action: #selector(MicrobitEventsController.backButton),for: .primaryActionTriggered)
        view.addSubview(backButton)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(backButton,margins:margins,left:-50,right:0,top:20,bottom:40,pinH:.right,pinV:.top)
        
        microbitUIEvent = MicrobitUIEvent(view:view)
        microbitUIEvent?.delegate = self
        microbitControl = MicrobitControl(view: view)
        microbitControl?.delegate = self
        microbitLogView = MicrobitLogView(view:view,viewSize:.medium)
    }
    override func viewDidAppear(_ animated: Bool) {
        microbit?.delegate = self
        microbitLogView?.updateLogView(log: (microbit?.log)!)
    }
    @objc func backButton(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Implement required MicrobitUIDelegate functions
    func startScanning() {
        microbit?.startScanning()
    }
    func stopScanning() {
        microbit?.stopScanning()
    }
    func disconnect() {
        microbit?.disconnect()
    }
    func raiseEvent(event: MicrobitEvent, value: UInt16) {
        microbit?.raiseEvent(event: event, value: value)
    }
    func event(register: [Int16]) {
        microbit?.registerEvents(events: register)
    }
    // MARK: Implement required MicrobitDelegate functions
    func microbitEvent(type: Int16, value: Int16) {
        microbitUIEvent?.update(type: type, value: value)
    }
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
    func serviceAvailable(service:ServiceName) {
        if service == .Event {
            microbitUIEvent?.registerEvents(events: [9010,9011,9012,9013,9014,9015])
        }
    }
}
class MicrobitUARTController:UIViewController,MicrobitUIDelegate,MicrobitDelegate {
    var microbit:Microbit?
    var microbitUART:MicrobitUART?
    var microbitControl:MicrobitControl?
    var microbitLogView:MicrobitLogView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIButton(type:.system)
        backButton.setTitle("Back",for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self,action: #selector(MicrobitUARTController.backButton),for: .primaryActionTriggered)
        view.addSubview(backButton)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(backButton,margins:margins,left:-50,right:0,top:20,bottom:40,pinH:.right,pinV:.top)
        
        microbitUART = MicrobitUART(view:view)
        microbitUART?.delegate = self
        microbitControl = MicrobitControl(view: view)
        microbitControl?.delegate = self
        microbitLogView = MicrobitLogView(view:view,viewSize:.medium)
    }
    override func viewDidAppear(_ animated: Bool) {
        microbit?.delegate = self
        microbitLogView?.updateLogView(log: (microbit?.log)!)
    }
    @objc func backButton(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Implement required MicrobitUIDelegate functions
    func startScanning() {
        microbit?.startScanning()
    }
    func stopScanning() {
        microbit?.stopScanning()
    }
    func disconnect() {
        microbit?.disconnect()
    }
    func uartSend(message: String) {
        microbit?.uartSend(message: message)
    }
    // MARK: Implement required MicrobitDelegate functions
    func uartReceived(message: String) {
        microbitUART?.outputField.text = message
    }
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
    func serviceAvailable(service:ServiceName) {
        if service == .UART {
        
        }
    }
}
class MicrobitBeaconController:UIViewController,MicrobitUIDelegate,MicrobitDelegate {
    var microbit:Microbit?
    var microbitUIAdvertisement:MicrobitUIAdvertisement?
    var microbitControl:MicrobitControl?
    var microbitLogView:MicrobitLogView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIButton(type:.system)
        backButton.setTitle("Back",for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self,action: #selector(MicrobitBeaconController.backButton),for: .primaryActionTriggered)
        view.addSubview(backButton)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(backButton,margins:margins,left:-50,right:0,top:20,bottom:40,pinH:.right,pinV:.top)
        
        microbitUIAdvertisement = MicrobitUIAdvertisement(view:view)
        microbitControl = MicrobitControl(view: view)
        microbitControl?.delegate = self
        microbitLogView = MicrobitLogView(view:view,viewSize:.medium)
    }
    override func viewDidAppear(_ animated: Bool) {
        microbit?.delegate = self
        microbitLogView?.updateLogView(log: (microbit?.log)!)
    }
    @objc func backButton(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Implement required MicrobitUIDelegate functions
    func startScanning() {
        microbit?.startScanning()
    }
    func stopScanning() {
        microbit?.stopScanning()
    }
    func disconnect() {
        microbit?.disconnect()
    }
    // MARK: Implement required MicrobitDelegate functions
    func advertisementData(url: String, namespace: Int64, instance: Int32, RSSI: Int) {
        microbitUIAdvertisement?.upadateAdverisementData(url: url, namespace: namespace, instance: instance, RSSI: RSSI)
    }
    func logUpdated(_ log: [String]) {
        microbitLogView?.updateLogView(log: log)
    }
}
