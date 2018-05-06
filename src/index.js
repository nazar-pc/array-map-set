// Generated by LiveScript 1.5.0
/**
 * @package ArrayMap and ArraySet
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
(function(){
  var key_aliases, key_strings, key_usages;
  key_aliases = new WeakMap;
  key_strings = new Map;
  key_usages = new Map;
  /**
   * @param {!ArrayBufferView} key
   *
   * @return {!ArrayBufferView}
   */
  function get_unique_key(key){
    var real_key, key_string;
    real_key = key_aliases.get(key);
    /**
     * Real key is an array with unique contents that appeared first.
     * If all of the usages were eliminated, some WeakMap can still point to old real key, which is not a real key anymore, which leads to inconsistencies.
     * In order to resolve this we have an additional check that confirms if real key is still believed to be a real key.
     */
    if (real_key && key_usages.has(real_key)) {
      return real_key;
    } else {
      key_string = key.join(',');
      if (key_strings.has(key_string)) {
        real_key = key_strings.get(key_string);
        key_aliases.set(key, real_key);
        return real_key;
      } else {
        return key;
      }
    }
  }
  /**
   * @param {!ArrayBufferView} key
   */
  function increase_key_usage(key){
    var key_string, current_value;
    key_string = key.join(',');
    current_value = key_usages.get(key);
    if (!current_value) {
      key_aliases.set(key, key);
      key_strings.set(key_string, key);
      key_usages.set(key, 1);
    } else {
      ++current_value;
      key_usages.set(key, current_value);
    }
  }
  /**
   * @param {!ArrayBufferView} key
   */
  function decrease_key_usage(key){
    var key_string, current_value;
    key_string = key.join(',');
    current_value = key_usages.get(key);
    --current_value;
    if (!current_value) {
      key_strings['delete'](key_string);
      key_usages['delete'](key);
    } else {
      key_usages.set(key, current_value);
    }
  }
  /**
   * This is a Map with very interesting property: different arrays with the same contents will be treated as the same array
   *
   * Implementation keeps weak references to make the whole thing fast and efficient
   */
  function ArrayMap(array){
    var x$, map, i$, len$, ref$, key, value;
    x$ = map = new Map;
    x$.get = function(key){
      key = get_unique_key(key);
      return Map.prototype.get.call(this, key);
    };
    x$.has = function(key){
      key = get_unique_key(key);
      return Map.prototype.has.call(this, key);
    };
    x$.set = function(key, value){
      key = get_unique_key(key);
      if (!Map.prototype.has.call(this, key)) {
        increase_key_usage(key);
      }
      return Map.prototype.set.call(this, key, value);
    };
    x$['delete'] = function(key){
      key = get_unique_key(key);
      if (Map.prototype.has.call(this, key)) {
        decrease_key_usage(key);
      }
      return Map.prototype['delete'].call(this, key);
    };
    x$.clear = function(){
      var this$ = this;
      this.forEach(function(arg$, key){
        this$['delete'](key);
      });
    };
    if (array) {
      for (i$ = 0, len$ = array.length; i$ < len$; ++i$) {
        ref$ = array[i$], key = ref$[0], value = ref$[1];
        map.set(key, value);
      }
    }
    return map;
  }
  /**
   * This is a Set with very interesting property: different arrays with the same contents will be treated as the same array
   *
   * Implementation keeps weak references to make the whole thing fast and efficient
   */
  function ArraySet(array){
    var x$, set, i$, len$, item;
    x$ = set = new Set;
    x$.has = function(key){
      key = get_unique_key(key);
      return Set.prototype.has.call(this, key);
    };
    x$.add = function(key){
      key = get_unique_key(key);
      if (!Set.prototype.has.call(this, key)) {
        increase_key_usage(key);
      }
      return Set.prototype.add.call(this, key);
    };
    x$['delete'] = function(key){
      key = get_unique_key(key);
      if (Set.prototype.has.call(this, key)) {
        decrease_key_usage(key);
      }
      return Set.prototype['delete'].call(this, key);
    };
    x$.clear = function(){
      var this$ = this;
      this.forEach(function(arg$, key){
        this$['delete'](key);
      });
    };
    if (array) {
      for (i$ = 0, len$ = array.length; i$ < len$; ++i$) {
        item = array[i$];
        set.add(item);
      }
    }
    return set;
  }
  function Wrapper(){
    return {
      'ArrayMap': ArrayMap,
      'ArraySet': ArraySet
    };
  }
  if (typeof define === 'function' && define['amd']) {
    define(Wrapper);
  } else if (typeof exports === 'object') {
    module.exports = Wrapper();
  } else {
    this['detox_utils'] = Wrapper();
  }
}).call(this);