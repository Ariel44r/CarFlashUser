//
//  ChatViewController.swift
//  Apporio Taxi
//
//  Created by Atul Jain on 28/10/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    
    
    var ref1 = FIRDatabase.database().reference()
    
    var defaults = UserDefaults.standard

    
    /// Lazy computed property for painting outgoing messages blue
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    /// Lazy computed property for painting incoming messages gray
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        
        // First, check the defaults if an ID and display name are set
        if  let id = defaults.string(forKey: "jsq_id"),
            let name = defaults.string(forKey: "jsq_name")
        {
            // Set the JSQMVC properties for sender ID and display name
            senderId = id
            senderDisplayName = name
        }
        else
        {
            // If the defaults doesn't have the ID and name, generate an ID, set the name to blank, and show the name dialog
         //   senderId = String(arc4random_uniform(999999))
            
            senderId = "User"
            senderDisplayName = GlobalVarible.drivername
            
            // Save the sender ID
            defaults.set(senderId, forKey: "jsq_id")
             defaults.set(senderDisplayName, forKey: "jsq_name")
            defaults.synchronize()
            
            // Show the display name dialog
           // showDisplayNameDialog()
        }
        
        title = "\(senderDisplayName!)"
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        
        let query = self.ref1.child("Chat").child(GlobalVarible.checkRideId)

        
      // let query = ref1.child("RideTable").child(GlobalVarible.checkRideId).child("Chat").queryLimited(toLast: 10)
        
        debugPrint(query)
        
       // let query = Constants.refs.databaseChats.queryLimited(toLast: 10)
        
        // Observe the query for changes, and if a child is added, call the snapshot closure
       //
          _ = query.observe(.childAdded, with: { [weak self] snapshot in
        
       /* _ = query.observe(.value, with: { (snapshot) in
            
            // Get all the data from the snapshot
            let value = snapshot.value as? NSDictionary
            
            if let rideid = value?["message"]{
                
                let id          = value?["send_via"] as! String
                let name        = value?["timestamp"] as! String
                let text        = value?["message"] as! String*/

            
        if  let data        = snapshot.value as? [String: String],
                let id          = data["send_via"],
                let name        = data["timestamp"],
                let text        = data["message"],
                !text.isEmpty   // <-- check if the text length > 0
            {
                // Create a new JSQMessage object with the ID, display name and text
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    // Append to the local messages array
                    self?.messages.append(message)
                    
                    // Tell JSQMVC that we're done adding this message and that it should reload the view
                    self?.finishReceivingMessage()
                }
            }
        })


        // Do any additional setup after loading the view.
    }
    
    
    func setupBackButton(){
    
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    
    func backButtonTapped() {
        
        
        defaults.removeObject(forKey: "jsq_id")
        defaults.removeObject(forKey: "jsq_name")
        

        
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backbtn_click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        // Return a specific message by index path
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        // Return the number of messages
        
        debugPrint(messages.count)
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        // Return the right image bubble (see top): outgoing/blue for messages from the current user, and incoming/gray for other's messages
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        // No avatar!
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        // Return an attributed string with the name of the user who's text bubble is shown, displayed on top of the bubble, or return `nil` for the current user
        
        
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: GlobalVarible.drivername)
       // return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        // Return the height of the bubble top label
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        // Get a reference for a new object on the `databaseChats` reference
        // `childByAutoId()` generates a unique random object key
        //let ref = Constants.refs.databaseChats.childByAutoId()
        
       // let ref = ref1.child("RideTable").child(GlobalVarible.checkRideId).child("Chat").childByAutoId()
        
       // let sticks = String((Date().timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
        
        let sticks = String(Date().timeIntervalSince1970)
        
        let startdate = (sticks.components(separatedBy: "."))
        
        
         let ref = self.ref1.child("Chat").child(GlobalVarible.checkRideId).childByAutoId()
        
        
        // Create the message data, as a dictionary
        let message = ["send_via": senderId, "timestamp": startdate[0], "message": text]
        
        // Save the data on the new reference
        ref.setValue(message)
        
        // Tell JSQMVC we're done here
        // Note: the UI and bubbles don't update until the newly sent message is returned via the .observe(.childAdded,with:) closure. Neat!
        finishSendingMessage()
    }

    

   
}

