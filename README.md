MozzartApp (SwiftUI)

Funkcionalnosti

Offline-first
    •    Na pokretanju se prvo prikazuju keširani podaci (ako postoje).
    •    Mrežni pozivi se izvršavaju paralelno u pozadini.
    •    Ako nema interneta → koristi se poslednji keširani response.

⸻

Postepeno učitavanje
    •    Sports, Matches i Competitions se učitavaju nezavisno.
    •    UI se renderuje i kada neki endpoint vrati prazno ili failuje.
    •    Svaki deo ekrana se osvežava čim njegovi podaci postanu dostupni.

⸻

Filtriranje
    •    Sport filter (gornji): filtrira LIVE i PREMATCH po sportId.
    •    Day filter: danas, sutra, vikend, sledeci, sve (filter sve prikazuje sve prematch igre zbog prikaza UI, jer svi datumi iz apija su u proslosti - decembar 2025)

⸻

Mapiranja
    •    competitionId → competition.name
    •    sportId → naziv + SF Symbol
    •    vreme:
    •    Fudbal: 1./2. poluvreme – xx’ - ako je sport = fudbal dodavace se “poluvreme”
    •    Ostali sportovi: prikazuje se raw vrednost (npr. “Game 8”, “23’”)

⸻

Slike i SVG ograničenja

API vraća SVG URL-ove (Dicebear, CDN).

Pošto:
    •    Eksterne biblioteke su zabranjene
    •    SwiftUI nema nativnu SVG podršku
    •    WKWebView je testiran ali se pokazao nestabilnim u horizontalnim kontrolama (layout glitch, flickering…itd)

donete su sledeće odluke:

Sport filter

Koriste se SF Symbols radi stabilnosti i performansi.

Sports ikonice su dostupne u SVG formatu. Pošto su eksterne biblioteke zabranjene, a SwiftUI nema nativnu podršku za SVG, za sport filter su korišćeni SF Symbols radi stabilnosti i boljeg UX-a.

Team / League slike
    •    SVG → PNG endpoint (Dicebear podržava /png)
    •    URLCache za offline rad
    •    Fallback (inicijali / system icon)

⸻

Dicebear Rate Limit (429)

Dicebear povremeno vraća HTTP 429.

Rešeno:
    •    Cache-first pristup
    •    Lokalni fallback (inicijali)

⸻

Arhitektura

Slojevi
    •    View (SwiftUI) — layout i prikaz
    •    ViewModel — state, filtriranje, formatiranje
    •    Repository / API layer — remote fetch + fallback na cache
    •    Cache layer — lokalno čuvanje JSON podataka + URLCache za slike

⸻

Data Flow
    1.    View se prikazuje odmah.
    2.    Keširani podaci se učitavaju i prikazuju.
    3.    Pokreće se paralelni refresh:
    •    refreshMatches()
    •    refreshCompetitions()
    •    refreshSports()
    4.    Svaki refresh:
    •    pokušava remote fetch
    •    ako uspe → kešira i vraća remote
    •    ako failuje → vraća cache ili prazan niz

⸻


Korišćen je TaskGroup za paralelno osvežavanje endpointa. Svi endpointi su nezavisni → nema potrebe čekati jedan da se završi pre drugog.

Resenje celokupnog zadatka uradjeno je za oko 11-12h. Deo od 3-4 sata potrosen je na najbolji pristup za prikaz Svg slika kao i njihovo kesiranje, razlozi za native tok umesto importa biblioteka kao testiranje kako se WebKit moze ponasati. Oko 3 sata je potroseno na UI i njegove custom komponente i ostatak na setup projekta, apija, modela i arhitekturu projekta. 
