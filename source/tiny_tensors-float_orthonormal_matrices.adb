--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Matrices;

package body Tiny_Tensors.Float_Orthonormal_Matrices is
   use Tiny_Tensors.Float_Matrices;

   function "*"
     (Left : Orthonormal_Matrix; Right : FV.Vector) return FV.Vector is
       (From_Orthonormal (Left) * Right);

   function Determinant (Operand : Orthonormal_Matrix) return Float is
     (Determinant (From_Orthonormal (Operand)));

   function From_Diagonal
     (M : Float_Diagonal_Matrices.Diagonal_Matrix)
      return Orthonormal_Matrix is
     [[M (1), 0.0, 0.0],
      [0.0, M (2), 0.0],
      [0.0, 0.0, M (3)]];

   function "*" (Left, Right : Orthonormal_Matrix) return Orthonormal_Matrix is
      Result : constant Float_Matrices.Matrix :=
        From_Orthonormal (Left) * From_Orthonormal (Right);
   begin
      return
        [for J in 1 .. 3 =>
           [for K in 1 .. 3 =>
              Float'Max (-1.0, Float'Min (1.0, Result (J, K)))]];
   end "*";

end Tiny_Tensors.Float_Orthonormal_Matrices;
