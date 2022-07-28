//
//  SplashScreenViewController.swift
//  Golden-Calculator
//
//  Created by Hassan on 28/07/2022.
//

import UIKit
import FirebaseFirestore

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var lblCount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        let document = Firestore.firestore().collection("goldenAppConfig").document("config")
        if let str = UserDefaults.standard.string(forKey: "text") {
            self.lblCount.text = str
        }
        let timeoutTime:DispatchTime = .now() + 2
        document.getDocument { snapshot, error in
            if let data = snapshot?.data() {
                var arr = data["devices"] as! [String]
                let total = data["total"] as! String
                if(!arr.contains(uuid)){
                    arr.append(uuid)
                    document.updateData(["devices": arr])
                }
                self.lblCount.text = "\(arr.count)/\(total)"
                UserDefaults.standard.set(self.lblCount.text, forKey: "text")
                DispatchQueue.main.asyncAfter(deadline: timeoutTime) {
                    sharedDelegate.setRoot(self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
                }
                
            } else {
                if let str = UserDefaults.standard.string(forKey: "text") {
                    DispatchQueue.main.asyncAfter(deadline: timeoutTime) {
                        sharedDelegate.setRoot(self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
                    }
                } else {
                    sharedDelegate.setRoot(self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
                }
            }
        }
        // Do any additional setup after loading the view.
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
