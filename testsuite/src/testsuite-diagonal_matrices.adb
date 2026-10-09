--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Assertions;

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Matrices;

package body Testsuite.Diagonal_Matrices is
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Diagonal_Matrices;

   procedure Test_Diagonal_Matrix_Operations
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
         D : constant Diagonal_Matrix := [2.0, 3.0, 4.0];
         M : constant Matrix := [[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]];
         Expanded : constant Matrix := From_Diagonal (D);
      begin
         T.Assert (Expanded = [[2.0, 0.0, 0.0],
                               [0.0, 3.0, 0.0],
                               [0.0, 0.0, 4.0]]);
         T.Assert (2.0 * D = [4.0, 6.0, 8.0]);
         T.Assert (D * 2.0 = [4.0, 6.0, 8.0]);
         T.Assert (M * D = M * Expanded);
         T.Assert (M + D = M + Expanded);
         T.Assert (M - D = M - Expanded);
         T.Assert (D - M = Expanded - M);
      end;
   end Test_Diagonal_Matrix_Operations;

   procedure Test_Inverse (T : in out Trendy_Test.Operation'Class) is
      type Matrix_Array is array (Positive range <>) of Diagonal_Matrix;

      Unit : constant Diagonal_Matrix := Identity;
      Operands : constant Matrix_Array :=
        [
         Unit,
         [2.0, -4.0, 0.5],
         [0.0001, -10_000.0, 3.0]];
      Expected : constant Matrix_Array :=
        [
         Unit,
         [0.5, -0.25, 2.0],
         [10_000.0, -0.0001, 1.0 / 3.0]];
      Full_Unit : constant Matrix := Tiny_Tensors.Float_Matrices.Identity;
   begin
      T.Register;

      for K in Operands'Range loop
         declare
            Result : constant Diagonal_Matrix := Inverse (Operands (K));
            Operand : constant Matrix := From_Diagonal (Operands (K));
            Actual : constant Matrix := From_Diagonal (Result);
            Reference : constant Matrix := From_Diagonal (Expected (K));
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

end Testsuite.Diagonal_Matrices;
