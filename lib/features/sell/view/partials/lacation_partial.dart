import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/location_model.dart';
import 'package:ilolo/features/home/repository/location_repository.dart';
import 'package:ilolo/features/sell/repository/post_ad_repository.dart';
import 'package:ilolo/widgets/app_bar/custome_app_bar_widget.dart';
import 'package:provider/provider.dart';

class StatePartial extends StatefulWidget {
  const StatePartial({super.key});

  @override
  State<StatePartial> createState() => _StatePartialState();
}

class _StatePartialState extends State<StatePartial> {
  String _searchQuery = '';
  void updateSearchQuery(String query) {
    setState(() => _searchQuery = query);
  }

  List<StateDataModel> get filteredStates {
    if (_searchQuery.isEmpty) {
      return context.read<LocationRepository>().states;
    } else {
      return context.read<LocationRepository>().states.where((item) => item.state.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearch(
        onSearchChanged: updateSearchQuery,
        data: 'state',
      ),
      body: SafeArea(
        child: ListView(
          children: filteredStates
              .map((e) => Container(
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50], // Background color
                      borderRadius: BorderRadius.circular(10), // Rounded border
                    ),
                    child: ListTile(
                      onTap: () {
                        context.read<PostAdRepository>().state = e.state;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LgaPartial(state: e),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                      title: Text(e.state),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class LgaPartial extends StatefulWidget {
  const LgaPartial({required this.state, super.key});
  final StateDataModel state;

  @override
  State<LgaPartial> createState() => _LgaPartialState();
}

class _LgaPartialState extends State<LgaPartial> {
  String _searchQuery = '';
  void updateSearchQuery(String query) {
    setState(() => _searchQuery = query);
  }

  List<Lga> get filteredLgas {
    if (_searchQuery.isEmpty) {
      return widget.state.lgas;
    } else {
      return widget.state.lgas.where((item) => item.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearch(
        onSearchChanged: updateSearchQuery,
        data: "LGA",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
            child: Text(
              widget.state.state,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredLgas
                  .map((e) => Container(
                        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue[50], // Background color
                          borderRadius: BorderRadius.circular(10), // Rounded border
                        ),
                        child: ListTile(
                          onTap: () {
                            context.read<PostAdRepository>().lga = e.name;
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                          title: Text(e.name),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
