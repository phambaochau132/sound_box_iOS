//
//  SearchController.swift
//  SoundBox
//
//  Created by  User on 22.05.2024.
//

import UIKit

class SearchController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    var listSong:[Song]?
    var listResult:[Song] = [Song]()
    
    
    override func viewDidLoad() {
        searchBar.delegate = self
        resultTableView.dataSource=self
        resultTableView.delegate=self
        listResult = listSong!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let list = listSong{
            if searchText != ""{
                listResult = list.filter({ (song)->Bool in
                    let nameSong=song.getName()
                    // So sanh phan tu song co chua chuoi searchText khong (khong phan biet chu hoa hoac chu thuong)
                    if(nameSong.contains(searchText) || song.getSinger().contains(searchText)){
                        return true
                    }
                    else{
                        return false
                    }
                })
            }else{
                listResult = list
            }
            
            resultTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataItem = listResult[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultTableViewCell
      
        cell.imageSong.downloaded(from: dataItem.getThumbnail())
        cell.nameSong.text = dataItem.getName()
        cell.singerSong.text = dataItem.getSinger()
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller=tabBarController?.viewControllers![1] as! PlayingController
        controller.selectedSong=listResult[indexPath.row]
        controller.listSong=listSong
        controller.changeSong=true
        tabBarController?.selectedIndex=1
        navigationController?.popViewController(animated: true)

    }
    
}
