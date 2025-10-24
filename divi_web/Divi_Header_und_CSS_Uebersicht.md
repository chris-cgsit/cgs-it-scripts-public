# 📘 Divi Header & CSS Überblick

## 🔹 1. Hauptstruktur von Divi

Divi unterscheidet zwei Ebenen von Header-Bereichen:

| Bereich | Beschreibung | Typische CSS-Klassen |
|----------|---------------|----------------------|
| **Main Header** | Globaler Kopfbereich (Logo, Menü, Navigation) | `#main-header`, `#et-top-navigation`, `.et-fixed-header`, `.et_header_style_*` |
| **Sub-Header / Hero** | Seitenindividuelle Kopfzeile (z. B. Vollbreite Kopfzeile mit Text + Bild) | `.et_pb_fullwidth_header`, `.et_pb_fullwidth_header_container`, `.header-content`, `.header-image-container` |

---

## 🔹 2. Main Header (globales Menü & Logo)

### Typische Klassen & IDs
| Element | Beschreibung |
|----------|--------------|
| `#main-header` | Gesamter Primär-Header |
| `.et-fixed-header` | Zustand bei Sticky Header |
| `#top-header` | Top-Bar mit Social Icons / Kontakt |
| `#et-top-navigation` | Navigation (UL/LI-Menüstruktur) |
| `.et-menu`, `.nav` | Hauptnavigation |
| `.et_mobile_menu`, `.et_mobile_nav_menu` | Mobile Menü |
| `.logo_container`, `#logo` | Logo-Container |
| `.et_header_style_left / centered / split / slide` | Header-Layout-Modi |
| `.et_search_form_container`, `.et-cart-info` | Such- und Warenkorb-Icons |

---

### Einstellbar über Divi UI
- **Divi → Theme Options → Header & Navigation**
  - Header-Layout (left / centered / split / slide)
  - Fixed Navigation aktivieren/deaktivieren
  - Top Bar ein-/ausblenden
  - Logo- und Menü-Höhe
  - Dropdown-Farben, Fonts
- **Customizer → Header & Navigation**
  - Farben, Schriftgrößen, Abstände
  - Hintergrundfarben, aktive Links, Hoverfarben
  - Verhalten „Hide nav until scroll“

---

### Nur per CSS beeinflussbar
- Exakte **Padding/Margin**-Werte (Header-Höhe)
- **Submenu-Breite** und Ausrichtung
- **Breakpoint** für mobiles Menü
- Logo–Text **Vertikal-Zentrierung**
- Feine Spacing-Kontrolle im Sticky-Header (`.et-fixed-header`)

---

## 🔹 3. Sub-Header / Hero (seitenweise Kopfzeilen)

### Variante A – Fullwidth Header Module
**Typische Klassen**
```css
.et_pb_fullwidth_header
.et_pb_fullwidth_header_container.center|left|right
.header-content
.header-image-container
```

**Einstellbar im Modul**
- Text / Titel / Untertitel / Buttons
- Header-Bild & Platzierung (links, rechts, zentriert)
- Hintergrund (Farbe, Bild, Video, Overlay)
- Padding, Typografie, Farben

**Nur per CSS**
- Exakte Bild/Text-Platzierung (Flexbox)
- Mobile Reihenfolge / vertikale Ausrichtung
- Feines Padding / Margin-Tuning

---

### Variante B – Regular Section + Row
**Struktur**
```
.et_pb_section
  └── .et_pb_row
        ├── .et_pb_column (Text)
        └── .et_pb_column (Bild)
```

**Einstellbar**
- Spalten-Layout, Gutter Width, Vertical Align
- Padding/Margins, Equalize Column Heights

**Nur per CSS**
- Globale Abstände über Seiten hinweg
- Exakte Responsiveness jenseits Standard-Breakpoints

---

## 🔹 4. Divi Menü-Modul (Theme Builder Header)

**Typische Klassen**
```css
.et_pb_menu
.et_pb_menu__menu
.et_pb_menu__wrap
.et_pb_menu__logo-wrap
.et_mobile_nav_menu
.mobile_menu_bar
```

**Einstellbar**
- Menüquelle, Alignment, Farben, Fonts
- Dropdown-Farben, Mobile-Icon, Sticky Verhalten

**Nur per CSS**
- Item-Abstände (Gaps)
- Icon-Größe / Abstand
- Feine vertikale Ausrichtung von Logo & Menü

---

## 🔹 5. Wo Divi-CSS liegt

| Speicherort | Beschreibung |
|--------------|--------------|
| `/wp-content/themes/Divi/style.css` | Haupt-CSS des Parent-Themes |
| `/wp-content/themes/Divi/css/` | Enthält modulare CSS-Dateien (`et-builder-modules.css`, `et-core-unified.css`) |
| **⚠️ Nicht bearbeiten!** | Updates überschreiben Änderungen |

**Overrides:**
- `wp-content/themes/Divi-child/style.css` → _empfohlen_  
- **Divi → Theme Options → Custom CSS**
- Modul-spezifisch unter *Advanced → Custom CSS*

Nach Änderungen:  
> Divi → Theme Options → Builder → Advanced → **Clear Static CSS File Generation Cache**

---

## 🔹 6. Praxis-Snippets (für Child-Theme)

### Main Header kompakter
```css
#main-header, #et-top-navigation {
  padding: 6px 0 !important;
}
.et-fixed-header #top-menu > li > a {
  padding-top: 14px;
  padding-bottom: 14px;
}
```

### Fullwidth Header: Text links / Bild rechts
```css
.et_pb_fullwidth_header .et_pb_fullwidth_header_container {
  display: flex;
  align-items: center;
  gap: 2rem;
}
.et_pb_fullwidth_header .header-content {
  flex: 1 1 55%;
}
.et_pb_fullwidth_header .header-image-container {
  flex: 0 0 auto;
  max-width: 320px;
}
@media (max-width: 980px) {
  .et_pb_fullwidth_header .et_pb_fullwidth_header_container {
    display: block;
  }
}
```

---

## 🔹 7. Klassen-Ermittlung (Debugging)
1. **Browser DevTools** (Rechtsklick → *Untersuchen*)  
   - `<body>` enthält globale Flags:  
     `.et_header_style_left`, `.et_fixed_nav`, `.et_non_fixed_nav`, …  
   - Header-Bereich inspizieren → konkrete Klassen sichtbar.  
2. Im Styles-Panel erkennt man Quelle & Datei / Zeile jeder Regel.  
   → Unterscheidung zwischen **Theme Option (Inline/Customizer)** und **Core CSS**.

---

## 🔹 8. Schnellreferenz: Was per Option vs. CSS

| Kategorie | Theme Option | CSS |
|------------|--------------|-----|
| Header-Layout | ✅ |  |
| Farben / Fonts | ✅ |  |
| Logo- / Menü-Höhe (grob) | ✅ |  |
| Dropdown-Farben | ✅ |  |
| Padding / Margin (fein) |  | ✅ |
| Sticky Header Abstände |  | ✅ |
| Submenu-Breite / Position |  | ✅ |
| Hero-Text-/Bild-Ausrichtung |  | ✅ |
| Responsives Verhalten (Custom) |  | ✅ |

---

© 2025 CGS IT Solutions GmbH – interne Dokumentation
