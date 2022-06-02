import 'package:flutter/material.dart';
import 'components.dart';
import 'home_screen.dart';
import '../Database/Note_dp.dart';
import 'package:share_plus/share_plus.dart';

class EditNoteScreen extends StatefulWidget {
  final note;
  final title;
  final color;
  final id;

  EditNoteScreen({Key? key, this.note, this.title, this.color, this.id})
      : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  bool isEmpty = true;
  int currentIndex = 0;
  int valueColor = 0;
  Color themeColor = const Color(0xFF1321E0);
  GlobalKey<FormState> formstate = GlobalKey();
  GlobalKey<FormState> formstatecolor = GlobalKey();

  bool isShow = false;
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController id = TextEditingController();
  SqlDb note_dp = SqlDb();

  @override
  void initState() {
    super.initState();
    title.text = widget.title;
    note.text = widget.note;
    valueColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isEmpty ? Color(widget.color) : themeColor,
          elevation: 6, //shadoo
          title: const Text(
            'Edit Note',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            MaterialButton(
              minWidth: 15,
              textColor: Colors.white,
              onPressed: () {
                setState(
                  () {
                    isShow = !isShow;
                  },
                );
              },
              child: const Icon(
                Icons.more_vert,
              ),
            ),
            MaterialButton(
              minWidth: 15,
              textColor: Colors.white,
              onPressed: () async {
                int response = await note_dp.updateData('''
                  UPDATE Notes SET 
                  note = "${note.text}",
                  title = "${title.text}",
                  color = "$valueColor"
                  WHERE id = ${widget.id}
                  ''');
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
          key: formstate,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: title,
                    keyboardType: TextInputType.text,
                    cursorColor: themeColor,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Type Something...',
                      labelStyle: TextStyle(fontSize: 15, color: themeColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: themeColor),
                      ),
                      contentPadding: const EdgeInsets.only(left: 10),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: themeColor, width: .5),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45),
                  child: TextFormField(
                    controller: note,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    cursorColor: themeColor,
                    decoration: InputDecoration(
                      labelText: 'Type Something...',
                      labelStyle: TextStyle(fontSize: 15, color: themeColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: themeColor),
                      ),
                      contentPadding: const EdgeInsets.only(left: 10),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: themeColor, width: .5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: isShow
            ? BottomSheet(
                elevation: 25,
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
                            int response = await note_dp.deleteData(
                                "DELETE FROM Notes WHERE id= ${widget.id}");
                            if (response > 0) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                  (route) => false);
                            }
                            setState(() {});
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
                                        VALUES ("${title.text}", "${note.text}", $valueColor) ''');
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
                            right: 8,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            height: 50.0,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: ((context, index) => GestureDetector(
                                    onTap: () => setState(() {
                                      isEmpty = false;
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
                onClosing: () {},
              )
            : null);
  }
}
