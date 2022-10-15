//
//  ViewController.swift
//  iOS-Calculator
//
//  Created by Daegeon Choi on 2021/01/20.
//

import UIKit
import SceneKit
import ARKit


extension UIButton {
    @IBInspectable var isRounded: Bool {
        get {
            return false
        }
        set {
            if newValue {
                self.layer.cornerRadius = self.bounds.width / 2
            }
        }
    }
}

class ViewController: UIViewController {

    //MARK:- IBOutlets
    
    // result label
    @IBOutlet weak var resultLabel: UILabel!
    
    // function button
    @IBOutlet weak var ACButton: UIButton!
    @IBOutlet weak var posNegButton: UIButton!
    @IBOutlet weak var modulatButton: UIButton!
    
    // operation button
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var addbutton: UIButton!
    @IBOutlet weak var resultbutton: UIButton!
    
    // number button
    @IBOutlet weak var buttonDot: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    
    @IBOutlet weak var cntAutorizeView: UIView!
    
    var dataManager = DataManager()
    var adopter:ARRulerAdoptor!
    var isCameraAuthorized: Bool = true {
        didSet {
            cntAutorizeView.isHidden = isCameraAuthorized
        }
    }
    
    //arview
    @IBOutlet weak var lblMeasurement: UILabel!
    @IBOutlet weak var arView: ARSCNView!
    
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adopter = ARRulerAdoptor(sceneView: arView, delegate: self)
        dataManager.delegate = self
        self.lblMeasurement.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleCameraPermissison()
        if isCameraAuthorized {
            self.adopter.startSession()
        }
    }
    
    func openSetting() {
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsUrl)
    }
    
    @IBAction func btnSetting(_ sender: UIButton) {
        openSetting()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.adopter.pauseSession()
    }
    
    func handleCameraPermissison() {
        isCameraAuthorized = checkCameraAuthorized()
    }
    
    func checkCameraAuthorized() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
        

}

//MARK:- View Actions
extension ViewController: DataManagerDelegate {
    //MARK: IBActions
    @IBAction func numberPressed(_ sender: UIButton) {
        dataManager.proccessNumber(button: sender, labelText: resultLabel.text!)
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        dataManager.processOperator(button: sender)
    }
    
    @IBAction func resultPressed(_ sender: UIButton) {
        dataManager.getResult()
    }

    //MARK: DataManagerDelegate stubs
    func updateView(result: String) {
        resultLabel.text = result
    }
}

extension ViewController: ArRulerOutput {
    func onReadMeasurement(measurement: CGFloat) {
        self.lblMeasurement.isHidden = false
        self.lblMeasurement.text = "\(String(format: "%.1f", measurement)) inches"
    }
}
