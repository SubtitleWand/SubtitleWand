package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	file_picker "github.com/miguelpruivo/flutter_file_picker/go"
	path_provider "github.com/go-flutter-desktop/plugins/path_provider"
	url_launcher "github.com/go-flutter-desktop/plugins/url_launcher"
)

const windowHeight = 800
const windowWidth = 1280

var options = []flutter.Option{

	flutter.WindowInitialDimensions(
		windowWidth,
		windowHeight,
	),
	flutter.WindowDimensionLimits(1280, 800, 1600, 900),
	flutter.AddPlugin(&file_picker.FilePickerPlugin{}),
	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "tokenyet.github.io",
		ApplicationName: "subtitlewand",
	}),
	flutter.AddPlugin(&url_launcher.UrlLauncherPlugin{}),
}
