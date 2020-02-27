//
//  main.swift
//  HanDoeLuPro
//
//  Created by khczhihao on 2020/2/25.
//  Copyright © 2020 zhihao. All rights reserved.
//

import SocketIO
import AppKit
import Foundation

struct Point {
    var x: Float
    var y: Float
}

func getMouseLocation() -> Point {
    var mouseLoc = NSEvent.mouseLocation
        mouseLoc.y = NSHeight(NSScreen.screens[0].frame) - mouseLoc.y;
    return Point(
        x: Float(mouseLoc.x),
        y: Float(mouseLoc.y)
    )
}

func mouseMoveEvent(x: Float, y: Float) -> CGPoint {
    let point = CGPoint(x: CGFloat(x),y :CGFloat(y))
    let mouseMove = CGEvent(
        mouseEventSource: nil,
        mouseType: CGEventType.mouseMoved,
        mouseCursorPosition: point,
        mouseButton: CGMouseButton.left
    )
    mouseMove?.post(
        tap: CGEventTapLocation.cghidEventTap
    )
    return point
}

func mouseMove(x: Float, y: Float) {
        let mouseLoc = getMouseLocation()
        CGDisplayMoveCursorToPoint(0, mouseMoveEvent(
            x: mouseLoc.x + x,
            y: mouseLoc.y + y
        ))
}

func mouseTo(x: Float, y: Float) {
    CGDisplayMoveCursorToPoint(0, mouseMoveEvent(x: x, y: y))
}

func mouseKeyDown(type: String) {
    var mouseType = CGEventType.leftMouseDown
    var mouseButton = CGMouseButton.left
    if (type == "right") {
        mouseType = CGEventType.rightMouseDown
        mouseButton = CGMouseButton.right
    }
    let mouseLoc = getMouseLocation()
    let point = CGPoint(x: CGFloat(mouseLoc.x),y :CGFloat(mouseLoc.y))
    let mouseDown = CGEvent(
        mouseEventSource: CGEventSource(stateID: CGEventSourceStateID.hidSystemState),
        mouseType: mouseType,
        mouseCursorPosition: point,
        mouseButton: mouseButton
    )
    mouseDown?.post(tap: .cghidEventTap)
}

func mouseKeyUp(type: String) {
    var mouseType = CGEventType.leftMouseUp
    var mouseButton = CGMouseButton.left
    if (type == "right") {
        mouseType = CGEventType.rightMouseUp
        mouseButton = CGMouseButton.right
    }
    let mouseLoc = getMouseLocation()
    let point = CGPoint(x: CGFloat(mouseLoc.x),y :CGFloat(mouseLoc.y))
    let mouseUp = CGEvent(
        mouseEventSource: CGEventSource(stateID: CGEventSourceStateID.hidSystemState),
        mouseType: mouseType,
        mouseCursorPosition: point,
        mouseButton: mouseButton
    )
    mouseUp?.post(tap: .cghidEventTap)
}

func scrollWheel(x: Int, y: Int) {
    let scrollEvent = CGEvent(
        scrollWheelEvent2Source: CGEventSource(stateID: CGEventSourceStateID.hidSystemState),
        units: CGScrollEventUnit.pixel,
        wheelCount: 1,
        wheel1: Int32(y),
        wheel2: Int32(x),
        wheel3: 0
    )
    scrollEvent?.setIntegerValueField(CGEventField.eventSourceUserData, value: 1)
    scrollEvent?.post(tap: .cghidEventTap)
}

func keyIn(key: CGKeyCode) {
    let source = CGEventSource(
        stateID: CGEventSourceStateID.hidSystemState
    )
    let event = CGEvent(
        keyboardEventSource: source,
        virtualKey: key,
        keyDown: true
    )
    event?.post(tap: CGEventTapLocation.cghidEventTap)
}

func keyUp(key: CGKeyCode) {
    let source = CGEventSource(
        stateID: CGEventSourceStateID.hidSystemState
    )
    let event = CGEvent(
        keyboardEventSource: source,
        virtualKey: key,
        keyDown: false
    )
    event?.post(tap: CGEventTapLocation.cghidEventTap)
}

var host = "http://localhost:8080/"
if (CommandLine.arguments.count > 1) {
    host = CommandLine.arguments[1]
}

print("連線至：" + host)

let manager = SocketManager(
    socketURL: URL(
        string: host
    )!,
    config: [
        .log(true),
        .compress,
        .forceWebsockets(true)
    ]
)

let socket = manager.defaultSocket

func start() {
    socket.on(clientEvent: .connect) {data, ack in
        socket.emit("macos", """
            從https://gist.github.com/eegrok/949034參照鍵盤對照表\n
            KeyDown(Int)\n
            KeyUp(Int)\n
            MouseTo(Float, Float)\n
            MouseMove(Float, Float)\n
            ScrollWheel(Int, Int)\n
            MouseKeyDown(String<left | right>)\n
            MouseKeyUp(String<left | right>)\n
        """)
    }
    socket.on("KeyDown") {data, ack in
        let key = data[0] as! UInt16
        keyIn(key: CGKeyCode(key))
    }
    socket.on("KeyUp") {data, ack in
        let key = data[0] as! UInt16
        keyUp(key: CGKeyCode(key))
    }
    socket.on("MouseTo") {data, ack in
        let x = data[0] as! Float
        let y = data[1] as! Float
        mouseTo(x: x, y: y)
    }
    socket.on("MouseMove") {data, ack in
        let x = data[0] as! Float
        let y = data[1] as! Float
        mouseMove(x: x, y: y)
    }
    socket.on("ScrollWheel") {data, ack in
        let x = data[0] as! Int
        let y = data[1] as! Int
        scrollWheel(x: x, y: y)
    }
    socket.on("MouseKeyDown") {data, ack in
        let type = data[0] as! String
        mouseKeyDown(type: type)
    }
    socket.on("MouseKeyUp") {data, ack in
        let type = data[0] as! String
        mouseKeyUp(type: type)
    }
    socket.connect()
}

start()
CFRunLoopRun()
