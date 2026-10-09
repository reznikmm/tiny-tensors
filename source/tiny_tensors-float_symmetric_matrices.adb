--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Orthonormal_Matrices;

package body Tiny_Tensors.Float_Symmetric_Matrices is
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Orthonormal_Matrices;

   function "*" (L : Symmetric_Matrix; R : FV.Vector) return FV.Vector is
     [L (1 & 1) * R (1) + L (1 & 2) * R (2) + L (1 & 3) * R (3),
      L (2 & 1) * R (1) + L (2 & 2) * R (2) + L (2 & 3) * R (3),
      L (3 & 1) * R (1) + L (3 & 2) * R (2) + L (3 & 3) * R (3)];

   function "*"
     (Left : Float; Right : Symmetric_Matrix) return Symmetric_Matrix is
       [for J in Right'Range => Left * Right (J)];

   function "*"
     (Left : Symmetric_Matrix; Right : Float) return Symmetric_Matrix is
       [for J in Left'Range => Left (J) * Right];

   function "+"
     (Left  : Symmetric_Matrix;
      Right : Float_Diagonal_Matrices.Diagonal_Matrix)
      return Symmetric_Matrix is
       [a_11 => Left (1 & 1) + Right (1),
        a_12 => Left (1 & 2),
        a_13 => Left (1 & 3),
        a_22 => Left (2 & 2) + Right (2),
        a_23 => Left (2 & 3),
        a_33 => Left (3 & 3) + Right (3)];

   function "-"
     (Left  : Symmetric_Matrix;
      Right : Float_Diagonal_Matrices.Diagonal_Matrix)
      return Symmetric_Matrix is
       [a_11 => Left (1 & 1) - Right (1),
        a_12 => Left (1 & 2),
        a_13 => Left (1 & 3),
        a_22 => Left (2 & 2) - Right (2),
        a_23 => Left (2 & 3),
        a_33 => Left (3 & 3) - Right (3)];

   function "+" (Left, Right : Symmetric_Matrix) return Symmetric_Matrix is
     [a_11 => Left (1 & 1) + Right (1 & 1),
      a_12 => Left (1 & 2) + Right (1 & 2),
      a_13 => Left (1 & 3) + Right (1 & 3),
      a_22 => Left (2 & 2) + Right (2 & 2),
      a_23 => Left (2 & 3) + Right (2 & 3),
      a_33 => Left (3 & 3) + Right (3 & 3)];

   function "-" (Left, Right : Symmetric_Matrix) return Symmetric_Matrix is
     [a_11 => Left (1 & 1) - Right (1 & 1),
      a_12 => Left (1 & 2) - Right (1 & 2),
      a_13 => Left (1 & 3) - Right (1 & 3),
      a_22 => Left (2 & 2) - Right (2 & 2),
      a_23 => Left (2 & 3) - Right (2 & 3),
      a_33 => Left (3 & 3) - Right (3 & 3)];

   function Det (M : Symmetric_Matrix) return Float is
     (M (1 & 1) * (M (2 & 2) * M (3 & 3) - M (2 & 3) * M (3 & 2)) -
      M (1 & 2) * (M (2 & 1) * M (3 & 3) - M (2 & 3) * M (3 & 1)) +
      M (1 & 3) * (M (2 & 1) * M (3 & 2) - M (2 & 2) * M (3 & 1)));

   function Determinant (Operand : Symmetric_Matrix) return Float renames Det;

   function V_x_VT (Left : FV.Vector) return Symmetric_Matrix is
     [a_11 => Left (1) * Left (1),
      a_12 => Left (1) * Left (2),
      a_13 => Left (1) * Left (3),
      a_22 => Left (2) * Left (2),
      a_23 => Left (2) * Left (3),
      a_33 => Left (3) * Left (3)];

   --  function L_x_R (L, R : Symmetric_Matrix) return Symmetric_Matrix is
   --  [L (1 & 1) * R (1 & 1) + L (2 & 1) * R (2 & 1) + L (3 & 1) * R (3 & 1),
   --   L (1 & 1) * R (1 & 2) + L (2 & 1) * R (2 & 2) + L (3 & 1) * R (3 & 2),
   --   L (1 & 1) * R (1 & 3) + L (2 & 1) * R (2 & 3) + L (3 & 1) * R (3 & 3),
   --   L (1 & 2) * R (1 & 2) + L (2 & 2) * R (2 & 2) + L (3 & 2) * R (3 & 2),
   --   L (1 & 2) * R (1 & 3) + L (2 & 2) * R (2 & 3) + L (3 & 2) * R (3 & 3),
   --   L (1 & 3) * R (1 & 3) + L (2 & 3) * R (2 & 3) + L (3 & 3) * R (3 & 3)];

   --  function "*" (Left, Right : Symmetric_Matrix) return Symmetric_Matrix
   --    renames L_x_R;

   function MT_x_M (M : Float_Matrices.Matrix) return Symmetric_Matrix is
     [a_11 => M (1, 1) * M (1, 1) + M (2, 1) * M (2, 1) + M (3, 1) * M (3, 1),
      a_12 => M (1, 1) * M (1, 2) + M (2, 1) * M (2, 2) + M (3, 1) * M (3, 2),
      a_13 => M (1, 1) * M (1, 3) + M (2, 1) * M (2, 3) + M (3, 1) * M (3, 3),
      a_22 => M (1, 2) * M (1, 2) + M (2, 2) * M (2, 2) + M (3, 2) * M (3, 2),
      a_23 => M (1, 2) * M (1, 3) + M (2, 2) * M (2, 3) + M (3, 2) * M (3, 3),
      a_33 => M (1, 3) * M (1, 3) + M (2, 3) * M (2, 3) + M (3, 3) * M (3, 3)];

   function MT_x_M (M : Symmetric_Matrix) return Symmetric_Matrix is
     [M (1 & 1) * M (1 & 1) + M (1 & 2) * M (1 & 2) + M (1 & 3) * M (1 & 3),
      M (1 & 1) * M (2 & 1) + M (1 & 2) * M (2 & 2) + M (1 & 3) * M (2 & 3),
      M (1 & 1) * M (3 & 1) + M (1 & 2) * M (3 & 2) + M (1 & 3) * M (3 & 3),
      M (2 & 1) * M (2 & 1) + M (2 & 2) * M (2 & 2) + M (2 & 3) * M (2 & 3),
      M (2 & 1) * M (3 & 1) + M (2 & 2) * M (3 & 2) + M (2 & 3) * M (3 & 3),
      M (3 & 1) * M (3 & 1) + M (3 & 2) * M (3 & 2) + M (3 & 3) * M (3 & 3)];

   function M_Plus_MT (M : Float_Matrices.Matrix) return Symmetric_Matrix is
     [a_11 => M (1, 1) + M (1, 1),
      a_12 => M (1, 2) + M (2, 1),
      a_13 => M (1, 3) + M (3, 1),
      a_22 => M (2, 2) + M (2, 2),
      a_23 => M (2, 3) + M (3, 2),
      a_33 => M (3, 3) + M (3, 3)];

   function Q_A_QT_Cell
     (A : Symmetric_Matrix;
      Q : Float_Matrices.Matrix;
      J, K : Positive) return Float
   is
     (Q (J, 1) *
      (A (1 & 1) * Q (K, 1) + A (1 & 2) * Q (K, 2) + A (1 & 3) * Q (K, 3)) +
       Q (J, 2) *
      (A (2 & 1) * Q (K, 1) + A (2 & 2) * Q (K, 2) + A (2 & 3) * Q (K, 3)) +
       Q (J, 3) *
      (A (3 & 1) * Q (K, 1) + A (3 & 2) * Q (K, 2) + A (3 & 3) * Q (K, 3)));

   function Q_A_QT
     (A : Symmetric_Matrix;
      Q : Float_Matrices.Matrix) return Symmetric_Matrix is
     [a_11 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_12 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_13 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_22 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_23 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_33 => Q_A_QT_Cell (A, Q, J => 1, K => 1)];

   function Q_A_QT
     (A : Symmetric_Matrix;
      Q : Float_Orthonormal_Matrices.Orthonormal_Matrix)
      return Symmetric_Matrix is
       (Q_A_QT (A, From_Orthonormal (Q)));

   function Q_A_QT_Cell
     (A : Float_Diagonal_Matrices.Diagonal_Matrix;
      Q : Float_Matrices.Matrix;
      J, K : Positive) return Float
   is
     (Q (J, 1) * A (1) * Q (K, 1)
      + Q (J, 2) * A (2) * Q (K, 2)
      + Q (J, 3) * A (3) * Q (K, 3));

   function Q_A_QT
     (A : Float_Diagonal_Matrices.Diagonal_Matrix;
      Q : Float_Matrices.Matrix) return Symmetric_Matrix is
     [a_11 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_12 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_13 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_22 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_23 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_33 => Q_A_QT_Cell (A, Q, J => 1, K => 1)];

   function LT_x_L
     (Left : Float_Vector_Arrays.Vector_Array) return Symmetric_Matrix is
   begin
      return Result : Symmetric_Matrix := [others => 0.0] do
         for J in Index_1_3 loop
            for K in J .. 3 loop
               for I in Left'Range loop
                  Result (J & K) := @ + Left (I) (J) * Left (I) (K);
               end loop;
            end loop;
         end loop;
      end return;
   end LT_x_L;

end Tiny_Tensors.Float_Symmetric_Matrices;
