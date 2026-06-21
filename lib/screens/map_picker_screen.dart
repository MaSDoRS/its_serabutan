import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPickerResult {
  final LatLng latLng;
  final String address;
  MapPickerResult({required this.latLng, required this.address});
}

class MapPickerScreen extends StatefulWidget {
  final String title;
  final LatLng? initialPosition;

  const MapPickerScreen({
    super.key,
    this.title = 'Pilih Lokasi',
    this.initialPosition,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  // ITS Surabaya sebagai default
  static const _defaultCenter = LatLng(-7.2794, 112.7973);

  LatLng _center = _defaultCenter;
  String _currentAddress = 'Geser peta untuk memilih lokasi';
  bool _isLoadingAddress = false;
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _center = widget.initialPosition ?? _defaultCenter;
    // Reverse geocode titik awal
    Future.delayed(const Duration(milliseconds: 500), () {
      _reverseGeocode(_center);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reverseGeocode(LatLng point) async {
    setState(() => _isLoadingAddress = true);
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${point.latitude}&lon=${point.longitude}&format=json&accept-language=id',
      );
      final res = await http.get(url, headers: {'User-Agent': 'bantai_eas/1.0'})
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final display = data['display_name'] as String? ?? '';
        if (mounted) setState(() => _currentAddress = display.isNotEmpty ? display : 'Lokasi dipilih');
      }
    } catch (_) {
      if (mounted) setState(() => _currentAddress = 'Lokasi dipilih (${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)})');
    } finally {
      if (mounted) setState(() => _isLoadingAddress = false);
    }
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() { _searchResults = []; _isSearching = false; });
      return;
    }
    setState(() => _isSearching = true);
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5&countrycodes=id&accept-language=id',
      );
      final res = await http.get(url, headers: {'User-Agent': 'bantai_eas/1.0'})
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        if (mounted) {
          setState(() {
            _searchResults = data.map((e) => e as Map<String, dynamic>).toList();
            _isSearching = false;
          });
        }
      }
    } catch (_) {
      if (mounted) setState(() { _searchResults = []; _isSearching = false; });
    }
  }

  void _selectSearchResult(Map<String, dynamic> result) {
    final lat = double.parse(result['lat'] as String);
    final lng = double.parse(result['lon'] as String);
    final address = result['display_name'] as String? ?? '';
    final newPoint = LatLng(lat, lng);

    _mapController.move(newPoint, 16);
    setState(() {
      _center = newPoint;
      _currentAddress = address;
      _searchResults = [];
      _searchController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Stack(
              children: [
                // Peta
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: 15.5,
                    onMapEvent: (event) {
                      if (event is MapEventMove || event is MapEventFlingAnimation) {
                        setState(() => _center = event.camera.center);
                      }
                      if (event is MapEventMoveEnd || event is MapEventFlingAnimationEnd) {
                        _center = event.camera.center;
                        _reverseGeocode(_center);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.bantai_eas',
                      maxZoom: 19,
                    ),
                  ],
                ),

                // Crosshair pin di tengah layar (tidak ikut gerak)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0288D1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4)],
                        ),
                        child: const Text('Titik Lokasi', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 2),
                      const Icon(Icons.location_on, color: Color(0xFF0288D1), size: 44),
                      // Shadow bawah pin
                      Container(
                        width: 12,
                        height: 5,
                        margin: const EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search bar di atas
                Positioned(
                  top: 12, left: 16, right: 16,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => _search(v),
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Cari alamat atau tempat...',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                            prefixIcon: _isSearching
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                                  )
                                : const Icon(Icons.search, color: Color(0xFF0288D1)),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchResults = []);
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // Hasil pencarian
                      if (_searchResults.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _searchResults.length,
                            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
                            itemBuilder: (ctx, i) {
                              final r = _searchResults[i];
                              return InkWell(
                                onTap: () => _selectSearchResult(r),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.place_outlined, size: 18, color: Color(0xFF0288D1)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          r['display_name'] as String? ?? '',
                                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                // Tombol lokasi saya
                Positioned(
                  right: 16,
                  bottom: 140,
                  child: FloatingActionButton.small(
                    heroTag: 'myLoc',
                    backgroundColor: Colors.white,
                    elevation: 4,
                    onPressed: () {
                      _mapController.move(_defaultCenter, 15.5);
                    },
                    child: const Icon(Icons.my_location, color: Color(0xFF0288D1), size: 20),
                  ),
                ),

                // Bottom panel — tampilkan alamat + tombol pilih
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, spreadRadius: 1)],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF0288D1)),
                            const SizedBox(width: 8),
                            const Text('Lokasi Dipilih',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0288D1))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _isLoadingAddress
                            ? Row(children: [
                                const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                                const SizedBox(width: 8),
                                Text('Memuat alamat...', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                              ])
                            : Text(
                                _currentAddress,
                                style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoadingAddress
                                ? null
                                : () => Navigator.pop(
                                      context,
                                      MapPickerResult(latLng: _center, address: _currentAddress),
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0288D1),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 0,
                            ),
                            child: const Text('Pilih Lokasi Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ],
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
              const Icon(Icons.map_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
              Text('Geser peta untuk menyesuaikan',
                  style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8))),
            ],
          ),
        ),
      ),
    );
  }
}
