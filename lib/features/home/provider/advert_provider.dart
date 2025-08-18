import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/advert_model.dart';

class HomeAdverts extends ChangeNotifier {
  final List<AdvertModel> _adverts = [];
  List<AdvertModel> get adverts => _adverts; 
}
