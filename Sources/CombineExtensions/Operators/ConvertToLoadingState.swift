//
//  ConvertToLoadingState.swift
//

import Combine

public enum LoadingState<Value> {
    case progress
    case loaded(Value)
    case failed(Error)
}

public extension Publisher {
    func convertToLoadingState() -> AnyPublisher<LoadingState<Output>, Never> {
        self.map(LoadingState.loaded)
            .catch { Just(.failed($0)) }
            .eraseToAnyPublisher()
    }
}
