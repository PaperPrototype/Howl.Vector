package vector;
import haxe.exceptions.ArgumentException;
import haxe.Exception;
import haxe.ds.Vector;

class Float4x4Class {
    public var c0:Float4; // Column 0
    public var c1:Float4; // Column 1
    public var c2:Float4; // Column 2
    public var c3:Float4; // Column 3

    public function new(c0:Float4, c1:Float4, c2:Float4, c3:Float4) {
        this.c0 = c0;
        this.c1 = c1;
        this.c2 = c2;
        this.c3 = c3;
    }
}

/**
    A Float4x4 matrix class with operator overloading based on Prowl.Vector.

    Ported and adapted from Prowl.Vector.

    @see https://github.com/ProwlEngine/Prowl.Vector/blob/main/Vector/Matrices/Float4x4.cs
**/
// @:forward(arrayRead)
@:forward(c0, c1, c2, c3)
abstract Float4x4(Float4x4Class) from Float4x4Class to Float4x4Class {
    public static final Identity:Float4x4 = new Float4x4(Float4.UnitX, Float4.UnitY, Float4.UnitZ, Float4.UnitW);
    public static final Zero    :Float4x4 = new Float4x4(Float4.Zero, Float4.Zero, Float4.Zero, Float4.Zero);

    public var translation(get, set):Float4;
    inline function get_translation():Float4 {
        return this.c3;
    }
    inline function set_translation(value:Float4):Float4 {
        this.c3 = value;
        return value;
    }

    /**Returns a reference to the Float4 (column) at a specified index.**/
    @:op([])
    public inline function get(index:Int):Float4 {
        return switch(index) {
            case 0: this.c0;
            case 1: this.c1;
            case 2: this.c2;
            case 3: this.c3;
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
            case 3: this.c3[row];
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
            case 3: {
                if      (row == 0) this.c3.x = value; 
                else if (row == 1) this.c3.y = value; 
                else if (row == 2) this.c3.z = value; 
            }
            default: throw "Column out of bounds: " + column;
        }
    }

    /// CONSTRUCTORS ///
    public inline function new(col0:Float4, col1:Float4, col2:Float4, col3:Float4) {
        this = new Float4x4Class(col0, col1, col2, col3);
    }

    public static inline function fromValues(m00:Float, m01:Float, m02:Float, m03:Float, m10:Float, m11:Float, m12:Float, m13:Float, m20:Float, m21:Float, m22:Float, m23:Float, m30:Float, m31:Float, m32:Float, m33:Float)
    {
        return new Float4x4(
            new Float4(m00, m10, m20, m30),
            new Float4(m01, m11, m21, m31),
            new Float4(m02, m12, m22, m32),
            new Float4(m03, m13, m23, m33),
        );
    }

    // @:op(a())
    public static inline function fromScalar(s:Float): Float4x4 {
        return new Float4x4(
            new Float4(s, s, s, s), 
            new Float4(s, s, s, s),
            new Float4(s, s, s, s),
            new Float4(s, s, s, s),
        );
    }

    /// <summary>Constructs a Float4x4 from a Float3x3 rotation matrix and a Float3 translation vector.</summary>
    public static inline function fromFloat3x3(rotation: Float3x3, translation: Float3): Float4x4
    {
        return new Float4x4(
            new Float4(rotation.c0.x, rotation.c0.y, rotation.c0.z, 0.0),
            new Float4(rotation.c1.x, rotation.c1.y, rotation.c1.z, 0.0),
            new Float4(rotation.c2.x, rotation.c2.y, rotation.c2.z, 0.0),
            new Float4(translation.x, translation.y, translation.z, 1.0),
        );
    }

    /// <summary>Constructs a Float4x4 from a Quaternion rotation and a Float3 translation vector.</summary>
    public static inline function fromQuaternion(rotation: Quaternion, translation: Float3): Float4x4
    {
        var rotMatrix: Float3x3 = Float3x3.fromQuaternion(rotation);
        return new Float4x4(
            new Float4(rotMatrix.c0.x, rotMatrix.c0.y, rotMatrix.c0.z, 0.0),
            new Float4(rotMatrix.c1.x, rotMatrix.c1.y, rotMatrix.c1.z, 0.0),
            new Float4(rotMatrix.c2.x, rotMatrix.c2.y, rotMatrix.c2.z, 0.0),
            new Float4( translation.x,  translation.y,  translation.z, 1.0),
        );
    }

    /// OPERATOR OVERLOADING ///

    // /// <summary>Returns the result of a matrix-vector multiplication.</summary>
    // /// <param name="m">The matrix.</param>
    // /// <param name="v">The vector.</param>
    // /// <returns>The result of m * v.</returns>
    // @:op(A * B) public static inline function mul_vector(m: Float4x4, v: Float4): Float4 {
    //     return m.c0 * v.x + m.c1 * v.y + m.c2 * v.z;
    // }


    /// <summary>
    /// Returns the result of a matrix-matrix multiplication.
    /// </summary>
    /// <returns>Order matters, so the result of A * B is that B is applied first, then A.</returns>
    @:op(A * B) public static inline function mul(a: Float4x4, b: Float4x4) { 
        return new Float4x4(
            a.c0 * b.c0.x + a.c1 * b.c0.y + a.c2 * b.c0.z + a.c3 * b.c0.w,
            a.c0 * b.c1.x + a.c1 * b.c1.y + a.c2 * b.c1.z + a.c3 * b.c1.w,
            a.c0 * b.c2.x + a.c1 * b.c2.y + a.c2 * b.c2.z + a.c3 * b.c2.w,
            a.c0 * b.c3.x + a.c1 * b.c3.y + a.c2 * b.c3.z + a.c3 * b.c3.w
        );
    }

    /// <summary>Returns the result of a matrix-vector multiplication.</summary>
    /// <param name="m">The matrix.</param>
    /// <param name="v">The vector.</param>
    /// <returns>The result of m * v.</returns>
    @:op(A * B) public static inline function mul_vector(m: Float4x4, v: Float4): Float4 { 
        return m.c0 * v.x +
            m.c1 * v.y +
            m.c2 * v.z +
            m.c3 * v.w;
    }

    // Equality operators
    @:op(A == B) public static inline function eq(left:Float4x4, right:Float4x4):Bool { return left.equals(right); }
    @:op(A != B) public static inline function neq(left:Float4x4, right:Float4x4):Bool { return !left.equals(right); }
    public inline function equals(rhs: Float4x4): Bool {
        return this.c0.equals(rhs.c0) && this.c1.equals(rhs.c1) && this.c2.equals(rhs.c2) && this.c3.equals(rhs.c3);
    }

    /**Hashcode for dictionaries and sets**/
    public function getHashCode(): Int
    {
        var hash: Int = 17;
        hash = hash * 23 + this.c0.getHashCode();
        hash = hash * 23 + this.c1.getHashCode();
        hash = hash * 23 + this.c2.getHashCode();
        hash = hash * 23 + this.c3.getHashCode();
        return hash;
    }

    /** Returns the vector as an array [x, y] **/
    public inline function toArray():Vector<Float> {
        var array: Vector<Float>  = new Vector(9);
        for (i in 0...4) {
            for (j in 0...4) {
                array[i * 4 + j] = get_float(i, j);
            }
        }
        return array;   
    }

    /** Returns a string representation of the vector in the format "Float4x4(x, y)" **/
    public inline function toString():String {
        var sb = "";
        sb += "Float4x4(";
        sb += this.c0.x + ", " + this.c1.x + ", " + this.c2.x;
        sb += "  ";
        sb += this.c0.y + ", " + this.c1.y + ", " + this.c2.y;
        sb += "  ";
        sb += this.c0.z + ", " + this.c1.z + ", " + this.c2.z;
        sb += "  ";
        sb += this.c0.w + ", " + this.c1.z + ", " + this.c2.z;
        sb += ")";
        return sb;
    }

    /// METHODS ///
    public function getRow0():Float4 {
        return new Float4(this.c0.x, this.c1.x, this.c2.x, this.c3.x);
    }
    public function setRow0(v:Float4):Void {
        this.c0.x = v.x;
        this.c1.x = v.y;
        this.c2.x = v.z;
        this.c3.z = v.w;
    }

    public function getRow1():Float4 {
        return new Float4(this.c0.y, this.c1.y, this.c2.y, this.c3.y);
    }
    public function setRow1(v:Float4):Void {
        this.c0.y = v.x;
        this.c1.y = v.y;
        this.c2.y = v.z;
        this.c3.y = v.w;
    }

    public function getRow2():Float4 {
        return new Float4(this.c0.z, this.c1.z, this.c2.z, this.c3.w);
    }
    public function setRow2(v:Float4):Void {
        this.c0.z = v.x;
        this.c1.z = v.y;
        this.c2.z = v.z;
        this.c3.z = v.w;
    }

    public function getRow3():Float4 {
        return new Float4(this.c0.w, this.c1.w, this.c2.w, this.c3.w);
    }
    public function setRow3(v:Float4):Void {
        this.c0.w = v.x;
        this.c1.w = v.y;
        this.c2.w = v.z;
        this.c3.w = v.w;
    }

    /**
        Calculates the inverse of this matrix.
        @return The inverted matrix, or leaves the matrix unchanged inversion fails.
    **/
    public function invert():Float4x4 {
        var result:Float4x4 = new Float4x4(Float4.Zero, Float4.Zero, Float4.Zero, Float4.Zero);
        tryInvert(this, result);
        return result;
    }

    /** 
        Attempts to calculate the inverse of the given matrix. If successful, result will contain the inverted matrix.
        @param matrix The source matrix to invert.
        @param result If successful, contains the inverted matrix.
        @return True if the source matrix could be inverted; False otherwise.
    **/
    public static function tryInvert(matrix: Float4x4, result:Float4x4):Bool
    {
        var a = matrix.c0.x; var b = matrix.c1.x; var c = matrix.c2.x; var d = matrix.c3.x;
        var e = matrix.c0.y; var f = matrix.c1.y; var g = matrix.c2.y; var h = matrix.c3.y;
        var i = matrix.c0.z; var j = matrix.c1.z; var k = matrix.c2.z; var l = matrix.c3.z;
        var m = matrix.c0.w; var n = matrix.c1.w; var o = matrix.c2.w; var p = matrix.c3.w;

        var kp_lo = k * p - l * o;
        var jp_ln = j * p - l * n;
        var jo_kn = j * o - k * n;
        var ip_lm = i * p - l * m;
        var io_km = i * o - k * m;
        var in_jm = i * n - j * m;

        var a11 =  (f * kp_lo - g * jp_ln + h * jo_kn);
        var a12 = -(e * kp_lo - g * ip_lm + h * io_km);
        var a13 =  (e * jp_ln - f * ip_lm + h * in_jm);
        var a14 = -(e * jo_kn - f * io_km + g * in_jm);

        var det = a * a11 + b * a12 + c * a13 + d * a14;

        if (Math.abs(det) < Maths.EPSILON)
        {
            result = new Float4x4(
                new Float4(Math.NaN, Math.NaN, Math.NaN, Math.NaN),
                new Float4(Math.NaN, Math.NaN, Math.NaN, Math.NaN),
                new Float4(Math.NaN, Math.NaN, Math.NaN, Math.NaN),
                new Float4(Math.NaN, Math.NaN, Math.NaN, Math.NaN)
            );
            return false;
        }

        var invDet = 1.0 / det;

        var gp_ho = g * p - h * o;
        var fp_hn = f * p - h * n;
        var fo_gn = f * o - g * n;
        var ep_hm = e * p - h * m;
        var eo_gm = e * o - g * m;
        var en_fm = e * n - f * m;

        var gl_hk = g * l - h * k;
        var fl_hj = f * l - h * j;
        var fk_gj = f * k - g * j;
        var el_hi = e * l - h * i;
        var ek_gi = e * k - g * i;
        var ej_fi = e * j - f * i;

        result = new Float4x4(
            new Float4(
                a11 * invDet,
                a12 * invDet,
                a13 * invDet,
                a14 * invDet
            ),
            new Float4(
                -(b * kp_lo - c * jp_ln + d * jo_kn) * invDet,
                 (a * kp_lo - c * ip_lm + d * io_km) * invDet,
                -(a * jp_ln - b * ip_lm + d * in_jm) * invDet,
                 (a * jo_kn - b * io_km + c * in_jm) * invDet
            ),
            new Float4(
                 (b * gp_ho - c * fp_hn + d * fo_gn) * invDet,
                -(a * gp_ho - c * ep_hm + d * eo_gm) * invDet,
                 (a * fp_hn - b * ep_hm + d * en_fm) * invDet,
                -(a * fo_gn - b * eo_gm + c * en_fm) * invDet
            ),
            new Float4(
                -(b * gl_hk - c * fl_hj + d * fk_gj) * invDet,
                 (a * gl_hk - c * el_hi + d * ek_gi) * invDet,
                -(a * fl_hj - b * el_hi + d * ej_fi) * invDet,
                 (a * fk_gj - b * ek_gi + c * ej_fi) * invDet
            )
        );
        return true;
    }

    /// <summary>Calculates the determinant of a Float4x4 matrix.</summary>
    /// <param name="m">The matrix to calculate the determinant
    public static function determinant(m: Float4x4): Float
    {
        // Components are laid out in column-major order, but the formula is often shown in row-major.
        // We'll use component names a,b,c... for clarity, mapping from the column vectors.
        var a :Float  = m.c0.x, b = m.c1.x, c = m.c2.x, d = m.c3.x;
        var e :Float  = m.c0.y, f = m.c1.y, g = m.c2.y, h = m.c3.y;
        var i :Float  = m.c0.z, j = m.c1.z, k = m.c2.z, l = m.c3.z;
        var mm:Float  = m.c0.w, n = m.c1.w, o = m.c2.w, p = m.c3.w;

        // Pre-calculate 2x2 determinants for cofactors
        var kp_lo:Float = k * p - l * o;
        var jp_ln:Float = j * p - l * n;
        var jo_kn:Float = j * o - k * n;
        var ip_lm:Float = i * p - l * mm;
        var io_km:Float = i * o - k * mm;
        var in_jm:Float = i * n - j * mm;

        // Cofactor expansion across the first row
        return  a * (f * kp_lo - g * jp_ln + h * jo_kn) -
                b * (e * kp_lo - g * ip_lm + h * io_km) +
                c * (e * jp_ln - f * ip_lm + h * in_jm) -
                d * (e * jo_kn - f * io_km + g * in_jm);
    }


    /// <summary>Returns a Float4x4 matrix representing a rotation around an axis by an angle.</summary>
    public static function fromAxisAngle(axis: Float3, angle: Float): Float4x4
    {
        var rot3x3: Float3x3 = Float3x3.fromAxisAngle(axis, angle);
        return Float4x4.fromFloat3x3(rot3x3, Float3.Zero);
    }

    /// <summary>Returns a Float4x4 matrix that rotates around the X-axis.</summary>
    public static function rotateX(angle: Float): Float4x4
    {
        var rot3x3: Float3x3 = Float3x3.rotateX(angle);
        return Float4x4.fromFloat3x3(rot3x3, Float3.Zero);
    }

    /// <summary>Returns a Float4x4 matrix that rotates around the Y-axis.</summary>
    public static function rotateY(angle: Float): Float4x4
    {
        var rot3x3: Float3x3 = Float3x3.rotateY(angle);
        return Float4x4.fromFloat3x3(rot3x3, Float3.Zero);
    }

    /// <summary>Returns a Float4x4 matrix that rotates around the Z-axis.</summary>
    public static function rotateZ(angle: Float): Float4x4
    {
        var rot3x3: Float3x3 = Float3x3.rotateZ(angle);
        return Float4x4.fromFloat3x3(rot3x3, Float3.Zero);
    }

    /// <summary>Returns a Float4x4 uniform scale matrix.</summary>
    public static function createScale(s: Float): Float4x4
    {
        return Float4x4.fromValues(
            s, 0.0, 0.0, 0.0,
            0.0, s, 0.0, 0.0,
            0.0, 0.0, s, 0.0,
            0.0, 0.0, 0.0, 1.0
        );
    }

    /// <summary>Returns a Float4x4 non-uniform scale matrix.</summary>
    public static function createScaleIndividual(x: Float, y: Float, z: Float): Float4x4
    {
        return Float4x4.fromValues(
            x, 0.0, 0.0, 0.0,
            0.0, y, 0.0, 0.0,
            0.0, 0.0, z, 0.0,
            0.0, 0.0, 0.0, 1.0
        );
    }

    /// <summary>Returns a Float4x4 non-uniform scale matrix.</summary>
    public static function createScaleFloat3(scales: Float3): Float4x4
    {
        return createScaleIndividual(scales.x, scales.y, scales.z);
    }

    /// <summary>Returns a Float4x4 translation matrix.</summary>
    public static function createTranslation(vector: Float3): Float4x4
    {
        return Float4x4.fromValues(
            1.0, 0.0, 0.0, vector.x,
            0.0, 1.0, 0.0, vector.y,
            0.0, 0.0, 1.0, vector.z,
            0.0, 0.0, 0.0, 1.0
        );
    }

    /// <summary>
    /// Creates a translation, rotation, and scale (TRS) matrix.
    /// Operations are applied in order: scale, then rotate, then translate.
    /// </summary>
    public static function createTRS(translation: Float3, rotation: Quaternion, scale: Float3): Float4x4
    {
        var S = Float4x4.createScaleFloat3(scale);
        var R = Float4x4.createFromQuaternion(rotation);
        var T = Float4x4.createTranslation(translation);

        // Column-vector convention: apply S, then R, then T
        return T * (R * S); // Maths.Mul(T, Maths.Mul(R, S))
    }

    /// <summary>
    /// Creates a rotation matrix from the given Quaternion rotation value.
    /// </summary>
    /// <param name="quaternion">The source Quaternion.</param>
    /// <returns>The rotation matrix.</returns>
    public static function createFromQuaternion(quaternion: Quaternion): Float4x4
    {
        var result: Float4x4 = Float4x4.Zero;

        var xx:Float = quaternion.x * quaternion.x;
        var yy:Float = quaternion.y * quaternion.y;
        var zz:Float = quaternion.z * quaternion.z;

        var xy: Float = quaternion.x * quaternion.y;
        var wz: Float = quaternion.z * quaternion.w;
        var xz: Float = quaternion.z * quaternion.x;
        var wy: Float = quaternion.y * quaternion.w;
        var yz: Float = quaternion.y * quaternion.z;
        var wx: Float = quaternion.x * quaternion.w;

        result.c0.x = 1.0 - 2.0 * (yy + zz);
        result.c0.y = 2.0 * (xy + wz);
        result.c0.z = 2.0 * (xz - wy);
        result.c0.w = 0.0;
        result.c1.x = 2.0 * (xy - wz);
        result.c1.y = 1.0 - 2.0 * (zz + xx);
        result.c1.z = 2.0 * (yz + wx);
        result.c1.w = 0.0;
        result.c2.x = 2.0 * (xz + wy);
        result.c2.y = 2.0 * (yz - wx);
        result.c2.z = 1.0 - 2.0 * (yy + xx);
        result.c2.w = 0.0;

        result.c3 = new Float4(0.0, 0.0, 0.0, 1.0);

        return result;
    }

    /// <summary> Creates a Left-Handed view matrix from an eye position, a forward direction, and an up vector. </summary>
    public static function createLookTo(eyePosition: Float3, forwardVector: Float3, upVector: Float3): Float4x4
    {
        // Simply call CreateLookAt using a target point one unit in the forward direction
        return createLookAt(eyePosition, eyePosition + forwardVector, upVector);
    }

    /// <summary>Creates a Left-Handed view matrix from an eye position, a forward direction, and an up vector.</summary>
    public static function createLookAt(eyePosition: Float3, targetPosition: Float3, upVector: Float3): Float4x4
    {
        // Calculate camera basis vectors
        var f: Float3 = Float3.normalize(targetPosition - eyePosition); // camera forward (+Z in camera space)
        var s: Float3 = Float3.normalize(Float3.cross(upVector, f));     // right  = up × f
        var u: Float3 = Float3.cross(f, s);                             // up     = f × s

        // A view matrix transforms from world space to camera space.
        // We need the inverse of the camera-to-world transform.
        // For an orthonormal rotation matrix, the inverse is the transpose.
        // The inverse translation is: -R^T * eyePosition

        var m: Float4x4 = Float4x4.Identity;

        // Put axes in ROWS (transpose of rotation)
        m.set_float(0, 0, s.x); m.set_float(0, 1, s.y); m.set_float(0, 2, s.z);  // row 0 = right
        m.set_float(1, 0, u.x); m.set_float(1, 1, u.y); m.set_float(1, 2, u.z);  // row 1 = up
        m.set_float(2, 0, f.x); m.set_float(2, 1, f.y); m.set_float(2, 2, f.z);  // row 2 = forward

        // Translation: -R^T * eyePosition = -(dot products with eye position)
        m.set_float(0, 3, -Float3.dot(s, eyePosition));
        m.set_float(1, 3, -Float3.dot(u, eyePosition));
        m.set_float(2, 3, -Float3.dot(f, eyePosition));

        // m[3,*] already [0,0,0,1]
        return m;
    }

    /// <summary>Creates a Left-Handed orthographic projection matrix (Depth [0,1]).</summary>
    public static function CreateOrtho(width: Float, height: Float, nearPlane: Float, farPlane: Float): Float4x4
    {
        // This implementation is based on the DirectX Math Library XMMatrixOrthographicLH method
        // https://github.com/microsoft/DirectXMath/blob/master/Inc/DirectXMathMatrix.inl

        var range: Float = 1.0 / (farPlane - nearPlane);

        var result: Float4x4 = Float4x4.Zero;

        result.c0.x = 2.0 / width;
        result.c0.y = result.c0.z = result.c0.w = 0.0;

        result.c1.y = 2.0 / height;
        result.c1.x = result.c1.z = result.c1.w = 0.0;

        result.c2.z = range;
        result.c2.x = result.c2.y = result.c2.w = 0.0;

        result.c3.x = result.c3.y = 0.0;
        result.c3.z = -range * nearPlane;
        result.c3.w = 1;

        return result;
    }

    /// <summary>Creates a Left-Handed orthographic projection matrix (Depth [0,1]).</summary>
    public static function createOrthoOffCenter(left: Float, right: Float, bottom: Float, top: Float, nearPlane: Float, farPlane: Float): Float4x4
    {
        // This implementation is based on the DirectX Math Library XMMatrixOrthographicOffCenterLH method
        // https://github.com/microsoft/DirectXMath/blob/master/Inc/DirectXMathMatrix.inl

        var reciprocalWidth : Float = 1.0 / (right - left);
        var reciprocalHeight: Float = 1.0 / (top - bottom);
        var range           : Float = 1.0 / (farPlane - nearPlane);

        // Float4x4 result = default;
        var result: Float4x4 = Float4x4.Zero;

        result.c0 = new Float4(reciprocalWidth + reciprocalWidth, 0, 0, 0);
        result.c1 = new Float4(0, reciprocalHeight + reciprocalHeight, 0, 0);
        result.c2 = new Float4(0, 0, range, 0);
        result.c3 = new Float4(
            -(left + right) * reciprocalWidth,
            -(top + bottom) * reciprocalHeight,
            -range * nearPlane,
            1
        );

        return result;
    }

    /// <summary>Creates a Left-Handed perspective projection matrix (Depth [0,1]).</summary>
    public static function createPerspectiveFov(verticalFovRadians: Float, aspectRatio: Float, nearPlane: Float, farPlane: Float): Float4x4
    {
        // This implementation is based on the DirectX Math Library XMMatrixPerspectiveLH method
        // https://github.com/microsoft/DirectXMath/blob/master/Inc/DirectXMathMatrix.inl

        if (verticalFovRadians <= 0.0) throw new ArgumentException("verticalFovRadians", "Must be greater than zero.");
        if (verticalFovRadians >= Math.PI) throw new ArgumentException("verticalFovRadians", "Must be less than Pi.");

        if (nearPlane <= 0.0) throw new ArgumentException("nearPlane", "Must be greater than zero.");
        if (farPlane  <= 0.0) throw new ArgumentException("farPlane", "Must be greater than zero.");
        if (nearPlane >= farPlane) throw new ArgumentException("nearPlane", "Must be less than farPlane.");

        var height:Float = 1.0 / Math.tan(verticalFovRadians * 0.5);
        var width :Float = height / aspectRatio;
        var range :Float = Math.POSITIVE_INFINITY == farPlane ? 1.0 : farPlane / (farPlane - nearPlane);

        var result: Float4x4 = Float4x4.Zero;

        result.c0 = new Float4(width, 0, 0, 0);
        result.c1 = new Float4(0, height, 0, 0);
        result.c2 = new Float4(0, 0, range, 1.0);
        result.c3 = new Float4(0, 0, -range * nearPlane, 0);

        return result;
    }

    /// <summary>Returns the transpose of a Float4x4 matrix.</summary>
    /// <param name="m">The matrix to transpose.</param>
    /// <returns>The transposed matrix (Float4x4).</returns>
    public static function transpose(m: Float4x4): Float4x4 { 
        return new Float4x4(
            new Float4(m.c0.x, m.c1.x, m.c2.x, m.c3.x),
            new Float4(m.c0.y, m.c1.y, m.c2.y, m.c3.y),
            new Float4(m.c0.z, m.c1.z, m.c2.z, m.c3.z),
            new Float4(m.c0.w, m.c1.w, m.c2.w, m.c3.w)
        );
    }

    /// <summary>Transforms a 3D point using a 4x4 matrix (treating point as homogeneous with w=1).</summary>
    /// <param name="point">The 3D point to transform.</param>
    /// <param name="matrix">The 4x4 transformation matrix.</param>
    /// <returns>The transformed 3D point with perspective divide applied.</returns>
    public static function transformPointFloat3(point: Float3, matrix: Float4x4): Float3
    {
        // Treat point as homogeneous coordinates (x, y, z, 1)
        var homogeneous: Float4 = new Float4(point.x, point.y, point.z, 1.0);
        var transformed: Float4 = matrix * homogeneous;

        // Perform perspective divide
        if (Math.abs(transformed.w) > Maths.EPSILON)
            return new Float3(transformed.x / transformed.w, transformed.y / transformed.w, transformed.z / transformed.w);
        else
            return new Float3(transformed.x, transformed.y, transformed.z);
    }

    /// <summary>Transforms a 4D point using a 4x4 matrix (direct multiplication).</summary>
    /// <param name="point">The 4D point to transform.</param>
    /// <param name="matrix">The 4x4 transformation matrix.</param>
    /// <returns>The transformed 4D point.</returns>
    public static function transformPointFloat4(point: Float4, matrix: Float4x4): Float4 {
        return matrix * point;
    }

    /// <summary>Transforms a 3D normal vector using the upper-left 3x3 portion of a 4x4 matrix.</summary>
    /// <param name="normal">The 3D normal vector to transform.</param>
    /// <param name="matrix">The 4x4 transformation matrix.</param>
    /// <returns>The transformed and normalized normal vector.</returns>
    public static function transformNormal(normal: Float3, matrix: Float4x4): Float3
    {
        // Extract the upper-left 3x3 portion for rotation/scale
        var upperLeft: Float3x3 = Float3x3.fromFloat4x4(matrix);
        return Float3x3.transformFloat3Normal(normal, upperLeft);
    }
}