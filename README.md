# LootLoggerClassic

LootLoggerClassic logger loot du får i WoW Classic Era og lagrer historikk lokalt.

Addonen kan vise loot i et eget vindu med søk, filter, statistikk og minimap-knapp.

## Versjon

1.0

## Hva den gjør

- Logger loot når du får item i chat (`CHAT_MSG_LOOT`)
- Lagrer item, antall, tid, dato og zone i `SavedVariables`
- Viser loot i scrollable UI
- Har rarity-filter (All, Common, Uncommon, Rare, Epic)
- Har søk på item-navn
- Viser total loot og session loot
- Har draggable hovedvindu
- Har minimap-knapp for å åpne/lukke UI

## Kommandoer

- `/lootlogger` åpner/lukker hovedvinduet
- `/lltest` printer de 5 siste entries i chat
- `/llhistory` printer hele historikken i chat
- `/llclear` tømmer loot-databasen

## Installasjon

1. Last ned eller kopier mappen `LootLoggerClassic`
2. Legg mappen i:
   `World of Warcraft\_classic_era_\Interface\AddOns\`
3. Start spillet og sjekk at addonen er aktiv i AddOns-listen
4. Skriv `/lootlogger` i chat for å åpne UI

## Data som lagres

Data lagres i `LootLoggerClassicDB`.

Hver entry inneholder:

- item link
- quantity
- time
- date
- zone

## Plan videre

Nåværende TODO-liste er ferdig.

Mulige neste steg:

- Interface options panel i spillmenyen
- Bedre eksport eller sortering av historikk
- Små UI-forbedringer og tema-valg
