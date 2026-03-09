# LootLoggerClassic – TODO

A **World of Warcraft Classic addon** that logs all loot received and stores it in a persistent history.

---

# Phase 1 – Basic Addon Setup

## Goal

Make sure the addon loads correctly in the game.

### Tasks

* [ ] Create addon folder `LootLoggerClassic`
* [ ] Create `LootLoggerClassic.toc`
* [ ] Add lua files to `.toc`

Example:

```
## Interface: 11507
## Title: LootLoggerClassic
## Notes: Logs all loot you receive.
## Author: Audun
## Version: 1.0
## SavedVariables: LootLoggerClassicDB

core.lua
database.lua
events.lua
UI.lua
```

* [ ] Verify addon appears in WoW AddOn list
* [ ] Add basic load test in `core.lua`

Example:

```lua
print("LootLoggerClassic loaded!")
```

* [ ] Confirm message prints in chat when logging in

---

# Phase 2 – Database System

## Goal

Create a database that persists between play sessions.

### Tasks

* [ ] Define SavedVariables in `.toc`

```
## SavedVariables: LootLoggerClassicDB
```

* [ ] Initialize database in `database.lua`

Example:

```lua
LootLoggerClassicDB = LootLoggerClassicDB or {}
LootLoggerClassicDB.loot = LootLoggerClassicDB.loot or {}
```

* [ ] Create function `AddLootEntry(itemLink, quantity)`

Each entry should store:

* item link
* quantity
* time
* date
* zone

Example structure:

```lua
{
  item = itemLink,
  quantity = amount,
  time = date("%H:%M:%S"),
  date = date("%Y-%m-%d"),
  zone = GetZoneText()
}
```

---

# Phase 3 – Detect Loot Events

## Goal

Detect when the player receives loot.

### Tasks

* [ ] Register event `CHAT_MSG_LOOT`
* [ ] Detect if the message belongs to the player
* [ ] Extract:

  * item link
  * quantity
* [ ] Call `AddLootEntry()` when loot is detected

Test with:

```
/reload
```

Then loot mobs and confirm entries are saved.

---

# Phase 4 – Debug Commands

## Goal

Make testing easier.

### Tasks

* [ ] Create slash command `/lltest`
* [ ] Print the last 5 loot entries
* [ ] Create slash command `/llclear`
* [ ] Clear the database for testing

---

# Phase 5 – Loot History UI

## Goal

Display loot history in a window.

### Tasks

* [ ] Create main frame in `UI.lua`
* [ ] Set frame size and position
* [ ] Add backdrop
* [ ] Add title **"Loot History"**
* [ ] Add scroll frame for many entries
* [ ] Populate UI with loot entries

Each row should display:

```
[Time] Item Name xAmount
```

Example:

```
[14:32] Linen Cloth x3
```

---

# Phase 6 – Item Quality Colors

## Goal

Color loot based on rarity.

### Tasks

* [ ] Use `GetItemInfo(itemLink)`
* [ ] Get item quality
* [ ] Apply color using:

```lua
ITEM_QUALITY_COLORS
```

Example colors:

* Grey – Poor
* White – Common
* Green – Uncommon
* Blue – Rare
* Purple – Epic

---

# Phase 7 – Advanced Features

Optional improvements.

### Possible Features

* [ ] Filter by item rarity
* [ ] Filter by zone
* [ ] Search by item name
* [ ] Show total number of items looted
* [ ] Show most common item
* [ ] Show rarest item
* [ ] Export loot history to chat

---

# Phase 8 – Polish

## Goal

Make the addon feel complete.

### Tasks

* [ ] Add slash command `/lootlogger`
* [ ] Open loot history window
* [ ] Add close button
* [ ] Allow ESC to close window
* [ ] Improve layout and spacing
* [ ] Test in:

  * solo play
  * party
  * dungeon
  * raid

---

# Final Goal

A complete addon that:

✔ Logs every item you loot
✔ Saves loot history permanently
✔ Displays loot history in a clean UI
✔ Supports filtering and statistics

---

# Learning Goals

Through this project you will practice:

* WoW Events
* Lua Tables
* SavedVariables
* Frame UI creation
* ScrollFrames
* Slash commands
* Structuring a real addon project
