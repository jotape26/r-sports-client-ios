# R Sports (iOS Client)

This is my final paper in my Information Systems bachelor course. This is an academic project and it's not maintained anymore.

I'm more than happy to answer any questions regarding the code.

## Install

Clone this project
```sh
cd r-sports-client-ios
sudo gem install cocoapods 
pod install
```

## Compiling

This project uses remote notification in order to alert users of new reservations. To compile, you'll need an active Apple Developer Account with access to push notification.

Altenatively, you can disable push notification in the project settings.

## Push Notifications

This project also had a backend service for our Push Notifications (and some data processing routines). 
You can check the server code at [jotape26/r-sports-notification-service](https://github.com/jotape26/r-sports-notification-service)
  