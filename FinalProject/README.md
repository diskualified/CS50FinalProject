# Draft Queens User Manuel

YouTube Video URL: https://youtu.be/7bAGL92KJAo

Opening Files and Setting Up the Environment:
    In order to launch the app, you must install xcode and pods used in the project. In order to install pods, you need to install cocoapods through terminal by executing $ sudo gem install cocoapods. Then, change directory so that you are in the project folder. Once the you are in the project directory, execute $ pod install to install the necessary pods for the project, which include SwiftSoup and Firebase. Finally, open the files by opening the file named FinalProject.xcworkspace, NOT FinalProject.xcodeproj. When running the app, make sure the simulator is iPhone 12 Pro, or a device with display of similar dimension. This can be done by going to the top bar and clicking the device option next to where it says FinalProject. 
    
Opening the App:
    Once the user opens the app, they will be presented with the app's login screen. 
    
Registration:
    In order to login, the user must register a new account. Click the register button to be redirected to that page. Then type in the text box the respective values (email, password). To clarify, the username is an email. 
    In case the password autofills with autogenerated password, just click off the password box, click back on, and click choose your own password. 
    If any fields are incorrect (ex. email is not in the format name@example.com, password is not 8 characters long, does not include a number and a special character, the passwords do not match), there will be error text to instruct how to fix the problem. After clicking register, the user will be automatically redirected to the app's homepage. If they already have an account and want to login and not register a new account, click the login button on the bottom of the page to be directed back to the login page.
    
Login:
    If the user already has an account, then they just input their email and password and login. If the email and password corresponds to an existing account, they will be directed to the app's homepage.
    
Homepage:
    On the homepage, there is a table view of all the games for upcoming weeks. The user's balance is displayed above the table view. In the top left there is a logout button, which will direct them back to the login screen. If the user scrolls to the bottom of the table, there is a button to view user's purchased bets. When they press the button, it will direct them to another table view that displays their bets. Each row in the table view of the games can be pressed and will segue to the game information.
    
Game Information:
    On this page, the user will see the betting odds and wager for each of the two teams in the game. Underneath each team's information is a button to purchase a bet for that team. When they click that button, the bet will be added to their account, the price of the bet will be subtracted from their balance, and they will be redirected back to the app's homepage. There is also a back button in the top left to go back to the homepage without purchasing a bet.

Purchased Bets Table View:
    In order to see the bets the user has already purchased, click on the purchased bets button. On that page, each row of the displayed table shows the game they bet on and the team  of that game they bet on. The button to go back to the homepage is in the top left.
    
Future Goal (not fully functional):
    After an NFL game is completed in real life, the final score should be saved and the score difference should be used to calculate which bets won. If a bet is a winning bet, add the bet winnings to the user's balance. Regardless of whether a bet is a winning or losing bet, delete the bet from the user's purchased bet after the entire week of games is over.
    