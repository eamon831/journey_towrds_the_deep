import '/app/core/exporter.dart';
import '/app/entity/user.dart';

class LocalDbDataController extends BaseController {
  final userList = Rx<List<User>?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> insertList() async {
    final userList = List.generate(
      1000,
      (index) => User(
        userId: index,
        userName: 'User $index',
        fullName: 'Full Name $index',
        email: ' [email protected]',
        password: 'password',
        roles: 'User',
      ),
    );

    // Insert list of users
    await dbHelper.insertList(
      tableName: tableUsers,
      dataList: userList.map((e) => e.toJson()).toList(),
      deleteBeforeInsert: false,
    );
    print('User List Inserted');
  }

  Future<void> getUserList() async {
    await dataFetcher(
      future: () async {
        final regularData = await dbHelper.getAll(
          tbl: tableUsers,
        );
        userList.value = regularData.map((e) => User.fromJson(e)).toList();

        print('User List: ${userList.value!.length}');
      },
    );

    /* final data = await dbHelper.getAllIsolate<User>(
      tbl: dbTables.tableUsers,
      fromJson: (json) => User.fromJson(json),
    );

    userList.value = data;*/
  }

  Future<void> deleteAll() async {
    await dbHelper.deleteAll(
      tbl: tableUsers,
    );
    await getUserList();
  }
}
