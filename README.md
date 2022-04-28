# Combine extensions

A collection of Swift Combine operators:

### Basic operators for updating progress, catch errors and assign results. The result is weakly capturing self in order to avoid retain cycles.
`update(loading:on)`
`catch(to:on:replaceWith:)`
`assign(to:on:)`

### Other
`tryMap(failure:)`
`convertToResult`

Example

```swift
func fetchUsers() {
    (1...6).publisher
        .map { id in ".../users/\(id)" }
        .compactMap(URL.init)
        .update(loading: \.loading, on: self)
        .flatMap(session.dataTaskPublisher)
        .map(\.data)
        .decode(type: User.self, decoder: JSONDecoder.init)
        .collect()
        .receive(on: RunLoop.main)
        .mapError(ApiError.init)
        .catch(to: \.error, on: self, replaceWith: [])
        .assign(to: &$users)
}
```
