<p align="center">
  <img src="https://raw.githubusercontent.com/chris-cgsit/cgs-it-scripts-public/main/images/cgsit/logos/Logo-JPEG-small.png" width="140">
</p>

# CGS IT – Grundlagen zu Datenbanken, Relationalen Modellen & SQL

### *Kurzüberblick für die Java-JDBC Ausbildung*

---

# 1. Was ist eine Datenbank?

Eine **Datenbank** ist ein System zur **dauerhaften, strukturierten Speicherung** von Daten.
Sie stellt sicher, dass Daten:

* **strukturiert abgelegt** werden
* **schnell gefunden** und abgefragt werden können
* **mehreren Nutzern gleichzeitig** zur Verfügung stehen
* **konsistent und sicher** gespeichert werden
* auch nach Abstürzen weiterhin **korrekt und vollständig** verfügbar sind

## 1.1 Was ist eine Tabelle?

Eine **Tabelle** ist die zentrale Struktureinheit einer relationalen Datenbank.

Sie besteht aus:

* **Spalten (Columns)**
  → definieren Datentyp und Struktur
* **Zeilen (Rows)**
  → enthalten die konkreten Daten (Datensätze)

Beispiel:

| id | name | email | created_at |
| -- | ---- | ----- | ---------- |

Eine Tabelle funktioniert ähnlich wie ein Excel-Sheet — allerdings **streng typisiert**, formal definiert und unter voller Transaktionskontrolle.

## 1.2 Was ist eine Relation?

Eine **Relation** bezeichnet die **Beziehung zwischen zwei Tabellen**, z. B.:

* Ein Kunde kann **viele Bestellungen** haben (1:n)
* Viele Studenten besuchen viele Kurse (n:m)

Relationen werden durch **Primary Keys** (PK) und **Foreign Keys** (FK) hergestellt und durch **referenzielle Integrität** abgesichert.

---

# 2. Was ist eine relationale Datenbank?

Eine **relationale Datenbank (RDBMS)** speichert Daten in **Tabellen**, die durch Relationen miteinander verbunden sind.

Charakteristisch:

* tabellenbasierte, strukturierte Daten
* klare Beziehungen (Relationen)
* konsistente Transaktionen
* SQL als standardisierte Abfragesprache
* geeignet für große, sichere und komplexe IT-Systeme

Beispiele für relationale Datenbanksysteme:

* PostgreSQL
* Oracle
* MySQL / MariaDB
* Microsoft SQL Server
* H2 Database (Java In-Memory/Embedded)

---

# 3. Warum relationale Datenbanken?

* **klare, strukturierte Datenorganisation**
* **sehr gute Performance** bei Abfragen durch Indizes
* **ACID-Transaktionen** für absolute Datenkonsistenz
* **sicheres Mehrbenutzer-Verhalten**
* **Standardisierung durch SQL**
* **starkes Tool-Ökosystem** (CLI, Admin-Tools, Monitoring)

RDBMS sind die Basis für Enterprise-Software, Web-Plattformen, Behörden-Systeme und nahezu alle professionellen Datenarchitekturen.

# 4.1. Wie greift Java via JDBC auf die Datenbank zu

<p align="center">
  <img src="https://raw.githubusercontent.com/chris-cgsit/cgs-it-scripts-public/main/docs/train/dbd_laers.png" width="300"><br>
  <em>Abbildung: JDBC Layer Architektur</em>
</p>

### Der Zugriff erfolgt in mehreren klar getrennten Schichten:

- Application Logic erstellt über die JDBC-API eine Verbindung zur Datenbank (Connection).
- Über ein PreparedStatement sendet Java SQL-Befehle an den JDBC-Treiber.
- Der JDBC-Treiber übersetzt diese Befehle in das native Datenbankprotokoll (z. B. PostgreSQL oder Oracle Binary Protocol).
- Über die TCP/IP-Verbindung werden die SQL-Kommandos an den Datenbankserver übertragen.
- Die Datenbank führt das SQL aus, verarbeitet Transaktionen und liefert die Ergebnisse zurück.
- Der JDBC-Treiber verpackt die Antwort in ein ResultSet, das in Java weiterverarbeitet werden kann.
- Damit kapselt JDBC alle Details der Netzwerkkommunikation und ermöglicht einen einheitlichen, 
standardisierten Datenbankzugriff, unabhängig vom jeweiligen Datenbanksystem.


---

# 4. SQL – Structured Query Language

SQL ist die **standardisierte Sprache**, um Datenbanken zu steuern.

Sie umfasst:

* **DDL – Data Definition Language**
  Tabellen & Strukturen erzeugen/ändern/löschen
* **DML – Data Manipulation Language**
  Daten lesen, einfügen, ändern, löschen
* **DCL – Data Control Language**
  Rechte & Benutzerverwaltung
* **TCL – Transaction Control Language**
  Commit / Rollback / Savepoints

SQL ist **deklarativ** — man beschreibt WAS man will, nicht WIE.

---

# 5. SQL-Befehle mit Beispielen

## 5.1 DDL – Tabellen und Strukturen definieren

```sql
CREATE TABLE customer (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(200) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE customer ADD COLUMN phone VARCHAR(50);

DROP TABLE customer;
```

## 5.2 DML – Daten abfragen und manipulieren

### SELECT

```sql
SELECT id, name FROM customer WHERE name LIKE 'A%';
```

### INSERT

```sql
INSERT INTO customer (name, email)
VALUES ('Anna', 'anna@example.com');
```

### UPDATE

```sql
UPDATE customer SET name = 'Chris S.' WHERE id = 5;
```

### DELETE

```sql
DELETE FROM customer WHERE id = 5;
```

## 5.3 DCL – Rechteverwaltung

```sql
GRANT SELECT ON customer TO student;
REVOKE INSERT ON customer FROM student;
```

## 5.4 TCL – Transaktionen

```sql
BEGIN;
UPDATE customer SET name='Test';
ROLLBACK;

BEGIN;
UPDATE customer SET name='Final';
COMMIT;
```

---

# 6. Wichtige SQL-Grundbegriffe

| Begriff              | Bedeutung                                  |
| -------------------- | ------------------------------------------ |
| **Primary Key (PK)** | Eindeutige Zeilenidentifikation            |
| **Foreign Key (FK)** | Verweist auf PK in anderer Tabelle         |
| **Unique**           | Wert darf nicht doppelt vorkommen          |
| **NOT NULL**         | Spalte darf keinen leeren Wert haben       |
| **Index**            | Beschleunigt Suchabfragen                  |
| **View**             | Virtuelle Tabelle basierend auf SELECT     |
| **Schema**           | Namensraum für Tabellen und DB-Objekte     |
| **Constraint**       | Regel zur Sicherstellung von Datenqualität |

---

# 7. Tabellen und Beziehungen

## 7.1 Beispieltabelle

```sql
CREATE TABLE customer (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(200)
);
```

## 7.2 1:n Beziehung (Kunde → Bestellungen)

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer(id),
    amount DECIMAL(10,2)
);
```

## 7.3 JOINs

### INNER JOIN

```sql
SELECT c.name, o.amount
FROM customer c
JOIN orders o ON o.customer_id = c.id;
```

### LEFT JOIN

```sql
SELECT c.name, o.amount
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.id;
```

---

# 8. ACID – die vier Grundprinzipien

* **Atomicity** – alles oder nichts
* **Consistency** – Daten bleiben regelkonform
* **Isolation** – parallele Transaktionen sind getrennt
* **Durability** – Änderungen bleiben dauerhaft erhalten

---

# 9. JDBC – Grundlagen für Java-Schüler

Vorbereitungswissen:

* Eine JDBC-**Connection** öffnet die Verbindung zur Datenbank
* Ein **PreparedStatement** führt SQL sicher aus
* Ein **ResultSet** liefert die Daten zurück
* Fehler werden über **SQLException** behandelt
* Ressourcen müssen **geschlossen** werden
  (Empfohlen: try-with-resources)

### Beispiel:

```java
try (Connection con = DriverManager.getConnection(url, user, pass);
     PreparedStatement ps = con.prepareStatement("SELECT id, name FROM customer");
     ResultSet rs = ps.executeQuery()) {

    while (rs.next()) {
        System.out.println(rs.getInt("id") + " - " + rs.getString("name"));
    }
}
```

---

# 10. Wichtige Links für Schüler

## 10.1 PostgreSQL

* Website: [https://www.postgresql.org/](https://www.postgresql.org/)
* Dokumentation: [https://www.postgresql.org/docs/](https://www.postgresql.org/docs/)
* SQL-Befehle: [https://www.postgresql.org/docs/current/sql-commands.html](https://www.postgresql.org/docs/current/sql-commands.html)
* Tutorial: [https://www.postgresql.org/docs/current/tutorial.html](https://www.postgresql.org/docs/current/tutorial.html)
* Download: [https://www.postgresql.org/download/](https://www.postgresql.org/download/)

---

## 10.2 Oracle Database

* Website: [https://www.oracle.com/database/](https://www.oracle.com/database/)
* Dokumentation: [https://docs.oracle.com/en/database/](https://docs.oracle.com/en/database/)
* SQL Language Reference:
  [https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/index.html](https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/index.html)
* XE Download:
  [https://www.oracle.com/database/technologies/xe-downloads.html](https://www.oracle.com/database/technologies/xe-downloads.html)

---

## 10.3 H2 Database (sehr wichtig für Java/Quarkus/Spring Tests)

* Website: [https://www.h2database.com/](https://www.h2database.com/)
* Dokumentation: [https://www.h2database.com/html/main.html](https://www.h2database.com/html/main.html)
* SQL Features: [https://www.h2database.com/html/commands.html](https://www.h2database.com/html/commands.html)
* Embedded Mode Tutorial:
  [https://www.h2database.com/html/features.html](https://www.h2database.com/html/features.html)

---

## 10.4 SQL Standard (ANSI/ISO)

### Kostenpflichtiger offizieller Standard:

* ISO/IEC 9075: [https://www.iso.org/standard/76583.html](https://www.iso.org/standard/76583.html)

### Kostenlose, hochwertige Erklärungen:

* SQL Überblick: [https://en.wikipedia.org/wiki/SQL](https://en.wikipedia.org/wiki/SQL)
* SQL-Standard Übersicht: [https://en.wikipedia.org/wiki/ISO/IEC_9075](https://en.wikipedia.org/wiki/ISO/IEC_9075)
* Modern SQL (sehr gute Quelle): [https://modern-sql.com/](https://modern-sql.com/)

---

## 10.5 SQL Tutorials für Einsteiger

* SQLBolt (interaktiv): [https://sqlbolt.com/](https://sqlbolt.com/)
* W3Schools SQL Tutorial: [https://www.w3schools.com/sql/](https://www.w3schools.com/sql/)
* TutorialsPoint SQL: [https://www.tutorialspoint.com/sql/index.htm](https://www.tutorialspoint.com/sql/index.htm)

---

<a href="https://cgs.at" target="_blank">
  <img src="https://raw.githubusercontent.com/chris-cgsit/cgs-it-scripts-public/main/images/cgsit/logos/Logo-JPEG-small.png" width="140">
</a>

> Besuch uns auf der offiziellen Website:  
> [https://cgs.at](https://cgs.at)

[CGS IT Solutions GmbH – https://cgs.at](https://cgs.at)

---
---






