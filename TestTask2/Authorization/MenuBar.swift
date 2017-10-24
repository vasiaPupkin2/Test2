//
//  MenuBar.swift
//  TestTask2
//
//  Created by leanid niadzelin on 19.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let titles = ["Login", "Register"]
    weak var loginController: LoginController?
    var horizontalViewLeftAnchor: NSLayoutConstraint?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainGreen()
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        let selectedItem = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedItem, animated: false, scrollPosition: .left)
        setupHorizontalBar()
    }
    
    private func setupHorizontalBar() {
        let horizontalView = UIView()
        horizontalView.backgroundColor = .white
        horizontalView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalView)
        
        horizontalViewLeftAnchor = horizontalView.leftAnchor.constraint(equalTo: leftAnchor)
        horizontalViewLeftAnchor?.isActive = true
        horizontalView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horizontalView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        horizontalView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loginController?.scrollTo(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.titleLabel.text = titles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

