//
//  VideoLauncher.swift
//  myYoutube
//
//  Created by Armin Spahic on 19/11/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerView: UIView, RemovePlayerDelegate {
    
    func removePlayer() {
       player?.pause()
        isPlaying = false
        
    }
    
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let controlsContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    let pausePlayButton: UIButton = {
       let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    var isPlaying = true
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
            
        }

        isPlaying = !isPlaying
    }
    
    let videoLengthLabel: UILabel = {
       let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoSlider: UISlider = {
       let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.red
        slider.thumbTintColor = UIColor.red
        slider.addTarget(self, action: #selector(handleSliderChanged), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderChanged() {
        print(videoSlider.value)
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value) , timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //do something
            })
        }
       
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let videoLauncher = VideoLauncher()
        videoLauncher.delegate = self
        
        setupPlayerView()
        
        setupGradientLayer()
        
        backgroundColor = UIColor.black
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        controlsContainerView.addSubview(pausePlayButton)
        controlsContainerView.addSubview(videoLengthLabel)
        controlsContainerView.addSubview(videoSlider)
        controlsContainerView.addSubview(currentTimeLabel)
        
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        videoLengthLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    var player: AVPlayer?
    
    private func setupPlayerView() {
        let urlString = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.frame
            self.layer.addSublayer(playerLayer)
            player?.play()
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds))
                let minutesString = String(format: "%02d", Int(seconds / 60 ))
                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                
                //lets move slider thumb
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    
                    self.videoSlider.value = Float (seconds / durationSeconds)
                }
                
                print(seconds)
                
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = UIColor.clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
            
            
        }
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol RemovePlayerDelegate: class {
    func removePlayer()
}

class VideoLauncher: UIView {
    
    weak var delegate: RemovePlayerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removePlayerFromSuperview() {
        let view = VideoPlayerView()
        delegate = view
        delegate?.removePlayer()
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.removeFromSuperview()
        removePlayerFromSuperview()
    }
    
     //let view = UIView()
    
    func showVideoPlayer() {
        print("Showing video animations")
        
        if let keyWindow = UIApplication.shared.keyWindow {
           
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
            self.isUserInteractionEnabled = true
            self.backgroundColor = UIColor.white
            self.addGestureRecognizer(tapGestureRecognizer)
            
            self.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height:10)
            
            //16 x 9 is the aspect ratio of all HD videos
            let height = keyWindow.frame.width * 9/16
            let videoPlayerViewFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerViewFrame)

            self.addSubview(videoPlayerView)
            keyWindow.addSubview(self)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.frame = keyWindow.frame
                
            }) { (completedAnimation) in
                // do something
              // UIApplication.shared.setStatusBarHidden(true, with: .fade)
            }
        }
       
    }
}
