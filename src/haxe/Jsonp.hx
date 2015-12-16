package haxe;
import js.Browser.window;
import js.Browser.document;

/**
  JSONP (or JSON with Padding) is a technique used by web developers to 
  overcome the cross-domain restrictions imposed by browsers to allow data 
  to be retrieved from systems other than the one the page was served by.
  
  @author Mark Knol
 */
class Jsonp {
  static private var _ID = 0;
  
  /**
    Convenience method to create a new Jsonp instance with given callback information.
  */
  public static function requestUrl<T>(url:String, callback:T->Void, jsonCallbackName:String = null) {
    var j = new JsonP(url);
    j.onData = callback;
    j.request(jsonCallbackName);
    return j;
  }
  
	/**
		The url of `this` request. It is used only by the request() method and
		can be changed in order to send the same request to different target
		Urls.
	**/
  public var url:String;
  
  /**
		This method is called upon a successful request, with `data` containing
		the result object.

		The intended usage is to bind it to a custom function:
		`JsonpInstance.onData = function(data) { // handle result }`
	**/
  public var onData:Dynamic->Void;
  
  /**
		Creates a new JsonP instance with `url` as parameter.

		This does not do a request until request() is called.

		If `url` is null, the field url must be set to a value before making the
		call to request(), or the result is unspecified.
	**/
  public function new(url:String = "") {
    this.url = url;
  }
  
  /**
    Sends `this` Jsonp request to the Url specified by `this.url`.
    A script-element is created and added to the head of the browser 
    document. A callback handler is registered to the Window object.
    
    When the data is loaded the `onData` method will be called and
    the callback handler will be unregistered from the Window object 
    and the script-element will be removed from the DOM.
    
    @param callbackName (optional) can be used to set a fixed callback
                        name, otherwise unique name is generated.
  */
  public function request(callbackName:String = null) {
    var name =  callbackName != null ? callbackName : "unique_callback_" + _ID++;
    if (url.indexOf('?') != -1) url += "&callback=" + name;
    else url += "?callback=" + name;

    var script = document.createScriptElement();
    script.type = 'text/javascript';
    script.src = url;

    // Setup handler
    Reflect.setField(window, name, function(data) {
      if (onData != null) onData(data);
      document.getElementsByTagName('head')[0].removeChild(script);
      script = null;
      Reflect.deleteField(window, name);
    });

    // Load JSON
    document.getElementsByTagName('head')[0].appendChild(script);
  }
}
