--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Symmetric_Matrices;
with Tiny_Tensors.Float_Vectors;
with Tiny_Tensors.Float_Vector_Arrays;

package body Testsuite.Symmetric_Matrices is
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Diagonal_Matrices;
   use Tiny_Tensors.Float_Symmetric_Matrices;
   use Tiny_Tensors.Float_Vectors;

   procedure Test_Symmetric_Adj (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
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
         --  Test matrix-vector multiplication
         Result := Adjugate (M);
         T.Assert (Result = Exp);
      end;
   end Test_Symmetric_Adj;

   procedure Test_Symmetric_Matrix_Operations
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

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

         T.Assert (S (a_11) = 66.0);
         T.Assert (S (a_12) = 78.0);
         T.Assert (S (a_13) = 90.0);
         T.Assert (S (a_22) = 93.0);
         T.Assert (S (a_23) = 108.0);
         T.Assert (S (a_33) = 126.0);

         T.Assert (S (a_11) = C (1, 1));
         T.Assert (S (a_12) = C (1, 2));
         T.Assert (S (a_13) = C (1, 3));
         T.Assert (S (a_22) = C (2, 2));
         T.Assert (S (a_23) = C (2, 3));
         T.Assert (S (a_33) = C (3, 3));
      end;

      declare
         --  Test To_Index function
         pragma Warnings (Off);
      begin
         T.Assert (To_Index (1, 1) = a_11);
         T.Assert (To_Index (1, 2) = a_12);
         T.Assert (To_Index (2, 1) = a_12);  -- Symmetric
         T.Assert (To_Index (3, 3) = a_33);

         --  Test "&" operator (alias for To_Index)
         T.Assert ((1 & 2) = a_12);
         T.Assert ((2 & 3) = a_23);
         T.Assert ((3 & 1) = a_13);
      end;

      declare
         --  Test with simple matrix
         Simple_M : constant Matrix := [[2.0, 0.0, 0.0],
                                        [0.0, 3.0, 0.0],
                                        [0.0, 0.0, 4.0]];
         S : Symmetric_Matrix;
      begin
         S := Gramian (Simple_M);
         T.Assert (S (a_11) = 4.0);   -- 2^2
         T.Assert (S (a_22) = 9.0);   -- 3^2
         T.Assert (S (a_33) = 16.0);  -- 4^2
         T.Assert (S (a_12) = 0.0);   -- Off-diagonal elements should be 0
         T.Assert (S (a_13) = 0.0);
         T.Assert (S (a_23) = 0.0);
      end;
   end Test_Symmetric_Matrix_Operations;

   procedure Test_Determinant
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
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
         T.Assert (abs (Det - Det_from_Matrix) < 0.001);
         --  Manual calculation: 4*(3*5 - 1*1) - 1*(1*5 - 1*2) + 2*(1*1 - 3*2)
         --  = 4*14 - 1*3 + 2*(-5) = 56 - 3 - 10 = 43
         T.Assert (abs (Det - 43.0) < 0.001);
      end;
   end Test_Determinant;

   procedure Test_LT_x_L_Operations
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

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
         T.Assert (abs (Result (a_11) - 1.0) < 0.001);
         T.Assert (abs (Result (a_22) - 1.0) < 0.001);
         T.Assert (abs (Result (a_33) - 1.0) < 0.001);
         T.Assert (abs (Result (a_12)) < 0.001);
         T.Assert (abs (Result (a_13)) < 0.001);
         T.Assert (abs (Result (a_23)) < 0.001);
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

         T.Assert (abs (Result (a_11) - 17.0) < 0.001);
         T.Assert (abs (Result (a_12) - 22.0) < 0.001);
         T.Assert (abs (Result (a_13) - 27.0) < 0.001);
         T.Assert (abs (Result (a_22) - 29.0) < 0.001);
         T.Assert (abs (Result (a_23) - 36.0) < 0.001);
         T.Assert (abs (Result (a_33) - 45.0) < 0.001);
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

         T.Assert (abs (Result (a_11) - 4.0) < 0.001);
         T.Assert (abs (Result (a_12) - 6.0) < 0.001);
         T.Assert (abs (Result (a_13) - 8.0) < 0.001);
         T.Assert (abs (Result (a_22) - 9.0) < 0.001);
         T.Assert (abs (Result (a_23) - 12.0) < 0.001);
         T.Assert (abs (Result (a_33) - 16.0) < 0.001);
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

         T.Assert (abs (Result (a_11) - Expected (a_11)) < 0.001);
         T.Assert (abs (Result (a_12) - Expected (a_12)) < 0.001);
         T.Assert (abs (Result (a_13) - Expected (a_13)) < 0.001);
         T.Assert (abs (Result (a_22) - Expected (a_22)) < 0.001);
         T.Assert (abs (Result (a_23) - Expected (a_23)) < 0.001);
         T.Assert (abs (Result (a_33) - Expected (a_33)) < 0.001);
      end;
   end Test_LT_x_L_Operations;

   procedure Test_Scalar_And_Mixed_Operations
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

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
         T.Assert (2.0 * S = Scaled);
         T.Assert (S * 2.0 = Scaled);
         T.Assert (From_Symmetric (S + D) = Full_S + Expanded);
         T.Assert (From_Symmetric (S - D) = Full_S - Expanded);
         T.Assert (M * S = M * Full_S);
         T.Assert (S * M = Full_S * M);
         T.Assert (M + S = M + Full_S);
         T.Assert (M - S = M - Full_S);
      end;
   end Test_Scalar_And_Mixed_Operations;

   procedure Test_Inverse (T : in out Trendy_Test.Operation'Class) is
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
      T.Register;

      for K in Operands'Range loop
         declare
            Result : constant Symmetric_Matrix := Inverse (Operands (K));
            Operand : constant Matrix := From_Symmetric (Operands (K));
            Actual : constant Matrix := From_Symmetric (Result);
            Reference : constant Matrix := From_Symmetric (Expected (K));
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


end Testsuite.Symmetric_Matrices;
