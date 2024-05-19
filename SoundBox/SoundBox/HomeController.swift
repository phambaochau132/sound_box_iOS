//
//  HomeController.swift
//  SoundBox
//
//  Created by QTS Mobile on 29/04/2024.
//

import UIKit
import FirebaseDatabase


class HomeController: UIViewController,UICollectionViewDataSource,UITableViewDataSource,UICollectionViewDelegate,UITableViewDelegate{
    @IBOutlet weak var listRecent: UICollectionView!
    @IBOutlet weak var listRecommend: UITableView!
    var recommendSongs=[Song]()
    var recentSongs=[Song]()
    var changeRecentSongs=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataRecommendSongs()
        setDataRecentSongs()
        listRecommend.dataSource=self
        listRecent.dataSource=self
        listRecent.delegate=self
        listRecommend.delegate=self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Reload list recent khi co thay doi
        if changeRecentSongs{
            setDataRecentSongs()
            changeRecentSongs=false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendSongs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRecommend", for: indexPath) as! SongTableViewCell
        let song=recommendSongs[indexPath.row]
        cell.nameSong.text=song.getName()
        cell.singer.text=song.getSinger()
        cell.rating.text=String(song.getRating())
        DispatchQueue.main.async {
            cell.imageSong.image=BaseController.loadImage(url: song.getThumbnail())}
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        //Truyen gia tri
        let navVC = tabBarController?.viewControllers![1]
        let controller = navVC as! PlayingController
        controller.selectedSong = recommendSongs[indexPath.row]
        controller.listSong=recommendSongs
        controller.changeSong=true
        // Chuyen man hinh
        tabBarController?.selectedIndex = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellRecent", for: indexPath) as! RecentCollectionViewCell
        let song=recentSongs[indexPath.row]
        cell.nameSong.text=song.getName()
        DispatchQueue.main.async {
            cell.imageSong.image=BaseController.loadImage(url: song.getThumbnail())}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Truyen gia tri
        let navVC = tabBarController?.viewControllers![1]
        let controller = navVC as! PlayingController
        controller.selectedSong = recentSongs[indexPath.row]
        controller.listSong=recentSongs
        controller.changeSong=true
        // Chuyen man hinh
        tabBarController?.selectedIndex = 1
    }
    
    func setDataRecommendSongs(){
        recentSongs.removeAll()
        BaseController.ref.child("recommendSongs").observe(.childAdded, with: {DataSnapshot in
                if let songs = DataSnapshot.value as? [String:NSObject]{
                    let id:String=songs["id"] as! String
                     let name:String=songs["name"] as! String
                     let singer:String=songs["singer"] as! String
                     let thumbnail:String=songs["thumbnail"] as! String
                     let file_path:String=songs["file_path"] as! String
                     let rating:Int=songs["rating"] as! Int
                    self.recommendSongs.append(Song(id: id, name: name, singer: singer, thumbnail: thumbnail, file_path: file_path, rating: rating))
                    self.listRecommend.reloadData()
                }else{
                    print("Loi database")
                }

            })
    }
    func setDataRecentSongs(){
        recentSongs.removeAll()
        BaseController.ref.child("recentSongs").observe(.childAdded, with: {DataSnapshot in
                if let songs = DataSnapshot.value as? [String:NSObject]{
                    let id:String=songs["id"] as! String
                     let name:String=songs["name"] as! String
                     let singer:String=songs["singer"] as! String
                     let thumbnail:String=songs["thumbnail"] as! String
                     let file_path:String=songs["file_path"] as! String
                     let rating:Int=songs["rating"] as! Int
                    self.recentSongs.insert((Song(id: id, name: name, singer: singer, thumbnail: thumbnail, file_path: file_path, rating: rating)), at: 0)

                    self.listRecent.reloadData()
                }else{
                    print("Loi database")
                }

            })
    }

}
