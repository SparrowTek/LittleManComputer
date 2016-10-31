//
//  MoreViewController.swift
//  LittleManComputer
//
//  Created by Thomas Rademaker on 10/30/16.
//  Copyright © 2016 SparrowTek LLC. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var wikiWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        loadLittleManComputerWikipediaPage()
    }
    
    private func loadLittleManComputerWikipediaPage() {
        let urlString = "https://en.wikipedia.org/wiki/Little_man_computer"
        let url = NSURL(string: urlString)
        let request = NSURLRequest(url: url as! URL)
        wikiWebView.loadRequest(request as URLRequest)
    }
    
    @IBAction func webviewGoBack() {
        wikiWebView.goBack()
    }
    
}
