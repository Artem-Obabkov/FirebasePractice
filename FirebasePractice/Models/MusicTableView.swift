//
//  MusicTableView.swift
//  tableViewMusic
//
//  Created by pro2017 on 12/01/2021.
//

import UIKit

//Nevermind
//The Beatles
//The Dark Side of the Moon
//What’s Going On
//My Beautiful Dark Twisted Fantasy
//Let It Bleed
//Led Zeppelin IV

class Music {
    
    var image: UIImage
    var name: String
    var description: String
    
    init(image: UIImage, name: String, description: String) {
        self.image = image
        self.name = name
        self.description = description
    }
    
}

class MusicTableView: UITableViewController {
    
    // Массив с композициями
    var albums = [Music]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Добавляем в массив экземпляры структуры
        albums.append(Music(image: UIImage(named: "Nevermind")!, name: "Nevеrmind", description: "Some description"))
        albums.append(Music(image: UIImage(named: "The Beatles")!, name: "The Beatles", description: "Some description"))
        albums.append(Music(image: UIImage(named: "The Dark Side of the Moon")!, name: "The Dark Side of the Moon", description: "Some description"))
        albums.append(Music(image: UIImage(named: "My Beautiful Dark Twisted Fantasy")!, name: "My Beautiful Dark Twisted Fantasy", description: "Some description"))
        albums.append(Music(image: UIImage(named: "Let It Bleed")!, name: "Let It Bleed", description: "Some description"))
        albums.append(Music(image: UIImage(named: "Led Zeppelin IV")!, name: "Led Zeppelin IV", description: "Some description"))
        albums.append(Music(image: UIImage(named: "What’s Going On")!, name: "What’s Going On", description: "Some description"))
        
        
        self.title = "Album"
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as! MusicCompositionTableViewCell

        // Configure the cell...
        cell.albumImage.image = albums[indexPath.row].image
        cell.albumName.text = albums[indexPath.row].name
        cell.albumDescription.text = albums[indexPath.row].description

        return cell
    }
    
    @IBAction override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showBig" else { return }
        
        let destinatonVC = segue.destination as! SecondScreen
        
        let selectedRow = tableView.indexPathForSelectedRow!
        
        let album = albums[selectedRow.row]

        destinatonVC.album = album
    }

}
