//
//  BaseViewController.swift
//  itunesSearchDemo
//
//  Created by Sam Tang on 30/8/2018.
//  Copyright © 2018 digisalad. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseViewController: UIViewController {

    var hud = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()

        initLoadingView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initLoadingView(){
        hud.textLabel.text = "Loading"
        
    }
    
    func showLoading(){
        hud.show(in: self.view, animated: true)
    }
    
    func hideLoading(){
        hud.dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
