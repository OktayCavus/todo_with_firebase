import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  Home({super.key});

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final TextEditingController _controller = TextEditingController();

  Padding _inputFields() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'Todo gir',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          IconButton(
              onPressed: () {
                firebaseFirestore
                    .collection('todos')
                    // ! "" içindeki isimleri biz kafamıza göre veriyoruz
                    // ! Timestamp firebase doc eklerken bir veri türü string gibi
                    .add({
                  "todo": _controller.text,
                  "createdAt": Timestamp.now()
                });
                _controller.clear();
              },
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // ! burda anlık veriler girildiği gibi database'e eklensin ve ordan
              // ! gelsin diye streamBuilder kullanacaz
              // ! streamBuidler ile futureBuilder farkı
              // ! futureBuilder ilk başlayınca veriyi çeker ve değişiklik olunca
              // ! anlık göstermez
              Expanded(
                  child: StreamBuilder/*<QuerySnapshot<Map<String, dynamic>>>*/(
                // ! stream'de firebase çekeceğimiz veriler olacak
                stream: firebaseFirestore.collection('todos').snapshots(),
                builder: (context, snapshots) {
                  final todos = snapshots.data?.docs;
                  if (todos == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (todos.isEmpty) {
                    return const Center(
                      child: Text('No Todos'),
                    );
                  }
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      // ! bu widget bizim todo ları sağa sola kaydırıp silmemize yarıyor
                      return Dismissible(
                        // ! bu parametre kaydırınca yapılacak işlemi anlatıyor
                        onDismissed: (direction) {
                          firebaseFirestore
                              .collection('todos')
                              .doc(todo.id)
                              .delete();
                        },
                        // ! key ler unic olmalı o yüzden herbirine todo.id veridk
                        key: Key(todo.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        child: GestureDetector(
                          // ! behavior gestureDetector'da boş alanlara tıklanmıyor
                          // ! bu parametre her yere tıklamayı sağlıyor
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            /* // ! map bekleyen yapılarn içine süslü parantez açıyoruz
                            firebaseFirestore
                                .collection('todos')
                                .doc(todo.id)
                                .set({
                              'todo': todo['todo'] + 'aa',
                              'createdAt': Timestamp.now()
                            });*/
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    // ! todo baştaki firestoredaki add document altındakine eşit
                                    // ! diğeri de addField altındaki text'e eşit
                                    todo['todo'],
                                    style: const TextStyle(),
                                  ),
                                  const Divider(),
                                  Text(
                                    // ! intl formatı tarih ile ilgili işlemler için
                                    DateFormat('dd/MM/yyyy      HH:mm')
                                        .format(todo['createdAt'].toDate()),
                                    style: const TextStyle(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )),
              _inputFields()
            ],
          ),
        ),
      ),
    );
  }
}
