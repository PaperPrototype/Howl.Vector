package vector;

class Float3Class {
    public var x:Float;
    public var y:Float;
    public var z:Float;

    public function new(x:Float, y:Float, z:Float) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}

/**
	A Float3 vector class with operator overloading based on Prowl.Vector.

    Ported and adapted from Prowl.Vector with help from Heaps' h3d.Vector:

    @see https://github.com/ProwlEngine/Prowl.Vector/blob/main/Vector/Vectors/Float3.cs
    @see https://github.com/HeapsIO/heaps/blob/master/h3d/Vector.hx
**/
@:build(vector.FloatSwizzles.buildSwizzles3())
@:forward(x, y, z)
abstract Float3(Float3Class) from Float3Class to Float3Class {
    public static final Zero :Float3 = new Float3(0, 0, 0);
    public static final One  :Float3 = new Float3(1, 1, 1);
    public static final UnitX:Float3 = new Float3(1, 0, 0);
    public static final UnitY:Float3 = new Float3(0, 1, 0);
    public static final UnitZ:Float3 = new Float3(0, 0, 1);

    // Getter for array access (one argument)
    @:op([])
    public inline function get(index:Int):Float {
        return switch(index) {
            case 0: this.x;
            case 1: this.y;
            case 2: this.z;
            default: throw "Index out of bounds: " + index;
        };
    }

    // Setter for array access (two arguments: index and value)
    @:op([])
    public inline function set(index:Int, value:Float):Float {
        switch(index) {
            case 0: this.x = value;
            case 1: this.y = value;
            case 2: this.z = value;
            default: throw "Index out of bounds: " + index;
        }
        return value;
    }

    /// CONSTRUCTORS ///
    public inline function new(x:Float, y:Float, z:Float) {
        this = new Float3Class(x, y, z);
    }
    // @:op(a()) inline function callNoArgs(): Float3 {
    //     return new Float3(0, 0, 0);
    // }
    // @:op(a()) inline function callOneArg(scalar: Float): Float3 {
    //     return new Float3(scalar, scalar, scalar);
    // }

    /// OPERATOR OVERLOADING ///

    // vector to vector
    @:op(-A) public static function    neg(v:Float3          ): Float3 { return new Float3(-v.x, -v.y, -v.z); }
    @:op(A + B) public static function add(a:Float3, b:Float3): Float3 { return new Float3(a.x + b.x, a.y + b.y, a.z + b.z); }
    @:op(A - B) public static function sub(a:Float3, b:Float3): Float3 { return new Float3(a.x - b.x, a.y - b.y, a.z - b.z); }
    @:op(A * B) public static function mul(a:Float3, b:Float3): Float3 { return new Float3(a.x * b.x, a.y * b.y, a.y * b.y); }
    @:op(A / B) public static function div(a:Float3, b:Float3): Float3 { return new Float3(a.x / b.x, a.y / b.y, a.y / b.y); }
    @:op(A % B) public static function rem(a:Float3, b:Float3): Float3 { return new Float3(a.x % b.x, a.y % b.y, a.y % b.y); };

    // vector to scalar
    @:op(A + B) public static function add_scalar(v: Float3, scalar: Float): Float3 { return new Float3(v.x + scalar, v.y + scalar, v.z + scalar); }
    @:op(A - B) public static function sub_scalar(v: Float3, scalar: Float): Float3 { return new Float3(v.x - scalar, v.y - scalar, v.z - scalar); }
    @:op(A * B) public static function mul_scalar(v: Float3, scalar: Float): Float3 { return new Float3(v.x * scalar, v.y * scalar, v.z * scalar); }
    @:op(A / B) public static function div_scalar(v: Float3, scalar: Float): Float3 { return new Float3(v.x / scalar, v.y / scalar, v.z / scalar); }
    @:op(A % B) public static function rem_scalar(v: Float3, scalar: Float): Float3 { return new Float3(v.x % scalar, v.y % scalar, v.z % scalar); }

    // scalar to vector
    @:op(A + B) public static function scalar_add(scalar: Float, v: Float3): Float3 { return new Float3(scalar + v.x, scalar + v.y, scalar + v.z); }
    @:op(A - B) public static function scalar_sub(scalar: Float, v: Float3): Float3 { return new Float3(scalar - v.x, scalar - v.y, scalar - v.z); }
    @:op(A * B) public static function scalar_mul(scalar: Float, v: Float3): Float3 { return new Float3(scalar * v.x, scalar * v.y, scalar * v.z); }
    @:op(A / B) public static function scalar_div(scalar: Float, v: Float3): Float3 { return new Float3(scalar / v.x, scalar / v.y, scalar / v.z); }
    @:op(A % B) public static function scalar_rem(scalar: Float, v: Float3): Float3 { return new Float3(scalar % v.x, scalar % v.y, scalar % v.z); }

    // Equality operators
    @:op(A == B) public static inline function eq(left:Float3, right:Float3):Bool { return left.equals(right); }
    @:op(A != B) public static inline function neq(left:Float3, right:Float3):Bool { return !left.equals(right); }
    public inline function equals(other: Float3): Bool {
        return this.x == other.x && this.y == other.y && this.z == other.z;
    }

    /**Hashcode for dictionaries and sets**/
    public function getHashCode(): Int {
        // Convert floats to their integer bit representations
        var xBits = haxe.io.FPHelper.floatToI32(this.x);
        var yBits = haxe.io.FPHelper.floatToI32(this.y);
        var zBits = haxe.io.FPHelper.floatToI32(this.z);
        
        // Combine the hash codes
        return xBits ^ (yBits << 2) ^ (zBits >> 2);
    }

    /** Returns the vector as an array [x, y] **/
    public inline function toArray():Array<Float> {
        return [this.x, this.y, this.z];
    }

    /** Returns a string representation of the vector in the format "(x, y)" **/
    public inline function toString():String {
        return '(${this.x}, ${this.y}, ${this.z})';
    }

    /// MATHS OPERATIONS ///
    
    /**Returns the componentwise clamp of a Float3 vector.**/
    public static inline function clamp(v: Float3, min: Float, max: Float): Float3
    {
        return new Float3(
            Maths.clamp(v.x, min, max),
            Maths.clamp(v.y, min, max),
            Maths.clamp(v.z, min, max)
        );
    }

    /**Clamps each component of a vector between 0 and 1.**/
    public static inline function saturate(v: Float3): Float3 {
        return new Float3(Maths.saturate(v.x), Maths.saturate(v.y), Maths.saturate(v.z));
    }

    public static inline function lerp(a: Float3, b: Float3, t: Float): Float3 {
        return new Float3(Maths.lerp(a.x, b.x, Maths.saturate(t)), Maths.lerp(a.y, b.y, Maths.saturate(t)), Maths.lerp(a.z, b.z, Maths.saturate(t)));
    }

    /// Float3 OPERATIONS ///

    /** Returns a normalized version of the given vector. **/
    public static inline function normalize(v: Float3): Float3
    {
        var length: Float = length(v);
        if (length > Maths.EPSILON) {
            return v / length;
        }
        return Zero;
    }

    /** Returns the magnitude (length) of the given vector. **/
    public static inline function length(v: Float3): Float {
        return Math.sqrt(lengthSquared(v));
    }

    /** Returns the magnitude (length) of the given vector. **/
    public static inline function lengthSquared(v: Float3): Float {
        return v.x * v.x + v.y * v.y + v.z * v.z;
    }

    /** Returns the angle in radians between two vectors. **/
    public static inline function angleBetween(a: Float3, b: Float3): Float
    {
        var dot = dot(normalize(a), normalize(b));
        return Math.acos(Maths.clamp(dot, -1.0, 1.0));
    }

    /**Returns the cross product of two Float3 vectors.**/
    public static function cross(a: Float3, b: Float3): Float3 {
        return new Float3(
            a.y * b.z - a.z * b.y,
            a.z * b.x - a.x * b.z,
            a.x * b.y - a.y * b.x
        );
    }

    /** Returns the distance between two Float3 points. **/
    public static inline function distance(x: Float3, y: Float3): Float {
        return length(x - y);
    }

    /** Returns the distance between two Float3 points. **/
    public static inline function distanceSquared(x: Float3, y: Float3): Float {
        return lengthSquared(x - y);
    }

    /** Returns the dot product of two Float3 vectors. **/
    public static inline function dot(a: Float3, b: Float3): Float {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }

    /** Checks if two vectors are parallel within a tolerance. **/
    public static inline function isParrallel(a: Float3, b: Float3, tolerance: Float = 1e-6): Bool {
        var normalizedDot = Math.abs(dot(normalize(a), normalize(b)));
        return normalizedDot >= (1.0 - tolerance);
    }


    /** Checks if two vectors are perpendicular within a tolerance. **/
    public static inline function isPerpendicular(a: Float3, b: Float3, tolerance: Float = 1e-6): Bool
    {
        var dot = Math.abs(dot(a, b));
        return dot <= tolerance;
    }

    /**Orthonormalizes a set of three vectors using Gram-Schmidt process.**/
    public static inline function orthoNormalize3Way(normal: Float3, tangent: Float3, binormal: Float3) {
        normal = normalize(normal);
        tangent = normalize(tangent - project(tangent, normal));
        binormal = cross(normal, tangent);
    }


    /**Orthonormalizes two vectors using Gram-Schmidt process.**/
    public static inline function orthoNormalize2Way(normal: Float3, tangent: Float3)
    {
        normal = normalize(normal);
        tangent = normalize(tangent - project(tangent, normal));
    }

    /** Projects vector a onto vector b. **/
    public static inline function project(a: Float3, b: Float3): Float3
    {
        var denominator = dot(b, b);
        if (denominator <= Maths.EPSILON)
            return Float3.Zero;
        return b * (dot(a, b) / denominator);
    }

    /** Projects a vector onto a plane defined by a normal vector. **/
    public static inline function projectOntoPlane(vector: Float3, planeNormal: Float3):Float3 {
        return vector - project(vector, planeNormal);
    }

    /** Reflects a vector off a normal. **/
    public static inline function reflect(vector: Float3, normal: Float3): Float3
    {
        var dot = dot(vector, normal);
        return vector - 2 * dot * normal;
    }


    /**Calculates the refraction direction for an incident vector and surface normal.**/
    public static inline function refract( incident: Float3,  normal: Float3,  eta: Float): Float3
    {
        var dotNI: Float = dot(normal, incident);
        var k: Float = 1.0 - eta * eta * (1.0 - dotNI * dotNI);
        return k < 0.0 ? Zero : eta * incident - (eta * dotNI + Math.sqrt(k)) * normal;
    }

    /**Returns the signed angle in radians between two 2D vectors. **/
    public static inline function signedAngleBetween( a: Float3,  b: Float3, axis: Float3): Float {
        var angle: Float = angleBetween(a, b);
        var cross: Float3 = cross(a, b);
        var sign: Float = dot(cross, axis) < 0.0 ? -1.0 : 1.0;
        return angle * sign;    
    }

    /**Spherically interpolates between two vectors.**/
    public static inline function slerp(a: Float3, b: Float3, t: Float): Float3
    {
        t = Maths.saturate(t);
        return slerpUnclamped(a, b, t);
    }

    public static inline function slerpUnclamped(a: Float3, b: Float3, t: Float): Float3
    {
        var result = Float3.Zero;

        // Normalize the vectors
        var normalizedA: Float3 = normalize(a);
        var normalizedB: Float3 = normalize(b);

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
    public static inline function moveTowards(current: Float3, target: Float3, maxDistanceDelta: Float): Float3
    {
        var toVector: Float3 = target - current;
        var distance: Float = length(toVector);
        if (distance <= maxDistanceDelta || distance < Maths.EPSILON)
            return target;
        return current + toVector / distance * maxDistanceDelta;
    }
}