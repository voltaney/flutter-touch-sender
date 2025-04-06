<div align="center">
<img src="assets/icon/icon.png" width="80" />
<h1>Touch Sender</h1>
Touch Sender is a multithreaded application that detects single-touch input and transmits the touch state over UDP at up to 1000 Hz. Touch detection and UDP transmission run on separate threads to ensure high responsiveness and performance.
</div>

<table align="center">
    <tr>
        <td align="center">
            <img src="docs/assets/screenshot1.jpg" height="400" /><br />
            <p>Settings screen</p>
        </td>
        <td align="center">
            <img src="docs/assets/screenshot2.jpg" height="400" /><br />
            <p>Touchpad screen</p>
        </td>
    </tr>
</table>

## Features

- Sends touch state (single-touch) via UDP.
- Transmits data at up to 1000 Hz.
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

Here is a showcase video demonstrating how a game is played using the data sent by this app and received by [TouchSenderTablet](https://github.com/voltaney/TouchSenderTablet):

https://github.com/user-attachments/assets/2acf9f1d-42dd-42c2-a63c-a2d8ba15cc77

For more information about related projects, check the [Related Projects](#related-projects) section below.

## Limitations

- Implemented in Flutter, which may introduce slight overhead due to the Gesture Arena mechanism.
- Touch data is currently handled in Flutter's logical pixels, not in physical screen coordinates.

## Related Projects

- [TouchSenderInterpreter](https://github.com/voltaney/TouchSenderInterpreter): A library for parsing data received from this application. Available on [NuGet](https://www.nuget.org/packages/Voltaney.TouchSenderInterpreter/).
- [TouchSenderTablet](https://github.com/voltaney/TouchSenderTablet): A Windows application that uses the data received from this application to control the mouse on a PC.
