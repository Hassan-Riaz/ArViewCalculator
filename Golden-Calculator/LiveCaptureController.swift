//
//  LiveCaptureController.swift
//  Golden-Calculator
//
//  Created by Hassan on 27/07/2022.
//

import UIKit
//import ARKit
//import Vision
import Foundation

class LiveCaptureController: UIViewController {//.AVCaptureVideoDataOutputSampleBufferDelegate {
    
//    @IBOutlet weak private var previewView: UIView!
//   private var previewLayer: AVCaptureVideoPreviewLayer! = nil
//   var rootLayer: CALayer! = nil
//   var bufferSize: CGSize = .zero
//    @IBOutlet weak var cntPreview: UIView!
//    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Define layer
//       previewLayer = AVCaptureVideoPreviewLayer(session: session)
//
//       // Add layer to hierarchy
////        rootLayer = previewView.layer // Assign the previewView’s layer to rootLayer
//       rootLayer = previewView.layer
//       previewLayer.frame = rootLayer.bounds
//       rootLayer.addSublayer(previewLayer)
//
//       // Get dimensions of preview
//       let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
//       bufferSize.width = CGFloat(dimensions.height)
//       bufferSize.height = CGFloat(dimensions.width)
        
//        let captureSession = AVCaptureSession()
//        captureSession.sessionPreset = .photo
//        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
//        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
//        captureSession.addInput(input)
//        captureSession.startRunning()
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        self.view.layer.addSublayer(previewLayer)
//        previewLayer.frame = self.view.frame
//
//        let dataOutput = AVCaptureVideoDataOutput()
//        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        captureSession.addOutput(dataOutput)
        
//        var request = VNCoreMLRequest(model: <#T##VNCoreMLModel#>)
//        VNImageRequestHandler(cgImage: <#T##CGImage#>, options: <#T##[VNImageOption : Any]#>).perform(<#T##[VNRequest]#>)
    }
    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("frmae captured", Date())
//        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
//
////        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else { return }
//        guard let model = try? VNCoreMLModel(for: SqueezeNet(configuration: MLModelConfiguration()).model) else { return }
//        var request = VNCoreMLRequest(model: model) { response, error in
////            print(response.results)
//            guard let results = response.results as? [VNClassificationObservation] else { return }
//            guard let observe = results.first else { return }
//            print(observe.identifier, observe.confidence)
////            observe.confidence
////            self.lblName.text = observe.identifier
//
//        }
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//    }
 }
