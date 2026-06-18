##############################################################
# Makefile — Build Helper untuk equran-app
# Jalankan: make <target>
##############################################################

.PHONY: help clean build-android-apk install-apk build-android-aab build-ios build-web build-all analyze

# Direktori untuk menyimpan debug symbols (wajib untuk --obfuscate)
DEBUG_INFO_DIR := build/debug-info

# Konfigurasi untuk install APK
DEVICE_ID ?= 1381270562013940
APK_PATH ?= build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

help: ## Tampilkan daftar perintah
	@echo ""
	@echo "  ╔══════════════════════════════════════════════════╗"
	@echo "  ║        equran-app — Build Commands               ║"
	@echo "  ╚══════════════════════════════════════════════════╝"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-28s\033[0m %s\n", $$1, $$2}'
	@echo ""

clean: ## Bersihkan build artifacts
	flutter clean
	rm -rf $(DEBUG_INFO_DIR)

build-android-apk: ## Build APK per ABI (arm64, armv7, x86_64) — ukuran kecil
	@echo "🔨 Building Android APK (split per ABI)..."
	@mkdir -p $(DEBUG_INFO_DIR)/android
	flutter build apk \
		--release \
		--split-per-abi \
		--no-tree-shake-icons
	@echo ""
	@echo "📦 Ukuran APK:"
	@ls -lh build/app/outputs/flutter-apk/*.apk | awk '{print "  " $$5 "  " $$9}'
	@echo ""
	@echo "✅ APK tersimpan di: build/app/outputs/flutter-apk/"

install-apk: ## Install arm64-v8a release APK ke device adb (default: 1381270562013940)
	@echo "📲 Installing APK to device $(DEVICE_ID)..."
	adb -s $(DEVICE_ID) install -r "$(APK_PATH)" 2>&1

build-android-aab: ## Build Android App Bundle (AAB) untuk Google Play
	@echo "🔨 Building Android App Bundle (AAB)..."
	@mkdir -p $(DEBUG_INFO_DIR)/android
	flutter build appbundle \
		--release \
		--no-tree-shake-icons
	@echo ""
	@echo "📦 Ukuran AAB:"
	@ls -lh build/app/outputs/bundle/release/*.aab | awk '{print "  " $$5 "  " $$9}'
	@echo ""
	@echo "💡 Info: Ukuran AAB adalah gabungan seluruh arsitektur (Universal)."
	@echo "   Saat di-download pengguna dari Play Store, ukurannya akan jauh lebih kecil"
	@echo "   (estimasi ~30-38 MB, mirip dengan ukuran APK per ABI)."
	@echo ""
	@echo "✅ AAB tersimpan di: build/app/outputs/bundle/release/"

build-ios: ## Build iOS IPA (perlu Mac + Xcode)
	@echo "🔨 Building iOS IPA..."
	@mkdir -p $(DEBUG_INFO_DIR)/ios
	flutter build ipa \
		--release \
		--obfuscate \
		--split-debug-info=$(DEBUG_INFO_DIR)/ios \
		--no-tree-shake-icons
	@echo ""
	@echo "📦 Ukuran IPA:"
	@ls -lh build/ios/ipa/*.ipa 2>/dev/null | awk '{print "  " $$5 "  " $$9}' || echo "  (IPA ada di Xcode Organizer)"
	@echo ""
	@echo "✅ Build selesai."

build-web: ## Build Web (PWA)
	@echo "🔨 Building Web..."
	flutter build web \
		--release \
		--web-renderer canvaskit \
		--pwa-strategy offline-first \
		--source-maps \
		--no-tree-shake-icons
	@echo ""
	@echo "📦 Ukuran Web output:"
	@du -sh build/web/
	@echo ""
	@echo "✅ Web tersimpan di: build/web/"

build-all: clean build-android-apk build-android-aab ## Build semua target Android (clean + APK + AAB)
	@echo ""
	@echo "🎉 Semua build selesai!"

analyze: ## Jalankan analisis ukuran build (size report)
	@echo "📊 Menganalisis ukuran app..."
	flutter build apk --analyze-size --target-platform android-arm64
	@echo ""
	@echo "💡 Tip: Gunakan 'make build-android-apk' untuk build optimized."
