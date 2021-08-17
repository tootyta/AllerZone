# AllerZone - an informative app concerning allergies made using Flutter and a variety of dependencies

This is my 2nd time using Flutter, so I apologize if my app isn't amazing. I made this app because, as an individual with allergies, I wanted to be able to easily access
and obtain numerical and specific yet understandable information about allergies in my area. I also wanted an app that would help users dissect their own allergies and provide helpful advice for common scenarios that a lot of individuals with allergies experience. 

## Getting Started

To use this project, simply import it as a Flutter project. I recommend using Android Studio.

## Daily Pollen

![4](https://user-images.githubusercontent.com/17104414/129662944-fef56ca2-88fc-424b-9934-b312d9912cf5.PNG)

This page provides the user with current pollen levels for Weed, Tree, and Grass pollen (depending on the dropdown) for their area. It does this by asynchronously grabbing the latitude and longitude of the user's location and requesting/parsing the location's allergy data into a readable format for the user. 

![6](https://user-images.githubusercontent.com/17104414/129663370-48a859c3-9750-45c5-b2e2-4713e5d1acf2.PNG)

![5](https://user-images.githubusercontent.com/17104414/129663136-fcb40cd6-43fa-48a6-a5b7-3c2a77704bed.PNG)

The user will then see a similar pop-up to the one above to provide the allergy data as well as an interpretation of the levels. Finally, the graphs on the main screen of the app will be updated to display specific pollen information in case there are multiple species of the organism causing allergies (usually trees). 

## Prediction

![7](https://user-images.githubusercontent.com/17104414/129663668-07dcda8e-e3d1-40a9-a174-89b973353b7d.PNG)

This page is meant to help the user figure out what they may be allergic to if anything. The user simply needs to fill in whether they've had bad allergies during the last seven days (specifically). After doing so, the app will proportionally compare the amount of pollen on the bad allergy days to the amount of total pollen that occured during those seven days by category of pollen and see if the amount contributed is over 50%. Obviously, a simple 50% threshold does not account for numerical abnormalities and outlier days, so a note is provided to advise the user to seek medical advice if they want more accurate results.

![2](https://user-images.githubusercontent.com/17104414/129664069-25e0ae0a-b4e5-488f-a567-d4e14d995701.PNG)

## Forecast

![3](https://user-images.githubusercontent.com/17104414/129664187-834d24e8-1cfb-4269-b8ae-bddb5f6924ba.PNG)

This page provides the user with a 48-hour forecast with the amount of pollen that may be present during those hours. Clicking any of the golden cards will present the user with a dialogue similar to the one on the Daily Pollen page to provide interpretations for those pollen levels along with the risk association. 

![8](https://user-images.githubusercontent.com/17104414/129664352-5f8a01a9-ab59-4b90-ba38-136100080325.PNG)

## Need Help

This page was supposed to provide the relatable, anecdotal information that I have compiled about my experiences with allergies along with contact information and links to websites with medical information. However, as the API I was using, Ambee, is soon disabling its free plans, I did not have enough time to display all this information in a beautiful way. However, I have provided all the information that I was going to put in the allergyques.txt file in this repository. 

## Extras

This app will not be maintained as of now because Ambee is disabling its free plans with its API. 
