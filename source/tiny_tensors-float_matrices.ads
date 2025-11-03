--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Wide_Character_Encoding (UTF8);
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

   type Symmetric_Matrix is record
     M_11 : Float;
     M_12 : Float;
     M_13 : Float;
     M_22 : Float;
     M_23 : Float;
     M_33 : Float;
   end record;
   --  Symmetric matrix represented in compact form

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

end Tiny_Tensors.Float_Matrices;
