part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // dynamic provinceData;

  bool isLoading = false;

  List<String> shippingCompanies = ['jne', 'pos', 'tiki'];
  dynamic selectedShippingCompany;
  final ctrlNumber = TextEditingController();

  List<Province> provinceOriginData = [];
  dynamic provinceIdOrigin;
  dynamic selectedProvinceOrigin;

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;

  List<Province> provinceToData = [];
  dynamic provinceIdTo;
  dynamic selectedProvinceTo;

  dynamic cityDataTo;
  dynamic cityIdTo;
  dynamic selectedCityTo;

  Future<dynamic> getProvinces() async {
    // dynamic prov;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceOriginData = value;
        provinceToData = value;
        isLoading = false;
      });
    });
    // return prov;
  }

  Future<List<City>> getCitiesOrigin(dynamic provId) async {
    List<City> citiesOrigin = [];
    await MasterDataService.getCity(provId).then((value) {
      citiesOrigin = value;
    });
    return citiesOrigin;
  }

  Future<List<City>> getCitiesDestination(dynamic provId) async {
    List<City> citiesDestination = [];
    await MasterDataService.getCity(provId).then((value) {
      citiesDestination = value;
    });
    return citiesDestination;
  }

  Future<void> updateCityDataOrigin(dynamic provId) async {
    cityDataOrigin = getCitiesOrigin(provId);
    await cityDataOrigin;
  }

  Future<void> updateCityDataTo(dynamic provId) async {
    cityDataTo = getCitiesDestination(provId);
    await cityDataTo;
  }

  List<Costs> shippingCosts = [];

  Future<List<Costs>> getTCost(dynamic cityIdOrigin, dynamic cityIdTo,
      int controlNumber, dynamic selectedShippingCompany) async {
    // Convert controlNumber to an integer
    // int weight = int.parse(controlNumber);

    await MasterDataService.getCost(
      cityIdOrigin.toString(),
      cityIdTo.toString(),
      controlNumber,
      selectedShippingCompany,
    ).then((value) {
      shippingCosts = value;
    });
    return shippingCosts;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getProvinces();
    cityDataOrigin = getCitiesOrigin(provinceIdOrigin);
    cityDataTo = getCitiesDestination(provinceIdTo);
    // Future.delayed(Duration(seconds: 3), () {
    //    getCities(provinceIdOrigin);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('HomePage'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100,
                        // height: 80,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedShippingCompany,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 4,
                          style: TextStyle(color: Colors.black),
                          hint: Text('Pilih'),
                          items: shippingCompanies
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedShippingCompany = newValue!;
                            });
                          },
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        width: 150,
                        height: 60,
                        child: TextFormField(
                          controller: ctrlNumber,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Berat (gr)',
                            // border: OutlineInputBorder(),
                            // prefixIcon: Icon(Icons.phone),
                          ),
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          // validator: (value) {
                          // if (value!.isEmpty) {
                          //   return 'Nomor telepon harus diisi';
                          // }
                          // if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                          //   return 'Nomor telepon hanya boleh mengandung angka';
                          // }
                          // if (value.length < 8 || value.length > 13) {
                          //   return 'Nomor telepon harus terdiri dari 8 hingga 13 angka';
                          // }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text("Origin"),
              Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Container(
                              width: 100,
                              child: provinceOriginData.isEmpty
                                  ? const Align(
                                      alignment: Alignment.center,
                                      child: Text("Data tidak ditemukan"),
                                    )
                                  : DropdownButton<Province>(
                                      isExpanded: true,
                                      value: selectedProvinceOrigin,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: TextStyle(color: Colors.black),
                                      hint: selectedProvinceOrigin == null
                                          ? Text('Pilih Provinsi')
                                          : Text(
                                              selectedProvinceOrigin.province!),
                                      items: provinceOriginData
                                          .map<DropdownMenuItem<Province>>(
                                              (Province value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value.province!),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) async {
                                        setState(() {
                                          selectedProvinceOrigin = newValue;
                                          provinceIdOrigin =
                                              selectedProvinceOrigin.provinceId;
                                          selectedCityOrigin = null;
                                        });
                                        await updateCityDataOrigin(
                                            provinceIdOrigin);
                                      },
                                    ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: FutureBuilder<List<City>>(
                                future: cityDataOrigin,
                                builder: (context, snapshot) {
                                  var data = snapshot.connectionState;
                                  if (data != ConnectionState.done) {
                                    return UiLoading.loadingSmall();
                                  } else {
                                    if (snapshot.hasData) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityOrigin,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 4,
                                          style: TextStyle(color: Colors.black),
                                          hint: selectedCityOrigin == null
                                              ? Text('Pilih Kota')
                                              : Text(
                                                  selectedCityOrigin.cityName),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedCityOrigin = newValue;
                                              cityIdOrigin =
                                                  selectedCityOrigin.cityId;
                                            });
                                          });
                                    } else if (snapshot.hasError) {
                                      return Text("Tidak ada Data");
                                    }
                                  }
                                  return Text('');
                                }),
                          ),
                        ],
                      )
                    ]),
                  )),
              Text("To"),
              Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Container(
                              width: 100,
                              child: provinceToData.isEmpty
                                  ? const Align(
                                      alignment: Alignment.center,
                                      child: Text("Data tidak ditemukan"),
                                    )
                                  : DropdownButton<Province>(
                                      isExpanded: true,
                                      value: selectedProvinceTo,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: TextStyle(color: Colors.black),
                                      hint: selectedProvinceTo == null
                                          ? Text('Pilih Provinsi')
                                          : Text(selectedProvinceTo.province!),
                                      items: provinceToData
                                          .map<DropdownMenuItem<Province>>(
                                              (Province value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value.province!),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) async {
                                        setState(() {
                                          selectedProvinceTo = newValue;
                                          provinceIdTo =
                                              selectedProvinceTo.provinceId;
                                          selectedCityTo = null;
                                        });
                                        await updateCityDataTo(provinceIdTo);
                                      },
                                    ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: FutureBuilder<List<City>>(
                                future: cityDataTo,
                                builder: (context, snapshot) {
                                  var data = snapshot.connectionState;
                                  if (data != ConnectionState.done) {
                                    return UiLoading.loadingSmall();
                                  } else {
                                    if (snapshot.hasData) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityTo,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 4,
                                          style: TextStyle(color: Colors.black),
                                          hint: selectedCityTo == null
                                              ? Text('Pilih Kota')
                                              : Text(selectedCityTo.cityName),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedCityTo = newValue;
                                              cityIdTo = selectedCityTo.cityId;
                                            });
                                          });
                                    } else if (snapshot.hasError) {
                                      return Text("Tidak ada Data");
                                    }
                                  }
                                  return Text('');
                                }),
                          ),
                        ],
                      )
                    ]),
                  )),
              ElevatedButton(
                onPressed: () async {
                  if (selectedCityOrigin != null &&
                      selectedCityTo != null &&
                      ctrlNumber.text.isNotEmpty &&
                      selectedShippingCompany != null) {
                    List<Costs> updatedShippingCosts = await getTCost(
                      "501",
                      "114",
                      1700,
                      "jne",
                      // cityIdOrigin,
                      // cityIdTo,
                      // ctrlNumber.text,
                      // selectedShippingCompany,
                    );

                    setState(() {
                      shippingCosts = updatedShippingCosts;
                    });
                  } else {
                    print('Please fill in all required fields');
                  }
                },
                child: Text('Calculate Shipping Cost'),
              ),
              Flexible(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: shippingCosts.isEmpty
                      ? const Align(
                          alignment: Alignment.center,
                          child: Text("Data tidak ditemukan"),
                        )
                      : ListView.builder(
                          itemCount: shippingCosts.length,
                          itemBuilder: (context, index) {
                            return CardCost(shippingCosts[index]);
                          },
                        ),
                ),
              ),
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container()
        ],
      ),
    );
  }
}
