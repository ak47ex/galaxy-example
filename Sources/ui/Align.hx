package ui;

@:enum
abstract Align(Int) to Int
{
	var center = 1 << 0;
	var top = 1 << 1;
	var bottom = 1 << 2;
	var left = 1 << 3;
	var right = 1 << 4;
	var topLeft = top | left;
	var topRight = top | right;
	var bottomLeft = bottom | left;
	var bottomRight = bottom | right;
}