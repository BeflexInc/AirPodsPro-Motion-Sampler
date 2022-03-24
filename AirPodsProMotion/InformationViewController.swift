//
//  ViewController.swift
//  AirPodsProMotion
//
//  Created by Yoshio on 2020/09/22.
//

import UIKit
import CoreMotion
import CoreLocation

class InformationViewController: UIViewController, CMHeadphoneMotionManagerDelegate, CLLocationManagerDelegate {

    lazy var textView: UITextView = {
        let view = UITextView()
        view.frame = CGRect(x: self.view.bounds.minX + (self.view.bounds.width / 10),
                            y: self.view.bounds.minY + (self.view.bounds.height / 6),
                            width: self.view.bounds.width, height: self.view.bounds.height)
        view.text = "Looking for AirPods Pro"
        view.font = view.font?.withSize(14)
        view.isEditable = false
        return view
    }()
    
    
    let cmManager = CMHeadphoneMotionManager()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Information View"
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        
        var prevTime : Date = Date()
        
        cmManager.delegate = self
        locationManager.delegate = self
        
        guard cmManager.isDeviceMotionAvailable else {
            self.Alert("Sorry", "Your device is not supported.")
            textView.text = "Sorry, Your device is not supported."
            return
        }
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        
        cmManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error  in
            guard let motion = motion, error == nil else { return }
            print(String(Int((prevTime.timeIntervalSinceNow.truncatingRemainder(dividingBy: 1)) * 1000)) + "ms")
            prevTime = Date()
            self?.printData(motion)
        })
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cmManager.stopDeviceMotionUpdates()
    }
    
    
    func printData(_ data: CMDeviceMotion) {
//        print(data)
        self.textView.text = """
            Acceleration:
                x: \(data.userAcceleration.x)
                y: \(data.userAcceleration.y)
                z: \(data.userAcceleration.z)
            Heading:
                \(data.heading)
            """
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Location updated")
//    }
}
