import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Your api key storage.
import 'keys.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
    buttonTheme: const ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
    buttonTheme: const ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.yellow,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Place Picker Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage();

  static final kInitialPosition = const LatLng(-33.8567844, 151.213108);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PickResult? selectedPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map Place Picker Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Load Google Map"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PlacePicker(
                        apiKey: APIKeys.apiKey,
                        initialPosition: HomePage.kInitialPosition,
                        useCurrentLocation: true,
                        zoomControlsEnabled: false,
                        selectInitialPosition: true,

                        //usePlaceDetailSearch: true,
                        onPlacePicked: (result) {
                          setState(() => selectedPlace = result);
                          Navigator.pop(context);
                        },
                        //forceSearchOnZoomChanged: true,
                        //automaticallyImplyAppBarLeading: false,
                        //autocompleteLanguage: "ko",
                        //region: 'au',
                        //selectInitialPosition: true,
                        selectedPlaceWidgetBuilder: (context, selectedPlace,
                            state, isSearchBarFocused) {
                          print(
                              "state: $state, isSearchBarFocused: $isSearchBarFocused");
                          return isSearchBarFocused
                              ? const SizedBox.shrink()
                              : CustomFloatingCard(state);
                        },
                        // pinBuilder: (context, state) {
                        //   if (state == PinState.Idle) {
                        //     return Icon(Icons.favorite_border);
                        //   }
                        //
                        //   return Icon(Icons.favorite);
                        // },
                      );
                    },
                  ),
                );
              },
            ),
            if (selectedPlace != null)
              Text(
                selectedPlace!.formattedAddress ?? "",
              )
          ],
        ),
      ),
    );
  }
}

class CustomFloatingCard extends StatelessWidget {
  final SearchingState state;

  const CustomFloatingCard(this.state);

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
    return FloatingCard(
      bottomPosition: 0.0,
      leftPosition: 0.0,
      rightPosition: 0.0,
      width: 500,
      borderRadius: BorderRadius.circular(12.0),
      child: state == SearchingState.Searching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ElevatedButton(
              child: const Text("Pick Here"),
              onPressed: () {
                // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                //            this will override default 'Select here' Button.
                print("do something with [selectedPlace] data");
                Navigator.pop(context);
              },
            ),
    );
  }
}
