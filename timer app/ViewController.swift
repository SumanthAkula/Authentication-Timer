//
//  ViewController.swift
//  Authentication Timer
//
//  Created by Sumo Akula on 12/19/19.
//  Copyright © 2019 Sumo Akula. All rights reserved.
//

/**
 # iPhone 8+ times
 0.369606041
 0.355802666
 0.363012708
 0.363784792
 0.375522291
 0.370376458
 0.386249583
 0.398042167
 0.380881125
 0.375942542
 
 # SD -> 0.012338327698155
 # Mean -> 0.3739220373
 
 
 # iPhone X times
 0.494062791
 0.478915208
 0.50864525
 0.522563
 0.542854209
 0.536625084
 0.505555333
 0.535650625
 0.543637542
 0.523170792
 
 # SD -> 0.021884448595831
 # Mean -> 0.5191679834
 */

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
