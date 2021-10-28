//
//  MusicTableViewExtension.swift
//
//
//  Created by pro2017 on 16/10/2021.
//

import Foundation
import UIKit
import FirebaseAuth

extension MusicTableView {
    
    func createAlert(with title: String, message: String?, songInfo: SongModel?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let songName = "Song name..."
        let songDescription = "Song descriprion..."
        
        alertController.addTextField { (tf) in
            tf.placeholder = songName
            if songInfo != nil {
                tf.text = songInfo!.name
            }
        }
        
        alertController.addTextField { (tf) in
            tf.placeholder = songDescription
            if songInfo != nil {
                tf.text = songInfo!.description
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (alert) in
            
            // Достаем tf
            guard
                let firstTf = alertController.textFields?[0],
                let secondTF = alertController.textFields?[1]
            else { return }
            
            // Достаем текст из tf и выбираем изоборажение
            guard
                let songName = firstTf.text,
                songName != "",
                var songDesc = secondTF.text
            else { return }
            
            if songDesc == "" {
                songDesc = "No description..."
            }
            
            if songInfo == nil {
                // Сохраняем песню
                self?.saveData(with: songName, songDesc: songDescription)
                
            } else {
                // Обновляем значения
                self?.updateValues(for: songInfo!, songName: songName, sondDesc: songDesc)
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    // Сохранение данных
    fileprivate func saveData(with songName: String, songDesc: String) {
        // Получаем случайный номер изображения
        let imageNumber = Int.random(in: 0...images.count - 1)
        
        // Создаем модель
        let song = SongModel(imageNumber: imageNumber, name: songName, description: songDesc, userID: self.currentUser.uid )
        
        // Добавляем путь до конкретной песни в базе данных. Именем директории будет являться название песни. Так же это является продолжение ref, который мы указали в начале класса
        let songRef = self.ref?.child(song.name.lowercased())
        
        // Добавляем значения. Эти значения должны совпадать со свойствами модели данных. Но что бы не загромождать этот viewController перейдем в модель данных и там напишем функцию, которая будет возвращать словарь данных
        // let value = ["imageData": song.imageData, "name": song.name, "description": song.description, "userID": song.userID] as [String : Any]
        
        songRef?.setValue(song.convertToDictionary())
        
        self.songs.append(song)
        self.tableView.reloadData()
    }
    
    // Обновление данных
    fileprivate func updateValues(for song: SongModel, songName: String, sondDesc: String) {
        
        let updatedValues = ["name": songName, "description": sondDesc]
        song.ref?.updateChildValues(updatedValues)
        
    }
}
