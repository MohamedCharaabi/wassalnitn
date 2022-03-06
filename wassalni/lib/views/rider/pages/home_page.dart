import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/driver_crud.dart';
import 'package:wassalni/modelView/services/firebase_crud.dart';
import 'package:wassalni/models/ride_model.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DriverCrud _driverCrud = DriverCrud();

  @override
  Widget build(BuildContext context) {
    String _userId = Provider.of<UserProvider>(context).currentUser!.uid!;
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Requests",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: white,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<RideModel>?>(
              future: _driverCrud.getDriverRides(_userId),
              builder: (context, snapshots) {
                return snapshots.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : snapshots.hasData
                        ? ListView.builder(
                            itemCount: snapshots.data!.length,
                            itemBuilder: (context, index) {
                              RideModel _ride = snapshots.data![index];

                              return FutureBuilder<UserModel?>(
                                  future:
                                      FirebaseCrud().getUserInfo(_ride.user_id),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : snapshot.hasData
                                            ? ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: snapshot
                                                              .data!.image !=
                                                          null
                                                      ? NetworkImage(
                                                          snapshot.data!.image!)
                                                      : null,
                                                ),
                                                title: Text(
                                                    snapshot.data!.name!,
                                                    style: TextStyle(
                                                        color: white)),
                                                subtitle: Text(
                                                    snapshot.data!.phone ??
                                                        "no phone",
                                                    style: TextStyle(
                                                        color: white)),
                                                trailing: Text(
                                                  _ride.status.name,
                                                  style: TextStyle(
                                                    color: _ride.status.name ==
                                                            "accepted"
                                                        ? Colors.green
                                                        : _ride.status.name ==
                                                                "rejected"
                                                            ? Colors.red
                                                            : Colors.grey,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox();
                                  });
                            },
                          )
                        : Center(
                            child: Text("No Requests",
                                style: TextStyle(fontSize: 20, color: white)),
                          );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
