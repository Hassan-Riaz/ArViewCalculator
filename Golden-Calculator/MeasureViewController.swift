//
//  MeasureViewController.swift
//  Golden-Calculator
//
//  Created by Hassan on 30/07/2022.
//

import UIKit
import SceneKit
import ARKit

extension SCNGeometry {
//    class func line(from vector1: SCNVector3, to vector2: SCNVector3) -> SCNGeometry {
////        let indices: [Int32] = [0, 1]
////        let source = SCNGeometrySource(vertices: [vector1, vector2])
////        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
////        element.pointSize = 10
////        CGRect(
////        SCNShape(path: UIBezierPath(cgPath: CGPath(), extrusionDepth: <#T##CGFloat#>)
////        let shape = SCNShape(sources: [source], elements: [element])
////        shape.path?.bounds.width = 1
//        return CylinderLine(parent: sceneView!.scene.rootNode,
//                            v1: nodeA.position,
//                            v2: nodeB.position,
//                            radius: 0.001,
//                            radSegmentCount: 16,
//                            color: UIColor.white)
////        return SCNShape(sources: [source], elements: [element])
////        return SCNGeometry(sources: [source], elements: [element])
//    }
}

class MeasureViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var dotNodes  = [SCNNode]()
    var textNode = SCNNode()
    var meterValue: Double?
    var parentCont: ArRulerOutput? {
        self.parent as? ArRulerOutput
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
//        sceneView.device?.supportsFeatureSet(<#T##MTLFeatureSet#>)
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count >= 2 {
            for dot in self.dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTextResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = hitTextResults.first {
                let dotGeometry = SCNSphere(radius: 0.005)
                let material = SCNMaterial()
                material.diffuse.contents = UIColor(named: "OperatorButtonColor")
                dotGeometry.materials = [material]
                
                let dotNode = SCNNode(geometry: dotGeometry)
                dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,hitResult.worldTransform.columns.3.y,hitResult.worldTransform.columns.3.z)
                sceneView.scene.rootNode.addChildNode(dotNode)
                dotNodes.append(dotNode)
                if dotNodes.count >= 2 {
//                    let materialProp = SCNMaterial()
                    let lineNode = CylinderLine(parent: sceneView!.scene.rootNode,
                                        v1: dotNodes[0].position,
                                        v2: dotNodes[1].position,
                                        radius: 0.005,
                                        radSegmentCount: 16,
                                        color: UIColor(named: "OperatorButtonColor")!)
//                    let lineGeometry = SCNGeometry.line(from: dotNodes[0].position, to:  dotNodes[1].position)

//                    lineGeometry.materials = [mat]
//                    let lineNode = SCNNode(geometry: lineGeometry)
                    dotNodes.append(lineNode)
                    sceneView.scene.rootNode.addChildNode(lineNode)
                    calculate()
                }
            }
//            let estimatePlane: ARRaycastQuery.Target = .estimatedPlane
//            let alignment: ARRaycastQuery.TargetAlignment = .any
//            let query: ARRaycastQuery? = sceneView.raycastQuery(from: touchLocation, allowing: estimatePlane, alignment: alignment)
//            if let nonOptQuery: ARRaycastQuery = query {
//                let result: [ARRaycastResult] = sceneView.session.raycast(nonOptQuery)
//                guard let raycast: ARRaycastResult = result.first else { return }
//                addDot(hitResult: raycast)
//            }
        }
    }
    
    
    func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        meterValue = Double(abs(distance))
        let heightMeter = Measurement(value: meterValue ?? 0, unit: UnitLength.meters)
//        let heightInches = heightMeter.converter(to: .inches)
        let heightCentimeter = heightMeter.converted(to: UnitLength.centimeters)
        let value = "\(heightCentimeter)"
        let finalMeasurement = String(value.prefix(6)) + " cm"
        let posStart = start.position
        let posEnd = end.position
        let middle = SCNVector3((posStart.x+posEnd.x)/2.0, (posStart.y+posEnd.y)/2.0+0.002, (posStart.z+posEnd.z)/2.0)
        
        self.parentCont?.onReadMeasurement(measurement: start.distance(to: end))
//        updateText(text: finalMeasurement, atPosition: middle)
        
    }
    
    func updateText(text: String, atPosition position: SCNVector3){
//        textNode.removeFromParentNode()
////        let end = dotNodes[0]
//        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
//        textGeometry.firstMaterial?.diffuse.contents = UIColor(named: "OperatorButtonColor")
//        textNode = SCNNode(geometry: textGeometry)
//        print(position.x, position.y - 0.01,position.z)
//        textNode.setPivot()
//        textNode.position = position
//        textNode.scale = SCNVector3(x: 0.005, y: 0.005, z: 0.005)
//        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SCNNode {
    
    func setUniformScale(_ scale: Float) {
        self.scale = SCNVector3Make(scale, scale, scale)
    }
    
    func renderOnTop() {
        self.renderingOrder = 2
        if let geom = self.geometry {
            for material in geom.materials {
                material.readsFromDepthBuffer = false
            }
        }
        for child in self.childNodes {
            child.renderOnTop()
        }
    }
    
    func setPivot() {
        let minVec = self.boundingBox.min
        let maxVec = self.boundingBox.max
        let bound = SCNVector3Make( maxVec.x - minVec.x, maxVec.y - minVec.y, maxVec.z - minVec.z);
        self.pivot = SCNMatrix4MakeTranslation(bound.x / 2, bound.y, bound.z / 2);
    }
}

 class CylinderLine: SCNNode {
     init( parent: SCNNode, v1: SCNVector3, v2: SCNVector3, radius: CGFloat, radSegmentCount: Int, color: UIColor)
     {
         super.init()
         
         let  height = v1.distance(receiver: v2)
         position = v1
         let nodeV2 = SCNNode()
         nodeV2.position = v2
         parent.addChildNode(nodeV2)
         
         let zAlign = SCNNode()
         zAlign.eulerAngles.x = Float(CGFloat.pi / 2)
         
         let cyl = SCNCylinder(radius: radius, height: CGFloat(height))
         cyl.radialSegmentCount = radSegmentCount
         cyl.firstMaterial?.diffuse.contents = color
         
         let nodeCyl = SCNNode(geometry: cyl )
         nodeCyl.position.y = -height/2
         zAlign.addChildNode(nodeCyl)
         
         addChildNode(zAlign)
         
         constraints = [SCNLookAtConstraint(target: nodeV2)]
     }
     
     init( parent: SCNNode, v1: SCNNode, v2: SCNNode, radius: CGFloat, radSegmentCount: Int, color: UIColor)
     {
         super.init()
         
         let  height = v1.position.distance(receiver: v2.position)
         position = v1.position
//         let nodeV2 = SCNNode()
//         nodeV2.position = v2
//         parent.addChildNode(nodeV2)
         
         let zAlign = SCNNode()
         zAlign.eulerAngles.x = Float(CGFloat.pi / 2)
         
         let cyl = SCNCylinder(radius: radius, height: CGFloat(height))
         cyl.radialSegmentCount = radSegmentCount
         cyl.firstMaterial?.diffuse.contents = color
         
         let nodeCyl = SCNNode(geometry: cyl )
         nodeCyl.position.y = -height/2
         zAlign.addChildNode(nodeCyl)
         
         addChildNode(zAlign)
         
         constraints = [SCNLookAtConstraint(target: v2)]
     }
     
     override init() {
         super.init()
     }
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
     }
 }

 private extension SCNVector3{
     func distance(receiver:SCNVector3) -> Float{
         let xd = receiver.x - self.x
         let yd = receiver.y - self.y
         let zd = receiver.z - self.z
         let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
         
         if (distance < 0){
             return (distance * -1)
         } else {
             return (distance)
         }
     }
 }
