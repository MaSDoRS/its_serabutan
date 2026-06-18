import 'package:flutter/material.dart';

class ChatMitraScreen extends StatefulWidget {
  final String mitraName;

  const ChatMitraScreen({super.key, this.mitraName = 'Yazid Alfarizy'});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Curvy
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: const BoxDecoration(
                color: Color(0xFF1565C0), // Dark blue from image
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'MITRA PENYEDIA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Header Driver Profile
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            // Avatar
                            Stack(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.mitraName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // White text in dark header
                                  ),
                                ),
                                const Text(
                                  'Online',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white70, // White text in dark header
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.videocam, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.phone, color: Colors.white70),
                            const SizedBox(width: 8),
                            const Icon(Icons.more_vert, color: Colors.white70),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Date
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Text(
                '20/08/2026',
                style: TextStyle(fontSize: 11, color: Colors.black45),
              ),
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(_messages[index]);
              },
            ),
          ),
          
          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(_MitraChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isUser) ...[
              Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ],
            Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (message.isUser)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 2),
                    child: Text('Dafa Silaban', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                if (!message.isUser)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(widget.mitraName, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFFBE122), width: 1.5),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isUser ? 16 : 0),
                      bottomRight: Radius.circular(message.isUser ? 0 : 16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.text,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF73C2DF),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message.time,
                        style: const TextStyle(fontSize: 8, color: Colors.black38),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (message.isUser) ...[
              Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFBE122)),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(Icons.emoji_emotions_outlined, color: Colors.grey.shade400, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Masukkan teks di sini',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    Icon(Icons.folder_open, color: Colors.grey.shade600, size: 20),
                    const SizedBox(width: 8),
                    Icon(Icons.camera_alt_outlined, color: Colors.grey.shade600, size: 20),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFBE122)),
              ),
              child: const Icon(Icons.mic, color: Colors.black87),
            ),
          ],
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

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 2, size.height + 10, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
