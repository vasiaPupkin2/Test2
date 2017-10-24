//
//  DetailPhotoController.swift
//  TestTask2
//
//  Created by leanid niadzelin on 19.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit
import CoreData

class DetailPhotoController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var entityDescription: NSEntityDescription?
    var photo: Photo?
    var comments = [Comment]()
    var dateText: String?
    var image: UIImage?
    
    let commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Comment"
        tf.resignFirstResponder()
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entityDescription = NSEntityDescription.entity(forEntityName: "Comment", in: CoreDataManager.shared.managedObjectContext)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)
        setupNavigationButton()
        fetchComments()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tapGesture)
        
        imageView.image = image
        dateLabel.text = dateText
        
        commentsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        commentsTableView.estimatedRowHeight = 60
        
    }
    
    private func setupNavigationButton() {
        navigationItem.hidesBackButton = true
        let leftBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"), style: .plain, target: self, action: #selector(handleLeftBarButton))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        leftBarButton.tintColor = .white
    }
    
    @objc private func handleLeftBarButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // Fetch comments
    
    private func fetchComments() {
        self.comments = self.photo?.comment?.allObjects as! [Comment]
        comments.sort{$0.date > $1.date}
    }
    
    
    
    // Delete comment
    @objc private func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.commentsTableView)
            if let indexPath = commentsTableView.indexPathForRow(at: touchPoint) {
                let comment = self.comments[indexPath.row]
                let alert = UIAlertController(title: "", message: "Do you want to delete this comment?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                    
                    API.shared.removeComment(commentId: Int(comment.commentId), imageId:  Int(self.photo!.itemId), completion:{ success, response, error in
                        if success == true {
                            CoreDataManager.shared.managedObjectContext.delete(comment)
                            CoreDataManager.shared.saveContext()
                            self.fetchComments()
                            self.commentsTableView.reloadData()
                        }
                    })
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    // Send comment field
    
    lazy var commentContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 0, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setImage(#imageLiteral(resourceName: "submit"), for: .normal)
        submitButton.tintColor = .lightGray
        submitButton.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 0)
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.commentTextField.addBottomBorder(color: UIColor.mainGreen(), width: 10)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.mainGray()
        containerView.addSubview(separatorView)
        separatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        let greenLineView = UIView()
        greenLineView.backgroundColor = UIColor.mainGreen()
        containerView.addSubview(greenLineView)
        greenLineView.anchor(top: nil, left: self.commentTextField.leftAnchor, bottom: self.commentTextField.bottomAnchor, right: self.commentTextField.rightAnchor, paddingTop: 0, paddingLeft: -6, paddingBottom: 6, paddingRight: 2, width: 0, height: 2)
        
        let greenLineViewLeftPart = UIView()
        greenLineViewLeftPart.backgroundColor = UIColor.mainGreen()
        containerView.addSubview(greenLineViewLeftPart)
        greenLineViewLeftPart.anchor(top: nil, left: greenLineView.leftAnchor, bottom: greenLineView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 2, height: 4)
        
        let greenLineViewRightPart = UIView()
        greenLineViewRightPart.backgroundColor = UIColor.mainGreen()
        containerView.addSubview(greenLineViewRightPart)
        greenLineViewRightPart.anchor(top: nil, left: nil, bottom: greenLineView.bottomAnchor, right: greenLineView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 2, height: 4)
        
        return containerView
    }()
    
    @objc private func handleSubmitButton() {
        self.commentTextField.resignFirstResponder()
        guard self.commentTextField.text != "" else { return }
        guard let photo = self.photo else { return }
        guard let text = commentTextField.text else { return }
        let timeInterval: Int = Int(Date().timeIntervalSince1970)
        
        API.shared.postComment(imageId: Int(photo.itemId), date: timeInterval, text: text, completion:{ success, response, error in
            
            if success {
                let comment = Comment(entity: self.entityDescription!, insertInto: CoreDataManager.shared.managedObjectContext)
                comment.commentId = (response?["data"]["id"].int32!)!
                comment.date = (response?["data"]["date"].int32!)!
                comment.text = response?["data"]["text"].stringValue
                comment.photo = self.photo
                CoreDataManager.shared.saveContext()
                self.commentTextField.text = ""
                self.fetchComments()
                self.commentsTableView.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                self.commentsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        })
    }
    
    override var inputAccessoryView: UIView? {
        get{
            return commentContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc private func tap() {
        commentTextField.resignFirstResponder()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.commentsTableView.reloadData()
    }

    // Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCellId") as! DetailPhotoCell
        let comment = comments[indexPath.row]
        cell.textCommentLabel.text = comment.text
        let date = Date(timeIntervalSince1970: TimeInterval(comment.date))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy hh.mm a"
        cell.detailCommentLabel.text = formatter.string(from: date)
        return cell
    }
}
