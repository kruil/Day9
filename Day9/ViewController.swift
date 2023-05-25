//
//  ViewController.swift
//  Day9
//
//  Created by Ilya Krupko on 25.05.23.
//

import UIKit

class ViewController: UICollectionViewController {
    
    let itemsCount = 10
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    override func loadView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layout.itemSize = CGSize(width: view.frame.width * 0.7, height: view.frame.height*0.5)
        layout.minimumLineSpacing = collectionView.layoutMargins.left * 2
        layout.sectionInset = .init(
            top: 0,
            left: collectionView.layoutMargins.left*2,
            bottom: 0,
            right: collectionView.layoutMargins.left*2
        )
    }
    
    func getClosestXPoint(targetPoint: Double, velocity: Double) -> Double {
        var bindPoints: [Double] = [0]
        let itemWidth = view.frame.width * 0.7
        let totalWidth = itemWidth + collectionView.layoutMargins.left * 2
        for i in 1 ..< itemsCount {
            let point = totalWidth * CGFloat(i) - collectionView.layoutMargins.left
            bindPoints.append(point)
        }
        if velocity == 0 {
            var pairs = bindPoints.map { ($0 , abs($0 - targetPoint)) }
            pairs.sort { $0.1 < $1.1 }
            return pairs.first!.0
        }
        return 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { itemsCount }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        let targetPoint = getClosestXPoint(targetPoint: scrollView.contentOffset.x, velocity: 0)
        scrollView.setContentOffset(CGPoint(x: targetPoint, y: scrollView.contentOffset.y), animated: true)
    }
    
    override func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let targetPoint = getClosestXPoint(targetPoint: targetContentOffset.pointee.x, velocity: 0)
        targetContentOffset.pointee = CGPoint(x: targetPoint, y: targetContentOffset.pointee.y)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )
        cell.layer.cornerRadius = 16
        cell.layer.cornerCurve = .continuous
        cell.backgroundColor = UIColor.systemBlue
        return cell
    }
}

