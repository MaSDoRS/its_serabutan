Catatan: fokus saat ini adalah memperbaiki redirect/callback OAuth Google Supabase yang terjebak ke localhost.

Checklist:
- [x] Ambil kode login Google (redirectTo: io.supabase.flutter://login-callback/)
- [x] Cek AndroidManifest.xml dan Info.plist (belum ada URL scheme/deep link io.supabase.flutter)
- [x] Tambahkan URL scheme io.supabase.flutter di AndroidManifest.xml
- [x] Tambahkan URL scheme io.supabase.flutter di iOS/Info.plist

- [ ] flutter clean + rebuild
- [ ] Tes login Google lagi

