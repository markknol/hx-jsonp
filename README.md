# JSONP for Haxe

 > JSONP (or JSON with Padding) is a technique used by web developers to overcome the cross-domain restrictions imposed by browsers to allow data to be retrieved from systems other than the one the page was served by.

## Usage
```haxe
var url = js.Browser.location.protocol + '//mywebsite.com/api/jsonp/search/';
var http = new haxe.Jsonp(url);
http.onData = function(data) {
  trace(data);
}
http.request("search_callback");
```
### Notes
This library only works for the Haxe JavaScript target.
