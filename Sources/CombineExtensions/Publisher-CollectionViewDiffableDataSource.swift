//
//  Publisher-CollectionViewDiffableDataSource.swif
//

import Combine
import UIKit

/**
 Publisher extension wrapping Apple's diffable data source */

public protocol Section: Hashable {
    associatedtype Item: Hashable
    
    var title: String? { get }
    var items: [Item] { get }
}

extension Section {
    var title: String? { nil }
}

public extension Publisher where Failure == Never {
    
    typealias DataSource<S: Section> = UICollectionViewDiffableDataSource<S, S.Item>
    typealias Snapshot<S: Section> = NSDiffableDataSourceSnapshot<S, S.Item>
    
    func assign<S>(
        to collectionView: UICollectionView,
        cellProvider: @escaping DataSource<S>.CellProvider,
        supplementaryViewProvider: (DataSource<S>.SupplementaryViewProvider)? = nil) -> AnyCancellable
        where Output == [S] {
                
        let dataSource = DataSource<S>(
            collectionView: collectionView,
            cellProvider: cellProvider)
        
        dataSource.supplementaryViewProvider = supplementaryViewProvider
                
        let subscriber = sink { sections in
            var snapshot = Snapshot<S>()
            for section in sections {
                snapshot.appendSections([section])
                snapshot.appendItems(section.items)
            }
            dataSource.apply(snapshot)
        }
        return AnyCancellable(subscriber)
    }
}
