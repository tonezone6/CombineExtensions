# CombineExtensions

A collection of Combine publishers.

### Operators:
* `convertToResult`
* `convertToLoadingState`
* `convertToSnapshot`
* `decode` using default arguments
* `decodeFailure`
* `weakAssign`
* `unwrap`

### UIKit
* `UIControl`

### Data source
* `assign(to:)`

```swift
viewModel.$cards.assign(
    to: collectionView,
    cellProvider: collectionView.cardCellProvider,
    supplementaryViewProvider: collectionView.cardsHeaderProvider
).store(in: &subscriptions)
```
