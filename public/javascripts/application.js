// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function serialize_fields(){
  var fields = new Array();
  fields.push(Form.Element.serialize('user_withings_userid'));
  fields.push(Form.Element.serialize('user_withings_publickey'));
  return fields.join('&');
}

