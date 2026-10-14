--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Matrices;

package body Testsuite.Diagonal_Matrices is
   use Slim_Test.Results;
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Diagonal_Matrices;

   procedure Test_Diagonal_Matrix_Operations
     (T : in out Slim_Test.Results.Result) is
      D : constant Diagonal_Matrix := [2.0, 3.0, 4.0];
      M : constant Matrix := [[1.0, 2.0, 3.0],
                              [4.0, 5.0, 6.0],
                              [7.0, 8.0, 9.0]];
      Expanded : constant Matrix := From_Diagonal (D);
   begin
      Assert (T, Expanded = [[2.0, 0.0, 0.0],
                             [0.0, 3.0, 0.0],
                             [0.0, 0.0, 4.0]]);
      Assert (T, 2.0 * D = [4.0, 6.0, 8.0]);
      Assert (T, D * 2.0 = [4.0, 6.0, 8.0]);
      Assert (T, M * D = M * Expanded);
      Assert (T, M + D = M + Expanded);
      Assert (T, M - D = M - Expanded);
      Assert (T, D - M = Expanded - M);
   end Test_Diagonal_Matrix_Operations;

   procedure Test_Inverse (T : in out Slim_Test.Results.Result) is
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
   begin
      for K in Operands'Range loop
         declare
            Result : constant Diagonal_Matrix := Inverse (Operands (K));
         begin
            --  Check known values independently of the inverse algorithm.
            Assert (T, Result rem Expected (K));
            --  An inverse must cancel the operand in both orders.
            Assert (T, Operands (K) * Result rem Identity);
            Assert (T, Result * Operands (K) rem Identity);
         end;
      end loop;
   end Test_Inverse;

end Testsuite.Diagonal_Matrices;
