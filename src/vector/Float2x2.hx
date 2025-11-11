package vector;
import haxe.ds.Vector;

class Float2x2Class {
    public var c0:Float2; // Column 0
    public var c1:Float2; // Column 1

    public function new(c0:Float2, c1:Float2) {
        this.c0 = c0;
        this.c1 = c1;
    }
}

/**
    A Float2x2 matrix class with operator overloading based on Prowl.Vector.

    Ported and adapted from Prowl.Vector.

    @see https://github.com/ProwlEngine/Prowl.Vector/blob/main/Vector/Matrices/Float2x2.cs
**/
// @:forward(arrayRead)
@:forward(c0, c1)
abstract Float2x2(Float2x2Class) from Float2x2Class to Float2x2Class {
    public static final Identity:Float2x2 = new Float2x2(Float2.UnitX, Float2.UnitY);
    public static final Zero    :Float2x2 = new Float2x2(Float2.Zero, Float2.Zero);

    /**Returns a reference to the Float2 (column) at a specified index.**/
    @:op([])
    public inline function get(index:Int):Float2 {
        return switch(index) {
            case 0: this.c0;
            case 1: this.c1;
            default: throw "Index out of bounds: " + index;
        };
    }

    /**Returns the element at row and column indices.**/
    @:op([])
    public inline function get_float(row:Int, column:Int):Float {
        return switch(column) {
            case 0: this.c0[row];
            case 1: this.c1[row];
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
            }
            case 1: {
                if      (row == 0) this.c1.x = value; 
                else if (row == 1) this.c1.y = value; 
            }
            default: throw "Column out of bounds: " + column;
        }
    }

    /// CONSTRUCTORS ///
    public inline function new(col0:Float2, col1:Float2) {
        this = new Float2x2Class(col0, col1);
    }
    public static inline function fromValues(m00:Float, m01: Float, m10: Float, m11: Float): Float2x2 {
        return new Float2x2(
            new Float2(m00, m10), 
            new Float2(m01, m11)
        );
    }

    // @:op(a()) inline function callIndividual(m00:Float, m01: Float, m10: Float, m11: Float): Float2x2 {
    //     return new Float2x2(
    //         new Float2(m00, m10), 
    //         new Float2(m01, m11)
    //     );
    // }
    // @:op(a()) inline function callScalar(s:Float): Float2x2 {
    //     return new Float2x2(
    //         new Float2(s, s), 
    //         new Float2(s, s),
    //     );
    // }

    /// OPERATOR OVERLOADING ///

    /// <summary>
    /// Returns the result of a matrix-matrix multiplication.
    /// </summary>
    /// <returns>Order matters, so the result of A * B is that B is applied first, then A.</returns>
    @:op(A * B) public static inline function mul(a: Float2x2, b:Float2x2): Float2x2 {
        return new Float2x2(
            a.c0 * b.c0.x + a.c1 * b.c0.y,
            a.c0 * b.c1.x + a.c1 * b.c1.y
        );
    }

    /// <summary>Returns the result of a matrix-vector multiplication.</summary>
    /// <param name="m">The matrix.</param>
    /// <param name="v">The vector.</param>
    /// <returns>The result of m * v.</returns>
    @:op(A * B) public static inline function mul_vector(m: Float2x2, v: Float2): Float2 {
        return m.c0 * v.x + m.c1 * v.y;
    }

    // Equality operators
    @:op(A == B) public static inline function eq(left:Float2x2, right:Float2x2):Bool { return left.equals(right); }
    @:op(A != B) public static inline function neq(left:Float2x2, right:Float2x2):Bool { return !left.equals(right); }
    public inline function equals(rightHandSide: Float2x2): Bool {
        return this.c0.equals(rightHandSide.c0) && this.c1.equals(rightHandSide.c1);
    }

    /**Hashcode for dictionaries and sets**/
    public function getHashCode(): Int
    {
        var hash: Int = 17;
        hash = hash * 23 + this.c0.getHashCode();
        hash = hash * 23 + this.c1.getHashCode();
        return hash;
    }

    /** Returns the vector as an array [x, y] **/
    public inline function toArray():Vector<Float> {
        var array: Vector<Float>  = new Vector(4);
        for (i in 0...2) {
            for (j in 0...2) {
                array[i * 2 + j] = get_float(i, j);
            }
        }
        return array;   
    }

    /** Returns a string representation of the vector in the format "Float2x2(x, y)" **/
    public inline function toString():String {
        var sb = "";
        sb += "Float2x2(";
        sb += this.c0.x + ", " + this.c1.x + ", ";
        sb += "  ";
        sb += this.c0.y + ", " + this.c1.y;
        sb += ")";
        return sb;
    }

    /// METHODS ///
    public function getRow0():Float2 {
        return new Float2(this.c0.x, this.c1.x);
    }
    public function setRow0(v:Float2):Void {
        this.c0.x = v.x;
        this.c1.x = v.y;
    }

    public function getRow1():Float2 {
        return new Float2(this.c0.y, this.c1.y);
    }
    public function setRow1(v:Float2):Void {
        this.c0.y = v.x;
        this.c1.y = v.y;
    }

    /**
        Calculates the inverse of this matrix.
        @return The inverted matrix, or leaves the matrix unchanged inversion fails.
    **/
    public function invert():Float2x2 {
        var result:Float2x2 = new Float2x2(Float2.Zero, Float2.Zero);
        tryInvert(this, result);
        return result;
    }

    /** 
        Attempts to calculate the inverse of the given matrix. If successful, result will contain the inverted matrix.
        @param matrix The source matrix to invert.
        @param result If successful, contains the inverted matrix.
        @return True if the source matrix could be inverted; False otherwise.
    **/
    public static function tryInvert(matrix: Float2x2, result:Float2x2):Bool
    {
        var a = matrix.c0.x; var b = matrix.c1.x;
        var c = matrix.c0.y; var d = matrix.c1.y;

        var det = a * d - b * c;

        if (Math.abs(det) < Maths.EPSILON)
        {
            result = new Float2x2(
                new Float2(Math.NaN, Math.NaN),
                new Float2(Math.NaN, Math.NaN)
            );
            return false;
        }

        var invDet = 1.0 / det;

        result = new Float2x2(
            new Float2(d * invDet, -c * invDet),
            new Float2(-b * invDet, a * invDet)
        );
        return true;
    }


    /**
        Calculates the determinant of a Float2x2 matrix.
        @param m The matrix to calculate the determinant of.
        @return The determinant of the matrix.
    **/
    public static inline function determinant(m: Float2x2): Float {
        // The matrix is column-major. For [[a,b],[c,d]], the columns are c0=(a,c) and c1=(b,d).
        // The determinant is ad - bc, which corresponds to m.c0.X * m.c1.Y - m.c1.X * m.c0.Y.
        return m.c0.x * m.c1.y - m.c1.x * m.c0.y;
    }

    /**
        Creates a 2x2 matrix representing a counter-clockwise rotation by an angle in radians.
        @param angle Rotation angle in radians.
        @return The 2x2 rotation matrix.
    **/
    public static inline function rotate(angle: Float): Float2x2
    {
        var s = Math.sin(angle);
        var c = Math.cos(angle);

        return Float2x2.fromValues(c, -s, s, c);
    }

    /**
        Returns a 2x2 matrix representing a uniform scaling of both axes by s.</summary>
        @param s The scaling factor.
    **/
    public static inline function scale_1(s: Float): Float2x2 {
        return Float2x2.fromValues(s, 0.0, 0.0, s);
    }

    /// <summary>Returns a 2x2 matrix representing a non-uniform axis scaling by x and y.</summary>
    /// <param name="x">The x-axis scaling factor.</param>
    /// <param name="y">The y-axis scaling factor.</param>
    public static inline function scale_2(x: Float, y: Float): Float2x2 {
        return Float2x2.fromValues(x, 0.0, 0.0, y);
    }

    /// <summary>Returns a 2x2 matrix representing a non-uniform axis scaling by the components of the Float2 vector v.</summary>
    /// <param name="v">The Float2 containing the x and y axis scaling factors.</param>
    public static function scale_3(v: Float2): Float2x2 {
        return scale_2(v.x, v.y);
    }

    /// <summary>Returns the transpose of a Float2x2 matrix.</summary>
    /// <param name="m">The matrix to transpose.</param>
    /// <returns>The transposed matrix (Float2x2).</returns>
    public static function transpose(m: Float2x2): Float2x2 {
        return new Float2x2(
            new Float2(m.c0.x, m.c1.x),
            new Float2(m.c0.y, m.c1.y)
        );
    }


    /// <summary>Transforms a 2D normal vector using the inverse transpose of a 2x2 matrix.</summary>
    /// <param name="normal">The 2D normal vector to transform.</param>
    /// <param name="matrix">The 2x2 transformation matrix.</param>
    /// <returns>The transformed and normalized normal vector.</returns>
    public static function transformNormal(normal:Float2,  matrix:Float2x2): Float2
    {
        var inverse: Float2x2 = new Float2x2(Float2.Zero, Float2.Zero);
        // For normals, we need to use the inverse transpose of the matrix
        if (!tryInvert(matrix, inverse))
        {
            // Matrix is singular, return the original normal
            return normal;
        }
        var invTranspose: Float2x2  = transpose(inverse);
        var transformed: Float2 = invTranspose * normal;
        return Float2.normalize(transformed);
    }


}