//
//  LiveCaptureController.swift
//  Golden-Calculator
//
//  Created by Hassan on 27/07/2022.
//

import UIKit
import ARKit
import Foundation

class LiveCaptureController: UIViewController {
    @IBOutlet weak private var previewView: UIView!
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    var rootLayer: CALayer! = nil
    var bufferSize: CGSize = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting up the capturesession etc.
        //...
//
//        // Define layer
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//
//        // Add layer to hierarchy
//        rootLayer = previewView.layer
//        previewLayer.frame = rootLayer.bounds
//        rootLayer.addSublayer(previewLayer)
//
//        // Get dimensions of preview
//        let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
//        bufferSize.width = CGFloat(dimensions.height)
//        bufferSize.height = CGFloat(dimensions.width)
    }
 }
