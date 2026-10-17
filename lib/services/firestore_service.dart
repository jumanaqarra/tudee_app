import 'package:cloud_firestore/cloud_firestore.dart';
//بيجيب مكتبة Firestore
import '../models/task_model.dart';

class FirestoreService { // هادا كلاس بيجمع كل دوال Firestore بمكان واحد.
  static final dataBase = FirebaseFirestore.instance;
// FirebaseFirestore.instance ==> هو الاتصال الجاهز بقاعدة البيانات
  /*كلمة instance معناها "نسخة وحيدة"
  بكل التطبيق في اتصال واحد، مش كل مرة بيفتح اتصال جديد.
 */

  // مجموعة المهام
  static final tasks = dataBase.collection('tasks');
  /*  متى بيتصل فعلياً؟
  * ما تنادي Firebase.initializeApp() بـ main.dart
  * بدونها FirebaseFirestore.instance بيعطي خطأ لأنو Firebase ما تجهّز.
  *
  *
  * --- بيرجع مرجع (CollectionReference) لمجموعة tasks.-----
   هادا مجرد عنوان فقط مش بيانات يعني لسا ما قرا اشي ولا راح للاتصال بالنت
  *
  * */

  // مستند واحد بنخزن فيه اسم المستخدم
  static final profile = dataBase.collection('settings').doc('profile');
  //  هان بنمسك مستند محدد جوا مجموعة ال setting المستند اسمه profile
  // هان بنخزن فيه اسم المستخدم
  // واخترت اسم ثابت اللي هو profile لأنو بدنا مستند واحد للاسم وكل مرة نقرأ ونكتب بنفس المكان




  // ---------- الاسم ----------

  static Future<String?> getName() async {
    final doc = await profile.get();
    // ----- profile.get()-------
    // بيروح لـ Firestore ويقرأ المستند مرة وحدة
    return doc.data()?['name'] as String?;
  //   -------- doc.data()? -------
  //   بيرجع Map<String, dynamic>?
  //   ممكن يكون null
  }

  static Future<void> saveName(String name) {
    return profile.set({'name': name});
  }

  // ---------- المهام ----------

  /// Live list of tasks (newest first). Updates automatically.
  static Stream<List<TaskModel>> watchTasks() {
    return tasks
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(TaskModel.fromDoc).toList());
  }

  static Future<void> addTask(String title) {
    // بينشئ مستند جديد وFirestore بيولّد له ID عشوائي
    return tasks.add({
      'title': title,
      'isDone': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateTask(String id, String title, bool isDone) {
    return tasks.doc(id).update({'title': title, 'isDone': isDone});
  }
}