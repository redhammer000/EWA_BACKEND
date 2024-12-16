import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/backend_api.dart';
import '../colors/primary_colors.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  CollectionReference _chatCollection =
  FirebaseFirestore.instance.collection('chats');
  List<Map<String, String>> _messages = [];
  List<String> conversationList = [];
  int messageCount = 0; // Initialize count variable


  @override
  void initState() {
    super.initState();
    _loadConversationList(); // Load conversationList when the widget initializes
  }

  void _startChat() {
    // Generate a unique chat ID
    String chatId = (conversationList.length + 1).toString();
    // Create a new collection for this chat session
    CollectionReference chatCollection =
    FirebaseFirestore.instance.collection('chat_$chatId');
    // Set the reference to this chat collection
    _chatCollection = chatCollection;

    // Add the chat ID to the conversation list
    setState(() {
      conversationList.add(chatId);
    });
    setState(() {
      _messages = [];
      messageCount = 0;
    });
    _saveConversationList(); // Save conversationList after adding a new chat
  }

  void _saveConversationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('conversationList', conversationList);
  }

  void _loadConversationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      conversationList = prefs.getStringList('conversationList') ?? [];
    });
  }


  void _sendMessage(String message) async {

    // Timestamp currentTime = Timestamp.now();
    setState(() {
      _messages.add({'role': 'user', 'message': message});
    });
    _controller.clear();

    try {
      // Increment message count and use it for document IDs
      messageCount++;

      // Save input message to Firestore with specific ID format
      String inputDocId = 'i$messageCount';
      DocumentReference inputDocRef =
      _chatCollection.doc(inputDocId);
      await inputDocRef.set({
        'message': message,
        // 'timestamp': currentTime,
      });

      // Send message to backend and save response to Firestore
      final response = await BackendAPI.sendMessage(message);
      String outputDocId = 'o$messageCount';
      await _chatCollection.doc(outputDocId).set({
        'message': response['message'],
        // 'timestamp': currentTime,
        // 'input_message_ref': inputDocRef,
        // Reference to the input message document
      });

      // Add the response to the local list
      setState(() {
        _messages.add({'role': 'bot', 'message': response['message']});
      });
    } catch (e) {
      // Handle error
      setState(() {
        _messages.add({'role': 'bot', 'message': 'Error: ${e.toString()}'});
      });
    }
  }
  Future<void> clearConversationListInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('conversationList'); // Remove the key from shared preferences
  }


  Future<void> getConversationMessages(String chatId) async {
    List<Map<String, String>> inputMessages = [];
    List<Map<String, String>> outputMessages = [];

    try {
      // Reference to the chat collection
      CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat_$chatId');

      // Retrieve all documents in the chat collection
      QuerySnapshot querySnapshot = await chatCollection.get();

      // Loop through each document and extract the message
      querySnapshot.docs.forEach((doc) {
        String message = doc.get('message');
        String id = doc.id;

        if (id.startsWith('i')) {
          inputMessages.add({'id': id, 'message': message});
        } else if (id.startsWith('o')) {
          outputMessages.add({'id': id, 'message': message});
        }
      });

      // Sort the input and output messages based on the numeric suffix in the document ID
      inputMessages.sort((a, b) => int.parse(a['id']!.substring(1)).compareTo(int.parse(b['id']!.substring(1))));
      outputMessages.sort((a, b) => int.parse(a['id']!.substring(1)).compareTo(int.parse(b['id']!.substring(1))));
    } catch (e) {
      // Handle error
      print('Error retrieving messages: $e');
    }

    List<Map<String, String>> sortedMessages = [];
    for (int i = 0; i < inputMessages.length; i++) {
      sortedMessages.add(inputMessages[i]);
      if (i < outputMessages.length) {
        sortedMessages.add(outputMessages[i]);
      }
    }

    setState(() {
      _messages = sortedMessages.map((msg) => {'message': msg['message']!}).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        children: [
          // Left side (Conversation List)
          Container(
            color: PrimaryColors.screencolorgrey,
            width: screenWidth / 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Bot1Small.png',
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text('E.W.A'),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: screenWidth / 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 12, top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _startChat();
                      },
                      style: ButtonStyle(

                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black87),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text('New chat'),
                    ),
                  ),
                ),
                Expanded(
                  child: conversationList.isEmpty
                      ? Center(
                    child: Text('No conversations yet'),
                  )
                      : ListView.builder(
                    itemCount: conversationList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: GestureDetector(
                          onTap: () {
                            getConversationMessages(conversationList[index]);
                            print('tapped'); // Pass the index of the selected conversation
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // Adjust border radius as needed
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            padding: EdgeInsets.all(5),
                            // Adjust padding as needed
                            child: Center(
                              child: Text(
                                'Conversation ${conversationList[index]}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // subtitle: Text(
                        //   '${conversationList[index]}',
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //   ),
                        // ),
                      );
                    },
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    clearConversationListInSharedPreferences();// Handle onTap action
                  },
                  child: Container(
                    color: Colors.white,
                    width: screenWidth / 4,
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        'Taha',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Right side (Chat Window)
          Expanded(
            child: Container(
              color: PrimaryColors.textcolorblack,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16.0, bottom: 16.0),
                    child: Text(
                      'E.W.A V1',
                      style: TextStyle(color: PrimaryColors.screencolorgrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: PrimaryColors.screencolorgrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  if (index.isOdd)
                                  Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.asset(
                                    'assets/images/Bot1Small.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      message['message']!,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: PrimaryColors.screencolorgrey,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/Bot1Small.png',
                              height: 24,
                              width: 24,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 14),
                              child: TextField(
                                controller: _controller,
                                style: TextStyle(fontSize: 14.0),
                                decoration: InputDecoration(
                                  hintText: 'Type your message...',
                                  hintStyle: TextStyle(fontSize: 14.0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            color: Colors.black87,
                            iconSize: 19.0,
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                _sendMessage(_controller.text);
                              }
                            },
                          ),
                        ],
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
