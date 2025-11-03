--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Vectors;

package Tiny_Tensors.Float_Matrices is
pragma Pure;

   type Matrix is array (1 .. 3, 1 .. 3) of Float;
   subtype Vector is Tiny_Tensors.Float_Vectors.Vector;

   function Transpose (Left : Matrix) return Matrix;
   --  Return transpose of M

   --  function M̄ (M : Matrix) return Matrix renames Transpose;
   --  function Mᵀ (M : Matrix) return Matrix renames Transpose;

   function "+" (Left, Right : Matrix) return Matrix;

   function "-" (Left, Right : Matrix) return Matrix;

   function "*" (L : Matrix; R : Vector) return Vector;
   --  Return matrix-vector multiplication

   function "*" (Left : Float; Right : Matrix) return Matrix;
   --  Return scalar multiplication

   type Diagonal_Matrix is array (1 .. 3) of Float;
   --  Diagonal matrix represented as vector of diagonal elements

   subtype Unit_Interval is Float range -1.0 .. 1.0;

   type Orthonormal_Matrix is array (1 .. 3, 1 .. 3) of Unit_Interval;
   --  Orthonormal matrix represented as 3x3 matrix with elements
   --  in -1.0 .. 1.0 range.

   type Symmetric_Matrix_Index is (A_11, A_12, A_13, A_22, A_23, A_33);
   --  Index for compact form representation of symmetric matrix.

   function To_Index (Row, Column : Index_1_3) return Symmetric_Matrix_Index is
     (case Row is
        when 1 =>
           (case Column is when 1 => A_11, when 2 => A_12, when 3 => A_13),
        when 2 =>
           (case Column is when 1 => A_12, when 2 => A_22, when 3 => A_23),
        when 3 =>
           (case Column is when 1 => A_13, when 2 => A_23, when 3 => A_33))
      with Static;
   --
   --  Convert row and column indexes to symmetric matrix index type.

   function "&" (Row, Column : Index_1_3) return Symmetric_Matrix_Index
     renames To_Index;

   type Symmetric_Matrix is array (Symmetric_Matrix_Index) of Float;
   --  Symmetric matrix represented in compact form

   type Vector_Array is array (Positive range <>) of Vector;

   function LT_x_R (Left, Right : Vector_Array) return Matrix;
   --  Return Left transpose times Right: Lᵀ x R

   function MT_x_M (M : Matrix) return Symmetric_Matrix;
   --  Return Mᵀ x M in compact form

private

   function Transpose (Left : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (K, J)]];

   function "+" (Left, Right : Matrix) return Matrix is
     [for K in 1 .. 3 =>
        [for J in 1 .. 3 => Left (K, J) + Right (K, J)]];

   function "-" (Left, Right : Matrix) return Matrix is
     [for K in 1 .. 3 =>
        [for J in 1 .. 3 => Left (K, J) - Right (K, J)]];

   function "*" (L : Matrix; R : Vector) return Vector is
     [L (1, 1) * R (1) + L (1, 2) * R (2) + L (1, 3) * R (3),
      L (2, 1) * R (1) + L (2, 2) * R (2) + L (2, 3) * R (3),
      L (3, 1) * R (1) + L (3, 2) * R (2) + L (3, 3) * R (3)];

   function "*" (Left : Float; Right : Matrix) return Matrix is
     [for K in 1 .. 3 =>
        [for J in 1 .. 3 => Left * Right (K, J)]];

   function MT_x_M (M : Matrix) return Symmetric_Matrix is
     [A_11 => M (1, 1) * M (1, 1) + M (2, 1) * M (2, 1) + M (3, 1) * M (3, 1),
      A_12 => M (1, 1) * M (1, 2) + M (2, 1) * M (2, 2) + M (3, 1) * M (3, 2),
      A_13 => M (1, 1) * M (1, 3) + M (2, 1) * M (2, 3) + M (3, 1) * M (3, 3),
      A_22 => M (1, 2) * M (1, 2) + M (2, 2) * M (2, 2) + M (3, 2) * M (3, 2),
      A_23 => M (1, 2) * M (1, 3) + M (2, 2) * M (2, 3) + M (3, 2) * M (3, 3),
      A_33 => M (1, 3) * M (1, 3) + M (2, 3) * M (2, 3) + M (3, 3) * M (3, 3)];

end Tiny_Tensors.Float_Matrices;
