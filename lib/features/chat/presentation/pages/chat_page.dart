import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../controllers/chat_controller.dart';
import '../../data/models/message_model.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Chat')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const LoadingWidget(message: 'Loading messages...');
              }
              if (controller.messages.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 64, color: AppColors.textSecondary),
                      SizedBox(height: 16),
                      Text('No messages yet. Start the conversation!'),
                    ],
                  ),
                );
              }
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg.senderId == controller.currentUserId;
                  return _buildMessageBubble(msg, isMe);
                },
              );
            }),
          ),
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryLight : AppColors.darkCard,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe && message.senderName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.senderName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.accent,
                  ),
                ),
              ),
            Text(
              message.message,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.createdAt),
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primaryLight,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: controller.sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
