# Tic-tac-toe Swift playground

This is a Swift playground book that introduces the min-max algorithm. I created this as part of my application for the 2019 Apple WWDC Scholarship.
![Screenshot](https://raw.githubusercontent.com/hristost/tic-tac-toe-playground/master/screenshot.PNG)
## Using the playground ##

* Open the pre-built `tictactoe.playgroundbook` using [Swift Playgrounds on Mac](https://apps.apple.com/us/app/swift-playgrounds/id1496833156?mt=12) or [Swift Playgrounds on iPad](https://apps.apple.com/us/app/swift-playgrounds/id908519492).
* Alternatively, build the playground book from source by opening with Xcode and building the `PlaygroundBook` target, which will produce your playground book as a product. (You can access it by opening the “Products” group in the Project navigator, and then right-clicking and selecting “Show in Finder”. From there, you can use AirDrop or other methods to copy the playground book to an iPad running Swift Playgrounds.)

## Notes

* I used the [Swift Playgrounds Author Template](https://developer.apple.com/documentation/swift_playgrounds/creating_and_running_a_playground_book?language=objc) provided by apple.
* As of now (Nov. 2019), this template fails to compile with Xcode 11.2.1. You need to find the template relevant to your Xcode version and replace the `PlaygroundSupport` framework before compiling. Alternatively, you can try [buidling PlaygroundSupport yourself](https://github.com/apple/swift-xcode-playground-support).
