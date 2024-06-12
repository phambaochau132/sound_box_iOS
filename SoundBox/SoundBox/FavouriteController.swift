//
//  FavouriteController.swift
//  SoundBox
//
//  Created by QTS Mobile on 12/05/2024.
//

import UIKit

class FavouriteController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var listFavourite: UITableView!
    var favourites=[Song]()
    var changeFavouriteList=false
//    var initialUI=false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favouriteItem=favourites[indexPath.row]
            let cell=tableView.dequeueReusableCell(withIdentifier: "CellFavourite") as! FavouriteTableViewCell
            cell.imageSong.downloaded(from: favouriteItem.getThumbnail())
            cell.nameSong.text=favouriteItem.getName()
            cell.singer.text=favouriteItem.getSinger()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller=tabBarController?.viewControllers![1] as! PlayingController
        controller.selectedSong=favourites[indexPath.row]
        controller.listSong=favourites
        controller.changeSong=true
        tabBarController?.selectedIndex=1
        
    }
    
    override func viewDidLoad() {
        setDataFavouriteSongs()
        listFavourite.dataSource=self
        listFavourite.delegate=self
//        initialUI=true
    }
    
    // reload lai TableView khi man hinh xuat hien lai lan nua
    override func viewWillAppear(_ animated: Bool) {
        setDataFavouriteSongs()
        // reaLoad lai tableView khi du ds bai hat yeu thich thay doi
        if changeFavouriteList{
//        if initialUI {
            setDataFavouriteSongs()
        }
            // Tra ve false khi reload xong
//            changeFavouriteList=false
    }
    
    @IBAction func searchFavourite(_ sender: UIBarButtonItem) {
        let controller=storyboard?.instantiateViewController(withIdentifier: "SearchScreen") as! SearchController
        controller.listSong=favourites
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // Lay du lieu tu Database va them vao ds bai hat
    func setDataFavouriteSongs(){
        favourites = []
        print("Chau \(favourites.count)")
        self.listFavourite.reloadData()
        BaseController.ref.child(BaseController.idUser).child("favouriteSongs").observe(.childAdded, with: {DataSnapshot in
                if let songs = DataSnapshot.value as? [String:NSObject]{
                        let id:String=songs["id"] as! String
                        let name:String=songs["name"] as! String
                        let singer:String=songs["singer"] as! String
                        let thumbnail:String=songs["thumbnail"] as! String
                        let file_path:String=songs["file_path"] as! String
                        let rating:Int=songs["rating"] as! Int
                        self.favourites.append(Song(id: id, name: name, singer: singer, thumbnail: thumbnail, file_path: file_path, rating: rating))
                    
                    //Reload lai TableView (uI) khi ds bai hat thay doi
                    self.listFavourite.reloadData()
                }else{
                    fatalError("Loi database")
                }
            })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
