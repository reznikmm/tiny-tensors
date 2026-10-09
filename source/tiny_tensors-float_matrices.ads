--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

limited with Tiny_Tensors.Float_Diagonal_Matrices;
limited with Tiny_Tensors.Float_Symmetric_Matrices;
limited with Tiny_Tensors.Float_Orthonormal_Matrices;
with Tiny_Tensors.Float_Vectors;
with Tiny_Tensors.Float_Vector_Arrays;

package Tiny_Tensors.Float_Matrices is
   pragma Pure;

   package FV renames Tiny_Tensors.Float_Vectors;

   type Matrix is array (1 .. 3, 1 .. 3) of Float;

   function Zero return Matrix;
   --  Return a zero matrix or null matrix (all of whose entries are 0.0).

   function Identity return Matrix;
   --  Return an identity matrix or unit matrix. It has ones on the main
   --  diagonal and zeros elsewhere.

   function Transpose (Operand : Matrix) return Matrix;
   --  Return transpose of M

   function Determinant (Operand : Matrix) return Float;
   --  Return determinant of matrix

   function Frobenius_Norm (Operand : Matrix) return Float;

   function Frobenius_Norm_2 (Operand : Matrix) return Float;
   --  Return Frobenius_Norm (Left)**2

   subtype Vector_Array_3 is Float_Vector_Arrays.Vector_Array (1 .. 3);
   --  Array of 3 vectors

   function Rows (M : Matrix) return Vector_Array_3 is
     [for J in 1 .. 3 =>
       [M (J, 1), M (J, 2), M (J, 3)]];
   --  Return rows of matrix as array of vectors

   function Columns (M : Matrix) return Vector_Array_3 is
     [for K in 1 .. 3 =>
       [M (1, K), M (2, K), M (3, K)]];
   --  Return columns of matrix as array of vectors

   function From_Rows (M : Vector_Array_3) return Matrix is
     [for J in 1 .. 3 =>
       [for K in 1 .. 3 => M (J) (K)]];
   --  Convert array of 3 vectors to matrix (each vector is a row)

   function From_Columns (M : Vector_Array_3) return Matrix is
     [for J in 1 .. 3 =>
       [for K in 1 .. 3 => M (K) (J)]];
   --  Convert array of 3 vectors to matrix (each vector is a column)

   function "+" (Left, Right : Matrix) return Matrix;

   function "-" (Left, Right : Matrix) return Matrix;

   function "-" (Right : Matrix) return Matrix;

   function "*" (Left, Right : Matrix) return Matrix;
   --  Return matrix multiplication

   function "*" (Left, Right : FV.Vector) return Matrix;
   --  Outer product of two vectors. AKA dyadic product xȳ.

   function "*" (Left : Float; Right : Matrix) return Matrix;
   function "*" (Left : Matrix; Right : Float) return Matrix;
   --  Return scalar multiplication

   function "*" (L : Matrix; R : FV.Vector) return FV.Vector;
   --  Return matrix-vector multiplication

   function Skew (Vector : FV.Vector) return Matrix;
   --  Return skew-symmetric form of Vector. So, A*B = Skew(A)*B

   function From_Diagonal
     (M : Float_Diagonal_Matrices.Diagonal_Matrix) return Matrix;
   --  Convert Diagonal_Matrix to Matrix

   function "*"
     (Left : Matrix;
      Right : Float_Diagonal_Matrices.Diagonal_Matrix) return Matrix;
   --  Return matrix multiplication

   function "+"
     (Left : Matrix;
      Right : Float_Diagonal_Matrices.Diagonal_Matrix) return Matrix;

   function "-"
     (Left : Matrix;
      Right : Float_Diagonal_Matrices.Diagonal_Matrix) return Matrix;

   function "-"
     (Left : Float_Diagonal_Matrices.Diagonal_Matrix;
      Right : Matrix) return Matrix;

   function From_Symmetric
     (M : Float_Symmetric_Matrices.Symmetric_Matrix) return Matrix;
   --  Convert Symmetric_Matrix to Matrix

   function "*"
     (Left : Matrix;
      Right : Float_Symmetric_Matrices.Symmetric_Matrix) return Matrix;

   function "*"
     (Left : Float_Symmetric_Matrices.Symmetric_Matrix;
      Right : Matrix) return Matrix;
   --  Return matrix multiplication

   function "+"
     (Left : Matrix;
      Right : Float_Symmetric_Matrices.Symmetric_Matrix) return Matrix;

   function "-"
     (Left : Matrix;
      Right : Float_Symmetric_Matrices.Symmetric_Matrix) return Matrix;

   function LT_x_R
     (Left, Right : Float_Vector_Arrays.Vector_Array) return Matrix
       with Pre => Left'Length = Right'Length;
   --
   --  Return Left transpose times Right: Lᵀ x R

   function From_Orthonormal
     (M : Float_Orthonormal_Matrices.Orthonormal_Matrix) return Matrix;
   --  Convert Orthonormal_Matrix to Matrix

   function "*"
     (Left : Float_Orthonormal_Matrices.Orthonormal_Matrix;
      Right : Matrix) return Matrix;
   --  Return matrix multiplication

   function "*"
     (Left : Float_Orthonormal_Matrices.Orthonormal_Matrix;
      Right : Float_Diagonal_Matrices.Diagonal_Matrix) return Matrix;
   --  Return matrix multiplication

   function "*"
     (Left : Matrix;
      Right : Float_Orthonormal_Matrices.Orthonormal_Matrix) return Matrix;
   --  Return matrix multiplication

   function "*"
     (Left : Float_Symmetric_Matrices.Symmetric_Matrix;
      Right : Float_Orthonormal_Matrices.Orthonormal_Matrix) return Matrix;
   --  Return matrix multiplication

end Tiny_Tensors.Float_Matrices;
