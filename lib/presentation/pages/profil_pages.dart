import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getxtra/get.dart';
import '../../core/app_color.dart';
import "../../core/image_ressource.dart";
import '../../controller/user_controller.dart';

class ProfilPages extends StatelessWidget {
  ProfilPages({super.key});

  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backg,
      appBar: AppBar(
        backgroundColor: AppColor.placeholder,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.placeholder,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: AppColor.blanc),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: AppColor.blanc, size: 22),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        final user = _userController.unUtilisateur.value;

        if (user == null) {
          return const CircularProgressIndicator();
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColor.placeholder,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              ImageRessource.avatar,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColor.blanc,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: AppColor.blanc.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _buildGroupContainer([
                _buildSectionItem(
                  icon: Icons.person_outline,
                  title: "Modifier le profil",
                  actionWidget: const SizedBox.shrink(),
                  onTap: () {},
                ),
                _buildSectionItem(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  actionWidget: const Text(
                    "ON",
                    style: TextStyle(
                      color: AppColor.or,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {},
                ),
                _buildSectionItem(
                  icon: Icons.language,
                  title: "Langue",
                  actionWidget: const Text(
                    "Français",
                    style: TextStyle(color: AppColor.or, fontSize: 14),
                  ),
                  onTap: () {},
                ),
              ]),

              _buildGroupContainer([
                _buildSectionItem(
                  icon: Icons.security,
                  title: "Sécurité",
                  actionWidget: const SizedBox.shrink(),
                  onTap: () {},
                ),
                _buildSectionItem(
                  icon: Icons.light_mode_outlined,
                  title: "Thème",
                  actionWidget: const Text(
                    "Sombre",
                    style: TextStyle(color: AppColor.or, fontSize: 14),
                  ),
                  onTap: () {},
                ),
              ]),

              _buildGroupContainer([
                _buildSectionItem(
                  icon: Icons.help_outline,
                  title: "Aide et support",
                  actionWidget: const SizedBox.shrink(),
                  onTap: () {},
                ),
                _buildSectionItem(
                  icon: Icons.contact_emergency_outlined,
                  title: "Nous contacter",
                  actionWidget: const SizedBox.shrink(),
                  onTap: () {},
                ),
                _buildSectionItem(
                  icon: Icons.privacy_tip_outlined,
                  title: "Confidentialité",
                  actionWidget: const SizedBox.shrink(),
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColor.buttonColor,
                      foregroundColor: AppColor.noir,
                    ),
                    onPressed: () {
                      _userController.deconnexion();
                    },
                    child: const Text(
                      "Deconnexion",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGroupContainer(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.bordure,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: children.length,
          separatorBuilder: (context, index) => Divider(
            color: AppColor.backg.withValues(alpha: 0.4),
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          itemBuilder: (context, index) => children[index],
        ),
      ),
    );
  }

  Widget _buildSectionItem({
    required IconData icon,
    required String title,
    required Widget actionWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: AppColor.blanc, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColor.blanc,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            actionWidget,
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right,
              color: AppColor.blanc.withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
