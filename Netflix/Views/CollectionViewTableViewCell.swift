//
//  CollectionViewTableViewCell.swift
//  Netflix
//
//  Created by Abraam on 28.03.2022.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    private var titles:[Title] = [Title]()

static let identifier = "CollectionViewTableViewCell"
    private let collectioView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectioView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectioView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectioView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectioView)
        
        collectioView.delegate = self
        collectioView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectioView.frame = contentView.bounds
    }
    public func configure(with title: [Title]) {
        self.titles = title
        DispatchQueue.main.async { [weak self] in
            self?.collectioView.reloadData()
        }
    }
    
}
  
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
       
        cell.configure(with: titles[indexPath.row].image)
        return cell
}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
      
        let title = titles[indexPath.row]
        let titleName = title.title
        APICaller.shared.getMovies(with: titleName + "trailer") { result in
            switch result {
            case.success(let videoElement):
                print(videoElement.id)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
   
    }
    
    
}
