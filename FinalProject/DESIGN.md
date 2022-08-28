#  Draft Queens Design
discusses, technically, how you implemented your project and why you made the design decisions you did. Your design document should be at least several paragraphs in length. Whereas your documentation is meant to be a user’s manual, consider your design document your opportunity to give the staff a technical tour of your project underneath its hood.

Registration page:
Using firebase, there is a database that has a collection of users that stores all user id, balance, email, and bet information. When the register button is pressed and there are no errors, a user is created with the username and the password as the respective entered text fields. Each user document in the Firestore database is initialized with the username equal to the email, balance set to 10,000, and a custom userid. When the user registers, they are directed to the homepage, which is done by setting the root view controller as the home view controller and displaying it on the screen.

Login page (initial view controller):
When the user enters their email and password and hits login, the text in each text field is taken and used to authorize the user. If the user does not exist in the database, an error occurs and is shown to the user. Else, the user is redirected to the home view controller and the table display data is taken from the logged in user's documents and collections.

Styling and errors:
For the design of the register and login pages, the app uses a swift file called Utilities, which has functions that color and style the buttons and text fields. There is an error label for both pages that is transparent until there is an error, in which case it displays the text of the error based on the error case. The cases are checked in the function validate fields in RegisterViewController and it is just one check to make sure all fields are filled in in LoginViewController. There is no need to check if the email is valid or not because a non-valid email could not be registered in the database in the first place.

Main View Controller (Homepage):
    To get the NFL games for the week to display on the main table view, the app uses a pod called SwiftSoup. SwiftSoup is used to webscrape data, or easily parse the HTML from a website and get data the app wants from the site. To get the HTML from the website, the app gets the contents from the website's URL. Then, it parses the contents and selects the elements with a specified tag in the HTML. This data is used to create arrays and dictionaries to store the over under, wager values, the teams in games, and the final score. Each game is shown in its own row in the table view.
    Whenever the main view controller is loaded, two functions are called, getBalance() and loadBets(). getBalance queries the Firestore database for the user using the unique uid and sets the label at the top to the balance amount for the user to view. loadBets queries the database for the user using the uid and queries inside the bets collection for that user to get bet information and store it in an array of strings to display in the bet table view.
    Each row of the games table is clickable and segues to the game view controller, which shows the specific over under betting odds, the wager values, etc for that specific row (or game). The segue sends the data from webscraping to the game view controller. Also at the bottom is a purchased bets button that segues to the bets view controller. This sends the array from the function loadBets to the bet view controller.
    The logout button uses the same design as the login and register pages to set root view controller as the login view controller and transition back to the login page.

Game View Controller:
    The data received from the segue from the homepage is used to fill in the labels for the one of two teams corresponding to the odds and wager values. There is also a button below each team that creates a new document to the database in the user's bets collection storing all the corresponding bet information and also updates the balance in the user's document. The button in the top left goes back and is there due to the navigation controller in the storyboard linking to the homepage.
    
Bet View Controller:
    The data received from the segue from the homepage is used to display all the user's purchased bets in a table view in the same way that all the week's games are displayed in the homepage.




