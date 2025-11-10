package vector;

class Float4Class {
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var w:Float;

    public function new(x:Float, y:Float, z:Float, w:Float) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }
}

/**
	A Float4 vector class with operator overloading based on Prowl.Vector.

    Ported and adapted from Prowl.Vector with help from Heaps' h3d.Vector:

    @see https://github.com/ProwlEngine/Prowl.Vector/blob/main/Vector/Vectors/Float4.cs
    @see https://github.com/HeapsIO/heaps/blob/master/h3d/Vector.hx
**/
@:build(vector.SwizzleMacro.buildSwizzles4())
@:forward(x, y, z, w)
abstract Float4(Float4Class) from Float4Class to Float4Class {
    public static final Zero:Float4 = new Float4(0, 0, 0, 0);
    public static final One:Float4 = new Float4(1, 1, 1, 1);
    public static final UnitX:Float4 = new Float4(1, 0, 0, 0);
    public static final UnitY:Float4 = new Float4(0, 1, 0, 0);
    public static final UnitZ:Float4 = new Float4(0, 0, 1, 0);
    public static final UnitW:Float4 = new Float4(0, 0, 0, 1);

    // Getter for array access (one argument)
    @:op([])
    public inline function get(index:Int):Float {
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
    public inline function set(index:Int, value:Float):Float {
        switch(index) {
            case 0: this.x = value;
            case 1: this.y = value;
            case 2: this.z = value;
            case 3: this.w = value;
            default: throw "Index out of bounds: " + index;
        }
        return value;
    }

    public inline function new(x:Float, y:Float, z:Float, w:Float) {
        this = new Float4Class(x, y, z, w);
    }

    // multiple constructors
    @:op(a()) inline function callNoArgs(): Float4 {
        return new Float4(0, 0, 0, 0);
    }

    // multiple constructors
    @:op(a()) inline function callOneArg(scalar: Float): Float4 {
        return new Float4(scalar, scalar, scalar, scalar);
    }

    // vector to vector
    @:op(-A) public static function    neg(v:Float4          ): Float4 { return new Float4(-v.x, -v.y, -v.z, -v.w); }
    @:op(A + B) public static function add(a:Float4, b:Float4): Float4 { return new Float4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w); }
    @:op(A - B) public static function sub(a:Float4, b:Float4): Float4 { return new Float4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w); }
    @:op(A * B) public static function mul(a:Float4, b:Float4): Float4 { return new Float4(a.x * b.x, a.y * b.y, a.y * b.y, a.w * b.w); }
    @:op(A / B) public static function div(a:Float4, b:Float4): Float4 { return new Float4(a.x / b.x, a.y / b.y, a.y / b.y, a.w / b.w); }
    @:op(A % B) public static function rem(a:Float4, b:Float4): Float4 { return new Float4(a.x % b.x, a.y % b.y, a.y % b.y, a.w % b.w); };

    // vector to scalar
    @:op(A + B) public static function add_scalar(v: Float4, scalar: Float): Float4 { return new Float4(v.x + scalar, v.y + scalar, v.z + scalar, v.w + scalar); }
    @:op(A - B) public static function sub_scalar(v: Float4, scalar: Float): Float4 { return new Float4(v.x - scalar, v.y - scalar, v.z - scalar, v.w - scalar); }
    @:op(A * B) public static function mul_scalar(v: Float4, scalar: Float): Float4 { return new Float4(v.x * scalar, v.y * scalar, v.z * scalar, v.w * scalar); }
    @:op(A / B) public static function div_scalar(v: Float4, scalar: Float): Float4 { return new Float4(v.x / scalar, v.y / scalar, v.z / scalar, v.w / scalar); }
    @:op(A % B) public static function rem_scalar(v: Float4, scalar: Float): Float4 { return new Float4(v.x % scalar, v.y % scalar, v.z % scalar, v.w % scalar); }

    // scalar to vector
    @:op(A + B) public static function scalar_add(scalar: Float, v: Float4): Float4 { return new Float4(scalar + v.x, scalar + v.y, scalar + v.z, scalar + v.w); }
    @:op(A - B) public static function scalar_sub(scalar: Float, v: Float4): Float4 { return new Float4(scalar - v.x, scalar - v.y, scalar - v.z, scalar - v.w); }
    @:op(A * B) public static function scalar_mul(scalar: Float, v: Float4): Float4 { return new Float4(scalar * v.x, scalar * v.y, scalar * v.z, scalar * v.w); }
    @:op(A / B) public static function scalar_div(scalar: Float, v: Float4): Float4 { return new Float4(scalar / v.x, scalar / v.y, scalar / v.z, scalar / v.w); }
    @:op(A % B) public static function scalar_rem(scalar: Float, v: Float4): Float4 { return new Float4(scalar % v.x, scalar % v.y, scalar % v.z, scalar % v.w); }

    // Equality operators
    @:op(A == B) public static inline function eq(left:Float4, right:Float4):Bool { return left.equals(right); }
    @:op(A != B) public static inline function neq(left:Float4, right:Float4):Bool { return !left.equals(right); }
    public inline function equals(other: Float4): Bool {
        return this.x == other.x && this.y == other.y && this.z == other.z && this.w == other.w;
    }

    /** Returns the vector as an array [x, y] **/
    public inline function toArray():Array<Float> {
        return [this.x, this.y, this.z, this.w];
    }

    /** Returns a string representation of the vector in the format "(x, y)" **/
    public inline function toString():String {
        return '(${this.x}, ${this.y}, ${this.z}, ${this.w})';
    }

    /// MATHS OPERATIONS ///
    
    /**Returns the componentwise clamp of a Float4 vector.**/
    public static inline function clamp(v: Float4, min: Float, max: Float): Float4
    {
        return new Float4(
            Maths.clamp(v.x, min, max),
            Maths.clamp(v.y, min, max),
            Maths.clamp(v.z, min, max),
            Maths.clamp(v.w, min, max)
        );
    }

    /**Clamps each component of a vector between 0 and 1.**/
    public static inline function saturate(v: Float4): Float4 {
        return new Float4(Maths.saturate(v.x), Maths.saturate(v.y), Maths.saturate(v.z), Maths.saturate(v.w));
    }

    public static inline function lerp(a: Float4, b: Float4, t: Float): Float4 {
        return new Float4(Maths.lerp(a.x, b.x, Maths.saturate(t)), Maths.lerp(a.y, b.y, Maths.saturate(t)), Maths.lerp(a.z, b.z, Maths.saturate(t)), Maths.lerp(a.w, b.w, Maths.saturate(t)));
    }

    /// Float4 OPERATIONS ///

    /** Returns a normalized version of the given vector. **/
    public static inline function normalize(v: Float4): Float4
    {
        var length: Float = length(v);
        if (length > Maths.Epsilon) {
            return v / length;
        }
        return Zero;
    }

    /** Returns the magnitude (length) of the given vector. **/
    public static inline function length(v: Float4): Float {
        return Math.sqrt(lengthSquared(v));
    }

    /** Returns the magnitude (length) of the given vector. **/
    public static inline function lengthSquared(v: Float4): Float {
        return v.x * v.x + v.y * v.y + v.z * v.z + v.w * v.w;
    }

    /** Returns the angle in radians between two vectors. **/
    public static inline function angleBetween(a: Float4, b: Float4): Float
    {
        var dot = dot(normalize(a), normalize(b));
        return Math.acos(Maths.clamp(dot, -1.0, 1.0));
    }

    /** Returns the distance between two Float4 points. **/
    public static inline function distance(x: Float4, y: Float4): Float {
        return length(x - y);
    }

    /** Returns the distance between two Float4 points. **/
    public static inline function distanceSquared(x: Float4, y: Float4): Float {
        return lengthSquared(x - y);
    }

    /** Returns the dot product of two Float4 vectors. **/
    public static inline function dot(a: Float4, b: Float4): Float {
        return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
    }

    /** Checks if two vectors are parallel within a tolerance. **/
    public static inline function isParrallel(a: Float4, b: Float4, tolerance: Float = 1e-6): Bool {
        var normalizedDot = Math.abs(dot(normalize(a), normalize(b)));
        return normalizedDot >= (1.0 - tolerance);
    }


    /** Checks if two vectors are perpendicular within a tolerance. **/
    public static inline function isPerpendicular(a: Float4, b: Float4, tolerance: Float = 1e-6): Bool
    {
        var dot = Math.abs(dot(a, b));
        return dot <= tolerance;
    }

    /** Projects vector a onto vector b. **/
    public static inline function project(a: Float4, b: Float4): Float4
    {
        var denominator = dot(b, b);
        if (denominator <= Maths.Epsilon)
            return Float4.Zero;
        return b * (dot(a, b) / denominator);
    }

    /** Projects a vector onto a plane defined by a normal vector. **/
    public static inline function projectOntoPlane(vector: Float4, planeNormal: Float4):Float4 {
        return vector - project(vector, planeNormal);
    }

    /** Reflects a vector off a normal. **/
    public static inline function reflect(vector: Float4, normal: Float4): Float4
    {
        var dot = dot(vector, normal);
        return vector - 2 * dot * normal;
    }


    /**Calculates the refraction direction for an incident vector and surface normal.**/
    public static inline function refract( incident: Float4,  normal: Float4,  eta: Float): Float4
    {
        var dotNI: Float = dot(normal, incident);
        var k: Float = 1.0 - eta * eta * (1.0 - dotNI * dotNI);
        return k < 0.0 ? Zero : eta * incident - (eta * dotNI + Math.sqrt(k)) * normal;
    }

    /**Spherically interpolates between two vectors.**/
    public static inline function slerp(a: Float4, b: Float4, t: Float): Float4
    {
        t = Maths.saturate(t);
        return slerpUnclamped(a, b, t);
    }

    public static inline function slerpUnclamped(a: Float4, b: Float4, t: Float): Float4
    {
        var result = Float4.Zero;

        // Normalize the vectors
        var normalizedA: Float4 = normalize(a);
        var normalizedB: Float4 = normalize(b);

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
    public static inline function moveTowards(current: Float4, target: Float4, maxDistanceDelta: Float): Float4
    {
        var toVector: Float4 = target - current;
        var distance: Float = length(toVector);
        if (distance <= maxDistanceDelta || distance < Maths.Epsilon)
            return target;
        return current + toVector / distance * maxDistanceDelta;
    }
}