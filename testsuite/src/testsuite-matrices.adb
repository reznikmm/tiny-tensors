--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Vectors;
with Tiny_Tensors.Float_Vector_Arrays;

package body Testsuite.Matrices is
   use Slim_Test.Results;
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Vectors;

   procedure Basic_Matrix_Operations
     (T : in out Slim_Test.Results.Result)
   is
      M1 : constant Matrix := [[1.0, 2.0, 3.0],
                               [4.0, 5.0, 6.0],
                               [7.0, 8.0, 9.0]];
      M2 : constant Matrix := [[9.0, 8.0, 7.0],
                               [6.0, 5.0, 4.0],
                               [3.0, 2.0, 1.0]];
      M3 : Matrix;
   begin
      --  Test matrix addition
      M3 := M1 + M2;
      Assert (T, M3 = [[10.0, 10.0, 10.0],
                      [10.0, 10.0, 10.0],
                      [10.0, 10.0, 10.0]]);

      --  Test matrix subtraction
      M3 := M1 - M2;
      Assert (T, M3 = [[-8.0, -6.0, -4.0],
                      [-2.0,  0.0,  2.0],
                      [+4.0,  6.0,  8.0]]);

      --  Test scalar multiplication
      M3 := 2.0 * M1;
      Assert (T, M3 = [[+2.0,  4.0,  6.0],
                      [+8.0, 10.0, 12.0],
                      [14.0, 16.0, 18.0]]);

      --  Test transpose
      M3 := Transpose (M1);
      Assert (T, M3 = [[1.0, 4.0, 7.0],
                      [2.0, 5.0, 8.0],
                      [3.0, 6.0, 9.0]]);

      --  Test element access
      Assert (T, M1 (1, 1) = 1.0);
      Assert (T, M1 (2, 3) = 6.0);
      Assert (T, M1 (3, 2) = 8.0);
   end Basic_Matrix_Operations;

   procedure Test_A_x_B (T : in out Slim_Test.Results.Result) is
      A : constant Matrix :=
        [[1.0, 2.0, 3.0],
         [4.0, 5.0, 6.0],
         [7.0, 8.0, 9.0]];
      B : constant Matrix :=
        [[-8.0, -6.0, -4.0],
         [-2.0,  1.0,  3.0],
         [+4.0,  5.0,  7.0]];

      Result : constant Matrix := A * B;

      Expected : constant Matrix :=
        [[0.0, 11.0, 23.0],
         [-18.0, 11.0, 41.0],
         [-36.0, 11.0, 59.0]];
   begin
      Assert (T, Result rem Expected);
   end Test_A_x_B;

   procedure Test_Adj_1 (T : in out Slim_Test.Results.Result) is
      M : constant Matrix :=
        [[-3.0, 2.0, -5.0], [-1.0, 0.0, -2.0], [3.0, -4.0, 1.0]];

      Exp : constant Matrix :=
        [[-8.0, 18.0, -4.0], [-5.0, 12.0, -1.0], [4.0, -6.0, 2.0] ];

      Result : Matrix;
   begin
      Result := Adjugate (M);
      Assert (T, Result = Exp);
   end Test_Adj_1;

   procedure Test_Adj_2 (T : in out Slim_Test.Results.Result) is
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
      Result := Adjugate (M);
      Assert (T, Result = Exp);
   end Test_Adj_2;

   procedure Test_Matrix_x_Vector_1 (T : in out Slim_Test.Results.Result) is
      M : constant Matrix := [[1.0, 2.0, 3.0],
                              [4.0, 5.0, 6.0],
                              [7.0, 8.0, 9.0]];
      V : constant Vector := [1.0, 2.0, 3.0];
      Result : Vector;
   begin
      --  Test matrix-vector multiplication
      Result := M * V;
      Assert (T, Result = [14.0, 32.0, 50.0]);
      --  [1*1 + 2*2 + 3*3, 4*1 + 5*2 + 6*3, 7*1 + 8*2 + 9*3]
      --  [1 + 4 + 9, 4 + 10 + 18, 7 + 16 + 27] = [14, 32, 50]
   end Test_Matrix_x_Vector_1;

   procedure Test_Matrix_x_Vector_2 (T : in out Slim_Test.Results.Result) is
      --  Test with identity matrix
      Identity : constant Matrix := [[1.0, 0.0, 0.0],
                                     [0.0, 1.0, 0.0],
                                     [0.0, 0.0, 1.0]];
      V : constant Vector := [5.0, 3.0, 7.0];
      Result : Vector;
   begin
      Result := Identity * V;
      Assert (T, Result = V);  -- Identity matrix should preserve vector
   end Test_Matrix_x_Vector_2;

   procedure Test_Determinant
     (T : in out Slim_Test.Results.Result) is
   begin
      declare
         --  Test determinant of identity matrix
         Identity : constant Matrix := [[1.0, 0.0, 0.0],
                                        [0.0, 1.0, 0.0],
                                        [0.0, 0.0, 1.0]];
         Det : Float;
      begin
         Det := Determinant (Identity);
         Assert (T, abs (Det - 1.0) < 0.001);
      end;

      declare
         --  Test determinant of simple diagonal matrix
         Diag : constant Matrix := [[2.0, 0.0, 0.0],
                                    [0.0, 3.0, 0.0],
                                    [0.0, 0.0, 4.0]];
         Det : Float;
      begin
         Det := Determinant (Diag);
         Assert (T, abs (Det - 24.0) < 0.001);  -- 2 * 3 * 4 = 24
      end;

      declare
         --  Test determinant of general matrix
         M : constant Matrix := [[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]];
         Det : Float;
      begin
         Det := Determinant (M);
         Assert (T, abs (Det) < 0.001);  -- This matrix is singular (det = 0)
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
         Assert (T, abs (Det - 1.0) < 0.001);
      end;

      declare
         --  Test determinant of matrix with zero row
         Zero_Row : constant Matrix := [[1.0, 2.0, 3.0],
                                        [0.0, 0.0, 0.0],
                                        [7.0, 8.0, 9.0]];
         Det : Float;
      begin
         Det := Determinant (Zero_Row);
         Assert (T, abs (Det) < 0.001);  -- Should be 0
      end;

      declare
         --  Test determinant of triangular matrix
         Upper_Triangular : constant Matrix := [[2.0, 1.0, 3.0],
                                                [0.0, 4.0, 2.0],
                                                [0.0, 0.0, 5.0]];
         Det : Float;
      begin
         Det := Determinant (Upper_Triangular);
         Assert (T, abs (Det - 40.0) < 0.001);  -- 2 * 4 * 5 = 40
      end;
   end Test_Determinant;

   procedure Test_LT_x_R
     (T : in out Slim_Test.Results.Result) is
      use Tiny_Tensors.Float_Vector_Arrays;

      --  Test with different Left and Right
      V1 : constant Vector := [1.0, 2.0, 3.0];
      V2 : constant Vector := [4.0, 5.0, 6.0];
      V3 : constant Vector := [7.0, 8.0, 9.0];

      Left : constant Vector_Array := [V1, V2];
      Right : constant Vector_Array := [V2, V3];

      Result : Matrix;

      Expected : constant Matrix :=
         [[32.0, 37.0, 42.0], [43.0, 50.0, 57.0], [54.0, 63.0, 72.0]];

   begin
      Result := LT_x_R (Left, Right);

      Assert (T, Result rem Expected);
   end Test_LT_x_R;

   procedure Test_Inverse_1 (T : in out Slim_Test.Results.Result) is
      Unit : constant Matrix := Identity;
      Result : constant Matrix := Inverse (Unit);
   begin
      Assert (T, Result rem Unit);
   end Test_Inverse_1;

   procedure Test_Inverse_2 (T : in out Slim_Test.Results.Result) is
      Input  : constant Matrix :=
        [[1.0, 2.0, 3.0], [0.0, 1.0, 4.0], [5.0, 6.0, 0.0]];

      Expected : constant Matrix :=
        [[-24.0, 18.0, 5.0], [20.0, -15.0, -4.0], [-5.0, 4.0, 1.0]];

      Result : constant Matrix := Inverse (Input);
   begin
      Assert (T, Result rem Expected);
   end Test_Inverse_2;

   procedure Test_Inverse_3 (T : in out Slim_Test.Results.Result) is
      Input  : constant Matrix :=
        [[2.0, 1.0, 0.0], [0.0, -4.0, 2.0], [0.0, 0.0, 0.5]];

      Expected : constant Matrix :=
        [[0.5, 0.125, -0.5], [0.0, -0.25, 1.0], [0.0, 0.0, 2.0]];

      Result : constant Matrix := Inverse (Input);
   begin
      Assert (T, Result rem Expected);
   end Test_Inverse_3;

end Testsuite.Matrices;
