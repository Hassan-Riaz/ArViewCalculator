//
//  SplashScreenViewController.swift
//  Golden-Calculator
//
//  Created by Hassan on 28/07/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblUUID: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var lblDownloadPosition: UILabel!
    
    
    func setPosition(position: Int, total: Int) {
        if position == 0 || total == 0 {
            return
        }
        lblDownloadPosition.isHidden = false
        var positionStr = "st"
        switch position % 10 {
        case 1:
            positionStr = "st"
            break
        case 2:
            positionStr = "nd"
            break
        case 3:
            positionStr = "rd"
            break
        default:
            positionStr = "th"
            break
        }
        self.lblDownloadPosition.text = "This is the \(position)\(positionStr) of \(total) downloads"
    }
    
    //Depreciated:
    func legacyCodeToSupportV1(devices: [String], uuid: String) {
        if !devices.contains(uuid) {
            var arr = devices
            arr.append(uuid)
            let collection = Firestore.firestore().collection("goldenAppConfig").document("config").updateData([
                "devices": arr
            ])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if let deviceUUid = UIDevice.current.identifierForVendor?.uuidString {
        var uuid: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
        lblUUID.text = uuid
        lblDownloadPosition.isHidden = true
        let isFirst = UserDefaults.standard.isRelaunching
        let createdAt = Date().toString(format: "MMMM dd, yyyy hh:mm a")
        if !isFirst {
            UserDefaults.standard.set(createdAt, forKey: "createdAt")
            self.lblTimeStamp.text = "Downloaded on " + createdAt
        } else {
            let date = UserDefaults.standard.string(forKey: "createdAt") ?? createdAt
            self.lblTimeStamp.text = "Downloaded on " + date
            let position = UserDefaults.standard.downloadPosition
            let totalDownloads = UserDefaults.standard.totalDownloads
            var count = totalDownloads
            self.setPosition(position: position, total: count)
            var  limit = UserDefaults.standard.limit
            if totalDownloads != 0 {
                self.lblCount.text = "\(totalDownloads)/\(limit)"
            }
        }
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else {
                self.moveToNext()
                return
            }
            UserDefaults.standard.isRelaunching = true
            let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
            if uuid.isEmpty {
                uuid = uid
            }
            
            let collection = Firestore.firestore().collection("goldenAppConfig")
            let userCollection = Firestore.firestore().collection("goldUsers")
            let configDocument = collection.document("config")
            let timeoutTime:DispatchTime = .now() + 2
            configDocument.getDocument { snapshot, error in
                if let data = snapshot?.data() {
                    let variationFactor = data["variationFactor"] as! Int
                    let currentCount = data["currentCount"] as! Int
                    let total = data["total"] as! String
                    let arr = data["devices"] as! [String]
                    self.legacyCodeToSupportV1(devices: arr, uuid: uuid)
                    self.lblCount.text = "\(currentCount + variationFactor)/\(total)"
                    userCollection.document(uid).getDocument { userSnapshot, error in
                        
                        if let userSnapshot = userSnapshot, userSnapshot.exists, let data = userSnapshot.data()  {
                            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                            let position = data["position"] as! Int
                            UserDefaults.standard.downloadPosition = position + variationFactor
                            self.setPosition(position: position + variationFactor, total: currentCount + variationFactor)
                            userCollection.document(uid).updateData(["lastSignInAt": Date(),
                                                                     "appVersion": appVersion])
                            UserDefaults.standard.totalDownloads = currentCount + variationFactor
                        } else {
                            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                            let newCount = currentCount + 1
                            userCollection.document(uid).setData([
                                "createdAt": Date(),
                                "lastSignInAt": Date(),
                                "uuid": uuid,
                                "position": newCount,
                                "appVersion": appVersion
                            ])
                            configDocument.updateData([
                                "currentCount": newCount
                            ])
                            UserDefaults.standard.downloadPosition = newCount + variationFactor
                            self.setPosition(position: newCount + variationFactor, total: newCount + variationFactor)
                            self.lblCount.text = "\(newCount + variationFactor)/\(total)"
                            UserDefaults.standard.totalDownloads =  newCount + variationFactor
                        }
                    }
                    UserDefaults.standard.limit = total
                    DispatchQueue.main.asyncAfter(deadline: timeoutTime) {
                        self.moveToNext()
                    }
                    
                } else {
                    if UserDefaults.standard.totalDownloads != 0 {
                        DispatchQueue.main.asyncAfter(deadline: timeoutTime) {
                            self.moveToNext()
                        }
                    } else {
                        self.moveToNext()
                    }
                }
            }
            
        }
    }
    
    func moveToNext() {
        sharedDelegate.setRoot(self.storyboard?.instantiateViewController(withIdentifier: "OViewController") as! OViewController)
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


extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        
        return localDate
    }
    
    func toString(format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}
