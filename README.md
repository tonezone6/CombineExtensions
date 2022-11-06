# Combine extensions

A collection of Swift Combine operators for updating progress, catching errors and assign results. The result is weakly capturing self in order to avoid retain cycles.

`update(loading:onWeak)`
`catch(to:onWeak:replaceWith:)`
`assign(to:onWeak:)`
`sink(receiveError:receiveValue:)`
`tryMap(failure:)`
`convertToResult`

Example

```swift
func fetch10Users() -> AnyPublisher<[User], SomeError> {
    Just((1...10))
        .map { id in "https://www.api/users/\(id)" }
        .compactMap(URL.init)
        .update(loading: \.loading, onWeak: self)
        .flatMap(session.dataTaskPublisher)
        .map(\.data)
        .decode(type: User.self, decoder: JSONDecoder.init)
        .collect()
        .mapError(SomeError.init)
        .eraseToAnyPublisher()
}
```
