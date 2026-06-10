import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "../../core/image_ressource.dart";

class ProfilPages extends StatelessWidget {
  const ProfilPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.noir,
      appBar: AppBar(
        backgroundColor: AppColor.placeholder,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.placeholder,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: AppColor.blanc),
        ),
        actions: const [
          Icon(Icons.update, color: AppColor.blanc),
          SizedBox(width: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Icon(Icons.menu, color: AppColor.blanc),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: double.infinity,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: AppColor.placeholder,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(ImageRessource.avatar, height: 110),
                        const Text(
                          "ARIANE STAR",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: AppColor.blanc,
                          ),
                        ),
                        const Text(
                          "arianestar@gmail.com | 671092083",
                          style: TextStyle(color: AppColor.blanc),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 200,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColor.bordure,
                          borderRadius: BorderRadiusDirectional.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSection(
                                context,
                                Icons.tab,
                                "Modifier le profil",
                                "",
                              ),
                              const SizedBox(height: 15),
                              _buildSection(
                                context,
                                Icons.notifications_none,
                                "Notifications",
                                "ON",
                              ),
                              const SizedBox(height: 15),
                              _buildSection(
                                context,
                                Icons.language,
                                "Langage",
                                "Francais",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 330,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColor.bordure,
                          borderRadius: BorderRadiusDirectional.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSection(
                                context,
                                Icons.security,
                                "Securite",
                                "",
                              ),
                              const SizedBox(height: 15),
                              _buildSection(
                                context,
                                Icons.light_mode,
                                "Theme",
                                "clair",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 420,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColor.bordure,
                          borderRadius: BorderRadiusDirectional.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSection(
                                context,
                                Icons.help,
                                "Aide et support ",
                                "",
                              ),
                              const SizedBox(height: 15),
                              _buildSection(
                                context,
                                Icons.contact_emergency,
                                "Nous contacter ",
                                "",
                              ),
                              const SizedBox(height: 15),
                              _buildSection(
                                context,
                                Icons.private_connectivity,
                                "Confidentialite ",
                                "",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    IconData icon,
    String title,
    String? action,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Row(
          children: [
            Icon(icon, color: AppColor.blanc, size: 17),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(color: AppColor.blanc, fontSize: 16),
            ),
          ],
        ),
        Text(action!, style: const TextStyle(color: AppColor.or, fontSize: 14)),
      ],
    );
  }
}
