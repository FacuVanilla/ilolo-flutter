import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/features/account/model/profile_model.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/account/view/account_screen.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showDrawer;
  const HomeAppBar({super.key, required this.title, this.showDrawer = true});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 80);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    final ProfileDataModel? profile = context.watch<ProfileRepository>().profileData;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          AppBar(
            title: Row(
              children: [
                const Text('Explore ilolo in'),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go('/home/location');
                  },
                  icon: const Icon(
                    Icons.navigation_rounded,
                    size: 12,
                    textDirection: TextDirection.rtl,
                  ),
                  label: const Text('Location'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: const Size(17.0, 17.0), // Set the minimum width and height
                    backgroundColor: Colors.black, // Change the button's background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Round the button corners
                    ),
                  ),
                )
              ],
            ),
            titleTextStyle: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Boxicons.bxs_category), // //auto_awesome_mosaic_rounded
                  onPressed: () {
                    if (widget.showDrawer) {
                      Scaffold.of(context).openDrawer();
                    }
                  },
                );
              },
            ),
            actions: [
              profile == null
                  ? IconButton(
                      icon: const Icon(
                        Icons.account_circle_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        GoRouter.of(context).push('/login');
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountScreen()));
                      },
                      child: SizedBox(
                        width: 35, // Adjust the width of the container
                        height: 35,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: profile.avatar!,
                              placeholder: (context, url) => const SizedBox( height: 10, width: 10, child: CupertinoActivityIndicator( radius: 20.0, )),
                              errorWidget: (context, url, error) => const Icon(Icons.account_circle_rounded, color: Colors.white, size: 32,),
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
              const Gap(10),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 15.0, left: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                onTap: () => context.go('/home/search'),
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Looking for...',
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
