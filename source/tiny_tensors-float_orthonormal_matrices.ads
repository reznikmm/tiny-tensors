--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

limited with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Sqrt;
with Tiny_Tensors.Float_Vectors;

package Tiny_Tensors.Float_Orthonormal_Matrices is
   pragma Pure;

   package FV renames Tiny_Tensors.Float_Vectors;

   subtype Unit_Interval is Float range -1.0 .. 1.0;

   type Orthonormal_Matrix is array (1 .. 3, 1 .. 3) of Unit_Interval;
   --  Orthonormal matrix represented as 3x3 matrix with elements
   --  in -1.0 .. 1.0 range. With det (M) in 1.0 | -1.0.

   function Identity return Orthonormal_Matrix;
   --  Return an identity matrix or unit matrix. It has ones on the main
   --  diagonal and zeros elsewhere.

   function Transpose (Operand : Orthonormal_Matrix) return Orthonormal_Matrix;

   function Determinant (Operand : Orthonormal_Matrix) return Float;
   --  Return determinant of orthonormal matrix. Return -1 or 1

   function Frobenius_Norm (Operand : Orthonormal_Matrix) return Float;

   function Frobenius_Norm_2 (Operand : Orthonormal_Matrix) return Float;
   --  Return Frobenius_Norm (Operand)**2

   function From_Diagonal
     (M : Float_Diagonal_Matrices.Diagonal_Matrix)
      return Orthonormal_Matrix;
   --  Convert Diagonal_Matrix to Orthonormal_Matrix

   function "-" (Right : Orthonormal_Matrix) return Orthonormal_Matrix;
   --  Return -M. It changes sign of det (M).

   function "*" (Left, Right : Orthonormal_Matrix) return Orthonormal_Matrix;
   --  Return matrix multiplication

   function "*"
     (Left : Orthonormal_Matrix; Right : FV.Vector) return FV.Vector;
   --  Return matrix-vector multiplication

private

   function Identity return Orthonormal_Matrix is
     [[1.0, 0.0, 0.0],
      [0.0, 1.0, 0.0],
      [0.0, 0.0, 1.0]];

   function Transpose (Operand : Orthonormal_Matrix) return Orthonormal_Matrix
     is [for J in 1 .. 3 => [for K in 1 .. 3 => Operand (K, J)]];

   function Frobenius_Norm_2 (Operand : Orthonormal_Matrix) return Float is
     ([for Item of Operand => Item**2]'Reduce ("+", 0.0));

   function Frobenius_Norm (Operand : Orthonormal_Matrix) return Float is
     (Tiny_Tensors.Float_Sqrt (Frobenius_Norm_2 (Operand)));

   function "-" (Right : Orthonormal_Matrix) return Orthonormal_Matrix is
     [for J in 1 .. 3 => [for K in 1 .. 3 => -Right (K, J)]];

end Tiny_Tensors.Float_Orthonormal_Matrices;
