import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/location_model.dart';
import 'package:ilolo/features/home/view/advert_by_location_screen.dart';
import 'package:ilolo/widgets/app_bar/custome_app_bar_widget.dart';

class LgaScreen extends StatefulWidget {
  const LgaScreen({required this.state, super.key});
  final StateDataModel state;

  @override
  State<LgaScreen> createState() => _LgaScreenState();
}

class _LgaScreenState extends State<LgaScreen> {
  String _searchQuery = '';
  void updateSearchQuery(String query) {
    setState(() => _searchQuery = query);
  }

    List<Lga> get filteredLgas {
    if (_searchQuery.isEmpty) {
      return widget.state.lgas;
    } else {
      return  widget.state.lgas.where((item) => item.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
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
            child: Text(widget.state.state, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
          ),
          Expanded(
            child: ListView(
                children: filteredLgas.map((e) => 
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
                            builder: (context) => AdvertByLocationScreen(locationName: e.name, location: 'lga'),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                      title: Text(e.name),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  )
                ).toList(),
              ),
          ),
        ],
      ),
    );
  }
}
