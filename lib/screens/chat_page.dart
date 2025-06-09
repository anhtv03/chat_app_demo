import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/api_constants.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/models/message.dart';
import 'package:chat_app_demo/models/friend.dart';
import 'package:chat_app_demo/models/DTOs/message_dto.dart';
import 'package:chat_app_demo/services/token_service.dart';
import 'package:chat_app_demo/services/message_service.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatPage extends StatefulWidget {
  final Friend friend;

  const ChatPage({super.key, required this.friend});

  @override
  State<StatefulWidget> createState() => ChatCustomPage();
}

class ChatCustomPage extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  late Friend _friend;
  late Box<Message> _messageBox;

  @override
  void initState() {
    super.initState();
    _friend = widget.friend;
    _openBoxAndLoadMessage();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_headerTitle()],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_contentMessage(), _buildInput(screenHeight)],
      ),
    );
  }

  //==========================handle logic==============================
  Future<void> _openBoxAndLoadMessage() async {
    _messageBox = await Hive.openBox<Message>('messages_${_friend.friendID}');
    setState(() {});

    try {
      String token = await TokenService.getToken('user') as String;
      DateTime? lastTime;
      if (_messageBox.values.isNotEmpty) {
        lastTime = _messageBox.values.last.createdAt;
      }

      var result = await MessageService.getMessages(
        _friend.friendID,
        token,
        lastTime: lastTime?.toIso8601String(),
      );

      for (var item in result.data) {
        await _messageBox.put(item.id, item);
      }

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   _scrollToEnd();
      // });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _sendMessage(String? content, List<File>? files) async {
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();

    final tempMessage = Message(
      id: tempId,
      content: content,
      images: [],
      files: [],
      messageType: 1,
      createdAt: DateTime.now().toUtc(),
      isSend: 0,
    );
    await _messageBox.put(tempId, tempMessage);
    _textEditingController.clear();

    try {
      String token = await TokenService.getToken('user') as String;
      MessageDTO dto = MessageDTO(content: content, files: files);
      var sentMessage = await MessageService.sendMessage(
        token,
        _friend.friendID,
        dto,
      );

      await _messageBox.delete(tempId);
      await _messageBox.put(sentMessage.data.id, sentMessage.data);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (image != null) {
      await _sendMessage(null, [File(image.path)]);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      _sendMessage(null, files);
    }
  }

  Future<void> _downloadImage(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        var response = await Dio().get(
          RouteConstants.getUrl(url),
          options: Options(responseType: ResponseType.bytes),
        );

        final result = await SaverGallery.saveImage(
          Uint8List.fromList(response.data),
          fileName: '${DateTime.now().millisecondsSinceEpoch}.jpg',
          androidRelativePath: "Pictures",
          quality: 80,
          skipIfExists: true,
        );

        print(result);

        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã lưu ảnh vào thư viện')),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Lỗi khi lưu ảnh')));
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Quyền lưu trữ bị từ chối')));
    }
  }

  //==========================build UI==============================
  Widget _headerTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StyleConstants.avatarFriend(_friend.avatar, _friend.isOnline),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _friend.fullName,
                  style: StyleConstants.textStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (_friend.isOnline)
                  Text(
                    'Trực tuyến',
                    style: TextStyle(
                      color: Color.fromRGBO(121, 124, 123, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentMessage() {
    if (!Hive.isBoxOpen('messages_${_friend.friendID}')) {
      return Center(child: CircularProgressIndicator());
    }

    return Flexible(
      child: ValueListenableBuilder<Box<Message>>(
        valueListenable:
            Hive.box<Message>('messages_${_friend.friendID}').listenable(),
        builder: (context, box, _) {
          final messages =
              box.values.toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          if (messages.isEmpty) {
            return Center(child: Text("Hãy bắt đầu cuộc trò truyện!"));
          }
          return ListView.builder(
            reverse: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 50),
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final Message message = messages[index];
              // print(
              //   'ChatPage: Message $index: content=${message.content} images=${message.images}, files=${message.files}',
              // );

              bool showDateHeader = _checkTimeTitle(index, message, messages);
              bool showTime = _checkShowTime(index, message, messages);
              final bool isLastMsg = index == 0;

              return Column(
                children: [
                  if (showDateHeader)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          message.getFormattedDate(message.createdAt),
                          style: const TextStyle(
                            color: Color.fromRGBO(121, 124, 123, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 10,
                    ),
                    child: Align(
                      alignment:
                          message.messageType == 1
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment:
                            message.messageType == 1
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //=====================Avatar===========================
                          if (message.messageType != 1)
                            Container(
                              width: (50 + 10),
                              child:
                                  _checkShowAvatar(index, message, messages)
                                      ? Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                          bottom: 0,
                                        ),
                                        child: StyleConstants.avatarFriend(
                                          _friend.avatar,
                                          _friend.isOnline,
                                        ),
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          //=====================Content and Time==================
                          Flexible(
                            child: Column(
                              crossAxisAlignment:
                                  message.messageType == 1
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                // Content message
                                if (message.content != null &&
                                    message.content!.isNotEmpty)
                                  _buildMessageField(message),
                                // Images
                                _buildFileField(message),
                                //====================Time message======================
                                if (showTime)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: SizedBox(
                                      child: Align(
                                        alignment:
                                            message.messageType == 1
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: Text(
                                          DateFormat(
                                            'h:mm a',
                                          ).format(message.createdAt),
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                              121,
                                              124,
                                              123,
                                              1,
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w100,
                                            fontStyle: FontStyle.italic,
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
                    ),
                  ),
                  if (isLastMsg && message.messageType == 1)
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 2),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          message.getStatusIsSend(message.isSend),
                          style: TextStyle(color: Color(0xFF4FC3F7), fontSize: 12),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInput(screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Row(
        children: [
          //=============Emoji=========================
          IconButton(
            icon: Icon(Icons.insert_emoticon, color: Colors.black),
            onPressed: () {
              FocusScope.of(context).unfocus();
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: screenHeight * 0.4,
                    child: EmojiPicker(
                      textEditingController: _textEditingController,
                    ),
                  );
                },
              );
            },
          ),
          //============================text input=========================
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                hintStyle: StyleConstants.textStyle,
                filled: true,
                fillColor: Color.fromRGBO(243, 246, 246, 1),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    if (_textEditingController.text.isNotEmpty) {
                      final messageContent = _textEditingController.text;
                      _sendMessage(messageContent, null);
                      setState(() {
                        _textEditingController.clear();
                      });
                    }
                  },
                  child: Icon(
                    Icons.send,
                    color: Color.fromRGBO(4, 125, 231, 1),
                  ),
                ),
              ),
            ),
          ),
          //============================file button=========================
          IconButton(icon: Icon(Icons.file_present), onPressed: _pickFile),
          //============================picture button=========================
          IconButton(icon: Icon(Icons.image), onPressed: _pickImage),
        ],
      ),
    );
  }

  Widget _buildFileField(Message message) {
    List<Widget> widgets = [];

    if (message.images.isNotEmpty) {
      for (final imageData in message.images) {
        if (imageData.url.isNotEmpty) {
          if (_checkImage(imageData.url)) {
            widgets.add(_buildImage(imageData.url));
          }
        }
      }
    }

    // Files
    if (message.files.isNotEmpty) {
      for (final fileData in message.files) {
        if (fileData.url.isNotEmpty) {
          if (_checkImage(fileData.url)) {
            widgets.add(_buildImage(fileData.url));
          } else {
            widgets.add(_buildFile(fileData.url, fileData.fileName));
          }
        }
      }
    }

    if (widgets.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment:
          message.messageType == 1
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildMessageField(Message message) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:
            message.messageType == 1
                ? const Color.fromRGBO(32, 160, 144, 1)
                : const Color.fromRGBO(242, 247, 251, 1),
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(10),
          bottomRight: const Radius.circular(10),
          topLeft: Radius.circular(message.messageType == 1 ? 10 : 0),
          topRight: Radius.circular(message.messageType == 1 ? 0 : 10),
        ),
      ),
      child: Text(
        message.content.toString(),
        style: TextStyle(
          color: message.messageType == 1 ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => Scaffold(
                  backgroundColor: Colors.black,
                  body: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: InteractiveViewer(
                        child: Image.network(RouteConstants.getUrl(url)),
                      ),
                    ),
                  ),
                ),
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder:
              (item) => AlertDialog(
                title: Text("Tải ảnh"),
                content: Text("Bạn có muốn tải ảnh này không?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Hủy"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _downloadImage(url);
                    },
                    child: Text("Tải xuống"),
                  ),
                ],
              ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child:
            url.isNotEmpty
                ? Image.network(
                  RouteConstants.getUrl(url),
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildFile(String url, String fileName) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child:
          url.isNotEmpty
              ? GestureDetector(
                onTap: () async {
                  print('Tải file: ${RouteConstants.getUrl(url)}');
                  try {
                    if (await canLaunchUrl(
                      Uri.parse(RouteConstants.getUrl(url)),
                    )) {
                      launchUrl(Uri.parse(RouteConstants.getUrl(url)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Không thể mở file')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Đã có lỗi xảy ra')));
                  }
                },
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(242, 247, 251, 1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.insert_drive_file,
                        color: Colors.blue,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          fileName.isNotEmpty ? fileName : url,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : SizedBox.shrink(),
    );
  }

  //==========================handle validation==============================
  bool _checkTimeTitle(var index, Message message, List<Message> messages) {
    if (index == messages.length - 1) return true;

    final nextMessage = messages[index + 1];
    final currentDay = DateTime(
      message.createdAt.year,
      message.createdAt.month,
      message.createdAt.day,
    );
    final nextDay = DateTime(
      nextMessage.createdAt.year,
      nextMessage.createdAt.month,
      nextMessage.createdAt.day,
    );

    return !currentDay.isAtSameMomentAs(nextDay);
  }

  bool _checkShowTime(var index, Message message, List<Message> messages) {
    if (index >= messages.length - 1) return true;
    final oldMessage = messages[index + 1];
    final currentTime = DateTime(
      message.createdAt.year,
      message.createdAt.month,
      message.createdAt.day,
      message.createdAt.hour,
      message.createdAt.minute,
    );
    final oldTime = DateTime(
      oldMessage.createdAt.year,
      oldMessage.createdAt.month,
      oldMessage.createdAt.day,
      oldMessage.createdAt.hour,
      oldMessage.createdAt.minute,
    );
    if (currentTime == oldTime &&
        message.messageType == oldMessage.messageType) {
      return false;
    }

    return true;
  }

  bool _checkImage(String url) {
    if (url.isNotEmpty) {
      final String urlLower = url.toLowerCase();
      final List<String> imageTypes = ['jpg', 'jpeg', 'png', 'gif'];
      for (final item in imageTypes) {
        if (urlLower.endsWith(item)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _checkShowAvatar(int index, Message message, List<Message> messages) {
    if (message.messageType == 1) return false;
    if (index >= messages.length - 1) return true;

    final olderMessage = messages[index + 1];
    final isDifferentDay = _checkTimeTitle(index, message, messages);

    if (isDifferentDay) return true;
    if (olderMessage.messageType != message.messageType ||
        message.createdAt.difference(olderMessage.createdAt).inMinutes > 2) {
      return true;
    }
    return false;
  }
}
