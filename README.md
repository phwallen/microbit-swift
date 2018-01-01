#  Microbit-Swift
Microbit-Swift is an application programming interface written in Swift for use with the micro:bit computer. It allows programs written for Apple devices to communicate with the micro:bit using Bluetooth Low Energy.

For information about this project and how to use the API see: [Micro:bit Swift Bluetooth LE](https://phwallen.github.io/microbit-swift/)

Microbit.playground.zip demonstrates the use of the API. It can be downloaded to an iPad that has **Swift Playgrounds** installed.

The Microbit directory contains an Xcode project for testing the components of the playground.

The source files for the Playground are:

- Microbit.swift - The API can be used on any platform that supports Core Bluetooth i.e. macOS, iOS, tvOS and watchOS. To use: copy this file into your Xcode project.
- MicrobitUIController.swift - A set of view controllers used by the Playground.
- MicrobitUI - A set of custom views used by the view controllers.