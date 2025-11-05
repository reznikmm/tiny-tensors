--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Vectors;
with Tiny_Tensors.Float_Vector_Arrays;

package Tiny_Tensors.Float_Matrices is
   pragma Pure;

   type Matrix is array (1 .. 3, 1 .. 3) of Float;
   package FV renames Tiny_Tensors.Float_Vectors;

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

   function Transpose (Left : Matrix) return Matrix;
   --  Return transpose of M

   --  function M̄ (M : Matrix) return Matrix renames Transpose;
   --  function Mᵀ (M : Matrix) return Matrix renames Transpose;

   function Determinant (Left : Matrix) return Float;
   --  Return determinant of matrix

   function "+" (Left, Right : Matrix) return Matrix;

   function "-" (Left, Right : Matrix) return Matrix;

   function "*" (Left, Right : Matrix) return Matrix;
   --  Return matrix multiplication

   function "*" (L : Matrix; R : FV.Vector) return FV.Vector;
   --  Return matrix-vector multiplication

   function "*" (Left : Float; Right : Matrix) return Matrix;
   --  Return scalar multiplication

   type Diagonal_Matrix is array (1 .. 3) of Float;
   --  Diagonal matrix represented as vector of diagonal elements

   function From_Diagonal (Left : Diagonal_Matrix) return Matrix;
   --  Convert Diagonal_Matrix to Matrix

   type Symmetric_Matrix_Index is (a_11, a_12, a_13, a_22, a_23, a_33);
   --  Index for compact form representation of symmetric matrix.

   function To_Index (Row, Column : Index_1_3) return Symmetric_Matrix_Index is
     (case Row is
        when 1 =>
           (case Column is when 1 => a_11, when 2 => a_12, when 3 => a_13),
        when 2 =>
           (case Column is when 1 => a_12, when 2 => a_22, when 3 => a_23),
        when 3 =>
           (case Column is when 1 => a_13, when 2 => a_23, when 3 => a_33))
      with Static;
   --
   --  Convert row and column indexes to symmetric matrix index type.

   function "&" (Row, Column : Index_1_3) return Symmetric_Matrix_Index
     renames To_Index;

   type Symmetric_Matrix is array (Symmetric_Matrix_Index) of Float;
   --  Symmetric matrix represented in compact form

   function From_Symmetric (Left : Symmetric_Matrix) return Matrix;
   --  Convert Symmetric_Matrix to Matrix

   function Determinant (M : Symmetric_Matrix) return Float;
   --  Return determinant of symmetric matrix

   function "*" (L : Symmetric_Matrix; R : FV.Vector) return FV.Vector;
   --  Return matrix-vector multiplication

   function "*"
     (Left : Float; Right : Symmetric_Matrix) return Symmetric_Matrix;
   --  Return scalar multiplication

   subtype Unit_Interval is Float range -1.0 .. 1.0;

   type Orthonormal_Matrix is array (1 .. 3, 1 .. 3) of Unit_Interval;
   --  Orthonormal matrix represented as 3x3 matrix with elements
   --  in -1.0 .. 1.0 range.

   function From_Orthonormal (Left : Orthonormal_Matrix) return Matrix;
   --  Convert Orthonormal_Matrix to Matrix

   function Transpose (Left : Orthonormal_Matrix) return Orthonormal_Matrix;

   function LT_x_R
    (Left, Right : Float_Vector_Arrays.Vector_Array) return Matrix
      with Pre => Left'Length = Right'Length;
   --  Return Left transpose times Right: Lᵀ x R

   function MT_x_M (M : Matrix) return Symmetric_Matrix;
   --  Return Mᵀ x M in compact form

   function "*" (Left : Matrix; Right : Diagonal_Matrix) return Matrix;
   --  Return matrix multiplication

   function "*"
    (Left : Orthonormal_Matrix; Right : Diagonal_Matrix) return Matrix;
   --  Return matrix multiplication

   function "*" (Left : Matrix; Right : Orthonormal_Matrix) return Matrix;
   --  Return matrix multiplication

private

   function Determinant (Left : Matrix) return Float is
     (Left (1, 1) * (Left (2, 2) * Left (3, 3) - Left (2, 3) * Left (3, 2)) -
      Left (1, 2) * (Left (2, 1) * Left (3, 3) - Left (2, 3) * Left (3, 1)) +
      Left (1, 3) * (Left (2, 1) * Left (3, 2) - Left (2, 2) * Left (3, 1)));

   function Determinant (M : Symmetric_Matrix) return Float is
     (M (1 & 1) * (M (2 & 2) * M (3 & 3) - M (2 & 3) * M (3 & 2)) -
      M (1 & 2) * (M (2 & 1) * M (3 & 3) - M (2 & 3) * M (3 & 1)) +
      M (1 & 3) * (M (2 & 1) * M (3 & 2) - M (2 & 2) * M (3 & 1)));

   function Transpose (Left : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (K, J)]];

   function Transpose (Left : Orthonormal_Matrix) return Orthonormal_Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (K, J)]];

   function "+" (Left, Right : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K) + Right (J, K)]];

   function "-" (Left, Right : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K) - Right (J, K)]];

   function "*" (Left, Right : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 =>
           (Left (J, 1) * Right (1, K)) +
           (Left (J, 2) * Right (2, K)) +
           (Left (J, 3) * Right (3, K))]];

   function "*" (L : Matrix; R : FV.Vector) return FV.Vector is
     [L (1, 1) * R (1) + L (1, 2) * R (2) + L (1, 3) * R (3),
      L (2, 1) * R (1) + L (2, 2) * R (2) + L (2, 3) * R (3),
      L (3, 1) * R (1) + L (3, 2) * R (2) + L (3, 3) * R (3)];

   function "*" (L : Symmetric_Matrix; R : FV.Vector) return FV.Vector is
     [L (1 & 1) * R (1) + L (1 & 2) * R (2) + L (1 & 3) * R (3),
      L (2 & 1) * R (1) + L (2 & 2) * R (2) + L (2 & 3) * R (3),
      L (3 & 1) * R (1) + L (3 & 2) * R (2) + L (3 & 3) * R (3)];

   function "*" (Left : Float; Right : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left * Right (J, K)]];

   function "*" (Left : Matrix; Right : Diagonal_Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K) * Right (K)]];

   function "*" (Left : Matrix; Right : Orthonormal_Matrix) return Matrix is
     (Left * From_Orthonormal (Right));

   function "*"
    (Left : Orthonormal_Matrix; Right : Diagonal_Matrix) return Matrix is
      (From_Orthonormal (Left) * Right);

   function "*"
     (Left : Float; Right : Symmetric_Matrix) return Symmetric_Matrix is
       [for J in Right'Range => Left * Right (J)];

   function From_Diagonal (Left : Diagonal_Matrix) return Matrix is
     [[Left (1), 0.0, 0.0],
      [0.0, Left (2), 0.0],
      [0.0, 0.0, Left (3)]];

   function From_Symmetric (Left : Symmetric_Matrix) return Matrix is
     [[Left (a_11), Left (a_12), Left (a_13)],
      [Left (a_12), Left (a_22), Left (a_23)],
      [Left (a_13), Left (a_23), Left (a_33)]];

   function From_Orthonormal (Left : Orthonormal_Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K)]];

   function MT_x_M (M : Matrix) return Symmetric_Matrix is
     [a_11 => M (1, 1) * M (1, 1) + M (2, 1) * M (2, 1) + M (3, 1) * M (3, 1),
      a_12 => M (1, 1) * M (1, 2) + M (2, 1) * M (2, 2) + M (3, 1) * M (3, 2),
      a_13 => M (1, 1) * M (1, 3) + M (2, 1) * M (2, 3) + M (3, 1) * M (3, 3),
      a_22 => M (1, 2) * M (1, 2) + M (2, 2) * M (2, 2) + M (3, 2) * M (3, 2),
      a_23 => M (1, 2) * M (1, 3) + M (2, 2) * M (2, 3) + M (3, 2) * M (3, 3),
      a_33 => M (1, 3) * M (1, 3) + M (2, 3) * M (2, 3) + M (3, 3) * M (3, 3)];

end Tiny_Tensors.Float_Matrices;
