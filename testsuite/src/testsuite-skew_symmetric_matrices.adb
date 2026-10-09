--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Orthonormal_Matrices;
with Tiny_Tensors.Float_Skew_Symmetric_Matrices;
with Tiny_Tensors.Float_Symmetric_Matrices;
with Tiny_Tensors.Float_Vectors;

package body Testsuite.Skew_Symmetric_Matrices is
   package KM renames Tiny_Tensors.Float_Skew_Symmetric_Matrices;
   package SM renames Tiny_Tensors.Float_Symmetric_Matrices;
   package DM renames Tiny_Tensors.Float_Diagonal_Matrices;
   package OM renames Tiny_Tensors.Float_Orthonormal_Matrices;
   package FV renames Tiny_Tensors.Float_Vectors;

   use Tiny_Tensors.Float_Matrices;
   use KM;
   use type FV.Vector;

   procedure Test_Construction (T : in out Trendy_Test.Operation'Class) is
      V : constant FV.Vector := [1.0, 2.0, 3.0];
      K : constant Skew_Symmetric_Matrix := KM.Skew (V);
      Empty : constant Skew_Symmetric_Matrix := KM.Zero;
      Expected : constant Matrix :=
        [[0.0, -3.0, 2.0], [3.0, 0.0, -1.0], [-2.0, 1.0, 0.0]];
   begin
      T.Register;
      T.Assert (K = [a_12 => -3.0, a_13 => 2.0, a_23 => -1.0]);
      T.Assert (To_Vector (K) = V);
      T.Assert (From_Skew_Symmetric (K) = Expected);
      T.Assert (Tiny_Tensors.Float_Matrices.Skew (V) = Expected);
      T.Assert (From_Skew_Symmetric (Empty) = Matrix'(Zero));
      T.Assert (Determinant (Empty) = 0.0);
      T.Assert (Determinant (K) = 0.0);
      T.Assert (Determinant (From_Skew_Symmetric (K)) = 0.0);
      T.Assert
        (Determinant (Skew_Symmetric_Matrix'[1.0E20, -2.0E20, 3.0E20]) = 0.0);
   end Test_Construction;

   procedure Test_Arithmetic (T : in out Trendy_Test.Operation'Class) is
      K : constant Skew_Symmetric_Matrix := [2.0, -3.0, 4.0];
      L : constant Skew_Symmetric_Matrix := [-1.0, 5.0, 2.0];
      Empty : constant Skew_Symmetric_Matrix := KM.Zero;
   begin
      T.Register;
      T.Assert (K + L = [1.0, 2.0, 6.0]);
      T.Assert (K - L = [3.0, -8.0, 2.0]);
      T.Assert (-K = [-2.0, 3.0, -4.0]);
      T.Assert (K + Empty = K);
      T.Assert (K - K = Empty);
      T.Assert (2.0 * K = [4.0, -6.0, 8.0]);
      T.Assert (K * 2.0 = [4.0, -6.0, 8.0]);
      T.Assert (0.0 * K = Empty);
      T.Assert (Transpose (K) = -K);
      T.Assert (Transpose (Transpose (K)) = K);
      T.Assert
        (From_Skew_Symmetric (Transpose (K)) =
           Transpose (From_Skew_Symmetric (K)));
      T.Assert (Frobenius_Norm_2 (K) = 58.0);
      T.Assert (abs (Frobenius_Norm (K)**2 - 58.0) < 0.0001);
      T.Assert (Frobenius_Norm (Empty) = 0.0);
      T.Assert
        (Frobenius_Norm_2 (K) = Frobenius_Norm_2 (From_Skew_Symmetric (K)));
   end Test_Arithmetic;

   procedure Test_Vector_Product (T : in out Trendy_Test.Operation'Class) is
      V : constant FV.Vector := [1.0, 2.0, 3.0];
      W : constant FV.Vector := [-2.0, 4.0, 1.0];
      K : constant Skew_Symmetric_Matrix := KM.Skew (V);
      Cross : constant FV.Vector := V * W;
   begin
      T.Register;
      T.Assert (K * W = [-10.0, -7.0, 8.0]);
      T.Assert (K * W = Cross);
      T.Assert (K * W = From_Skew_Symmetric (K) * W);
      T.Assert (K * V = [0.0, 0.0, 0.0]);
      T.Assert (KM.Zero * W = [0.0, 0.0, 0.0]);
   end Test_Vector_Product;

   procedure Test_Matrix_Products (T : in out Trendy_Test.Operation'Class) is
      K : constant Skew_Symmetric_Matrix := [2.0, -3.0, 4.0];
      L : constant Skew_Symmetric_Matrix := [-1.0, 5.0, 2.0];
      Product : constant Matrix := K * L;
   begin
      T.Register;
      T.Assert
        (Product = [[17.0, 6.0, 4.0], [-20.0, -6.0, -10.0],
                    [-4.0, -3.0, 7.0]]);
      T.Assert (Product = From_Skew_Symmetric (K) * From_Skew_Symmetric (L));
      T.Assert (K * KM.Zero = Matrix'(Zero));
      T.Assert (KM.Zero * K = Matrix'(Zero));
      T.Assert
        (K * K = [[-13.0, 12.0, 8.0], [12.0, -20.0, 6.0],
                  [8.0, 6.0, -25.0]]);
      T.Assert (K * L /= L * K);
   end Test_Matrix_Products;

   procedure Test_Adjugate_And_Gramian
     (T : in out Trendy_Test.Operation'Class) is
      K : constant Skew_Symmetric_Matrix := [2.0, -3.0, 4.0];
      Full_K : constant Matrix := From_Skew_Symmetric (K);
      Adj : constant SM.Symmetric_Matrix := SM.Adjugate (K);
      Gram : constant SM.Symmetric_Matrix := SM.Gramian (K);
      Full_Adj : constant Matrix := From_Symmetric (Adj);
      Full_Gram : constant Matrix := From_Symmetric (Gram);
   begin
      T.Register;
      T.Assert
        (Full_Adj = [[16.0, 12.0, 8.0], [12.0, 9.0, 6.0], [8.0, 6.0, 4.0]]);
      T.Assert (Full_Adj = Adjugate (Full_K));
      T.Assert (Full_K * Full_Adj = Matrix'(Zero));
      T.Assert (Full_Adj * Full_K = Matrix'(Zero));
      T.Assert (Full_Gram = Transpose (Full_K) * Full_K);
      T.Assert (Full_Gram = -(K * K));
      T.Assert (From_Symmetric (SM.Adjugate (KM.Zero)) = Matrix'(Zero));
      T.Assert (From_Symmetric (SM.Gramian (KM.Zero)) = Matrix'(Zero));
   end Test_Adjugate_And_Gramian;

   procedure Test_Mixed_Operations
     (T : in out Trendy_Test.Operation'Class) is
      K : constant Skew_Symmetric_Matrix := [2.0, -3.0, 4.0];
      Full_K : constant Matrix := From_Skew_Symmetric (K);
      M : constant Matrix :=
        [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]];
      D : constant DM.Diagonal_Matrix := [2.0, -3.0, 4.0];
      S : constant SM.Symmetric_Matrix := [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
      Q : constant OM.Orthonormal_Matrix :=
        [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]];
      Full_D : constant Matrix := From_Diagonal (D);
      Full_S : constant Matrix := From_Symmetric (S);
      Full_Q : constant Matrix := From_Orthonormal (Q);
   begin
      T.Register;
      T.Assert (K + M = Full_K + M);
      T.Assert (M + K = M + Full_K);
      T.Assert (K - M = Full_K - M);
      T.Assert (M - K = M - Full_K);
      T.Assert (K * M = Full_K * M);
      T.Assert (M * K = M * Full_K);
      T.Assert (K + D = Full_K + Full_D);
      T.Assert (D + K = Full_D + Full_K);
      T.Assert (K - D = Full_K - Full_D);
      T.Assert (D - K = Full_D - Full_K);
      T.Assert (K * D = Full_K * Full_D);
      T.Assert (D * K = Full_D * Full_K);
      T.Assert (K + S = Full_K + Full_S);
      T.Assert (S + K = Full_S + Full_K);
      T.Assert (K - S = Full_K - Full_S);
      T.Assert (S - K = Full_S - Full_K);
      T.Assert (K * S = Full_K * Full_S);
      T.Assert (S * K = Full_S * Full_K);
      T.Assert (K + Q = Full_K + Full_Q);
      T.Assert (Q + K = Full_Q + Full_K);
      T.Assert (K - Q = Full_K - Full_Q);
      T.Assert (Q - K = Full_Q - Full_K);
      T.Assert (K * Q = Full_K * Full_Q);
      T.Assert (Q * K = Full_Q * Full_K);
   end Test_Mixed_Operations;

   procedure Test_Square (T : in out Trendy_Test.Operation'Class) is
      use type SM.Symmetric_Matrix;

      type Matrix_Array is array (Positive range <>) of Skew_Symmetric_Matrix;
      Operands : constant Matrix_Array :=
        [KM.Zero, [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0],
         [2.0, -3.0, 4.0], [0.5, -0.25, 0.125]];
      K : constant Skew_Symmetric_Matrix := [2.0, -3.0, 4.0];
      Axis : constant Skew_Symmetric_Matrix := KM.Skew ([0.0, 0.0, 1.0]);
      --  Rodrigues' formula at pi/2: sin = 1, 1 - cos = 1.
      Rotation : constant Matrix :=
        Matrix'(Identity) + Axis + SM.Square (Axis);
   begin
      T.Register;
      T.Assert
        (From_Symmetric (SM.Square (K)) =
           [[-13.0, 12.0, 8.0], [12.0, -20.0, 6.0], [8.0, 6.0, -25.0]]);
      T.Assert (SM.Square (KM.Zero) = SM.Zero);

      for Operand of Operands loop
         declare
            Result : constant SM.Symmetric_Matrix := SM.Square (Operand);
         begin
            T.Assert (From_Symmetric (Result) = Operand * Operand);
            T.Assert (Result = -SM.Gramian (Operand));
            T.Assert (SM.Square (-Operand) = Result);
         end;
      end loop;

      T.Assert
        (Rotation = [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]]);
   end Test_Square;

end Testsuite.Skew_Symmetric_Matrices;
