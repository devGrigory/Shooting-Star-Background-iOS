//
//  ViewController.swift
//  AnimationBackground
//
//  Created by Grisha on 01.02.24.
//

import UIKit
import WebKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private var webView: WKWebView! = {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupUI()
        loadHTML()
    }
    
    // MARK: - Setup Methods
    private func setupWebView() {
        webView.navigationDelegate = self
    }
    
    private func setupUI() {
        view.addSubview(webView)
        
        /// Constrain webView to fill the view
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadHTML() {
        guard let htmlPath = Bundle.main.path(forResource: "stars_canvas", ofType: "html") else {
            print("Error: stars_canvas.html not found in bundle")
            return
        }
        let fileURL = URL(fileURLWithPath: htmlPath)
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
    }
}

extension ViewController: WKNavigationDelegate {
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        executeStarsJavaScript()
    }
    
    // MARK: - JavaScript Execution
    private func executeStarsJavaScript() {
        let jsCode = """
        var $starsCanvas = $('.js-stars');
        if ($starsCanvas.length) {
            $starsCanvas.each(function(i, el) {
                var $el = $(el),
                    defOpts = { width: $el.width(), height: $el.height() },
                    uniqueOpts = $el.data('stars-unique-opts'),
                    options = $.extend(true, {}, defOpts, uniqueOpts);
                $el.constellation(options);
            });
        }
        """
        
        webView.evaluateJavaScript(jsCode) { result, error in
            if let error = error {
                print("Failed to execute JavaScript: \(error.localizedDescription)")
            }
        }
    }
}
