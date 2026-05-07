# 🎵 Festival – Progettazione Database E-R & SQL

Progetto universitario di progettazione e implementazione di un database relazionale per la gestione di un **festival musicale**, dalla modellazione E-R fino alle query SQL avanzate.

---

## 📌 Obiettivo

Modellare e implementare un sistema di gestione completo per un festival musicale, coprendo: palchi, performance, artisti, staff, spettatori, biglietteria, ordini, pagamenti e sponsor.

---

## 🗂️ Schema E-R
<img width="1685" height="799" alt="image" src="https://github.com/user-attachments/assets/ec9dce8b-8911-4310-b8c9-ac5e0d5515c3" />

---

## 🏗️ Struttura del Database

Il database `festival` è composto da **10 tabelle** con relazioni N-M, vincoli di integrità referenziale e regole di business implementate tramite `CHECK` ed `ENUM`.

```
Palco ──────────── Performance ──────────── Biglietto
  │                     │                      │
Staff             Partecipazione            Ordine
                  (N-M Artista)               │
Artista ──────────────────────            Pagamento
  │
Sponsorizzazione ──── Sponsor
```

### Entità principali

| Tabella | Descrizione |
|---|---|
| `Palco` | Strutture fisiche del festival con denominazione e località |
| `Performance` | Eventi associati a un palco con data |
| `Artista` | Artisti singoli o band (gestione `CHECK` per Nome/Cognome vs Identificativo) |
| `Partecipazione` | Relazione N-M tra Artista e Performance |
| `Staff` | Personale assegnato a un palco con mansione |
| `Spettatore` | Utenti registrati con codice fiscale univoco |
| `Biglietto` | Titoli d'accesso legati a Performance e Ordine |
| `Ordine` | Acquisti effettuati da uno Spettatore |
| `Pagamento` | Transazioni con stato (`In verifica`, `Autorizzato`, `Completato`, `Rifiutato`, `Cancellato`) |
| `Sponsor` / `Sponsorizzazione` | Sponsor associabili a Performance e/o Artista |

### Scelte progettuali rilevanti

- **`ON DELETE RESTRICT`** su Palco→Performance e Spettatore→Ordine: impedisce la cancellazione di entità con dati dipendenti attivi
- **`ON DELETE CASCADE`** su Ordine→Biglietto e Performance→Biglietto: rimuove automaticamente i biglietti orfani
- **`ON DELETE SET NULL`** su Ordine→Pagamento: preserva la storia dell'ordine anche se il pagamento viene rimosso
- **`CHECK` su Artista**: vincolo che garantisce la presenza di Nome+Cognome oppure Identificativo (per le band)
- **`ENUM` su Pagamento.Stato**: stati del ciclo di vita di una transazione

---

## 📡 Query implementate

| # | Descrizione | Tecniche utilizzate |
|---|---|---|
| 1 | Numero di partecipazioni per artista | `JOIN`, `GROUP BY`, `COUNT` |
| 2 | Incasso totale per giorno (solo pagamenti completati) | `JOIN` multiplo, `WHERE`, `GROUP BY`, `ORDER BY` |
| 3 | Artisti che hanno suonato su più di un palco | `JOIN`, `GROUP BY`, `HAVING`, `COUNT DISTINCT` |
| 4 | Palco con il maggior numero di spettatori | `JOIN`, `GROUP BY`, `ORDER BY DESC`, `LIMIT` |
| 5 | Artista con il maggior incasso in biglietti | `JOIN`, `COALESCE`, `SUM`, `ORDER BY DESC`, `LIMIT` |
| 6 | Coppie di artisti che hanno collaborato ≥ 2 volte | **Self-join** su Partecipazione, `HAVING` |
| 7 | Sponsor attivi in almeno 3 giorni diversi | `JOIN`, `GROUP BY`, `HAVING COUNT` |
| 8 | Palco con incasso più alto per ogni giorno | **CTE** (`WITH`), subquery correlata |

---

## 🛠️ Stack Tecnologico

| Componente | Tecnologia |
|---|---|
| Database | MySQL 8.0 |
| Modellazione | Draw.io (diagramma E-R) |
| Query | SQL standard + CTE, self-join, subquery correlate |

---

## 🚀 Avvio

### Prerequisiti
- MySQL 8.0+

### Setup

```bash
mysql -u root -p < "festival - SQL.sql"
```

Il file esegue in sequenza: drop/create del database, creazione delle tabelle, insert dei dati di esempio, esecuzione delle query.

---

## 📁 Struttura del repository

```
festival_ER/
  ├── festival - SQL.sql         # Schema, dati e query
  └── festival - ER.drawio       # Sorgente editabile del diagramma
```

---

## 👤 Autore

**Vito Bondanese**
- GitHub: [@vitob99](https://github.com/vitob99)
- LinkedIn: [vito-bondanese](https://www.linkedin.com/in/vito-bondanese-24b673360/)
