package vector;

class Float2Class {
    public var x:Float;
    public var y:Float;

    public function new(x:Float, y:Float) {
        this.x = x;
        this.y = y;
    }
}

/**
	A Float2 vector class with operator overloading based on Prowl.Vector.

    Ported and adapted from Prowl.Vector with help from Heaps' h3d.Vector:

    @see https://github.com/ProwlEngine/Prowl.Vector/blob/main/Vector/Vectors/Float2.cs
    @see https://github.com/HeapsIO/heaps/blob/master/h3d/Vector.hx
**/
@:build(vector.SwizzleMacro.buildSwizzles2())
@:forward(x, y)
abstract Float2(Float2Class) from Float2Class to Float2Class {
    public static final Zero:Float2 = new Float2(0, 0);
    public static final One:Float2 = new Float2(1, 1);
    public static final UnitX:Float2 = new Float2(1, 0);
    public static final UnitY:Float2 = new Float2(0, 1);

    // Getter for array access (one argument)
    @:op([])
    public inline function get(index:Int):Float {
        return switch(index) {
            case 0: this.x;
            case 1: this.y;
            default: throw "Index out of bounds: " + index;
        };
    }

    // Setter for array access (two arguments: index and value)
    @:op([])
    public inline function set(index:Int, value:Float):Float {
        switch(index) {
            case 0: this.x = value;
            case 1: this.y = value;
            default: throw "Index out of bounds: " + index;
        }
        return value;
    }

    public inline function new(x:Float, y:Float) {
        this = new Float2Class(x, y);
    }

    // multiple constructors
    @:op(a()) inline function callNoArgs(): Float2 {
        return new Float2(0, 0);
    }

    // multiple constructors
    @:op(a()) inline function callOneArg(scalar: Float): Float2 {
        return new Float2(scalar, scalar);
    }

    // vector to vector
    @:op(-A) public static function    neg(v:Float2          ): Float2 { return new Float2(-v.x, -v.y); }
    @:op(A + B) public static function add(a:Float2, b:Float2): Float2 { return new Float2(a.x + b.x, a.y + b.y); }
    @:op(A - B) public static function sub(a:Float2, b:Float2): Float2 { return new Float2(a.x - b.x, a.y - b.y); }
    @:op(A * B) public static function mul(a:Float2, b:Float2): Float2 { return new Float2(a.x * b.x, a.y * b.y); }
    @:op(A / B) public static function div(a:Float2, b:Float2): Float2 { return new Float2(a.x / b.x, a.y / b.y); }
    @:op(A % B) public static function rem(a:Float2, b:Float2): Float2 { return new Float2(a.x % b.x, a.y % b.y); };

    // vector to scalar
    @:op(A + B) public static function add_scalar(v: Float2, scalar: Float): Float2 { return new Float2(v.x + scalar, v.y + scalar); }
    @:op(A - B) public static function sub_scalar(v: Float2, scalar: Float): Float2 { return new Float2(v.x - scalar, v.y - scalar); }
    @:op(A * B) public static function mul_scalar(v: Float2, scalar: Float): Float2 { return new Float2(v.x * scalar, v.y * scalar); }
    @:op(A / B) public static function div_scalar(v: Float2, scalar: Float): Float2 { return new Float2(v.x / scalar, v.y / scalar); }
    @:op(A % B) public static function rem_scalar(v: Float2, scalar: Float): Float2 { return new Float2(v.x % scalar, v.y % scalar); }

    // scalar to vector
    @:op(A + B) public static function scalar_add(scalar: Float, v: Float2): Float2 { return new Float2(scalar + v.x, scalar + v.y); }
    @:op(A - B) public static function scalar_sub(scalar: Float, v: Float2): Float2 { return new Float2(scalar - v.x, scalar - v.y); }
    @:op(A * B) public static function scalar_mul(scalar: Float, v: Float2): Float2 { return new Float2(scalar * v.x, scalar * v.y); }
    @:op(A / B) public static function scalar_div(scalar: Float, v: Float2): Float2 { return new Float2(scalar / v.x, scalar / v.y); }
    @:op(A % B) public static function scalar_rem(scalar: Float, v: Float2): Float2 { return new Float2(scalar % v.x, scalar % v.y); }

    // Equality operators
    @:op(A == B) public static inline function eq(left:Float2, right:Float2):Bool { return left.equals(right); }
    @:op(A != B) public static inline function neq(left:Float2, right:Float2):Bool { return !left.equals(right); }
    public inline function equals(other: Float2): Bool {
        return this.x == other.x && this.y == other.y;
    }

    /** Returns the vector as an array [x, y] **/
    public inline function toArray():Array<Float> {
        return [this.x, this.y];
    }

    /** Returns a string representation of the vector in the format "(x, y)" **/
    public inline function toString():String {
        return '(${this.x}, ${this.y})';
    }

    /// MATHS OPERATIONS ///
    
    /**Returns the componentwise clamp of a Float2 vector.**/
    public static inline function clamp(v: Float2, min: Float, max: Float): Float2
    {
        return new Float2(
            Maths.clamp(v.x, min, max),
            Maths.clamp(v.y, min, max)
        );
    }

    /**Clamps each component of a vector between 0 and 1.**/
    public static inline function saturate(v: Float2): Float2 {
        return new Float2(Maths.saturate(v.x), Maths.saturate(v.y));
    }

    public static inline function lerp(a: Float2, b: Float2, t: Float): Float2 {
        return new Float2(Maths.lerp(a.x, b.x, Maths.saturate(t)), Maths.lerp(a.y, b.y, Maths.saturate(t)));
    }

    /// FLOAT2 OPERATIONS ///

    /** Returns a normalized version of the given vector. **/
    public static inline function normalize(v: Float2): Float2
    {
        var length: Float = length(v);
        if (length > Maths.Epsilon) {
            return v / length;
        }
        return Zero;
    }

    /** Returns the magnitude (length) of the given vector. **/
    public static inline function length(v: Float2): Float {
        return Math.sqrt(lengthSquared(v));
    }

    /** Returns the magnitude (length) of the given vector. **/
    public static inline function lengthSquared(v: Float2): Float {
        return v.x * v.x + v.y * v.y;
    }


    /** Returns the angle in radians between two vectors. **/
    public static inline function angleBetween(a: Float2, b: Float2): Float
    {
        var dot = dot(normalize(a), normalize(b));
        return Math.acos(Maths.clamp(dot, -1.0, 1.0));
    }

    /** Returns the distance between two Float2 points. **/
    public static inline function distance(x: Float2, y: Float2): Float {
        return length(x - y);
    }

    /** Returns the distance between two Float2 points. **/
    public static inline function distanceSquared(x: Float2, y: Float2): Float {
        return lengthSquared(x - y);
    }

    /** Returns the dot product of two Float2 vectors. **/
    public static inline function dot(a: Float2, b: Float2): Float {
        return a.x * b.x + a.y * b.y;
    }

    /** Checks if two vectors are parallel within a tolerance. **/
    public static inline function isParrallel(a: Float2, b: Float2, tolerance: Float = 1e-6): Bool {
        var normalizedDot = Math.abs(dot(normalize(a), normalize(b)));
        return normalizedDot >= (1.0 - tolerance);
    }


    /** Checks if two vectors are perpendicular within a tolerance. **/
    public static inline function isPerpendicular(a: Float2, b: Float2, tolerance: Float = 1e-6): Bool
    {
        var dot = Math.abs(dot(a, b));
        return dot <= tolerance;
    }

    /** Projects vector a onto vector b. **/
    public static inline function project(a: Float2, b: Float2): Float2
    {
        var denominator = dot(b, b);
        if (denominator <= Maths.Epsilon)
            return Float2.Zero;
        return b * (dot(a, b) / denominator);
    }

    /** Projects a vector onto a plane defined by a normal vector. **/
    public static inline function projectOntoPlane(vector: Float2, planeNormal: Float2):Float2 {
        return vector - project(vector, planeNormal);
    }

    /** Reflects a vector off a normal. **/
    public static inline function reflect(vector: Float2, normal: Float2): Float2
    {
        var dot = dot(vector, normal);
        return vector - 2 * dot * normal;
    }


    /**Calculates the refraction direction for an incident vector and surface normal.**/
    public static inline function refract( incident: Float2,  normal: Float2,  eta: Float): Float2
    {
        var dotNI: Float = dot(normal, incident);
        var k: Float = 1.0 - eta * eta * (1.0 - dotNI * dotNI);
        return k < 0.0 ? Zero : eta * incident - (eta * dotNI + Math.sqrt(k)) * normal;
    }

    /**Returns the signed angle in radians between two 2D vectors. **/
    public static inline function signedAngleBetween( a: Float2,  b: Float2): Float {
        return Math.atan2(a.x * b.y - a.y * b.x, a.x * b.x + a.y * b.y);
    }

    /**Spherically interpolates between two vectors.**/
    public static inline function slerp(a: Float2, b: Float2, t: Float): Float2
    {
        t = Maths.saturate(t);
        return slerpUnclamped(a, b, t);
    }

    public static inline function slerpUnclamped(a: Float2, b: Float2, t: Float): Float2
    {
        var result = Float2.Zero;

        // Normalize the vectors
        var normalizedA: Float2 = normalize(a);
        var normalizedB: Float2 = normalize(b);

        // Calculate the cosine of the angle between them
        var dot: Float = dot(normalizedA, normalizedB);

        // If the dot product is negative, slerp won't take the shorter path.
        // So negate one vector to get the shorter path.
        if (dot < 0.0)
        {
            normalizedB = -normalizedB;
            dot = -dot;
        }

        // If the vectors are close to identical, just use linear interpolation
        if (dot > 1.0 - 1e-6)
        {
            result = normalizedA + t * (normalizedB - normalizedA);
            return normalize(result) * Maths.lerp(length(a), length(b), t);
        }

        // Calculate angle and sin
        var angle: Float = Math.acos(Math.abs(dot));
        var sinAngle: Float = Math.sin(angle);

        // Calculate the scale factors
        var scale1: Float = Math.sin((1.0 - t) * angle) / sinAngle;
        var scale2: Float = Math.sin(t * angle) / sinAngle;

        // Interpolate
        result = scale1 * normalizedA + scale2 * normalizedB;
        return result * Maths.lerp(length(a), length(b), t);
    }


    /**Moves a vector current towards target.**/
    public static inline function moveTowards(current: Float2, target: Float2, maxDistanceDelta: Float): Float2
    {
        var toVector: Float2 = target - current;
        var distance: Float = length(toVector);
        if (distance <= maxDistanceDelta || distance < Maths.Epsilon)
            return target;
        return current + toVector / distance * maxDistanceDelta;
    }
}