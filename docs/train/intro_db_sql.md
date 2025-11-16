# Grundlagen: Datenbanken, Relationale Modelle & SQL

**Kurzüberblick für die Java-JDBC Ausbildung**

---

## 1. Was ist eine Datenbank?

Eine **Datenbank** ist ein System zur **strukturierten Speicherung**, **Verwaltung** und **Abfrage** von Daten.
Ziele:

* Daten sicher speichern
* schnell finden und filtern
* konsistent halten
* mehreren Benutzern gleichzeitig Zugriff ermöglichen

Typische Eigenschaften:

* **Persistenz** (Daten bleiben auch nach Neustart erhalten)
* **Verlässlichkeit** (keine Datenkorruption)
* **Strukturierung** (Tabellen, Dokumente, Graphen …)
* **Skalierbarkeit**
* **Transaktionen** für sichere Änderungen

---

## 2. Was ist eine relationale Datenbank?

Eine **relationale Datenbank (RDBMS)** speichert Daten in **Tabellen**, die zueinander in Beziehung („Relation“) stehen.

**Eigenschaften:**

* Tabellen bestehen aus **Zeilen (Rows)** und **Spalten (Columns)**
* Jede Tabelle hat einen **Primärschlüssel (Primary Key)**
* Beziehungen zwischen Tabellen erfolgen über **Fremdschlüssel (Foreign Keys)**
* Modell basiert auf dem mathematischen **Relationenmodell**

**Beispiele für RDBMS:**

* PostgreSQL
* MySQL / MariaDB
* Oracle
* SQL Server
* H2 (für Tests / Java-Projekte)

---

## 3. Warum relationale Datenbanken?

* **Strukturierte Daten**
* **Schnelle Abfragen** durch Indizes
* **Hohe Datensicherheit**
* **Transaktionen** → garantierte Konsistenz
* **Standardisierte Abfragesprache SQL**

Relationale Datenbanken sind die Basis der meisten Enterprise-Anwendungen (Banken, Behörden, Shops, ERP, …).

---

## 4. SQL – Structured Query Language

SQL ist die **Standardsprache**, um Daten in relationalen Datenbanken zu:

* erstellen
* abfragen
* ändern
* löschen

**SQL ist deklarativ** → man beschreibt *was* man will, nicht *wie* es intern ausgeführt wird.

---

## 5. SQL Befehle nach Kategorien (DML / DDL / DCL / TCL)

### **DDL – Data Definition Language**

Struktur des Schemas ändern:

```sql
CREATE TABLE users (...);
ALTER TABLE users ADD COLUMN age INT;
DROP TABLE users;
```

### **DML – Data Manipulation Language**

Daten lesen und manipulieren:

```sql
SELECT * FROM users;
INSERT INTO users VALUES (...);
UPDATE users SET name='Chris';
DELETE FROM users WHERE id=1;
```

### **DCL – Data Control Language**

Zugriffsrechte:

```sql
GRANT SELECT ON users TO app_user;
REVOKE INSERT ON users FROM guest;
```

### **TCL – Transaction Control Language**

Transaktionen steuern:

```sql
COMMIT;
ROLLBACK;
SAVEPOINT step1;
```

---

## 6. Wichtige SQL-Begriffe für Anfänger

### **Primary Key**

Eindeutige Identifikation einer Zeile.

### **Foreign Key**

Verweist auf eine andere Tabelle → Beziehungen.

### **Unique Constraint**

Wert darf in dieser Spalte nur einmal vorkommen.

### **NOT NULL**

Spalte darf nicht leer sein.

### **Index**

Beschleunigt Suchen und Filtern.

### **View**

Virtuelle Tabelle basierend auf einer Abfrage.

### **Schema**

Namensraum für Tabellen & Objekte.

---

## 7. Tabellen, Zeilen, Spalten – Beispiel

```sql
CREATE TABLE customer (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(200) UNIQUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

* **customer** ist die Tabelle
* **id, name, email, created_at** sind Spalten
* Jede eingefügte Kundenzeile ist ein **Datensatz**

---

## 8. Beziehungen zwischen Tabellen

### 1:1 – genau ein zu einem

### 1:n – häufigstes Modell

### n:m – über Join-Tabellen

Beispiel 1:n:

```sql
CREATE TABLE orders (
    id         SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer(id),
    amount     DECIMAL(10,2)
);
```

---

## 9. Wichtige SQL-Abfragen

### SELECT – Daten lesen

```sql
SELECT name, email FROM customer WHERE name LIKE 'A%';
```

### INSERT – Daten schreiben

```sql
INSERT INTO customer (name, email)
VALUES ('Anna', 'anna@example.com');
```

### UPDATE – Daten ändern

```sql
UPDATE customer SET name = 'Chris S.' WHERE id = 5;
```

### DELETE – Daten löschen

```sql
DELETE FROM customer WHERE id = 5;
```

---

## 10. JOINs – Tabellen verbinden

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

## 11. ACID – Warum Transaktionen wichtig sind

**A**tomicity – alles oder nichts
**C**onsistency – DB bleibt widerspruchsfrei
**I**solation – parallele Transaktionen stören sich nicht
**D**urability – nach COMMIT dauerhaft gespeichert

Diese Prinzipien garantieren **Datensicherheit**, auch bei Fehlern, Crashs oder Stromausfällen.

---

## 12. Kurze Vorbereitung auf JDBC

Schüler sollen vorab verstehen:

* Was ein **Connection Pool** ist
* Was ein **Connection-Objekt** macht (Verbindung zur DB)
* Statement-Typen: `Statement`, `PreparedStatement`, `CallableStatement`
* ResultSet → Daten auslesen Zeile für Zeile
* Umgang mit SQL-Exceptions
* Wichtig: **immer schließen** (oder try-with-resources)

---

## 13. Beispiel: Einfache JDBC-Abfrage

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

# Ende

Dieses Dokument dient als **Kurzüberblick** vor Einstieg in die Java-JDBC-Praxis.

---

Wenn Du willst, kann ich daraus **sofort ein PDF erzeugen** (CGS-Blue Styling, Logo, Titelseite). Soll ich das PDF jetzt generieren?
