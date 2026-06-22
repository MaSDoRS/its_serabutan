import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'pembayaran_screen.dart';
import '../models/order_data.dart';

class ChatDetailScreen extends StatefulWidget {
  final String mitraName;
  final String mitraInitial;
  final OrderData orderData;

  const ChatDetailScreen({
    super.key,
    this.mitraName = 'Ghaly Rakha',
    this.mitraInitial = 'G',
    this.orderData = const OrderData(),
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  late final TextEditingController _hargaController;
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final hargaAwal = widget.orderData.hargaJasa.isNotEmpty &&
            widget.orderData.hargaJasa != '5.000'
        ? widget.orderData.hargaJasa
        : widget.orderData.budget.isNotEmpty &&
                widget.orderData.budget != '00.000'
            ? widget.orderData.budget
            : '00.000';
    _hargaController = TextEditingController(text: hargaAwal);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _hargaController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
        'time': TimeOfDay.now().format(context),
      });
    });
    _messageController.clear();
    _scrollToBottom();
  }

  void _sendHarga() {
    final harga = _hargaController.text.trim();
    if (harga.isEmpty || harga == '00.000') return;
    setState(() {
      _messages.add({
        'text': 'Penawaran Harga: Rp $harga',
        'isMe': true,
        'time': TimeOfDay.now().format(context),
        'isOffer': true,
      });
    });
    _hargaController.text = '00.000';
    _scrollToBottom();
  }

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _messages.add({
          'text': '',
          'isMe': true,
          'time': TimeOfDay.now().format(context),
          'imagePath': picked.path,
        });
      });
      _scrollToBottom();
    }
  }

  Future<void> _pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _messages.add({
          'text': '',
          'isMe': true,
          'time': TimeOfDay.now().format(context),
          'imagePath': picked.path,
        });
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildAppBar(context),
            _buildContactHeader(),
            if (widget.orderData.jenisLayanan.isNotEmpty) _buildOrderSummaryBar(),
            Container(height: 1.5, color: Colors.blue.shade50),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'TODAY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  ..._messages.map((msg) => _buildMessageBubble(msg)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            _buildPriceOfferCard(),
            _buildMessageInput(),
          ],
        ),
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
              const Expanded(
                child: Text(
                  'Mitra Penyedia Jasa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF29B6F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.mitraInitial,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF66BB6A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mitraName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryBar() {
    final od = widget.orderData;
    return Container(
      color: const Color(0xFFF5F8FC),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.receipt_long_outlined, size: 18, color: Color(0xFF0288D1)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        od.jenisLayanan,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0288D1)),
                      ),
                      if (od.jumlahMitra > 1) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0288D1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${od.jumlahMitra} org',
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (od.ringkasan.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      od.ringkasan,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (od.alamatTampil.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            od.alamatTampil,
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final bool isMe = msg['isMe'] as bool;
    final bool isOffer = msg['isOffer'] == true;
    final String? imagePath = msg['imagePath'] as String?;

    // Image bubble
    if (imagePath != null) {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
              const SizedBox(height: 4),
              Text(
                msg['time'] as String,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: isOffer
              ? const Color(0xFFE3F2FD)
              : isMe
                  ? const Color(0xFF29B6F6)
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMe ? 14 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              msg['text'] as String,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isOffer ? FontWeight.w700 : FontWeight.w500,
                color: isOffer
                    ? const Color(0xFF1565C0)
                    : isMe
                        ? Colors.white
                        : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              msg['time'] as String,
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white.withValues(alpha: 0.7) : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceOfferCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ajukan Penawaran Harga',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Rp',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: TextField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1565C0),
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _sendHarga,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('Kirim', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PembayaranScreen(
                    total: _hargaController.text.trim(),
                    jenisLayanan: widget.orderData.jenisLayanan,
                    mitraName: widget.mitraName,
                    mitraInitial: widget.mitraInitial,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCDD2),
                foregroundColor: const Color(0xFFE53935),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: const Text(
                'Lakukan Pembayaran',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: _pickFromGallery,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.photo_outlined, size: 20, color: Color(0xFF0288D1)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Masukkan teks di sini',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: InputBorder.none,
                      suffixIcon: GestureDetector(
                        onTap: _pickFromCamera,
                        child: Icon(Icons.camera_alt_outlined, size: 22, color: Colors.grey.shade500),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF29B6F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
