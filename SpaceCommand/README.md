# Space Command — iOS app

Déclinaison native SwiftUI du tracker LAUNCHPAD : iPhone + iPad, dark, mêmes données, mêmes patches, mêmes comptes à rebours, plus des notifications T-1h locales.

## Pour ouvrir le projet

```bash
cd /Users/kevinmelyon/SpaceX/SpaceCommand
open SpaceCommand.xcodeproj
```

Puis dans Xcode : ⌘R pour lancer sur un simulateur iPhone ou iPad.

## Régénérer le `.xcodeproj`

Si tu ajoutes des fichiers Swift, le projet se régénère depuis `project.yml` :

```bash
brew install xcodegen          # une seule fois
cd /Users/kevinmelyon/SpaceX/SpaceCommand
xcodegen generate
```

XcodeGen scanne le dossier `SpaceCommand/` et reconstruit le `.xcodeproj` — pas besoin de drag/drop manuel.

## Architecture

```
SpaceCommand/
├── SpaceCommandApp.swift          App entry + TabView iPhone / SplitView iPad
├── Models/
│   ├── Launch.swift               Codable models pour Launch Library 2
│   └── Rocket.swift               Catalogue encyclopédie (F1, F9, FH, Starship)
├── Services/
│   ├── APIClient.swift            URLSession async/await + fallback dev endpoint
│   ├── WikipediaService.swift     REST API summary + cache mémoire
│   └── NotificationService.swift  UNUserNotificationCenter T-1h
├── Theme/
│   ├── Theme.swift                Palette, fonts, PanelStyle
│   └── StarsBackground.swift      Canvas starfield + glows
├── Views/
│   ├── LaunchesView.swift         Grille des lancements + tabs F9/FH/SS + search
│   ├── LaunchesViewModel.swift
│   ├── LaunchCard.swift           Carte mission
│   ├── NextLaunchHero.swift       Bandeau « prochain décollage »
│   ├── StatStrip.swift            Stats flotte (lancements, atterrissages, réuse…)
│   ├── MissionDetailView.swift    Détail mission + booster + Wikipedia + bouton notif
│   ├── EncyclopediaView.swift     Fiches lanceurs avec specs
│   ├── AlertsView.swift           Notifications programmées
│   ├── SettingsView.swift         Langue, notifs, à propos
│   └── Countdown.swift            Compte à rebours animé
└── Localization/
    └── AppLanguage.swift          Switch FR/EN persistant (AppStorage)
```

## Stack

- **SwiftUI** (iOS 17+), `NavigationSplitView` pour iPad, `TabView` pour iPhone.
- **Async/await** pour le réseau, `actor` pour le cache Wikipedia.
- **UNUserNotificationCenter** pour les alertes T-1h locales (pas de serveur).
- **Aucune dépendance externe** — tout est natif Apple.

## Données

- API publique : The Space Devs · Launch Library 2 (`ll.thespacedevs.com`).
- Fallback automatique sur l'endpoint dev en cas de rate limit.
- Wikipedia REST API pour les résumés (FR/EN selon la langue active).

## Responsive

`@Environment(\.horizontalSizeClass)` aiguille entre :
- iPhone (`.compact`) → TabView en bas, grille 1 colonne.
- iPad (`.regular`) → NavigationSplitView sidebar + détail, grille auto-fit 2–3 colonnes.

## Notifications

L'utilisateur tape « Me prévenir 1 h avant » sur l'écran d'une mission → `UNCalendarNotificationTrigger` planifié à `net - 3600 s`. La permission est demandée la première fois. Toutes les alertes programmées sont visibles dans l'onglet Alertes et peuvent être annulées une par une ou globalement.

## Notes de design

- Police principale : SF Rounded en mode `.expanded` (substitut SF d'Orbitron).
- Mono : SF Mono système.
- Gradient signature : cyan `#3AD6FF` → violet `#7C6BFF`.
- Couleurs famille : F9 cyan, FH orange, Starship jaune.
- Statut : `GO` vert, `TBD` jaune, `HOLD` rouge.
- Toutes les surfaces utilisent `panel()` avec backdrop blur natif via `Material`.

## Tests rapides

```bash
xcodebuild -project SpaceCommand.xcodeproj -scheme SpaceCommand \
  -destination 'generic/platform=iOS Simulator' -sdk iphonesimulator build
```

Doit afficher `** BUILD SUCCEEDED **`.

## Étapes pour publier sur l'App Store

1. Compte Apple Developer (99 $/an).
2. Dans Xcode : Signing & Capabilities → équipe + bundle ID unique.
3. Ajouter une vraie icône (1024×1024) dans `Assets.xcassets/AppIcon.appiconset/`.
4. Archive → Distribute App → App Store Connect.
5. Description App Store, captures iPhone 6.7"/iPad 12.9", fiche de confidentialité.

Le projet inclut déjà la structure pour les icônes (`AppIcon.appiconset/Contents.json`) — il suffit d'ajouter le PNG.
