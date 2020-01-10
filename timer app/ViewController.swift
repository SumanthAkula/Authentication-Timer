//
//  ViewController.swift
//  Authentication Timer
//
//  Created by Sumo Akula on 12/19/19.
//  Copyright © 2019 Sumo Akula. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let device = UIDevice.modelName
        print(device)
    }
    
    var timeTaken: Double?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBAction func buttonPressed(_ sender: Any) {
        authenticateUser()
    }
    
    func updateLabel(message: String = "") {
        if let time = timeTaken {
            label.text = String(time) + " seconds"
        }
    }
    
    func authenticateUser() {
        
        label.text = "timer started"
        let startTime = DispatchTime.now()
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to measure the time"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        let endTime = DispatchTime.now()
                        let timeDiffNanoSeconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                        let timeDifference = Double(timeDiffNanoSeconds) / 1_000_000_000
                        print(timeDifference)
                        self.timeTaken = timeDifference
                        self.updateLabel()
                    } else {
                        self.label.text = "Something went wrong. Please try again"
                        let ac = UIAlertController(title: "Authentication failed", message: "Try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: false)
                    }
                }
            }
        } else {
            self.label.text = "Something went wrong. Please try again"
            let ac = UIAlertController(title: "Biometrics not available", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
