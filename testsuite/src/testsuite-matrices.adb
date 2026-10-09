--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Assertions;

with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Vectors;
with Tiny_Tensors.Float_Vector_Arrays;

package body Testsuite.Matrices is
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Vectors;

   procedure Basic_Matrix_Operations
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
         M1 : constant Matrix := [[1.0, 2.0, 3.0],
                                  [4.0, 5.0, 6.0],
                                  [7.0, 8.0, 9.0]];
         --  M2 : constant Matrix := [[9.0, 8.0, 7.0],
         --                           [6.0, 5.0, 4.0],
         --                           [3.0, 2.0, 1.0]];
         M3 : Matrix;
      begin
         --  Test matrix addition
         --  M3 := M1 + M2;
         --  T.Assert (M3 = [[10.0, 10.0, 10.0],
         --                  [10.0, 10.0, 10.0],
         --                  [10.0, 10.0, 10.0]]);

         --  Test matrix subtraction
         --  M3 := M1 - M2;
         --  T.Assert (M3 = [[-8.0, -6.0, -4.0],
         --                  [-2.0,  0.0,  2.0],
         --                  [+4.0,  6.0,  8.0]]);

         --  Test scalar multiplication
         M3 := 2.0 * M1;
         T.Assert (M3 = [[+2.0,  4.0,  6.0],
                         [+8.0, 10.0, 12.0],
                         [14.0, 16.0, 18.0]]);

         --  Test transpose
         M3 := Transpose (M1);
         T.Assert (M3 = [[1.0, 4.0, 7.0],
                         [2.0, 5.0, 8.0],
                         [3.0, 6.0, 9.0]]);

         --  Test element access
         T.Assert (M1 (1, 1) = 1.0);
         T.Assert (M1 (2, 3) = 6.0);
         T.Assert (M1 (3, 2) = 8.0);
      end;
   end Basic_Matrix_Operations;

   procedure Test_Adj (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
         M : constant Matrix :=
           [[-3.0, 2.0, -5.0], [-1.0, 0.0, -2.0], [3.0, -4.0, 1.0]];

         Exp : constant Matrix :=
              [[-8.0, 18.0, -4.0], [-5.0, 12.0, -1.0], [4.0, -6.0, 2.0] ];

         Result : Matrix;
      begin
         --  Test matrix-vector multiplication
         Result := Adjugate (M);
         T.Assert (Result = Exp);
      end;

      declare
         M : constant Matrix :=
           [[-3.0, +2.0, -5.0],
            [+2.0, +0.0, -2.0],
            [-5.0, -2.0, +1.0]];

         Exp : constant Matrix :=
           [[-4.0, +8.0,  -4.0],
            [+8.0, -28.0, -16.0],
            [-4.0, -16.0, -4.0]];

         Result : Matrix;
      begin
         --  Test matrix-vector multiplication
         Result := Adjugate (M);
         T.Assert (Result = Exp);
      end;
   end Test_Adj;

   procedure Test_Matrix_Vector_Multiplication
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
         M : constant Matrix := [[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]];
         V : constant Vector := [1.0, 2.0, 3.0];
         Result : Vector;
      begin
         --  Test matrix-vector multiplication
         Result := M * V;
         T.Assert (Result = [14.0, 32.0, 50.0]);
         --  [1*1 + 2*2 + 3*3, 4*1 + 5*2 + 6*3, 7*1 + 8*2 + 9*3]
         --  [1 + 4 + 9, 4 + 10 + 18, 7 + 16 + 27] = [14, 32, 50]
      end;

      declare
         --  Test with identity matrix
         Identity : constant Matrix := [[1.0, 0.0, 0.0],
                                        [0.0, 1.0, 0.0],
                                        [0.0, 0.0, 1.0]];
         V : constant Vector := [5.0, 3.0, 7.0];
         Result : Vector;
      begin
         Result := Identity * V;
         T.Assert (Result = V);  -- Identity matrix should preserve vector
      end;
   end Test_Matrix_Vector_Multiplication;

   procedure Test_Determinant
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
         --  Test determinant of identity matrix
         Identity : constant Matrix := [[1.0, 0.0, 0.0],
                                        [0.0, 1.0, 0.0],
                                        [0.0, 0.0, 1.0]];
         Det : Float;
      begin
         Det := Determinant (Identity);
         T.Assert (abs (Det - 1.0) < 0.001);
      end;

      declare
         --  Test determinant of simple diagonal matrix
         Diag : constant Matrix := [[2.0, 0.0, 0.0],
                                    [0.0, 3.0, 0.0],
                                    [0.0, 0.0, 4.0]];
         Det : Float;
      begin
         Det := Determinant (Diag);
         T.Assert (abs (Det - 24.0) < 0.001);  -- 2 * 3 * 4 = 24
      end;

      declare
         --  Test determinant of general matrix
         M : constant Matrix := [[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]];
         Det : Float;
      begin
         Det := Determinant (M);
         T.Assert (abs (Det) < 0.001);  -- This matrix is singular (det = 0)
      end;

      declare
         --  Test determinant of another matrix with known result
         M : constant Matrix := [[1.0, 2.0, 3.0],
                                 [0.0, 1.0, 4.0],
                                 [5.0, 6.0, 0.0]];
         Det : Float;
      begin
         --  Calculate manually: 1*(1*0 - 4*6) - 2*(0*0 - 4*5) + 3*(0*6 - 1*5)
         --  = 1*(-24) - 2*(-20) + 3*(-5) = -24 + 40 - 15 = 1
         Det := Determinant (M);
         T.Assert (abs (Det - 1.0) < 0.001);
      end;

      declare
         --  Test determinant of matrix with zero row
         Zero_Row : constant Matrix := [[1.0, 2.0, 3.0],
                                        [0.0, 0.0, 0.0],
                                        [7.0, 8.0, 9.0]];
         Det : Float;
      begin
         Det := Determinant (Zero_Row);
         T.Assert (abs (Det) < 0.001);  -- Should be 0
      end;

      declare
         --  Test determinant of triangular matrix
         Upper_Triangular : constant Matrix := [[2.0, 1.0, 3.0],
                                                [0.0, 4.0, 2.0],
                                                [0.0, 0.0, 5.0]];
         Det : Float;
      begin
         Det := Determinant (Upper_Triangular);
         T.Assert (abs (Det - 40.0) < 0.001);  -- 2 * 4 * 5 = 40
      end;
   end Test_Determinant;

   procedure Test_LT_x_R_Operations
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
         use Tiny_Tensors.Float_Vector_Arrays;

         --  Test with different Left and Right
         V1 : constant Vector := [1.0, 2.0, 3.0];
         V2 : constant Vector := [4.0, 5.0, 6.0];
         V3 : constant Vector := [7.0, 8.0, 9.0];

         Left : constant Vector_Array := [V1, V2];
         Right : constant Vector_Array := [V2, V3];
         Result : Matrix;

      begin
         Result := LT_x_R (Left, Right);

         T.Assert (abs (Result (1, 1) - 32.0) < 0.001);
         T.Assert (abs (Result (1, 2) - 37.0) < 0.001);
         T.Assert (abs (Result (1, 3) - 42.0) < 0.001);
         T.Assert (abs (Result (2, 1) - 43.0) < 0.001);
         T.Assert (abs (Result (2, 2) - 50.0) < 0.001);
         T.Assert (abs (Result (2, 3) - 57.0) < 0.001);
         T.Assert (abs (Result (3, 1) - 54.0) < 0.001);
         T.Assert (abs (Result (3, 2) - 63.0) < 0.001);
         T.Assert (abs (Result (3, 3) - 72.0) < 0.001);
      end;
   end Test_LT_x_R_Operations;

   procedure Test_Inverse (T : in out Trendy_Test.Operation'Class) is
      type Matrix_Array is array (Positive range <>) of Matrix;

      Unit : constant Matrix := Identity;
      Operands : constant Matrix_Array :=
        [
         Unit,
         [[1.0, 2.0, 3.0], [0.0, 1.0, 4.0], [5.0, 6.0, 0.0]],
         [[2.0, 1.0, 0.0], [0.0, -4.0, 2.0], [0.0, 0.0, 0.5]]];
      Expected : constant Matrix_Array :=
        [
         Unit,
         [[-24.0, 18.0, 5.0], [20.0, -15.0, -4.0], [-5.0, 4.0, 1.0]],
         [[0.5, 0.125, -0.5], [0.0, -0.25, 1.0], [0.0, 0.0, 2.0]]];
      Full_Unit : constant Matrix := Tiny_Tensors.Float_Matrices.Identity;
   begin
      T.Register;

      for K in Operands'Range loop
         declare
            Result : constant Matrix := Inverse (Operands (K));
            Operand : constant Matrix := Operands (K);
            Actual : constant Matrix := Result;
            Reference : constant Matrix := Expected (K);
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

end Testsuite.Matrices;
