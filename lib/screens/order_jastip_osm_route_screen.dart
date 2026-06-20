import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'pilih_penyedia_jasa_screen.dart';

class OrderJastipOsmRouteScreen extends StatefulWidget {
  const OrderJastipOsmRouteScreen({super.key});

  @override
  State<OrderJastipOsmRouteScreen> createState() =>
      _OrderJastipOsmRouteScreenState();
}

class _OrderJastipOsmRouteScreenState
    extends State<OrderJastipOsmRouteScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  bool _isLoading = true;

  // Koordinat Tujuan Jastip (Contoh: Titik Toko/Mitra)
  final LatLng _lokasiTujuan = const LatLng(-7.2794, 112.7973);

  double _jarakKm = 0.0;
  double _totalHarga = 0.0;
  final double _tarifPerKm = 5000;

  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _initLokasiJarakDanRute();
  }

  Future<void> _initLokasiJarakDanRute() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Layanan lokasi tidak aktif');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak permanen, buka Pengaturan');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final latAsal = position.latitude;
      final lngAsal = position.longitude;

      double distanceInMeters = Geolocator.distanceBetween(
          latAsal, lngAsal, _lokasiTujuan.latitude, _lokasiTujuan.longitude);

      List<LatLng> ruteJalan = await _getRouteFromOSRM(
          latAsal, lngAsal, _lokasiTujuan.latitude, _lokasiTujuan.longitude);

      if (!mounted) return;

      setState(() {
        _currentPosition = LatLng(latAsal, lngAsal);
        _routePoints = ruteJalan;
        _jarakKm = distanceInMeters / 1000;
        _totalHarga = _jarakKm * _tarifPerKm;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat rute jalan: $e')),
      );
    }
  }

  Future<List<LatLng>> _getRouteFromOSRM(
      double startLat, double startLng, double endLat, double endLng) async {
    final List<LatLng> points = [];
    try {
      final url = Uri.parse(
          'https://router.project-osrm.org/route/v1/driving/$startLng,$startLat;$endLng,$endLat?overview=full&geometries=geojson');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final List<dynamic> coordinates =
              data['routes'][0]['geometry']['coordinates'];
          for (var coord in coordinates) {
            points.add(LatLng(coord[1], coord[0]));
          }
        }
      }
    } catch (e) {
      debugPrint('Gagal mengambil rute OSRM: $e');
      // Fallback ke garis lurus jika API gagal
      points.add(LatLng(startLat, startLng));
      points.add(LatLng(endLat, endLng));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rute & Tarif Jastip'),
        backgroundColor: const Color(0xFFF48FB1),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? const Center(child: Text('Gagal mendapatkan lokasi'))
              : Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _currentPosition!,
                        initialZoom: 14.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.bantai_eas',
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routePoints,
                              strokeWidth: 5.0,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _currentPosition!,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on,
                                  color: Colors.blue, size: 40),
                            ),
                            Marker(
                              point: _lokasiTujuan,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on,
                                  color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 2)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'INFORMASI PESANAN (RUTE TERPETAKAN)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Colors.black54),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Jarak Tempuh:',
                                    style: TextStyle(fontSize: 15)),
                                Text(
                                  '${_jarakKm.toStringAsFixed(2)} km',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Ongkos Jastip:',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  'Rp ${_totalHarga.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PilihPenyediaJasaScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFD54F),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  'KONFIRMASI & CARI MITRA',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
