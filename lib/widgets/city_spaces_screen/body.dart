import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final String cityName;
  final String cityImageUrl;

  Body({
    @required this.cityName,
    @required this.cityImageUrl,
  });
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: screenSize.height * .3,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(widget.cityName),
            background: Hero(
              tag: widget.cityName,
              child: Image.network(widget.cityImageUrl),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[],
          ),
        )
      ],
    );
  }
}
