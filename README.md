# Currency Converter

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

Currency converter is a fully functional iOS app that allows users to convert from a base currency to a target currency using real-time exchange rates. Favorite converison pairs can be added to a watchlist, where users can stay up-to-date with the changes in the FX rates and its impact on their favorited conversion pairs. Users are also allowed to select a base currency and target currencies to analyze real-time FX rates via an interactive graph. 

### App Evaluation

- **Category:** Economics, Travel
- **Mobile:** Mobile allows for quick access to real-time currency exchange rates and up to date, reliable conversions.
- **Story:** Allows users to stay up to date with exchange rates and have insight into the state of the economy.
- **Market:** Currency enthusiasts, frequent travelers, and anyone looking to monitor their country's currency value.
- **Habit:** Directed at those that frequently travel and are interested in monitoring their expenses.
- **Scope:** The process of developing this app will be challenging as it will require fetching data from a credible API source and displaying data in a user friendly manner. V1 will allow users to convert from a base currency to a target currency and have access to real-time exchange rates that are displayed via a graph. V2 will implement local persistence to allow users to record frequent currency conversions for quicker access.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can convert any currency of choice to their target currency
* User can visaully see the exchange rates overtime via a graph
* User can closely monitor and store their favorite currencies 

**Optional Nice-to-have Stories**

* User can set alerts for drastic changes in exchange rates
* User has access to a settings feature to allow for customizable features

### 2. Screen Archetypes

##### Currency Conversion Screen
* User can convert any base currency of choice to their target currency
* User can add their favorite conversion pairs to their watchlist
##### Currency Watchlist Screen
* User can closely monitor currencies that were previously favorited
* User has access to quick, up-to-date information regarding real-time FX rates and its impact on their favorited conversion pairs
* User can update their watchlist by deleting a conversion pair
##### Currency Exchange Rates Screen
* User can visually analyze currency exchange rates via a graph
##### Currency Selection Screen
* User can select a country's currency to use
* User has access to a search bar to aid in quicker searches
#### Target Currency Selection Screen
* User can select their target currencies of choice to be displayed in the graph
* User has access to a search bar to aid in quicker searches

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Currency Conversion
* Currency Watchlist
* Exchange Rates

**Flow Navigation** (Screen to Screen)

#### Currency Conversion 
* => Currency Selection 
#### Exchange Rates 
* => Currency Selection 
* => Target Currency Selection 
#### Currency Watchlist 
* => None
#### Currency Selection 
* => Currency Conversion 
* => Currency Exchange Rates
#### Target Currency Screen:
* => Exchange Rates

## Wireframes
<img src="https://github.com/Anthony-Jerez/ios101-AssignmentSubmission/assets/87133474/2955270a-3559-4532-a40b-8fc9026eb8307" width=600>

## Schema

### Part 1 APP Update:
#### Sprint 1: Designing conversion screen and identifying API source
Notes: I initially struggled to implement the necessary UI components for the conversion screen and to identify a reliable API source for exchange rates. However, after ample time reading Swift documentation and browsing GitHubs that provide recommendations on useful APIs, I resolved these issues. For the next sprint, I'm planning on fetching the exchange rates from the API source and providing real-time conversion amounts for the user. Additionally, I plan to finish setting up all the screens and tab navigation. 

#### App Update Video:
<div>
    <a href="https://www.loom.com/share/96c6832c5c974f0fabbe7c5c71d40357">
    </a>
    <a href="https://www.loom.com/share/96c6832c5c974f0fabbe7c5c71d40357">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/96c6832c5c974f0fabbe7c5c71d40357-with-play.gif">
    </a>
  </div>
  
### Part 2 APP Update (Unit 9 Submission):
#### Sprint 2: Fetching real-time exchange rates from API source
Notes: After identifying the API source, I completed a network request to ensure that real-time and accurate exchange rates are applied for currency conversion. I initially struggled to fetch the data but after spending time reading the API documentation, I resolved this issue.
#### Sprint 3: Introducing a tab bar and creating a watchlist screen for users
Notes: At the end of this sprint, users are now able to navigate to different screens via a tab and are able to add their favorite currency conversion pairs to the watchlist screen. To ensure that the user receives accurate saved data, I fetch the updated data according to the conversion currency pairs that were saved. I initially had difficulty updating the data structure used to store the pairs since the fetch requests are asynchronous. However, after reviewing Swift documentation I resolved this.
#### Features Implemented:
- [x] User can convert from a base currency to a target currency according to real-time exchange rates fetched from API
- [x] User can navigate between various screens via a tab bar
- [x] User can select country codes via a table view
- [x] User can add/remove conversion currency pairs to their watchlist
- [x] User has access to up-to-date information for their favorited conversion currency pairs
#### App Update Video #2:
<div>
    <a href="https://www.loom.com/share/ac85116696544585b7ada547b94aacb7">
    </a>
    <a href="https://www.loom.com/share/ac85116696544585b7ada547b94aacb7">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/ac85116696544585b7ada547b94aacb7-with-play.gif">
    </a>
  </div>

#### Models
* Conversion Pair Model
* ISO Currency Code Model
* Exchange Rates Model

#### Networking
Conversion Screen: Fetches real-time exchange rates via API source
Watchlist Screen: Fetches real-time exchange rates for each favorited currency conversion pair to ensure up-to-date information for users
Exchange Rates Screen: Fetches real-time exchange rates for all supported currency codes to display in a graph and in comparison to a base currency selected by a user.
API Source: https://v6.exchangerate-api.com

### Final App Update (Unit 10 Submission):

#### Sprint 4: Creating a tab where users can view real-time exchange rates via a chart
Notes: At the end of this sprint, users are allowed to select a base currency and at most 8 target currencies from table view to display real-time exchange rates. If the user exceeds the limit of target currencies, an error message is displayed notifying the user of it. Exchange rates are displayed via a line chart and users have the option of zooming into the chart to better examine a particular currency of interest. 
#### Sprint 5: Implementing a search bar to ease the process of searching through table views
Notes: At the end of this sprint, users have the option to quickly search through the list of 161 currency codes via a search bar. 
#### Features Implemented: 
- [x] Users can convert from a base currency to a target currency using real-time FX rates
- [x] Users have the option to choose any currency from the list of 161 supported currency codes provided by the Exchange Rates API
- [x] Currency codes are presented in a table view, complemented by a search bar to facilitate quick navigation and searches
- [x] Users can save/delete their favorite conversion pairs in their watchlist, where these pairs are regularly updated to reflect real-time FX rates and the original base amount.
- [x] Users have the option to select a base currency and up to eight target currencies, allowing them to swiftly view real-time FX rates through a line chart.
- [x] Alert messages are displayed to correct and guide users when they don't adhere to provided instructions
#### Final Update Video:
<div>
    <a href="https://www.loom.com/share/ebe3659a9d7d43d99872b0390e753dfd">
    </a>
    <a href="https://www.loom.com/share/ebe3659a9d7d43d99872b0390e753dfd">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/ebe3659a9d7d43d99872b0390e753dfd-with-play.gif">
    </a>
  </div>
  
#### Currency Conversion Walkthrough:

<img src='https://github.com/Anthony-Jerez/ios101-AssignmentSubmission/assets/87133474/99c51779-4f58-4c84-8bb6-9a5f2d7cec8c' title='Currency Conversion Walkthrough' width='350' alt='Video Walkthrough' />

#### Watchlist Walkthrough: 

<img src='https://github.com/Anthony-Jerez/ios101-AssignmentSubmission/assets/87133474/ef92a18b-5b06-4607-a4f9-f75320140ead' title='Watchlist Walkthrough' width='350' alt='Video Walkthrough' />

#### Exchange Rates Walkthrough:

<img src='https://github.com/Anthony-Jerez/ios101-AssignmentSubmission/assets/87133474/c54490aa-2ddc-4ef5-a04a-57569096e0a4' title='Exchange Rates Walkthrough' width='350' alt='Video Walkthrough' />
