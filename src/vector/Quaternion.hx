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


    public var eulerAngles(get, set):Float3;
    inline function get_eulerAngles():Float3 {
        return this.c2;
    }
    inline function set_eulerAngles(value:Float3):Float3 {
        this.c2 = value;
        return value;
    }

    public static function fromEulerFloat3(euler: Float3): Quaternion {
        fromEuler(euler.x, euler.y, euler.z);
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

        var result = new Quaternion();
        result.w = cosYawOver2 * cosPitchOver2 * cosRollOver2 + sinYawOver2 * sinPitchOver2 * sinRollOver2;
        result.x = sinYawOver2 * cosPitchOver2 * cosRollOver2 + cosYawOver2 * sinPitchOver2 * sinRollOver2;
        result.y = cosYawOver2 * sinPitchOver2 * cosRollOver2 - sinYawOver2 * cosPitchOver2 * sinRollOver2;
        result.z = cosYawOver2 * cosPitchOver2 * sinRollOver2 - sinYawOver2 * sinPitchOver2 * cosRollOver2;

        return result;
    }

    public static function toEuler(q: Quaternion): Float3
    {
        var CUTOFF: Float = (1.0 - 2.0 * Maths.EPSILON) * (1.0 - 2.0 * Maths.EPSILON);

        var qv: Float4 = new Float4(q.x, q.y, q.z, q.w);

        var d1: Float4 = qv * (qv.W * 2.0);
        var d2: Float4 = new Float4(qv.x * qv.y * 2.0, qv.y * qv.z * 2.0, qv.z * qv.x * 2.0, qv.w * qv.w * 2.0);
        var d3: Float4 = new Float4(qv.x * qv.x, qv.y * qv.y, qv.z * qv.z, qv.w * qv.w);

        var euler = Float3.Zero;
        var y1: Float = d2.Y - d1.X;

        if (y1 * y1 < CUTOFF)
        {
            var x1: Float = d2.x + d1.z;
            var x2: Float = d3.y + d3.w - d3.x - d3.z;
            var z1: Float = d2.z + d1.y;
            var z2: Float = d3.z + d3.w - d3.x - d3.y;

            euler = new Float3(
                Math.atan2(x1, x2),
                -Math.asin(y1),
                Math.atan(z1, z2)
            );
        }
        else
        {
            y1 = Maths.clamp(y1, -1.0, 1.0);

            var abcd = new Float4(d2.z, d1.y, d2.y, d1.x);
            var x1: Float = 2.0 * (abcd.x * abcd.w + abcd.y * abcd.z);

            var x = new Float4(
                abcd.X * abcd.X * -1.0,
                abcd.Y * abcd.Y *  1.0,
                abcd.Z * abcd.Z * -1.0,
                abcd.W * abcd.W *  1.0
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

        euler.x = normalizeAngle(euler.X);
        euler.y = normalizeAngle(euler.Y);
        euler.z = normalizeAngle(euler.Z);

        return euler;
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
        axisAngle(axis, angle);
    };

    // /// <summary>Creates a quaternion representing a rotation around an axis by an angle.</summary>
    // /// <param name="axis">The axis of rotation (must be normalized).</param>
    // /// <param name="angle">The angle of rotation in radians.</param>
    // public static Quaternion AxisAngle(Float3 axis, float angle)
    // {
    //     float halfAngle = angle * 0.5f;
    //     //Maths.Sincos(halfAngle, out float s, out float c);
    //     float s = Maths.Sin(halfAngle);
    //     float c = Maths.Cos(halfAngle);
    //     return new Quaternion(axis.X * s, axis.Y * s, axis.Z * s, c);
    // }
}