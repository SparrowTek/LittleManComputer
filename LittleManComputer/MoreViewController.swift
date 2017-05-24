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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webBackButton: UIButton!
    @IBOutlet weak var reloadWikiButton: UIButton!
    
    fileprivate var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setupButtons()
        loadLittleManComputerWikipediaPage()
    }
    
    private func setupButtons(){
        reloadWikiButton.layer.cornerRadius = 5  // creates rounded corners
        reloadWikiButton.clipsToBounds = true
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
    
    @IBAction func reloadWiki() {
        reloadWikiButton.isHidden = true
        loadLittleManComputerWikipediaPage()
    }
    
    func timeout() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.reloadWikiButton.isHidden = false
            let alert = UIAlertController(title: "Loading error", message: "The LMC wiki page cannot load. Please make sure you have an internet connection.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
}

extension MoreViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
        timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(timeout), userInfo: nil, repeats: false)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        timer?.invalidate()
        activityIndicator.stopAnimating()
        
        if wikiWebView.canGoBack {
            webBackButton.isHidden = false
        } else {
            webBackButton.isHidden = true
        }
    }
}
