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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // Go to next page when they pressed the next button
    // ===============================================================
    func scrollToPageforBtn(page: Int, animated: Bool) {
        var frame: CGRect = self.collectionView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.collectionView.scrollRectToVisible(frame, animated: animated)
    }
    
    // set the next page infomation for pageControl and button
    // ================================================================
    func setNextPage(pageNumber: Int) {

        // set the current page of the pageControl
        pageControl.currentPage = pageNumber
    }
}

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
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HowToPlayCollectionViewCell", for: indexPath) as! HowToPlayCollectionViewCell
        let howToPlayData = HowToPlayData()

        cell.imageView.image = UIImage(named: howToPlayData.data[indexPath.row]["ImageName"]!)
        cell.textLabel.text = howToPlayData.data[indexPath.row]["text"]!
        return cell
    }
    


}
