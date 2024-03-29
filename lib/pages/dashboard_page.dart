import 'package:alfi_gest/providers/clubs/clubs_provider.dart';
import 'package:alfi_gest/widgets/clubs/club_logo.dart';
import 'package:alfi_gest/widgets/clubs/clubs_select.dart';
import 'package:alfi_gest/widgets/dashboard/cards.dart';
import 'package:alfi_gest/widgets/dashboard/input_card.dart';
import 'package:alfi_gest/widgets/user/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var clubController = TextEditingController();
    final userData = ref.watch(userDataProvider);
    final memberRole = ref.watch(roleProvider);
    final clubs = ref.watch(filteredClubsProvider);
    if (clubController.text.isEmpty && clubs.isNotEmpty) {
      clubController.text =
          clubs.where((c) => c.idClub == userData!.idClub).first.nameClub;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(25, 25, 25, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        userData == null
                            ? "Ciao!"
                            : "Ciao ${userData.givenName.isEmpty ? userData.legalName : userData.givenName}!",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        memberRole == null
                            ? "Non hai ruoli"
                            : formatRole(memberRole),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                userData!.idClub.isEmpty
                    ? const SizedBox.shrink()
                    : ClubLogo(idClub: userData.idClub, radius: 30),
              ],
            ),
            const SizedBox(height: 18),
            memberRole != null && memberRole == Role.socia
                ? const SizedBox(height: 20)
                : SizedBox.shrink(),
            memberRole != null && memberRole == Role.socia
                ? UserDetails()
                : memberRole == Role.responsabileCircolo
                    ? SizedBox.shrink()
                    : Row(
                        children: [
                          const Spacer(),
                          Expanded(
                            child: SizedBox(
                              height: 32,
                              child: FractionallySizedBox(
                                widthFactor: 0.9,
                                child: ClubsSelectWidget(
                                    clubController: clubController,
                                    clubs: clubs,
                                    isTextField: false),
                              ),
                            ),
                          ),
                        ],
                      ),
            const SizedBox(height: 33),
            memberRole != null && memberRole == Role.socia
                ? const SizedBox.shrink()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: const CardLargeDashboard(
                          title: "Socie*",
                          data: {
                            100: "Socie attive",
                            30: "Non Attive",
                            10: "Sospese",
                          },
                          height: {
                            "Attive": 145.0,
                            "Non Attive": 50.0,
                            "Sospese": 50.0,
                          },
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const CardSmallDashboard(
                              title: "Newsletter",
                              data: {
                                100: "Si",
                                30: "No",
                              },
                              height: {
                                "Si": 50.0,
                                "No": 50.0,
                              },
                            ),
                            const CardSmallDashboard(
                              title: "WhatsApp",
                              data: {
                                100: "Si",
                                30: "No",
                              },
                              height: {
                                "Si": 50.0,
                                "No": 50.0,
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            memberRole != null && memberRole == Role.socia
                ? const SizedBox.shrink()
                : InputCard(
                    title: "Validità tessera",
                    labelsInputs: {
                      0: "Tessera numero",
                    },
                    textBtn: "Verifica"),
          ],
        ),
      ),
    );
  }
}
