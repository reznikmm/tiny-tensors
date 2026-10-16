--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Orthonormal_Matrices;
with Tiny_Tensors.Float_Symmetric_Matrices;
with Tiny_Tensors.Float_Vectors;
with Tiny_Tensors.Float_Vector_Arrays;

package body Testsuite.Symmetric_Matrices is
   use Slim_Test.Results;
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Diagonal_Matrices;
   use Tiny_Tensors.Float_Symmetric_Matrices;
   use Tiny_Tensors.Float_Vectors;

   procedure Test_Q_A_QT (T : in out Slim_Test.Results.Result) is
      A : constant Symmetric_Matrix := [4.0, 1.0, -2.0, 3.0, 5.0, 6.0];
      D : constant Diagonal_Matrix := [4.0, 3.0, 6.0];
      Q : constant Matrix :=
        [[1.0, 2.0, 0.0], [0.0, -1.0, 3.0], [2.0, 0.0, 1.0]];
      O : constant
        Tiny_Tensors.Float_Orthonormal_Matrices.Orthonormal_Matrix :=
        [[0.0, 1.0, 0.0], [0.0, 0.0, -1.0], [1.0, 0.0, 0.0]];

      Expected : Matrix;
      Result : Symmetric_Matrix;
   begin
      Expected := Q * From_Symmetric (A) * Transpose (Q);
      Result := Q_A_QT (A, Q);

      Assert (T, From_Symmetric (Result) rem Expected);
      Assert (T, Result rem [20.0, 17.0, 20.0, 27.0, -1.0, 14.0]);

      Expected := Q * From_Diagonal (D) * Transpose (Q);
      Result := Q_A_QT (D, Q);

      Assert (T, From_Symmetric (Result) rem Expected);

      Expected := From_Orthonormal (O) * From_Symmetric (A)
        * Transpose (From_Orthonormal (O));
      Result := Q_A_QT (A, O);

      Assert (T, From_Symmetric (Result) rem Expected);
   end Test_Q_A_QT;

   procedure Test_Q_A_QT_1 (T : in out Slim_Test.Results.Result) is
      pragma Unreferenced (T);

      procedure Sink_Value (Discard : System.Address)
        with Import, External_Name => "sink_value";

      A : constant Symmetric_Matrix := [4.0, 1.0, -2.0, 3.0, 5.0, 6.0];

      Q : constant Matrix :=
        [[1.0, 2.0, 0.0], [0.0, -1.0, 3.0], [2.0, 0.0, 1.0]];

      Result : Symmetric_Matrix;
   begin
      Result := Q_A_QT (A, Q);

      Sink_Value (Result'Address);
   end Test_Q_A_QT_1;

   procedure Test_Symmetric_Adj (T : in out Slim_Test.Results.Result) is
      M : constant Symmetric_Matrix :=
        [-3.0, +2.0, -5.0,
         +0.0, -2.0,
         +1.0];

      Exp : constant Symmetric_Matrix :=
        [-4.0, +8.0,  -4.0,
         -28.0, -16.0,
         -4.0];

      Result : Symmetric_Matrix;
   begin
      Result := Adjugate (M);
      Assert (T, Result = Exp);
   end Test_Symmetric_Adj;

   procedure Test_Adj_1 (T : in out Slim_Test.Results.Result) is
      pragma Unreferenced (T);

      procedure Sink_Value (Discard : System.Address)
        with Import, External_Name => "sink_value";

      M : constant Symmetric_Matrix :=
        [-3.0, +2.0, -5.0,
         +0.0, -2.0,
         +1.0];

      Result : Symmetric_Matrix;
   begin
      Result := Adjugate (M);
      Sink_Value (Result'Address);
   end Test_Adj_1;

   procedure Test_Symmetric_Matrix_Operations
     (T : in out Slim_Test.Results.Result) is
   begin
      declare
         M : constant Matrix := [[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]];
         S : Symmetric_Matrix;
         C : constant Matrix := Transpose (M) * M;  -- For verification
      begin
         --  Test Gramian operation (M^T * M)
         S := Gramian (M);

         --  Calculate expected values manually:
         --  M^T = [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
         --  M^T * M =
         --  a_11 = 1*1 + 4*4 + 7*7 = 1 + 16 + 49 = 66
         --  a_12 = 1*2 + 4*5 + 7*8 = 2 + 20 + 56 = 78
         --  a_13 = 1*3 + 4*6 + 7*9 = 3 + 24 + 63 = 90
         --  a_22 = 2*2 + 5*5 + 8*8 = 4 + 25 + 64 = 93
         --  a_23 = 2*3 + 5*6 + 8*9 = 6 + 30 + 72 = 108
         --  a_33 = 3*3 + 6*6 + 9*9 = 9 + 36 + 81 = 126

         Assert (T, S rem [66.0, 78.0, 90.0, 93.0, 108.0, 126.0]);

         Assert (T, From_Symmetric (S) rem C);
      end;

      declare
         --  Test To_Index function
         pragma Warnings (Off);
      begin
         Assert (T, To_Index (1, 1) = a_11);
         Assert (T, To_Index (1, 2) = a_12);
         Assert (T, To_Index (2, 1) = a_12);  -- Symmetric
         Assert (T, To_Index (3, 3) = a_33);

         --  Test "&" operator (alias for To_Index)
         Assert (T, (1 & 2) = a_12);
         Assert (T, (2 & 3) = a_23);
         Assert (T, (3 & 1) = a_13);
      end;

      declare
         --  Test with simple matrix
         Simple_M : constant Matrix := [[2.0, 0.0, 0.0],
                                        [0.0, 3.0, 0.0],
                                        [0.0, 0.0, 4.0]];
         S : Symmetric_Matrix;
         Expected : constant Diagonal_Matrix := [4.0, 9.0, 16.0];
      begin
         S := Gramian (Simple_M);
         Assert (T, From_Symmetric (S) rem From_Diagonal (Expected));
      end;
   end Test_Symmetric_Matrix_Operations;

   procedure Test_Det_1 (T : in out Slim_Test.Results.Result) is
      pragma Unreferenced (T);

      procedure Sink_Value (Discard : System.Address)
        with Import, External_Name => "sink_value";

      S : constant Symmetric_Matrix :=
        (a_11 => 4.0, a_12 => 1.0, a_13 => 2.0,
         a_22 => 3.0, a_23 => 1.0, a_33 => 5.0);
      Det : constant Float := Determinant (S);
   begin
      Sink_Value (Det'Address);
   end Test_Det_1;

   procedure Test_Determinant
     (T : in out Slim_Test.Results.Result) is
      --  Test determinant of symmetric matrix
      S : constant Symmetric_Matrix :=
        (a_11 => 4.0, a_12 => 1.0, a_13 => 2.0,
         a_22 => 3.0, a_23 => 1.0, a_33 => 5.0);
      Det : Float;
      M_from_S : constant Matrix := From_Symmetric (S);
      Det_from_Matrix : Float;
   begin
      Det := Determinant (S);
      Det_from_Matrix := Determinant (M_from_S);
      --  Both should give the same result
      Assert (T, Det rem Det_from_Matrix);
      --  Manual calculation: 4*(3*5 - 1*1) - 1*(1*5 - 1*2) + 2*(1*1 - 3*2)
      --  = 4*14 - 1*3 + 2*(-5) = 56 - 3 - 10 = 43
      Assert (T, Det rem 43.0);
   end Test_Determinant;

   procedure Test_LT_x_L_Operations
     (T : in out Slim_Test.Results.Result) is
   begin
      declare
         use Tiny_Tensors.Float_Vector_Arrays;

         --  Test with simple orthogonal vectors
         V1 : constant Vector := [1.0, 0.0, 0.0];
         V2 : constant Vector := [0.0, 1.0, 0.0];
         V3 : constant Vector := [0.0, 0.0, 1.0];

         Left : constant Vector_Array := [V1, V2, V3];
         Result : Symmetric_Matrix;
      begin
         Result := LT_x_L (Left);

         --  Left^T * Right should be identity (in symmetric form)
         Assert (T, abs (Result (a_11) - 1.0) < 0.001);
         Assert (T, abs (Result (a_22) - 1.0) < 0.001);
         Assert (T, abs (Result (a_33) - 1.0) < 0.001);
         Assert (T, abs (Result (a_12)) < 0.001);
         Assert (T, abs (Result (a_13)) < 0.001);
         Assert (T, abs (Result (a_23)) < 0.001);
      end;

      declare
         use Tiny_Tensors.Float_Vector_Arrays;

         --  Test with arbitrary vectors
         V1 : constant Vector := [1.0, 2.0, 3.0];
         V2 : constant Vector := [4.0, 5.0, 6.0];

         Left : constant Vector_Array := [V1, V2];
         Result : Symmetric_Matrix;

         --  Manual calculation of L^T * R:
         --  [1 4] * [1 4] = [1*1 + 4*4   1*4 + 4*5] = [17  24]
         --  [2 5]   [2 5]   [2*1 + 5*4   2*4 + 5*5]   [22  33]
         --  [3 6]   [3 6]   [3*1 + 6*4   3*4 + 6*5]   [27  42]
         --
         --  But we want L^T * R where L and R are row vectors:
         --  L = [V1; V2] = [[1,2,3]; [4,5,6]]
         --  L^T * R = [[1,4]; [2,5]; [3,6]] * [[1,2,3]; [4,5,6]]
         --          = [[1*1+4*4, 1*2+4*5, 1*3+4*6],
         --             [2*1+5*4, 2*2+5*5, 2*3+5*6],
         --             [3*1+6*4, 3*2+6*5, 3*3+6*6]]
         --          = [[17, 22, 27],
         --             [22, 29, 36],
         --             [27, 36, 45]]
      begin
         Result := LT_x_L (Left);

         Assert (T, Result rem [17.0, 22.0, 27.0, 29.0, 36.0, 45.0]);
      end;

      declare
         use Tiny_Tensors.Float_Vector_Arrays;

         --  Test with single vector
         V : constant Vector := [2.0, 3.0, 4.0];
         Left : constant Vector_Array := [V];
         Result : Symmetric_Matrix;

         --  L^T * R = [[2]; [3]; [4]] * [[2, 3, 4]]
         --          = [[4, 6, 8],
         --             [6, 9, 12],
         --             [8, 12, 16]]
      begin
         Result := LT_x_L (Left);

         Assert (T, Result rem [4.0, 6.0, 8.0, 9.0, 12.0, 16.0]);
      end;

      declare
         use Tiny_Tensors.Float_Vector_Arrays;

         --  Test with three vectors to verify consistency with Gramian
         V1 : constant Vector := [1.0, 2.0, 3.0];
         V2 : constant Vector := [4.0, 5.0, 6.0];
         V3 : constant Vector := [7.0, 8.0, 9.0];

         Vecs : constant Vector_Array := [V1, V2, V3];
         Result : Symmetric_Matrix;
         M : constant Matrix := From_Rows (Vector_Array_3 (Vecs));
         Expected : Symmetric_Matrix;
      begin
         --  LT_x_R where Left = Right should be equivalent to Gramian
         Result := LT_x_L (Vecs);
         Expected := Gramian (M);

         Assert (T, Result rem Expected);
      end;
   end Test_LT_x_L_Operations;

   procedure Test_Scalar_And_Mixed_Operations
     (T : in out Slim_Test.Results.Result) is
   begin
      declare
         D : constant Diagonal_Matrix := [2.0, 3.0, 4.0];
         M : constant Matrix := [[1.0, 2.0, 3.0],
                                 [4.0, 5.0, 6.0],
                                 [7.0, 8.0, 9.0]];
         S : constant Symmetric_Matrix :=
           [a_11 => 1.0, a_12 => 2.0, a_13 => 3.0,
            a_22 => 4.0, a_23 => 5.0, a_33 => 6.0];
         Expanded : constant Matrix := From_Diagonal (D);
         Full_S : constant Matrix := From_Symmetric (S);
         Scaled : constant Symmetric_Matrix :=
           [a_11 => 2.0, a_12 => 4.0, a_13 => 6.0,
            a_22 => 8.0, a_23 => 10.0, a_33 => 12.0];
      begin
         Assert (T, 2.0 * S = Scaled);
         Assert (T, S * 2.0 = Scaled);
         Assert (T, From_Symmetric (S + D) = Full_S + Expanded);
         Assert (T, From_Symmetric (S - D) = Full_S - Expanded);
         Assert (T, M * S = M * Full_S);
         Assert (T, S * M = Full_S * M);
         Assert (T, M + S = M + Full_S);
         Assert (T, M - S = M - Full_S);
      end;
   end Test_Scalar_And_Mixed_Operations;

   procedure Test_Inverse (T : in out Slim_Test.Results.Result) is
      type Matrix_Array is array (Positive range <>) of Symmetric_Matrix;

      Unit : constant Symmetric_Matrix := Identity;

      Operands : constant Matrix_Array :=
        [
         Unit,
         [4.0, 1.0, 2.0, 3.0, 1.0, 5.0],
         [0.0, 1.0, 0.0, 0.0, 0.0, -2.0]];

      Expected : constant Matrix_Array :=
        [
         Unit,
         [14.0 / 43.0, -3.0 / 43.0, -5.0 / 43.0,
          16.0 / 43.0, -2.0 / 43.0, 11.0 / 43.0],
         [0.0, 1.0, 0.0, 0.0, 0.0, -0.5]];

      Full_Unit : constant Matrix := Tiny_Tensors.Float_Matrices.Identity;
   begin
      for K in Operands'Range loop
         declare
            Result : constant Symmetric_Matrix := Inverse (Operands (K));
         begin
            Assert (T, Result rem Expected (K));
         end;
      end loop;
   end Test_Inverse;


end Testsuite.Symmetric_Matrices;
