<div align="center">
<img src="assets/icon/icon.png" width="80" />
<h1>Touch Sender</h1>
<p>Touch Sender is a multi-threaded application that detects single touch inputs and transmits the touch state via UDP at up to 1000 Hz. </p>
</div>

<table align="center">
    <tr>
        <td align="center">
            <img src="docs/assets/screenshot1.jpg" height="500" />
        </td>
        <td align="center">
            <img src="docs/assets/screenshot2.jpg" height="500" />
        </td>
    </tr>
    <tr>
        <td align="center">
            <p>Settings screen</p>
        </td>
        <td align="center">
            <p>Touchpad screen</p>
        </td>
    </tr>
</table>

## Features

- Sends touch status (single touch) via UDP.
- Transmits data at up to 1000Hz.
- Multithreaded design: touch detection and UDP transmission run on separate threads.

## Installation

### Android

| Platform        | Links                                                                                                                                                    |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GitHub Releases | [![Download](https://img.shields.io/github/v/release/voltaney/touch-sender?logo=github&label=GitHub)](https://github.com/voltaney/touch-sender/releases) |
| Deploy Gate     | [![Download](https://dply.me/w0rn4z/button/large)](https://dply.me/w0rn4z#install)                                                                       |

### iOS

Currently not available.

## Example Usage

### Spin Rhythm XD

Here is a demonstration video showing how to play a game using the data sent by this application, using the [TouchSenderTablet](https://github.com/voltaney/TouchSenderTablet) as the receiver.

https://github.com/user-attachments/assets/2acf9f1d-42dd-42c2-a63c-a2d8ba15cc77

For more information about related projects, check the [Related Projects](#related-projects) section below.

## Limitations

- Implemented in Flutter, which may cause some overhead due to the gesture arena mechanism.
- Touch data is currently handled in [Flutter's logical pixels](https://api.flutter.dev/flutter/dart-ui/FlutterView/devicePixelRatio.html), not in physical screen coordinates.

## Related Projects

- [TouchSenderInterpreter](https://github.com/voltaney/TouchSenderInterpreter): A library for parsing data received from this application. Available on [NuGet](https://www.nuget.org/packages/Voltaney.TouchSenderInterpreter/).
- [TouchSenderTablet](https://github.com/voltaney/TouchSenderTablet): A Windows application that controls the PC mouse using data received from this application.
