//
//  WebViewController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/17/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate{
    
    var url = ""
    var button = NeoButton()
    override func viewDidLoad() {
        button.load(title: "done", frame: CGRect(x: 20, y: 20, width: 150, height: 58))
        super.viewDidLoad()
        super.view.addSubview(button)
        setupUI()
        print("URL_URL_URL\(url)")
        let myRequest = URLRequest(url: URL(string: url)!)
        webView.load(myRequest)
    }
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
