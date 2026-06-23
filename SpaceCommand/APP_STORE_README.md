# Space Command - App Store Ready 🚀

**Real-time SpaceX launch tracking for iPhone & iPad**

---

## 📋 App Store Submission Status

### ✅ READY FOR SUBMISSION

- [x] Code complete and tested
- [x] All features working (v1.0.0)
- [x] Multiplatform support (iPhone 6s+, iPad Air 2+)
- [x] Multilingue (FR/EN)
- [x] Privacy policy included
- [x] Documentation complete
- [ ] App icon finalized (placeholder - see instructions)
- [ ] Screenshots generated (see APPSTORE_SUBMISSION.md)

---

## 🎯 Quick Start for Publication

### Step 1: Prepare Assets (30 min)
```bash
# 1. Create App Icon 1024×1024
#    → See APPSTORE_SUBMISSION.md for instructions
#    → Place: SpaceCommand/Assets.xcassets/AppIcon.appiconset/
#    → Filename: AppIcon.png

# 2. Generate Screenshots
#    → Use simulator: iPhone 15 Pro Max (1242×2688)
#    → Use simulator: iPad Pro 12.9 (2048×2732)
#    → Tools: xcrun simctl io booted screenshot

# 3. Prepare metadata
#    → Copy text from APPSTORE_SUBMISSION.md
#    → Translate if needed
#    → Proof-read carefully
```

### Step 2: Setup Apple Developer (If needed)
```
1. Visit: https://developer.apple.com/account/
2. Enroll in Apple Developer Program (99$/year)
3. Create App ID: app.spacecommand.SpaceCommand
4. Create Distribution Certificate
5. Create App Store Provisioning Profile
```

### Step 3: Configure Signing in Xcode
```
1. Open SpaceCommand.xcodeproj in Xcode
2. Select target → Signing & Capabilities
3. Set Team to your Apple Developer team
4. Set Signing Certificate to Distribution
5. Verify Provisioning Profile is App Store
```

### Step 4: Archive & Upload
```bash
# Clean
xcodebuild clean

# Archive (Xcode GUI is easier)
# 1. Product → Archive in Xcode
# 2. Organizer window opens
# 3. Click "Distribute App"
# 4. Select "App Store Connect"
# 5. Follow wizard

# OR use Transporter (App Store app)
```

### Step 5: Create App Store Connect Listing
```
1. Visit: https://appstoreconnect.apple.com/
2. Click "My Apps" → "+" → "New App"
3. Platform: iOS
4. Name: Space Command
5. Bundle ID: app.spacecommand.SpaceCommand
6. SKU: SPACE-COMMAND-001
7. Full Access: your role
```

### Step 6: Fill Metadata in App Store Connect
- See **APPSTORE_SUBMISSION.md** for all text
- Copy-paste from there:
  - Description (FR/EN)
  - Keywords
  - Subtitle
  - Support URL
  - Privacy Policy URL

### Step 7: Upload Build & Screenshots
```
1. In App Store Connect → Build
2. Upload via Xcode or Transporter
3. Click "+" → Add Screenshots
4. Upload for each device type:
   - iPhone 6.7" (Pro Max)
   - iPhone 5.5"
   - iPad 12.9"
5. Add text overlays (optional)
```

### Step 8: Content Rating
```
Set to: 4+
All: No inappropriate content
```

### Step 9: Submit for Review
```
1. Review all information
2. Click "Submit for Review"
3. Wait 24-48 hours
4. Check email for status
```

---

## 📊 App Specification

| Item | Value |
|------|-------|
| **Name** | Space Command |
| **Version** | 1.0.0 |
| **Bundle ID** | app.spacecommand.SpaceCommand |
| **Minimum iOS** | 17.0 |
| **Devices** | iPhone 6s+, iPad Air 2+ |
| **Languages** | Français, English |
| **Price** | Free |
| **Category** | Lifestyle / News |
| **Rating** | 4+ |
| **IDFA** | Not used |
| **In-App Purchase** | No |
| **Subscription** | No |

---

## 🎨 Design & Assets

### App Icon
- Size: 1024×1024 PNG
- Colors: Gradient cyan (#3ad6ff) → purple (#7c6bff)
- Style: "SC" text centered, bold, modern
- Location: `SpaceCommand/Assets.xcassets/AppIcon.appiconset/AppIcon.png`

### Screenshots (Recommended Set)
1. **Hero Launch** - Next countdown + stats
2. **Missions List** - Cards with filters
3. **Mission Detail** - Full info + history
4. **Alerts** - Notifications management
5. **Encyclopedia** - Rocket reference

### Colors (Verified)
- **Accent**: #3ad6ff (bright cyan)
- **Accent2**: #7c6bff (purple)
- **Background**: #050d (dark navy)
- **Panel**: #0a0e1a (darker)

---

## ⚙️ Technical Specs

### APIs Used (Public, No Auth)
- **Launch Library 2**: https://ll.thespacedevs.com/2.3.0
- **Wikipedia**: https://en.wikipedia.org/api/rest_v1/

### Permissions
- ✅ Notifications (for T-1h alerts)
- ✅ Network (for API calls)
- ❌ Location
- ❌ Camera
- ❌ Microphone
- ❌ Contacts

### Data Handling
- ✅ All data on-device (no backend)
- ✅ 5-min API cache
- ✅ HTTPS only
- ✅ No personal data collection
- ✅ GDPR compliant

---

## 📝 Required Documents

### Included in Repo
- ✅ **APPSTORE_SUBMISSION.md** - Complete submission checklist
- ✅ **PRIVACY.md** - Privacy Policy (required by App Store)
- ✅ **README.md** - Setup & architecture docs
- ✅ **LICENSE** (add if needed)

### To Create
- [ ] **Icon-1024.png** - App icon file
- [ ] **Screenshots/** - Folder with 3-5 screenshots per device
- [ ] **ACKNOWLEDGMENTS.md** (optional) - Credit The Space Devs, Wikimedia

---

## 🚨 Common Pitfalls (Avoid!)

❌ **AVOID**: Claiming SpaceX affiliation  
✅ **DO**: State clearly "Unofficial app, not affiliated with SpaceX"

❌ **AVOID**: Misleading description  
✅ **DO**: Be accurate about features

❌ **AVOID**: Low-res screenshots  
✅ **DO**: Use exact sizes (1125×2436, 2048×2732)

❌ **AVOID**: Missing privacy policy  
✅ **DO**: Always include (see PRIVACY.md)

❌ **AVOID**: Using SpaceX trademark in name  
✅ **DO**: Use "Space Command" or "SpaceX Launch Tracker"

❌ **AVOID**: Broken APIs or crashes  
✅ **DO**: Test thoroughly on device

---

## 📅 Timeline Estimate

| Task | Time |
|------|------|
| Create icon + screenshots | 1-2 hours |
| Setup Apple Developer | 30 min (if new) |
| Configure code signing | 15 min |
| Archive & upload | 30 min |
| Fill metadata | 30 min |
| App Review (Apple) | 24-48 hours |
| **Total** | **~3-4 hours** + review time |

---

## 🎉 After Launch

### Immediate
- Monitor reviews in App Store
- Set up email notifications
- Prepare response templates for feedback

### Week 1
- Respond to first reviews
- Monitor for crash reports
- Fix critical bugs if found

### Month 1-3
- Plan v1.1 (widgets, shortcuts, etc.)
- Monitor API health
- Analyze user feedback

### Ongoing
- Keep dependencies updated
- Monitor Launch Library 2 API changes
- Add new features based on feedback

---

## 📞 Support & Resources

### Apple Developer
- https://developer.apple.com/app-store/review/guidelines/
- https://developer.apple.com/documentation/

### App Store Connect
- https://appstoreconnect.apple.com/

### Third-Party APIs
- Launch Library 2: https://thespacedevs.com/llapi
- Wikipedia: https://www.mediawiki.org/wiki/API/REST_API

### Tools
- App Icon Generator: https://appicon.co
- Screenshot Maker: https://previewed.app
- Xcode: Built-in simulator and archiver

---

## ✨ Features Summary (For Marketing)

🚀 **Real-time Countdown** - Live timers for every SpaceX launch  
📊 **Complete Details** - Rockets, boosters, missions, orbits  
🔄 **Booster History** - Track reused falcon boosters  
📚 **Encyclopedia** - All SpaceX rockets reference  
🔔 **Smart Alerts** - Notification 1h before launch  
🌐 **Multilingue** - Français & English  
📱 **Universal** - iPhone & iPad optimized  
🎨 **Modern Design** - Glassmorphic dark interface  

---

**Ready to launch? Follow steps in APPSTORE_SUBMISSION.md!** 🚀

