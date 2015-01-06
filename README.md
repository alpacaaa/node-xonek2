

# Allen & Heath XONE:K2 Node.js api

This module wraps the MIDI interface to communicate with the [XONE:K2](http://www.allen-heath.com/ahproducts/xonek2/) in a sane api for Node.


### Install

`npm install xonek2`


### Setup

Plug in the controller ( ͡° ͜ʖ ͡°)

```javascript
var xonek2 = require('xonek2');
var controller = xonek2.create();

if (!controller.connect())
  throw new Error("Can't connect to device");
```


### Layout

The controller has 4 channels

```javascript
// Access the third channel
var channel = controller.channels[2];
```

Each channel has an endless knob at the top, 3 standard knobs, a fader and 4 buttons

```javascript
channel.endless_knob
channel.knobs[1] // The second knob
channel.fader
channel.buttons[3] // The last button
```

Standard knobs have a button beneath them, endless knobs are buttons themselves (on push).

```javascript
channel.knobs[0].button
channel.endless_knob.button
```

Buttons and knobs have leds attached

```javascript
channel.endless_knob.led
channel.knobs[2].button.led
channel.buttons[0].led
```

The two big buttons and the central endless knobs at the bottom can be accessed through `controller.utils`

```javascript
controller.utils.buttons[1] // The "EXIT SETUP" button
controller.utils.endless_knobs[0]
```


### Usage

All the components (except for leds) emit events.

##### Buttons

```javascript
var button = controller.channels[0].buttons[1]; // The "E" button

button.on('press', function() {
  console.log('Button pressed');
});

button.on('release', function() {
  console.log('Button released');
});
```

##### Knobs

```javascript
var knob = controller.channels[3].knobs[1]; // The second knob on the last channel

knob.on('update', function(value) {
  console.log('Knob twisted: the value is (0-127): ' + value);
});
```


##### Faders

```javascript
var fader = controller.channels[1].fader; // The fader on the second channel

fader.on('update', function(value) {
  console.log('Fader moved: the value is (0-127): ' + value);
});
```

##### Endless knobs

```javascript
var endless_knob = controller.channels[0].endless_knob; // The endless knob on the first channel

endless_knob.on('update', function(value) {
  if (value == 1)
    console.log('Turnin right');

  if (value == -1)
    console.log('Turnin left');
});
```

##### Leds

Leds can be lit up in three different colors: red (default), orange and green.

```javascript
var led = controller.channels[2].knobs[0].button.led;
led.turn_on()

var led2 = controller.channels[0].endless_knob.led;
led2.turn_on(xonek2.COLOR_ORANGE);

var led3 = controller.channels[1].buttons[2].led;
led3.turn_on(xonek2.COLOR_GREEN);
```

Turn off a led

```javascript
led.turn_off();
```

Turn off all leds

```javascript
controller.reset_leds();
```


### Testing

Testing is done with a virtual midi device (so you don't need to connect the controller).

`npm test`


### License

```
Copyright (c) 2015, Marco Sampellegrini <babbonatale@alpacaaa.net>


Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

```
