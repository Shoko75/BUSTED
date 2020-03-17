# About
![alt text](https://github.com/Shoko75/portfolio/blob/master/img/details/Banner_Busted.png "main pic")
BUSTED is a mobile game application that is a modernized game of Cops and Robbers or Tag. You split yourselves into groups of two - Cops and Robbers - each with their own objectives to complete the game. You can enjoy this game with your family or friends.

# Why I created this app
Suddenly came up with this idea when I heard about Beacon technology because I really liked to play Cops and Robbers game during my childhood days. In addition, I was a little bit sad about the news that children don't play outside recently. So I hope I could encourage the children to enjoy playing outside with BUSTED.

# UI Design (This design was created by [@andasan](https://github.com/andasan))
![alt text](https://github.com/Shoko75/portfolio/blob/master/img/details/BUSTED_UI.png "UI_pic")

# Language and Libraries
- Swift5
- UIKit
- Webkit
- Mapkit
- CoreLocation
- CoreBluetooth
- UserNotifications
- Firebase(Authentication, Database, Storage, Functions)

# Architecture
![alt text](https://github.com/Shoko75/portfolio/blob/master/img/details/BUSTED_Architecture.png "BUSTED_Architecture")
## Front End
This app consists of MVVM design pattern. The reason why I choose using MVVM pattern is I expected that the app is going to be massive therefore it's better to use MVVM pattern than MVC pattern for organizing all assets easily. In addition, this pattern is very famous. Therefore, It will help me in the future if I have the experience of building the app by MVVM pattern.

## Database & Storage
To save user data and store photos I chose to use Google's Firebase Realtime Database and Storage. This became easy to manipulate by plenty of tools such as built in account password reset, easy user management and easy visualization and manipulation of the photos uploaded.

## Back End
To send notification of game invitation I chose to use Cloud Functions and Cloud Messaging. On Cloud Functions, I created the function that is triggered by changes to data in the Realtime Database and the notification of an invitation is sent by the function.

# Current Functions
[ Fundamental Functions ]
- User sign up, sign In and sign out
- Sending friends request and accept
- Changing the profile photo
- Showing How to play 

[ Game Functions ]
- Sending game invitation
- Joining the game
- Creating the field based on the admin's location
- Setting 3 money bags in the field
- Dividing into two teams which are Robbers and Cops randomly
- Showing the alert when cops or robbers get closer
- Capturing the money bag by robbers
- Catching the robber by the cop
- Judging the game end

# Upcoming Features
- Setting vibration when the user did some actions such as catch the robber, capture the money bag and getting closer to polices/robbers.
- Adding the function that the user can set the size of the field and the number of money bags.
- Editing user info
