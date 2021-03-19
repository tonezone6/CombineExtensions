# CombineExtensions

A collection of Combine publishers.

### Operators:
* `unwrap`
* `weakAssign`
* `tryDecodeFailure`

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
