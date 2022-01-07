import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/widgets/search_spaces_screen/sub_widgets/default_body.dart';
import 'package:scout/widgets/search_spaces_screen/sub_widgets/filtered_body.dart';
import 'package:scout/widgets/search_spaces_screen/sub_widgets/searched_body.dart';

import 'sub_widgets/spaces_search_container.dart';
import 'package:scout/providers/space.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // List<String> _items = [
  //   'https://pbs.twimg.com/media/EE9sDOiWkAAc0qn.jpg',
  //   'https://pbs.twimg.com/media/EFy1jGkWoAEwhav.jpg',
  //   'https://pbs.twimg.com/media/D-tFLafXYAAumg4.jpg',
  //   'https://pbs.twimg.com/media/D-tFLacXkAMGR3E.jpg',
  //   'https://culartblog.files.wordpress.com/2015/08/poets1.jpg',
  //   'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
  // ];
  bool isInit = true;
  bool filterMode = false;
  bool searchMode = false;

  didChangeDependencies() {
    if (isInit) {
      Provider.of<SpaceProvider>(context).retreiveAllSpaces();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  filterFunction({
    @required int maxCap,
    @required int minCap,
  }) {
    Provider.of<SpaceProvider>(context).filterSpaces(
      maxCap: maxCap,
      minCap: minCap,
    );
    setState(() => filterMode = true);
  }

  searchFunction({
    @required String spaceName,
  }) {
    Provider.of<SpaceProvider>(context).searchSpaces(name: spaceName);
    setState(() => searchMode = true);
  }

  @override
  Widget build(BuildContext context) {
    // final primaryColor = Theme.of(context).primaryColor;
    final spaces = Provider.of<SpaceProvider>(context).spaces;
    final spacesLength = Provider.of<SpaceProvider>(context).spacesLength;
    final filteredSpaces = Provider.of<SpaceProvider>(context).filteredSpaces;
    final filteredSpacesLength =
        Provider.of<SpaceProvider>(context).filteredSpacesLength;
    final searchedSpaces = Provider.of<SpaceProvider>(context).searchedSpaces;
    final searchedSpacesLength =
        Provider.of<SpaceProvider>(context).searchedSpacesLength;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              EventsSearchContainer(
                filterFunction: filterFunction,
                searchFunction: searchFunction,
              ),
              if (filterMode)
                ...filteredBody(
                  context: context,
                  spaces: filteredSpaces,
                  spacesLength: filteredSpacesLength,
                )
              else if (searchMode)
                ...searchedBody(
                  context: context,
                  spaces: searchedSpaces,
                  spacesLength: searchedSpacesLength,
                )
              else
                ...defaultBody(
                  context: context,
                  spaces: spaces,
                  spacesLength: spacesLength,
                ),
            ],
          ),
          if (filterMode || searchMode)
            Positioned(
              bottom: height * .03,
              right: width * .07,
              child: FloatingActionButton(
                child: Icon(CustomIcons.cancel_search),
                onPressed: () {
                  setState(() {
                    filterMode = false;
                    searchMode = false;
                  });
                },
              ),
            )
        ],
      ),
    );
  }
}
