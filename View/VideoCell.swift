//
//  VideoCEll.swift
//  myYoutube
//
//  Created by Armin Spahic on 08/11/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.titleString
            setupThumbnailImage()
            setupProfileImage()
            if let channelName = video?.channel?.channelName, let numberOfViews = video?.numberOfViews {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal

                let subtitleText = "\(channelName) - \(numberFormatter.string(from: numberOfViews)!) - 2 years ago"
                subtitleTextView.text = subtitleText
            }
            
            //measure title text
            if let title = video?.titleString {
                let size = CGSize(width: frame.width - 12 - 44 - 8 - 12, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
    }
    
    func setupProfileImage() {
        if let profileImageName = video?.channel?.profileImageName {
            iconImageView.loadImageUsingUrlString(urlString: profileImageName)
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageName = video?.thumbnailImageName {
            imageView.loadImageUsingUrlString(urlString: thumbnailImageName)
        }
    }
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return line
    }()
    
    let iconImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.backgroundColor = UIColor.green
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "taylor_swift_profile")
        iv.layer.cornerRadius = 22
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let imageView: CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let subtitleTextView: UITextView = {
       let textView = UITextView()
        textView.text = "TaylorSwiftVEVO - 1,604,607 views - 2 years"
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = UIColor.lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        
        addSubview(imageView)
        addSubview(iconImageView)
        addSubview(separatorLine)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: imageView)
        addConstraintsWithFormat(format: "V:|-12-[v0]-8-[v1(44)]-36-[v2(1)]|", views: imageView, iconImageView, separatorLine)
        addConstraintsWithFormat(format: "H:|-12-[v0(44)]|", views: iconImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorLine)
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: iconImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1, constant: 0))
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self.titleLabel, attribute: .height, multiplier: 0, constant: 20)
        addConstraint(titleLabelHeightConstraint!)
        
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: iconImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self.subtitleTextView, attribute: .height, multiplier: 0, constant: 28))
        
    }
    
}
