//
//  ViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/24/20.
//
import UIKit
import UIImageColors



let updatePlayerViewsToPlayingStatesKey = "dsimpson.sfsu.edu.updatePlayerViewsToPlayingStatesKey"
let updatePlayerViewsToPausedStatesKey = "dsimpson.sfsu.edu.updatePlayerViewsToPausedStatesKey"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
        
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return SongCollection.shared.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = SongCollection.shared.songs[indexPath.row]
        
        //configure
        cell.textLabel?.text = song.trackName
        //cell.textLabel?.textColor = song.colors?.primary
        cell.detailTextLabel?.text = song.albumName
        //cell.detailTextLabel?.textColor = song.colors?.secondary
        cell.imageView?.image = song.art
        //cell.backgroundColor = colors?.background
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        //present the player
        SongCollection.shared.position = indexPath.row
        SongPlayer.shared.startSong()
    }
}
    




