## ItemDataCollector

The addon fetches item data through the game’s API and tooltip and saves the collected data into a `SavedVariables.lua` file located in the WTF directory (e.g.  `World of Warcraft 3.3.5\WTF\Account\<Account_name>\SavedVariables.lua`). 
Since not all item information is accessible through the API, addon also extracts additional information via tooltip, capturing all relevant data.

### Usage

1. Download the `ItemDataCollector` addon and place it in your WoW AddOns directory.
2. Play and Interact with as many items as possible.

### How It Works:

* The addon collects item data through the following actions:
  * Looting an item
  * Hovering mouse over an item to display its tooltip
  * Opening a vendor window – automatically collects data for all items the vendor sells
  * Left-clicking on an item
  * Left-clicking on an item’s hyperlink in chat (You must double-click or more on the hyperlink to collect the data! A single click doesn't work currently.)
  * To avoid cluttering the data with low-value items, the addon is designed to only log items of common quality(non-trash) or higher.
* The file won't be overwritten between game sessions, BUT to prevent potentially losing valuable data it's good practice to periodically back up the SavedVariables.lua file.
