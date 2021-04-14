//Simple reverse geocoder

function GreverseGeocodeLatLng(latitude, longitude) {

  Utilities.sleep(1000);
  
  
  var test = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+latitude+","+longitude+"&location_type=GEOMETRIC_CENTER&key=XXX"
  var result = UrlFetchApp.fetch(test);    
  var json = result.getContentText();
  var data = JSON.parse(json);   
    
   response = data.results[0];    
      
  
  if(response === undefined) {
    return "??";
  }
  function g(fieldName) {
    for (var i = 0; i < response.address_components.length; i++) {
      if(response.address_components[i].types.indexOf(fieldName) != -1) {
        return response.address_components[i];
      }
    }
    return {"long_name": "??"};
  }
  rValue = [[g("route").long_name, g("locality").long_name]]; // g("postal_code").long_name, g("street_number").long_name
  return rValue;
  
}



function GreverseGeocodeLatLngr0(latitude, longitude) {

  Utilities.sleep(1000);
  
  
  var test = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+latitude+","+longitude+"&key=XXX"
  var result = UrlFetchApp.fetch(test);    
  var json = result.getContentText();
  var data = JSON.parse(json);   
    
   response = data.results[0];    
      
  
  if(response === undefined) {
    return "??";
  }
  function g(fieldName) {
    for (var i = 0; i < response.address_components.length; i++) {
      if(response.address_components[i].types.indexOf(fieldName) != -1) {
        return response.address_components[i];
      }
    }
    return {"long_name": "??"};
  }
  rValue = [[g("route").long_name, g("locality").long_name]]; // g("postal_code").long_name, g("street_number").long_name
  return rValue;
  
}


///////////////////////////////////////////////////////////////HEBREW//////////////////////////////////////////////////


function GreverseGeocodeLatLngHEB(latitude, longitude) {

  Utilities.sleep(1000);
  
  
  var test = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+latitude+","+longitude+"&language=iw&location_type=GEOMETRIC_CENTER&key=XXX"
  var result = UrlFetchApp.fetch(test);    
  var json = result.getContentText();
  var data = JSON.parse(json);   
   
   response = data.results[0];    
      
  

 
  if(response === undefined) {
    return "??";
  }
  function g(fieldName) {
    for (var i = 0; i < response.address_components.length; i++) {
      if(response.address_components[i].types.indexOf(fieldName) != -1) {
        return response.address_components[i];
      }
    }
    return {"long_name": "??"};
  }
  rValue = [[g("route").long_name, g("locality").long_name,]];
  return rValue;
  
}




function GreverseGeocodeLatLngHEBR0(latitude, longitude) {

  Utilities.sleep(1000);
  
  
  var test = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+latitude+","+longitude+"&language=iw&key=XXX"
  var result = UrlFetchApp.fetch(test);    
  var json = result.getContentText();
  var data = JSON.parse(json);   
    
   response = data.results[0];    
      
  
  if(response === undefined) {
    return "??";
  }
  function g(fieldName) {
    for (var i = 0; i < response.address_components.length; i++) {
      if(response.address_components[i].types.indexOf(fieldName) != -1) {
        return response.address_components[i];
      }
    }
    return {"long_name": "??"};
  }
  rValue = [[g("route").long_name, g("locality").long_name,]];
  return rValue;
  
}

///////////////////////////////////////////////////////////////ARABIC//////////////////////////////////////////////////


function GreverseGeocodeLatLngAR(latitude, longitude) {

  Utilities.sleep(1000);
  
  
  var test = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+latitude+","+longitude+"&language=ar&location_type=GEOMETRIC_CENTER&key=XXX"
  var result = UrlFetchApp.fetch(test);    
  var json = result.getContentText();
  var data = JSON.parse(json);   

   response = data.results[0];    
      


  if(response === undefined) {
    return "??";
  }
  function g(fieldName) {
    for (var i = 0; i < response.address_components.length; i++) {
      if(response.address_components[i].types.indexOf(fieldName) != -1) {
        return response.address_components[i];
      }
    }
    return {"long_name": "??"};
  }
  rValue = [[g("route").long_name, g("locality").long_name,]];
  return rValue;
  
}
            
    
            
            
function GreverseGeocodeLatLngARR0(latitude, longitude) {

  Utilities.sleep(1000);
  
  var test = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+latitude+","+longitude+"&language=ar&key=XXX"
  var result = UrlFetchApp.fetch(test);    
  var json = result.getContentText();
  var data = JSON.parse(json);   
 
   response = data.results[0];    
      


  if(response === undefined) {
    return "??";
  }
  function g(fieldName) {
    for (var i = 0; i < response.address_components.length; i++) {
      if(response.address_components[i].types.indexOf(fieldName) != -1) {
        return response.address_components[i];
      }
    }
    return {"long_name": "??"};
  }
  rValue = [[g("route").long_name, g("locality").long_name,]];
  return rValue;
  
}            