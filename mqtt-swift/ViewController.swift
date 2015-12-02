//
//  ViewController.swift
//  mqtt-swift
//
//  Created by Tomotaka Sakuma on 2015/12/01.
//  Copyright © 2015年 Tomotaka Sakuma. All rights reserved.
//

import UIKit
import Moscapsule
import Starscream

class Foo: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocket) {
        print("connected")
    }
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("disconnected")
    }
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("receive message")
    }
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("receive data")
    }
}

let host = "<mqtt-broker-hostname>"
let port:Int32 = 12470
let mqttTopic = "<topic-name>"
let username = "<username>"
let pw = "<password>"
let clientId = mqttTopic

class ViewController: UIViewController {
    
    var mqttClient: MQTTClient?
    var wsClient: WebSocket?
    
    func setup() {
//        setupWS()
        setupMQTT()
    }
    
    func setupWS() {
        let endpoint = NSURL(string: "ws://" + host + ":" + String(port) + "/")
        self.wsClient = WebSocket(url: endpoint!)
        self.wsClient?.delegate = Foo()
        self.wsClient?.connect()
    }
    
    func setupMQTT() {
        
        // set MQTT Client Configuration
        let mqttConfig = MQTTConfig(clientId: clientId, host: host, port: port, keepAlive: 60)
        mqttConfig.mqttAuthOpts = MQTTAuthOpts(username: username, password: pw)

        //        mqttConfig.onPublishCallback = { messageId in         NSLog("published (mid=\(messageId))")        }
        mqttConfig.onMessageCallback = { mqttMessage in
            NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
        }
        
        // create new MQTT Connection
        mqttClient = MQTT.newConnection(mqttConfig)
        
        // publish and subscribe
        //        mqttClient.publishString("message", topic: mqttTopic, qos: 2, retain: false)
        mqttClient?.subscribe(mqttTopic, qos: 0)
        
        // disconnect
        //        mqttClient.disconnect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

