class OrderData {
  final String jenisLayanan;
  final String kategori;
  final String deskripsi;
  final String alamat;
  final int jumlahMitra;
  final String hargaJasa;
  // Sosial
  final String judul;
  final String waktu;
  final String lokasi;
  final String preferensi;
  final String budget;
  // Logistik
  final String titikJemput;
  final String tujuan;
  final String berat;
  final int jumlahBarang;
  // Jastip
  final String namaLokasi;
  final List<String> items;
  final String catatan;
  // Antar Jemput
  final String jenisKendaraan;
  final String hargaAntarJemput;

  const OrderData({
    this.jenisLayanan = '',
    this.kategori = '',
    this.deskripsi = '',
    this.alamat = '',
    this.jumlahMitra = 1,
    this.hargaJasa = '',
    this.judul = '',
    this.waktu = '',
    this.lokasi = '',
    this.preferensi = '',
    this.budget = '',
    this.titikJemput = '',
    this.tujuan = '',
    this.berat = '',
    this.jumlahBarang = 0,
    this.namaLokasi = '',
    this.items = const [],
    this.catatan = '',
    this.jenisKendaraan = '',
    this.hargaAntarJemput = '',
  });

  // Ringkasan singkat untuk ditampilkan di chat
  String get ringkasan {
    final parts = <String>[];
    if (kategori.isNotEmpty) parts.add(kategori);
    if (judul.isNotEmpty) parts.add(judul);
    if (deskripsi.isNotEmpty) parts.add(deskripsi);
    if (namaLokasi.isNotEmpty) parts.add('Toko: $namaLokasi');
    if (items.isNotEmpty) parts.add('Item: ${items.join(", ")}');
    if (titikJemput.isNotEmpty) parts.add('Dari: $titikJemput');
    if (tujuan.isNotEmpty) parts.add('Ke: $tujuan');
    if (berat.isNotEmpty && berat != '0') parts.add('Berat: ${berat}kg');
    if (jumlahBarang > 0) parts.add('$jumlahBarang barang');
    if (jenisKendaraan.isNotEmpty) parts.add(jenisKendaraan);
    return parts.take(3).join(' · ');
  }

  String get alamatTampil => alamat.isNotEmpty ? alamat : lokasi;

  String get hargaTampil {
    if (hargaJasa.isNotEmpty && hargaJasa != '5.000' && hargaJasa != '00.000') return 'Rp $hargaJasa';
    if (budget.isNotEmpty && budget != '00.000') return 'Rp $budget';
    if (hargaAntarJemput.isNotEmpty) return hargaAntarJemput;
    return '';
  }
}
