# Ti.AirPrint Module

## Description

Exposes the AirPrint API to Titanium Mobile applications.

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the Ti.AirPrint Module

To access this module from JavaScript, you would do the following:

<pre>var AirPrint = require('ti.airprint');</pre>

## Functions

### Ti.AirPrint.print({...})

Prints a document by showing a popover on the iPad or a modal window on other iOS devices.

#### Arguments

Takes one argument, a dictionary with the following keys:

* url[string]: The URL to an image or PDF. Can be local or remote, but must be accessible to the app.
* showsPageRange[boolean] (optional): Whether or not to show the page range selector in the popover.
* view[object] (optional): On the iPad, the object from which the popover should originate.
* isHtml [boolean] (optional): Whether or not to print an html string.
* html [string]: The html string to be printed (set isHtml to true).

### Ti.AirPrint.canPrint()

Returns whether or not the current device supports printing. Note that a printer does not need to be attached for this to return true.

## Usage

See example.

## Author

Dawson Toth

## Feedback and Support

Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=iOS%20AirPrint%20Module).

## License

Copyright(c) 2010-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.
