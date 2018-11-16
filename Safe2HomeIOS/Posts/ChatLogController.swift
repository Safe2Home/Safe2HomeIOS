//
//  ChatLogController.swift
//  Safe2HomeIOS
//
//  Created by Yafei Liang on 11/16/18.
//  Copyright © 2018 Safe2Home. All rights reserved.
//

import Foundation
import UIKit

class ChatLogController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Epi 8 4:20
        navigationItem.title = "Chat Log Controller"
        
        collectionView?.backgroundColor = UIColor.white
        setupInputComments()
        //modified here
    }
    
    func setupInputComments() {
        let containerView = UIView()
        //containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        //ios contraint
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //containerView.heightAnchor.constraint(10).active = true
        //comment out the line above bc don't know how to modify
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        //sendButton.widthAnchor.constraint(80).isActive = true
        //sendButton.heightAnchor.constraint(equalTo: containerView.heigthAnchor).isActive = true
        //comment out the two lines above bc don't know how to modify
        
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        //didn't use the constant 16:14 Epi8
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        //inputTextField.widthAnchor.constraint(100).isActive = true
        //comment out the two lines above bc don't know how to modify
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.black
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)

        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        //separatorLineView.heightAnchor.constraint(1).isActive = true
        //comment out the line above bc don't know how to modify
    }
}
