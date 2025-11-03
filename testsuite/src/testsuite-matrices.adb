--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Vectors;

package body Testsuite.Matrices is
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Vectors;

   ------------------------------
   -- Basic_Matrix_Operations --
   ------------------------------

   procedure Basic_Matrix_Operations
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
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
         T.Assert (M3 = [[10.0, 10.0, 10.0],
                         [10.0, 10.0, 10.0],
                         [10.0, 10.0, 10.0]]);

         --  Test matrix subtraction
         M3 := M1 - M2;
         T.Assert (M3 = [[-8.0, -6.0, -4.0],
                         [-2.0,  0.0,  2.0],
                         [+4.0,  6.0,  8.0]]);

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

   -------------------------------------
   -- Test_Matrix_Vector_Multiplication --
   -------------------------------------

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

   ------------------------------------
   -- Test_Symmetric_Matrix_Operations --
   ------------------------------------

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
         --  Test MT_x_M operation (M^T * M)
         S := MT_x_M (M);

         --  Calculate expected values manually:
         --  M^T = [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
         --  M^T * M =
         --  A_11 = 1*1 + 4*4 + 7*7 = 1 + 16 + 49 = 66
         --  A_12 = 1*2 + 4*5 + 7*8 = 2 + 20 + 56 = 78
         --  A_13 = 1*3 + 4*6 + 7*9 = 3 + 24 + 63 = 90
         --  A_22 = 2*2 + 5*5 + 8*8 = 4 + 25 + 64 = 93
         --  A_23 = 2*3 + 5*6 + 8*9 = 6 + 30 + 72 = 108
         --  A_33 = 3*3 + 6*6 + 9*9 = 9 + 36 + 81 = 126

         T.Assert (S (A_11) = 66.0);
         T.Assert (S (A_12) = 78.0);
         T.Assert (S (A_13) = 90.0);
         T.Assert (S (A_22) = 93.0);
         T.Assert (S (A_23) = 108.0);
         T.Assert (S (A_33) = 126.0);

         T.Assert (S (A_11) = C (1, 1));
         T.Assert (S (A_12) = C (1, 2));
         T.Assert (S (A_13) = C (1, 3));
         T.Assert (S (A_22) = C (2, 2));
         T.Assert (S (A_23) = C (2, 3));
         T.Assert (S (A_33) = C (3, 3));
      end;

      declare
         --  Test To_Index function
         pragma Warnings (Off);
      begin
         T.Assert (To_Index (1, 1) = A_11);
         T.Assert (To_Index (1, 2) = A_12);
         T.Assert (To_Index (2, 1) = A_12);  -- Symmetric
         T.Assert (To_Index (3, 3) = A_33);

         --  Test "&" operator (alias for To_Index)
         T.Assert ((1 & 2) = A_12);
         T.Assert ((2 & 3) = A_23);
         T.Assert ((3 & 1) = A_13);
      end;

      declare
         --  Test with simple matrix
         Simple_M : constant Matrix := [[2.0, 0.0, 0.0],
                                        [0.0, 3.0, 0.0],
                                        [0.0, 0.0, 4.0]];
         S : Symmetric_Matrix;
      begin
         S := MT_x_M (Simple_M);
         T.Assert (S (A_11) = 4.0);   -- 2^2
         T.Assert (S (A_22) = 9.0);   -- 3^2
         T.Assert (S (A_33) = 16.0);  -- 4^2
         T.Assert (S (A_12) = 0.0);   -- Off-diagonal elements should be 0
         T.Assert (S (A_13) = 0.0);
         T.Assert (S (A_23) = 0.0);
      end;
   end Test_Symmetric_Matrix_Operations;

end Testsuite.Matrices;