import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate{
    
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
//        print("URL_URL_URL\(url)")
        
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
