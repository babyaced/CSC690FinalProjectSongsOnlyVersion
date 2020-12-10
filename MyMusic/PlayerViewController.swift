//
//  PlayerViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/24/20.
//

import AVFoundation
import UIKit

class PlayerViewController: UIViewController {
    
    //public var position: Int = 0
    
    @IBOutlet var holder: UIView!
    
    //var player: AVAudioPlayer?

    
    //User Interface Elements
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //line wrap
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //line wrap
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //line wrap
        return label
    }()
    
    let playPauseButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0{
            configure()
        }
    }
    
    func configure(){
        //set up player
        let song = SongCollection.shared.songs[SongCollection.shared.position]
        
        //set up user interface elements
        
        //ablum cover
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holder.frame.size.width-20,
                                      height: holder.frame.size.width-20)
        albumImageView.image = UIImage(named: song.imageName!)
        holder.addSubview(albumImageView)
        
        //Labels: Song, album, artist
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10,
                                      width: holder.frame.size.width-20,
                                      height: 70)
        albumNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 30,
                                      width: holder.frame.size.width-20,
                                      height: 70)
        artistNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 30 + 30,
                                      width: holder.frame.size.width-20,
                                      height: 70)
        
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        holder.addSubview(songNameLabel)
        holder.addSubview(albumNameLabel)
        holder.addSubview(artistNameLabel)
        
        //player controls

        let nextButton = UIButton()
        let backButton = UIButton()
        
        //Frame
        let yPosition = artistNameLabel.frame.origin.y + 30 + 20
        
        let size: CGFloat = 80
        
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        nextButton.frame = CGRect(x: holder.frame.size.width - size - 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        
        
        //Add actions
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        //Styling
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        nextButton.tintColor = .black
        backButton.tintColor = .black
        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backButton)
        //slider
        let slider = UISlider(frame: CGRect(x: 20, y: holder.frame.height-60, width: holder.frame.size.width-40, height: 50))
        
        slider.value = 0.5
        slider.addTarget(self,action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holder.addSubview(slider)
    }
    
    @objc func didTapBackButton(_ slider: UISlider){
        if SongCollection.shared.position > 0{
            SongCollection.shared.position = SongCollection.shared.position - 1
            player?.stop()
            for subview in holder.subviews{
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapNextButton(_ slider: UISlider){
        if SongCollection.shared.position < (SongCollection.shared.songs.count - 1){
            SongCollection.shared.position = SongCollection.shared.position + 1
            player?.stop()
            for subview in holder.subviews{
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapPlayPauseButton(_ slider: UISlider){
        if player?.isPlaying == true {
            //pause
            player?.pause()
            //show play button
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
            //shrink image
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 30,
                                               y: 30,
                                               width: self.holder.frame.size.width-60,
                                               height: self.holder.frame.size.width-60)
            })
        }
        else{
            //play
            player?.play()
            //show pause button
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            //increase image size
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 10,
                                               y: 10,
                                               width: self.holder.frame.size.width-20,
                                               height: self.holder.frame.size.width-20)
            })
        }
    }
    
    @objc func didSlideSlider(_ slider: UISlider){
        let value = slider.value
        player?.volume = value
        //adjust player volume
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //if let player = player{
         //   player.stop()
        //}*/
    }
}