# Sonos Symphony
## Descriptions
This package contains Symphony components that can be used in Sonos applications. Those include SymphonyButton, SymphonySlider, etc. Symphony components are very similar to existing Symphony components in S2 iOS mobile controller. However, components found in this library are written to work with SwiftUI and based on [Symphony iOS for Passport](https://www.figma.com/file/1qNDzeDfU7astjLof9AuXJ/Symphony-iOS-%F0%9F%8D%8E?node-id=7%3A3&t=opGuU3ec4RplkDQz-1) specs.

This package is designed to be used as a local package within the iOS Passport repository - see: https://developer.apple.com/videos/play/wwdc2019/410/ for more information on the benefits. The goal here is to promote modularity within our project. 

## Design principles

The library aims to provide a familiar APIs similar to existing SwiftUI APIs so that our developer with SwiftUI background will feel at home when using this library. With that in mind, we will follow the principles of [SwiftUI API design](https://developer.apple.com/wwdc22/10059)

## Documentation

We use [DocC](https://developer.apple.com/documentation/docc) to document our _public_ APIs. The goal is to add documentation within the source code for easy maintenance and also leverage the built-in support from Xcode.

## Component Theming Model

Components theming is done via [Theme](Sources/SonosSymphony/Styles/Theme.swift) structure which is passed to all interested components via [EnvironmentValues](https://developer.apple.com/documentation/swiftui/environmentvalues). A theme contains several basic colors that are used by components for things like background color, foreground color, text color, etc. Since theming information is passed as an EnvironmentValues, we can override its value using ``theme(_:Theme)`` modifier on any View instead of accepting the inherited theme from the parent container (see: [Theme](Sources/SonosSymphony/Styles/Theme.swift) for more details).

## Package Structure

This package uses feature-based structure. Each component can be think of a feature provided by the package. We use the convention that each component has a separate directory (even if it only has a single source file). This aims to provide consistency across the package so that new contributors can find things easily. Any shared extension code should go into [Extensions](Sources/SonosSymphony/Extensions/) if it is intended to be reused across components. Extensions intended to be used only for a single component (e.g. Double, CGFloat extensions that define sizes of a components) should be defined within the component directory itself and should not be exposed to other components (they should be defined with private, fileprivate). If you have common code that you want to share across components (or expose to clients of Sonos Symphony), you might want to create a separate directory with a name reflect its intentions (e.g. Commons/ for common code though we think this package should serve a single purpose - provides Symphony components. This makes the likelihood of having Common Utilities code less likely).

## Package Products

* ``SonosSymphony`` contains all supported Symphony components. If you simply want to use Symphony components, this is the product to import to your project.

## Testing

Currently, we have no plan for Unit Testing this package due to the lack of native support from Apple. Read more about Brock's finding [here](https://confluence.sonos.com/display/SD/SwiftUI+-+Testability+Study)
