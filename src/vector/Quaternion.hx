package vector;

class QuaternionClass {
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
    A Quaternion class with operator overloading based on Prowl.Vector.

    Ported and adapted from Prowl.Vector.

    @see https://github.com/ProwlEngine/Prowl.Vector/blob/main/Vector/Quaternion.cs
**/
@:forward(x, y, z, w)
abstract Quaternion(QuaternionClass) from QuaternionClass to QuaternionClass {
    /// <summary>A quaternion representing the identity transform (no rotation).</summary>
    public static final identity: Quaternion = new Quaternion(0.0, 0.0, 0.0, 1.0);

    /// CONSTRUCTORS ///
    public inline function new(x:Float, y:Float, z:Float, w:Float) {
        this = new QuaternionClass(x, y, z, w);
    }

    public var eulerAngles(get, set):Float3;
    inline function get_eulerAngles():Float3 {
        return toEuler(this);
    }
    inline function set_eulerAngles(value:Float3):Float3 {
        this = fromEulerFloat3(value);
        return value;
    }

    // /// <summary>
    // /// Creates a quaternion from a 4x4 rotation matrix.
    // /// The matrix must be orthonormal in its upper-left 3x3 part.
    // /// </summary>
    // public static function fromMatrix4x4(m: Float4x4): Quaternion {
    //     return fromMatrix3x3(new Float3x3(m.c0.xyz, m.c1.xyz, m.c2.xyz));
    // }

    /// <summary>
    /// Creates a quaternion from a 3x3 rotation matrix.
    /// The matrix must be orthonormal (a pure rotation matrix).
    /// </summary>
    public static function fromMatrix3x3(m: Float3x3): Quaternion
    {
        var trace: Float = m.c0.x + m.c1.y + m.c2.z;
        var x, y, z, w: Float;

        if (trace > 0.0)
        {
            var s: Float = Math.sqrt(trace + 1.0) * 2.0;
            w = 0.25 * s;
            x = (m.c1.z - m.c2.y) / s;
            y = (m.c2.x - m.c0.z) / s;
            z = (m.c0.y - m.c1.x) / s;
        }
        else if ((m.c0.x > m.c1.y) && (m.c0.x > m.c2.z))
        {
            var s: Float = Math.sqrt(1.0 + m.c0.x - m.c1.y - m.c2.z) * 2.0;
            w = (m.c1.z - m.c2.y) / s;
            x = 0.25 * s;
            y = (m.c0.y + m.c1.x) / s;
            z = (m.c0.z + m.c2.y) / s;
        }
        else if (m.c1.y > m.c2.z)
        {
            var s: Float = Math.sqrt(1.0 + m.c1.y - m.c0.x - m.c2.z) * 2.0;
            w = (m.c2.x - m.c0.z) / s;
            x = (m.c0.y + m.c1.x) / s;
            y = 0.25 * s;
            z = (m.c2.y + m.c1.z) / s;
        }
        else
        {
            var s: Float = Math.sqrt(1.0 + m.c2.z - m.c0.x - m.c1.y) * 2.0;
            w = (m.c0.y - m.c1.x) / s;
            x = (m.c2.x + m.c0.z) / s;
            y = (m.c2.y + m.c1.z) / s;
            z = 0.25 * s;
        }
        return new Quaternion(x, y, z, w);
    }

    public static function fromEulerFloat3(euler: Float3): Quaternion {
        return fromEuler(euler.x, euler.y, euler.z);
    }

    public static function fromEuler(x: Float, y: Float, z: Float): Quaternion
    {
        var yawOver2  :Float = Maths.DEG2RAD * x * 0.5;
        var pitchOver2:Float = Maths.DEG2RAD * y * 0.5;
        var rollOver2 :Float = Maths.DEG2RAD * z * 0.5;

        var cosYawOver2  :Float = Math.cos(yawOver2);
        var sinYawOver2  :Float = Math.sin(yawOver2);
        var cosPitchOver2:Float = Math.cos(pitchOver2);
        var sinPitchOver2:Float = Math.sin(pitchOver2);
        var cosRollOver2 :Float = Math.cos(rollOver2);
        var sinRollOver2 :Float = Math.sin(rollOver2);

        var result = new Quaternion(
            cosYawOver2 * cosPitchOver2 * cosRollOver2 + sinYawOver2 * sinPitchOver2 * sinRollOver2,
            sinYawOver2 * cosPitchOver2 * cosRollOver2 + cosYawOver2 * sinPitchOver2 * sinRollOver2,
            cosYawOver2 * sinPitchOver2 * cosRollOver2 - sinYawOver2 * cosPitchOver2 * sinRollOver2,
            cosYawOver2 * cosPitchOver2 * sinRollOver2 - sinYawOver2 * sinPitchOver2 * cosRollOver2
        );
        return result;
    }

    public static function toEuler(q: Quaternion): Float3
    {
        var CUTOFF: Float = (1.0 - 2.0 * Maths.EPSILON) * (1.0 - 2.0 * Maths.EPSILON);

        var qv: Float4 = new Float4(q.x, q.y, q.z, q.w);

        var d1: Float4 = qv * (qv.w * 2.0);
        var d2: Float4 = new Float4(qv.x * qv.y * 2.0, qv.y * qv.z * 2.0, qv.z * qv.x * 2.0, qv.w * qv.w * 2.0);
        var d3: Float4 = new Float4(qv.x * qv.x, qv.y * qv.y, qv.z * qv.z, qv.w * qv.w);

        var euler = Float3.Zero;
        var y1: Float = d2.y - d1.x;

        if (y1 * y1 < CUTOFF)
        {
            var x1: Float = d2.x + d1.z;
            var x2: Float = d3.y + d3.w - d3.x - d3.z;
            var z1: Float = d2.z + d1.y;
            var z2: Float = d3.z + d3.w - d3.x - d3.y;

            euler = new Float3(
                Math.atan2(x1, x2),
                -Math.asin(y1),
                Math.atan2(z1, z2),
            );
        }
        else
        {
            y1 = Maths.clamp(y1, -1.0, 1.0);

            var abcd = new Float4(d2.z, d1.y, d2.y, d1.x);
            var x1: Float = 2.0 * (abcd.x * abcd.w + abcd.y * abcd.z);

            var x = new Float4(
                abcd.x * abcd.x * -1.0,
                abcd.y * abcd.y *  1.0,
                abcd.z * abcd.z * -1.0,
                abcd.w * abcd.w *  1.0
            );

            var x2: Float = (x.x + x.y) + (x.z + x.w);
            euler = new Float3(
                Math.atan2(x1, x2),
                -Math.asin(y1),
                0.0
            );
        }

        // Convert from radians to degrees
        euler = euler * Maths.RAD2DEG;

        // Reorder YZX
        euler = new Float3(euler.y, euler.z, euler.x);

        euler.x = normalizeAngle(euler.x);
        euler.y = normalizeAngle(euler.y);
        euler.z = normalizeAngle(euler.z);

        return euler;
    }

    /// <summary>Explicitly converts a Quaternion to a Float4 vector.</summary>
    public static function toFloat4(q: Quaternion): Float4 { return new Float4(q.x, q.y, q.z, q.w); }

    @:op(-A)    public static function neg       (value: Quaternion)             : Quaternion { return new Quaternion(-value.x, -value.y, -value.z, -value.w); }
    @:op(A + B) public static function add_scalar(lh: Quaternion, scalar: Float ): Quaternion { return new Quaternion(lh.x + scalar, lh.y + scalar, lh.z + scalar, lh.w + scalar); }
    @:op(A - B) public static function sub_scalar(lh: Quaternion, scalar: Float ): Quaternion { return new Quaternion(lh.x - scalar, lh.y - scalar, lh.z - scalar, lh.w - scalar); }
    @:op(A / B) public static function div_scalar(lh: Quaternion, scalar: Float ): Quaternion { return new Quaternion(lh.x / scalar, lh.y / scalar, lh.z / scalar, lh.w / scalar); }
    @:op(A * B) public static function mul_scalar(lh: Quaternion, scalar: Float ): Quaternion { return new Quaternion(lh.x * scalar, lh.y * scalar, lh.z * scalar, lh.w * scalar); }
    @:op(A + B) public static function add       (lh: Quaternion, rh: Quaternion): Quaternion { return new Quaternion(lh.x + rh.x, lh.y + rh.y, lh.z + rh.z, lh.w + rh.w); }
    @:op(A - B) public static function sub       (lh: Quaternion, rh: Quaternion): Quaternion { return new Quaternion(lh.x - rh.x, lh.y - rh.y, lh.z - rh.z, lh.w - rh.w); }
    @:op(A / B) public static function div       (lh: Quaternion, rh: Quaternion): Quaternion { return new Quaternion(lh.x / rh.x, lh.y / rh.y, lh.z / rh.z, lh.w / rh.w); }


    /// <summary> Multiplies two quaternions, combining their rotations. </summary>
    /// <remarks>The order is important: a * b means applying rotation b then rotation a.</remarks>
    @:op(A * B) public static function mul(lh: Quaternion, rh: Quaternion): Quaternion{
        return new Quaternion(
            lh.w * rh.x + lh.x * rh.w + lh.y * rh.z - lh.z * rh.y,
            lh.w * rh.y - lh.x * rh.z + lh.y * rh.w + lh.z * rh.x,
            lh.w * rh.z + lh.x * rh.y - lh.y * rh.x + lh.z * rh.w,
            lh.w * rh.w - lh.x * rh.x - lh.y * rh.y - lh.z * rh.z
        );
    }

    /// <summary>Rotates a 3D vector by a quaternion.</summary>
    @:op(A * B) public static function mul_vector(lh: Quaternion,  vector: Float3): Float3
    {
        var qVec: Float3 = new Float3(lh.x, lh.y, lh.z);
        var t: Float3 = 2.0 * Float3.cross(qVec, vector);
        return vector + lh.w * t + Float3.cross(qVec, t);
    }


    @:op(A == B) public static function eq(left: Quaternion, right: Quaternion) { return  left.equals(right); }
    @:op(A != B) public static function neq(left: Quaternion, right: Quaternion) { return !left.equals(right); }

    /// <summary>Checks if this quaternion is equal to another quaternion.</summary>
    public inline function equals(other: Quaternion): Bool {
        return this.x == other.x && this.y == other.y && this.z == other.z && this.w == other.w;
    }


    /// <summary>Gets the hash code for this quaternion.</summary>
    public function getHashCode(): Int {
        // HashCode.Combine(X, Y, Z, W);
        var hash = 374761393; // Starting prime
        
        hash = (hash * 1521134295) + haxe.io.FPHelper.floatToI32(this.x);
        hash = (hash * 1521134295) + haxe.io.FPHelper.floatToI32(this.y);
        hash = (hash * 1521134295) + haxe.io.FPHelper.floatToI32(this.z);
        hash = (hash * 1521134295) + haxe.io.FPHelper.floatToI32(this.w);
        
        return hash;
    }


    private static function normalizeAngle(angle: Float): Float
    {
        // Unity-style normalization
        angle %= 360;
        if (angle < 0)
            angle += 360;
        return angle;
    }

    /// <summary>Creates a quaternion representing a rotation around an axis by an angle.</summary>
    /// <param name="angle">The angle of rotation in radians.</param>
    /// <param name="axis">The axis of rotation (must be normalized).</param>
    public static function angleAxis(angle: Float, axis: Float3): Quaternion {
        return axisAngle(axis, angle);
    };

    /// <summary>Creates a quaternion representing a rotation around an axis by an angle.</summary>
    /// <param name="axis">The axis of rotation (must be normalized).</param>
    /// <param name="angle">The angle of rotation in radians.</param>
    public static function axisAngle(axis: Float3, angle: Float): Quaternion
    {
        var halfAngle: Float = angle * 0.5;
        //Maths.Sincos(halfAngle, out float s, out float c);
        var s: Float = Math.sin(halfAngle);
        var c: Float = Math.cos(halfAngle);
        return new Quaternion(axis.x * s, axis.y * s, axis.z * s, c);
    }

    /// <summary>Returns the conjugate of a quaternion.</summary>
    public static inline function conjugate(q: Quaternion): Quaternion
    {
        return new Quaternion(-q.x, -q.y, -q.z, q.w);
    }


    /// <summary>Returns the inverse of a quaternion.</summary>
    public static inline function inverse(q: Quaternion): Quaternion
    {
        var lengthSq: Float = lengthSquared(q);
        if (lengthSq <= Maths.EPSILON) // Should not happen with valid rotations
            return identity;
        var invLengthSq:Float = 1.0 / lengthSq;
        return new Quaternion(
            -q.x * invLengthSq,
            -q.y * invLengthSq,
            -q.z * invLengthSq,
                q.w * invLengthSq
        );
    }


    /// <summary>Returns the dot product of two quaternions.</summary>
    public static inline function dot(a: Quaternion, b: Quaternion): Float
    {
        return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
    }

    /// <summary>Returns the length (magnitude) of a quaternion.</summary>
    public static inline function length(q: Quaternion): Float
    {
        return Math.sqrt(q.x * q.x + q.y * q.y + q.z * q.z + q.w * q.w);
    }

    /// <summary>Returns the squared length (magnitude squared) of a quaternion.</summary>
    public static inline function lengthSquared(q: Quaternion): Float
    {
        return q.x * q.x + q.y * q.y + q.z * q.z + q.w * q.w;
    }

    /// <summary>Returns a normalized version of a quaternion.</summary>
    public static inline function normalize(q: Quaternion): Quaternion
    {
        var len: Float = length(q);
        if (len <= Maths.EPSILON)
            return identity; // Or throw
        var invLen: Float = 1.0 / len;
        return new Quaternion(q.x * invLen, q.y * invLen, q.z * invLen, q.w * invLen);
    }

    /// <summary>Returns a safe normalized version of the quaternion. Returns identity if normalization fails.</summary>
    public static inline function normalizeSafe(q: Quaternion): Quaternion
    {
        var lenSq: Float = lengthSquared(q);
        if (lenSq < Maths.EPSILON)
            return identity;
        var invLen: Float = Maths.rsqrt(lenSq);
        return new Quaternion(q.x * invLen, q.y * invLen, q.z * invLen, q.w * invLen);
    }

    /// <summary>Returns a safe normalized version of the quaternion. Returns defaultValue if normalization fails.</summary>
    public static inline function normalizeSafe2(q: Quaternion, defaultValue: Quaternion): Quaternion
    {
        var lenSq: Float = lengthSquared(q);
        if (lenSq < Maths.EPSILON)
            return defaultValue;
        var invLen: Float = Maths.rsqrt(lenSq);
        return new Quaternion(q.x * invLen, q.y * invLen, q.z * invLen, q.w * invLen);
    }

    /// <summary>Creates a quaternion for a rotation around the X axis.</summary>
    public static inline function rotateX(angle: Float): Quaternion
    {
        var halfAngle: Float = angle * 0.5;
        //Maths.Sincos(angle * 0.5, out float s, out float c);
        var s: Float = Math.sin(halfAngle);
        var c: Float = Math.cos(halfAngle);
        return new Quaternion(s, 0.0, 0.0, c);
    }

    /// <summary>Creates a quaternion for a rotation around the Y axis.</summary>
    public static inline function rotateY(angle: Float): Quaternion
    {
        var halfAngle: Float = angle * 0.5;
        //Maths.Sincos(angle * 0.5, out float s, out float c);
        var s: Float = Math.sin(halfAngle);
        var c: Float = Math.cos(halfAngle);
        return new Quaternion(0.0, s, 0.0, c);
    }

    /// <summary>Creates a quaternion for a rotation around the Z axis.</summary>
    public static inline function rotateZ(angle: Float): Quaternion
    {
        var halfAngle: Float = angle * 0.5;
        //Maths.Sincos(angle * 0.5, out float s, out float c);
        var s: Float = Math.sin(halfAngle);
        var c: Float = Math.cos(halfAngle);
        return new Quaternion(0.0, 0.0, s, c);
    }

    /// <summary>Creates a quaternion looking from a 'forward' direction with an 'up' vector.</summary>
    public static function  LookRotation(forward: Float3, up: Float3): Quaternion
    {
        // Ensure forward vector is normalized
        forward = Float3.normalize(forward);

        var right: Float3 = Float3.cross(up, forward);

        // Handle degenerate case when forward and up are parallel
        if (Float3.lengthSquared(right) < Maths.EPSILON)
        {
            // use X-axis as right when looking up/down
            // For looking straight up (0,1,0) or down (0,-1,0), keep right as (1,0,0)
            right = Float3.UnitX;
        }

        right = Float3.normalize(right);
        var newUp: Float3 = Float3.cross(forward, right);

        // Create rotation matrix components
        var m: Float3x3 = new Float3x3(right, newUp, forward);
        return fromMatrix3x3(m);
    }

    /// <summary>Normalized Lerp: Linearly interpolates and then normalizes. Faster than Slerp but not constant velocity.</summary>
    public static function nlerp(q1: Quaternion, q2: Quaternion, t: Float): Quaternion
    {
        var dot: Float = dot(q1, q2);
        var w1x: Float = q1.x, w1y = q1.y, w1z = q1.z, w1w = q1.w;
        var w2x: Float = q2.x, w2y = q2.y, w2z = q2.z, w2w = q2.w;

        if (dot < 0.0) // Ensure shortest path
        {
            w2x = -w2x; w2y = -w2y; w2z = -w2z; w2w = -w2w;
        }

        var resX:Float = w1x + t * (w2x - w1x);
        var resY:Float = w1y + t * (w2y - w1y);
        var resZ:Float = w1z + t * (w2z - w1z);
        var resW:Float = w1w + t * (w2w - w1w);

        return normalize(new Quaternion(resX, resY, resZ, resW));
    }

    /// <summary>Spherical Linear Interpolation: Interpolates along the great arc on the unit sphere. Constant velocity.</summary>
    public static function slerp(q1: Quaternion, q2: Quaternion, t:Float): Quaternion
    {
        var dot: Float = dot(q1, q2);
        var q2Adjusted: Quaternion = q2;

        if (dot < 0.0)
        {
            dot = -dot;
            q2Adjusted = new Quaternion(-q2.x, -q2.y, -q2.z, -q2.w);
        }

        if (dot > 0.9995) // If quaternions are very close, use Nlerp for stability
        {
            return nlerp(q1, q2Adjusted, t);
        }

        var angle   :Float = Math.acos(dot);        // Angle between input quaternions
        var sinAngle:Float = Math.sin(angle);    // Sin of angle
        if (Math.abs(sinAngle) < Maths.EPSILON) // Should not happen if dot <= 0.9995f
        {
            return nlerp(q1, q2Adjusted, t); // Fallback
        }

        var invSinAngle:Float = 1.0 / sinAngle;
        var scale0     :Float = Math.sin((1.0 - t) * angle) * invSinAngle;
        var scale1     :Float = Math.sin(t * angle) * invSinAngle;
 
        return new Quaternion(
            (scale0 * q1.x) + (scale1 * q2Adjusted.x),
            (scale0 * q1.y) + (scale1 * q2Adjusted.y),
            (scale0 * q1.w) + (scale1 * q2Adjusted.z),
            (scale0 * q1.w) + (scale1 * q2Adjusted.w)
        );
    }

    /// <summary>Returns the angle in radians between two unit quaternions.</summary>
    public static function Angle(q1: Quaternion, q2: Quaternion): Float
    {
        // Ensure they are unit quaternions or the result might be off
        // For non-unit quaternions, normalizing them first is advisable:
        // q1 = Normalize(q1);
        // q2 = Normalize(q2);
        var dot:Float = dot(q1, q2);
        // Clamp dot to avoid Acos domain errors due to floating point inaccuracies
        return Math.acos(Math.min(Math.abs(dot), 1.0)) * 2.0;
    }

    /// <summary>The "forward" vector of a rotation (0,0,1) rotated by the quaternion.</summary>
    public static inline function forward(q: Quaternion): Float3 {
        return q * new Float3(0, 0, 1);
    }

    /// <summary>The "up" vector of a rotation (0,1,0) rotated by the quaternion.</summary>
    public static inline function up(q: Quaternion): Float3 {
        return q * new Float3(0, 1, 0);
    }

    /// <summary>The "right" vector of a rotation (1,0,0) rotated by the quaternion.</summary>
    public static inline function right(q: Quaternion): Float3 {
        return q * new Float3(1, 0, 0);
    }
}