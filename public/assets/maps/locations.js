function initMap(locations){map=new OpenLayers.Map("map");var mapnik=new OpenLayers.Layer.OSM,bing=new OpenLayers.Layer.Bing({key:"API-key",type:"Aerial"}),fromProjection=new OpenLayers.Projection("EPSG:4326"),toProjection=new OpenLayers.Projection("EPSG:900913"),position=(new OpenLayers.LonLat(-116.6052,31.86648)).transform(fromProjection,toProjection),zoom=12;map.addLayers([mapnik,bing]),map.setBaseLayer(mapnik),map.addControl(new OpenLayers.Control.LayerSwitcher),map.addControl(new OpenLayers.Control.MousePosition({displayProjection:"EPSG:4326"})),map.setCenter(position,zoom);var locationsJSON=eval("("+locations+")"),styles=new OpenLayers.StyleMap({"default":new OpenLayers.Style(OpenLayers.Util.applyDefaults({externalGraphic:"/assets/maps/icons/blue-dot.png",backgroundGraphic:"/assets/maps/icons/balloon-shadow.png",graphicZIndex:MARKER_Z_INDEX,backgroundGraphicZIndex:SHADOW_Z_INDEX,backgroundXOffset:-7,graphicHeight:32,fillOpacity:1},OpenLayers.Feature.Vector.style["default"])),select:new OpenLayers.Style({externalGraphic:"/assets/maps/icons/red-dot.png"})}),locationsLayer=new OpenLayers.Layer.Vector("Locations",{styleMap:styles});map.addLayer(locationsLayer);for(var location in locationsJSON){var locationPosition=(new OpenLayers.LonLat(locationsJSON[location].longitude,locationsJSON[location].latitude)).transform(fromProjection,toProjection),locationMarker=new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(locationPosition.lon,locationPosition.lat),{title:locationsJSON[location].name,description:locationsJSON[location].description});locationsLayer.addFeatures(locationMarker)}selectControl=new OpenLayers.Control.SelectFeature(locationsLayer,{clickout:!0,toggle:!1,multiple:!1,hover:!1,toggleKey:"ctrlKey",multipleKey:"shiftKey"}),map.addControl(selectControl),selectControl.activate(),locationsLayer.events.on({featureselected:onFeatureSelect,featureunselected:onFeatureUnselect})}function addMarker(e,t,n,r,i,s){var o=new OpenLayers.Feature(e,t);o.closeBox=i,o.popupClass=n,o.data.popupContentHTML=r,o.data.overflow=s?"auto":"hidden";var u=o.createMarker(),a=function(e){this.popup==null?(this.popup=this.createPopup(this.closeBox),map.addPopup(this.popup),this.popup.show()):this.popup.toggle(),currentPopup=this.popup,OpenLayers.Event.stop(e)};u.events.register("mousedown",o,a),e.addFeatures(u)}function onPopupClose(e){var t=this.feature;t.layer?selectControl.unselect(t):this.destroy()}function onFeatureSelect(e){feature=e.feature,popup=new OpenLayers.Popup.FramedCloud("featurePopup",feature.geometry.getBounds().getCenterLonLat(),null,"<h1>"+feature.attributes.title+"</h1>"+feature.attributes.description,null,!0,onPopupClose),feature.popup=popup,popup.feature=feature,map.addPopup(popup,!0)}function onFeatureUnselect(e){feature=e.feature,feature.popup&&(popup.feature=null,map.removePopup(feature.popup),feature.popup.destroy(),feature.popup=null)}var map,selectControl,SHADOW_Z_INDEX=10,MARKER_Z_INDEX=11;