--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Orthonormal_Matrices;
with Tiny_Tensors.Float_Symmetric_Matrices;
with Tiny_Tensors.Float_Vectors;

package body Testsuite.Orthonormal_Matrices is
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Diagonal_Matrices;
   use Tiny_Tensors.Float_Orthonormal_Matrices;
   use Tiny_Tensors.Float_Symmetric_Matrices;
   use Tiny_Tensors.Float_Vectors;

   procedure Test_Orthonormal_Matrix_Operations
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
         Q : constant Orthonormal_Matrix := [[0.0, -1.0, 0.0],
                                             [1.0,  0.0, 0.0],
                                             [0.0,  0.0, 1.0]];
         D : constant Diagonal_Matrix := [2.0, 3.0, 4.0];
         M : constant Matrix := [[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]];
         S : constant Symmetric_Matrix :=
           [a_11 => 1.0, a_12 => 2.0, a_13 => 3.0,
            a_22 => 4.0, a_23 => 5.0, a_33 => 6.0];
         V : constant Vector := [1.0, 2.0, 3.0];
         Expanded : constant Matrix := From_Orthonormal (Q);
         Reflection : constant Orthonormal_Matrix :=
           [[1.0, 0.0, 0.0], [0.0, -1.0, 0.0], [0.0, 0.0, 1.0]];
         Unit : constant Orthonormal_Matrix := Identity;
         Empty : constant Orthonormal_Matrix := [others => [others => 0.0]];
         Full_Unit : constant Matrix := Identity;
         Full_Empty : constant Matrix := Zero;
      begin
         T.Assert (Full_Unit = From_Orthonormal (Unit));
         T.Assert (Full_Empty = From_Orthonormal (Empty));
         T.Assert (Determinant (Q) = 1.0);
         T.Assert (Determinant (Reflection) = -1.0);
         T.Assert (Q * Transpose (Q) = Unit);
         T.Assert (From_Orthonormal (Q * Q) = Expanded * Expanded);
         T.Assert (Q * V = [-2.0, 1.0, 3.0]);
         T.Assert (Q * M = Expanded * M);
         T.Assert (M * Q = M * Expanded);
         T.Assert
           (Q * D = Expanded * Tiny_Tensors.Float_Matrices.From_Diagonal (D));
         T.Assert (S * Q = From_Symmetric (S) * Expanded);
      end;
   end Test_Orthonormal_Matrix_Operations;

   procedure Test_Inverse (T : in out Trendy_Test.Operation'Class) is
      type Matrix_Array is array (Positive range <>) of Orthonormal_Matrix;

      Unit : constant Orthonormal_Matrix := Identity;

      Operands : constant Matrix_Array :=
        [
         Unit,
         [[0.6, -0.8, 0.0], [0.8, 0.6, 0.0], [0.0, 0.0, 1.0]],
         [[1.0, 0.0, 0.0], [0.0, -1.0, 0.0], [0.0, 0.0, 1.0]]];

      Expected : constant Matrix_Array :=
        [
         Unit,
         [[0.6, 0.8, 0.0], [-0.8, 0.6, 0.0], [0.0, 0.0, 1.0]],
         [[1.0, 0.0, 0.0], [0.0, -1.0, 0.0], [0.0, 0.0, 1.0]]];

      Full_Unit : constant Matrix := Tiny_Tensors.Float_Matrices.Identity;
   begin
      T.Register;

      for K in Operands'Range loop
         declare
            Result : constant Orthonormal_Matrix := Inverse (Operands (K));
            Operand : constant Matrix := From_Orthonormal (Operands (K));
            Actual : constant Matrix := From_Orthonormal (Result);
            Reference : constant Matrix := From_Orthonormal (Expected (K));
         begin
            --  Check known values independently of the inverse algorithm.
            T.Assert
              (for all I in 1 .. 3 =>
                 (for all J in 1 .. 3 =>
                    abs (Actual (I, J) - Reference (I, J))
                      <= 0.00001 * Float'Max (1.0, abs (Reference (I, J)))));
            --  An inverse must cancel the operand in both orders.
            T.Assert (Frobenius_Norm (Operand * Actual - Full_Unit) < 0.0001);
            T.Assert (Frobenius_Norm (Actual * Operand - Full_Unit) < 0.0001);
         end;
      end loop;
   end Test_Inverse;

end Testsuite.Orthonormal_Matrices;
