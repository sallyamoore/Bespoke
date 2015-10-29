# bspoked
Bike Junction Locator for the Netherlands, Belgium, and Germany.
Find your path at [bspoked.bike](https://www.bspoked.bike)!

## Product Plan
Full Product Plan linked [here](https://docs.google.com/document/d/1B4K3zuGGnTcj-IX8mHe3t_gWqpO8Ft8Caxwo9BZfpwQ/edit?usp=sharing).

### Problem statement:
Bike touring in the Netherlands is enjoyable and relatively easy because the country has an extensive network of devoted bike paths featuring numbered nodes at each intersection. As a result, traveling by bike can be as simple as connecting the dots. However, getting yourself on a path from the airport or from within a city is often difficult -- Nodes in these areas are less well marked and harder to pinpoint. This can lead to long delays and travel stress for even a seasoned bike tourist.

In a simple, mobile-optimized interface ideal for bike travelers, this app will find the user’s current location or an entered location, locate the nearest numbered bike nodes, and easily show the user a bike route between the two.

### Market Research:
#### Applications with related functionality:

| App | Features  | Limitations |
|-----------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| OpenCycleMaps | - Maps all bike nodes  - Can find one’s current location | - Cannot create routes  - Not optimized for mobile; difficult to use on a mobile device. - Little interactivity |
| RouteYou Mobile App | - Multilingual - Worldwide - Finds established cycling paths | - Does not show numbered bike nodes - Cannot create a route - Does not find current location |
| RouteYou Web App | Like the mobile app, plus:  - Can map bike nodes  - Can find one’s current location - Can create, print, and save routes | - Not optimized for mobile; difficult to use on a mobile device. - Cannot find current location |
| Fietsersbond Routeplanner Mobile App (Fietsplanner) | - Plans bike routes that can be viewed as a map or list. - Can show numbered bike nodes | - Dutch language only - Cannot find current location |
| Fietsersbond Routeplanner Web App | Like the mobile app, plus:- Multilingual | - Not optimized for mobile; difficult to use on a mobile device. - Cannot find current location |
|  |  |  |

#### Insights from User Research:
- Biggest pain point during travel is finding a node when you’ve veered off of the path (e.g., when you stop for lunch, visit a museum, arrive at the airport, detour because of construction, etc.).
- Mobile optimization is paramount. Cyclists will not pull out a computer when they need to find a route, they would like to simply and easily find a node using a mobile device.
- Mapping is critical.
- Mapping must be optimized for cyclists (mobile).
- Finding one’s current location would increase ease of use.
- For non-Dutch speakers, Dutch-only applications are challenging and time-consuming to use.

#### Key Features That Differentiate This App:
- Will map nodes.
- Will find current location.
- Will create a route to nearby nodes.
- Will be optimized for mobile to facilitate use by bike tourists.
- Once nearby nodes are shown, a user will be able to click on a node to view directions to it.
- Will be created as an English-language app with the potential for internationalization

### Link to Trello board:
https://trello.com/b/snyEH1jG/capstone

## Requirements:
* Ruby version ~2.2.2
* Postgres database
* Additional production Gems include omniauth, bcrypt, bootstrap-sass, jquery-rails, and dotenv-rails
* Testing Gems include rspec-rails, capybara, selenium-webdriver, factory-girl-rails, and database_cleaner  

## System dependencies
* Mapping relies upon OpenStreetMaps' Overpass API, OpenCycleMaps, Mapbox, and Leaflet.
* Authorization by third-party applications (Google, Github, Facebook)

## Author
Email: bspoked.bike@gmail.com
Twitter: http://twitter.com/sallysuru
GitHub: https://github.com/sallyamoore
