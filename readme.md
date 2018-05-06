# ArrayMap and ArraySet [![Travis CI](https://img.shields.io/travis/nazar-pc/array-map-set/master.svg?label=Travis%20CI)](https://travis-ci.org/nazar-pc/array-map-set)
Just like regular Map and Set, but treats different `ArrayBufferView`s with the same values as equal.

When dealing with `Uint8Array` or other `ArrayBufferView` instance, you might receive them from different sources (like from the network, binary files, etc).
If you use these `Uint8Array`s as keys in `Map` or `Set`, different instances will be treated as completely different keys.
This package provides `ArrayMap` and `ArraySet` implementations, that work exactly the same way as plain versions, but treat such `Uint8Array`s as the same as long as they have the same contents.
You will also get consistently the same instance of `Uint8Array` as you iterate over keys or values and all of the `ArrayMap` or `ArraySet` will share the same instance of `Uint8Array`.

Internal implementation uses `WeakMap` and is optimized for high memory efficiency and performance.

## How to install
```
npm install array-map-set
```

## How to use
Node.js:
```javascript
var array_map_set = require('array-map-set')

// Do stuff
```
Browser:
```javascript
requirejs(['array-map-set'], function (array_map_set) {
    // Do stuff
})
```

## API
### array_map_set.ArrayMap(array : Array) : Map
The same constructor as plain `Map`, returns `Map` object.

### array_map_set.ArraySet(array : Array) : Set
The same constructor as plain `Set`, returns `Set` object.

## Contribution
Feel free to create issues and send pull requests (for big changes create an issue first and link it from the PR), they are highly appreciated!

When reading LiveScript code make sure to configure 1 tab to be 4 spaces (GitHub uses 8 by default), otherwise code might be hard to read.

## License
Free Public License 1.0.0 / Zero Clause BSD License

https://opensource.org/licenses/FPL-1.0.0

https://tldrlegal.com/license/bsd-0-clause-license
