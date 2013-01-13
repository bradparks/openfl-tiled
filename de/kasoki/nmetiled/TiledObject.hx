// Copyright (C) 2012 Christopher Kaster
// 
// This file is part of nme-tiled.
// 
// nme-tiled is free software: you can redistribute it and/or modify it under the
// terms of the GNU Lesser General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
// 
// nme-tiled is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
// more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with nme-tiled. If not, see: <http://www.gnu.org/licenses/>.
package de.kasoki.nmetiled;

import nme.geom.Point;

class TiledObject {

	public var gid(default, null):Int;
	public var name(default, null):String;
	public var type(default, null):String;
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var hasPolygon(checkHasPolygon, null):Bool;
	public var hasPolyline(checkHasPolyline, null):Bool;
	public var polygon(default, null):TiledPolygon;
	public var polyline(default, null):TiledPolyline;
	public var properties(default, null):Hash<String>;
	
	public function new(gid:Int, name:String, type:String, x:Int, y:Int, width:Int, height:Int, polygon:TiledPolygon, polyline:TiledPolyline, properties:Hash<String>) {
		this.gid = gid;
		this.name = name;
		this.type = type;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.polygon = polygon;
		this.polyline = polyline;
		this.properties = properties;
	}
	
	public static function fromXml(xml:Xml):TiledObject {
		var gid:Int = xml.get("gid") != null ? Std.parseInt(xml.get("gid")) : 0;
		var name:String = xml.get("name");
		var type:String = xml.get("type");
		var x:Int = Std.parseInt(xml.get("x"));
		var y:Int = Std.parseInt(xml.get("y"));
		var width:Int = Std.parseInt(xml.get("width"));
		var height:Int = Std.parseInt(xml.get("height"));
		var polygon:TiledPolygon = null;
		var polyline:TiledPolyline = null;
		var properties:Hash<String> = new Hash<String>();
		
		for (child in xml) {
			if(Helper.isValidElement(child)) {
				if (child.nodeName == "properties") {
					for (property in child) {
						if(Helper.isValidElement(property)) {
							properties.set(property.get("name"), property.get("value"));
						}
					}
				}
				
				if (child.nodeName == "polygon" || child.nodeName == "polyline") {
					var origin:Point = new Point(x, y);
					var points:Array<Point> = new Array<Point>();
					
					var pointsAsString:String = child.get("points");
					
					var pointsAsStringArray:Array<String> = pointsAsString.split(" ");
					
					for(p in pointsAsStringArray) {
						var coords:Array<String> = p.split(",");
						points.push(new Point(Std.parseInt(coords[0]), Std.parseInt(coords[1])));
					}
					
					if(child.nodeName == "polygon") {
						polygon = new TiledPolygon(origin, points);
					} else if(child.nodeName == "polyline") {
						polyline = new TiledPolyline(origin, points);
					}
				}
			}
		}
		
		return new TiledObject(gid, name, type, x, y, width, height, polygon, polyline, properties);
	}
	
	private function checkHasPolygon():Bool {
		return this.polygon != null;
	}
	
	private function checkHasPolyline():Bool {
		return this.polyline != null;
	}
	
}
