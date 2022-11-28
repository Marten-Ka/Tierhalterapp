// Auflistung der Tabellen mit ihrer Identifizierung
const krankheiten = "Krankheiten";
const krankheitstyp = "Krankheitstyp";
const pferdegeschlecht = "Pferdegeschlecht";
const pferderasse = "Pferderasse";
const symptom = "Symptom";

// Namen der Tabellen
Map<String, String> tableNames = {
  krankheiten: "Pferde-Krankheiten",
  krankheitstyp: "Arten von Krankheiten",
  pferdegeschlecht: "Geschlecht",
  pferderasse: "Rasse",
  symptom: "Symptome",
};

// Spalten der Tabellen
Map<String, List<String>> tableColumns = {
  krankheiten: [
    "Id",
    "Name",
    "Krankheitstyp",
    "Synonyme",
    "Symptom Immer",
    "Symptom Häufig",
    "Symptom Selten",
    "Symptom Dauer (Wochen)",
    "Differenzialdiagnose",
    "Typische Rassen",
    "Geschlecht Ausschließlich",
    "Geschlecht Typisch",
    "Alter (Min)",
    "Alter (Max)",
    "Informationen",
    "Sofortmaßnahmen",
    "Krankheit Häufig",
    "Krankheit Selten",
  ],
  krankheitstyp: [
    "Id",
    "Krankheitstyp",
  ],
  pferdegeschlecht: [
    "Id",
    "Pferdegeschlecht"
  ],
  pferderasse: [
    "Id",
    "Pferderasse"
  ],
  symptom: [
    "Id",
    "Symptom"
  ],
};

// Haupttabellen
Set<String> mainTables = {
  krankheiten,
};

// welche Tabellen benötigten die Haupttabellen
Map<String, Set<String>> normalizedTables = {
  krankheiten: {
    krankheitstyp,
    pferdegeschlecht,
    pferderasse,
    symptom
  },
};
