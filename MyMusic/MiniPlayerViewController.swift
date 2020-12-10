//
//  MiniPlayerViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 12/10/20.
//

import UIKit

class MiniPlayerViewController: UIViewController {

    @IBOutlet var miniPlayerSongLabel: UILabel!
    @IBOutlet var miniPlayerArtistLabel: UILabel!
    
    @IBOutlet var miniPlayerSongProgress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiniPlayer()
        createObservers()
        var playbackTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSongProgress), userInfo: nil, repeats: true)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupMiniPlayer(){
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 20
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(miniPlayerTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(miniPlayerSwipeLeft))
        swipeLeftRecognizer.direction = .left
        swipeLeftRecognizer.numberOfTouchesRequired = 1
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(miniPlayerSwipeRight))
        swipeRightRecognizer.direction = .right
        swipeRightRecognizer.numberOfTouchesRequired = 1
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(miniPlayerSwipeUp))
        swipeUpRecognizer.direction = .up
        swipeUpRecognizer.numberOfTouchesRequired = 1
        
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        
        self.view.addGestureRecognizer(swipeRightRecognizer)
        
        self.view.addGestureRecognizer(swipeUpRecognizer)
        
        self.view.isUserInteractionEnabled = true
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(MiniPlayerViewController.updateMiniPlayerViewToPlayingView), name: Notification.Name(rawValue: "dsimpson.sfsu.edu.updatePlayerViewsToPlayingStatesKey"), object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(MiniPlayerViewController.updateMiniPlayerViewToPausedView), name: Notification.Name(rawValue: "dsimpson.sfsu.edu.updatePlayerViewsToPausedStatesKey"), object: nil)
    }
    
    @objc
    func miniPlayerTap(_ gesture: UITapGestureRecognizer){
        if SongPlayer.shared.isPlaying() == true {
            //pause
            SongPlayer.shared.pauseSong()
        }
        else{
            //play
            SongPlayer.shared.playSong()
        }
    }
    
    @objc
    func miniPlayerSwipeUp(_ gesture: UISwipeGestureRecognizer){
        if SongCollection.shared.position != -1{
            guard let vc = storyboard?.instantiateViewController(identifier: "Full Player") as? FullPlayerViewController else {
                return
            }
            present(vc, animated: true)
        }
    }
    
    @objc
    func miniPlayerSwipeRight(_ gesture: UISwipeGestureRecognizer){
        SongPlayer.shared.prevSong()
    }
    
    @objc
    func miniPlayerSwipeLeft(_ gesture: UISwipeGestureRecognizer){
        SongPlayer.shared.nextSong()
    }
    
    @objc
    func updateMiniPlayerViewToPlayingView(){
        let song = SongCollection.shared.songs[SongCollection.shared.position]
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor =  song.colors?.background
        })
        miniPlayerSongLabel.text = song.trackName
        miniPlayerSongLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        miniPlayerArtistLabel.text = song.artistName
        miniPlayerArtistLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        miniPlayerSongLabel.textColor = song.colors?.primary
        miniPlayerArtistLabel.textColor = song.colors?.secondary
        miniPlayerSongProgress.progressTintColor = song.colors?.secondary
        
    }
    
    @objc
    func updateMiniPlayerViewToPausedView(){
        let textColor : UIColor
        let song = SongCollection.shared.songs[SongCollection.shared.position]
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.systemBackground
        })
        miniPlayerSongLabel.text = song.trackName
        miniPlayerSongLabel.font = UIFont.systemFont(ofSize: 20.0)
        miniPlayerArtistLabel.font = UIFont.systemFont(ofSize: 15.0)
        miniPlayerArtistLabel.text = song.artistName
        
        if traitCollection.userInterfaceStyle == .light{
            textColor = UIColor.darkText
        }
        else{
            textColor = UIColor.lightText
        }
        miniPlayerSongLabel.textColor = textColor
        miniPlayerArtistLabel.textColor = textColor
        miniPlayerSongProgress.progressTintColor = textColor
    }
    
    @objc
    func updateSongProgress(){
        if SongPlayer.shared.player != nil{
            let songPercentage = SongPlayer.shared.getPlaybackTime()/SongPlayer.shared.getCurrentTrackLength()
            miniPlayerSongProgress.setProgress(Float(songPercentage), animated: true)
        }else{
            miniPlayerSongProgress.setProgress(0, animated: false)
        }

    }
    
}
