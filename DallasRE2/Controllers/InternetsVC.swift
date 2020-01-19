//
//  Internets.swift
//  LunchTyme
//
//  Created by Yu Zhang on 7/30/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//

import UIKit
import WebKit

class InternetsVC: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    
    let baseurlString : String = "https://cindyzhuo.com/"
    
    let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let view = WKWebView (frame: customFrame , configuration: webConfiguration)
        return view
    }()
    
    let backButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "ic_webBack"), style: .plain, target: self, action: #selector(goBack))
        return view
    }()

    let forwardButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "ic_webForward"), style: .plain, target: self, action: #selector(goForward))
        return view
    }()

    let refreshButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "ic_webRefresh"), style: .plain, target: self, action: #selector(refresh))
        return view
    }()
    
    let urlTextField: UITextField = {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: 180, height: 40))
        view.allowsEditingTextAttributes = true
        view.isUserInteractionEnabled = true
        view.autocapitalizationType = UITextAutocapitalizationType.none
        view.backgroundColor = UIColor.white
        view.borderStyle = .bezel
        view.layer.cornerRadius = 5
        view.clearButtonMode = .always
        return view
    }()
    
    let progressLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        label.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        return label
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .whiteLarge
        spinner.color = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return spinner
    }()

    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

    }

    fileprivate func addUrlTextFieldConstraint() {

    }
    
    func setupViews() {

        let url: URL = URL(string: baseurlString)!
        let urlRequest: URLRequest = URLRequest(url : url)
        webView.load(urlRequest)
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.navigationItem.leftBarButtonItems = [backButton, refreshButton, forwardButton]


        urlTextField.text = baseurlString
        urlTextField.delegate = self
        urlTextField.becomeFirstResponder()


        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        view.addSubview(spinner)
        view.addSubview(progressLabel)
        view.addSubview(urlTextField)
        
        let barHeight = self.navigationController!.navigationBar.bounds.height

        let myConstraints = [
            NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: barHeight+urlTextField.frame.size.height),
            NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)]
        view.addConstraints(myConstraints)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        let mySpinnerConstraints = [
            NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)]
        view.addConstraints(mySpinnerConstraints)

        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        let myProgressConstraints = [
            NSLayoutConstraint(item: progressLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: progressLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 50)]
        view.addConstraints(myProgressConstraints)

        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        let myURLConstraints = [
            NSLayoutConstraint(item: urlTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20),
            NSLayoutConstraint(item: urlTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20)]
        view.addConstraints(myURLConstraints)
        view.layoutIfNeeded()
        view.addConstraint(NSLayoutConstraint(item: urlTextField, attribute: .bottom, relatedBy: .equal, toItem: webView, attribute: .top, multiplier: 1.0, constant: 0))
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                            self.view.layoutIfNeeded()
                            },
                       completion: nil)

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let urlString:String = urlTextField.text!
        let url:URL = URL(string:urlString)!
        let urlRequest: URLRequest = URLRequest(url: url)
        textField.resignFirstResponder()
        webView.load(urlRequest)
        backButton.isEnabled = true
        backButton.image = UIImage(named: "ic_webBack")
        return true
    }

    @objc func goBack() {
        print("press")
        guard let url = webView.url?.absoluteString else {
            let url: URL = URL(string: baseurlString)!
            let urlRequest: URLRequest = URLRequest(url : url)
            webView.load(urlRequest)
            return
        }
        if webView.canGoBack || url != baseurlString {
            if !backButton.isEnabled {
                backButton.isEnabled = true
                backButton.image = UIImage(named: "ic_webBack")
            }
            
            webView.goBack()
        }else if !webView.canGoBack && webView.url?.absoluteString != baseurlString {
            backButton.isEnabled = true
            let url: URL = URL(string: baseurlString)!
            let urlRequest: URLRequest = URLRequest(url : url)
            webView.load(urlRequest)
        }
        
        else if webView.url?.absoluteString == baseurlString {
            backButton.isEnabled = false
            backButton.image = nil
            forwardButton.isEnabled = true
            forwardButton.image = UIImage(named: "ic_webForward")

        }
    }

    @objc func goForward() {
        if webView.canGoForward {
            if !forwardButton.isEnabled {
                forwardButton.isEnabled = true
                forwardButton.image = UIImage(named: "ic_webForward")
            }
            webView.goForward()
        }else {
            forwardButton.isEnabled = false
            forwardButton.image = nil
            backButton.isEnabled = true
            backButton.image = UIImage(named: "ic_webBack")
        }
    }

    @objc func refresh() {
        webView.reload()
    }


    // MARK: - show indicator
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        spinner.startAnimating()
        progressLabel.isHidden = false
    }

    // hide indicator
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        progressLabel.isHidden = true

        urlTextField.text = webView.url?.absoluteString
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(Float(webView.estimatedProgress))
            progressLabel.text = String(Int(webView.estimatedProgress * 100)) + "%"
        }
    }

    deinit {
        print ("There is no memory leak from webView controller")
    }

}
//class URLTextField: UITextField {
//    var onClick: () -> Void = {}
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        onClick()
//    }
//}
