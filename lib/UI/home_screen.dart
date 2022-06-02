import 'package:flutter/material.dart';
import '../Database/Note_dp.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SqlDb note_dp = SqlDb();
  bool isLoading = true;
  List notes = [];

  Future<List<Map>> readData() async {
    List<Map> response = await note_dp.readData("SELECT * FROM notes");
    notes.addAll(response);
    isLoading = false;
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
        backgroundColor: const Color(0xFF0F66D0),
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'MY Notes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            ListView.builder(
              reverse: true,
              itemCount: notes.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return MaterialButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditNoteScreen(
                          title: notes[i]['title'],
                          note: notes[i]['note'],
                          color: notes[i]['color'],
                          id: notes[i]['id'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 15),
                    elevation: 2,
                    shape: Border(
                      left:
                          BorderSide(color: Color(notes[i]['color']), width: 5),
                    ),
                    child: ListTile(
                      title: Text(
                        "${notes[i]['title']}",
                        style: TextStyle(
                          color: Color(notes[i]['color']),
                        ),
                      ),
                      subtitle: Text("${notes[i]['note']}"),
                    ),
                  ),
                );
              },
            ),
            if (notes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage('images/Empty Note.png'),
                        width: 220,
                        height: 150,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'No Notes :(',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F66D0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          'You have no task to do.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Color.fromARGB(255, 0, 42, 255),
        child: Column(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.1,
                    0.9,
                  ],
                  colors: [
                    Color(0xFF0F66D0),
                    Color(0xFF0F66D0),
                  ],
                ),
              ),
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pushNamed("AddNote");
        },
      ),
    );
  }
}
