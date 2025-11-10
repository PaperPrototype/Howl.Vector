package vector;

class Int4Class {
    public var x:Int;
    public var y:Int;
    public var z:Int;
    public var w:Int;

    public function new(x:Int, y:Int, z:Int, w:Int) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }
}


/**
	An Int4 vector class with operator overloading based on Prowl.Vector.

    Ported and adapted from Prowl.Vector.

    @see https://github.com/ProwlEngine/Prowl.Vector/blob/main/Vector/Vectors/Int4.cs
**/
@:build(vector.IntSwizzles.buildSwizzles4())
@:forward(x, y, z, w)
abstract Int4(Int4Class) from Int4Class to Int4Class {
    public static final Zero :Int4 = new Int4(0, 0, 0, 0);
    public static final One  :Int4 = new Int4(1, 1, 1, 1);
    public static final UnitX:Int4 = new Int4(1, 0, 0, 0);
    public static final UnitY:Int4 = new Int4(0, 1, 0, 0);
    public static final UnitZ:Int4 = new Int4(0, 0, 1, 0);
    public static final UnitW:Int4 = new Int4(0, 0, 0, 1);


    // Getter for array access (one argument)
    @:op([])
    public inline function get(index:Int):Int {
        return switch(index) {
            case 0: this.x;
            case 1: this.y;
            case 2: this.z;
            case 3: this.w;
            default: throw "Index out of bounds: " + index;
        };
    }

    // Setter for array access (two arguments: index and value)
    @:op([])
    public inline function set(index:Int, value:Int):Int {
        switch(index) {
            case 0: this.x = value;
            case 1: this.y = value;
            case 2: this.z = value;
            case 3: this.w = value;
            default: throw "Index out of bounds: " + index;
        }
        return value;
    }

    public inline function new(x:Int, y:Int, z:Int, w:Int) {
        this = new Int4Class(x, y, z, w);
    }

    // multiple constructors
    @:op(a()) inline function callNoArgs(): Int4 {
        return new Int4(0, 0, 0, 0);
    }

    // multiple constructors
    @:op(a()) inline function callOneArg(scalar: Int): Int4 {
        return new Int4(scalar, scalar, scalar, scalar);
    }

    // vector to vector
    @:op(-A) public static function    neg(v:Int4): Int4 { return new Int4(-v.x, -v.y, -v.z, -v.w); }
    @:op(A + B) public static function add(a:Int4, b:Int4): Int4 { return new Int4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w); }
    @:op(A - B) public static function sub(a:Int4, b:Int4): Int4 { return new Int4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w); }
    @:op(A * B) public static function mul(a:Int4, b:Int4): Int4 { return new Int4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w); }
    // @:op(A / B) public static function div(a:Int4, b:Int4): Int4 { return new Int4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w); }
    @:op(A % B) public static function rem(a:Int4, b:Int4): Int4 { return new Int4(a.x % b.x, a.y % b.y, a.z % b.z, a.w % b.w); };


    // bitwise operators
    @:op(~A) public static inline function not (v: Int4):Int4 { return new Int4(~v.x, ~v.y, ~v.z, ~v.w); }
    @:op(A & B) public static inline function  and (a: Int4, b: Int4):Int4 { return new Int4(a.x &  b.x, a.y &  b.y, a.z &  b.z, a.w &  b.w); }
    @:op(A | B) public static inline function  or  (a: Int4, b: Int4):Int4 { return new Int4(a.x |  b.x, a.y |  b.y, a.z |  b.z, a.w |  b.w); }
    @:op(A ^ B) public static inline function  zor (a: Int4, b: Int4):Int4 { return new Int4(a.x ^  b.x, a.y ^  b.y, a.z ^  b.z, a.w ^  b.w ); }
    @:op(A << B) public static inline function shl (a: Int4, b: Int ):Int4 { return new Int4(a.x << b  , a.y << b  , a.z << b  , a.w << b  ); }
    @:op(A >> B) public static inline function shr (a: Int4, b: Int ):Int4 { return new Int4(a.x >> b  , a.y >> b  , a.z >> b  , a.w >> b  ); }

    // vector to scalar
    @:op(A + B) public static function add_scalar(v: Int4, scalar: Int): Int4 { return new Int4(v.x + scalar, v.y + scalar, v.z + scalar, v.w + scalar); }
    @:op(A - B) public static function sub_scalar(v: Int4, scalar: Int): Int4 { return new Int4(v.x - scalar, v.y - scalar, v.z - scalar, v.w - scalar); }
    @:op(A * B) public static function mul_scalar(v: Int4, scalar: Int): Int4 { return new Int4(v.x * scalar, v.y * scalar, v.z * scalar, v.w * scalar); }
    // @:op(A / B) public static function div_scalar(v: Int4, scalar: Int): Int4 { return new Int4(v.x / scalar, v.y / scalar, v.z / scalar, v.w / scalar); }
    @:op(A % B) public static function rem_scalar(v: Int4, scalar: Int): Int4 { return new Int4(v.x % scalar, v.y % scalar, v.z % scalar, v.w % scalar); }

    // scalar to vector
    @:op(A + B) public static function scalar_add(scalar: Int, v: Int4): Int4 { return new Int4(scalar + v.x, scalar + v.y, scalar + v.z, scalar + v.w); }
    @:op(A - B) public static function scalar_sub(scalar: Int, v: Int4): Int4 { return new Int4(scalar - v.x, scalar - v.y, scalar - v.z, scalar - v.w); }
    @:op(A * B) public static function scalar_mul(scalar: Int, v: Int4): Int4 { return new Int4(scalar * v.x, scalar * v.y, scalar * v.z, scalar * v.w); }
    // @:op(A / B) public static function scalar_div(scalar: Int, v: Int4): Int4 { return new Int4(scalar / v.x, scalar / v.y, scalar / v.z, scalar / v.w); }
    @:op(A % B) public static function scalar_rem(scalar: Int, v: Int4): Int4 { return new Int4(scalar % v.x, scalar % v.y, scalar % v.z, scalar % v.w); }

    // Equality operators
    @:op(A == B) public static inline function eq(left:Int4, right:Int4):Bool { return left.equals(right); }
    @:op(A != B) public static inline function neq(left:Int4, right:Int4):Bool { return !left.equals(right); }
    public inline function equals(other: Int4): Bool {
        return this.x == other.x && this.y == other.y && this.z == other.z && this.w == other.w;
    }

    /** Returns the vector as an array [x, y] **/
    public inline function toArray():Array<Int> {
        return [this.x, this.y, this.z, this.w];
    }

    /** Returns a string representation of the vector in the format "(x, y)" **/
    public inline function toString():String {
        return '(${this.x}, ${this.y}, ${this.z}), ${this.w})';
    }

    /**Returns the dot product of two Int4 vectors.**/
    public static inline function dot(a: Int4, b: Int4): Int {
        return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
    }
}