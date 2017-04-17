//
//  SettingsViewController.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Toast_Swift

class SettingsViewController: UIViewController, WebSocketManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicatorView: NVActivityIndicatorView?
    var socketManager: WebSocketManager?
    var settings: Settings?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = true
        tableView.register(UINib.init(nibName: "SettingsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier())
        reloadSettings()
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Front left motor"
        case 1:
            return "Front right motor"
        case 2:
            return "Rear left motor"
        case 3:
            return "Rear right motor"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier()) as? SettingsTableViewCell else {
            precondition(false)
        }
        
        let isForward = indexPath.row == 0
        let title = isForward ? "Forward speed" : "Backward speed"
        
        guard let settings = settings else {
            cell.configure(viewModel: SettingsTableViewCellModel(title: title, value: 0))
            return cell
        }
        
        var value: Int = 0
        switch indexPath.section {
        case 0:
            value = isForward ? settings.frontLeftForwardSpeed : settings.frontLeftBackwardSpeed
        case 1:
            value = isForward ? settings.frontRightForwardSpeed : settings.frontRightBackwardSpeed
        case 2:
            value = isForward ? settings.rearLeftForwardSpeed : settings.rearLeftBackwardSpeed
        case 3:
            value = isForward ? settings.rearRightForwrdSpeed : settings.rearRightBackwardSpeed
        default: break
        }
        cell.configure(viewModel: SettingsTableViewCellModel(title: title, value: value))
         return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    
    // MARK: - Actions

    @IBAction func reset(_ sender: UIBarButtonItem) {
        reloadSettings()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - WebSocketManagerDelegate
    
    func socketStateDidChanged(socketManager: WebSocketManager) {
        activityIndicatorView?.removeFromSuperview()
        self.view.makeToast("Disconnected!")
    }
    
    func socketDidFailed(socketManager: WebSocketManager, error: Error) {
        activityIndicatorView?.removeFromSuperview()
        self.view.makeToast("\(error)")
    }
    
    func socketDidReceiveMessage(socketManager: WebSocketManager, message: String) {
        activityIndicatorView?.removeFromSuperview()
        do {
            let json = try JSONSerialization.jsonObject(with: message.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
            if json is [String:Any] {
                settings = Settings(withJson: json as! [String : Any])
                tableView.reloadData()
            }
        }
        catch {
            self.view.makeToast("Failed to read response from car")
        }
    }
    
    // MARK: - Private
    
    func reloadSettings() {
        if let socketManager = socketManager {
            activityIndicatorView = NVActivityIndicatorView(frame: view.bounds, type: .ballClipRotatePulse, color: UIColor.blue)
            view.addSubview(activityIndicatorView!)
            activityIndicatorView?.startAnimating()
            
            socketManager.delegate = self
            socketManager.sendMessage(message: DrivingCommand.getSettings.rawValue);
        }
    }
}
