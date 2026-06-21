import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'pilih_penyedia_jasa_screen.dart';
import '../models/order_data.dart';

class OrderJastipOsmRouteScreen extends StatefulWidget {
  final LatLng destinasiLatLng;
  final String namaDestinasi;
  final OrderData? orderData;

  const OrderJastipOsmRouteScreen({
    super.key,
    this.destinasiLatLng = const LatLng(-7.2794, 112.7973),
    this.namaDestinasi = 'Lokasi Toko',
    this.orderData,
  });

  @override
  State<OrderJastipOsmRouteScreen> createState() =>
      _OrderJastipOsmRouteScreenState();
}

class _OrderJastipOsmRouteScreenState
    extends State<OrderJastipOsmRouteScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  bool _isLoading = true;
  String? _errorMsg;
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _initLokasiDanRute();
  }

  Future<void> _initLokasiDanRute() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Layanan lokasi tidak aktif. Aktifkan GPS di Pengaturan.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak permanen. Buka Pengaturan untuk mengizinkan.');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      final userLatLng = LatLng(position.latitude, position.longitude);
      final dest = widget.destinasiLatLng;

      final rute = await _getRouteFromOSRM(
        position.latitude, position.longitude,
        dest.latitude, dest.longitude,
      );

      if (!mounted) return;
      setState(() {
        _currentPosition = userLatLng;
        _routePoints = rute;
        _isLoading = false;
      });

      // Fit peta agar kedua marker selalu terlihat
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _fitBounds(userLatLng, dest);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMsg = e.toString();
      });
    }
  }

  void _fitBounds(LatLng a, LatLng b) {
    final minLat = min(a.latitude, b.latitude);
    final maxLat = max(a.latitude, b.latitude);
    final minLng = min(a.longitude, b.longitude);
    final maxLng = max(a.longitude, b.longitude);

    const pad = 0.008;
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(
          LatLng(minLat - pad, minLng - pad),
          LatLng(maxLat + pad, maxLng + pad),
        ),
        padding: const EdgeInsets.fromLTRB(40, 80, 40, 200),
      ),
    );
  }

  Future<List<LatLng>> _getRouteFromOSRM(
      double startLat, double startLng, double endLat, double endLng) async {
    final List<LatLng> points = [];
    try {
      final url = Uri.parse(
          'https://router.project-osrm.org/route/v1/driving/$startLng,$startLat;$endLng,$endLat?overview=full&geometries=geojson');
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          final coords = data['routes'][0]['geometry']['coordinates'] as List;
          for (var coord in coords) {
            points.add(LatLng(coord[1] as double, coord[0] as double));
          }
        }
      }
    } catch (_) {
      // Fallback: garis lurus antar dua titik
      points.add(LatLng(startLat, startLng));
      points.add(LatLng(endLat, endLng));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF0288D1)),
                        SizedBox(height: 16),
                        Text('Memuat lokasi & rute...', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : _errorMsg != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_off_outlined, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(_errorMsg!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() { _isLoading = true; _errorMsg = null; });
                                  _initLokasiDanRute();
                                },
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: LatLng(
                                (_currentPosition!.latitude + widget.destinasiLatLng.latitude) / 2,
                                (_currentPosition!.longitude + widget.destinasiLatLng.longitude) / 2,
                              ),
                              initialZoom: 14,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.bantai_eas',
                                maxZoom: 19,
                              ),
                              if (_routePoints.isNotEmpty)
                                PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      points: _routePoints,
                                      strokeWidth: 5.0,
                                      color: const Color(0xFF0288D1),
                                    ),
                                  ],
                                ),
                              MarkerLayer(
                                markers: [
                                  // Posisi user
                                  Marker(
                                    point: _currentPosition!,
                                    width: 52,
                                    height: 52,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFF0288D1), width: 2.5),
                                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 6)],
                                      ),
                                      child: const Icon(Icons.my_location, color: Color(0xFF0288D1), size: 28),
                                    ),
                                  ),
                                  // Destinasi toko
                                  Marker(
                                    point: widget.destinasiLatLng,
                                    width: 44,
                                    height: 56,
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            widget.namaDestinasi.split(' ').first,
                                            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Icon(Icons.location_on, color: Colors.red, size: 28),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Info card toko (atas)
                          Positioned(
                            top: 12,
                            left: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36, height: 36,
                                    decoration: const BoxDecoration(color: Color(0xFFE3F2FD), shape: BoxShape.circle),
                                    child: const Icon(Icons.store_outlined, size: 20, color: Color(0xFF0288D1)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Tujuan Jastip',
                                            style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
                                        Text(
                                          widget.namaDestinasi,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Tombol fit ulang
                                  GestureDetector(
                                    onTap: () => _fitBounds(_currentPosition!, widget.destinasiLatLng),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE3F2FD),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.fit_screen_outlined, size: 18, color: Color(0xFF0288D1)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bottom panel — hanya tombol
                          Positioned(
                            bottom: 0, left: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16, spreadRadius: 2)],
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PilihPenyediaJasaScreen(
                                        orderData: widget.orderData ?? const OrderData(jenisLayanan: 'Jastip'),
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD54F),
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'KONFIRMASI & CARI PENYEDIA',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.map_outlined, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Rute Jastip',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
