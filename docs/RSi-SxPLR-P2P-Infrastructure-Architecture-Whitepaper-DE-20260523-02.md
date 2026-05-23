# Decentralized Autonomous Ecosystem Architecture
## Infrastruktur für digitale Souveränität durch echtes Peer-to-Peer

**Whitepaper v1.0 (FINAL DRAFT)**

---

**Dokument-Informationen**

| Feld | Wert |
|------|------|
| **Version** | 1.0 (FINAL DRAFT) |
| **Datum** | 23. Mai 2026 |
| **Autor** | Ralf Siebert (aka Maxim R. Garrtner) |
| **Kontakt** | [maxim.r.garrtner@yandex.com](mailto:maxim.r.garrtner@yandex.com) |
| **Klassifikation** | Konzeptionell / Öffentlich / Technisch |
| **Lizenz** | CC BY-SA 4.0 |
| **Sprache** | Deutsch |
| **Bezug** | Positionspapier: *„Digitale Souveränität durch Echtes Peer-to-Peer"* (PP-2026-001) |

---

## Executive Summary

Die Architektur des Internets ist keine technische Neutralität – sie ist eine politische und ökonomische Entscheidung. Seit der Ablösung direkter Computer-zu-Computer-Verbindungen durch zentralisierte Rechenzentren hat sich das World Wide Web von einem offenen Kommunikationsraum zu einer Infrastruktur des **Überwachungskapitalismus** entwickelt. Persönliche Daten werden extrahiert, Verhaltensvorhersagen trainiert und Aufmerksamkeit algorithmisch optimiert – ohne informierte Einwilligung und ohne echte Kontrolle der Nutzenden.

Dieses Whitepaper beschreibt die Architektur eines **Decentralized Autonomous Ecosystems (DAE)**, das digitale Souveränität nicht verspricht, sondern **technisch erzwingt**. Im Gegensatz zu applikatorischen „Pseudo-P2P"-Modellen (z. B. ActivityPub/Mastodon, Matrix, Web3), die weiterhin auf zentralisierten Servern und Vermittlungsdiensten auf OSI-Layer 7 operieren, ermöglicht das DAE autonome, autorisierte und verschlüsselte Direktverbindungen zwischen Endgeräten auf den unteren Netzwerkschichten (Layer 2–4).

Das DAE basiert auf einer komplementären **Protokoll-Triade**:
- **`B.A.T.M.A.N. advanced`** (Layer 2): Offline-fähiges, MAC-basiertes Mesh-Routing für lokale Circles
- **`WireGuard`** (Layer 3): Authentifizierte, kryptographische Overlay-VPN für sicheren Transit über unsichere Netze
- **`p2plib`** (Layer 5–7): DNS-freie Service-Discovery, CRDT-basierte Offline-First-Synchronisation und applikations-agnostische E2E-Kommunikation

Jeder Peer im DAE betreibt einen **vollständigen, lokal autarken Anwendungsstack**, gekoppelt mit einem öffentlichen Sibling-Node für resiliente Replikation und optionale öffentliche Erreichbarkeit. Hardware-gesicherte Identitäten (TPM 2.0), Circle-basierte Autorisierung und dezentrale Konsensvalidierung eliminieren Single Points of Failure, algorithmische Manipulation und intransparente Datenextraktion.

Als **exemplarische Anwendung** wird die *Competence Signature* vorgestellt – ein dezentrales System zur Erfassung, Signierung und Verifikation beruflicher Kompetenzen. Sie demonstriert, wie Applikationen auf der DAE-Infrastruktur Datensouveränität, Authentizität und Resilienz operationalisieren können. Das DAE selbst ist jedoch applikations-agnostisch und kann beliebige Dienste hosten: Chat, Forum, Social Federation, CMS, KI-Inferenz oder kooperative Compute-Workflows.

Bei prädiktiven Betriebskosten von ca. **23 €/Monat pro Node-Paar** transformiert das DAE global ungenutzte Rechenkapazitäten (~26,8 Mrd. idle CPU-Cores) in eine kooperative, zensurresistente und compliant-by-design Infrastruktur. Es ist keine alternative Plattform – sondern die infrastrukturelle Wiederherstellung von Eigentum, Privatsphäre und authentischer Zusammenarbeit im digitalen Raum.

> *„Dezentralität ist kein technisches Feature. Sie ist die Wiederherstellung von Eigentum, Privatsphäre und Kooperation im digitalen Raum."*

---

## Metadaten

| Feld | Wert |
|------|------|
| **Dokument-ID** | `DAE-WP-2026-001-v1.0` |
| **Versionierung** | Semantic Versioning (Major.Minor.Patch) |
| **Primärer Fokus** | Infrastruktur-Architektur des Decentralized Autonomous Ecosystems (DAE) |
| **Sekundärer Fokus** | Anwendungsbeispiel: Competence Signature (eine von vielen möglichen Applikationen) |
| **Zielgruppe** | Infrastruktur-Architekten, Open-Source-Entwickler, Datenschutzbeauftragte, Community-Netzwerk-Betreiber, IT-Entscheider, Forschung |
| **Schlagwörter** | Decentralized Autonomous Ecosystem, True Peer-to-Peer, WireGuard, B.A.T.M.A.N. advanced, p2plib, TPM 2.0, SaltStack GitFS, Datensouveränität, Circle-Topologie, OSI-Layer 2–4 |
| **Referenzprotokolle** | `B.A.T.M.A.N. advanced` (OSI L2), `WireGuard` (OSI L3), `p2plib` (OSI L5–7), Bitcoin OP_RETURN (optional), Tor (optional), ActivityPub (kompatibel) |
| **Hardware-Referenz** | Lenovo ThinkStation P330 Tiny (lokal), OVH Kimsufi KS-B / VPS (öffentlich) |
| **Betriebssystem** | DietPi / Debian 12 Bookworm (minimal) |
| **Orchestrierung** | SaltStack (GitFS), Docker Compose, Caddy Reverse Proxy, Restic Backup |
| **Zitierempfehlung** | Siebert, R. (2026). *Decentralized Autonomous Ecosystem Architecture: Infrastruktur für digitale Souveränität durch echtes Peer-to-Peer* (Whitepaper v1.0). Verfügbar unter: [maxim.r.garrtner@yandex.com] |

---

# 1. Einleitung & Problemstellung

## 1.1 Historische Evolution der Netzwerk-Architekturen

Die grundlegende Idee von Peer-to-Peer findet sich in den Anfängen der Vernetzung von Computern wieder: Zwei Rechner werden durch ein Kabel direkt verbunden. Vor rund 30 Jahren entstand daraus das Internet durch die Standardisierung von Protokollen, die unterschiedliche Computertypen, Betriebssysteme und Software-Produkte zu einem normalisierten, interoperablen Netzwerk zusammenschlossen [[PDF]].

Diese Evolution lässt sich in fünf Phasen unterteilen, die jeweils neue Abhängigkeiten und strukturelle Schwächen etablierten:

| Phase | Zeitraum | Charakteristik | Strukturelle Konsequenz |
|-------|----------|----------------|------------------------|
| **Single Server** | Bis 1990 | Direkte Kabelverbindung, namentlich bekannte Teilnehmer | Vertrauensbasiert, lokal begrenzt, keine Skalierung |
| **Internet Service Providing** | 1990–1999 | ISPs stellen Rechenleistung in Rechenzentren bereit | Anonymisierung der Nutzer, Daten verlassen lokale Kontrolle |
| **Virtualisierung & Cloud** | 2000–2010 | Effizientere Nutzung durch VMs, bedarfsorientierte Abrechnung | Vollständige Auslagerung von Speicher & Compute an Dritte |
| **API Service Providing** | 2015–heute | Applikative Vernetzung via APIs, Hybrid-Cloud-Architekturen | Daten fließen über fremde Schnittstellen, intransparente Weiterverarbeitung |
| **Sidekick Peer-to-Peer** | 2005–heute | Echte P2P-Netzwerke auf Hardware- und Applikationsebene | Autonome Vernetzung möglich, aber noch Nischenphänomen |

Die konsequente Logik dieser Entwicklung ist die Entstehung einer **Client-Server-Infrastruktur**, die das Internet zu einem quasi-öffentlichen Raum macht: Ein zentrales Rechenzentrum bietet Applikationen anonymen Teilnehmern an. Die Verbindung erfolgt anonym; persönliche Daten werden zentral gespeichert und ohne explizite, nachvollziehbare Autorisierung von Dritten genutzt.

---

## 1.2 Die Diagnose: Überwachungskapitalismus als Architektur-Problem

Der Überwachungskapitalismus, geprägt durch Shoshana Zuboff, beschreibt ein Wirtschaftssystem, das menschliche Erfahrung als kostenlosen Rohstoff für kommerzielle Extraktion, Vorhersage und Verhaltensbeeinflussung beansprucht. Diese Logik ist kein Nebenprodukt des Internets – sie ist **strukturell in seiner Architektur verankert**.

### 1.2.1 Die vier Mechanismen der Extraktion

| Mechanismus | Umsetzung in zentralisierten Systemen | Konsequenz für Nutzende |
|-------------|--------------------------------------|------------------------|
| **Datenextraktion** | Tracking von Klicks, Standort, Sozialgraphen, Verweildauer | Verlust der Kontrolle über eigene Informationen |
| **Verhaltensvorhersage** | KI-Modelle prognostizieren zukünftiges Nutzerverhalten | Manipulation durch personalisierte Inhalte |
| **Verhaltensbeeinflussung** | Nudging, algorithmische Filterblasen, Engagement-Optimierung | Erosion von Autonomie und kritischer Urteilsfähigkeit |
| **Monetarisierung** | Verkauf von Profilen an Werbetreibende, politische Akteure, Dritte | Nutzende werden zum Produkt, nicht zum Kunden |

Die Anonymität des Zugangs wird durch die **Transparenz des Verhaltens** kompensiert. Niemand muss wissen, wer Sie sind, solange das System präzise vorhersagen kann, was Sie als Nächstes tun werden. Dieser Prozess ist kein technischer Unfall, sondern ein strukturelles Merkmal der Client-Server-Infrastruktur.

### 1.2.2 Das Versagen regulatorischer Ansätze

Verträge, Nutzungsbedingungen und Datenschutzregulierungen (wie die DSGVO) versuchen, dieser Macht Grenzen zu setzen. Sie bleiben jedoch oft wirkungslos, wenn die technische Architektur selbst die Extraktion, Replikation und Fremdnutzung von Daten standardisiert. Datenhoheit wird zur Illusion, sobald die Infrastruktur physisch und logisch außerhalb der Reichweite der datenerzeugenden Person liegt.

> **Kernthese**: Solange Kommunikation über vermittelnde Server läuft, entsteht zwangsläufig eine Kontrollinstanz, die Datenfluss, Zugriff, Speicherung und Metadaten-Analyse regelt. Datenschutz durch AGBs ist ein Widerspruch in sich.

---

## 1.3 Die Illusion applikatorischer Dezentralisierung

Angesichts der wachsenden Kritik an zentralisierten Plattformen entstand eine neue Welle vermeintlich dezentraler Lösungen: **ActivityPub (Mastodon/Fediverse)**, **Matrix/Element**, **Nostr**, **IPFS** oder **Web3-Applikationen**. Diese Systeme werben mit Offenheit, Föderation, Nutzerkontrolle und Zensurresistenz.

Technisch operieren sie jedoch fast ausschließlich auf der **Anwendungsschicht (OSI Layer 7)**:

```
Client → Server → (Server-zu-Server) → Server → Client
```

Im Falle von ActivityPub beispielsweise tauschen Server auf Applikationsebene Daten aus; der Client ist niemals direkt mit einem anderen Client verbunden. Matrix nutzt Ende-zu-Ende-Verschlüsselung, bleibt aber auf zentrale Home-Server oder Relay-Dienste angewiesen, um Nachrichten zu speichern und weiterzuleiten.

### 1.3.1 Definition: Pseudo-P2P vs. Echtes P2P

| Merkmal | **Pseudo Peer-to-Peer** | **Echtes Peer-to-Peer** |
|---------|------------------------|------------------------|
| **OSI-Layer** | Schicht 7 (Applikation) | Schicht 2–4 (Data Link, Network, Transport) |
| **Verbindungspfad** | Client → Server → Client | Peer ↔ Peer (direkt) |
| **Vermittlung** | Zentrale oder föderierte Server-Instanz | Algorithmus-basierte direkte Adressierung |
| **Autorisierung** | Plattformseitig (Nutzerkonto, AGB) | Gegenseitig, explizit, widerrufbar |
| **Datenfluss** | Durch Server relayt, gespeichert oder analysiert | Ende-zu-Ende verschlüsselt, kein Transit durch Dritte |
| **Internet-Abhängigkeit** | Zwingend erforderlich | Optional; autonomes Mesh möglich |

Diese Ansätze werden hier als **Pseudo-Peer-to-Peer** bezeichnet. Sie reduzieren zwar die Abhängigkeit von einzelnen Monopolisten, bewahren aber das grundlegende Vermittlungsparadigma: Eine Server-Instanz (oder ein Server-Cluster) autorisiert, speichert, relayt oder validiert die Kommunikation. Die Datenextraktion wird lediglich dezentralisiert oder fragmentiert, nicht aber eliminiert.

---

## 1.4 Das Paradigma des Echten Peer-to-Peer

Echtes P2P nutzt die Netzwerktechnologie direkt auf der Ebene des **Transports (TCP/UDP, Layer 4)**, des **Internets (IP, Layer 3)** oder der **Sicherungsschicht (MAC-Adressen, Layer 2)**. Damit entfällt die Nutzung von Servern oder Vermittlungssystemen in Rechenzentren vollständig. Die Verbindung wird autonom, algorithmisch und hardwarenah etabliert.

### 1.4.1 Das Circle-Prinzip & Identitätsbekanntgabe

Ein zentrales Merkmal echter P2P-Netzwerke ist die **Aufhebung der Anonymität zugunsten authentischer Sozialität**. Im klassischen Internet interagieren Teilnehmende pseudonym oder anonym in einem öffentlichen Raum. Echtes P2P ersetzt dieses Modell durch das **Circle-Konzept**:

- **Kreise statt Plattformen**: Peers organisieren sich in sozialen oder geo-lokalen Einheiten (Familie, Freundeskreis, Verein, Nachbarschaft, Grätzl).
- **Persönliche Bekanntschaft**: Innerhalb eines Circle kennen sich die Eigentümer der Peers persönlich oder sind über vertrauenswürdige Mitglieder verknüpft.
- **Explizite Autorisierung**: Jede Verbindung erfordert gegenseitige Bestätigung. Autorisierung kann jederzeit widerrufen werden.
- **Identitätsbekanntgabe**: Quellen sind namentlich bekannt. Verantwortung für veröffentlichte Informationen liegt klar beim jeweiligen Peer.

Dieses Modell stellt die **Verantwortung für Inhalte und Daten** wieder her. Desinformation wird durch ein neuartiges Konsens-Modell eingedämmt: Informationen werden nicht algorithmisch verstärkt, sondern durch peer-basierte Validierung und persönliche Verifikation gefiltert.

### 1.4.2 Autonomie & Gateway-Struktur

Echte P2P-Mesh-Netzwerke sind **inhärent autonom**. Sie benötigen keinen expliziten Zugang zum Internet, um zu funktionieren. Die Verbindung wird vollständig durch die angeschlossenen Geräte selbst hergestellt. Das Internet ist lediglich eine ergänzende Struktur, die über **Gateway-Peers** angebunden wird.

```
[Circle-Mesh] ←→ [Gateway-Peer] ←→ [Internet / andere Circles]
```

- **Offline-Fähigkeit**: Bei Internetausfall, Zensur oder Infrastrukturstörungen bleibt das lokale Circle-Netzwerk voll funktionsfähig.
- **Resilientes Routing**: Datenpakete finden alternative Pfade über verfügbare Peers (Multi-Path-Routing).
- **Kontrollierte Externalisierung**: Nur autorisierte Daten werden über Gateways nach außen geleitet. Der Datenfluss bleibt granular steuerbar.

---

## 1.5 Das ungenutzte globale Potential

Eine Analyse der weltweit verfügbaren IT-Infrastruktur (Stand Dezember 2023) zeigt das enorme, bisher weitgehend ungenutzte Potenzial für echte P2P-Architekturen [[PDF]]:

| Maschinentyp | Anzahl (Mio.) | Ø CPU-Cores | Gesamt-Cores (Mio.) |
|--------------|---------------|-------------|---------------------|
| **Server** | 17,5 | 64 | 1.120 |
| **Personal Computer** | 350,0 | 8 | 2.800 |
| **Mobile Endgeräte** | 6.000,0 | 4 | 24.000 |
| **Gesamt** | **6.367,5** | – | **~27.920** |

Davon stehen schätzungsweise **~26.800 Millionen Prozessor-Kerne** im überdurchschnittlichen Leerlauf zur Verfügung. Diese verteilte Kapazität repräsentiert kein technisches Defizit, sondern ein **gesellschaftliches Infrastruktur-Potenzial**. Echtes P2P nutzt diesen Leerlauf für:
- Lokale Validierung und Konsensbildung
- Dezentrale Datenspeicherung und Replikation
- Verteilte Berechnung und Arbeitslast-Balancierung
- Resiliente Kommunikationswege

Im Gegensatz zu Cloud-Modellen, die Rechenleistung zentral bündeln und extern vermarkten, bleibt die Wertschöpfung im P2P-Netzwerk bei den Teilnehmenden. Kooperation ersetzt Extraktion.

> *„Jeder weiß ein wenig, jeder muss nicht alles wissen, jeder gibt sein Wissen in die Kooperation."*

---

## 1.6 Motivation für das Decentralized Autonomous Ecosystem

Die vorangegangene Diagnose macht deutlich: Der Überwachungskapitalismus ist kein bloßes Geschäftsmodell, sondern das direkte Ergebnis einer Infrastruktur, die Zentralisierung als Standard setzt. Die Wiederherstellung von Datensouveränität, authentischer Sozialität und resilienter Kommunikation erfordert daher keine bessere Applikation, sondern eine fundamentale Neugestaltung der Vernetzung selbst.

Das **Decentralized Autonomous Ecosystem (DAE)** operationalisiert dieses Paradigma durch:
1. **Protokoll-basierte Souveränität**: `B.A.T.M.A.N. advanced` (L2), `WireGuard` (L3) und `p2plib` (L5–7) eliminieren Vermittler auf Netzwerk- und Transportschicht.
2. **Hardware-gesicherte Identität**: TPM 2.0 siegelt private Keys; `tpm2_unseal` zur Laufzeit, niemals im Git oder auf Disk.
3. **Full-Stack Autonomie**: Jeder Peer hostet den kompletten Anwendungs- und Validierungsstack lokal – keine funktionale Abhängigkeit von anderen Nodes.
4. **Circle-basierte Topologie**: Peers organisieren sich in sozial oder geo-lokal definierten Kreisen; Gateways verbinden Circles föderiert, ohne zentrale Kontrollinstanz.

Als **exemplarische Anwendung** wird im Verlauf dieses Whitepapers die *Competence Signature* vorgestellt – ein dezentrales System zur Erfassung, Signierung und Verifikation beruflicher Kompetenzen. Sie demonstriert, wie Applikationen auf der DAE-Infrastruktur Datensouveränität, Authentizität und Resilienz operationalisieren können. Das DAE selbst ist jedoch **applikations-agnostisch** und kann beliebige Dienste hosten: Chat, Forum, Social Federation, CMS, KI-Inferenz oder kooperative Compute-Workflows.

---

## 1.7 Aufbau des Kapitels & Ausblick

Dieses Kapitel hat die historische Evolution der Netzwerk-Architekturen nachgezeichnet, die strukturellen Schwächen zentralisierter Infrastrukturen diagnostiziert und das Paradigma echten Peer-to-Peer als technische und ethische Alternative begründet.

Die folgenden Kapitel operationalisieren diese Prinzipien:
- **Kapitel 2** detailliert die Protokoll-Triade (`B.A.T.M.A.N. advanced`, `WireGuard`, `p2plib`) und ihre komplementäre Synergie.
- **Kapitel 3** beschreibt das Systemdesign: Hardware-Basis, 1:1 Sibling-Paarung, Datenfluss und Validierungskette.
- **Kapitel 4–7** behandeln Anwendungs-Schicht, Sicherheit, Betrieb und Ökonomie des DAE.

Das Ziel ist nicht die Beschreibung einer alternativen Plattform, sondern die Spezifikation einer Infrastruktur, die digitale Souveränität **technisch erzwingt** – nicht vertraglich verspricht.

---

# 2. Architektur-Grundlagen & Protokoll-Stack

Die Diagnose zentralisierter Extraktionsmodelle und die Prinzipien echter Peer-to-Peer-Vernetzung bleiben abstrakt, solange sie nicht durch eine präzise, schichtenübergreifende Protokoll-Architektur operationalisiert werden. Das Decentralized Autonomous Ecosystem (DAE) nutzt nicht ein einzelnes Protokoll, sondern eine komplementäre Triade, die gezielt auf unterschiedlichen Ebenen des OSI-Referenzmodells (Open Systems Interconnection) arbeitet. Diese Schichtung ist kein technischer Overhead, sondern das strukturelle Fundament, das digitale Souveränität, Resilienz und Privatsphäre durch Design erzwingt.

---

## 2.1 Das OSI-Modell als Fundament für echtes P2P

Das OSI-Layer-Modell unterteilt Netzwerkkommunikation in sieben definierte Schichten, wobei jede Schicht spezifische Funktionen erfüllt und Dienste für die darüberliegende Ebene bereitstellt. In der heutigen Internet-Architektur findet der Großteil der „Dezentralisierung" auf der **Anwendungsschicht (Layer 7)** statt. Applikationen wie ActivityPub, Matrix oder Web3-Frontends kommunizieren über Server, die als Vermittler fungieren. Der Client ist niemals direkt mit einem anderen Client verbunden; Daten werden relayt, gespeichert oder applikatorisch synchronisiert [[PDF]].

Echtes P2P durchbricht dieses Vermittlungsparadigma, indem es die Netzwerkkommunikation auf tieferen Schichten etabliert:

| OSI-Schicht | Funktion im klassischen Internet | Funktion im echten P2P (DAE) |
|-------------|--------------------------------|------------------------------|
| **Layer 7 (Application)** | Browser, APIs, Social Media, Cloud-Apps | Service-Discovery, E2E-Payload, CRDT-Sync (`p2plib`) |
| **Layer 6 (Presentation)** | TLS/SSL, Komprimierung | Applikatorische Verschlüsselung (libsodium), Zero-Trust-Auth |
| **Layer 5 (Session)** | HTTP-Keepalives, WebSockets | Persistente Peer-Sessions, zustandslose Handshakes |
| **Layer 4 (Transport)** | TCP/UDP, Port-basiertes Routing | Stateless UDP-Tunnel, NAT-Durchdringung (`WireGuard`) |
| **Layer 3 (Network)** | IP-Routing, DNS-Abhängigkeit | Crypto-Key Routing, kryptographische Identität (`WireGuard`) |
| **Layer 2 (Data Link)** | Switch-basierte MAC-Weiterleitung | Proaktives Mesh-Routing, MAC-Adress-Verifikation (`B.A.T.M.A.N.`) |
| **Layer 1 (Physical)** | Kabel, Funk, Sendeantennen | Standard-Hardware (WiFi/Ethernet), LoRa (optional) |

> **Kernprinzip**: Solange Datenpakete physisch durch fremdverwaltete Rechenzentren fließen, bleibt Überwachung möglich. Echte Souveränität entsteht dort, wo Verbindungen bereits auf Ebene der Sicherungsschicht (MAC) oder Vermittlungsschicht (IP) autorisiert, verschlüsselt und direkt zwischen Endgeräten etabliert werden [[PDF]].

---

## 2.2 Die Protokoll-Triade im Detail

### 2.2.1 `B.A.T.M.A.N. advanced` (OSI Layer 2) – Das autonome lokale Nervensystem

`B.A.T.M.A.N. advanced` (Better Approach To Mobile Adhoc Networking) ist ein proaktives Routing-Protokoll, das direkt im Linux-Kernel integriert ist und auf der Sicherungsschicht operiert. Im Gegensatz zu proprietären WiFi-Mesh-Chipsätzen (wie sie historisch im OLPC-Projekt unter IEEE 802.11s zum Einsatz kamen) ist `B.A.T.M.A.N.` vollständig Open Source und hardware-agnostisch [[PDF]].

**Technische Charakteristika:**
- **MAC-basierte Adressierung**: Verbindungen werden auf Hardware-Ebene etabliert. Jede Netzwerkkarte identifiziert sich über ihre eindeutige MAC-Adresse, was die Verbindungssicherheit bereits vor der IP-Ebene erhöht.
- **Proaktives Routing**: Jeder Peer sendet regelmäßig *Originator Messages* (OGMs). Die Verbindungsqualität (*Transmission Quality, TQ*) wird dezentral gemessen. Jeder Node kennt stets die beste Richtung zum Ziel, ohne zentrale Routing-Tabellen.
- **Hybrid-Fähigkeit**: Unterstützt kabellose (WLAN) und kabelgebundene (Ethernet) Verbindungen im selben Mesh. Ermöglicht *Mesh-over-Internet*, wenn Peers geografisch verteilt sind.
- **Keine Internet-Abhängigkeit**: Das Mesh funktioniert vollständig autonom. Das klassische Internet wird nur über autorisierte Gateway-Peers angebunden.

**Rolle im DAE**: `B.A.T.M.A.N.` bildet das lokale Circle-Netzwerk. Es garantiert Offline-Fähigkeit, findet alternative Pfade bei Link-Ausfällen und ermöglicht die direkte, vermittelungsfreie Kommunikation innerhalb eines bekannten Teilnehmerkreises.

---

### 2.2.2 `WireGuard` (OSI Layer 3) – Das kryptographische Overlay

Während `B.A.T.M.A.N.` lokale Pfade findet, adressiert `WireGuard` die Sicherheit des Datentransits über unsichere oder fremdverwaltete Netze. Es operiert auf der Vermittlungsschicht und nutzt moderne Kryptographie für authentifizierten, verschlüsselten Transit.

**Technische Charakteristika:**
- **Crypto-Key Routing**: IP-Adressen werden an öffentliche ECC-Keys (Curve25519) gebunden. Die Verbindung wird nicht über DNS oder zentrale Zertifizierungsstellen hergestellt, sondern über kryptographische Identitäten.
- **Minimaler Codebase**: Mit unter 4.000 Zeilen Code ist `WireGuard` deutlich auditierbarer als IPsec oder OpenVPN. Geringere Komplexität bedeutet geringere Angriffsfläche und höhere Performance.
- **NAT & Firewall Durchdringung**: Integrierte *Persistent-Keepalive*-Mechanismen und UDP-basierter Transport ermöglichen stabile Verbindungen hinter restriktiven Routern, ohne manuelle Portfreigaben.
- **Stateless & Kernel-Integriert**: Läuft direkt im OS-Netzwerkstack, nutzt Hardware-Beschleunigung und verursacht minimalen CPU-Overhead.

**Rolle im DAE**: `WireGuard` bildet das sichere Rückgrat für geografisch verteilte Nodes. Es verbindet lokale `B.A.T.M.A.N.`-Meshes mit öffentlichen Sibling-Nodes und ermöglicht verschlüsselten Transit über das öffentliche Internet, ohne dass Provider oder Zwischenknoten Metadaten oder Payload einsehen können.

---

### 2.2.3 `p2plib` (OSI Layer 5–7) – Die applikatorische Direktkommunikation

Applikationen benötigen eine Schicht, die auf den gesicherten Netzwerkprotokollen aufsetzt, ohne wieder auf Server-Relays, zentrale APIs oder proprietäre Frameworks zurückzugreifen. `p2plib` (konzeptionell als moderne P2P-Kommunikationsbibliothek) schließt diese Lücke und implementiert die Anforderungen an echte Applikations-P2P: direkte End-to-End-Kanäle, dezentrale Dienstesuche und offline-fähige Synchronisation.

**Technische Charakteristika:**
- **Service Discovery ohne DNS**: Peers melden eigene Dienste (Chat, BBS, Competence Core, CMS) im Mesh an. Discovery erfolgt über lokale Broadcasts oder DHT-ähnliche Strukturen innerhalb des `WireGuard`-Subnets.
- **CRDT-basierte Replikation**: Zustandsänderungen (Nachrichten, Kompetenz-Nachweise, Foren-Posts) werden als konfliktfreie replizierte Datentypen (Conflict-Free Replicated Data Types) synchronisiert. Offline-First-Design garantiert Datenkonsistenz ohne zentrale Sequenzierung.
- **Session-Management & E2E-Payload**: Sitzungen werden über temporäre Key-Pairs ausgehandelt. Verschlüsselung erfolgt applikatorisch (z. B. libsodium) zusätzlich zur Transportverschlüsselung (Defense-in-Depth).
- **Framework-Agnostisch**: Bindet sich nahtlos in NodeJS, Python oder Go-Dienste ein, ohne Vendor-Lock-in oder zentrale Identity-Provider.

**Rolle im DAE**: `p2plib` ist die Brücke zur Anwendungslogik. Sie stellt sicher, dass Dienste direkt zwischen Peers kommunizieren, Daten lokal persistieren und nur autorisierten Teilnehmern zugänglich sind. Sie operationalisiert das kooperative Prinzip: *„Jeder weiß ein wenig, jeder muss nicht alles wissen, jeder gibt sein Wissen in die Kooperation."* [[PDF]]

---

## 2.3 Die Multi-Layer-Souveränitätskette

Die drei Protokolle sind keine Alternativen, sondern komplementäre Schichten, die gemeinsam eine souveräne Infrastruktur erzwingen. Keine einzelne Schicht ist allein ausreichend; erst ihr Zusammenspiel eliminiert strukturelle Abhängigkeiten.

```mermaid
flowchart TD
    subgraph L7["Applikationsschicht (L7)"]
        APP["Competence Core, Chat, BBS, Friendica, WP"]
    end
    subgraph L5_6["Session & Payload (L5-L6)"]
        P2P["p2plib<br/>Service Discovery, CRDT-Sync, E2E-Verschlüsselung"]
    end
    subgraph L3["Verschlüsseltes Overlay (L3)"]
        WG["WireGuard<br/>Crypto-Key Routing, NAT-Traversal, Authenticated Tunnel"]
    end
    subgraph L2["Mesh-Routing (L2)"]
        BAT["B.A.T.M.A.N. advanced<br/>MAC-basiert, proaktiv, hybrid (WLAN+Ethernet)"]
    end
    subgraph PHY["Physikalische Schicht (L1)"]
        HW["WiFi / Ethernet / LoRa (optional)<br/>Hardware-gebundene Adressierung"]
    end

    APP --> P2P --> WG --> BAT --> HW
    
    classDef app fill:#e8f5e9,stroke:#2e7d32;
    classDef session fill:#fff3e0,stroke:#ef6c00;
    classDef net3 fill:#e3f2fd,stroke:#1976d2;
    classDef net2 fill:#f3e5f5,stroke:#7b1fa2;
    classDef phy fill:#ffebee,stroke:#c62828;
    
    class APP app;
    class P2P session;
    class WG net3;
    class BAT net2;
    class HW phy;
```

**Synergie-Effekte:**
1. **Redundante Sicherheit**: MAC-Filter (L2) + Crypto-Keys (L3) + E2E-Payload-Verschlüsselung (L5–7) schaffen eine Zero-Trust-Architektur.
2. **Graceful Degradation**: Fällt das Internet aus, bleibt `B.A.T.M.A.N.` + `p2plib` lokal funktionsfähig. Fällt ein lokaler Router aus, findet `WireGuard` alternative Pfade über andere Peers.
3. **Identität über Adresse**: Peers werden nicht über IPs oder Domains identifiziert, sondern über kryptographische und hardwaregebundene Keys. Das eliminiert DNS-Hijacking, CA-Abhängigkeiten und IP-Tracking.
4. **Kooperative Lastverteilung**: Arbeitslast wird dezentral verteilt; kein Peer muss die volle Rechenlast tragen, um valide Dienste bereitzustellen [[PDF]].

---

## 2.4 Graceful Degradation & Resilienz durch Schichtung

Ein echtes P2P-Ecosystem muss unter extremen Bedingungen funktionsfähig bleiben: Internetausfall, Zensur, Infrastrukturstörungen oder gezielte Angriffe auf einzelne Knoten. Das DAE adressiert dies durch **Graceful Degradation**:

| Ausfallszenario | Protokoll-Reaktion | Operative Konsequenz |
|-----------------|-------------------|----------------------|
| **WAN/Internet-Ausfall** | `B.A.T.M.A.N.` bleibt aktiv; `p2plib` puffert CRDT-Zustände lokal | Lokaler Circle bleibt voll funktionsfähig; Sync erfolgt asynchron bei Wiederverbindung |
| **WiFi-Interferenz/Link-Down** | `B.A.T.M.A.N.` erkennt TQ-Abfall, routed über Ethernet-Backup oder alternativen Peer | Kein Single Point of Routing; Multi-Path-Redundanz aktiv |
| **NAT/Firewall-Blockade** | `WireGuard` nutzt UDP-Keepalive (`PersistentKeepalive=25`) | Stabile Verbindungen auch hinter restriktiven Consumer-Routern |
| **Node-Absturz/Kompromittierung** | SaltStack + GitFS erkennt Konfigurations-Drift, setzt letzten validen State zurück | Self-Healing ohne manuelle Intervention; TPM-Keys bleiben geschützt |

Resilienz ist hier kein Marketing-Begriff, sondern eine engineering-getriebene Systemeigenschaft, die durch die gezielte Schichtung der Protokoll-Triade erreicht wird.

---

## 2.5 Das Gateway-Prinzip & Circle-Interkonnektivität

Ein Circle ist in sich geschlossen und vollständig autonom. Das Internet ist keine Voraussetzung für dessen Funktion, sondern eine optionale Erweiterung. Die Verbindung zwischen Circles oder zum klassischen Web erfolgt ausschließlich über **Gateway-Peers**.

```
[Circle-Mesh L2] ←→ [Gateway-Peer (L2/L3 Bridge)] ←→ [Internet / andere Circles]
```

- **Autorisierte Externalisierung**: Nur explizit freigegebene Dienste oder synchronisierte Datensätze passieren das Gateway. Keine Metadaten-Lecks, keine Tracking-Telemetrie.
- **Föderale Skalierung**: Mehrere Circles können über vertrauenswürdige Gateways verbunden werden, ohne eine zentrale Koordinationsinstanz zu etablieren. Jeder Circle behält seine Autonomie, seine Regeln und seine Datenhoheit.
- **Redundanz durch Sibling-Paare**: Fällt ein lokaler Edge-Node aus, übernimmt der öffentliche Sibling-Node die Gateway-Funktion und sichert die bidirektionale Synchronisation.
- **Compliance by Design**: Da Daten physisch lokal gespeichert und nur auf explizite Konfiguration repliziert werden, operationalisiert diese Struktur DSGVO/GDPR-Prinzipien standardmäßig.

Das Gateway-Prinzip transformiert das Internet von einem zentralen Kontrollraum zu einem **optionalen Transportmedium**. Die eigentliche Infrastruktur, die Validierung und die soziale Interaktion verbleiben im autonomen Circle-Netzwerk.

---

## 2.6 Ausblick auf die Implementierung

Die Protokoll-Triade (`B.A.T.M.A.N. advanced`, `WireGuard`, `p2plib`) bildet das technische Rückgrat des DAE. Sie eliminiert Vermittler auf Netzwerk- und Transportschicht, ersetzt anonymer Reichweite durch explizite Autorisierung und verwandelt ungenutzte Rechenkapazität in kooperative Infrastrukturen.

Im nächsten Kapitel wird gezeigt, wie diese Protokolle auf konkreter Hardware operationalisiert werden: die 1:1 Sibling-Paarung, die NVMe-Trennung von OS und Daten, die TPM-Integration und die physische Topologie, die jedes Node-Paar zu einer souveränen, vollständigen Einheit macht.

---

# 3. Systemdesign & Infrastruktur

Die Architektur eines Decentralized Autonomous Ecosystems (DAE) ist nur so robust wie die physische und logische Infrastruktur, auf der sie operiert. Während die Protokoll-Triade (`B.A.T.M.A.N. advanced`, `WireGuard`, `p2plib`) die kommunikative Souveränität definiert, stellt das Systemdesign sicher, dass diese Protokolle auf autonomen, voll ausgestatteten und hardware-gesicherten Knoten laufen. Im Gegensatz zu client-server-Modellen oder pseudo-dezentralen Architekturen, die Rollen fragmentieren und Thin-Clients erzwingen, folgt das DAE dem Prinzip der **physischen und logischen Vollständigkeit jedes Peers**.

---

## 3.1 Hardware-Referenz & Physische Topologie

Das DAE ist hardware-agnostisch, benötigt jedoch für Referenzimplementierungen Geräte, die TPM 2.0, sufficient RAM/CPU für Container-Orchestrierung und NVMe-Speicherung unterstützen. Die folgende Referenzarchitektur basiert auf bewährten, kosteneffizienten Komponenten, die das Verhältnis von Leistung, Energieverbrauch und Datensouveränität optimieren.

### 3.1.1 Lokaler Edge-Node: Lenovo ThinkStation P330 Tiny
| Komponente | Spezifikation | DAE-Relevanz |
|------------|--------------|--------------|
| **CPU** | Intel Core i9-9900T (8C/16T, 35W TDP) | Ausreichend für Parallelbetrieb von Mesh-Daemons, Container-Runtime und Validierungslogik |
| **RAM** | 32 GB DDR4-2666 (2×16 GB, auf 64 GB erweiterbar) | Puffer für `B.A.T.M.A.N.`-Routing-Tabellen, Docker-Services, CRDT-State-Caches |
| **Storage 1 (OS)** | 512 GB M.2 NVMe SSD (OPAL 2.0) | Betriebssystem, Container-Images, Protokoll-Konfigurationen, hardwareverschlüsselt |
| **Storage 2 (Data)** | 1 TB M.2 NVMe SSD (nachrüstbar) | Applikationsdaten, Blockchain-Index, lokale Backups, CRDT-Replication-Logs |
| **Security** | TPM 2.0, Secure Boot, Intel vPro | Hardware-Root-of-Trust für Key-Sealing, Remote-Attestation, Drift-Detection |
| **Power** | ~18 W idle / ~45 W peak | ~€30/Jahr Stromkosten; ideal für 24/7-Betrieb im lokalen Circle |

### 3.1.2 Öffentlicher Sibling-Node: OVH Kimsufi KS-B / VPS
| Komponente | Spezifikation | DAE-Relevanz |
|------------|--------------|--------------|
| **CPU** | Intel Xeon E5-1620v2 (4C/8T) | Backup-Sync, Gateway-Relay, öffentliche HTTPS/ActivityPub-Termination |
| **RAM** | 32 GB DDR3 ECC | Identischer Stack wie lokal; ECC-Fehlerkorrektur für Langzeitstabilität |
| **Network** | 500 Mbps public, unmetered, anti-DDoS | Öffentliche Erreichbarkeit, Circle-Gateway, Inter-Circle-Federation |
| **Kosten** | ~$11.10/Monat + einmaliges Setup | Predictable Kosten; kein Free-Tier-Abhängigkeitsrisiko |

> **Hinweis**: Diese Spezifikationen sind Referenzwerte. Das DAE läuft ebenso auf Raspberry Pi 4/5, x86-Mini-PCs oder alten Laptops, sofern TPM 2.0 und Linux-Kernel-Support gegeben sind. Die Architektur skaliert horizontal mit der verfügbaren Hardware.

---

## 3.2 Das Full-Stack-per-Node-Prinzip

Jeder Peer im DAE hostet einen **vollständigen, lokal autarken Anwendungs- und Infrastrukturstack**. Dieses Design eliminiert funktionale Abhängigkeiten, die in zentralisierten oder föderierten Modellen zwangsläufig entstehen.

| Schicht | Lokale Instanz (P330 Tiny) | Öffentliche Instanz (Kimsufi/VPS) |
|---------|---------------------------|-----------------------------------|
| **OS & Kernel** | Debian/DietPi, `batman-adv`, `wireguard`-Module | Identisch |
| **Netzwerk** | `B.A.T.M.A.N.`-Mesh, `WireGuard`-Client/Server | `WireGuard`-Server/Client, Caddy Reverse Proxy |
| **Container-Runtime** | Docker Compose, `p2plib`-Daemon, Restic | Identisch |
| **Anwendungen** | Competence Core, Chat, BBS, Friendica, WP, Bitcoin+Tor | Identisch (optional: Public-Facing-Only-Modus) |
| **Datenhaltung** | NVMe-2 (lokal), TPM-Sealed Keys | NVMe/SSD (Backup-Replica), Mirror-Keys |

**Operative Konsequenzen:**
- ✅ **Kein Single Point of Failure**: Fällt ein lokaler Node aus, bleibt der Sibling-Node operational und umgekehrt.
- ✅ **Graceful Degradation**: Bei WAN-Ausfall arbeiten lokale Dienste weiterhin; `p2plib` puffert Zustände asynchron.
- ✅ **Kooperative Lastverteilung**: Wie im KB-Konzept definiert: *„Jeder weiß ein wenig, jeder muss nicht alles wissen, jeder gibt sein Wissen in die Kooperation."* Validierung, Routing und Storage werden dezentral verteilt, ohne dass ein Peer die Volllast tragen muss.

---

## 3.3 1:1 Sibling-Paarung & Circle-Gateway-Architektur

Das DAE organisiert Peers in **Circles** (familiär, beruflich, geo-lokal, vereinsbasiert). Innerhalb eines Circle kennen sich die Eigentümer der Peers persönlich; Autorisierung ist explizit, kryptographisch verifiziert und jederzeit widerrufbar [[PDF]].

### 3.3.1 Paarungslogik
```
[Lokaler Node A] ←→ [Öffentlicher Sibling A]
       ↕                         ↕
[Circle-Mesh L2]          [Circle-Gateway L3/L7]
```
- **Bidirektionale Replikation**: `p2plib` synchronisiert CRDT-Zustände verschlüsselt zwischen lokal und öffentlich.
- **Gateway-Funktion**: Der öffentliche Node terminiert HTTPS, federiert ActivityPub, und relayt autorisierte Daten zu anderen Circles oder ins klassische Internet.
- **Metadaten-Minimierung**: Gateways relayen keine Tracking-Telemetrie, keine unverschlüsselten Payloads und keine Applikations-Logs. Der Datenfluss bleibt granular steuerbar.

### 3.3.2 Identitätsbekanntgabe & Autorisierung
Im Gegensatz zum anonymisierten Internet, das persönliche Daten zentral speichert und ohne Kontrolle des Eigentümers nutzt [[PDF]], erzwingt das DAE:
1. **Explizite Peering-Anfrage**: Jeder Node stellt eine kryptographische Autorisierungsanfrage.
2. **Circle-Bestätigung**: Bestehende Mitglieder verifizieren die Identität (physisch, telefonisch, über vertrauenswürdige Introducer).
3. **Key-Registrierung**: Öffentliche Keys werden im Mesh registriert; private Keys verbleiben TPM-gesiegelt.
4. **Widerrufbarkeit**: Jede Autorisierung kann durch den Circle-Owner oder den Peer selbst jederzeit zurückgezogen werden.

---

## 3.4 Datenfluss & Validierungskette im DAE

Ein Datenobjekt (z. B. Kompetenz-Nachweis, Forenbeitrag, Chat-Nachricht) durchläuft im DAE eine definierte, mehrstufige Validierungs- und Synchronisationskette:

```mermaid
flowchart LR
    A["Erstellung & Lokale Speicherung<br/>(NVMe-2, Local-Only)"] --> B["TPM-Signierung<br/>(Hardware-Root-of-Trust)"]
    B --> C["p2plib CRDT-Sync<br/>(Offline-First, Zustandserfassung)"]
    C --> D["Lokale Circle-Validierung<br/>(≥3 autorisierte Peers)"]
    D --> E["WireGuard Overlay +<br/>B.A.T.M.A.N. Routing"]
    E --> F["Sibling-Backup &<br/>Public-Termination"]
    F --> G["Inter-Circle-Federation<br/>(Gateway-zu-Gateway)"]
    G --> H["Dezentrale Persistenz<br/>(CRDT-Konsens, Optional: BTC-Timestamp)"]

    classDef step fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px;
    class A,B,C,D,E,F,G,H step;
```

**Protokoll-Zuordnung:**
- **L2/L3**: `B.A.T.M.A.N.` findet den optimalen Pfad im Circle; `WireGuard` verschlüsselt den Transit zum Sibling/anderen Circles.
- **L5–7**: `p2plib` handshakes die Session, synchronisiert CRDTs, verwaltet Service-Discovery ohne DNS.
- **Validierung**: Multi-Peer-Konsens ersetzt zentrale Zertifizierung. Jede Signatur ist hardwaregebunden und nicht abstreitbar (Non-Repudiation).

---

## 3.5 Logische Topologie & Protokoll-Mapping

Die folgende Mermaid-Visualisierung zeigt die physische und logische Anordnung der Nodes, der Circle-Meshes, der Sibling-Paare und der Gateway-Verbindungen.

```mermaid
flowchart TD
    subgraph CircleA["Circle A (Lokal)"]
        N1(("Lokal A1<br/>P330 Tiny"))
        N2(("Lokal A2<br/>P330 Tiny"))
        N1 <-->|"B.A.T.M.A.N. L2"| N2
    end

    subgraph CircleB["Circle B (Lokal)"]
        N3(("Lokal B1<br/>P330 Tiny"))
        N4(("Lokal B2<br/>P330 Tiny"))
        N3 <-->|"B.A.T.M.A.N. L2"| N4
    end

    GW1(("Sibling A<br/>Kimsufi/VPS"))
    GW2(("Sibling B<br/>Kimsufi/VPS"))
    BTC((Bitcoin<br/>Timestamping))
    TOR((Tor<br/>Privacy))
    WEB((Internet<br/>Public))

    %% 1:1 Sibling Pairing
    N1 <-->|"WireGuard L3 + p2plib L5-7"| GW1
    N3 <-->|"WireGuard L3 + p2plib L5-7"| GW2

    %% Inter-Circle via Gateways
    GW1 <-->|"Authenticated Sync"| GW2
    GW1 <-->|"Clearnet/Onion"| BTC
    GW1 <-->|"SOCKS5 Proxy"| TOR
    GW2 <-->|"HTTPS/Caddy"| WEB

    %% Styling
    classDef local fill:#e3f2fd,stroke:#1976d2,stroke-width:3px;
    classDef sibling fill:#fff3e0,stroke:#ef6c00,stroke-width:2px;
    classDef ext fill:#f5f5f5,stroke:#616161,stroke-dasharray:6;
    class N1,N2,N3,N4 local;
    class GW1,GW2 sibling;
    class BTC,TOR,WEB ext;
```

> **Legende**:  
> 🔵 **Lokale Circle-Nodes**: Vollautonom, `B.A.T.M.A.N.`-Mesh, TPM-gesichert, Full-Stack lokal  
> 🟠 **Sibling-Gateways**: Bidirektionale Replikation, externe Federation, öffentliche Termination  
> ⚪ **Externe Netze**: Optionale Anbindung; Datenfluss nur über autorisierte, verschlüsselte Kanäle  

---

## 3.6 Skalierung, Ressourcenallokation & Offline-Resilienz

### 3.6.1 Nutzung ungenutzter Rechenkapazität
Eine Analyse der globalen IT-Infrastruktur (Stand Dezember 2023) zeigt, dass weltweit schätzungsweise **~26.800 Millionen Prozessor-Kerne** in Personal Computern, Mobilgeräten und Servern im überdurchschnittlichen Leerlauf verfügbar sind [[PDF]]. Das DAE transformiert dieses Potenzial von einer passiven Infrastruktur in eine aktive, kooperative Ressource:
- **Edge-Compute**: Jeder Peer führt lokale Validierung, CRDT-Merge-Logik und Service-Hosting aus.
- **Load-Balancing**: Arbeitslast wird dynamisch über autorisierte Peers verteilt; kein zentrales Scheduling.
- **Ökonomie**: Predictable Kosten (~€23/Monat pro Paar) ersetzen nutzungsbasierte Cloud-Abrechnungen.

### 3.6.2 Offline-First & Graceful Degradation
Das DAE ist nicht auf Internet-Konnektivität angewiesen. Bei Ausfall des WAN:
1. `B.A.T.M.A.N.` bleibt im lokalen Circle aktiv; Routing adaptiert sich an verfügbare Links.
2. `p2plib` speichert Zustandsänderungen lokal; CRDTs garantieren Konfliktfreiheit bei späterem Sync.
3. Applikationen (Chat, BBS, Competence Core, lokale WP-Instanz) bleiben uneingeschränkt nutzbar.
4. Bei Wiederverbindung erfolgt asynchroner, verschlüsselter Abgleich mit Sibling-Nodes und anderen Circles.

Diese Architektur macht das DAE nicht nur technisch robust, sondern auch geopolitisch und infrastrukturell resilient. Sie entkoppelt lokale Kommunikation und Datenhoheit von globalen Backbone-Monopolen.

---

## 3.7 Ausblick auf die Anwendungs-Schicht

Die physische und logische Infrastruktur ist nun definiert: autonome Nodes, 1:1 Sibling-Paarung, Circle-Meshes, Gateway-Federation und eine mehrschichtige Protokoll-Integration. Diese Basis ist applikations-agnostisch und kann beliebige Workloads hosten.

Im nächsten Kapitel wird gezeigt, wie konkrete Dienste auf dieser Infrastruktur operieren: Die *Competence Signature* als exemplarische Validierungs-Applikation, sowie Chat, BBS, Friendica und WordPress als interoperable, lokal gehostete Module. Alle Dienste teilen denselben Stack, nutzen dieselben Protokolle und unterliegen denselben Souveränitäts-Prinzipien.

---

# 4. Anwendungs-Schicht & Dienste

Die Infrastruktur eines Decentralized Autonomous Ecosystems (DAE) ist per Definition **anwendungs-agnostisch**. Sie stellt keinen zentralen App-Store, keine plattformspezifischen APIs und keine serververmittelte Laufzeitumgebung bereit. Stattdessen definiert sie einen souveränen, hardwaregesicherten und protokollgesteuerten Runtime-Space, in dem beliebige Dienste isoliert, lokal und peer-zu-peer betrieben werden können. Die *Competence Signature* ist lediglich eine exemplarische Applikation, die demonstriert, wie Geschäftslogik, Validierung und Datensouveränität auf dieser Infrastruktur operationalisiert werden.

---

## 4.1 Das Prinzip der Anwendungs-Agnostizität

Im klassischen Client-Server- oder Pseudo-P2P-Modell (Layer 7) sind Applikationen strukturell an Vermittlungsinstanzen gebunden: DNS-Server, API-Gateways, Identity-Provider oder föderierte Relay-Knoten. Jede Anwendung muss eigene Authentifizierungs-, Synchronisations- und Routing-Logik implementieren [[KB]]. Das DAE kehrt dieses Paradigma um:

| Merkmal | Pseudo-P2P (Layer 7) | DAE-Anwendungslaufzeit (Layer 2–7) |
|---------|----------------------|-----------------------------------|
| **Verbindungsweg** | Client → Server/Relay → Client | Peer ↔ Peer (direkt über verschlüsselte Tunnel) |
| **Service-Discovery** | DNS, API-Registry, zentrale Verzeichnisse | `p2plib`-Broadcast/DHT innerhalb des WireGuard-Subnets |
| **Datenpersistenz** | Server-Datenbanken, Cloud-Storage | Lokale NVMe, CRDT-basierte Replikation, explizite Freigabe |
| **Authentifizierung** | Nutzername/Passwort, OAuth, JWT | TPM-gesiegelte Key-Pairs, Circle-Autorisierung, MAC/IP-Key-Binding |
| **Abhängigkeit** | Framework-Lock-in, Provider-Abhängigkeit | Container-Isolation, standardisierte Protokolle, vollständige Migration möglich |

Jeder Peer im DAE hostet denselben vollständigen Dienst-Stack. Es gibt keine „Thin Clients", keine funktional fragmentierten Knoten und keine zentrale Instanz, die Dienste orchestriert. Die Koordination erfolgt dezentral über Protokolle, nicht über Plattformlogik.

---

## 4.2 Exemplarische Anwendung: Competence Signature

Die *Competence Signature* dient im Whitepaper als **Referenzimplementierung**, um zu zeigen, wie eine anspruchsvolle Validierungs-Applikation auf der DAE-Infrastruktur operiert. Sie ist keine Plattform, sondern ein lokaler Dienst mit folgenden Eigenschaften:

| Funktion | Umsetzung im DAE |
|----------|------------------|
| **Erfassung** | Lokale Erstellung von Kompetenz-Nachweisen, Zertifikaten oder Projektverifikationen |
| **Signierung** | Hardware-basierte ECC-Signatur via `tpm2_sign` (Curve25519/SHA-256); Non-Repudiation durch TPM-Attestation |
| **Validierung** | Multi-Peer-Konsens: ≥3 autorisierte Circle-Mitglieder bestätigen die Signatur via `p2plib`-Sync |
| **Persistenz** | Lokale Speicherung auf NVMe-2; asynchrone, verschlüsselte CRDT-Replikation zu Sibling & autorisierten Peers |
| **Timestamping** | Optional: OP_RETURN-Transaktion über lokalen Bitcoin Full Node (Tor-geschützt) für unveränderliche Zeitstempel |

Die Anwendung nutzt ausschließlich die Protokoll-Triade des DAE. Sie benötigt keine externen Identity-Provider, keine Cloud-Datenbanken und keine serververmittelte Kommunikation. Die Datensouveränität bleibt vollständig beim Eigentümer des Peers.

---

## 4.3 Der interoperable Dienst-Stack

Neben der *Competence Signature* demonstriert der folgende Stack, wie verschiedene Anwendungsklassen dieselbe Infrastruktur nutzen, ohne sich gegenseitig zu blockieren oder zentrale Abhängigkeiten zu erzeugen:

| Dienst | Zweck | Technologie-Stack | DAE-Integration |
|--------|-------|-------------------|-----------------|
| **Bitcoin Full Node + Tor** | Dezentrale Validierung, Timestamping, Privacy | `bitcoin/bitcoin`, `dperson/torproxy` | L3-Overlay via WireGuard; RPC nur im Mesh erreichbar; Tor für Onion-Propagation |
| **P2P Chat** | Ende-zu-Ende-Messenger, Offline-First | NodeJS, WebSocket, libsodium, PouchDB | `p2plib` für Discovery & CRDT-Sync; E2E-Verschlüsselung auf L6; kein Relay |
| **BBS / Forum** | Thread-basierte Diskussionen, kooperative Wissensbasis | NodeJS, CouchDB (Multi-Master) | `p2plib` synchronisiert Änderungen; CouchDB-Replication über WireGuard-IPs |
| **Friendica** | Föderiertes Social Network (ActivityPub-kompatibel) | PHP 8.2, MariaDB, Apache | ActivityPub-Adapter; Public-Facing nur via Caddy auf Sibling-Node; Circle-Only-Modus möglich |
| **WordPress** | CMS für Dokumentation, Portale, Public-Präsenz | PHP 8.2, MariaDB, Caddy Reverse Proxy | Statische Inhalte lokal; Dynamic-Content nur für autorisierte Peers; Public-Gateway optional |

Alle Dienste laufen in isolierten Containern, teilen sich dieselbe Netzwerkschnittstelle (`10.42.0.0/24`), nutzen dieselbe CRDT-Synchronisationslogik und unterliegen denselben Zero-Trust-Richtlinien.

---

## 4.4 Protokoll-Integration auf Anwendungsebene

Applikationen im DAE kommunizieren nicht über HTTP-APIs an zentrale Endpunkte, sondern nutzen die **komplementäre Protokoll-Triade** als native Laufzeitumgebung:

```mermaid
flowchart TD
    subgraph Apps["Anwendungsebene (L7)"]
        CS[Competence Core]
        CHAT[P2P Chat]
        BBS[BBS Forum]
        FRND[Friendica]
        WP[WordPress]
    end
    subgraph L5_6["Session & Sync (L5-L6)"]
        P2P["p2plib<br/>• Service Discovery (DNS-frei)<br/>• E2E Session-Handshake<br/>• CRDT Replication<br/>• libsodium Payload-Encryption"]
    end
    subgraph L3["Secure Transport (L3)"]
        WG["WireGuard<br/>• Crypto-Key Routing<br/>• Authenticated Tunnel<br/>• NAT-Traversal (Keepalive)"]
    end
    subgraph L2["Mesh Routing (L2)"]
        BAT["B.A.T.M.A.N. advanced<br/>• MAC-basierte Pfadfindung<br/>• Proaktive TQ-Metrik<br/>• Hybrid WLAN/Ethernet"]
    end

    CS --> P2P
    CHAT --> P2P
    BBS --> P2P
    FRND --> P2P
    WP --> P2P
    
    P2P --> WG --> BAT
    
    classDef app fill:#e8f5e9,stroke:#2e7d32;
    classDef l56 fill:#fff3e0,stroke:#ef6c00;
    classDef l3 fill:#e3f2fd,stroke:#1976d2;
    classDef l2 fill:#f3e5f5,stroke:#7b1fa2;
    
    class CS,CHAT,BBS,FRND,WP app;
    class P2P l56;
    class WG l3;
    class BAT l2;
```

**Funktionsweise:**
1. **Discovery**: Ein neuer Dienst (z. B. `competence-core`) meldet sich via `p2plib` im lokalen Subnet an. Kein DNS, keine Registry. Peers erkennen ihn über Broadcast/DHT innerhalb des WireGuard-Mesh.
2. **Session-Handshake**: Bei Verbindungsaufbau werden temporäre Ephemeral-Key-Pairs ausgetauscht. Die Session ist zustandslos und hardware-verifizierbar (TPM-Attestation optional).
3. **Payload-Sync**: Zustandsänderungen (Nachrichten, Zertifikate, Foren-Posts) werden als CRDTs serialisiert, applikatorisch verschlüsselt (libsodium) und über `p2plib` an autorisierte Peers gesendet.
4. **Transport**: Die Pakete durchlaufen `WireGuard` (L3-Verschlüsselung, NAT-Durchdringung) und werden von `B.A.T.M.A.N. advanced` (L2-Routing) zum optimalen nächsten Hop geleitet.

Im Gegensatz zu Layer-7-Implementierungen, bei denen jede Anwendung eigene Verschlüsselung, Authentifizierung und Routing-Logik nachrüsten muss [[KB]], bietet das DAE diese Schichten **infrastrukturell standardisiert**. Applikationen konzentrieren sich auf Fachlogik, nicht auf Infrastruktur-Sicherheit.

---

## 4.5 Container-Architektur & Datenisolation

Die physische und logische Trennung von Betriebssystem, Container-Laufzeit und Anwendungsdaten ist ein Kernprinzip des DAE. Sie verhindert lateralen Zugriff, minimiert Angriffsflächen und gewährleistet Compliance-by-Design.

| Laufwerk | Inhalt | Sicherheitseigenschaft |
|----------|--------|------------------------|
| **NVMe-1 (512 GB)** | OS (DietPi/Debian), Docker-Images, Kernel-Module, Protokoll-Konfigurationen | OPAL 2.0 Hardware-Verschlüsselung, Read-Only-Mounts für Container |
| **NVMe-2 (1 TB)** | Anwendungsdaten, Blockchain-Index, CRDT-State-Logs, lokale Backups | ext4/XFS, TPM-gesiegelte Backup-Keys, isolierte Volume-Mounts pro Container |
| **TPM 2.0** | Private Keys, Sealing-Policies, Attestation-Quotes | Hardware-Root-of-Trust, Keys verlassen niemals den Chip, Unsealing nur zur Laufzeit |

**Zero-Trust Container-Richtlinien:**
- Ausführung als non-root User (`USER 1000:1000`)
- Seccomp/AppArmor-Profile zur Einschränkung von Syscalls
- Read-only Root-Filesysteme; `/data` als einziges writable Volume
- Keine privilegierten Container, außer für `wireguard`/`batman-adv` (CAP_NET_ADMIN)
- Netzwerk-Policies: Container kommunizieren nur über `10.42.0.0/24`; kein direkter WAN-Zugriff

Diese Architektur stellt sicher, dass selbst bei Kompromittierung eines einzelnen Dienstes keine lateral movement möglich ist und sensible Daten hardwaregebunden geschützt bleiben.

---

## 4.6 Konsens, Validierung & kooperative Arbeitslastverteilung

Das DAE operationalisiert das im KB beschriebene Prinzip:  
> *„Jeder weiß ein wenig, jeder muss nicht alles wissen, jeder gibt sein Wissen in die Kooperation."*

Im Kontext der Anwendungsschicht bedeutet dies:

| Mechanismus | Umsetzung | Vorteil gegenüber zentralen Systemen |
|-------------|-----------|--------------------------------------|
| **Lokale Validierung zuerst** | Jeder Peer prüft Signaturen, Hashes und CRDT-Zustände lokal | Keine Abhängigkeit von externer Validierungsinfrastruktur |
| **Multi-Peer-Konsens** | Kritische Einträge erfordern Bestätigung durch ≥3 autorisierte Peers | Ersetzt zentrale Zertifizierungsstellen; verhindert Single-Point-of-Trust |
| **CRDT-Konfliktlösung** | Zustandsänderungen sind kommutativ, assoziativ und idempotent | Keine zentrale Sequenzierung (z. B. kein Leader/Quorum-Server) nötig |
| **Kooperative Lastverteilung** | Routing, Sync und Validierung werden dezentral über autorisierte Peers verteilt | Kein Peer trägt die Volllast; Skalierung erfolgt horizontal durch Circle-Erweiterung |
| **Graceful Degradation** | Bei WAN-Ausfall bleibt lokale Validierung & CRDT-Cache aktiv | Anwendungen funktionieren offline; Sync erfolgt asynchron bei Reconnect |

Konsens entsteht hier nicht durch algorithmische Amplifikation oder zentrale Moderation, sondern durch **transparente, hardware-verifizierte und kooperativ getragene Validierung**. Identitäten sind bekannt, Autorisierung ist explizit, und Verantwortung liegt klar beim Eigentümer des Peers [[KB]].

---

## 4.7 Ausblick auf Sicherheit & Betrieb

Die Anwendungsschicht des DAE demonstriert, dass digitale Souveränität nicht durch bessere AGBs oder plattforminterne Datenschutz-Features erreicht wird, sondern durch eine Infrastruktur, die Extraktion, Manipulation und Fremdkontrolle **technisch unmöglich macht**. Dienste laufen isoliert, kommunizieren direkt, speichern lokal und synchronisieren nur auf explizite Autorisierung.

Im nächsten Kapitel wird gezeigt, wie diese Architektur durch eine mehrschichtige Sicherheitsstrategie (Zero-Trust), TPM-Key-Lifecycle-Management, Audit-Logging und Caddy-basierte Reverse-Proxy-Hardening gegen Angriffe, Kompromittierung und Metadaten-Lecks geschützt wird.

---

# 5. Sicherheit, Zero-Trust & Datenschutz

Die Architektur eines Decentralized Autonomous Ecosystems (DAE) ist nicht darauf ausgelegt, Sicherheit nachträglich durch Firewalls, VPN-Gateways oder plattforminterne Datenschutzeinstellungen zu gewährleisten. Stattdessen wird Sicherheit **architektonisch erzwungen**. Jede Verbindung, jeder Datenzugriff und jede Zustandsänderung unterliegt einem Zero-Trust-Modell, das auf kryptographischer Identität, hardwaregebundenem Root-of-Trust und expliziter Circle-Autorisierung basiert. Im Gegensatz zum klassischen Internet, das persönliche Daten in anonymisierten, zentralen Rechenzentren speichert und ohne Kontrolle des Eigentümers Dritter zugänglich macht [[KB]], operationalisiert das DAE Privatheit und Integrität durch Design.

---

## 5.1 Das Zero-Trust-Paradigma im DAE

Traditionelle Netzwerksicherheit basiert auf dem Perimeter-Modell: Innerhalb eines vertrauenswürdigen Netzwerks gelten Ressourcen als sicher, außerhalb als gefährlich. Diese Annahme ist im modernen Internet obsolet. Das DAE eliminiert das Konzept eines implizit vertrauenswürdigen Netzwerks vollständig.

| Zero-Trust-Prinzip | Umsetzung im DAE |
|--------------------|------------------|
| **Explizite Verifikation** | Jede Session erfordert kryptographische Authentifizierung via TPM-gesiegelter Keys. Keine implizite Vertrauensstellung durch IP-Adresse oder Netzwerkzone. |
| **Prinzip der geringsten Rechte** | Container laufen als non-root, mit read-only Root-Filesystem und minimalen `CAP_*`-Capabilities. Nur Netzwerk-Daemons erhalten `CAP_NET_ADMIN`. |
| **Implizite Annahme von Kompromittierung** | Jede Verbindung wird verschlüsselt (L2/L3/L5–7), jedes Log auditierbar, jede Konfiguration versioniert und bei Drift automatisch zurückgesetzt. |
| **Dauerhafte Überwachung & Validierung** | Health-Checks, CRDT-Konsistenzprüfungen und Hardware-Attestation laufen kontinuierlich. Anomalien triggeren automatische Isolierung. |

Zero-Trust im DAE ist keine Software-Funktion, sondern eine **strukturelle Eigenschaft des Protokoll-Stacks**.

---

## 5.2 Hardware-Root-of-Trust & TPM 2.0 Key-Lifecycle

Der Trusted Platform Module (TPM 2.0) bildet das unveränderliche Vertrauensanker des DAE. Private Keys verlassen niemals den Hardware-Chip. Sie werden nur zur Laufzeit für kryptographische Operationen entsiegelt und nach Gebrauch sofort wieder im geschützten Speicher abgelegt.

### 5.2.1 Key-Lifecycle-Phasen
| Phase | Mechanismus | Sicherheitsgarantie |
|-------|-------------|---------------------|
| **Generierung** | ECC-Key-Pair (Curve25519/Ed25519) direkt im TPM erzeugt | Keys sind nie im RAM oder auf Disk im Plaintext |
| **Sealing** | Binding an PCR-Werte (Secure Boot, Kernel-Hash, Konfig-Integrität) | Key ist nur nutzbar, wenn Systemstate unverändert ist |
| **Unsealing** | Zur Boot-Zeit via `tpm2_unseal` in ephemeren Speicher geladen | Automatische Verweigerung bei Manipulationsversuch |
| **Nutzung** | Signierung (`tpm2_sign`), Entschlüsselung, WireGuard-Auth | Hardware-beschleunigt, auditierbar, non-repudiable |
| **Rotation/Revocation** | Neuer Key wird generiert, alter im TPM invalidiert | Sofortige Widerrufbarkeit ohne Datenverlust |

**Integration in den Stack:**
- `WireGuard`: Private Keys werden aus TPM entsiegelt, Public Keys dienen als Routing-Identität.
- `Competence Signature`: Kompetenz-Nachweise werden via `tpm2_sign` hardware-signiert.
- `System-Attestation`: SaltStack prüft PCR-Quotes vor Provisioning; bei Abweichung wird State zurückgerollt.

---

## 5.3 Verschlüsselungskaskade: Von Layer 2 bis Layer 7

Sicherheit im DAE folgt dem **Defense-in-Depth-Prinzip** über mehrere OSI-Schichten. Selbst bei Kompromittierung einer Ebene bleibt die Integrität und Vertraulichkeit der Daten geschützt.

```mermaid
flowchart TD
    L2["Layer 2 (Data Link)<br/>MAC-Binding, B.A.T.M.A.N. Auth-Peering"] --> L3["Layer 3 (Network)<br/>WireGuard: Curve25519, ChaCha20-Poly1305, Auth-Tunnel"]
    L3 --> L5["Layer 5-6 (Session/Presentation)<br/>p2plib: libsodium E2E, Ephemeral-Key-Handshake"]
    L5 --> L7["Layer 7 (Application)<br/>Payload-Strukturen, CRDT-Merge-Logik"]
    
    classDef layer fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px;
    class L2,L3,L5,L7 layer;
```

| Schicht | Protokoll | Verschlüsselung & Authentifizierung |
|---------|-----------|-------------------------------------|
| **Layer 2** | `B.A.T.M.A.N. advanced` | MAC-Adress-Binding, OGM-Validierung, proaktive Pfadprüfung |
| **Layer 3** | `WireGuard` | State-of-the-Art Krypto (Curve25519, ChaCha20, Poly1305, BLAKE2s), Crypto-Key-Routing |
| **Layer 5–6** | `p2plib` | Temporäre Session-Keys, libsodium (XSalsa20-Poly1305), Replay-Schutz |
| **Layer 7** | Applikations-Logik | Datenstrukturen sind kryptographisch signiert (TPM), Hash-verkettet |

Diese Kaskade verhindert, dass ein einzelner Schwachpunkt (z. B. Router-Kompromittierung, DNS-Spoofing, Framework-Bug) zur vollständigen Datenexposition führt.

---

## 5.4 Circle-Autorisierung vs. Anonyme Plattformen

Das klassische Internet ist ein **implizit öffentlicher Raum**: Teilnehmer interagieren pseudonym oder anonym, persönliche Daten werden zentral gespeichert und ohne explizite Kontrolle des Eigentümers genutzt [[KB]]. Soziale Medien und Plattformen heben Privatheit durch Transparenz und algorithmische Verstärkung auf.

Das DAE ersetzt dieses Modell durch das **Circle-Prinzip**:
- **Identitätsbekanntgabe**: Peers sind namentlich bekannt. Quellen sind klar zuordenbar. Verantwortung liegt beim Eigentümer.
- **Explizite, gegenseitige Autorisierung**: Jede Verbindung erfordert kryptographische Peering-Anfrage und manuelle Bestätigung durch bestehende Circle-Mitglieder.
- **Widerrufbarkeit**: Autorisierung kann jederzeit zurückgezogen werden. Keys werden invalidiert, Replikation gestoppt.
- **Privatheit als Default**: Daten sind lokal gespeichert und nur für explizit autorisierte Peers sichtbar. Keine automatische Veröffentlichung oder Tracking-Telemetrie.

> *„Privatheit wird nicht durch öffentliche Transparenz aufgehoben, sondern durch selektive, autorisierte Sichtbarkeit geschützt."*

Gateways verbinden Circles föderiert, aber nur autorisierte, verschlüsselte Datensätze passieren die Grenze. Keine Metadaten-Lecks, keine impliziten Zugriffsrechte.

---

## 5.5 Audit, Non-Repudiation & Verifizierung

Im DAE wird Vertrauen nicht zentral zugesprochen, sondern **dezentral verifiziert**. Die Kombination aus Hardware-Signierung, Multi-Peer-Konsens und transparenten Audit-Logs stellt sicher, dass Informationen sauber von Desinformation getrennt werden können [[KB]].

| Mechanismus | Umsetzung | Wirkung |
|-------------|-----------|---------|
| **Non-Repudiation** | TPM-basierte Signierung jedes kritischen Eintrags | Ersteller kann Urheberschaft nicht abstreiten; Fälschung technisch ausgeschlossen |
| **Multi-Node-Validierung** | ≥3 autorisierte Peers bestätigen Konsistenz & Authentizität | Ersetzt zentrale Zertifizierungsstellen; verhindert Single-Point-of-Trust |
| **CRDT-Integritätsprüfung** | Hash-verkettete Zustandsänderungen, konfliktfreie Merge-Logik | Manipulation an einem Node wird bei Sync automatisch erkannt & abgelehnt |
| **Dezentrales Audit-Logging** | Loki + Prometheus im Mesh; Logs werden lokal gespeichert, nur Hashes synchronisiert | Vollständige Nachvollziehbarkeit ohne zentrale Log-Server |
| **Optionaler Blockchain-Timestamp** | OP_RETURN-Transaktion via Tor-geschützten Bitcoin-Node | Unveränderlicher, öffentlich verifizierbarer Zeitstempel für kritische Nachweise |

Konsens entsteht nicht durch algorithmische Filter oder Plattform-Moderation, sondern durch **transparente, hardware-verifizierte und kooperativ getragene Validierung**.

---

## 5.6 Compliance-by-Design (DSGVO/GDPR operationalisiert)

Datenschutzbestimmungen wie die DSGVO bleiben oft wirkungslos, wenn die technische Architektur die Extraktion und Fremdnutzung von Daten standardisiert. Das DAE löst dieses Dilemma, indem es regulatorische Anforderungen **architektonisch implementiert**:

| DSGVO-Recht | Zentrale Umsetzung (oft fragil) | DAE-Implementierung (technisch erzwungen) |
|------------|--------------------------------|------------------------------------------|
| **Datenminimierung** | Opt-out, Cookie-Banner, Metadaten-Sammlung | Standardmäßig deaktiviert; nur explizit autorisierte Sync-Streams |
| **Löschrecht (Art. 17)** | Serverseitige Löschung, Backups verbleiben oft | Lokale Löschung beendet sofort `p2plib`-Replikation; kein zentrales Archiv |
| **Datenportabilität (Art. 20)** | Proprietäre Exporte, API-Rate-Limits | Offene Formate, direkte Migration über autorisierte Peers |
| **Rechenschaftspflicht (Art. 5)** | Compliance-Berichte, Audits durch Dritte | TPM-Attestation, immutable Logs, GitOps-Historie als technischer Nachweis |
| **Jurisdiktion** | Daten in ausländischen Rechenzentren (CLOUD Act, FISA) | Physischer Speicherort beim Peer-Eigentümer → lokales Recht gilt |

Compliance ist im DAE kein nachträglicher Verwaltungsakt, sondern eine **inhärente Systemeigenschaft**.

---

## 5.7 Hardening & Verteidigungsschichten

Neben protokoll- und hardwarebasierten Sicherheitsmechanismen implementiert das DAE operative Verteidigungsschichten, um Angriffsflächen zu minimieren und Resilienz zu maximieren.

| Schicht | Maßnahme | Zweck |
|---------|----------|-------|
| **Container** | non-root Execution, read-only Root FS, Seccomp/AppArmor, `CAP_NET_ADMIN` isoliert | Laterale Bewegungen unterbinden, Syscall-Angriffe blockieren |
| **Netzwerk** | Caddy Reverse Proxy mit Auto-HTTPS, HSTS, CSP, Rate-Limiting, IP-Whitelisting für Admin | Public-Facing-Dienste härten, DDoS/Brute-Force abwehren |
| **Host** | `fail2ban`, `auditd`, `unattended-upgrades`, UFW mit strict Default-Deny | Automatisierte Angriffserkennung, Patch-Management, Host-Firewall |
| **Konfiguration** | SaltStack GitFS, `yamllint`/`salt-lint` CI/CD, Drift-Detection & Auto-Rollback | Konfigurationsfehler erkennen, unbefugte Änderungen rückgängig machen |
| **Backup** | `restic` mit TPM-gesiegeltem Repo-Key, bidirektional zu Sibling, verschlüsselt | Disaster-Recovery ohne Cloud-Provider, Integrität gewahrt |

Diese Schichten bilden ein **kohärentes Sicherheitsnetz**, das Angriffe bereits an der Perimeter-Ebene abfängt, im Kernel isoliert und auf Applikationsebene verifiziert.

---

## 5.8 Ausblick auf Betrieb & Provisioning

Die Sicherheitsarchitektur des DAE zeigt, dass digitale Souveränität und Datenschutz nicht durch Verträge oder Plattform-Policies gewährleistet werden, sondern durch eine Infrastruktur, die Extraktion, Manipulation und Fremdkontrolle **technisch unmöglich macht**. Hardware-gesicherte Keys, mehrschichtige Verschlüsselung, Circle-Autorisierung und Compliance-by-Design bilden das Fundament.

Im nächsten Kapitel wird gezeigt, wie diese Architektur operationalisiert wird: SaltStack + GitHub GitFS für versionierte Provisionierung, der `cs-wizard.py` CLI für Circle- und Node-Pair-Generierung, CI/CD-Validation und Self-Healing-Betrieb. Sicherheit wird hier nicht nur designed, sondern **automatisiert durchgesetzt**.

---

# 6. Betrieb, Provisioning & GitOps

Der Betrieb eines Decentralized Autonomous Ecosystems (DAE) widerspricht fundamental den etablierten Praktiken zentralisierter Cloud-Infrastrukturen. Während traditionelle Systeme auf Provider-Konsolen, API-Gateways und manuelle Skript-Ausführung setzen, operationalisiert das DAE den Betrieb durch **GitOps, versionierte Infrastruktur-as-Code (IaC) und autonome Selbstheilung**. Die Provisionierung erfolgt nicht durch externe Orchestrierungs-Dienste, sondern durch einen dezentralen, auditierbaren und kryptographisch verifizierten Konfigurationskreislauf. Dieser Ansatz stellt sicher, dass Kontrolle, Transparenz und Reproduzierbarkeit niemals an Dritte delegiert werden.

---

## 6.1 Das GitOps-Paradigma im DAE

GitOps transformiert Infrastruktur-Konfiguration von einem operativen Akt in einen deklarativen, versionierten Zustand. Im DAE bedeutet dies:
- **Konfiguration als Code**: Jede Netzwerkeinstellung, jedes Container-Layout und jede Circle-Regel ist in Git dokumentiert.
- **Single Source of Truth**: Das GitHub-Repository (oder eine selbst-gehostete Git-Instanz) ist die autoritative Quelle. Keine manuellen Änderungen auf Live-Systemen.
- **Automatische Konvergenz**: SaltStack-Minions pullen regelmäßig den gewünschten State und gleichen ihn mit dem Ist-Zustand ab. Abweichungen (Drift) werden automatisch korrigiert.
- **Vollständige Auditierbarkeit**: Jeder Commit, jeder Merge und jede Rollback-Operation ist nachvollziehbar, signiert und revisionssicher.

Im Gegensatz zu Cloud-Providern, bei denen Provisionierung über proprietäre APIs und Blackbox-Steuerungen erfolgt, bleibt im DAE die gesamte Betriebslogik offen, lokal ausführbar und unabhängig von externen Diensten.

---

## 6.2 SaltStack + GitHub GitFS: Versionierte Provisionierung

SaltStack dient als Orchestrierungs-Engine des DAE. Durch die `gitfs`-Backend-Integration bezieht jeder Minion seine States und Pillars direkt aus einem Git-Repository, ohne dass ein zentraler Salt-Master betrieben werden muss. Dies eliminiert Single Points of Failure und ermöglicht vollständig dezentrale Provisionierung.

**Minion-Konfiguration (`/etc/salt/minion.d/gitfs.conf`)**
```yaml
fileserver_backend:
  - gitfs

gitfs_remotes:
  - git@github.com:your-org/dae-infra.git

gitfs_provider: pygit2
gitfs_base: main
gitfs_root: salt/

pillar_roots:
  base:
    - /srv/pillar
    - gitfs://pillar/
```

**State-Assignment (`top.sls`)**
```yaml
base:
  'role:local':
    - match: grain
    - dae.local-stack
  'role:public':
    - match: grain
    - dae.public-gateway
  'circle:*':
    - match: pillar
    - dae.circle-sync
```

Der Workflow ist linear und deterministisch:
1. Admin erstellt/ändert Konfiguration lokal.
2. `git commit` + `git push` → Versionierung im Repository.
3. Salt Minion erkennt Änderung (via Scheduler oder Event-Trigger).
4. `gitfs` pullt neuen State/Pillar.
5. `state.apply` konvergiert das System zum deklarierten Zustand.

---

## 6.3 Der `cs-wizard.py` CLI: Circle- & Node-Pair-Generierung

Manuelle YAML-Erstellung ist fehleranfällig und skaliert schlecht. Der `cs-wizard.py` CLI automatisiert die Generierung von Circle-Definitionen, 1:1 Sibling-Paarungen und Service-Enablings, während er gleichzeitig Validierungsregeln durchsetzt.

```python
#!/usr/bin/env python3
"""DAE Circle & Node-Pair Configuration Wizard"""
import yaml, questionary, subprocess, sys
from pathlib import Path

PILLAR_DIR = Path("pillar/nodes")
PILLAR_DIR.mkdir(parents=True, exist_ok=True)

def main():
    print("🌐 DAE Configuration Wizard v1.0")
    circle_id = questionary.text("Circle-ID (z.B. circle-berlin):").ask().strip()
    pair_id = questionary.text("Pair-ID (z.B. pair-a):").ask().strip()
    role = questionary.select("Node-Rolle?", choices=["local", "public"]).ask()
    
    config = {
        "circle_id": circle_id,
        "pair_id": pair_id,
        "role": role,
        "network": {
            "wireguard_ip": questionary.text("WireGuard IP (10.42.0.x):", default="10.42.0.1").ask(),
            "persistent_keepalive": 25
        },
        "services": {svc: {"enabled": questionary.confirm(f"{svc} aktivieren?").ask()} for svc in ["competence", "chat", "bbs", "friendica", "wp"]},
        "backup": {"target": f"{pair_id}-{'public' if role=='local' else 'local'}", "schedule": "0 */4 * * *"}
    }
    
    path = PILLAR_DIR / f"{pair_id}-{role}.yaml"
    with open(path, "w") as f: yaml.dump(config, f, default_flow_style=False, sort_keys=False)
    print(f"✅ Gespeichert: {path}")
    
    if questionary.confirm("Git-Commit & Push?").ask():
        subprocess.run(["git", "add", str(path)], check=True)
        subprocess.run(["git", "commit", "-m", f"feat: add {pair_id}-{role} to {circle_id}"], check=True)
        subprocess.run(["git", "push"], check=True)

if __name__ == "__main__": main()
```

Der Wizard operationalisiert das im KB beschriebene **Circle-Prinzip**: Explizite Identitätsbekanntgabe, gegenseitige Autorisierung und klare Rollen-Zuordnung (lokal vs. öffentlich) werden direkt in die Infrastruktur-Konfiguration übersetzt.

---

## 6.4 Pillar-Schema & Konfigurations-Management

Pillars speichern node-spezifische, sensitivere Konfigurationen, die nicht im allgemeinen State-Tree liegen. Im DAE sind Pillars strikt nach **Circle, Pair und Rolle** strukturiert.

| Pillar-Key | Typ | Beschreibung | DAE-Funktion |
|------------|-----|--------------|--------------|
| `circle_id` | String | Logische Gruppierung (Familie, Verein, Grätzl) | Circle-basierte Autorisierung & Sync-Boundaries |
| `pair_id` | String | Eindeutige ID für 1:1 Sibling-Kopplung | Bidirektionale Replikation, Failover-Routing |
| `role` | Enum (`local`/`public`) | Funktion im Paar | Bestimmt Caddy-Termination, Public-Access, Backup-Direction |
| `network.wireguard_ip` | CIDR | Statische IP im Mesh-Subnet | Crypto-Key-Routing, Service-Discovery via `p2plib` |
| `services.*.enabled` | Boolean | Dienst-Aktivierung | Selektiver Full-Stack, Ressourcen-Optimierung |
| `backup.target` | String | Ziel-Pair für CRDT-Sync | Asynchrone, verschlüsselte Zustandsreplikation |

**Secrets-Management**: Passwort, API-Keys oder TLS-Zertifikate werden niemals plaintext im Git abgelegt. Stattdessen nutzt das DAE:
- `sops` + `age` für verschlüsselte Pillar-Dateien
- TPM 2.0 zur Laufzeit-Entsiegelung (`tpm2_unseal`)
- Environment-Injection nur im Container-Start-Prozess

---

## 6.5 CI/CD-Validation & Quality Gates

Bevor Konfigurationen in die Live-Umgebung gelangen, durchlaufen sie automatisierte Quality Gates. Dies verhindert Syntaxfehler, Konfigurations-Drift und Sicherheitslücken, bevor sie auf die Nodes angewendet werden.

**GitHub Actions Workflow (`.github/workflows/validate.yml`)**
```yaml
name: DAE Config Validation
on: [push, pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install linters
        run: pip install yamllint salt-lint
      - name: Lint Pillars & States
        run: |
          yamllint pillar/
          salt-lint salt/
      - name: Validate Schema
        run: python3 scripts/validate_pillar_schema.py pillar/nodes/*.yaml
```

**Validierungsregeln:**
- ✅ `yamllint`: Strikte YAML-Syntax, keine Tabulatoren, konsistente Einrückung
- ✅ `salt-lint`: Korrekte Jinja-Syntax, State-Reihenfolge, veraltete Module erkennen
- ✅ Schema-Check: Erforderliche Keys (`circle_id`, `wireguard_ip`, `role`) müssen vorhanden sein
- ✅ IP-Konflikt-Prüfung: `wireguard_ip` muss im `10.42.0.0/24`-Subnet eindeutig sein

Nur bei erfolgreichem Durchlauf aller Gates wird ein Merge in `main` freigegeben. Dieses Prinzip implementiert **Zero-Trust auf Konfigurationsebene**.

---

## 6.6 Monitoring-Stack & Self-Healing-Drift-Detection

Betriebssicherheit im DAE wird nicht durch externe SaaS-Monitoring-Tools gewährleistet, sondern durch einen lokal deployten, privacy-by-design PLG-Stack (Prometheus, Loki, Grafana) und autonome Heilungslogik.

| Komponente | Aufgabe | DAE-Integration |
|------------|---------|-----------------|
| **Prometheus Node Exporter** | Hardware & OS-Metriken (CPU, RAM, Disk, Net) | Scrape nur über `10.42.0.0/24`, keine externe Exposition |
| **cAdvisor** | Container-Ressourcen & Health | Überwachung von Docker-Services, Auto-Restart bei CrashLoop |
| **Loki** | Log-Aggregation | Logs verbleiben lokal; nur Hashes/Metadaten via `p2plib` sync |
| **Grafana** | Dashboards & Alerting | Access nur via WireGuard; Circle-Only-Sicht |
| **SaltStack Scheduler** | Drift-Detection & Auto-Recovery | Prüft alle 15 Min Service-Status; bei Abweichung: `state.apply` |

**Self-Healing-Workflow:**
```mermaid
flowchart LR
    A["Salt Scheduler<br/>(alle 15 Min)"] --> B{"Service/Config<br/>im Soll-Zustand?"}
    B -->|Ja| C["Nächster Check-Zyklus"]
    B -->|Nein| D["Drift erkannt:<br/>Container down / Config geändert"]
    D --> E["Auto-Rollback:<br/>Letzter validen State aus Git"]
    E --> F["state.apply<br/>Konvergenz erzwingen"]
    F --> G["Health-Check<br/>Validierung erfolgreich?"]
    G -->|Ja| H["Log-Entry: Self-Healing OK"]
    G -->|Nein| I["Alert an Circle-Owner<br/>Manuelle Intervention"]
    
    classDef check fill:#e8f5e9,stroke:#2e7d32;
    classDef drift fill:#fff3e0,stroke:#ef6c00;
    classDef heal fill:#e3f2fd,stroke:#1976d2;
    class A,B,C check;
    class D,E,F,G drift;
    class H,I heal;
```

Diese Architektur gewährleistet, dass das DAE nicht nur konfiguriert, sondern **kontinuierlich validiert und bei Bedarf autonom repariert** wird. Betriebsunterbrechungen werden minimiert, menschliche Intervention auf Ausnahmefälle reduziert.

---

## 6.7 Ausblick auf Ökonomie & Implementierungsleitfaden

Der Betrieb eines DAE ist durch GitOps, automatisierte Validierung und Self-Healing signifikant entlastet von manueller Administration. Konfiguration ist versioniert, reproduzierbar und auditierbar. Monitoring ist lokal, privacy-konform und auf Circle-Ebene begrenzt. Die Infrastruktur verwaltet sich selbst, während der menschliche Operator strategische Circle-Expansion und Service-Integration steuert.

Im nächsten Kapitel wird gezeigt, wie diese Architektur ökonomisch skaliert: Das Kostenmodell pro Node-Paar, die Nutzung globaler Leerlauf-Kapazitäten, ein detaillierter 4-Phasen-Implementierungsplan und praktische Checklisten für den Produktivbetrieb.

---

# 7. Ökonomie, Skalierung & Implementierungsleitfaden

Die technische Architektur eines Decentralized Autonomous Ecosystems (DAE) ist nur dann nachhaltig, wenn sie ökonomisch tragfähig, skalierbar und operativ beherrschbar ist. Im Gegensatz zu Cloud-SaaS-Modellen, die nutzungsbasierte Abrechnungen, versteckte Datenexport-Gebühren und Vendor-Lock-in-Effekte etablieren, operationalisiert das DAE ein kooperatives, transparentes und vorhersagbares Betriebsmodell. Dieses Kapitel übersetzt die infrastrukturellen Prinzipien in konkrete Wirtschaftlichkeitsanalysen, einen strukturierten Implementierungsplan und operative Checklisten für den Produktivbetrieb.

---

## 7.1 Ökonomisches Modell: Von der Extraktion zur kooperativen Wertschöpfung

Zentrale Cloud-Infrastrukturen basieren auf einem extraktiven Geschäftsmodell: Rechenleistung, Speicher und Netzwerkkapazität werden als Produkt verkauft, während Nutzerdaten implizit zur Optimierung, Profilerstellung und Monetarisierung extrahiert werden. Das DAE kehrt diese Logik um durch das Prinzip der **kooperativen Arbeitslastverteilung**:

> *„Jeder weiß ein wenig, jeder muss nicht alles wissen, jeder gibt sein Wissen in die Kooperation."* [[KB]]

Im DAE wird keine Rechenleistung gekauft, sondern sie wird durch die Teilnehmer selbst bereitgestellt und dezentral geteilt. Die ökonomische Wertschöpfung verbleibt im Circle, nicht bei externen Providern. Applikationen, Validierungslogik und Datenspeicherung laufen auf lokal kontrollierter Hardware. Kosten entstehen ausschließlich für physische Infrastruktur, Strom und optionale öffentliche Gateways. Keine API-Rate-Limits, keine Datenexport-Gebühren, keine versteckten Skalierungsaufschläge.

---

## 7.2 Das ungenutzte globale Rechenpotenzial

Eine Analyse der weltweit verfügbaren IT-Infrastruktur (Stand Dezember 2023) zeigt das enorme, bisher weitgehend ungenutzte Potenzial für echte P2P-Architekturen [[KB]]:

| Maschinentyp | Anzahl (Mio.) | Ø CPU-Cores | Gesamt-Cores (Mio.) |
|--------------|---------------|-------------|---------------------|
| **Server** | 17,5 | 64 | 1.120 |
| **Personal Computer** | 350,0 | 8 | 2.800 |
| **Mobile Endgeräte** | 6.000,0 | 4 | 24.000 |
| **Gesamt** | **6.367,5** | – | **~27.920** |

Davon stehen schätzungsweise **~26.800 Millionen Prozessor-Kerne** im überdurchschnittlichen Leerlauf zur Verfügung. Diese Kapazität repräsentiert kein technisches Defizit, sondern ein **gesellschaftliches Infrastruktur-Potenzial**. Das DAE transformiert diesen Leerlauf in:
- Lokale Validierung und Multi-Peer-Konsens
- Dezentrale CRDT-Synchronisation und State-Merge-Logik
- Edge-basierte KI-Inferenz (z. B. lokale LLMs für Chat/BBS)
- Resiliente Kommunikationswege ohne Cloud-Transit

Im Gegensatz zu Modellen, die Rechenleistung zentral bündeln und extern vermarkten, bleibt die Wertschöpfung im DAE bei den Teilnehmenden. Kooperation ersetzt Extraktion.

---

## 7.3 Kostenstruktur & Predictable Betriebskosten (pro Node-Paar)

Das ökonomische Fundament des DAE ist transparent, einmalig kalkulierbar und langfristig stabil. Die folgende Übersicht basiert auf Referenzhardware und realistischen Betriebsbedingungen in Deutschland/EU (Stand Mai 2026).

| Kostenkomponente | Einmalig (pro Paar) | Jährlich (pro Paar) |
|------------------|---------------------|---------------------|
| P330 Tiny (refurbished, i9/32GB/512GB) | ~€280 | – |
| Zusätzliche 1 TB NVMe (Daten/Backup) | ~€60 | – |
| OVH Kimsufi KS-B / VPS (Setup + 1. Monat) | ~€22 | ~€133 |
| Strom (2 Nodes × ~25W idle, €0,30/kWh) | – | ~€130 |
| Domain & DNS (DynDNS / Static) | – | ~€15 |
| **Gesamt** | **~€362** | **~€278** |

> **Durchschnittliche monatliche Kosten:** ~€23,16 pro Node-Paar  
> **Amortisation:** Bei 5 Jahren Laufzeit: ~€35/Monat inklusive Hardware-Abschreibung.

Im Vergleich dazu würde ein äquivalenter SaaS-Stack (WordPress + DB + Chat-Service + Forum-Hosting + Backup-Speicher + VPN + Monitoring) schnell €50–€150+/Monat erreichen, mit unkalkulierbaren Skalierungskosten und Datenexport-Risiken. Das DAE bietet **Predictable Costs**, volle Kontrolle und keine Abhängigkeit von Preisanpassungen Dritter.

---

## 7.4 Implementierungsleitfaden: 4-Phasen-Plan

Der Übergang von der Konzeption zum produktiven DAE-Betrieb folgt einem strukturierten, iterativen Pfad. Jede Phase baut auf der vorherigen auf und schließt mit einer Validierungs-Gate.

| Phase | Dauer | Fokus | Deliverables |
|-------|-------|-------|--------------|
| **Phase 1: Foundation** | Woche 1–2 | Hardware-Setup, OS, TPM-Init, Basis-Netzwerk | P330 Tiny + Kimsufi bereit, TPM 2.0 aktiv, WireGuard/BATMAN-Modul geladen, Salt Minion bootstraped |
| **Phase 2: Circle & Pairing** | Woche 3–4 | Sibling-Kopplung, Dienst-Deployment, Sync-Test | `cs-wizard.py` generiert Pillars, 1:1-Paar aktiv, `p2plib`-Sync verifiziert, Competence Core + Chat lokal betriebsbereit |
| **Phase 3: Scale & Validation** | Woche 5–6 | Multi-Peer-Erweiterung, Konsens-Logik, Monitoring | 3+ Peers im Circle, Multi-Sign-Validierung aktiv, PLG-Stack (Prometheus/Loki/Grafana) deployt, Health-Checks automatisiert |
| **Phase 4: Production & Federation** | Woche 7–8 | Public-Gateway, Inter-Circle-Routing, Hardening | Caddy-HTTPS live, ActivityPub-Federation aktiv, Restic-Backup-Zyklen validiert, CI/CD-Pipeline (yamllint/salt-lint) produktiv |

**Erfolgskriterien pro Phase:**
- ✅ TPM-Key-Sealing/Unsealing funktioniert ohne Plaintext-Exposure
- ✅ WireGuard-Tunnel stabil über NAT, BATMAN-TQ > 80%
- ✅ CRDT-Sync zwischen lokal und öffentlich konsistent & konfliktfrei
- ✅ Self-Healing erkennt & korrigiert Konfig-Drift innerhalb von 15 Min
- ✅ Circle-Autorisierung protokolliert, widerrufbar, auditierbar

---

## 7.5 Checklisten für Produktivbetrieb & Circle-Expansion

### ✅ Pre-Deployment (Hardware & BIOS)
- [ ] Secure Boot & TPM 2.0 im BIOS aktiviert
- [ ] PXE/USB-Boot-Reihenfolge angepasst
- [ ] Dual-NVMe-Konfiguration: NVMe-1 (OS), NVMe-2 (Data)
- [ ] Gigabit-Ethernet priorisiert, WLAN als Fallback konfiguriert
- [ ] Stromversorgung stabilisiert (USV optional für lokale Nodes)

### ✅ Provisioning (GitOps & SaltStack)
- [ ] GitHub-Repository initialisiert, SSH-Keys deployed
- [ ] `gitfs` in `/etc/salt/minion.d/` konfiguriert
- [ ] `cs-wizard.py` ausgeführt, Pillar-Dateien validiert
- [ ] CI/CD-Workflow (`yamllint`, `salt-lint`) erfolgreich durchlaufen
- [ ] `state.apply` ohne Drift-Warnungen abgeschlossen

### ✅ Operational (Circle & Sicherheit)
- [ ] Circle-Mitglieder verifiziert, Keys registriert
- [ ] WireGuard-`PersistentKeepalive=25` auf allen Peers
- [ ] Backup-Zyklen (Restic) bidirektional aktiv, Wiederherstellung getestet
- [ ] Admin-Zugriff nur via WireGuard-IP, Public-Port 443 gehärtet (Caddy)
- [ ] Notfall-Plan dokumentiert: Node-Ausfall, Key-Kompromittierung, WAN-Down

---

## 7.6 Fallback-Szenarien & Resilienz-Strategien

Das DAE ist für Ausfälle, Kompromittierungen und Infrastrukturstörungen ausgelegt. Die folgende Matrix definiert automatische Reaktionen und manuelle Interventionspunkte.

| Szenario | Automatische Reaktion | Operative Konsequenz | Manuelle Intervention |
|----------|----------------------|----------------------|------------------------|
| **WAN/Internet-Ausfall** | BATMAN bleibt aktiv, `p2plib` puffert CRDTs lokal | Lokaler Circle voll funktionsfähig, Sync asynchron bei Reconnect | Keine. System arbeitet offline-first |
| **Node-Absturz / Service-Crash** | Salt Scheduler erkennt Drift, triggert `state.apply` | Container restartet, Config wiederhergestellt | Nur bei wiederholtem CrashLoop; Logs via Loki prüfen |
| **TPM-Seal-Fehler / Key-Exposure** | Unsealing verweigert, Node bootet in Safe-Mode | Private Keys nicht verfügbar, Dienste pausiert | Key-Rotation, neues Sealing, Circle-Reauthorization |
| **Sibling-Node offline** | Lokaler Node bleibt autonom, Backup gestoppt | Öffentliche Termination nicht erreichbar, Daten sicher | Sibling wiederherstellen, Restic-Resync starten |
| **Circle-Split / Fork** | CRDT erkennt divergierende States, markiert Konflikte | Automatische Merge-Logik angewendet, bei Ambiguität: manuell | Circle-Owner reviewed, konsolidiert State, pusst via `p2plib` |

Graceful Degradation ist kein optionales Feature, sondern **architektonisch verankert**. Das System bleibt unter Stressbedingungen funktional, während Integrität und Privatsphäre gewahrt bleiben.

---

## 7.7 Monitoring-Empfehlungen & Self-Healing-Optimierung

Betriebssicherheit im DAE wird durch einen lokal deployten, privacy-by-design PLG-Stack gewährleistet. Externe SaaS-Monitoring-Tools werden bewusst vermieden, um Metadaten-Lecks zu verhindern.

| Metrik | Tool | Schwellwert | Aktion bei Überschreitung |
|--------|------|-------------|---------------------------|
| **BATMAN TQ (Transmission Quality)** | `batctl o` | < 70% | Alternative Route prüfen, Link-Qualität loggen |
| **WireGuard Latency / Packet Loss** | `wg show` | > 50ms / > 2% | Keepalive erhöhen, NAT-Traversal prüfen |
| **Container CPU / RAM** | cAdvisor / Prometheus | > 85% sustained | Service neustarten, Ressourcen-Limit anpassen |
| **CRDT Sync Lag** | `p2plib`-Logs | > 300s | Circle-Gateway prüfen, Bandbreite limitieren |
| **TPM PCR-Drift** | `tpm2_pcrread` | ≠ Baseline | Node in Quarantäne, State-Rollback, Audit-Alert |

**Self-Healing-Workflow:**
```
Salt Scheduler (alle 15 Min) → State-Check → Drift erkannt? → Nein: Continue
                                                              ↓ Ja
Letzter validen State aus Git → state.apply → Health-Check → Erfolgreich? → Log: OK
                                                                           ↓ Nein
Alert an Circle-Admin → Manuelle Review → Fallback-Node aktiv → Recovery-Protokoll
```
Diese Architektur minimiert menschliche Intervention auf Ausnahmefälle und stellt sicher, dass das DAE **kontinuierlich validiert, autonom repariert und dokumentiert** bleibt.

---

## 7.8 Ausblick auf Fazit & Handlungsaufforderung

Die Ökonomie, Skalierung und Implementierung des DAE demonstrieren, dass digitale Souveränität nicht nur technisch machbar, sondern auch wirtschaftlich nachhaltig ist. Predictable Kosten, kooperatives Compute, automatisierte Provisionierung und resiliente Fallback-Strategien transformieren die Infrastruktur von einem experimentellen Setup in eine **produktionsreife, kritische Systemarchitektur**.

Im abschließenden Kapitel werden die technischen, ökonomischen und gesellschaftlichen Argumente synthetisiert, die historische Notwendigkeit echter Dezentralisierung begründet und ein klarer Call-to-Action für Privatpersonen, Entwickler, NGOs und politische Entscheidungsträger formuliert.

---

# 8. Fazit & Handlungsaufforderung

Die technische Architektur, das Betriebsmodell und die ökonomische Tragfähigkeit des Decentralized Autonomous Ecosystems (DAE) sind keine theoretischen Konstrukte. Sie sind die engineering-getriebene Antwort auf die strukturellen Schwächen zentralisierter Infrastrukturen und die applikatorischen Limitationen sogenannter Pseudo-P2P-Systeme. Solange Datenpakete physisch durch fremdverwaltete Rechenzentren fließen und Verbindungen über Layer-7-Relays vermittelt werden, bleibt digitale Souveränität eine vertragliche Fiktion. Das DAE operationalisiert sie als inhärente Systemeigenschaft.

---

## 8.1 Synthese: Infrastruktur als politische Entscheidung

Die vorangegangenen Kapitel haben einen klaren Pfad aufgezeigt: **Digitale Souveränität wird nicht verhandelt, sie wird gebaut.** Das DAE eliminiert die Grundvoraussetzungen des Überwachungskapitalismus durch drei architektonische Hebel:

| Hebel | Technische Umsetzung | Gesellschaftliche Wirkung |
|-------|---------------------|---------------------------|
| **Schicht-Entkopplung** | `B.A.T.M.A.N. advanced` (L2) + `WireGuard` (L3) + `p2plib` (L5–7) | Eliminiert zentrale Vermittler, DNS-Abhängigkeit und Metadaten-Aggregation |
| **Hardware-Vertrauensanker** | TPM 2.0 Sealing, OPAL 2.0, Crypto-Key-Routing | Erzwingt Non-Repudiation, verhindert Key-Exfiltration, operationalisiert Datensouveränität |
| **Circle-Topologie & Kooperation** | Explizite Autorisierung, bidirektionale Sibling-Paare, CRDT-Sync | Ersetzt anonyme Reichweite durch bekannte Identität, Verantwortung und konsensbasierte Validierung |

Die *Competence Signature* dient in diesem Whitepaper lediglich als exemplarische Applikation, um zu demonstrieren, wie Geschäftslogik, Validierung und Datenschutz auf dieser Infrastruktur operieren können. Das DAE selbst ist jedoch **applikations-agnostisch**. Es kann Chat, Forum, Social Federation, CMS, KI-Inferenz, Supply-Chain-Tracking oder kooperative Forschungsdatenräume hosten – stets unter denselben Souveränitätsprinzipien.

---

## 8.2 Warum jetzt? Die Konvergenz von Reife, Notwendigkeit & Potenzial

Fünf historische Treiber bilden einen Wendepunkt, der echte Peer-to-Peer-Architekturen von einem Nischenkonzept zu einer kritischen Infrastruktur macht:

1. **Technologische Reife**: Kernel-integrierte Protokolle, TPM 2.0, Container-Orchestrierung und GitOps sind produktionsstabil, unabhängig auditiert und community-erprobt.
2. **Regulatorischer Druck**: DSGVO, DSA, DMA und globale Datenschutzgesetze machen zentrale Extraktionsmodelle kostspielig und rechtlich riskant. Das DAE ist „compliant by design".
3. **Geopolitische Fragmentierung**: Cloud-Souveränität, nationale Firewalls und Infrastruktursanktionen erfordern resiliente, providerunabhängige Alternativen.
4. **Gesellschaftliches Bewusstsein**: Wachsende Skepsis gegenüber Plattform-Macht, KI-Manipulation und Desinformation schafft Nachfrage nach kontrollierbarer, verifizierbarer Infrastruktur.
5. **Ungenutztes globales Potenzial**: Eine Analyse der IT-Infrastruktur (Stand 2023) zeigt, dass weltweit schätzungsweise **~26.800 Millionen Prozessor-Kerne** in Personal Computern, Mobilgeräten und Servern im überdurchschnittlichen Leerlauf verfügbar sind [[KB]]. Diese Kapazität wird nicht an Cloud-Provider lizenziert, sondern direkt für kooperative Validierung, lokale Dienste und resiliente Replikation nutzbar gemacht.

Wie im KB-Konzept betont: *„Jeder weiß ein wenig, jeder muss nicht alles wissen, jeder gibt sein Wissen in die Kooperation."* Das DAE transformiert diesen Leerlauf in eine aktive, gemeinwohlorientierte Infrastruktur. Kooperation ersetzt Extraktion.

---

## 8.3 Handlungsaufforderung: Wer muss was tun?

Die Transformation von einer extraktiven zu einer souveränen digitalen Infrastruktur erfordert koordinierte, aber dezentrale Aktion. Die folgende Matrix definiert konkrete Handlungsfelder:

| Akteursgruppe | Konkrete Handlung |
|---------------|-------------------|
| **Privatpersonen & Communities** | Betreiben Sie Ihren eigenen Peer (refurbished Hardware + Open-Source-Stack). Bilden Sie lokale Circles. Lernen Sie die Grundlagen von `WireGuard`, `B.A.T.M.A.N.` und `p2plib`. Gewinnen Sie Datenhoheit durch Praxis, nicht durch Apps. |
| **Entwickler & Open-Source-Community** | Treiben Sie `p2plib`-Ökosysteme voran. Integrieren Sie CRDT-Sync und TPM-Sealing in bestehende Frameworks. Dokumentieren, auditen und vereinfachen Sie Deployment. Bauen Sie Tooling, keine Vendor-Lock-ins. |
| **Bildung & Forschung** | Verankern Sie echte P2P-Architekturen (Layer 2–4) in Lehrplänen. Fördern Sie unabhängige Protokoll-Audits. Erforschen Sie kooperative Compute-Modelle, Circle-basierte Konsensmechanismen und Desinformations-Resistenz. |
| **Politik & Regulierung** | Anerkennen Sie lokale P2P-Infrastruktur als digitales Gemeingut. Fördern Sie Edge-Computing-Initiativen und Community-Netzwerke. Erweitern Sie Netzneutralität auf Layer 2/3. Schützen Sie Hardware-Root-of-Trust vor Backdoor-Pflichten. |
| **Unternehmen & NGOs** | Dezentralisieren Sie interne Kommunikations- und Dateninfrastruktur. Ersetzen Sie SaaS-Abhängigkeiten durch autonome Node-Paare. Nutzen Sie P2P für resiliente Notfallkommunikation, transparente Lieferketten und föderale Dienste. |

---

## 8.4 Ausblick: Vom Nischenkonzept zur kritischen Infrastruktur

Echtes Peer-to-Peer wird sich nicht durch Marketing, sondern durch Notwendigkeit durchsetzen. Fünf Entwicklungslinien zeichnen den Übergang vom experimentellen Setup zur kritischen Infrastruktur ab:

1. **Community-Netzwerke & Bildung**: Circles ersetzen zunehmend SaaS-Abhängigkeiten in Schulen, Vereinen und Nachbarschaften. Autonomie wird zur digitalen Grundkompetenz.
2. **Resiliente Notfallkommunikation**: Bei Infrastrukturausfällen, Naturkatastrophen oder geopolitischen Spannungen funktionieren lokale Meshes weiterhin. Gateways dienen nur der kontrollierten Externalisierung.
3. **Öffentliche Infrastruktur & NGOs**: Kommunen, Genossenschaften und zivilgesellschaftliche Organisationen deployen Node-Paare, um Datensouveränität, transparente Lieferketten und föderale Dienste ohne Provider-Lock-in zu betreiben.
4. **Regulatorische Anerkennung**: Datenschutzbehörden und Standardisierungsgremien beginnen, lokale P2P-Architekturen als „Compliance-by-Design" zu klassifizieren. Layer-2/3-Neutralität wird zum neuen Netzneutralitäts-Standard.
5. **Kooperative Compute-Modelle**: Das Prinzip der verteilten Arbeitslast skaliert von lokaler Validierung zu verteilten Workflows, dezentraler KI-Inferenz und gemeinsamen Forschungsdatenräumen.

Das Decentralized Autonomous Ecosystem ist keine Utopie. Es ist eine präzise, reproduzierbare und produktionsreife Architektur, die sich horizontal durch vertrauenswürdige Circles, föderal durch autorisierte Gateways und global durch kryptographischen Konsens skaliert – ohne zentrale Kontrollinstanz, aber mit voller technischer Integrität.

---

## 8.5 Abschließende These

Die Architektur des Internets ist keine technische Neutralität. Sie ist das Ergebnis historischer Entscheidungen, ökonomischer Anreize und infrastruktureller Pfadabhängigkeiten. Dezentrale Peer-to-Peer-Infrastruktur ist die bewusste Entscheidung, diese Pfadabhängigkeit zu durchbrechen. Sie ist die Entscheidung für Souveränität, Resilienz und menschliche Würde im digitalen Zeitalter.

> *„Die Zukunft des Internets wird nicht von Konzernen verhandelt, sondern von Communities gebaut. Echtes Peer-to-Peer ist kein technisches Nischenprojekt. Es ist die infrastrukturelle Wiederherstellung von Eigentum, Privatsphäre und Kooperation im digitalen Raum."*

---
📬 **Kontakt & Contribution**  
Dieses Whitepaper ist ein lebendes Dokument. Feedback, Forks, Implementierungsbeiträge und Peer-Reviews sind ausdrücklich erwünscht.

**Autor**  
Ralf Siebert (aka Maxim R. Garrtner)  
📧 [maxim.r.garrtner@yandex.com](mailto:maxim.r.garrtner@yandex.com)  

**Verfügbare Artefakte auf Anfrage:**  
- Komplette SaltStack-State-Templates & GitFS-Konfiguration  
- Docker Compose Bundle (6 Dienste, identisch pro Node-Paar)  
- `cs-wizard.py` CLI für Circle- & Node-Pair-Generierung  
- `B.A.T.M.A.N. advanced` + `WireGuard` + `p2plib` Setup-Skripte  
- Terraform-Module für OVH Kimsufi / VPS Provisioning  
- Referenz-Implementierung: Competence Signature Core (NodeJS + TPM 2.0)  

---

*© 2026 Ralf Siebert (aka Maxim R. Garrtner). Veröffentlicht unter CC BY-SA 4.0.*  
*Basierend auf den Erkenntnissen aus „Anatomie eines Peer to Peer Netzwerks“ (2023/2026) sowie aktueller Open-Source-Infrastruktur-Praxis.* 🌐🔐
