# 🖼️ ImageScanTool

A lightweight Swift CLI tool to **detect dynamic image usage** in your codebase such as:

- `UIImage(named: imageName)`
- `UIImage(named: "icon_\(style)")`
- `Image(named: variable)` (SwiftUI)

---

## 🚀 Installation

### 💚 Using [Mint](https://github.com/yonaskolb/mint)

```bash
mint install forever19735/ImageScanTool
```

Or add to your `Mintfile`:

```
https://github.com/forever19735/ImageScanTool.git
```

---

## 🧪 Build & Run (Local SwiftPM)

```bash
swift build -c release
.build/release/imagescan --source ./Sources --output ./whitelist.txt
```

---

## 📦 Usage

```bash
imagescan --source <source_folder> --output <output_file>
```

### Example:

```bash
imagescan --source ./MyApp/Sources --output ./Generated/whitelist.txt
```

### Options:

| Flag      | Description                              |
|-----------|------------------------------------------|
| `--source`| Path to the folder containing Swift code |
| `--output`| Output path for the generated whitelist  |

---

## 📂 What Gets Picked Up

✅ Dynamic image access patterns like:

```swift
UIImage(named: imageName)
UIImage(named: "icon_\(type)")
Image(systemName: imageIdentifier)
```

🚫 Static strings will be skipped:

```swift
UIImage(named: "icon_home") // skipped
```

---
## ✅ License
MIT
