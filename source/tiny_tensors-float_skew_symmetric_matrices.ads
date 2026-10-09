--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Sqrt;
with Tiny_Tensors.Float_Vectors;
limited with Tiny_Tensors.Float_Symmetric_Matrices;

package Tiny_Tensors.Float_Skew_Symmetric_Matrices is
   pragma Pure;

   package FV renames Tiny_Tensors.Float_Vectors;
   package SM renames Tiny_Tensors.Float_Symmetric_Matrices;

   type Skew_Symmetric_Matrix_Index is (a_12, a_13, a_23);

   type Skew_Symmetric_Matrix is
     array (Skew_Symmetric_Matrix_Index) of Float;
   --  Upper triangle of a 3x3 skew-symmetric matrix. The diagonal is zero
   --  and M (J, I) = -M (I, J).

   function Zero return Skew_Symmetric_Matrix;

   function Skew (Vector : FV.Vector) return Skew_Symmetric_Matrix;
   --  Construct the matrix for which Skew (V) * W = V cross W.

   function To_Vector (Operand : Skew_Symmetric_Matrix) return FV.Vector;
   --  Return the axial vector, the inverse of Skew.

   function Determinant (Dummy : Skew_Symmetric_Matrix) return Float is (0.0);
   --  Every 3x3 skew-symmetric matrix is singular.

   function Transpose (Operand : Skew_Symmetric_Matrix)
     return Skew_Symmetric_Matrix;

   function Frobenius_Norm (Operand : Skew_Symmetric_Matrix) return Float;

   function Frobenius_Norm_2 (Operand : Skew_Symmetric_Matrix) return Float;

   function "+" (Left, Right : Skew_Symmetric_Matrix)
     return Skew_Symmetric_Matrix;

   function "-" (Left, Right : Skew_Symmetric_Matrix)
     return Skew_Symmetric_Matrix;

   function "-" (Right : Skew_Symmetric_Matrix) return Skew_Symmetric_Matrix;

   function "*" (Left : Float; Right : Skew_Symmetric_Matrix)
     return Skew_Symmetric_Matrix;

   function "*" (Left : Skew_Symmetric_Matrix; Right : Float)
     return Skew_Symmetric_Matrix;

   function "*" (Left : Skew_Symmetric_Matrix; Right : FV.Vector)
     return FV.Vector;

   function "**"
     (Left   : Skew_Symmetric_Matrix;
      Ignore : Just_Two) return SM.Symmetric_Matrix;

private

   function Zero return Skew_Symmetric_Matrix is [others => 0.0];

   function Skew (Vector : FV.Vector) return Skew_Symmetric_Matrix is
     [a_12 => -Vector (3), a_13 => Vector (2), a_23 => -Vector (1)];

   function To_Vector (Operand : Skew_Symmetric_Matrix) return FV.Vector is
     [-Operand (a_23), Operand (a_13), -Operand (a_12)];

   function "-" (Right : Skew_Symmetric_Matrix) return Skew_Symmetric_Matrix
     is [for Item of Right => -Item];

   function Transpose (Operand : Skew_Symmetric_Matrix)
     return Skew_Symmetric_Matrix is (-Operand);

   function Frobenius_Norm_2 (Operand : Skew_Symmetric_Matrix) return Float is
     (2.0 * [for Item of Operand => Item**2]'Reduce ("+", 0.0));

   function Frobenius_Norm (Operand : Skew_Symmetric_Matrix) return Float is
     (Tiny_Tensors.Float_Sqrt (Frobenius_Norm_2 (Operand)));

   function "+" (Left, Right : Skew_Symmetric_Matrix)
     return Skew_Symmetric_Matrix is
       [for J in Left'Range => Left (J) + Right (J)];

   function "-" (Left, Right : Skew_Symmetric_Matrix)
     return Skew_Symmetric_Matrix is
       [for J in Left'Range => Left (J) - Right (J)];

   function "*" (Left : Float; Right : Skew_Symmetric_Matrix)
     return Skew_Symmetric_Matrix is
       [for J in Right'Range => Left * Right (J)];

   function "*" (Left : Skew_Symmetric_Matrix; Right : Float)
     return Skew_Symmetric_Matrix is
       [for J in Left'Range => Left (J) * Right];

   function "*" (Left : Skew_Symmetric_Matrix; Right : FV.Vector)
     return FV.Vector is
       [Left (a_12) * Right (2) + Left (a_13) * Right (3),
        -Left (a_12) * Right (1) + Left (a_23) * Right (3),
        -Left (a_13) * Right (1) - Left (a_23) * Right (2)];

end Tiny_Tensors.Float_Skew_Symmetric_Matrices;
