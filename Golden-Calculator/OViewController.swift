//
//  OViewController.swift
//  Silver-Calculator
//
//  Created by Hassan on 24/08/2022.
//

import Foundation
import UIKit
import SceneKit
import ARKit


class OViewController: UIViewController {


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
    var isCameraAuthorized: Bool = true
    enum ConverstionUnit: Int, CaseIterable {
        case cm =  0
        case inches = 1
        case meter = 2
        
        func getLabel(value: CGFloat) -> String {
            //        self.lblMeasurement.text = "\() inches"
            return String(format: "%.1f", self.getMeasurement(inches: value)) + self.unit
        }
        
        func getMeasurement(inches: CGFloat) -> CGFloat {
            switch self {
            case .cm:
                return inches * 2.54
            case .meter:
                return inches * 0.0254
            default:
                return inches
            }
        }
        
        var unit: String {
            switch self {
            case .inches:
                return " inches"
            case .cm:
                return " cm"
            case .meter:
                return " meter"
            }
        }
        
        func next() -> ConverstionUnit {
            let value = self.rawValue + 1
            let result = value % ConverstionUnit.allCases.count
            return ConverstionUnit(rawValue: result) ?? .cm
        }
    }
    var selectedUnit = ConverstionUnit.cm {
        didSet {
            setMeasurement(mesaurement: mesaurement, unit: selectedUnit)
        }
    }
    
    
    func setMeasurement(mesaurement: CGFloat, unit: ConverstionUnit){
        lblMeasurement.text = unit.getLabel(value: mesaurement)
    }
    
    var mesaurement: CGFloat = 0 {
        didSet {
            setMeasurement(mesaurement: mesaurement, unit: selectedUnit)
        }
    }
        
    
    //arview
    @IBOutlet weak var lblMeasurement: UILabel!
    @IBOutlet weak var arView: ARSCNView!
    
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        handleCameraPermissison()
        self.adopter = ARRulerAdoptor(sceneView: arView, delegate: self)
        isCameraAuthorized = true
        cntAutorizeView.isHidden = true
        dataManager.delegate = self
        lblMeasurement.text = "To measure, Tap on the edges of an object"
//        self.lblMeasurement.isHidden = true
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
    
    @IBAction func actConverUnit(_ sender: UIButton) {
        selectedUnit = selectedUnit.next()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.adopter.pauseSession()
    }
    
    func handleCameraPermissison() {
//        checkCameraAuthorized()
        AVCaptureDevice.requestAccess(for: .video) { result in
            DispatchQueue.main.async {
                self.isCameraAuthorized = result
                self.cntAutorizeView.isHidden = result
            }
        }
    }
    
//    func checkCameraAuthorized() -> Bool {
//        AVCaptureDevice.requestAccess(for: .video) { result in
//            self.isCameraAuthorized = result
//        }
////        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
        

}

//MARK:- View Actions
extension OViewController: DataManagerDelegate {
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

extension OViewController: ArRulerOutput {
    func onReadMeasurement(measurement: CGFloat) {
        self.lblMeasurement.isHidden = false
        self.mesaurement = measurement
    }
}
