//: A UIKit based Playground for presenting user interface test
  
import PlaygroundSupport

let vc = MicrobitUIController()
vc.microbit = Microbit("BBC micro:bit [tizip]")
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = vc
