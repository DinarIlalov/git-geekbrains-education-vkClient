//
//  VKLoginViewController.swift
//  VKClient
//
//  Created by Константин Зонин on 24.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit
import WebKit

class VKLoginViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var webLoaderActivityIndicator: UIActivityIndicatorView! {
        didSet {
            webLoaderActivityIndicator.color = .black
            webLoaderActivityIndicator.startAnimating()
        }
    }

    // MARK: Properties
    private let vkService = VKAuthService()
    
    // MARK: Class funcs
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAuthForm()
    }

    @IBAction func unwindToAuthorizationController(_ sender: UIStoryboardSegue) {
        // Log Out from main interface
    }
    
    // MARK: - Functions
    private func showAuthForm() {
        do {
            let request = try vkService.сreateAuthRequest()
            webView.load(request)
        }
        catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

// MARK: - WKNavigationDelegate
extension VKLoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webLoaderActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if (error._code == -1009) {
            infoLabel.text = "No Internet connection!"
            infoLabel.isHidden = false
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
            else {
                print("Incorrect redirect url or no response parameters!")
                decisionHandler(.allow)
                return
        }
        infoLabel.isHidden = true
        
        let urlComponents = fragment.components(separatedBy: "&")
            .map{ $0.components(separatedBy: "=") }
        let token = urlComponents.first {$0.first == "access_token"}?.last
        let userId = Int(urlComponents.first {$0.first == "user_id"}?.last ?? "0")
        guard let accessToken = token else {
            print("No token received!")
            decisionHandler(.allow)
            return
        }
        guard let userIdInt = userId else {
            print("No user_id!")
            decisionHandler(.allow)
            return
        }
        
        UserData.SaveData(token: accessToken, userId: userIdInt)
        
        // TODO: debug
        print(accessToken)
        
        VKApiServiceLoggingProxy().getCurrentUserCredentianals() {
            FirebaseService.saveLoginInfo()
        }
        
        decisionHandler(.cancel)
        performSegue(withIdentifier: "mainMenuSegue", sender: self)
    }
    
}
