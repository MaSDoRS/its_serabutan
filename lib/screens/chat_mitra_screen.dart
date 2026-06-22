import 'package:flutter/material.dart';

class ChatMitraScreen extends StatefulWidget {
  final String mitraName;
  final String customerName;

  const ChatMitraScreen({
    super.key,
    this.mitraName = 'Yazid Alfarizy',
    this.customerName = 'Customer',
  });

  @override
  State<ChatMitraScreen> createState() => _ChatMitraScreenState();
}

class _ChatMitraScreenState extends State<ChatMitraScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final List<_MitraChatMessage> _messages = [
    _MitraChatMessage(
      text: 'Selamat pagi bapak, apakah titik jemput dan titik antarnya sudah sesuai?',
      isUser: false,
      time: '19.17',
    ),
    _MitraChatMessage(
      text: 'Sudah sangat sesuai pak',
      isUser: true,
      time: '19.17',
    ),
    _MitraChatMessage(
      text: 'Oh iya, btw saya cewe pak',
      isUser: true,
      time: '19.17',
    ),
    _MitraChatMessage(
      text: 'Maaf Mba, siap saya otw ke titik jemput',
      isUser: false,
      time: '19.18',
    ),
    _MitraChatMessage(
      text: 'Oke siap pak',
      isUser: true,
      time: '19.17',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_MitraChatMessage(
        text: text,
        isUser: true,
        time: TimeOfDay.now().format(context),
      ));
    });
    _messageController.clear();
    _scrollToBottom();
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
            Container(height: 1.5, color: Colors.blue.shade50),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // Date label
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '20/08/2026',
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
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────────
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
          padding:
              const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Mitra Penyedia',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Action icons
              Icon(Icons.videocam_outlined,
                  color: Colors.white.withValues(alpha: 0.85), size: 22),
              const SizedBox(width: 16),
              Icon(Icons.phone_outlined,
                  color: Colors.white.withValues(alpha: 0.85), size: 22),
              const SizedBox(width: 16),
              Icon(Icons.more_vert,
                  color: Colors.white.withValues(alpha: 0.85), size: 22),
            ],
          ),
        ),
      ),
    );
  }

  // ── Contact Header ─────────────────────────────────────────────────────────
  Widget _buildContactHeader() {
    // Initial letter dari mitraName
    final initial =
        widget.mitraName.isNotEmpty ? widget.mitraName[0].toUpperCase() : 'M';

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
                    initial,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Online indicator
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

  // ── Chat Bubble ────────────────────────────────────────────────────────────
  Widget _buildMessageBubble(_MitraChatMessage message) {
    final bool isMe = message.isUser;
    final String senderName = isMe ? widget.customerName : widget.mitraName;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender name
            Padding(
              padding: const EdgeInsets.only(bottom: 3, left: 4, right: 4),
              child: Text(
                senderName,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            // Bubble
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.68,
              ),
              decoration: BoxDecoration(
                color: isMe
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
                    message.text,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isMe ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: TextStyle(
                      fontSize: 9,
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Input Area ─────────────────────────────────────────────────────────────
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
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Gallery icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.photo_outlined,
                    size: 20, color: Color(0xFF0288D1)),
              ),
              const SizedBox(width: 10),
              // Text field
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
                      hintStyle: TextStyle(
                          fontSize: 13, color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.camera_alt_outlined,
                          size: 22, color: Colors.grey.shade500),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Send button
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF29B6F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send,
                      size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MitraChatMessage {
  final String text;
  final bool isUser;
  final String time;

  _MitraChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}