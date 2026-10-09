--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Sqrt;
with Tiny_Tensors.Float_Vectors;

package Tiny_Tensors.Float_Diagonal_Matrices is
   pragma Pure;

   package FV renames Tiny_Tensors.Float_Vectors;

   type Diagonal_Matrix is array (1 .. 3) of Float;
   --  Diagonal matrix represented as vector of diagonal elements

   function Zero return Diagonal_Matrix;
   --  Return a zero matrix or null matrix (all of whose entries are 0.0).

   function Identity return Diagonal_Matrix;
   --  Return an identity matrix or unit matrix. It has ones on the main
   --  diagonal.

   function Determinant (Operand : Diagonal_Matrix) return Float;
   --  Return determinant of diagonal matrix

   function Frobenius_Norm (Operand : Diagonal_Matrix) return Float;

   function Frobenius_Norm_2 (Operand : Diagonal_Matrix) return Float;
   --  Return Frobenius_Norm (Operand)**2

   function "+" (Left, Right : Diagonal_Matrix) return Diagonal_Matrix;

   function "-" (Left, Right : Diagonal_Matrix) return Diagonal_Matrix;

   function "-" (Right : Diagonal_Matrix) return Diagonal_Matrix;

   function "*" (Left, Right : Diagonal_Matrix) return Diagonal_Matrix;
   --  Return matrix multiplication

   function "*" (Left : Float; Right : Diagonal_Matrix) return Diagonal_Matrix;
   function "*" (Left : Diagonal_Matrix; Right : Float) return Diagonal_Matrix;
   --  Return scalar multiplication

   function "*" (Left : Diagonal_Matrix; Right : FV.Vector) return FV.Vector;
   --  Return matrix-vector multiplication

private

   function Identity return Diagonal_Matrix is [1 .. 3 => 1.0];

   function Zero return Diagonal_Matrix is [1 .. 3 => 0.0];

   function Determinant (Operand : Diagonal_Matrix) return Float is
     (Operand (1) * Operand (2) * Operand (3));

   function Frobenius_Norm_2 (Operand : Diagonal_Matrix) return Float is
     ([for Item of Operand => Item**2]'Reduce ("+", 0.0));

   function Frobenius_Norm (Operand : Diagonal_Matrix) return Float is
     (Tiny_Tensors.Float_Sqrt (Frobenius_Norm_2 (Operand)));

   function "+" (Left, Right : Diagonal_Matrix) return Diagonal_Matrix is
     [for J in 1 .. 3 => Left (J) + Right (J)];

   function "-" (Left, Right : Diagonal_Matrix) return Diagonal_Matrix is
     [for J in 1 .. 3 => Left (J) - Right (J)];

   function "-" (Right : Diagonal_Matrix) return Diagonal_Matrix is
     [for J in 1 .. 3 => -Right (J)];

   function "*" (Left, Right : Diagonal_Matrix) return Diagonal_Matrix is
     [for J in 1 .. 3 => Left (J) * Right (J)];

   function "*" (Left : Float; Right : Diagonal_Matrix) return Diagonal_Matrix
     is [for J in 1 .. 3 => Left * Right (J)];

   function "*" (Left : Diagonal_Matrix; Right : FV.Vector) return FV.Vector is
     [for J in 1 .. 3 => Left (J) * Right (J)];

end Tiny_Tensors.Float_Diagonal_Matrices;
