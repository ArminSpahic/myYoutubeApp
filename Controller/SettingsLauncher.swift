//
//  SettingsLauncher.swift
//  myYoutube
//
//  Created by Armin Spahic on 09/11/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name:SettingName, imageName:String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String {
    case Settings = "Settings"
    case Terms = "Terms & privacy policy"
    case Feedback = "Send Feedback"
    case Help = "Help"
    case Switch = "Switch Account"
    case Cancel = "Cancel"
}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var homeController: HomeController?
    
    override init() {
        super.init()
        setupViews()
    }
    
    let settings: [Setting] = {
        return [Setting(name: .Settings, imageName: "settings") , Setting(name: .Terms, imageName: "privacy"), Setting(name: .Feedback, imageName: "feedback"), Setting(name: .Help, imageName: "help"), Setting(name: .Switch, imageName: "switch_account"), Setting(name: .Cancel, imageName: "cancel")]
    }()
    
    let cellId = "cellId"
    let cellHeight = 50
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        let setting = settings[indexPath.item]
        cell.setting = setting
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = settings[indexPath.item]
        dismissView(setting: selectedItem)
    }

    let blackView = UIView()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    @objc func dismissViewForGesture() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
        })
    }
    
    @objc func dismissView(setting: Setting) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }) { (completed: Bool) in
            if setting.name != .Cancel {
                self.homeController?.showControllerForSetting(setting: setting)
            } else {
                
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let setting = self.settings[indexPath.item]
        dismissView(setting: setting)
    }
    
    @objc func showSettings() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewForGesture)))
            
            blackView.alpha = 0
            window.addSubview(blackView)
            window.addSubview(collectionView)
            let height: CGFloat = CGFloat(settings.count * cellHeight)
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            blackView.frame = window.frame
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
            }, completion: nil)
        }
        
        
    }
    
    func setupViews() {
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    


}
