//
//  BaseViewController.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Toast_Swift

class BaseViewController: UIViewController {
    
    lazy var loadingView: UIView = { [unowned self] in
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let activityIndicatorView = NVActivityIndicatorView(frame: self.view.bounds, type: .ballClipRotatePulse, color: self.view.tintColor, padding: 100)
        activityIndicatorView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        return view
    }()
    
    
    var active: Bool = false

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory warning!!!");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        active = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        active = false
    }

    func showLoadingView() {
        view.addSubview(loadingView)
    }
    
    func hideLoadingView() {
        loadingView.removeFromSuperview()
    }
    
    func showToastMessage(message: String) {
        view.makeToast(message)
    }

}
