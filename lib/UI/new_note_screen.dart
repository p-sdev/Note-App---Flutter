import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'components.dart';
import 'home_screen.dart';
import '../Database/Note_dp.dart';

class NewNoteScreen extends StatefulWidget {
  NewNoteScreen({Key? key}) : super(key: key);

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  int currentIndex = 0;
  bool isShow = false;
  int valueColor = const Color(0xFF1321E0).value;
  Color themeColor = const Color(0xFF0F66D0);

  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  SqlDb note_dp = SqlDb();
  List notes = [];

  Future<List<Map>> readData() async {
    List<Map> response = await note_dp.readData("SELECT * FROM Notes");
    notes.addAll(response);
    if (this.mounted) {
      setState(() {});
    }
    return response;
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeColor,
          elevation: 6,
          title: const Text(
            'New Note',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, size: 30),
              onPressed: () {
                setState(() {
                  isShow = !isShow;
                });
              },
            ),
            MaterialButton(
              minWidth: 15,
              textColor: Colors.white,
              onPressed: () async {
                int response = await note_dp
                    .insertData('''INSERT INTO Notes ('title','note' ,'color')
                  VALUES ("${titleController.text}", "${noteController.text}", "${valueColor}") ''');
                if (response > 0) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
                }
              },
              child: const Icon(Icons.check),
            ),
          ],
        ),
        body: Form(
          key: formState,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: textField(
                      title: 'Type Something...',
                      msg: 'Please enter some text',
                      controller: titleController,
                      color: themeColor),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45),
                  child: textField(
                      title: 'Type Something...',
                      msg: 'Please enter some text',
                      controller: noteController,
                      color: themeColor),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: isShow
            ? BottomSheet(
                elevation: 25,
                onClosing: () {},
                builder: (BuildContext context) {
                  return Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.only(top: 15, bottom: 20, left: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MaterialButton(
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      width: 2,
                                      color: themeColor,
                                    )),
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.share,
                                  color: themeColor,
                                ),
                              ),
                              title: Text(
                                'Share with your friends',
                                style: TextStyle(
                                    color: themeColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () async {
                              await Share.share("This Note");
                            }),
                        MaterialButton(
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 2,
                                    color: themeColor,
                                  )),
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.delete,
                                color: themeColor,
                              ),
                            ),
                            title: Text(
                              'Delete',
                              style: TextStyle(
                                  color: themeColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (route) => false);
                          },
                        ),
                        MaterialButton(
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 2,
                                    color: themeColor,
                                  )),
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.copy,
                                color: themeColor,
                              ),
                            ),
                            title: Text(
                              'Duplicate',
                              style: TextStyle(
                                  color: themeColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () async {
                            int response = await note_dp.insertData(
                                '''INSERT INTO Notes ('title','note', 'color')
                                        VALUES ("${titleController.text}", "${noteController.text}", $valueColor) ''');
                            if (response > 0) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                  (route) => false);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                            bottom: 20,
                            left: 8,
                            right: 0,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 15.0, right: 8),
                            height: 50.0,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: ((context, index) => GestureDetector(
                                    onTap: () => setState(() {
                                      currentIndex = index;
                                      themeColor = colors[index];
                                      valueColor = themeColor.value;
                                    }),
                                    child: CircleAvatar(
                                      backgroundColor: colors[index],
                                      child: currentIndex == index
                                          ? const Icon(
                                              Icons.check,
                                              color: Color(0xFFE6E6E6),
                                            )
                                          : null,
                                    ),
                                  )),
                              itemCount: colors.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(width: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : null);
  }
}
