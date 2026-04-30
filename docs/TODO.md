# LootLoggerClassic – TODO

# Phase 1 - Core Addon Setup

* [x] Create addon folder `LootLoggerClassic`
* [x] Create `LootLoggerClassic.toc`
* [x] Add lua files `core.lua, database.lua, events.lua, UI.lua`
* [x] Register `SavedVariables: LootLoggerClassicDB`
* [x] Add load message `print("LootLoggerClassic loaded!")`
* [x] Verify addon loads in game
* [x] Verify addon appears in AddOns list

---

# Phase 2 - Database System

* [x] Initialize database table `LootLoggerClassicDB`
* [x] Create sub-table `LootLoggerClassicDB.loot`
* [x] Create function `AddLootEntry(itemLink, quantity)`
* [x] Store item link
* [x] Store quantity
* [x] Store time `date("%H:%M:%S")`
* [x] Store date `date("%Y-%m-%d")`
* [x] Store zone `GetZoneText()`
* [x] Add debug print when loot is logged
* [x] Verify loot entries appear in database

---

# Phase 3 - Loot Event Detection

* [x] Register event `CHAT_MSG_LOOT`
* [x] Detect if loot belongs to the player
* [x] Extract item link from chat message
* [x] Extract quantity from chat message
* [x] Call `AddLootEntry()` when loot is detected
* [x] Test loot from mobs
* [x] Test loot from containers/chests
* [x] Test loot from gathering professions

---

# Phase 4 - Debug & Chat Commands

* [x] Create slash command `/lltest`
* [x] Print last 5 loot entries in chat
* [x] Create slash command `/llhistory`
* [x] Print full loot history
* [x] Create slash command `/llclear`
* [x] Clear loot database for testing

---

# Phase 5 - Loot History UI

* [x] Create main UI frame
* [x] Add title `Loot History`
* [x] Add background/backdrop
* [x] Add close button `esc`
* [x] Add scrollable loot list
* [x] Populate list with loot entries
* [x] Display `[time] item xquantity`
* [x] Add command `/lootlogger` to open UI

Example row:

```
[14:32] Linen Cloth x3
```

---

# Phase 6 - Item Quality & Visual Polish

* [x] Detect item quality `GetItemInfo()`
* [x] Apply item color using `ITEM_QUALITY_COLORS`
* [x] Highlight rare items
* [x] Add spacing and alignment improvements
* [x] Improve UI readability

---

# Phase 7 - Statistics System

* [x] Track total items looted
* [x] Show statistics in UI

---

# Phase 8 - Advanced Features

* [x] Add rarity filter `common/uncommon/rare/epic`
* [x] Add item name search
* [x] Add session loot counter

---

# Phase 9 - Advanced Polish

* [x] Add draggable UI window
* [x] Add minimap button
* [x] Add version number display in UI

---

# Final Goal

A complete addon that:

✔ Logs every item the player loots
✔ Stores loot history permanently
✔ Displays loot history in a scrollable UI
✔ Supports filtering, statistics, and export tools
