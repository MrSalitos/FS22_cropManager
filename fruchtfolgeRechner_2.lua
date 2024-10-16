-- Einordnung der Feldfrüchte in Familien
local fruchtfolge = {
  { name = "Getreide", fruchtarten = { "Weizen", "Gerste", "Hafer", "Roggen", "Triticale", "Hirse", "Sonnenblumen", "Sojabohnen", "Mais", "Zuckerrohr" } },
  { name = "Wurzelfrüchte", fruchtarten = { "Kartoffeln", "Zuckerrüben" } },
  { name = "Grünland", fruchtarten = { "Gras", "Klee" } },
  { name = "Gemüse", fruchtarten = { "Zwiebeln", "Karotten" } },
  { name = "Obst", fruchtarten = { "Trauben", "Oliven" } },
  { name = "Sonstige", fruchtarten = { "Raps", "Pappel", "Ölrettich", "Sorghum" } }
}
	
-- Einordnung der Feldfrüchte nach Nährstoffbedarf (Vereinfacht)
local frucht_kategorien = {
  Weizen = "Starkzehrer",
  Gerste = "Mittelzehrer",
  Hafer = "Schwachzehrer",
  Roggen = "Mittelzehrer",
  Triticale = "Mittelzehrer",
  Hirse = "Schwachzehrer",
  Sonnenblumen = "Mittelzehrer",
  Sojabohnen = "Mittelzehrer",
  Mais = "Starkzehrer",
  Zuckerrohr = "Starkzehrer",
  Kartoffeln = "Starkzehrer",
  Zuckerrüben = "Starkzehrer",
  Gras = "Mittelzehrer",
  Klee = "Schwachzehrer",
  Zwiebeln = "Mittelzehrer",
  Karotten = "Schwachzehrer",
  Trauben = "Schwachzehrer",  -- Nährstoffbedarf variiert je nach Sorte
  Oliven = "Schwachzehrer",  -- Nährstoffbedarf variiert je nach Sorte
  Raps = "Starkzehrer",
  Pappel = "Schwachzehrer",
  Ölrettich = "Mittelzehrer",
  Sorghum = "Mittelzehrer"
}

-- Tabelle, die die vorhandenen Felder mit Namen, ihrer Größe und die jeweils aktuelle, letzte und nächste Frucht enthält
local felder = {
  { name = "Feld 1", size = 1.2, crop = "Weizen", lastCrop = "Gerste", nextCrop = "" },
  { name = "Feld 2", size = 2.3, crop = "Gerste", lastCrop = "Raps", nextCrop = "" },
  { name = "Feld 3", size = 0.8, crop = "Raps", lastCrop = "Weizen", nextCrop = "" },
  { name = "Feld 4", size = 4.2, crop = "Weizen", lastCrop = "Gerste", nextCrop = "" },
  { name = "Feld 5", size = 3.4, crop = "Gerste", lastCrop = "Raps", nextCrop = "" },
  { name = "Feld 6", size = 1.8, crop = "Raps", lastCrop = "Weizen", nextCrop = "" },
  { name = "Feld 7", size = 2.0, crop = "Weizen", lastCrop = "Gerste", nextCrop = "" },
  { name = "Feld 8", size = 1.6, crop = "Gerste", lastCrop = "Raps", nextCrop = "" },
  { name = "Feld 9", size = 1.4, crop = "Raps", lastCrop = "Weizen", nextCrop = "" }
}

-- Tabelle, die die benötigte Anbaufläche in Hektar(ha) für bestimmte Feldfrüchte enthält
local anbau = {
  { crop = "Gerste", area = 4 },
  { crop = "Mais", area = 5 },
  { crop = "Raps", area = 6 }
}

-- Funktion zum Anzeigen vorhandener Felder
function fieldsShow(felder)
  for i = 1, #felder do
	print("\n------------------------------------------------")
    print(felder[i].name .. "\t\t| Göße: " .. felder[i].size .. " ha")
	print("Vorfrucht:\t| " .. felder[i].lastCrop)
	print("Aktuell:\t| " .. felder[i].crop)
	print("Folgefrucht:\t| " .. felder[i].nextCrop)
  end
end

--Funktion zum Anlegen neuer Felder
function fieldCreate()
  local inputNeuesFeld = io.read()
  local inputIterator = inputNeuesFeld:gmatch("([^;]+)")
  local neuesFeldName = inputIterator()
  local neuesFeldFrucht = inputIterator()
  local neuesFeldZustand = tonumber(inputIterator())
  --print ("Feldname eingeben: ")
  --local neuesFeldName = string.gmatch()
  --print ("Angebaute Fruchtart: ")
  --local neuesFeldFrucht = io.read()
  --print ("Aktueller Zustand des Feldes: ")
  --local neuesFeldZustand = tonumber(io.read())
  local neuesFeld = {name = neuesFeldName, frucht = neuesFeldFrucht, zustand = neuesFeldZustand}

  table.insert(felder, neuesFeld)
end

--Funktion zum Bearbeiten eines Feldes
function fieldEdit(index, neueFrucht, neuerZustand)
  local inputFieldEdit = io.read()
  local inputIterator = inputFieldEdit:gmatch("([^;]+)")
  index = tonumber(inputIterator())
  neueFrucht = inputIterator()
  neuerZustand = tonumber(inputIterator())
  --local name = "Feld " .. index
  --local bearbeitetesFeld = {name=name, frucht=neueFrucht, zustand=neuerZustand}
  --table.remove(felder, index)
  --table.insert(felder, index, bearbeitetesFeld)
  felder[index].frucht = neueFrucht
  felder[index].zustand = neuerZustand
end

--Funktion zum Löschen des Feldes unter Angabe des index
function fieldDelete(index)
  print("Bitte gib die Nummer des Feldes ein, das gelöscht werden soll:")
  index = tonumber(io.read())
  if index ~= nil and index <= #felder and index >= 1 then
    table.remove(felder, index)
    print("Das Feld wurde gelöscht.")
  else
    print("Der Eingegebene Feld-Index exisitert nicht")
  end
end

--Funktion zum Berechnen der Fruchtfolge
function berechneFruchtfolge(anbau, fruchtfolge, felder)
  local ergebnis = {}
  local restflaechen = {}

  -- Initialisiere restflaechen mit den Werten aus anbau
  for _, eintrag in ipairs(anbau) do
    restflaechen[eintrag.crop] = eintrag.area
  end

  -- Berechne die Gesamtfläche aller Felder
  local gesamtflaeche = 0
  for _, feld in ipairs(felder) do
    gesamtflaeche = gesamtflaeche + feld.size
  end

  -- Berechne die Fläche für Weizen
  local flaecheWeizen = gesamtflaeche
  for _, eintrag in ipairs(anbau) do
    flaecheWeizen = flaecheWeizen - eintrag.area
  end
  restflaechen["Weizen"] = flaecheWeizen

  for i, feld in ipairs(felder) do
    local kategorieIndex = nil
    local letzteFruchtKategorie = nil
    for j, kategorie in ipairs(fruchtfolge) do
      if table.indexOf(kategorie.fruchtarten, feld.lastCrop) ~= nil then
        letzteFruchtKategorie = j
        break
      end
    end

    if letzteFruchtKategorie then
      kategorieIndex = letzteFruchtKategorie + 1
      if kategorieIndex > #fruchtfolge then
        kategorieIndex = 1
      end
    else
      kategorieIndex = 1
    end

    local gefunden = false
    while not gefunden do
      local kategorie = fruchtfolge[kategorieIndex]
      for _, frucht in ipairs(kategorie.fruchtarten) do
        if restflaechen[frucht] >= feld.size and frucht ~= feld.lastCrop then
          table.insert(ergebnis, {feld = feld.name, frucht = frucht})
          restflaechen[frucht] = restflaechen[frucht] - feld.size
          gefunden = true
          break
        end
      end

      kategorieIndex = kategorieIndex + 1
      if kategorieIndex > #fruchtfolge then
        kategorieIndex = 1
      end
      if kategorieIndex == letzteFruchtKategorie then
        break
      end
    end

    if not gefunden then
      table.insert(ergebnis, {feld = feld.name, frucht = "Keine passende Frucht gefunden"})
    end
  end

  return ergebnis
end

function mainMenu()
  while true do
    print("\nHauptmenü:")
    print("1. Felder anzeigen")
    print("2. Feld anlegen")
    print("3. Feld bearbeiten")
    print("4. Feld löschen")
    print("5. Fruchtfolge berechnen")
    print("0. Beenden")

    local menuInput = tonumber(io.read())

    if menuInput == 1 then
      fieldsShow(felder)
    elseif menuInput == 2 then
      fieldCreate()
    elseif menuInput == 3 then
      fieldEdit()
    elseif menuInput == 4 then
      fieldDelete()
    elseif menuInput == 5 then
      berechneFruchtfolge()  -- Fruchtfolge-Rechner aufrufen
    elseif menuInput == 0 then
      break
    else
      print("Ungültige Eingabe")
    end
  end
end

mainMenu()
