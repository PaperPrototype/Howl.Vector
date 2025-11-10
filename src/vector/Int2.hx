package vector;

class Int2Class {
    public var x:Int;
    public var y:Int;

    public function new(x:Int, y:Int) {
        this.x = x;
        this.y = y;
    }
}


/**
	An Int2 vector class with operator overloading based on Prowl.Vector.

    Ported and adapted from Prowl.Vector.

    @see https://github.com/ProwlEngine/Prowl.Vector/blob/main/Vector/Vectors/Int2.cs
**/
@:build(vector.IntSwizzles.buildSwizzles2())
@:forward(x, y)
abstract Int2(Int2Class) from Int2Class to Int2Class {
    public static final Zero :Int2 = new Int2(0, 0);
    public static final One  :Int2 = new Int2(1, 1);
    public static final UnitX:Int2 = new Int2(1, 0);
    public static final UnitY:Int2 = new Int2(0, 1);


    // Getter for array access (one argument)
    @:op([])
    public inline function get(index:Int):Int {
        return switch(index) {
            case 0: this.x;
            case 1: this.y;
            default: throw "Index out of bounds: " + index;
        };
    }

    // Setter for array access (two arguments: index and value)
    @:op([])
    public inline function set(index:Int, value:Int):Int {
        switch(index) {
            case 0: this.x = value;
            case 1: this.y = value;
            default: throw "Index out of bounds: " + index;
        }
        return value;
    }

    public inline function new(x:Int, y:Int) {
        this = new Int2Class(x, y);
    }

    // multiple constructors
    @:op(a()) inline function callNoArgs(): Int2 {
        return new Int2(0, 0);
    }

    // multiple constructors
    @:op(a()) inline function callOneArg(scalar: Int): Int2 {
        return new Int2(scalar, scalar);
    }


    // vector to vector
    @:op(-A) public static function    neg(v:Int2          ): Int2 { return new Int2(-v.x, -v.y); }
    @:op(A + B) public static function add(a:Int2, b:Int2): Int2 { return new Int2(a.x + b.x, a.y + b.y); }
    @:op(A - B) public static function sub(a:Int2, b:Int2): Int2 { return new Int2(a.x - b.x, a.y - b.y); }
    @:op(A * B) public static function mul(a:Int2, b:Int2): Int2 { return new Int2(a.x * b.x, a.y * b.y); }
    // @:op(A / B) public static function div(a:Int2, b:Int2): Int2 { return new Int2(a.x / b.x, a.y / b.y); }
    @:op(A % B) public static function rem(a:Int2, b:Int2): Int2 { return new Int2(a.x % b.x, a.y % b.y); };


    // bitwise operators
    @:op(~A) public static inline function not (v: Int2):Int2 { return new Int2(~v.x, ~v.y); }
    @:op(A & B) public static inline function  and (a: Int2, b: Int2):Int2 { return new Int2(a.x &  b.x, a.y &  b.y); }
    @:op(A | B) public static inline function  or  (a: Int2, b: Int2):Int2 { return new Int2(a.x |  b.x, a.y |  b.y); }
    @:op(A ^ B) public static inline function  zor (a: Int2, b: Int2):Int2 { return new Int2(a.x ^  b.x, a.y ^  b.y); }
    @:op(A << B) public static inline function shl (a: Int2, b: Int ):Int2 { return new Int2(a.x << b  , a.y << b  ); }
    @:op(A >> B) public static inline function shr (a: Int2, b: Int ):Int2 { return new Int2(a.x >> b  , a.y >> b  ); }

    // vector to scalar
    @:op(A + B) public static function add_scalar(v: Int2, scalar: Int): Int2 { return new Int2(v.x + scalar, v.y + scalar); }
    @:op(A - B) public static function sub_scalar(v: Int2, scalar: Int): Int2 { return new Int2(v.x - scalar, v.y - scalar); }
    @:op(A * B) public static function mul_scalar(v: Int2, scalar: Int): Int2 { return new Int2(v.x * scalar, v.y * scalar); }
    // @:op(A / B) public static function div_scalar(v: Int2, scalar: Int): Int2 { return new Int2(v.x / scalar, v.y / scalar); }
    @:op(A % B) public static function rem_scalar(v: Int2, scalar: Int): Int2 { return new Int2(v.x % scalar, v.y % scalar); }

    // scalar to vector
    @:op(A + B) public static function scalar_add(scalar: Int, v: Int2): Int2 { return new Int2(scalar + v.x, scalar + v.y); }
    @:op(A - B) public static function scalar_sub(scalar: Int, v: Int2): Int2 { return new Int2(scalar - v.x, scalar - v.y); }
    @:op(A * B) public static function scalar_mul(scalar: Int, v: Int2): Int2 { return new Int2(scalar * v.x, scalar * v.y); }
    // @:op(A / B) public static function scalar_div(scalar: Int, v: Int2): Int2 { return new Int2(scalar / v.x, scalar / v.y); }
    @:op(A % B) public static function scalar_rem(scalar: Int, v: Int2): Int2 { return new Int2(scalar % v.x, scalar % v.y); }

    // Equality operators
    @:op(A == B) public static inline function eq(left:Int2, right:Int2):Bool { return left.equals(right); }
    @:op(A != B) public static inline function neq(left:Int2, right:Int2):Bool { return !left.equals(right); }
    public inline function equals(other: Int2): Bool {
        return this.x == other.x && this.y == other.y;
    }

    /** Returns the vector as an array [x, y] **/
    public inline function toArray():Array<Int> {
        return [this.x, this.y];
    }

    /** Returns a string representation of the vector in the format "(x, y)" **/
    public inline function toString():String {
        return '(${this.x}, ${this.y})';
    }

    /**Returns the dot product of two Int2 vectors.**/
    public static inline function dot(a: Int2, b: Int2): Int {
        return a.x * b.x + a.y * b.y;
    }
}