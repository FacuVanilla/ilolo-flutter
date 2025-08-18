import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/location_model.dart';
import 'package:ilolo/features/home/repository/location_repository.dart';
import 'package:ilolo/features/home/view/lag_screen.dart';
import 'package:ilolo/widgets/app_bar/custome_app_bar_widget.dart';
import 'package:provider/provider.dart';

class StateScreen extends StatefulWidget {
  const StateScreen({super.key});

  @override
  State<StateScreen> createState() => _StateScreenState();
}

class _StateScreenState extends State<StateScreen> {
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
      appBar: AppBarWithSearch(onSearchChanged: updateSearchQuery, data: 'state',),
      body: SafeArea(
        child: ListView(
          children: filteredStates.map((e) => 
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.blue[50], // Background color
                borderRadius: BorderRadius.circular(10), // Rounded border
              ),
              child: ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LgaScreen(state: e),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                title: Text(e.state),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            )
          ).toList(),
        ),
      ),
    );
  }
}