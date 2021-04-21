import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:petcaremovil/src/models/venta.dart';
import 'package:petcaremovil/src/pages/Compra.dart';

class ListaCompras extends StatelessWidget {
  final String idprofile;

  ListaCompras({Key keys, @required this.idprofile}) : super(key: keys);

  List<Venta> parseListVentas(String reponseBody) {
    final parsed = jsonDecode(reponseBody).cast<Map<String, dynamic>>();
    return parsed.map<Venta>((json) => Venta.fromJson(json)).toList();
  }

  Future<List<Venta>> fetchCompras(http.Client client) async {
    final response = await http.get(
        Uri.parse('http://34.239.109.204/api/v1/profile/profile_detail/42/'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Token cbb26288d097255ebf4e4a02339ad53561e64c40"
        });

    return parseListVentas(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mis Compras Realizadas"),
        elevation: 0,
      ),
      body: FutureBuilder<List<Venta>>(
        future: fetchCompras(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListCompras(listCompras: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ListCompras extends StatelessWidget {
  final List<Venta> listCompras;

  ListCompras({Key key, this.listCompras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(left: 30, right: 30),
        child: ListView.builder(
          itemCount: listCompras.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Card(
                  color: Theme.of(context).cardColor,
                  shadowColor: Colors.blueAccent,
                  elevation: 4,
                  child: new InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Compra(
                            idcompra: index.toString(),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 8.0, bottom: 4.0),
                            child: Row(children: <Widget>[
                              Text(
                                //listCompras[index].name,
                                "\$ 1500",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Spacer(),
                              Icon(
                                Icons.shopping_bag_outlined,
                                color: Theme.of(context).secondaryHeaderColor,
                              )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 4.0, bottom: 10.0),
                            child: Row(children: <Widget>[
                              Text(
                                //"${DateFormat('dd/MM/yyyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(trip.endDate).toString()}"),
                                //listCompras[index].email,
                                "12-05-2020",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Pago: Tarjeta",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ));
  }
}