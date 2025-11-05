--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Containers.Generic_Anonymous_Array_Sort;

with Tiny_Tensors.Float_Eigen_System;
with Tiny_Tensors.Float_Vector_Arrays;
with Tiny_Tensors.Float_Vectors;
with Tiny_Tensors.Float_Sqrt;

procedure Tiny_Tensors.Float_Singular_Value_Decomposition
  (Input : Tiny_Tensors.Float_Matrices.Matrix;
   U     : out Tiny_Tensors.Float_Matrices.Orthonormal_Matrix;
   S     : out Tiny_Tensors.Float_Matrices.Diagonal_Matrix;
   V     : out Tiny_Tensors.Float_Matrices.Orthonormal_Matrix)
is
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Vector_Arrays;

   function SQRT (X : Float) return Float is
     (if X < 0.0 then 0.0 else Tiny_Tensors.Float_Sqrt (X));

   function To_Orthonormal (Left : Matrix) return Orthonormal_Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K)]];

   BT_B    : constant Float_Matrices.Symmetric_Matrix :=
     Float_Matrices.MT_x_M (Input);

   Values  : Tiny_Tensors.Float_Matrices.Diagonal_Matrix;
   Vectors : Tiny_Tensors.Float_Matrices.Vector_Array_3;

   procedure Swap (Left, Right : Positive);

   function More (Left, Right : Positive) return Boolean is
     (Values (Left) > Values (Right) or
       (Values (Left) = Values (Right) and Left > Right));

   ----------
   -- Swap --
   ----------

   procedure Swap (Left, Right : Positive) is
      Tmp_V : Float := Values (Left);
      Tmp_M : Float_Vectors.Vector := Vectors (Left);
   begin
      Values (Left) := Values (Right);
      Values (Right) := Tmp_V;
      Vectors (Left) := Vectors (Right);
      Vectors (Right) := Tmp_M;
   end Swap;

   procedure Sort is new
     Ada.Containers.Generic_Anonymous_Array_Sort (Positive, More, Swap);
begin
   Float_Eigen_System.Get_Eigen_System (BT_B, Values, Vectors);

   Sort (1, 3);

   V := To_Orthonormal (From_Columns (Vectors));

   S := [for J in 1 .. 3 => SQRT (Values (J))];

   declare
      Inv : constant Diagonal_Matrix :=
        [for J in 1 .. 3 => (if S (J) = 0.0 then 0.0 else 1.0 / S (J))];

      T : constant Matrix := Input * V * Inv;

      Norm : constant Matrix := From_Rows (Normalize (Rows (T)));
   begin
      U := To_Orthonormal (Norm);
   end;

end Tiny_Tensors.Float_Singular_Value_Decomposition;
