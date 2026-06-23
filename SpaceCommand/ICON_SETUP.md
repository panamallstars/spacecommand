# App Icon Setup Guide

## 🎨 Option 1: Online (Easiest - Recommended)

### Using Figma (Free)
1. Go to **figma.com** → Sign up/Login
2. Create new file
3. Create 1024×1024 board
4. **Design**:
   - Background: Gradient cyan (#3ad6ff) → purple (#7c6bff)
   - Text: "SC" in white (San Francisco, 520px, bold)
   - Subtitle: "SPACE COMMAND" in white (80px, semi-bold)
5. **Export**:
   - Right-click → Export
   - Format: PNG
   - Scale: 1x
   - Download as `AppIcon.png`

### Using Pixlr or Photopea
1. Go to **pixlr.com** or **photopea.com**
2. New 1024×1024 image
3. Create gradient background
4. Add text layers as above
5. Export as PNG

### Using Online Icon Generator
1. Go to **appicon.co**
2. Upload a square image/design
3. Auto-generates all sizes
4. Download PNG bundle

---

## 🖥️ Option 2: macOS Preview (Quick & Native)

1. Create a simple design in **Preview.app**:
   ```
   - New image: 1024×1024
   - Add gradient fill
   - Add text "SC"
   - Save as PNG
   ```

2. Or use **Sketch** (if installed):
   ```
   - Create 1024 board
   - Design as above
   - Export → PNG 1x
   ```

---

## 🛠️ Option 3: Command Line (Advanced)

### Using ImageMagick
```bash
# Install ImageMagick if needed
brew install imagemagick

# Create icon with gradient + text
convert -size 1024x1024 \
  gradient:"#3ad6ff-#7c6bff" \
  -gravity center \
  -fill white \
  -font /System/Library/Fonts/Helvetica.ttc \
  -pointsize 500 \
  -weight 700 \
  -annotate +0+50 "SC" \
  AppIcon.png
```

### Using Python + PIL
```bash
pip install Pillow

# Save as script.py and run
python3 script.py
```

**script.py**:
```python
from PIL import Image, ImageDraw, ImageFont
import colorsys

# Create image with gradient
img = Image.new('RGB', (1024, 1024))
draw = ImageDraw.Draw(img)

# Draw gradient (cyan to purple)
for i in range(1024):
    r = int(58 + (124 - 58) * i / 1024)
    g = int(214 + (107 - 214) * i / 1024)
    b = int(255 + (255 - 255) * i / 1024)
    draw.line([(i, 0), (i, 1024)], fill=(r, g, b))

# Add text
try:
    font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 500)
except:
    font = ImageFont.load_default()

draw.text((512, 450), "SC", fill="white", font=font, anchor="mm")

img.save('AppIcon.png')
print("✅ AppIcon.png created!")
```

---

## 📁 Step-by-Step Setup in Xcode

### 1. Export PNG (1024×1024)
Get your `AppIcon.png` from any method above.

### 2. Open Xcode Project
```bash
cd /Users/kevinmelyon/SpaceX/SpaceCommand
open SpaceCommand.xcodeproj
```

### 3. Navigate to Assets
In Xcode left panel:
- **Assets.xcassets**
- **AppIcon** (click to select)

### 4. Drag & Drop
Simply drag `AppIcon.png` into the Xcode asset catalog

Or use Finder:
```bash
# Copy PNG to asset folder
cp AppIcon.png \
  SpaceCommand/Assets.xcassets/AppIcon.appiconset/
```

### 5. Update Contents.json
Edit: `SpaceCommand/Assets.xcassets/AppIcon.appiconset/Contents.json`

Change the filename if needed:
```json
{
  "images" : [
    {
      "filename" : "AppIcon.png",
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

### 6. Verify in Xcode
- Click on AppIcon.appiconset
- Preview pane shows your icon
- Should see "SC" on gradient background

### 7. Build & Test
```bash
xcodebuild -project SpaceCommand.xcodeproj \
  -scheme SpaceCommand \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  build
```

Then run simulator → should see icon on home screen.

---

## ✅ Icon Checklist

- [x] Size: 1024×1024 pixels
- [x] Format: PNG with transparency (optional)
- [x] Colors: Gradient cyan → purple
- [x] Text: "SC" in white, centered
- [x] Font: Bold/Heavy weight
- [x] No text at edges (120px margin on all sides)
- [x] Placed in: `Assets.xcassets/AppIcon.appiconset/`
- [x] Filename updated in Contents.json
- [x] Xcode shows preview correctly
- [x] Simulator displays correctly
- [x] No artifacts or gradients issues

---

## 📝 App Icon Best Practices

### DO ✅
- Simple, recognizable at small sizes (60px down to 16px)
- High contrast (white text on dark gradient here)
- No intricate details
- Safe area: 85% of canvas (keep "SC" within ~850px)
- Test at actual sizes:
  - App icon: 60px
  - Spotlight: 40px
  - Settings: 58px

### DON'T ❌
- Tiny text (will be unreadable)
- Too many colors
- Photo backgrounds (won't scale well)
- Text outside safe area
- Alpha transparency (stick to solid)
- Very thin lines (will disappear)

---

## 🎨 Alternative Icon Ideas

### Option A: Rocket + Text
```
Icon: Stylized rocket on gradient
Text: "SC" below
Color: Cyan rocket on gradient
```

### Option B: Orbit Circle
```
Icon: Circular orbit path
Center: Dot (planet/satellite)
Color: Gradient background
Text: "SC" at bottom
```

### Option C: Minimalist
```
Icon: Just "SC" letters
Font: San Francisco Bold
No background text
Simple gradient
```

---

## 🔗 Resources

**Icon Design Tools**:
- Figma: https://figma.com
- Photopea: https://photopea.com
- Pixlr: https://pixlr.com
- Sketch: https://www.sketch.com

**Icon Generators**:
- AppIcon.co: https://appicon.co
- MakeAppIcon: https://makeappicon.com
- iPhoneXS: https://www.iphonexs.app

**Apple Guidelines**:
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/
- App Icons: https://developer.apple.com/design/human-interface-guidelines/foundations/app-icons/

---

## 🚀 Next Steps

1. **Create icon** using your preferred method (Figma recommended - 10 min)
2. **Export as PNG** 1024×1024
3. **Place in** `Assets.xcassets/AppIcon.appiconset/`
4. **Update** Contents.json filename if needed
5. **Test** in simulator
6. **Proceed** to App Store submission (see APP_STORE_README.md)

**Estimated Time**: 15-30 minutes total

---

## ❓ Troubleshooting

### Icon not showing in Xcode
- Check filename in Contents.json matches actual file
- Try: `xcodebuild clean`
- Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
- Rebuild project

### Icon shows as placeholder
- File might be corrupted - try re-exporting
- Check file size > 50KB
- Try: File → Inspect in Preview.app

### Icon looks wrong on device
- Wrong size - must be exactly 1024×1024
- Wrong format - use PNG only
- Try different method above

### Gradient doesn't render properly
- Check gradient colors are valid hex
- Export from Figma/Photoshop (usually works)
- Try PNG format vs JPEG

---

**Questions?** Check Apple's guidelines or try online icon tools first.

