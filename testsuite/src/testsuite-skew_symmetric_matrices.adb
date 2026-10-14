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
   use Slim_Test.Results;
   package KM renames Tiny_Tensors.Float_Skew_Symmetric_Matrices;
   package SM renames Tiny_Tensors.Float_Symmetric_Matrices;
   package DM renames Tiny_Tensors.Float_Diagonal_Matrices;
   package OM renames Tiny_Tensors.Float_Orthonormal_Matrices;
   package FV renames Tiny_Tensors.Float_Vectors;

   use Tiny_Tensors.Float_Matrices;
   use KM;
   use type FV.Vector;

   procedure Test_Construction (T : in out Slim_Test.Results.Result) is
      V : constant FV.Vector := [1.0, 2.0, 3.0];
      K : constant Skew_Symmetric_Matrix := KM.Skew (V);
      Empty : constant Skew_Symmetric_Matrix := KM.Zero;
      Expected : constant Matrix :=
        [[0.0, -3.0, 2.0], [3.0, 0.0, -1.0], [-2.0, 1.0, 0.0]];
   begin
      Assert (T, K = [a_12 => -3.0, a_13 => 2.0, a_23 => -1.0]);
      Assert (T, To_Vector (K) = V);
      Assert (T, From_Skew_Symmetric (K) = Expected);
      Assert (T, Tiny_Tensors.Float_Matrices.Skew (V) = Expected);
      Assert (T, From_Skew_Symmetric (Empty) = Matrix'(Zero));
      Assert (T, Determinant (Empty) = 0.0);
      Assert (T, Determinant (K) = 0.0);
      Assert (T, Determinant (From_Skew_Symmetric (K)) = 0.0);
      Assert
        (T,
         Determinant (Skew_Symmetric_Matrix'[1.0E20, -2.0E20, 3.0E20]) = 0.0);
   end Test_Construction;

   procedure Test_Arithmetic (T : in out Slim_Test.Results.Result) is
      K : constant Skew_Symmetric_Matrix := [2.0, -3.0, 4.0];
      L : constant Skew_Symmetric_Matrix := [-1.0, 5.0, 2.0];
      Empty : constant Skew_Symmetric_Matrix := KM.Zero;
   begin
      Assert (T, K + L = [1.0, 2.0, 6.0]);
      Assert (T, K - L = [3.0, -8.0, 2.0]);
      Assert (T, -K = [-2.0, 3.0, -4.0]);
      Assert (T, K + Empty = K);
      Assert (T, K - K = Empty);
      Assert (T, 2.0 * K = [4.0, -6.0, 8.0]);
      Assert (T, K * 2.0 = [4.0, -6.0, 8.0]);
      Assert (T, 0.0 * K = Empty);
      Assert (T, Transpose (K) = -K);
      Assert (T, Transpose (Transpose (K)) = K);
      Assert (T, From_Skew_Symmetric (Transpose (K)) =
           Transpose (From_Skew_Symmetric (K)));
      Assert (T, Frobenius_Norm_2 (K) = 58.0);
      Assert (T, abs (Frobenius_Norm (K)**2 - 58.0) < 0.0001);
      Assert (T, Frobenius_Norm (Empty) = 0.0);
      Assert
        (T, Frobenius_Norm_2 (K) = Frobenius_Norm_2 (From_Skew_Symmetric (K)));
   end Test_Arithmetic;

   procedure Test_Vector_Product (T : in out Slim_Test.Results.Result) is
      V : constant FV.Vector := [1.0, 2.0, 3.0];
      W : constant FV.Vector := [-2.0, 4.0, 1.0];
      K : constant Skew_Symmetric_Matrix := KM.Skew (V);
      Cross : constant FV.Vector := V * W;
   begin
      Assert (T, K * W = [-10.0, -7.0, 8.0]);
      Assert (T, K * W = Cross);
      Assert (T, K * W = From_Skew_Symmetric (K) * W);
      Assert (T, K * V = [0.0, 0.0, 0.0]);
      Assert (T, KM.Zero * W = [0.0, 0.0, 0.0]);
   end Test_Vector_Product;

   procedure Test_Matrix_Products (T : in out Slim_Test.Results.Result) is
      K : constant Skew_Symmetric_Matrix := [2.0, -3.0, 4.0];
      L : constant Skew_Symmetric_Matrix := [-1.0, 5.0, 2.0];
      Product : constant Matrix := K * L;
   begin
      Assert (T, Product = [[17.0, 6.0, 4.0], [-20.0, -6.0, -10.0],
                    [-4.0, -3.0, 7.0]]);
      Assert (T, Product = From_Skew_Symmetric (K) * From_Skew_Symmetric (L));
      Assert (T, K * KM.Zero = Matrix'(Zero));
      Assert (T, KM.Zero * K = Matrix'(Zero));
      Assert (T, K * K = [[-13.0, 12.0, 8.0], [12.0, -20.0, 6.0],
                  [8.0, 6.0, -25.0]]);
      Assert (T, K * L /= L * K);
   end Test_Matrix_Products;

   procedure Test_Adjugate_And_Gramian
     (T : in out Slim_Test.Results.Result) is
      K : constant Skew_Symmetric_Matrix := [2.0, -3.0, 4.0];
      Full_K : constant Matrix := From_Skew_Symmetric (K);
      Adj : constant SM.Symmetric_Matrix := SM.Adjugate (K);
      Gram : constant SM.Symmetric_Matrix := SM.Gramian (K);
      Full_Adj : constant Matrix := From_Symmetric (Adj);
      Full_Gram : constant Matrix := From_Symmetric (Gram);
   begin
      Assert
        (T, Full_Adj = [[16.0, 12.0, 8.0], [12.0, 9.0, 6.0], [8.0, 6.0, 4.0]]);
      Assert (T, Full_Adj = Adjugate (Full_K));
      Assert (T, Full_K * Full_Adj = Matrix'(Zero));
      Assert (T, Full_Adj * Full_K = Matrix'(Zero));
      Assert (T, Full_Gram = Transpose (Full_K) * Full_K);
      Assert (T, Full_Gram = -(K * K));
      Assert (T, From_Symmetric (SM.Adjugate (KM.Zero)) = Matrix'(Zero));
      Assert (T, From_Symmetric (SM.Gramian (KM.Zero)) = Matrix'(Zero));
   end Test_Adjugate_And_Gramian;

   procedure Test_Mixed_Operations
     (T : in out Slim_Test.Results.Result) is
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
      Assert (T, K + M = Full_K + M);
      Assert (T, M + K = M + Full_K);
      Assert (T, K - M = Full_K - M);
      Assert (T, M - K = M - Full_K);
      Assert (T, K * M = Full_K * M);
      Assert (T, M * K = M * Full_K);
      Assert (T, K + D = Full_K + Full_D);
      Assert (T, D + K = Full_D + Full_K);
      Assert (T, K - D = Full_K - Full_D);
      Assert (T, D - K = Full_D - Full_K);
      Assert (T, K * D = Full_K * Full_D);
      Assert (T, D * K = Full_D * Full_K);
      Assert (T, K + S = Full_K + Full_S);
      Assert (T, S + K = Full_S + Full_K);
      Assert (T, K - S = Full_K - Full_S);
      Assert (T, S - K = Full_S - Full_K);
      Assert (T, K * S = Full_K * Full_S);
      Assert (T, S * K = Full_S * Full_K);
      Assert (T, K + Q = Full_K + Full_Q);
      Assert (T, Q + K = Full_Q + Full_K);
      Assert (T, K - Q = Full_K - Full_Q);
      Assert (T, Q - K = Full_Q - Full_K);
      Assert (T, K * Q = Full_K * Full_Q);
      Assert (T, Q * K = Full_Q * Full_K);
   end Test_Mixed_Operations;

   procedure Test_Square (T : in out Slim_Test.Results.Result) is
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
      Assert
        (T,
         From_Symmetric (SM.Square (K))
           = [[-13.0, 12.0, 8.0], [12.0, -20.0, 6.0], [8.0, 6.0, -25.0]]);

      Assert (T, SM.Square (KM.Zero) = SM.Zero);

      for Operand of Operands loop
         declare
            Result : constant SM.Symmetric_Matrix := SM.Square (Operand);
         begin
            Assert (T, From_Symmetric (Result) = Operand * Operand);
            Assert (T, Result = -SM.Gramian (Operand));
            Assert (T, SM.Square (-Operand) = Result);
         end;
      end loop;

      Assert
        (T, Rotation = [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]]);
   end Test_Square;

end Testsuite.Skew_Symmetric_Matrices;
