//
//  ConvertToLoadingState.swift
//

import Combine

public enum LoadingState<Value, Failure: Error> {
    case progress
    case loaded(Value)
    case failed(Failure)
}

public extension Publisher {
    func convertToLoadingState() -> AnyPublisher<LoadingState<Output, Failure>, Never> {
        self.map(LoadingState.loaded)
            .catch { Just(.failed($0)) }
            .eraseToAnyPublisher()
    }
}
