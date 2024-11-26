## ItemDataCollector

The addon fetches item data through the game’s API and tooltip and saves the collected data into a `SavedVariables.lua` file located in the WTF directory (e.g.  `World of Warcraft 3.3.5\WTF\Account\<Account_name>\SavedVariables.lua`). Since not all item information is accessible through the API, addon also extracts additional information via tooltip, capturing all relevant data.

### Usage

1. Download and Install the Addon: Download the `ItemDataCollector` addon and place it in your WoW AddOns directory.
2. Launch the Game with the Datamining library: Run the game using the datamining [Library](https://github.com/robinsch/ListfileGen335/) with [dll_injector32](https://github.com/hasherezade/dll_injector) and make sure the addon is loaded in the game!
3. Play and Interact: While playing, interact with as many items as possible, focusing especially on custom items.

### How It Works:

* The addon gathers item data through the game’s API and tooltips, storing the collected information in a `SavedVariables.lua` file located in the WTF directory -> `World of Warcraft 3.3.5\WTF\Account\<Account_Name>\SavedVariables.lua`.
* To collect item data, you can either loot the item, click on the item or hover a mouse over it to display tooltip. If the item was posted in chat, you MUST DOUBLE-LEFT-CLICK on it to gather the data! Clicking only once won't work!
* To avoid cluttering the data with low-value items, the addon is designed to only log items of uncommon quality(non-trash) or higher.
* The file won't be overwritten between game sessions, BUT to prevent potentially losing valuable data from rare or important items periodically back up the `SavedVariables.lua` file -> `SavedVariables_<yourDiscordName><number>.lua` -> e.g. `SavedVariables_emity1.lua`, `SavedVariables_emity2.lua` and so on.
