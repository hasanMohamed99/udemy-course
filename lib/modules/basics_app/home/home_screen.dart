import 'dart:ffi';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget
{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
              Icons.menu
          ),
          onPressed: (){
          },
        ),
        title: const Text(
          'First App'
        ),
        actions: [
          IconButton(
              icon: const Icon(
                  Icons.search
              ),
              onPressed: (){
              },
          ),
          IconButton(
            icon: const Text(
                'hello'
            ),
            onPressed: (){
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                width: 200.0,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    const Image(
                      image: NetworkImage(
                        'https://cdn.pixabay.com/photo/2015/04/19/08/33/flower-729512__340.jpg'
                      ),
                      height: 200.0,
                      width: 200.0,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: double.infinity,
                      color:Colors.black.withOpacity(0.3),
                      padding: const EdgeInsetsDirectional.only(top: 10,bottom: 10),
                      child: const Text(
                        'Flower',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40.0,
                          color: Colors.white,

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
    );
  }

}