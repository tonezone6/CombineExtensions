//
//  File.swift
//  
//
//  Created by Alex Stratu on 16.04.2021.
//

import Combine
import UIKit

public protocol Section: Hashable {
    associatedtype Item: Hashable
    
    var title: String? { get }
    var items: [Item] { get }
}

extension Section {
    var title: String? { nil }
}

public extension Publisher {
    typealias Snapshot<S: Section> = NSDiffableDataSourceSnapshot<S, S.Item>

    func convertToSnapshot<S: Section>() -> AnyPublisher<Snapshot<S>, Failure>
    where Output == [S] {
        
        self.map { sections -> Snapshot<S> in
            var snapshot = Snapshot<S>()
            for section in sections {
                snapshot.appendSections([section])
                snapshot.appendItems(section.items)
            }
            return snapshot
        }
        .eraseToAnyPublisher()
    }

}
