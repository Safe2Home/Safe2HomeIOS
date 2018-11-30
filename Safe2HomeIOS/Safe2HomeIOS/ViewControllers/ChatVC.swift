//
//  ChatVC.swift
//  Safe2HomeIOS
//
//  Created by Eric Le Ge on 11/21/18.
//  Copyright © 2018 Safe2Home. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import FirebaseFirestore


class ChatVC: MessagesViewController {
    var currentUser =  CurrentUser(id: (Auth.auth().currentUser?.uid)!)
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    private let user: User
    private let channel: Channel
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    override func viewDidLoad() {
        
        let uid = Auth.auth().currentUser!.uid
        
        self.currentUser = CurrentUser(id: uid)
        
        
        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        //        let testMessage = Message(user: user, content: "I love pizza, what is your favorite kind?")
        //        insertNewMessage(testMessage)
        self.tabBarController?.tabBar.isHidden = true
        reference = db.collection(["channels", id, "thread"].joined(separator: "/"))
        super.viewDidLoad()
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    init(user: User, channel: Channel) {
        self.user = user
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
        title = channel.name
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        messageListener?.remove()
    }
    private func save(_ message: Message) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
        }
    }
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.index(of: message) == (messages.count - 1)
        let shouldScrollToBottom = isLatestMessage
        print("********",messages)
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            insertNewMessage(message)
            
        default:
            break
        }
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension ChatVC: MessagesDataSource {
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // 1
    func currentSender() -> Sender {
        
        return Sender(id: currentUser.id, displayName: currentUser.username)
    }
    
    // 2
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // 3
    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        
        //return messages[indexPath.section]
        return messages[indexPath.section]
    }
    
    // 4
    func cellTopLabelAttributedText(for message: MessageType,
                                    at indexPath: IndexPath) -> NSAttributedString? {
        
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
}

extension ChatVC: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        // 1
        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        // 2
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath,
                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        // 3
        return 0
    }
}

extension ChatVC: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        // 1
        return isFromCurrentSender(message: message) ? .orange : .lightGray}//UIColor.init(red: 249, green: 166, blue: 2, alpha: 0)
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        
        // 2
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        // 3
        return .bubbleTail(corner, .curved)
    }
}

// MARK: - MessageInputBarDelegate

extension ChatVC: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        if let user = Auth.auth().currentUser{
            let message = Message(user: user, content: text)
            
            save(message)
            inputBar.inputTextView.text = ""
        }
        
    }
    
}
