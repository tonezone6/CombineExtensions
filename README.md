# CombineExtensions

A collection of Swift Combine operators:

### Handle events:
`onSubscribe(perform:)`, `onReceive(perform:)`, `onComplete(perform:)`

### Map custom failure:
`tryMap(failure:)`

### Catch error:
`catch(to:onWeak:replaceWith:)`

### Assign result:
`assign(to:onWeak:)`

### Converts:
`convertToResult`


Without extensions

```
func fetch() {
    (1...6).publisher
        .map { "https://api.com/users/\($0)" }
        .compactMap(URL.init)
        .handleEvents(receiveSubscription: { [weak self] _ in
            self?.loading = true
        })
        .flatMap(URLSession.shared.dataTaskPublisher)
        .map(\.data)
        .decode(type: User.self, decoder: JSONDecoder())
        .collect()
        .receive(on: DispatchQueue.main)
        .mapError(\.apiError)
        .catch { [weak self] error -> AnyPublisher<[User], Never> in
            self?.error = error
            return Just([]).eraseToAnyPublisher()
        }
        .handleEvents(receiveCompletion: { [weak self] _ in
            self?.loading = false
        })
        .assign(to: &$users)
}
```

With extensions

```
func fetch() {
    (1...6).publisher
        .map { "https://api.com/users/\($0)" }
        .compactMap(URL.init)
        .onSubscribe { [weak self] in self?.loading = true }
        .flatMap(URLSession.shared.dataTaskPublisher)
        .map(\.data)
        .decode(type: User.self, decoder: JSONDecoder())
        .collect()
        .receive(on: DispatchQueue.main)
        .mapError(\.apiError)
        .catch(to: \.error, onWeak: self, replaceWith: [])
        .onComplete { [weak self] in self?.loading = false }
        .assign(to: &$users)
}
```




       
