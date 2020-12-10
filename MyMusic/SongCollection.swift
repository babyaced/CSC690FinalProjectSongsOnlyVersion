//
//  SongCollection.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/25/20.
//

import UIImageColors
import UIKit
import Foundation
import AVFoundation

class SongCollection{
    
    static let shared = SongCollection()
    
    let preferredColorQuality = UIImageColorsQuality.low
    
    struct Song{
        let name : String?
        let albumName : String?
        let artistName : String?
        let art : UIImage?
        let trackName : String?
        let colors: UIImageColors?
        let path: String?
    }
    
    var songs = [Song]()
    var position: Int
    private init(){
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        do{
            let songFolder = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for file in songFolder{
                let pathString = file.absoluteString
                var mp3Name : String?
                var trackMeta : String?
                var albumMeta : String?
                var artistMeta : String?
                var artMeta: UIImage?
                
//                print(pathString)
                if pathString.contains(".mp3")
                {
                    let components = pathString.components(separatedBy: "/")
                    mp3Name = components[components.count-1]
                    mp3Name = mp3Name?.removingPercentEncoding
                    mp3Name = mp3Name?.replacingOccurrences(of: ".mp3", with: "")
                    //print("MP3 NAME: ",mp3Name)
                }
                
                guard let audioPath = Bundle.main.path(forResource: mp3Name, ofType: ".mp3") else{
                    //print("\n")
                    continue
                }
                let playerItem = AVPlayerItem(url: NSURL(fileURLWithPath: audioPath) as URL)
                
                let metadataList = playerItem.asset.metadata as [AVMetadataItem]
//                print(metadataList)
                for item in metadataList {
                        if item.commonKey == nil{
                            continue
                        }
                        guard let key = item.commonKey?.rawValue, let value = item.value else{
                            continue
                        }

                       switch key {
                        case "title" : trackMeta = value as? String
                        case "artist": artistMeta = value as? String
                        case "albumName": albumMeta = value as? String
                        case "artwork" where value is Data : artMeta = UIImage(data: value as! Data)
                        default:
                          continue
                       }

                }
                /*print("Song: ", trackMeta)
                print("Artist: ", artistMeta)
                print("Album: ", albumMeta)
                print("\n")*/
                let newSong = Song(name: mp3Name, albumName: albumMeta, artistName: artistMeta, art: artMeta, trackName: trackMeta, colors: (artMeta?.getColors(quality: preferredColorQuality)),path: pathString)
//                print(newSong)
                if(mp3Name != nil){
//                    print(newSong)
                    songs.append(newSong)
                }
                    
            }
            songs.sort { $0.trackName! < $1.trackName! }
        }
        catch{
            
        }
        position = -1
        
    }
}
