import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference? ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref = FirebaseFirestore.instance.collection('notice_board');
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('notice_board');

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc("12345").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something went wrong ${snapshot.error}");
            return Text("Something went wrong ${snapshot.error}");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return child(data['images']);
          }

          return const Text("loading");
        },
      ),
    );
  }

  CarouselSlider child(
    List<dynamic> images,
  ) {
    return CarouselSlider(
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 2),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn),
      items: images.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Image.network(i, fit: BoxFit.cover,width: double.infinity,);
          },
        );
      }).toList(),
    );
  }
}
