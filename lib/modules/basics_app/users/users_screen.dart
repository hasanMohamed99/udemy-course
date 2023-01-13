import 'package:flutter/material.dart';
import 'package:training_app/models/user/user_model.dart';

class UsersScreen extends StatelessWidget {
  List<UserModel> users = [
    UserModel(
      id: 2,
      name: 'Hasan Mohamed',
      phone: '01019942462'
    ),
    UserModel(
        id: 44,
        name: 'Ahmed Mohamed',
        phone: '01554209247'
    ),
    UserModel(
        id: 73,
        name: 'Islam Mohamed',
        phone: '01294425274'
    ),
    UserModel(
        id: 2,
        name: 'Hasan Mohamed',
        phone: '01019942462'
    ),
    UserModel(
        id: 44,
        name: 'Ahmed Mohamed',
        phone: '01554209247'
    ),
    UserModel(
        id: 73,
        name: 'Islam Mohamed',
        phone: '01294425274'
    ),
    UserModel(
        id: 2,
        name: 'Hasan Mohamed',
        phone: '01019942462'
    ),
    UserModel(
        id: 44,
        name: 'Ahmed Mohamed',
        phone: '01554209247'
    ),
    UserModel(
        id: 73,
        name: 'Islam Mohamed',
        phone: '01294425274'
    ),
    UserModel(
        id: 2,
        name: 'Hasan Mohamed',
        phone: '01019942462'
    ),
    UserModel(
        id: 44,
        name: 'Ahmed Mohamed',
        phone: '01554209247'
    ),
    UserModel(
        id: 73,
        name: 'Islam Mohamed',
        phone: '01294425274'
    ),
    UserModel(
        id: 2,
        name: 'Hasan Mohamed',
        phone: '01019942462'
    ),
    UserModel(
        id: 44,
        name: 'Ahmed Mohamed',
        phone: '01554209247'
    ),
    UserModel(
        id: 73,
        name: 'Islam Mohamed',
        phone: '01294425274'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => buildUserItem(users[index]),
        separatorBuilder: (context, index) => Container(
          height: 1.0,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        itemCount: users.length,
      ),
    );
  }

  // 1-build item
  // 2-build list
  // 3-add item to list

  Widget buildUserItem(UserModel user) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          child: Text(
            '${user.id}',
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.phone,
              style: const TextStyle(
                  color: Colors.grey
              ),
            ),
          ],
        ),
      ],
    ),
  );

}
