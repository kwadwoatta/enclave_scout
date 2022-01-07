import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout/models/space.dart';
import 'package:scout/providers/space.dart';
import 'package:scout/widgets/search_spaces_screen/sub_widgets/space_card.dart';
import 'package:scout/widgets/show_error_dialog.dart';

import './layout_type.dart';
import './hero_header.dart';

class HeroPage extends StatefulWidget implements HasLayoutGroup {
  HeroPage({
    Key key,
    this.layoutGroup,
    this.onLayoutToggle,
    @required this.cityName,
    @required this.cityImageUrl,
  }) : super(key: key);

  final String cityName;
  final String cityImageUrl;
  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;

  @override
  _HeroPageState createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  bool isInit = true;

  didChangeDependencies() {
    if (isInit) {
      Provider.of<SpaceProvider>(context).retreiveAllSpaces();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _scrollView(context),
    );
  }

  Widget _scrollView(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final citySpaces = Provider.of<SpaceProvider>(context).spaces;
    final primaryColor = Theme.of(context).primaryColor;

    // Use LayoutBuilder to get the hero header size while keeping the image aspect-ratio
    return Container(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: HeroHeader(
              cityImageUrl: widget.cityImageUrl,
              cityName: widget.cityName,
              layoutGroup: widget.layoutGroup,
              onLayoutToggle: widget.onLayoutToggle,
              minExtent: 150.0,
              maxExtent: 250.0,
            ),
          ),

          // List
          StreamBuilder(
            stream: citySpaces,
            builder: (context, AsyncSnapshot<List<Space>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: EdgeInsets.only(top: height * .3),
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              else if (snapshot.hasData) {
                final citySpaces = snapshot.data;
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // SizedBox(height: height * .01),
                      ...citySpaces.map((space) {
                        return SpaceCard(
                          space: space,
                        );
                      }).toList(),
                      // SizedBox(height: height * .01),
                    ],
                  ),
                );
              } else if (!snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                        child: Text(
                          'Sorry, no event spaces are currently listed for this city.',
                          style: TextStyle(
                            fontSize: width * .05,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                // ErrorDialog(context: context, error: snapshot.error);
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                        child: Text(
                          'Oops, an error occured.',
                          style: TextStyle(
                            fontSize: width * .05,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                        child: Text(
                          'Oops, no event space found.',
                          style: TextStyle(
                            fontSize: width * .05,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}
