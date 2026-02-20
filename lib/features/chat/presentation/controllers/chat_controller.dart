import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/models/message_model.dart';
import '../../../../core/utils/storage_service.dart';

class ChatController extends GetxController {
  final ChatRemoteDatasource _datasource = ChatRemoteDatasource();
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;
  String? currentUserId;

  late String teamId;
  io.Socket? _socket;

  @override
  void onInit() {
    super.onInit();
    teamId = Get.arguments as String? ?? '';
    if (teamId.isNotEmpty) {
      _loadUserId();
      fetchMessages();
      _connectSocket();
    }
  }

  Future<void> _loadUserId() async {
    final userData = await StorageService.getUserData();
    if (userData != null) {
      final data = jsonDecode(userData);
      currentUserId = data['_id'];
    }
  }

  void _connectSocket() {
    _socket = io.io(
      'http://10.0.2.2:5000',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      _socket!.emit('joinTeam', teamId);
    });

    _socket!.on('newMessage', (data) {
      if (data is Map<String, dynamic>) {
        final msg = MessageModel.fromJson(data);
        final alreadyExists = messages.any((m) => m.id == msg.id);
        if (!alreadyExists) {
          messages.add(msg);
          _scrollToBottom();
        }
      }
    });
  }

  Future<void> fetchMessages() async {
    isLoading.value = true;
    try {
      final data = await _datasource.getMessages(teamId);
      messages.value = data.map((json) => MessageModel.fromJson(json)).toList();
      _scrollToBottom();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();
    try {
      await _datasource.sendMessage(teamId, text);
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _socket?.emit('leaveTeam', teamId);
    _socket?.disconnect();
    _socket?.dispose();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
