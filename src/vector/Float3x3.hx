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
    // public static inline function fromValues(m00:Float, m01: Float, m10: Float, m11: Float): Float3x3 {
    //     return new Float3x3(
    //         new Float3(m00, m10), 
    //         new Float3(m01, m11)
    //     );
    // }
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

    // public static inline function fromFloat4x4(m:Float4x4): Float3x3 {
    //     return new Float3x3(
    //         m.c0.xyz,
    //         m.c1.xyz,
    //         m.c2.xyz
    //     );
    // }

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
                array[i * 2 + j] = get_float(i, j);
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
        this.c1.x = v.z;
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


    // public static function fromQuaternion(q: Quaternion): Float3x3 {

    //     var x2:Float = q.X + q.X;
    //     var y2:Float = q.Y + q.Y;
    //     var z2:Float = q.Z + q.Z;
    //     var xx:Float = q.X * x2;
    //     var yy:Float = q.Y * y2;
    //     var zz:Float = q.Z * z2;
    //     var xy:Float = q.X * y2;
    //     var xz:Float = q.X * z2;
    //     var yz:Float = q.Y * z2;
    //     var wx:Float = q.W * x2;
    //     var wy:Float = q.W * y2;
    //     var wz:Float = q.W * z2;


    //     var m00:Float = 1.0 - (yy + zz);
    //     var m01:Float = xy + wz;
    //     var m02:Float = xz - wy;

    //     var m10:Float = xy - wz;
    //     var m11:Float = 1.0 - (xx + zz);
    //     var m12:Float = yz + wx;

    //     var m20:Float = xz + wy;
    //     var m21:Float = yz - wx;
    //     var m22:Float = 1.0 - (xx + yy);

    //     return Float3x3.fromValues(m00, m01, m02,
    //         m10, m11, m12,
    //         m20, m21, m22);
    // }
}