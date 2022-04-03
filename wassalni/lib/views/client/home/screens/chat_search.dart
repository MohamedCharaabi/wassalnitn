import 'package:flutter/material.dart';
import 'package:wassalni/modelView/services/driver_crud.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/views/screens/messages/chat_page.dart';
import 'package:wassalni/views/screens/messages/message_screen.dart';

class ChatSearch extends StatefulWidget {
  final bool searchForDriver;
  const ChatSearch({Key? key, required this.searchForDriver}) : super(key: key);

  @override
  State<ChatSearch> createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {
  String input = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: TextField(
          onChanged: (val) {
            setState(() {
              input = val;
            });
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: white,
              size: 28,
            ),
            hintText: !widget.searchForDriver
                ? 'type in client name...'
                : 'type in driver name...',
            hintStyle: TextStyle(
              color: white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: white,
          ),
        ),
      ),
      body: input.isNotEmpty
          ? FutureBuilder<List<UserModel>>(
              future: DriverCrud().searchDriversClients(
                  term: input, isDriver: widget.searchForDriver),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No drivers found'),
                  );
                }
                final List<UserModel> drivers = snapshot.data!;
                return ListView.builder(
                    itemCount: drivers.length,
                    itemBuilder: (context, index) {
                      final UserModel driver = drivers[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MessagesScreen(
                                user: driver,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: white,
                        ),
                        title: Text(
                          '${driver.name}',
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          driver.phone ?? 'no phone',
                          style: TextStyle(
                            color: white,
                            fontSize: 16,
                          ),
                        ),
                      );
                    });
              }),
            )
          : const SizedBox(),
    );
  }
}
