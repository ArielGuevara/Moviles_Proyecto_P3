import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/chatbot_controller.dart';
import '../../core/domain/entities/message.dart';
import '../../theme/theme_manager.dart';
import '../../theme/color_palette.dart';
import 'widgets/app_background.dart';

class ChatbotScreen extends StatefulWidget {
  final ChatbotController controller;

  const ChatbotScreen({super.key, required this.controller});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  bool isLoading = false;

  void _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    _controller.clear();
    await widget.controller.send(text);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.controller.chat;
    final theme = Theme.of(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final isDark = themeManager.isDarkMode;

    return AppBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final Message msg = messages[index];
                  return Align(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      decoration: BoxDecoration(
                        gradient: msg.isUser
                            ? (isDark ? primaryGradientDark : primaryGradientLight)
                            : (isDark ? darkCardGradient : lightCardGradient),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isUser 
                              ? Colors.white 
                              : (isDark ? modernDarkText : modernLightText),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? azulVibrante : azulVibrante,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Generando respuesta...",
                      style: TextStyle(
                        color: isDark ? modernDarkSecondaryText : modernLightSecondaryText,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? modernDarkSurface.withOpacity(0.8) : Colors.white.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Escribe tu pregunta...",
                        hintStyle: TextStyle(
                          color: isDark ? modernDarkMutedText : modernLightMutedText,
                        ),
                      ),
                      enabled: !isLoading,
                      style: TextStyle(
                        color: isDark ? modernDarkText : modernLightText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: isDark ? primaryGradientDark : primaryGradientLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: isLoading ? null : _handleSend,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}