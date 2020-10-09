//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by Admin on 01/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController {
    var position = 0
    var songs : [Song]  = []
    var player : AVAudioPlayer?
    let playButton = UIButton()
    
    
    @IBOutlet var holderView : UIView!
    
    //Image View
    private let albumImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let songNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let albumNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holderView.subviews.count == 0 {
            configure()
        }
    }
    func configure() {
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        

        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setMode(.default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setCategory(AVAudioSession.Category.playback)
            guard let urlString = urlString else { return }
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player  else { return }
            player.volume = 0.5
            player.play()
            
            //this is for lockscreen play 
            let artWork = MPMediaItemArtwork(image: UIImage(named: song.imageName)!)
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle : song.name,
                MPMediaItemPropertyArtist : song.artistName,
                MPMediaItemPropertyArtwork : artWork,
                MPMediaItemPropertyPlaybackDuration : player.duration
            ]
            UIApplication.shared.beginReceivingRemoteControlEvents()
            becomeFirstResponder()
        } catch(let error) {
            print(error)
        }
        
        
        //album
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holderView.frame.size.width - 20,
                                      height: holderView.frame.size.width - 20)
        albumImageView.image = UIImage(named: song.imageName)
        holderView.addSubview(albumImageView)
        
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10,
                                     width: holderView.frame.size.width - 20,
                                     height: 70)
      
        albumNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 70,
                                      width: holderView.frame.size.width - 20,
                                      height: 70)
        
        artistNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10 + 140,
                                     width: holderView.frame.size.width - 20,
                                     height: 70)
        
        
        songNameLabel.text = song.name
        artistNameLabel.text = song.artistName
        albumNameLabel.text = song.albumName
        
        holderView.addSubview(songNameLabel)
        holderView.addSubview(albumNameLabel)
        holderView.addSubview(artistNameLabel)
        
        let slider = UISlider(frame: CGRect(x: 20, y: holderView.frame.size.height - 60 , width: holderView.frame.size.width - 40 , height: 50))
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holderView.addSubview(slider)
        
        let nextButton = UIButton()
        let previousButton = UIButton()
        
        //frame
        let yPosition = artistNameLabel.frame.origin.y + 70 + 20
        let size : CGFloat = 70
        
        playButton.frame = CGRect(x: (holderView.frame.size.width - size)/2.0 , y: yPosition, width: size, height: size)
        nextButton.frame = CGRect(x: holderView.frame.size.width - size - 20 , y: yPosition, width: size, height: size)
        previousButton.frame = CGRect(x: 20 , y: yPosition, width: size, height: size)
        
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        previousButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        
        playButton.tintColor = .black
        previousButton.tintColor = .black
        nextButton.tintColor = .black
        
        holderView.addSubview(playButton)
        holderView.addSubview(previousButton)
        holderView.addSubview(nextButton)
        
    }
    
    
    @objc func didSlideSlider(_ slider : UISlider) {
        let value = slider.value
        player?.volume = value
    }
    @objc func didTapPreviousButton() {
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in holderView.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
        
    }
    @objc func didTapForwardButton() {
        if position < songs.count - 1 {
           position = position + 1
           player?.stop()
           for subview in holderView.subviews {
               subview.removeFromSuperview()
           }
           configure()
        }
        
    }
    @objc func didTapPlayButton() {
        if player?.isPlaying == true {
            player?.pause()
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
}
