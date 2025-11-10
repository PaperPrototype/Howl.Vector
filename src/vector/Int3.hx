package vector;

class Int3Class {
    public var x:Int;
    public var y:Int;
    public var z:Int;

    public function new(x:Int, y:Int, z:Int) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}


/**
	An Int3 vector class with operator overloading based on Prowl.Vector.

    Ported and adapted from Prowl.Vector.

    @see https://github.com/ProwlEngine/Prowl.Vector/blob/main/Vector/Vectors/Int3.cs
**/
@:build(vector.IntSwizzles.buildSwizzles3())
@:forward(x, y, z)
abstract Int3(Int3Class) from Int3Class to Int3Class {
    public static final Zero :Int3 = new Int3(0, 0, 0);
    public static final One  :Int3 = new Int3(1, 1, 1);
    public static final UnitX:Int3 = new Int3(1, 0, 0);
    public static final UnitY:Int3 = new Int3(0, 1, 0);
    public static final UnitZ:Int3 = new Int3(0, 0, 1);


    // Getter for array access (one argument)
    @:op([])
    public inline function get(index:Int):Int {
        return switch(index) {
            case 0: this.x;
            case 1: this.y;
            case 2: this.z;
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
            default: throw "Index out of bounds: " + index;
        }
        return value;
    }

    public inline function new(x:Int, y:Int, z:Int) {
        this = new Int3Class(x, y, z);
    }

    // multiple constructors
    @:op(a()) inline function callNoArgs(): Int3 {
        return new Int3(0, 0, 0);
    }

    // multiple constructors
    @:op(a()) inline function callOneArg(scalar: Int): Int3 {
        return new Int3(scalar, scalar, scalar);
    }

    // vector to vector
    @:op(-A) public static function    neg(v:Int3): Int3 { return new Int3(-v.x, -v.y, -v.z); }
    @:op(A + B) public static function add(a:Int3, b:Int3): Int3 { return new Int3(a.x + b.x, a.y + b.y, a.z + b.z); }
    @:op(A - B) public static function sub(a:Int3, b:Int3): Int3 { return new Int3(a.x - b.x, a.y - b.y, a.z - b.z); }
    @:op(A * B) public static function mul(a:Int3, b:Int3): Int3 { return new Int3(a.x * b.x, a.y * b.y, a.z * b.z); }
    // @:op(A / B) public static function div(a:Int3, b:Int3): Int3 { return new Int3(a.x / b.x, a.y / b.y, a.z / b.z); }
    @:op(A % B) public static function rem(a:Int3, b:Int3): Int3 { return new Int3(a.x % b.x, a.y % b.y, a.z % b.z); };


    // bitwise operators
    @:op(~A) public static inline function not (v: Int3):Int3 { return new Int3(~v.x, ~v.y, ~v.z); }
    @:op(A & B) public static inline function  and (a: Int3, b: Int3):Int3 { return new Int3(a.x &  b.x, a.y &  b.y, a.z &  b.z); }
    @:op(A | B) public static inline function  or  (a: Int3, b: Int3):Int3 { return new Int3(a.x |  b.x, a.y |  b.y, a.z |  b.z); }
    @:op(A ^ B) public static inline function  zor (a: Int3, b: Int3):Int3 { return new Int3(a.x ^  b.x, a.y ^  b.y, a.z ^  b.z); }
    @:op(A << B) public static inline function shl (a: Int3, b: Int ):Int3 { return new Int3(a.x << b  , a.y << b  , a.z << b  ); }
    @:op(A >> B) public static inline function shr (a: Int3, b: Int ):Int3 { return new Int3(a.x >> b  , a.y >> b  , a.z >> b  ); }

    // vector to scalar
    @:op(A + B) public static function add_scalar(v: Int3, scalar: Int): Int3 { return new Int3(v.x + scalar, v.y + scalar, v.z + scalar); }
    @:op(A - B) public static function sub_scalar(v: Int3, scalar: Int): Int3 { return new Int3(v.x - scalar, v.y - scalar, v.z - scalar); }
    @:op(A * B) public static function mul_scalar(v: Int3, scalar: Int): Int3 { return new Int3(v.x * scalar, v.y * scalar, v.z * scalar); }
    // @:op(A / B) public static function div_scalar(v: Int3, scalar: Int): Int3 { return new Int3(v.x / scalar, v.y / scalar, v.z / scalar); }
    @:op(A % B) public static function rem_scalar(v: Int3, scalar: Int): Int3 { return new Int3(v.x % scalar, v.y % scalar, v.z % scalar); }

    // scalar to vector
    @:op(A + B) public static function scalar_add(scalar: Int, v: Int3): Int3 { return new Int3(scalar + v.x, scalar + v.y, scalar + v.z); }
    @:op(A - B) public static function scalar_sub(scalar: Int, v: Int3): Int3 { return new Int3(scalar - v.x, scalar - v.y, scalar - v.z); }
    @:op(A * B) public static function scalar_mul(scalar: Int, v: Int3): Int3 { return new Int3(scalar * v.x, scalar * v.y, scalar * v.z); }
    // @:op(A / B) public static function scalar_div(scalar: Int, v: Int3): Int3 { return new Int3(scalar / v.x, scalar / v.y, scalar / v.z); }
    @:op(A % B) public static function scalar_rem(scalar: Int, v: Int3): Int3 { return new Int3(scalar % v.x, scalar % v.y, scalar % v.z); }

    // Equality operators
    @:op(A == B) public static inline function eq(left:Int3, right:Int3):Bool { return left.equals(right); }
    @:op(A != B) public static inline function neq(left:Int3, right:Int3):Bool { return !left.equals(right); }
    public inline function equals(other: Int3): Bool {
        return this.x == other.x && this.y == other.y && this.z == other.z;
    }

    /** Returns the vector as an array [x, y] **/
    public inline function toArray():Array<Int> {
        return [this.x, this.y, this.z];
    }

    /** Returns a string representation of the vector in the format "(x, y)" **/
    public inline function toString():String {
        return '(${this.x}, ${this.y}, ${this.z})';
    }

    /**Returns the dot product of two Int3 vectors.**/
    public static inline function dot(a: Int3, b: Int3): Int {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }
}