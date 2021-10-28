//
//  MusicTableView.swift
//  tableViewMusic
//
//  Created by pro2017 on 12/01/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

//Nevermind
//The Beatles
//The Dark Side of the Moon
//What’s Going On
//My Beautiful Dark Twisted Fantasy
//Let It Bleed
//Led Zeppelin IV

let images = ["Nevermind", "The Beatles", "The Dark Side of the Moon", "My Beautiful Dark Twisted Fantasy", "Let It Bleed", "Led Zeppelin IV", "What’s Going On"]

class MusicTableView: UITableViewController {
    
    // Создаем текущего пользователя
    var currentUser: User!
    
    // Создаем ref, где мы сразу будем добираться до массива песен
    var ref: DatabaseReference!
    
    // Массив с композициями
    var songs = [SongModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Определяем текущего пользователя
        guard let user = Auth.auth().currentUser else { return }
        self.currentUser = user
        
        // Определяем путь до массива песен, где вход в каждую новую директорюи происходит через child("")
        self.ref = Database.database().reference(withPath: "users").child(currentUser.uid).child("songs")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        getCurrentUserSongs()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return songs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as! MusicCompositionTableViewCell

        // Configure the cell...
        cell.albumImage.image = Int.getImage(from: songs[indexPath.row].imageNumber)!
        cell.albumName.text = songs[indexPath.row].name
        cell.albumDescription.text = songs[indexPath.row].description

        return cell
    }
    
    // Delete rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Получаем тукущую песню
            let song = songs[indexPath.row]
            
            self.songs.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Удаляем значение в базе данных. Делаем это через ref, т.к это является адресом песни, а если у песни нету адреса, соответственно песни тоже нету
            song.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = editCell(for: indexPath)
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    fileprivate func editCell(for indexPath: IndexPath) -> UIContextualAction {
        // Получаем песню
        let song = songs[indexPath.row]
        
        // СОздаем действие
        let contextualAction = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completion) in
            
            // Обновляем данные песни
            self?.createAlert(with: "Edit", message: "Edit song param here", songInfo: song)
            
            completion(true)
        }
        
        // Настраиваем дизайн
        contextualAction.image = UIImage(systemName: "pencil.circle")
        contextualAction.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return contextualAction
    }
    
    @IBAction override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        
        case "showBig":
            let destinatonVC = segue.destination as! AddScreen
            
            let selectedRow = tableView.indexPathForSelectedRow!
            
            let album = songs[selectedRow.row]

            destinatonVC.album = album
            
        case "showProfileView":
            print("Shit")
            
        default:
            return
        }
    }
    
    
    
    // IBActions
    
    @IBAction func personAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showProfileView", sender: self)
    }
     
    @IBAction func addAction(_ sender: UIButton) {
        self.createAlert(with: "Add song", message: nil, songInfo: nil)
    }
    
    private func getCurrentUserSongs() {
        
        // Получаем данные
        self.ref.observe(.value) { [weak self] (snapshot) in
            
            // Создаем второстепенный массив типа SongModel, который позволит не дублировать элементы в основном масииве
            var _songs = [SongModel]()
            
            // Извлекаем данные из данного snapshot
            guard let value = snapshot.value as? [String: Any] else { return }
            
            // С помощью перебора извлекаем нужные элементы из всех данных, полученных с базы данных. item является snapshot - ом определенной директории (в данном случае конкретной песней), поэтому его можно так же скастить до типа [String: Any] и передать в инициализатор модели.
            for item in value {
                
                // ВАЖНО Нужно эти 2 действия выполнить в 2 guard - ах
                // Получаем данные о песни
                guard
                    let songItem = item.value as? [String: Any]
                else { return }
                
                // Создаем адресс конкретной песни
                let currentSongRefChildName = (songItem["name"] as! String).lowercased()
                
                
                // Создаем модель данных песни и адресс конкретной песни
                guard
                    let currentSongRef = self?.ref.child(currentSongRefChildName),
                    let song = SongModel(snapshotValue: songItem, ref: currentSongRef)
                else { return }
                
                _songs.append(song) 
            }
            
            // Обновляем таблицу и присваиваем данные
            self?.songs = _songs
            self?.tableView.reloadData()
        }
    }
    
}
