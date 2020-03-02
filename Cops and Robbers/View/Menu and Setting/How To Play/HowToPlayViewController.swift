//
//  HowToPlayViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-13.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class HowToPlayViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // MARK: Others
    func setNextPage(pageNumber: Int) {
        // set the current page of the pageControl
        pageControl.currentPage = pageNumber
    }
}

// MARK: UICollectionViewDelegate
extension HowToPlayViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        setNextPage(pageNumber: Int(pageNumber))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let howToPlayData = HowToPlayData()
        return howToPlayData.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.howToPlayCollectionViewCell, for: indexPath)!
        let howToPlayData = HowToPlayData()

        cell.imageView.image = howToPlayData.data[indexPath.row]["ImageName"] as? UIImage
        cell.textLabel.text = howToPlayData.data[indexPath.row]["text"] as? String
        return cell
    }
}
