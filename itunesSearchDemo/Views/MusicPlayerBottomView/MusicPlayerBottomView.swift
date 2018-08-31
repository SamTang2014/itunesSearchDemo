//
//  MusicPlayerBottomView.swift
//  itunesSearchDemo
//
//  Created by Sam Tang on 31/8/2018.
//  Copyright © 2018年 digisalad. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


class MusicPlayerBottomView: UIView {
    
    var isPlayingMusic = false
    
    var playImage = UIImage(named: "play.png")
    var pauseImage = UIImage(named: "pause.png")

    
    var player: AVPlayer?
    var playerItem : AVPlayerItem?
    
    var ituneResponseResult : Results? = nil {
        didSet {
            isPlayingMusic = true
            playButton.setImage(pauseImage, for: UIControlState.normal)
            musicProgressVIew.progress = 0
            playPreviewMusic()
            songNameLabel.text = ituneResponseResult?.trackName
            let url = URL(string: (ituneResponseResult?.artworkUrl100!)!)
            iconImageView.kf.setImage(with: url)
            
        }
    }
    
   
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var musicProgressVIew: UIProgressView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("MusicPlayerBottomView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        iconImageView.kf.setImage(with: nil, placeholder: #imageLiteral(resourceName: "music_placeholder"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        
        musicProgressVIew.progress = 0
        
        playImage = resizeImage(image: playImage!, targetSize: CGSize(width: 50, height: 50))
        pauseImage = resizeImage(image: pauseImage!, targetSize: CGSize(width: 50, height: 50))
        playButton.setImage(playImage, for: UIControlState.normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        songNameLabel.text = "-"
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    @IBAction func clickPlayButton(_ sender: Any) {
        
        updateStatusAndButtonImage()

        
    }
    
    private func updateStatusAndButtonImage(){
        
        guard let _ = ituneResponseResult else {
            return
        }
        
        if(isPlayingMusic){
            player?.pause()
            isPlayingMusic = false
            playButton.setImage(playImage, for: UIControlState.normal)
        }else {
            player?.play()
            isPlayingMusic = true
            playButton.setImage(pauseImage, for: UIControlState.normal)
        }
        
    }

    private func resetCounter(){
        player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) {
            
            (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let currentTime : Float64 = CMTimeGetSeconds((self.player!.currentItem?.currentTime())!);
                let durationTime : Float64 = CMTimeGetSeconds((self.player!.currentItem?.duration)!);
                
                self.musicProgressVIew!.progress = Float (currentTime) / Float(durationTime)
                
               
                
                if(Float (currentTime) == Float(durationTime)){
                    
                    let zero = CMTimeMakeWithSeconds(0, 100)
                    self.player?.seek(to: zero)
                    self.musicProgressVIew.progress = 0
                    self.isPlayingMusic = false
                    self.playButton.setImage(self.playImage, for: UIControlState.normal)
                    
                }
                
            }
        }
    }
    
    
    private func playPreviewMusic(){
        
        let urlString = ituneResponseResult?.previewUrl
        
        guard let url = URL.init(string: urlString!)
            else {
                return
        }
        
        playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        handleBackgroundMusic()
        player?.play()
        
        resetCounter()
        
    }
    
    private func handleBackgroundMusic(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
            UIApplication.shared.beginReceivingRemoteControlEvents()
            setupCommandCenter()
        } catch {
            print(error)
        }
        
    }
    
    private func setupCommandCenter() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: ituneResponseResult?.trackName]
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.updateStatusAndButtonImage()
            self?.player?.play()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.updateStatusAndButtonImage()
            self?.player?.pause()
            return .success
        }
    }
    
    
    
}
