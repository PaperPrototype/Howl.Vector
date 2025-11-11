package vector;
import haxe.ds.Vector;

class Float3x3Class {
    public var c0:Float3; // Column 0
    public var c1:Float3; // Column 1
    public var c2:Float3; // Column 2

    public function new(c0:Float3, c1:Float3, c2:Float3) {
        this.c0 = c0;
        this.c1 = c1;
        this.c2 = c2;
    }
    
}

/**
    A Float3x3 matrix class with operator overloading based on Prowl.Vector.

    Ported and adapted from Prowl.Vector.

    @see https://github.com/ProwlEngine/Prowl.Vector/blob/main/Vector/Matrices/Float3x3.cs
**/
// @:forward(arrayRead)
@:forward(c0, c1, c2)
abstract Float3x3(Float3x3Class) from Float3x3Class to Float3x3Class {
    public static final Identity:Float3x3 = new Float3x3(Float3.UnitX, Float3.UnitY, Float3.UnitZ);
    public static final Zero    :Float3x3 = new Float3x3(Float3.Zero, Float3.Zero, Float3.Zero);

    public var translation(get, set):Float3;
    inline function get_translation():Float3 {
        return this.c2;
    }
    inline function set_translation(value:Float3):Float3 {
        this.c2 = value;
        return value;
    }

    /**Returns a reference to the Float3 (column) at a specified index.**/
    @:op([])
    public inline function get(index:Int):Float3 {
        return switch(index) {
            case 0: this.c0;
            case 1: this.c1;
            case 2: this.c2;
            default: throw "Index out of bounds: " + index;
        };
    }

    /**Returns the element at row and column indices.**/
    @:op([])
    public inline function get_float(row:Int, column:Int):Float {
        return switch(column) {
            case 0: this.c0[row];
            case 1: this.c1[row];
            case 2: this.c2[row];
            default: throw "Column out of bounds: " + column;
        };
    }

    /**Sets the element at row and column indices.**/
    @:op([])
    public inline function set_float(row:Int, column:Int, value:Float):Void {
        switch(column) {
            case 0: { 
                if      (row == 0) this.c0.x = value; 
                else if (row == 1) this.c0.y = value; 
                else if (row == 2) this.c0.z = value; 
            }
            case 1: {
                if      (row == 0) this.c1.x = value; 
                else if (row == 1) this.c1.y = value; 
                else if (row == 2) this.c1.z = value; 
            }
            case 2: {
                if      (row == 0) this.c2.x = value; 
                else if (row == 1) this.c2.y = value; 
                else if (row == 2) this.c2.z = value; 
            }
            default: throw "Column out of bounds: " + column;
        }
    }

    /// CONSTRUCTORS ///
    public inline function new(col0:Float3, col1:Float3, col2:Float3) {
        this = new Float3x3Class(col0, col1, col2);
    }

    public static inline function fromValues(m00:Float, m01:Float, m02:Float, m10:Float, m11:Float, m12:Float, m20:Float, m21:Float, m22:Float)
    {
        return new Float3x3(
            new Float3(m00, m10, m20),
            new Float3(m01, m11, m21),
            new Float3(m02, m12, m22)
        );
    }

    // @:op(a())
    public static inline function fromScalar(s:Float): Float3x3 {
        return new Float3x3(
            new Float3(s, s, s), 
            new Float3(s, s, s),
            new Float3(s, s, s)
        );
    }

    public static inline function fromFloat4x4(f4x4:Float4x4): Float3x3 {
        return new Float3x3(
            f4x4.c0.xyz,
            f4x4.c1.xyz,
            f4x4.c2.xyz
        );
    }

    /// OPERATOR OVERLOADING ///

    /// <summary>
    /// Returns the result of a matrix-matrix multiplication.
    /// </summary>
    /// <returns>Order matters, so the result of A * B is that B is applied first, then A.</returns>
    @:op(A * B) public static inline function mul(a: Float3x3, b:Float3x3): Float3x3 {
        return new Float3x3(
            a.c0 * b.c0.x + a.c1 * b.c0.y + a.c2 * b.c0.z,
            a.c0 * b.c1.x + a.c1 * b.c1.y + a.c2 * b.c1.z,
            a.c0 * b.c2.x + a.c1 * b.c2.y + a.c2 * b.c2.z
        );
    }

    /// <summary>Returns the result of a matrix-vector multiplication.</summary>
    /// <param name="m">The matrix.</param>
    /// <param name="v">The vector.</param>
    /// <returns>The result of m * v.</returns>
    @:op(A * B) public static inline function mul_vector(m: Float3x3, v: Float3): Float3 {
        return m.c0 * v.x + m.c1 * v.y + m.c2 * v.z;
    }

    // Equality operators
    @:op(A == B) public static inline function eq(left:Float3x3, right:Float3x3):Bool { return left.equals(right); }
    @:op(A != B) public static inline function neq(left:Float3x3, right:Float3x3):Bool { return !left.equals(right); }
    public inline function equals(rightHandSide: Float3x3): Bool {
        return this.c0.equals(rightHandSide.c0) && this.c1.equals(rightHandSide.c1) && this.c2.equals(rightHandSide.c2);
    }

    /**Hashcode for dictionaries and sets**/
    public function getHashCode(): Int
    {
        var hash: Int = 17;
        hash = hash * 23 + this.c0.getHashCode();
        hash = hash * 23 + this.c1.getHashCode();
        hash = hash * 23 + this.c2.getHashCode();
        return hash;
    }

    /** Returns the vector as an array [x, y] **/
    public inline function toArray():Vector<Float> {
        var array: Vector<Float>  = new Vector(9);
        for (i in 0...3) {
            for (j in 0...3) {
                array[i * 3 + j] = get_float(i, j);
            }
        }
        return array;   
    }

    /** Returns a string representation of the vector in the format "Float3x3(x, y)" **/
    public inline function toString():String {
        var sb = "";
        sb += "Float3x3(";
        sb += this.c0.x + ", " + this.c1.x + ", " + this.c2.x;
        sb += "  ";
        sb += this.c0.y + ", " + this.c1.y + ", " + this.c2.y;
        sb += "  ";
        sb += this.c0.z + ", " + this.c1.z + ", " + this.c2.z;
        sb += ")";
        return sb;
    }

    /// METHODS ///
    public function getRow0():Float3 {
        return new Float3(this.c0.x, this.c1.x, this.c2.x);
    }
    public function setRow0(v:Float3):Void {
        this.c0.x = v.x;
        this.c1.x = v.y;
        this.c2.x = v.z;
    }

    public function getRow1():Float3 {
        return new Float3(this.c0.y, this.c1.y, this.c2.y);
    }
    public function setRow1(v:Float3):Void {
        this.c0.y = v.x;
        this.c1.y = v.y;
        this.c2.y = v.z;
    }

    public function getRow2():Float3 {
        return new Float3(this.c0.z, this.c1.z, this.c2.z);
    }
    public function setRow2(v:Float3):Void {
        this.c0.z = v.x;
        this.c1.z = v.y;
        this.c2.z = v.z;
    }

    /**
        Calculates the inverse of this matrix.
        @return The inverted matrix, or leaves the matrix unchanged inversion fails.
    **/
    public function invert():Float3x3 {
        var result:Float3x3 = new Float3x3(Float3.Zero, Float3.Zero, Float3.Zero);
        tryInvert(this, result);
        return result;
    }

    /** 
        Attempts to calculate the inverse of the given matrix. If successful, result will contain the inverted matrix.
        @param matrix The source matrix to invert.
        @param result If successful, contains the inverted matrix.
        @return True if the source matrix could be inverted; False otherwise.
    **/
    public static function tryInvert(matrix: Float3x3, result:Float3x3):Bool
    {
        var m00 = matrix.c0.x; var m01 = matrix.c1.x; var m02 = matrix.c2.x;
        var m10 = matrix.c0.y; var m11 = matrix.c1.y; var m12 = matrix.c2.y;
        var m20 = matrix.c0.z; var m21 = matrix.c1.z; var m22 = matrix.c2.z;

        // Calculate determinant
        var det = m00 * (m11 * m22 - m12 * m21) -
                    m01 * (m10 * m22 - m12 * m20) +
                    m02 * (m10 * m21 - m11 * m20);


        if (Math.abs(det) < Maths.EPSILON)
        {
            result = new Float3x3(
                new Float3(Math.NaN, Math.NaN, Math.NaN),
                new Float3(Math.NaN, Math.NaN, Math.NaN),
                new Float3(Math.NaN, Math.NaN, Math.NaN)
            );
            return false;
        }

        var invDet = 1.0 / det;

        // Calculate cofactors and transpose (adjugate matrix)
        result = new Float3x3(
            new Float3(
                (m11 * m22 - m12 * m21) * invDet,
                -(m10 * m22 - m12 * m20) * invDet,
                (m10 * m21 - m11 * m20) * invDet
            ),
            new Float3(
                -(m01 * m22 - m02 * m21) * invDet,
                (m00 * m22 - m02 * m20) * invDet,
                -(m00 * m21 - m01 * m20) * invDet
            ),
            new Float3(
                (m01 * m12 - m02 * m11) * invDet,
                -(m00 * m12 - m02 * m10) * invDet,
                (m00 * m11 - m01 * m10) * invDet
            )
        );
        return true;
    }

    /**
        Calculates the determinant of a Float3x3 matrix.
        @param m The matrix to calculate the determinant of.
        @return The determinant of the matrix.
    **/
    public static function determinant(m: Float3x3): Float {
        // Using the scalar triple product formula: a · (b x c)
        return m.c0.x * (m.c1.y * m.c2.z - m.c1.z * m.c2.y) -
            m.c0.y * (m.c1.x * m.c2.z - m.c1.z * m.c2.x) +
            m.c0.z * (m.c1.x * m.c2.y - m.c1.y * m.c2.x);
    }

    public static function fromQuaternion(q: Quaternion): Float3x3 {

        var x2:Float = q.x + q.x;
        var y2:Float = q.y + q.y;
        var z2:Float = q.z + q.z;
        var xx:Float = q.x * x2;
        var yy:Float = q.y * y2;
        var zz:Float = q.z * z2;
        var xy:Float = q.x * y2;
        var xz:Float = q.x * z2;
        var yz:Float = q.y * z2;
        var wx:Float = q.w * x2;
        var wy:Float = q.w * y2;
        var wz:Float = q.w * z2;

        var m00:Float = 1.0 - (yy + zz);
        var m01:Float = xy + wz;
        var m02:Float = xz - wy;

        var m10:Float = xy - wz;
        var m11:Float = 1.0 - (xx + zz);
        var m12:Float = yz + wx;

        var m20:Float = xz + wy;
        var m21:Float = yz - wx;
        var m22:Float = 1.0 - (xx + yy);

        return Float3x3.fromValues(m00, m01, m02,
            m10, m11, m12,
            m20, m21, m22);
    }


    /// <summary>
    /// Returns a Float3x3 matrix representing a rotation around a unit axis by an angle in radians.
    /// </summary>
    /// <param name="axis">The rotation axis (must be normalized).</param>
    /// <param name="angle">The angle of rotation in radians.</param>
    public static function fromAxisAngle(axis: Float3, angle: Float): Float3x3
    {
        var s = Math.sin(angle);
        var c = Math.cos(angle);

        var t: Float = 1.0 - c;

        var x: Float = axis.x;
        var y: Float = axis.y;
        var z: Float = axis.z;

        // Assumes axis is normalized
        var m00: Float = t * x * x + c;
        var m01: Float = t * x * y - s * z;
        var m02: Float = t * x * z + s * y;

        var m10: Float = t * x * y + s * z;
        var m11: Float = t * y * y + c;
        var m12: Float = t * y * z - s * x;

        var m20: Float = t * x * z - s * y;
        var m21: Float = t * y * z + s * x;
        var m22: Float = t * z * z + c;

        return Float3x3.fromValues(m00, m01, m02, m10, m11, m12, m20, m21, m22);
    }

    /// <summary>Returns a Float3x3 matrix that rotates around the X-axis.</summary>
    public static function rotateX(angle: Float): Float3x3
    {
        var s = Math.sin(angle);
        var c = Math.cos(angle);

        return Float3x3.fromValues(
            1.0, 0.0, 0.0,
            0.0, c, -s,
            0.0, s, c
        );
    }

    /// <summary>Returns a Float3x3 matrix that rotates around the Y-axis.</summary>
    public static function rotateY(angle: Float): Float3x3
    {
        var s = Math.sin(angle);
        var c = Math.cos(angle);

        return Float3x3.fromValues(
            c, 0.0, s,
            0.0, 1.0, 0.0,
            -s, 0.0, c
        );
    }

    /// <summary>Returns a Float3x3 matrix that rotates around the Z-axis.</summary>
    public static function rotateZ(angle: Float): Float3x3
    {
        var s = Math.sin(angle);
        var c = Math.cos(angle);

        return Float3x3.fromValues(
            c, -s, 0.0,
            s, c , 0.0,
            0.0  , 0.0, 1.0
        );
    }

    /// <summary>Returns a Float3x3 matrix representing a uniform scaling.</summary>
    public static function scale(s: Float): Float3x3
    {
        return Float3x3.fromValues(
            s, 0.0, 0.0,
            0.0, s, 0.0,
            0.0, 0.0, s
        );
    }

    /// <summary>Returns a Float3x3 matrix representing a non-uniform axis scaling.</summary>
    public static function scaleIndividual(x: Float, y: Float, z: Float): Float3x3
    {
        return Float3x3.fromValues(
            x, 0.0, 0.0,
            0.0, y, 0.0,
            0.0, 0.0, z
        );
    }

    /// <summary>Returns a Float3x3 matrix representing a non-uniform axis scaling.</summary>
    public static function scaleFloat3(v: Float3): Float3x3
    {
        return scaleIndividual(v.x, v.y, v.z);
    }

    /// <summary>Creates a 3x3 view rotation matrix. Assumes forward and up are normalized and not collinear.</summary>
    public static function createLookRotation(forward: Float3, up: Float3): Float3x3
    {
        if (Float3.lengthSquared(forward) < Maths.EPSILON || Float3.lengthSquared(up) < Maths.EPSILON)
            return Float3x3.Identity;

        var zaxis: Float3 = Float3.normalize(forward);
        var xaxis: Float3 = Float3.cross(up, zaxis);

        if (Float3.lengthSquared(xaxis) < Maths.EPSILON) // Collinear (degenerate)
        {
            return Float3x3.Identity;
        }
        else
        {
            xaxis = Float3.normalize(xaxis);
        }

        var yaxis: Float3 = Float3.cross(zaxis, xaxis); // Already normalized if xaxis and zaxis are orthonormal

        return Float3x3.fromValues(
            xaxis.x, yaxis.x, zaxis.x,
            xaxis.y, yaxis.y, zaxis.y,
            xaxis.z, yaxis.z, zaxis.z
        );
    }

    /// <summary>Returns the transpose of a Float3x3 matrix.</summary>
    /// <param name="m">The matrix to transpose.</param>
    /// <returns>The transposed matrix (Float3x3).</returns>
    public static function transpose(m: Float3x3): Float3x3  { 
        return new Float3x3(
            new Float3(m.c0.x, m.c1.x, m.c2.x),
            new Float3(m.c0.y, m.c1.y, m.c2.y),
            new Float3(m.c0.z, m.c1.z, m.c2.z)
        );
    }

    /// <summary>Transforms a 3D normal vector using the inverse transpose of a 3x3 matrix.</summary>
    /// <param name="normal">The 3D normal vector to transform.</param>
    /// <param name="matrix">The 3x3 transformation matrix.</param>
    /// <returns>The transformed and normalized normal vector.</returns>
    public static function transformFloat3Normal(normal: Float3, matrix: Float3x3): Float3
    {
        var inverse: Float3x3 = Float3x3.Zero;
        // For normals, we need to use the inverse transpose of the matrix
        if (!tryInvert(matrix, inverse))
        {
            // Matrix is singular, return the original normal
            return normal;
        }
        var invTranspose: Float3x3 = transpose(inverse);
        var transformed : Float3   = invTranspose * normal;
        return Float3.normalize(transformed);
    }

    // TransformPoint functions
    /// <summary>Transforms a 2D point using a 3x3 matrix (treating point as homogeneous with w=1).</summary>
    /// <param name="point">The 2D point to transform.</param>
    /// <param name="matrix">The 3x3 transformation matrix.</param>
    /// <returns>The transformed 2D point with perspective divide applied.</returns>
    public static function transformPoint(point: Float2, matrix: Float3x3): Float2
    {
        // Treat point as homogeneous coordinates (x, y, 1)
        var homogeneous: Float3 = new Float3(point.x, point.y, 1.0);
        var transformed: Float3 = matrix * homogeneous;

        // Perform perspective divide
        if (Math.abs(transformed.z) > Maths.EPSILON)
            return new Float2(transformed.x / transformed.z, transformed.y / transformed.z);
        else
            return new Float2(transformed.x, transformed.y);
    }

    /// <summary>Transforms a 2D normal vector using the upper-left 2x2 portion of a 3x3 matrix.</summary>
    /// <param name="normal">The 2D normal vector to transform.</param>
    /// <param name="matrix">The 3x3 transformation matrix.</param>
    /// <returns>The transformed and normalized normal vector.</returns>
    public static function transformFloat2Normal(normal: Float2, matrix: Float3x3): Float2
    {
        // Extract the upper-left 2x2 portion for rotation/scale
        var upperLeft = Float2x2.fromValues(
            matrix.c0.x, matrix.c0.y,
            matrix.c1.x, matrix.c1.y
        );
        return Float2x2.transformNormal(normal, upperLeft);
    }
}