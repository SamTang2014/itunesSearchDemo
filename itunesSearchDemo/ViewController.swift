//
//  ViewController.swift
//  itunesSearchDemo
//
//  Created by Sam Tang on 30/8/2018.
//  Copyright © 2018年 digisalad. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class ViewController: BaseViewController,UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var musicPlayerBottomView: MusicPlayerBottomView!
    
  
    
    lazy var searchBar = UISearchBar()
    
    @IBOutlet weak var resultTableView: UITableView!
    
    var itunesResponse = ItunesResponse(json: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchBar()
        initTableView()
        
    }

    
    private func initTableView(){
        resultTableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "resultCell")
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    private func initSearchBar(){
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        self.showLoading()
        API.searchMusic(
            keyword: searchBar.text!,
        onResponse: {
              self.hideLoading()
        },
        onSuccess: { (itunesResponse) in

            self.itunesResponse = itunesResponse
            
            if(self.itunesResponse.resultCount! > 0){
                self.resultTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            }else{
                self.resultTableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }
            
            self.resultTableView.reloadData()
            
        },onFailure: {(error) in

          

        }
        )

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = itunesResponse.resultCount != nil ? itunesResponse.resultCount! : 0
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell else {
            fatalError("create cell error")
        }
        
        let result = itunesResponse.results![indexPath.row]
        let url = URL(string: result.artworkUrl100!)
        cell.songNameLabel.text = result.trackName
        cell.collectionNameLabel.text = result.collectionName
        cell.artistNameLabel.text = result.artistName
        cell.iconImageView.kf.setImage(with: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? SearchResultTableViewCell) != nil {
            
//            let previewMusic = self.itunesResponse.results![indexPath.row].previewUrl
//            playPreviewMusic(url : previewMusic!)
            musicPlayerBottomView.ituneResponseResult = self.itunesResponse.results![indexPath.row]
            
        }
    }
    
    
   
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

