package vector;

class Maths {

    /// REGION Constants
    /**A small value used for floating point comparisons.**/
    public static final EPSILON:Float = 1e-10; // 0.0000000001
    /// ENDREGION Constants

    /// REGION Degrees/Radians Conversion
    /**π / 180 (degrees to radians multiplier)**/
    public static final DEG2RAD: Float = Math.PI / 180.0;

    /**180 / π (radians to degrees multiplier)**/
    public static final RAD2DEG: Float = 180.0 / Math.PI;
    /// ENDREGION Degrees/Radians Conversion

    /// REGION Basic Math Functions
    /**
        Clamps a value between min and max.
        @param x The value to clamp.
        @param min The minimum value.
        @param max The maximum value.
        @returns The clamped value.
    **/
    public static inline function clamp(x:Float, min:Float, max:Float):Float {
        return Math.max(min, Math.min(max, x));
    }

    /**Clamps a value between 0 and 1.**/
    public static inline function saturate(x: Float): Float {
        return clamp(x, 0.0, 1.0);
    }

    /**Linearly interpolates between two float values.**/
    public static inline function lerp(a: Float, b: Float, t: Float): Float {
        return a + (b - a) * saturate(t);
    }
    /// ENDREGION Basic Math Functions

    // public static inline function clamp(x:Float, min:Float, max:Float):Float {
    //     return Math.max(min, Math.min(max, x));
    // }

    // TODO implement this per class since Haxe doesn't support method overloading
    // /// <summary>Clamps float x between min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static float Clamp(float x, float min, float max) => (float)Math.Clamp(x, min, max);
    // /// <summary>Clamps double x between min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static double Clamp(double x, double min, double max) => (double)Math.Clamp(x, min, max);
    // /// <summary>Clamps int x between min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static int Clamp(int x, int min, int max) => (int)Math.Clamp(x, min, max);
    // /// <summary>Clamps byte x between min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static byte Clamp(byte x, byte min, byte max) => (byte)Math.Clamp(x, min, max);
    // /// <summary>Clamps ushort x between min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static ushort Clamp(ushort x, ushort min, ushort max) => (ushort)Math.Clamp(x, min, max);
    // /// <summary>Clamps uint x between min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static uint Clamp(uint x, uint min, uint max) => (uint)Math.Clamp(x, min, max);
    // /// <summary>Clamps ulong x between min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static ulong Clamp(ulong x, ulong min, ulong max) => (ulong)Math.Clamp(x, min, max);
    // /// <summary>Returns the componentwise clamp of a Float2 vector.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Float2 Clamp(Float2 x, Float2 min, Float2 max) => new Float2(Clamp(x.X, min.X, max.X), Clamp(x.Y, min.Y, max.Y));

    // /// <summary>Clamps each component of a Float2 vector between scalar min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Float2 Clamp(Float2 x, float min, float max) => new Float2(Clamp(x.X, min, max), Clamp(x.Y, min, max));
    // /// <summary>Returns the componentwise clamp of a Float3 vector.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Float3 Clamp(Float3 x, Float3 min, Float3 max) => new Float3(Clamp(x.X, min.X, max.X), Clamp(x.Y, min.Y, max.Y), Clamp(x.Z, min.Z, max.Z));

    // /// <summary>Clamps each component of a Float3 vector between scalar min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Float3 Clamp(Float3 x, float min, float max) => new Float3(Clamp(x.X, min, max), Clamp(x.Y, min, max), Clamp(x.Z, min, max));
    // /// <summary>Returns the componentwise clamp of a Float4 vector.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Float4 Clamp(Float4 x, Float4 min, Float4 max) => new Float4(Clamp(x.X, min.X, max.X), Clamp(x.Y, min.Y, max.Y), Clamp(x.Z, min.Z, max.Z), Clamp(x.W, min.W, max.W));

    // /// <summary>Clamps each component of a Float4 vector between scalar min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Float4 Clamp(Float4 x, float min, float max) => new Float4(Clamp(x.X, min, max), Clamp(x.Y, min, max), Clamp(x.Z, min, max), Clamp(x.W, min, max));
    // /// <summary>Returns the componentwise clamp of a Double2 vector.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Double2 Clamp(Double2 x, Double2 min, Double2 max) => new Double2(Clamp(x.X, min.X, max.X), Clamp(x.Y, min.Y, max.Y));

    // /// <summary>Clamps each component of a Double2 vector between scalar min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Double2 Clamp(Double2 x, double min, double max) => new Double2(Clamp(x.X, min, max), Clamp(x.Y, min, max));
    // /// <summary>Returns the componentwise clamp of a Double3 vector.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Double3 Clamp(Double3 x, Double3 min, Double3 max) => new Double3(Clamp(x.X, min.X, max.X), Clamp(x.Y, min.Y, max.Y), Clamp(x.Z, min.Z, max.Z));

    // /// <summary>Clamps each component of a Double3 vector between scalar min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Double3 Clamp(Double3 x, double min, double max) => new Double3(Clamp(x.X, min, max), Clamp(x.Y, min, max), Clamp(x.Z, min, max));
    // /// <summary>Returns the componentwise clamp of a Double4 vector.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Double4 Clamp(Double4 x, Double4 min, Double4 max) => new Double4(Clamp(x.X, min.X, max.X), Clamp(x.Y, min.Y, max.Y), Clamp(x.Z, min.Z, max.Z), Clamp(x.W, min.W, max.W));

    // /// <summary>Clamps each component of a Double4 vector between scalar min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Double4 Clamp(Double4 x, double min, double max) => new Double4(Clamp(x.X, min, max), Clamp(x.Y, min, max), Clamp(x.Z, min, max), Clamp(x.W, min, max));
    // /// <summary>Returns the componentwise clamp of a Int2 vector.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Int2 Clamp(Int2 x, Int2 min, Int2 max) => new Int2(Clamp(x.X, min.X, max.X), Clamp(x.Y, min.Y, max.Y));

    // /// <summary>Clamps each component of a Int2 vector between scalar min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Int2 Clamp(Int2 x, int min, int max) => new Int2(Clamp(x.X, min, max), Clamp(x.Y, min, max));
    // /// <summary>Returns the componentwise clamp of a Int3 vector.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Int3 Clamp(Int3 x, Int3 min, Int3 max) => new Int3(Clamp(x.X, min.X, max.X), Clamp(x.Y, min.Y, max.Y), Clamp(x.Z, min.Z, max.Z));

    // /// <summary>Clamps each component of a Int3 vector between scalar min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Int3 Clamp(Int3 x, int min, int max) => new Int3(Clamp(x.X, min, max), Clamp(x.Y, min, max), Clamp(x.Z, min, max));
    // /// <summary>Returns the componentwise clamp of a Int4 vector.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Int4 Clamp(Int4 x, Int4 min, Int4 max) => new Int4(Clamp(x.X, min.X, max.X), Clamp(x.Y, min.Y, max.Y), Clamp(x.Z, min.Z, max.Z), Clamp(x.W, min.W, max.W));

    // /// <summary>Clamps each component of a Int4 vector between scalar min and max values.</summary>
    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public static Int4 Clamp(Int4 x, int min, int max) => new Int4(Clamp(x.X, min, max), Clamp(x.Y, min, max), Clamp(x.Z, min, max), Clamp(x.W, min, max));

}