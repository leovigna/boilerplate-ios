# Boilerplate iOS App
My Swift boilerplate sample app.
Integrates my favorite libraries:
* [Firebase Cloud Firestore](https://firebase.google.com/products/firestore/)
* [Firebase Auth](https://firebase.google.com/products/auth/)
* [Stripe](http://stripe.com)
* [GoogleMaps](https://developers.google.com/maps/)
* [Spotify](https://beta.developer.spotify.com/documentation/ios-sdk/)
## Motivation
This project was created for personal learning and to enable rapid prototyping during hackathons.
## Build Status
Travis build status. HERE
## Getting Started
These instructions will get you started.
### Prerequisites
You will need XCode to run the simulator and create an iOS app.
### Installing
Use [Cocoapods](http://Cocoapods.org) to install any dependencies defined in the [Podfile](https://github.com/lion9901/boilerplate-ios/blob/master/Podfile) at their latest version.
Open your terminal, navigate to the project folder and run:
```
pod install
```
### Running
Use the iPhone simulator on XCode to run the sample app.
### Testing
Make sure to add you own keys to interact with the stripe api.
To do this edit, the [LVConstants.swift](https://github.com/lion9901/boilerplate-ios/blob/master/boilerplate/Utility/LVConstants.swift) file.
```
static let STRIPE_KEY = <YOUR_PUBLISHABLE_KEY_HERE>
```
If you run the backend on a server make sure to also edit the Stripe API url field:
```
static let STRIPE_API_URL = <SERVER_URL>/stripe
```
Currently no unit tests are implemented.
## Screenshots
Include logo/demo screenshot etc.
## Code style
Official Swift API Guidelines [Swift](https://swift.org/documentation/api-design-guidelines/)
## Authors

* **Leo Vigna** - *Initial work* - [boilerplate-ios](https://github.com/lion9901/boilerplate-ios)

## Contribute
At this moment, you are welcome to fork the project.
## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/lion9901/boilerplate-ios/blob/master/LICENSE.md) file for details
