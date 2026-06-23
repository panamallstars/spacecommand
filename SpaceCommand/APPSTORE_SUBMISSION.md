# Space Command - App Store Submission Guide

## ✅ Checklist Pré-Soumission

### 1. **Account & Certificates** 
- [ ] Compte Apple Developer actif (99$/an) à developer.apple.com
- [ ] Créer/configurer App ID: `app.spacecommand.SpaceCommand`
- [ ] Créer certificats de signature (Distribution)
- [ ] Créer Provisioning Profile pour Distribution

### 2. **App Metadata** (PRÊT ✅)
- [ ] Nom: **Space Command**
- [ ] Version: **1.0.0**
- [ ] Bundle ID: **app.spacecommand.SpaceCommand**
- [ ] Deployment Target: **iOS 17.0+**
- [ ] Devices: **iPhone 6s+, iPad Air 2+**
- [ ] Orientations: **Portrait (iPhone), All (iPad)**

### 3. **App Icon** (À FAIRE)
- [ ] Créer icon 1024x1024 PNG (voir instructions ci-dessous)
- [ ] Placer dans `Assets.xcassets/AppIcon.appiconset/`

### 4. **Screenshots** (À FAIRE)
Générer pour App Store Connect :
- **iPhone 6.7"** (Pro Max) : 1242×2688 px
- **iPhone 5.5"** : 1125×2436 px
- **iPad 12.9"** : 2048×2732 px

### 5. **Listing Text**

#### **App Name**
```
Space Command
```

#### **Subtitle** (FR/EN)
```
FR: Suivi en temps réel des lancements SpaceX
EN: Real-time SpaceX launch tracking
```

#### **Description** (FR)
```
Space Command est l'application officieuse pour suivre en direct tous les lancements SpaceX.

🚀 FONCTIONNALITÉS:
• Lancements à venir : Retrouvez tous les lancements prévus avec compte à rebours en temps réel
• Détails complets : Fusées, boosters, missions, pads, orbites — tout ce qu'il faut savoir
• Historique des boosters : Voyez l'historique de vol complet de chaque booster réutilisé
• Encyclopédie SpaceX : Référence complète des fusées (Falcon 9, Falcon Heavy, Starship)
• Alertes intelligentes : Recevez une notification 1 heure avant chaque lancement
• Multilingue : Français et English

📊 DONNÉES EN TEMPS RÉEL:
- 500+ lancements historiques
- Taux de réussite de 99%+
- Statistiques de réutilisation des boosters

🎨 DESIGN:
- Interface sombre et moderne (glassmorphic)
- Animations fluides
- Optimisée pour iPhone et iPad

⚠️ DISCLAIMER:
Space Command est un projet non-officiel, sans affiliation avec SpaceX. Les données proviennent de The Space Devs (Launch Library 2) et Wikipedia.
```

#### **Description** (EN)
```
Space Command is an unofficial app to track all SpaceX launches in real-time.

🚀 FEATURES:
• Upcoming Launches: Browse all scheduled launches with live countdown timers
• Complete Details: Rockets, boosters, missions, pads, orbits — everything you need
• Booster History: View the complete flight history of each reused booster
• SpaceX Encyclopedia: Complete reference of rockets (Falcon 9, Falcon Heavy, Starship)
• Smart Alerts: Get notifications 1 hour before launch
• Multilingual: Français and English

📊 REAL-TIME DATA:
- 500+ historical launches
- 99%+ success rate
- Booster reusability statistics

🎨 DESIGN:
- Modern dark interface (glassmorphic)
- Smooth animations
- Optimized for iPhone and iPad

⚠️ DISCLAIMER:
Space Command is an unofficial project, not affiliated with SpaceX. Data sourced from The Space Devs (Launch Library 2) and Wikipedia.
```

#### **Keywords** (FR)
```
SpaceX, fusée, lancement, Falcon 9, Starship, espace, NASA, countdown, booster
```

#### **Keywords** (EN)
```
SpaceX, rocket, launch, Falcon 9, Starship, space, NASA, countdown, booster
```

#### **Support URL**
```
https://github.com/yourusername/SpaceCommand/issues
```

#### **Privacy Policy URL**
```
https://github.com/yourusername/SpaceCommand/blob/main/PRIVACY.md
```

### 6. **Content Rating**
- Age Rating: **4+**
- Alcohol/Tobacco: No
- Violence: No
- Mature Content: No
- Medical: No
- Gambling: No

### 7. **App Review Information**
- **Demo Account** (if needed): N/A — app is publicly available
- **Notes**: 
```
Space Command is a real-time SpaceX launch tracker using public APIs:
- Launch Library 2 API (The Space Devs)
- Wikipedia REST API

The app includes local push notifications (T-1h before launches).
All data is fetched from public sources.
No authentication required.
```

## 🎨 App Icon Creation

### Option 1: Quick (Recommended for App Store)
1. Open Figma (figma.com) → New File
2. Create 1024×1024 canvas
3. Design:
   - Background: Linear gradient from #3ad6ff (cyan) to #7c6bff (purple)
   - Text: "SC" in white, 400px font, centered
   - Style: Bold, modern, clean
4. Export as PNG 1024×1024
5. Place in: `SpaceCommand/Assets.xcassets/AppIcon.appiconset/`
6. Update `Contents.json` filename if needed

### Option 2: Online Tool
- Use AppIcon.co or makeappicon.com
- Upload a base image → auto-generates all sizes

### Option 3: Command Line
```bash
# Using ImageMagick (if installed)
convert -size 1024x1024 xc: \
  \( -size 1024x1024 gradient:cyan-blue \) \
  -composite \
  -fill white -font Arial -pointsize 400 \
  -gravity center -annotate +0+0 "SC" \
  AppIcon.png
```

## 📸 Screenshots for App Store

### iPhone Screenshots (1125×2436)
Generate 3-5 screenshots showing:
1. **Home Screen** - Next launch + countdown
2. **Missions List** - Cards with images and filters
3. **Mission Detail** - Full launch info + booster history
4. **Alerts** - Notification management
5. **Encyclopedia** - Rocket reference

### iPad Screenshots (2048×2732)
Show SplitView layout with sidebar + detail

### Adding Text Overlays
Use Xcode Screenshots + annotation, or:
```
Tools: Figma, Preview.app (macOS), or ScreenFlow
Font: San Francisco (same as iOS)
Colors: White text, use app's accent colors
```

## 🔒 Privacy Policy

Create `PRIVACY.md`:
```markdown
# Privacy Policy - Space Command

## Data Collection
- No personal data collected
- No user accounts
- No tracking or analytics

## API Usage
- Launch Library 2 (Public API)
- Wikipedia REST API (Public API)
- All data is anonymously fetched

## Local Storage
- Notification preferences stored locally on device
- Language preference stored locally on device

## Permissions
- Notification permission (for T-1h alerts)
- Network permission (for API calls)

## Contact
[Your Email]
```

## 📋 Submission Checklist

### Before Archive
- [ ] Update version in `project.yml` if needed
- [ ] Test on real iOS 17.0+ device
- [ ] Test all features: launches, filters, alerts, i18n
- [ ] Verify App Icon (1024×1024)
- [ ] Verify screenshots (all required sizes)
- [ ] Test dark mode
- [ ] Test light mode (if supported)
- [ ] Test landscape orientation (iPad)

### Build & Archive
```bash
# 1. Clean
xcodebuild clean

# 2. Generate Xcode project
xcodegen generate

# 3. Archive (requires valid signing identity)
xcodebuild archive \
  -project SpaceCommand.xcodeproj \
  -scheme SpaceCommand \
  -archivePath ./build/SpaceCommand.xcarchive \
  -configuration Release \
  -sdk iphoneos

# 4. Export for App Store (Xcode GUI recommended)
# Or use: xcodebuild -exportArchive -archivePath ./build/SpaceCommand.xcarchive ...
```

### In App Store Connect
1. Create new version
2. Fill in all metadata (see above)
3. Upload screenshots for each device type
4. Add 2-3 preview videos (optional, recommended)
5. Set pricing: **Free**
6. Select categories: **Lifestyle** or **News**
7. Add age rating
8. Enable "Made in France" (if applicable)
9. Submit for review

## 🎯 Important Notes

**Development Team**: You'll need to:
1. Have an Apple Developer account (99$/year)
2. Create App ID in Apple Developer portal
3. Create Distribution certificate
4. Create Ad Hoc or App Store distribution profile
5. Configure code signing in Xcode

**Bundle ID**: Must match `app.spacecommand.SpaceCommand` in Apple Developer portal

**Review Time**: Typically 24-48 hours

**Rejection Reasons** (avoid):
- Missing privacy policy
- Misleading description (don't claim affiliation with SpaceX)
- Broken APIs or crashes
- Missing app icon
- Poor resolution screenshots

## 📞 After Launch

- Monitor reviews and ratings
- Respond to user feedback
- Monitor API health (Launch Library 2)
- Plan future updates:
  - v1.1: iPad widgets
  - v1.2: Siri shortcuts
  - v1.3: Watch app
  - v2.0: AR rocket viewer

---

**Questions?** Check Apple's App Store Review Guidelines:
https://developer.apple.com/app-store/review/guidelines/
