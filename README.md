# fetch
Search for events on Seat Geek.

## Assumptions

1. A User can search for events.
1. A User can favorite events.

## Solution formulation

Steps I thought of and executed for searching for events:

1. Use Seat Geek API to fetch all events or based on a search term
1. Display events in a master detail view 
    1. Users can favorite and unfavorite events
    1. Favorites are persisted between app launches
    1. Favorites are persisted as a dictionary to maintain O(1) lookups.
1. Supports iOS 12 and up

## Libraries/Tools used

* No main dependencies. 

## How to setup

Run the following commands to setup:

1. git clone git@github.com:scottharris86/fetch.git
1. open in Xcode
1. add CLIENT_ID to APIController.swift (replace empty clientId string)
1. Run

## Decisions and tradeoffs

1. Basic file persistence was used to save time and create a functional mvp.
1. I Chose to just cache image data on the event model itself instead of implementing a more robust caching mechanism
1. I Chose to just reload the table view data when dismissing the event detail view instead of implementing something better like a protocol or notification to update the table view when a favorite is changed
1. There are places to improve. Still, I would not opt to do them all for a small problem domain like this one. As software engineers we need to find a balance.

## If it was a bigger project

This is a coding challenge and scope is quite small. If it was a bigger real project, doing the following would be better:

1. Add real caching strategy
1. Use proper operation queue to increase performance and the ability to start and cancel any task instead of waiting 0.25 seconds to dispatch again
1. Add more information about events and venues
1. Maybe implement Core Data and sync events
1. Add tests
