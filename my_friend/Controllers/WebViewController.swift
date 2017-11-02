//
//  WebViewController.swift
//  my_friend
//
//  Created by soma on 2017. 11. 1..
//  Copyright © 2017년 SeokHo. All rights reserved.
//

import Foundation

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    var url:String?
    
    @IBAction func onClickCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onClickGoFrontButton(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func onClickRefreshButton(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func onClickStopButton(_ sender: Any) {
        webView.stopLoading()
    }
    
    @IBAction func onClickGoBackButton(_ sender: Any) {
        webView.goBack()
    }
    


    func LoadUrl()
    {
           webView?.loadRequest(URLRequest(url: URL(string: url!)!))
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoadUrl()
    }}

