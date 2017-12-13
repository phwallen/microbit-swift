import UIKit

public protocol MicrobitUIDelegate {
    func startScanning()
    func stopScanning()
    func disconnect()
    func uartSend(message:String)
    func pinSetfor(read:[UInt8:Bool])
    func pinSetfor(analogue:[UInt8:Bool])
    func pinWrite(value:[UInt8:UInt8])
    func accelerometerSet(period:PeriodType)
    func magnetometerSet(period:PeriodType)
    func temperatureSet(period:UInt16)
    func ledSet(matrix:[UInt8])
    func ledText(message:String,scrollRate:Int16)
    func event(register:[Int16])
    func raiseEvent(event:MicrobitEvent,value:UInt16)
}
extension MicrobitUIDelegate {
    func startScanning() {}
    func stopScanning() {}
    func disconnect() {}
    func uartSend(message:String) {}
    func pinSetfor(read:[UInt8:Bool]) {}
    func pinSetfor(analogue:[UInt8:Bool]) {}
    func pinWrite(value:[UInt8:UInt8]) {}
    func accelerometerSet(period:PeriodType){}
    func magnetometerSet(period:PeriodType) {}
    func temperatureSet(period:UInt16){}
    func ledSet(matrix:[UInt8]){}
    func ledText(message:String,scrollRate:Int16){}
    func event(register:[Int16]){}
    func raiseEvent(event:MicrobitEvent,value:UInt16){}
}
class Layout {
    enum pinType{
        case left
        case right
        case top
        case bottom
        case both
    }
    class func manager(_ uiObject:UIView,margins:UILayoutGuide,left:CGFloat,right:CGFloat,top:CGFloat,bottom:CGFloat,pinH:pinType,pinV:pinType) {
        switch (pinH) {
        case .left :
            uiObject.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: left).isActive = true
            uiObject.trailingAnchor.constraint(equalTo: margins.leadingAnchor,constant: right).isActive = true
        case .right :
            uiObject.leadingAnchor.constraint(equalTo: margins.trailingAnchor, constant: left).isActive = true
            uiObject.trailingAnchor.constraint(equalTo: margins.trailingAnchor,constant: right).isActive = true
        case .both :
            uiObject.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: left).isActive = true
            uiObject.trailingAnchor.constraint(equalTo: margins.trailingAnchor,constant: right).isActive = true
        default :
            break
        }
        switch (pinV) {
        case .top :
            uiObject.topAnchor.constraint(equalTo: margins.topAnchor, constant: top).isActive = true
            uiObject.bottomAnchor.constraint(equalTo: margins.topAnchor,constant: bottom).isActive = true
        case .bottom :
            uiObject.topAnchor.constraint(equalTo: margins.bottomAnchor, constant: top).isActive = true
            uiObject.bottomAnchor.constraint(equalTo: margins.bottomAnchor,constant: bottom).isActive = true
        case .both :
            uiObject.topAnchor.constraint(equalTo: margins.topAnchor, constant: top).isActive = true
            uiObject.bottomAnchor.constraint(equalTo: margins.bottomAnchor,constant: bottom).isActive = true
        default :
            break
        }
    }
}

public class MicrobitLogView {
    public enum LogViewSize:Int {
        case small  = 350
        case medium = 210
        case large = 50
    }
    let logView = UITextView()
    var viewSize:LogViewSize
    public init(view:UIView,viewSize:LogViewSize = .large) {
        self.viewSize = viewSize
        logView.frame = CGRect(x: 0, y:0, width:300,height:100)
        logView.backgroundColor = UIColor.lightGray
        #if os(iOS)
            logView.isEditable = false
        #endif
        logView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logView)
        
        let margins = view.layoutMarginsGuide
        
        Layout.manager(logView,margins:margins,left:0,right:0,top:CGFloat(viewSize.rawValue),bottom:-10,pinH:.both,pinV:.both)
    }
    
    public func updateLogView(log:[String]) {
        var logBuffer = ""
        for entry in log {
            logBuffer = logBuffer + entry + "\n\n"
        }
        logView.text = logBuffer
        let stringLength = logView.text.count
        logView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }
}

public class MicrobitControl:NSObject{
    public var delegate:MicrobitUIDelegate?
    public init(view:UIView) {
        super.init()
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 0
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let startScanButton = UIButton(type:.system)
        startScanButton.setTitle("Start Scan", for: .normal)
        startScanButton.tag = 0
        //startScanButton.backgroundColor = UIColor.blue
        startScanButton.translatesAutoresizingMaskIntoConstraints = false
        startScanButton.addTarget(self,action: #selector(MicrobitControl.buttonAction),for: .primaryActionTriggered)
        hStackView.addArrangedSubview(startScanButton)
        
        let stopScanButton = UIButton(type:.system)
        stopScanButton.setTitle("Stop Scan",for: .normal)
        stopScanButton.tag = 1
        //stopScanButton.backgroundColor = UIColor.blue
        stopScanButton.translatesAutoresizingMaskIntoConstraints = false
        stopScanButton.addTarget(self,action: #selector(MicrobitControl.buttonAction),for: .primaryActionTriggered)
        hStackView.addArrangedSubview(stopScanButton)
        
        let disconnectButton = UIButton(type:.system)
        disconnectButton.setTitle("Disconnect",for: .normal)
        disconnectButton.tag = 2
        //disconnectButton.backgroundColor = UIColor.blue
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false
        disconnectButton.addTarget(self,action: #selector(MicrobitControl.buttonAction),for: .primaryActionTriggered)
        hStackView.addArrangedSubview(disconnectButton)
        view.addSubview(hStackView)
        let margins = view.layoutMarginsGuide
        
        Layout.manager(hStackView,margins:margins,left:0,right:250,top:20,bottom:40,pinH:.left,pinV:.top)
    }
    @objc func buttonAction(sender:UIButton) {
        switch(sender.tag) {
        case 0 :
            delegate?.startScanning()
        case 1 :
            delegate?.stopScanning()
        case 2 :
            delegate?.disconnect()
        default :
            break
        }
    }
}

public class MicrobitUART:NSObject,UITextFieldDelegate {
    public let inputField = UITextField()
    public let outputField = UILabel()
    public var delegate:MicrobitUIDelegate?
    let errorLabel = UILabel()
    public init(view:UIView) {
        super.init()
        let inputLabel = UILabel()
        inputLabel.text = "UART Input (max. of 20 characters)"
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputLabel)
        
        inputField.backgroundColor = .lightGray
        inputField.delegate = self
        inputField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputField)
        
        let outputLabel = UILabel()
        outputLabel.text = "UART Output"
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(outputLabel)
        
        outputField.backgroundColor = .lightGray
        outputField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(outputField)
        
        let clearButton = UIButton(type:.system)
        clearButton.setTitle("clear", for: .normal)
        //clearButton.backgroundColor = UIColor.blue
        clearButton.addTarget(self,action: #selector(MicrobitUART.buttonAction),for: .primaryActionTriggered)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)
        
        //let errorFont = UIFont(name:"Copperplate",size:10.0)
        let errorFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        errorLabel.font = errorFont
        errorLabel.textColor = .red
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        
        
        let margins = view.layoutMarginsGuide
        let hp:CGFloat = 60.0
        
        Layout.manager(inputLabel,margins:margins,left:20,right:-20,top:hp,bottom:hp + 20,pinH:.both,pinV:.top)
        
        Layout.manager(inputField,margins:margins,left:20,right:-20,top:hp + 30,bottom:hp + 50,pinH:.both,pinV:.top)
        
        Layout.manager(outputLabel,margins:margins,left:20,right:-20,top:hp + 70,bottom:hp + 90,pinH:.both,pinV:.top)
        
        Layout.manager(outputField,margins:margins,left:20,right:-20,top:hp + 100,bottom:hp + 120,pinH:.both,pinV:.top)
        
        Layout.manager(clearButton,margins:margins,left:-100,right:-20,top:hp + 100,bottom:hp + 120,pinH:.right,pinV:.top)
        
        Layout.manager(errorLabel,margins:margins,left:20.0,right:-20.0,top:hp + 60.0,bottom:hp + 70.0,pinH:.both,pinV:.top)
    }
    public func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        guard let input = textField.text else {return false}
        if input.count < 21 {
            errorLabel.text = ""
            textField.resignFirstResponder()
            delegate?.uartSend(message:input)
            return true
        } else {
            errorLabel.text = "More than 20 characters entered"
            return false
        }
    }
    @objc func buttonAction(sender:UIButton) {
        print("clear output field")
        outputField.text = ""
    }
}
public class MicrobitPinIO {
    
    public var delegate:MicrobitUIDelegate?
    
    var ioButtonArray = [UIButton]()
    var adButtonArray = [UIButton]()
    var daButtonArray = [UIButton]()
    var daSliderArray = [UISlider]()
    var analogueLabelArray = [UILabel]()
    var ioStateArray = [Bool]()
    var adStateArray = [Bool]()
    var daStateArray = [Bool]()
    
    public init(view:UIView) {
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 0
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for tag in 0 ..< 10 {
            let vStackView = UIStackView()
            vStackView.axis = .vertical
            vStackView.distribution = .equalSpacing
            vStackView.spacing = 0
            vStackView.translatesAutoresizingMaskIntoConstraints = false
            
            let pinLabel = UILabel()
            pinLabel.text = String(tag)
            pinLabel.translatesAutoresizingMaskIntoConstraints = false
            vStackView.addArrangedSubview(pinLabel)
            
            let ioButton = UIButton(type:.system)
            ioButton.translatesAutoresizingMaskIntoConstraints = false
            ioButton.tag = tag
            ioButton.setTitle("W", for: .normal)
            ioButton.backgroundColor = .lightGray
            ioButton.addTarget(self,action: #selector(MicrobitPinIO.ioButtonAction),for: .primaryActionTriggered)
            vStackView.addArrangedSubview(ioButton)
            ioButtonArray.append(ioButton)
            ioStateArray.append(false)
            
            let adButton = UIButton(type:.system)
            adButton.translatesAutoresizingMaskIntoConstraints = false
            adButton.tag = tag
            adButton.setTitle("D", for: .normal)
            adButton.backgroundColor = .yellow
            adButton.addTarget(self,action: #selector(MicrobitPinIO.adButtonAction),for: .primaryActionTriggered)
            vStackView.addArrangedSubview(adButton)
            if tag > 3 {
                adButton.isEnabled = false
                adButton.backgroundColor = .clear
                adButton.setTitle(" ", for: .normal)
            }
            adButtonArray.append(adButton)
            adStateArray.append(false)
            
            let daButton = UIButton(type:.system)
            daButton.translatesAutoresizingMaskIntoConstraints = false
            daButton.tag = tag
            daButton.setTitle("⚫️", for: .normal)
            daButton.addTarget(self,action: #selector(MicrobitPinIO.daButtonAction),for: .primaryActionTriggered)
            vStackView.addArrangedSubview(daButton)
            daButtonArray.append(daButton)
            daStateArray.append(false)
            
            hStackView.addArrangedSubview(vStackView)
        }
        let margins = view.layoutMarginsGuide
        view.addSubview(hStackView)
        Layout.manager(hStackView,margins:margins,left:0,right:0,top:80,bottom: 230,pinH:.both,pinV:.top)
        
        let head1Label = UILabel()
        head1Label.text = "Pin I/O Control  Panel"
        head1Label.textAlignment = .center
        head1Label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(head1Label)
        Layout.manager(head1Label,margins:margins,left:0,right:0,top:50,bottom:70,pinH:.both,pinV:.top)
        
        let head4Label = UILabel()
        head4Label.text = "Use the the sliders below to set analogue values"
        head4Label.backgroundColor = .lightGray
        head4Label.textAlignment = .center
        head4Label.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(head4Label)
        //Layout.manager(head4Label,margins:margins,left:0,right:0,top:310,bottom: 330,pinH:.both,pinV:.top)
        
        let head2Label = UILabel()
        head2Label.text = "Toggle the buttons below to read (R) or write (W) to the microbit pins"
        head2Label.backgroundColor = .lightGray
        head2Label.textAlignment = .center
        head2Label.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(head2Label)
        //Layout.manager(head2Label,margins:margins,left:0,right:0,top:122,bottom: 140,pinH:.both,pinV:.top)
        
        let head3Label = UILabel()
        head3Label.text = "Toggle the buttons below to set the pins to analogue (A) or digital (D)"
        head3Label.backgroundColor = .lightGray
        head3Label.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(head3Label)
        //Layout.manager(head3Label,margins:margins,left:0,right:0,top:190,bottom: 210,pinH:.both,pinV:.top)
        
        let hStackView1 = UIStackView()
        hStackView1.axis = .horizontal
        hStackView1.distribution = .equalSpacing
        hStackView1.spacing = 50
        hStackView1.translatesAutoresizingMaskIntoConstraints = false
        
        for tag in 0 ..< 4 {
            let vStackView = UIStackView()
            vStackView.axis = .vertical
            vStackView.distribution = .equalSpacing
            vStackView.spacing = 0
            vStackView.translatesAutoresizingMaskIntoConstraints = false
            
            let pinLabel = UILabel()
            pinLabel.text = String(tag)
            pinLabel.translatesAutoresizingMaskIntoConstraints = false
            vStackView.addArrangedSubview(pinLabel)
            
            let slider = UISlider()
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.isContinuous = false
            slider.minimumValue = 0
            slider.maximumValue = 255
            slider.tintColor = .green
            slider.tag = tag
            slider.isEnabled = false
            slider.widthAnchor.constraint(equalToConstant: 100).isActive = true
            slider.addTarget(self,action: #selector(MicrobitPinIO.sliderAction),for:.valueChanged)
            vStackView.addArrangedSubview(slider)
            daSliderArray.append(slider)
            
            let analogueLabel = UILabel()
            analogueLabel.text = "0"
            analogueLabel.translatesAutoresizingMaskIntoConstraints = false
            vStackView.addArrangedSubview(analogueLabel)
            analogueLabelArray.append(analogueLabel)
            
            hStackView1.addArrangedSubview(vStackView)
        }
        view.addSubview(hStackView1)
        Layout.manager(hStackView1,margins:margins,left:0,right:0,top:240,bottom: 340,pinH:.both,pinV:.top)
    }
    public func update(pins:[UInt8:UInt8]) {
        for pin in pins {
            if adStateArray[Int(pin.key)] {
                analogueLabelArray[Int(pin.key)].text = String(pin.value)
                daSliderArray[Int(pin.key)].value = Float(pin.value)
            }
            if pin.value > 0 {
                daButtonArray[Int(pin.key)].setTitle("🔴", for: .normal)
            } else {
                daButtonArray[Int(pin.key)].setTitle("⚫️", for: .normal)
            }
        }
    }
    
    @objc func ioButtonAction(sender:UIButton) {
        if ioStateArray[sender.tag] {
            ioStateArray[sender.tag] = false
            sender.setTitle("W", for: .normal)
        } else {
            ioStateArray[sender.tag] = true
            sender.setTitle("R", for: .normal)
        }
        var readConfig = [UInt8:Bool]()
        var pin:UInt8 = 0
        for state in ioStateArray {
            readConfig[pin] = state
            pin += 1
        }
        delegate?.pinSetfor(read: readConfig)
    }
    @objc func adButtonAction(sender:UIButton) {
        if adStateArray[sender.tag] {
            adStateArray[sender.tag] = false
            sender.setTitle("D", for: .normal)
            daSliderArray[sender.tag].isEnabled = false
            daButtonArray[sender.tag].isEnabled = true
            //analogueLabelArray[sender.tag].text = " "
        } else {
            adStateArray[sender.tag] = true
            sender.setTitle("A", for: .normal)
            daSliderArray[sender.tag].isEnabled = true
            daButtonArray[sender.tag].isEnabled = false
        }
        var analogueConfig = [UInt8:Bool]()
        var pin:UInt8 = 0
        for state in adStateArray {
            analogueConfig[pin] = state
            pin += 1
        }
        delegate?.pinSetfor(analogue: analogueConfig)
    }
    @objc func daButtonAction(sender:UIButton) {
        if daStateArray[sender.tag] {
            daButtonArray[sender.tag].setTitle("⚫️", for: .normal)
            daStateArray[sender.tag] = false
            delegate?.pinWrite(value: [UInt8(sender.tag):0])
        } else {
            daButtonArray[sender.tag].setTitle("🔴", for: .normal)
            daStateArray[sender.tag] = true
            delegate?.pinWrite(value: [UInt8(sender.tag):1])
        }
    }
    @objc func sliderAction(sender:UISlider) {
        print("pin IO switch - \(sender.tag)  \(UInt8(sender.value))")
        analogueLabelArray[sender.tag].text = String(UInt8(sender.value))
        delegate?.pinWrite(value: [UInt8(sender.tag):UInt8(sender.value)])
        
    }
}
public class MicrobitAccelerometer {
    public var delegate:MicrobitUIDelegate?
    
    var xValue = UILabel()
    var yValue = UILabel()
    var zValue = UILabel()
    
    let periodControl = UISegmentedControl(items:["1ms","2ms","5ms","10ms","20ms","80ms","160ms","640ms"])
    
    public init(view:UIView) {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .equalSpacing
        vStackView.spacing = 0
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let head1Label = UILabel()
        head1Label.text = "Accelerometer"
        head1Label.textAlignment = .center
        head1Label.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(head1Label)
        
        let head2Label = UILabel()
        head2Label.text = "Frequency with which accelerometer data is reported in milliseconds"
        head2Label.textAlignment = .center
        head2Label.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(head2Label)
        
        periodControl.translatesAutoresizingMaskIntoConstraints = false
        periodControl.addTarget(self,action: #selector(MicrobitAccelerometer.segmentedControlAction),for: .primaryActionTriggered)
        vStackView.addArrangedSubview(periodControl)
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 0
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let xLabel = UILabel()
        xLabel.translatesAutoresizingMaskIntoConstraints = false
        xLabel.text = "x:"
        hStackView.addArrangedSubview(xLabel)
        xValue = UILabel()
        xValue.widthAnchor.constraint(equalToConstant: 100).isActive = true
        xValue.translatesAutoresizingMaskIntoConstraints = false
        hStackView.addArrangedSubview(xValue)
        let yLabel = UILabel()
        yLabel.translatesAutoresizingMaskIntoConstraints = false
        yLabel.text = "y:"
        hStackView.addArrangedSubview(yLabel)
        yValue = UILabel()
        yValue.translatesAutoresizingMaskIntoConstraints = false
        yValue.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hStackView.addArrangedSubview(yValue)
        let zLabel = UILabel()
        zLabel.translatesAutoresizingMaskIntoConstraints = false
        zLabel.text = "z:"
        hStackView.addArrangedSubview(zLabel)
        zValue = UILabel()
        zValue.translatesAutoresizingMaskIntoConstraints = false
        zValue.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hStackView.addArrangedSubview(zValue)
        
        vStackView.addArrangedSubview(hStackView)
        
        let margins = view.layoutMarginsGuide
        view.addSubview(vStackView)
        Layout.manager(vStackView,margins:margins,left:0,right:0,top:50,bottom: 200,pinH:.both,pinV:.top)
    }
    
    public func update(x:Int16,y:Int16,z:Int16) {
        xValue.text = String(x)
        yValue.text = String(y)
        zValue.text = String(z)
    }
    public func setPeriod() {
        periodControl.selectedSegmentIndex = 7
        delegate?.accelerometerSet(period:.p640)
    }
    @objc func segmentedControlAction(sender:UISegmentedControl) {
        var periodType:PeriodType
        switch sender.selectedSegmentIndex {
        case 0 : periodType = PeriodType.p1
        case 1 : periodType = PeriodType.p2
        case 2 : periodType = PeriodType.p5
        case 3 : periodType = PeriodType.p10
        case 4 : periodType = PeriodType.p20
        case 5 : periodType = PeriodType.p80
        case 6 : periodType = PeriodType.p160
        case 7 : periodType = PeriodType.p640
        default : periodType = PeriodType.p640
        }
        delegate?.accelerometerSet(period: periodType)
    }
}
public class MicrobitMagnetometer {
    public var delegate:MicrobitUIDelegate?
    
    var xValue = UILabel()
    var yValue = UILabel()
    var zValue = UILabel()
    
    let periodControl = UISegmentedControl(items:["1ms","2ms","5ms","10ms","20ms","80ms","160ms","640ms"])
    
    var compassImage = UIImageView()
    var lastBearing:CGFloat = 0.0
    var bearingValue = UILabel()
    
    public init(view:UIView) {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .equalSpacing
        vStackView.spacing = 0
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let head1Label = UILabel()
        head1Label.text = "Magnetometer"
        head1Label.textAlignment = .center
        head1Label.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(head1Label)
        
        let head2Label = UILabel()
        head2Label.text = "Frequency with which magnetometer data is reported in milliseconds"
        head2Label.textAlignment = .center
        head2Label.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(head2Label)
        
        periodControl.translatesAutoresizingMaskIntoConstraints = false
        periodControl.addTarget(self,action: #selector(MicrobitAccelerometer.segmentedControlAction),for: .primaryActionTriggered)
        vStackView.addArrangedSubview(periodControl)
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 0
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let xLabel = UILabel()
        xLabel.translatesAutoresizingMaskIntoConstraints = false
        xLabel.text = "x:"
        hStackView.addArrangedSubview(xLabel)
        xValue = UILabel()
        xValue.widthAnchor.constraint(equalToConstant: 100).isActive = true
        xValue.translatesAutoresizingMaskIntoConstraints = false
        hStackView.addArrangedSubview(xValue)
        let yLabel = UILabel()
        yLabel.translatesAutoresizingMaskIntoConstraints = false
        yLabel.text = "y:"
        hStackView.addArrangedSubview(yLabel)
        yValue = UILabel()
        yValue.translatesAutoresizingMaskIntoConstraints = false
        yValue.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hStackView.addArrangedSubview(yValue)
        let zLabel = UILabel()
        zLabel.translatesAutoresizingMaskIntoConstraints = false
        zLabel.text = "z:"
        hStackView.addArrangedSubview(zLabel)
        zValue = UILabel()
        zValue.translatesAutoresizingMaskIntoConstraints = false
        zValue.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hStackView.addArrangedSubview(zValue)
        
        vStackView.addArrangedSubview(hStackView)
        
        let margins = view.layoutMarginsGuide
        
        view.addSubview(vStackView)
        Layout.manager(vStackView,margins:margins,left:0,right:0,top:50,bottom: 200,pinH:.both,pinV:.top)
        
        let bearingLabel = UILabel()
        bearingLabel.text = "Compass Bearing"
        bearingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bearingLabel)
        Layout.manager(bearingLabel,margins:margins,left:10,right:200,top:210,bottom: 250,pinH:.left,pinV:.top)
        
        bearingValue.text = "0"
        bearingValue.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bearingValue)
        Layout.manager(bearingValue,margins:margins,left:210,right:250,top:210,bottom: 250,pinH:.left,pinV:.top)
        
        let emojiImage = "➸".image()
        compassImage.image = emojiImage
        //compassImage.layer.borderWidth = 1.0
        compassImage.translatesAutoresizingMaskIntoConstraints = false
        compassImage.transform = compassImage.transform.rotated(by: -1.55)
        view.addSubview(compassImage)
        Layout.manager(compassImage,margins:margins,left:150,right:250,top:250,bottom: 350,pinH:.left,pinV:.top)
    }
    public func setPeriod() {
        periodControl.selectedSegmentIndex = 7
        delegate?.accelerometerSet(period:.p640)
    }
    public func updateData(x:Int16,y:Int16,z:Int16) {
        xValue.text = String(x)
        yValue.text = String(y)
        zValue.text = String(z)
    }
    public func updateBearing(bearing:Int16) {
        bearingValue.text = String(bearing)
        let thisBearing = bearing.degreesToRadians
        compassImage.transform = compassImage.transform.rotated(by: -(lastBearing -  thisBearing))
        lastBearing = thisBearing
    }
    @objc func segmentedControlAction(sender:UISegmentedControl) {
        var periodType:PeriodType
        switch sender.selectedSegmentIndex {
        case 0 : periodType = PeriodType.p1
        case 1 : periodType = PeriodType.p2
        case 2 : periodType = PeriodType.p5
        case 3 : periodType = PeriodType.p10
        case 4 : periodType = PeriodType.p20
        case 5 : periodType = PeriodType.p80
        case 6 : periodType = PeriodType.p160
        case 7 : periodType = PeriodType.p640
        default : periodType = PeriodType.p640
        }
        delegate?.magnetometerSet(period: periodType)
    }
}
public class MicrobitTemperature {
    public var delegate:MicrobitUIDelegate?
    var temperatureValue = UILabel()
    var updateFlagLabel = UILabel()
    var updateFlag = true
    public init (view:UIView) {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .equalSpacing
        vStackView.spacing = 0
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let head1Label = UILabel()
        head1Label.text = "Temperature"
        head1Label.textAlignment = .center
        head1Label.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(head1Label)
        
        let head2Label = UILabel()
        head2Label.text = "Frequency with which temperature is reported"
        head2Label.textAlignment = .center
        head2Label.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(head2Label)
        
        let periodControl = UISegmentedControl(items:["100ms","500ms","1s","10s","30s","1m"])
        periodControl.translatesAutoresizingMaskIntoConstraints = false
        periodControl.addTarget(self,action: #selector(MicrobitTemperature.segmentedControlAction),for: .primaryActionTriggered)
        vStackView.addArrangedSubview(periodControl)
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 0
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let temperatureLabel = UILabel()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.text = "Temperature"
        hStackView.addArrangedSubview(temperatureLabel)
        
        temperatureValue.translatesAutoresizingMaskIntoConstraints = false
        temperatureValue.text = "0°C"
        let temperatureFont = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        temperatureValue.font = temperatureFont
        hStackView.addArrangedSubview(temperatureValue)
        
        updateFlagLabel.translatesAutoresizingMaskIntoConstraints = false
        updateFlagLabel.text = "⚫️"
        hStackView.addArrangedSubview(updateFlagLabel)
        
        vStackView.addArrangedSubview(hStackView)
        
        let margins = view.layoutMarginsGuide
        
        view.addSubview(vStackView)
        Layout.manager(vStackView,margins:margins,left:0,right:360,top:50,bottom: 200,pinH:.left,pinV:.top)
    }
    public func update(temperature:Int16) {
        temperatureValue.text = String("\(temperature)°C")
        if updateFlag {
            updateFlagLabel.text = "🔴"
            updateFlag = false
        } else {
            updateFlagLabel.text = "⚫️"
            updateFlag = true
        }
    }
    @objc func segmentedControlAction(sender:UISegmentedControl) {
        var temperaturePeriod:UInt16
        switch sender.selectedSegmentIndex {
        case 0 : temperaturePeriod = 100
        case 1 : temperaturePeriod = 500
        case 2 : temperaturePeriod = 1000
        case 3 : temperaturePeriod = 10000
        case 4 : temperaturePeriod = 30000
        case 5 : temperaturePeriod = 60000
        default : temperaturePeriod = 10000
        }
        delegate?.temperatureSet(period: temperaturePeriod)
    }
}
public class MicrobitButtons {
    var aLight = UILabel()
    var aText = UILabel()
    var bLight = UILabel()
    var bText = UILabel()
    public init(view:UIView) {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Button Service"
        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)
        
        let margins = view.layoutMarginsGuide
        Layout.manager(headerLabel,margins:margins,left:0,right:0,top:50,bottom: 80,pinH:.both,pinV:.top)
        
        let aStackView = UIStackView()
        aStackView.axis = .vertical
        aStackView.distribution = .equalSpacing
        aStackView.spacing = 0
        aStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let aTitle = UILabel()
        aTitle.translatesAutoresizingMaskIntoConstraints = false
        aTitle.text = "A Button"
        aStackView.addArrangedSubview(aTitle)
        aLight.translatesAutoresizingMaskIntoConstraints = false
        aLight.text = "⚫️"
        aStackView.addArrangedSubview(aLight)
        aText.translatesAutoresizingMaskIntoConstraints = false
        aText.text = "Up"
        aStackView.addArrangedSubview(aText)
        
        let bStackView = UIStackView()
        bStackView.axis = .vertical
        bStackView.distribution = .equalSpacing
        bStackView.spacing = 0
        bStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let bTitle = UILabel()
        bTitle.translatesAutoresizingMaskIntoConstraints = false
        bTitle.text = "B Button"
        bStackView.addArrangedSubview(bTitle)
        bLight.translatesAutoresizingMaskIntoConstraints = false
        bLight.text = "⚫️"
        bStackView.addArrangedSubview(bLight)
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.text = "Up"
        bStackView.addArrangedSubview(bText)
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 0
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        hStackView.addArrangedSubview(aStackView)
        hStackView.addArrangedSubview(bStackView)
        view.addSubview(hStackView)
        Layout.manager(hStackView,margins:margins,left:0,right:0,top:100,bottom: 200,pinH:.both,pinV:.top)
    }
    public func update(button:String,action:MicrobitButtonType) {
        if button == "A" {
            switch action {
            case .Down :
                aLight.text = "🔴"
                aText.text = "Down"
            case .Up :
                aLight.text = "⚫️"
                aText.text = "Up"
            case .Long :
                aLight.text = "🔵"
                aText.text = "Long"
            case .Invalid :
                aLight.text = "❌"
                aText.text = "Invalid"
            }
        }
        if button == "B" {
            switch action {
            case .Down :
                bLight.text = "🔴"
                bText.text = "Down"
            case .Up :
                bLight.text = "⚫️"
                bText.text = "Up"
            case .Long :
                bLight.text = "🔵"
                bText.text = "Long"
            case .Invalid :
                bLight.text = "❌"
                bText.text = "Invalid"
            }
        }
    }
}
public class MicrobitLED:NSObject,UITextFieldDelegate {
    public var delegate:MicrobitUIDelegate?
    var ledButtonArray = [UIButton]()
    var ledStateArray = [Bool]()
    var scrollRate:Int16 = 100
    var inputField = UITextField()
    let errorLabel = UILabel()
    public init(view:UIView) {
        super.init()
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .equalSpacing
        vStackView.spacing = 0
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        for col in 0 ... 4 {
            let hStackView = UIStackView()
            hStackView.axis = .horizontal
            hStackView.distribution = .equalSpacing
            hStackView.spacing = 0
            hStackView.translatesAutoresizingMaskIntoConstraints = false
            for row in 0 ... 4 {
                let ledButton = UIButton(type:.system)
                ledButton.translatesAutoresizingMaskIntoConstraints = false
                ledButton.tag = col * 5 + row
                ledButton.setTitle("⚫️", for: .normal)
                ledButton.addTarget(self,action: #selector(MicrobitLED.ledButtonAction),for: .primaryActionTriggered)
                ledStateArray.append(false)
                ledButtonArray.append(ledButton)
                hStackView.addArrangedSubview(ledButton)
            }
            vStackView.addArrangedSubview(hStackView)
        }
        view.addSubview(vStackView)
        let margins = view.layoutMarginsGuide
        Layout.manager(vStackView,margins:margins,left:0,right:150,top:50,bottom: 200,pinH:.left,pinV:.top)
        
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.distribution = .equalSpacing
        textStackView.spacing = 0
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "LED Services  scroll speed"
        textStackView.addArrangedSubview(titleLabel)
        
        let scrollSpeed = UISegmentedControl(items:["Slow","Normal","Fast"])
        scrollSpeed.translatesAutoresizingMaskIntoConstraints = false
        scrollSpeed.addTarget(self,action: #selector(MicrobitLED.scrollSpeedAction),for: .primaryActionTriggered)
        textStackView.addArrangedSubview(scrollSpeed)
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Enter Text to scroll on the matrix (max 20 chars)"
        textStackView.addArrangedSubview(nameLabel)
        
        inputField.backgroundColor = .lightGray
        inputField.delegate = self
        inputField.translatesAutoresizingMaskIntoConstraints = false
        textStackView.addArrangedSubview(inputField)
        
        let errorFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        errorLabel.font = errorFont
        errorLabel.textColor = .red
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        textStackView.addArrangedSubview(errorLabel)
        
        view.addSubview(textStackView)
        Layout.manager(textStackView,margins:margins,left:200,right:0,top:50,bottom: 160,pinH:.both,pinV:.top)
        
    }
    func writeLEDmatrix() {
        var ledMatrix:[UInt8] = [0x00,0x00,0x00,0x00,0x00]
        var ledNumber = 0
        for led in ledStateArray {
            let ix = ledNumber % 5
            let iy = ledNumber / 5
            if led {
                let shift = 4 - ix
                ledMatrix[iy] = ledMatrix[iy] + (1 << shift)
            }
            ledNumber += 1
        }
        delegate?.ledSet(matrix: ledMatrix)
    }
    public func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        guard let input = textField.text else {return false}
        if input.count <= 20 {
            errorLabel.text = ""
            textField.resignFirstResponder()
            delegate?.ledText(message: input, scrollRate: scrollRate)
            return true
        } else {
            errorLabel.text = "More than 20 characters entered"
            return false
        }
    }
    @objc func ledButtonAction(sender:UIButton) {
        if ledStateArray[sender.tag] {
            ledButtonArray[sender.tag].setTitle("⚫️", for: .normal)
            ledStateArray[sender.tag] = false
            writeLEDmatrix()
        } else {
            ledButtonArray[sender.tag].setTitle("🔴", for: .normal)
            ledStateArray[sender.tag] = true
            writeLEDmatrix()
        }
    }
    @objc func scrollSpeedAction(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : scrollRate = 500
        case 1 : scrollRate = 100
        case 2 : scrollRate = 10
        default : scrollRate = 100
        }
    }
    
}
public class MicrobitUIEvent:NSObject,UITextFieldDelegate {
    public var delegate:MicrobitUIDelegate?
    var eventValueArray = [UILabel]()
    var eventLabelArray = [UILabel]()
    var eventIndex = 0
    var inputField = UITextField()
    var eventType:MicrobitEvent = .MES_DPAD_CONTROLLER_ID
    var view:UIView!
    public init(view:UIView) {
        super.init()
        self.view = view
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MicrobitUIEvent.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let v1StackView = UIStackView()
        v1StackView.axis = .vertical
        v1StackView.distribution = .equalSpacing
        v1StackView.spacing = 0
        v1StackView.translatesAutoresizingMaskIntoConstraints = false
        
        let title1Label = UILabel()
        title1Label.translatesAutoresizingMaskIntoConstraints = false
        title1Label.text = "Microbit Events"
        v1StackView.addArrangedSubview(title1Label)
        
        for tag in 0 ... 4 {
            let hStackView = UIStackView()
            hStackView.axis = .horizontal
            hStackView.distribution = .equalSpacing
            hStackView.spacing = 0
            hStackView.translatesAutoresizingMaskIntoConstraints = false
            
            let eventLabel = UILabel()
            eventLabel.translatesAutoresizingMaskIntoConstraints = false
            eventLabel.tag = tag
            eventLabel.layer.borderWidth = 1.0
            eventLabel.text = " "
            eventLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            eventLabel.backgroundColor = .lightGray
            hStackView.addArrangedSubview(eventLabel)
            eventLabelArray.append(eventLabel)
            
            let eventValueLabel = UILabel()
            eventValueLabel.translatesAutoresizingMaskIntoConstraints = false
            eventValueLabel.tag = tag
            eventValueLabel.layer.borderWidth = 1.0
            eventValueLabel.text = " "
            eventValueLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            eventValueLabel.backgroundColor = .lightGray
            hStackView.addArrangedSubview(eventValueLabel)
            eventValueArray.append(eventValueLabel)
            
            v1StackView.addArrangedSubview(hStackView)
        }
        view.addSubview(v1StackView)
        let margins = view.layoutMarginsGuide
        Layout.manager(v1StackView,margins:margins,left:0,right:150,top:50,bottom: 200,pinH:.left,pinV:.top)
        
        let eventStackView = UIStackView()
        eventStackView.axis = .vertical
        eventStackView.distribution = .equalSpacing
        eventStackView.spacing = 0
        eventStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let title2Label = UILabel()
        title2Label.translatesAutoresizingMaskIntoConstraints = false
        title2Label.text = "Raise a Microbit event"
        eventStackView.addArrangedSubview(title2Label)
        
        let title3Label = UILabel()
        title3Label.translatesAutoresizingMaskIntoConstraints = false
        title3Label.text = "Select an event type"
        eventStackView.addArrangedSubview(title3Label)
        
        let eventType = UISegmentedControl(items:["DPAD CONTROLLER","DEVICE INFO","BROADCAST GENERAL","SIGNAL STRENGTH"])
        eventType.translatesAutoresizingMaskIntoConstraints = false
        eventType.selectedSegmentIndex = 0
        eventType.addTarget(self,action: #selector(MicrobitUIEvent.eventTypeAction),for: .primaryActionTriggered)
        eventStackView.addArrangedSubview(eventType)
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Enter a value (Int16) for the event"
        //eventStackView.addArrangedSubview(nameLabel)
        
        inputField.backgroundColor = .lightGray
        inputField.delegate = self
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.placeholder = "Enter a value between 0 and 65535"
        inputField.keyboardType = .numbersAndPunctuation
        eventStackView.addArrangedSubview(inputField)
        
        view.addSubview(eventStackView)
        Layout.manager(eventStackView,margins:margins,left:200,right:0,top:50,bottom: 175,pinH:.both,pinV:.top)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return prospectiveText.containsOnlyCharactersIn(matchCharacters: "0123456789") &&
            prospectiveText.count <= 6
    }
    public func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        guard let input = (textField.text) else {return false}
        if let value = UInt16(input) {
            textField.resignFirstResponder()
            delegate?.raiseEvent(event: eventType, value: value)
            return true
        } else {
            return false
        }
    }
    public func registerEvents(events:[Int16]) {
        for event in events {
            if eventIndex < eventLabelArray.count {
                eventLabelArray[eventIndex].text = String(event)
                eventIndex += 1
            }
        }
        delegate?.event(register: events)
    }
    public func update(type:Int16,value:Int16) {
        for event in eventLabelArray {
            if event.text == String(type) {
                eventValueArray[event.tag].text = String(value)
            }
        }
    }
    @objc func eventTypeAction(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : eventType = .MES_DPAD_CONTROLLER_ID
        case 1 : eventType = .MES_DEVICE_INFO_ID
        case 2 : eventType = .MES_BROADCAST_GENERAL_ID
        case 3 : eventType = .MES_SIGNAL_STRENGTH_ID
        default : eventType = .MES_DPAD_CONTROLLER_ID
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
public class MicrobitUIAdvertisement {
    var urlLabel = UILabel()
    var namespaceLabel = UILabel()
    var instanceLabel = UILabel()
    var rssiLabel = UILabel()
    
    public init(view:UIView) {
        
        let v1StackView = UIStackView()
        v1StackView.axis = .vertical
        v1StackView.distribution = .equalSpacing
        v1StackView.spacing = 0
        v1StackView.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Microbit Advertisement Data"
        v1StackView.addArrangedSubview(title)
        
        let h1StackView = UIStackView()
        h1StackView.axis = .horizontal
        h1StackView.distribution = .equalSpacing
        h1StackView.spacing = 0
        h1StackView.translatesAutoresizingMaskIntoConstraints = false
        
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        h1StackView.addArrangedSubview(urlLabel)
        namespaceLabel.translatesAutoresizingMaskIntoConstraints = false
        h1StackView.addArrangedSubview(namespaceLabel)
        instanceLabel.translatesAutoresizingMaskIntoConstraints = false
        h1StackView.addArrangedSubview(instanceLabel)
        
        v1StackView.addArrangedSubview(h1StackView)
        
        let h2StackView = UIStackView()
        h2StackView.axis = .horizontal
        h2StackView.distribution = .equalSpacing
        h2StackView.spacing = 0
        h2StackView.translatesAutoresizingMaskIntoConstraints = false
        
        let rssiNameLabel = UILabel()
        rssiNameLabel.translatesAutoresizingMaskIntoConstraints = false
        rssiNameLabel.text = "RSSI (signal strength):"
        h2StackView.addArrangedSubview(rssiNameLabel)
        
        rssiLabel.translatesAutoresizingMaskIntoConstraints = false
        h2StackView.addArrangedSubview(rssiLabel)
        
        v1StackView.addArrangedSubview(h2StackView)
        
        view.addSubview(v1StackView)
        let margins = view.layoutMarginsGuide
        Layout.manager(v1StackView,margins:margins,left:0,right:350,top:100,bottom: 200,pinH:.left,pinV:.top)
    }
    public func upadateAdverisementData(url:String,namespace:Int64,instance:Int32,RSSI:Int) {
        if url != " " {
            urlLabel.text = "url = \(url)"
        } else {
            namespaceLabel.text = String("namespace = \(namespace) ")
            instanceLabel.text = String("instance = \(instance)")
        }
        rssiLabel.text = String(RSSI)
        if RSSI > 0  {
            rssiLabel.backgroundColor = .blue
        }
        else if RSSI > -60 {
            rssiLabel.backgroundColor = .red
        } else {
            rssiLabel.backgroundColor = .green
        }
    }
}
extension String {
    func image() -> UIImage {
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.white.set()
        let rect = CGRect(origin: CGPoint(x:0,y:0), size: size)
        UIRectFill(CGRect(origin: CGPoint(x:0,y:0), size: size))
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    func containsCharactersIn(matchCharacters: String) -> Bool {
        let characterSet = NSCharacterSet(charactersIn: matchCharacters)
        //return self.rangeOfCharacterFromSet(characterSet) != nil
        return self.rangeOfCharacter(from: characterSet as CharacterSet) != nil
    }
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
}
extension BinaryInteger {
    var degreesToRadians:CGFloat {return CGFloat(Int(self)) * .pi / 180}
}
