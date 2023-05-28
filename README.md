# RDRAppearance

This repository demonstrate triggering a `UIAppearance` refresh without having to remove views from the hierarchy and re-add them. This fixes several problems with presented view controllers.

Read the full blog post: https://datwelk.substack.com/p/realtime-uiappearance-refresh

# Install
Use Swift Package Manager.

# How to use
## Objective-C 
Call appearance selectors as follows:

```objectivec
@import RDRAppearance;

[[UIButton rdr_appearance] setBackgroundColor:...];
[[UIButton rdr_appearanceWhenContainedInInstancesOfClasses:@[[UIViewController class]]] setBackgroundColor...];
```

Trigger a refresh:

```objectivec
@import RDRAppearance;

[UIView rdr_refreshAppearance];
```

## Swift
Call appearance selectors as follows:

```swift
import RDRAppearance

UIButton.rdr_appearance().backgroundColor = ...
UIButton.rdr_appearance(whenContainedInInstancesOf: [UIViewController.self]).backgroundColor = ...
```

Trigger a refresh:
```swift
import RDRAppearance

UIView.rdr_refreshAppearance()
```
