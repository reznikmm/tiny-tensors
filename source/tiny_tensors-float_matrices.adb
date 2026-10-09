--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Skew_Symmetric_Matrices;
with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Symmetric_Matrices;
with Tiny_Tensors.Float_Orthonormal_Matrices;
with Tiny_Tensors.Float_Sqrt;

package body Tiny_Tensors.Float_Matrices is
   use Tiny_Tensors.Float_Diagonal_Matrices;
   use Tiny_Tensors.Float_Symmetric_Matrices;

   function "*" (L : Matrix; R : FV.Vector) return FV.Vector is
     [L (1, 1) * R (1) + L (1, 2) * R (2) + L (1, 3) * R (3),
      L (2, 1) * R (1) + L (2, 2) * R (2) + L (2, 3) * R (3),
      L (3, 1) * R (1) + L (3, 2) * R (2) + L (3, 3) * R (3)];

   function "*"
     (Left : Matrix;
      Right : Symmetric_Matrix) return Matrix is
     (Left * From_Symmetric (Right));

   function "*"
     (Left : Symmetric_Matrix;
      Right : Matrix) return Matrix is
     (From_Symmetric (Left) * Right);

   function "*" (Left, Right : FV.Vector) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J) * Right (K)]];

   function "*" (Left : Float; Right : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left * Right (J, K)]];

   function "*" (Left : Matrix; Right : Float) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K) * Right]];

   function "*" (Left : Matrix; Right : DM.Diagonal_Matrix) return Matrix is
     [for J in 1 .. 3 => [for K in 1 .. 3 => Left (J, K) * Right (K)]];

   function "*" (Left : DM.Diagonal_Matrix; Right : Matrix) return Matrix is
     [for J in 1 .. 3 => [for K in 1 .. 3 => Left (J) * Right (J, K)]];

   function "*"
     (Left  : DM.Diagonal_Matrix; Right : SM.Symmetric_Matrix) return Matrix is
       [for J in 1 .. 3 =>
          [for K in 1 .. 3 => Left (J) * Right (J & K)]];

   function "*"
     (Left  : SM.Symmetric_Matrix; Right : DM.Diagonal_Matrix) return Matrix is
       [for J in 1 .. 3 =>
          [for K in 1 .. 3 => Left (J & K) * Right (K)]];

   function "*" (Left, Right : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 =>
           (Left (J, 1) * Right (1, K)) +
           (Left (J, 2) * Right (2, K)) +
           (Left (J, 3) * Right (3, K))]];

   function "*" (Left : Matrix; Right : OM.Orthonormal_Matrix) return Matrix is
     (Left * From_Orthonormal (Right));

   function "*" (Left : OM.Orthonormal_Matrix; Right : Matrix) return Matrix is
     (From_Orthonormal (Left) * Right);

   function "*"
     (Left : OM.Orthonormal_Matrix; Right : DM.Diagonal_Matrix) return Matrix
       is (From_Orthonormal (Left) * Right);

   function "*"
     (Left : DM.Diagonal_Matrix; Right : OM.Orthonormal_Matrix) return Matrix
       is (Left * From_Orthonormal (Right));

   function "*" (Left, Right : SM.Symmetric_Matrix) return Matrix is
     [for I in 1 .. 3 =>
        [for J in 1 .. 3 =>
           Left (I & 1) * Right (1 & J) +
           Left (I & 2) * Right (2 & J) +
           Left (I & 3) * Right (3 & J)]];

   function "*"
     (Left  : Symmetric_Matrix;
      Right : OM.Orthonormal_Matrix) return Matrix is
       [for I in 1 .. 3 =>
          [for J in 1 .. 3 =>
             Left (I & 1) * Right (1, J) +
             Left (I & 2) * Right (2, J) +
             Left (I & 3) * Right (3, J)]];

   function "*"
     (Left  : OM.Orthonormal_Matrix;
      Right : SM.Symmetric_Matrix) return Matrix is
       [for I in 1 .. 3 =>
          [for J in 1 .. 3 =>
             Left (I, 1) * Right (1 & J) +
             Left (I, 2) * Right (2 & J) +
             Left (I, 3) * Right (3 & J)]];

   function "+" (Left, Right : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K) + Right (J, K)]];

   function "-" (Left, Right : Matrix) return Matrix is
     [for J in 1 .. 3 => [for K in 1 .. 3 => Left (J, K) - Right (J, K)]];

   function "-" (Right : Matrix) return Matrix is
     [for J in 1 .. 3 => [for K in 1 .. 3 => -Right (J, K)]];

   function "+" (Left : Matrix; Right : Symmetric_Matrix) return Matrix is
     (Left + From_Symmetric (Right));

   function "+" (Left : SM.Symmetric_Matrix; Right : Matrix) return Matrix is
     (From_Symmetric (Left) + Right);

   function "-" (Left : Matrix; Right : Symmetric_Matrix) return Matrix is
     (Left - From_Symmetric (Right));

   function "-" (Left : SM.Symmetric_Matrix; Right : Matrix) return Matrix is
     (From_Symmetric (Left) - Right);

   function "+" (Left : DM.Diagonal_Matrix; Right : Matrix) return Matrix is
     (Float_Matrices.From_Diagonal (Left) + Right);

   function "+" (Left : Matrix; Right : OM.Orthonormal_Matrix) return Matrix is
     (Left + Float_Matrices.From_Orthonormal (Right));

   function "+" (Left : OM.Orthonormal_Matrix; Right : Matrix) return Matrix is
     (Float_Matrices.From_Orthonormal (Left) + Right);

   function "+" (Left : Matrix; Right : DM.Diagonal_Matrix) return Matrix is
     (Left + Float_Matrices.From_Diagonal (Right));

   function "-" (Left : Matrix; Right : DM.Diagonal_Matrix) return Matrix is
     (Left - Float_Matrices.From_Diagonal (Right));

   function "-" (Left : DM.Diagonal_Matrix; Right : Matrix) return Matrix is
     (Float_Matrices.From_Diagonal (Left) - Right);

   function "-" (Left : Matrix; Right : OM.Orthonormal_Matrix) return Matrix is
     (Left - Float_Matrices.From_Orthonormal (Right));

   function "-" (Left : OM.Orthonormal_Matrix; Right : Matrix) return Matrix is
     (Float_Matrices.From_Orthonormal (Left) - Right);

   function Adjugate (Operand : Matrix) return Matrix is
     [
      [Operand (2, 2) * Operand (3, 3) - Operand (2, 3) * Operand (3, 2),
       Operand (1, 3) * Operand (3, 2) - Operand (1, 2) * Operand (3, 3),
       Operand (1, 2) * Operand (2, 3) - Operand (1, 3) * Operand (2, 2)],
      [Operand (2, 3) * Operand (3, 1) - Operand (2, 1) * Operand (3, 3),
       Operand (1, 1) * Operand (3, 3) - Operand (1, 3) * Operand (3, 1),
       Operand (1, 3) * Operand (2, 1) - Operand (1, 1) * Operand (2, 3)],
      [Operand (2, 1) * Operand (3, 2) - Operand (2, 2) * Operand (3, 1),
       Operand (1, 2) * Operand (3, 1) - Operand (1, 1) * Operand (3, 2),
       Operand (1, 1) * Operand (2, 2) - Operand (1, 2) * Operand (2, 1)]];

   function Determinant (Operand : Matrix) return Float is
     (declare
        Cofactor : constant Matrix := Adjugate (Operand);
      begin
        Operand (1, 1) * Cofactor (1, 1)
        + Operand (2, 1) * Cofactor (1, 2)
        + Operand (3, 1) * Cofactor (1, 3));

   function From_Diagonal
     (M : DM.Diagonal_Matrix) return Matrix is
     [[M (1), 0.0, 0.0],
      [0.0, M (2), 0.0],
      [0.0, 0.0, M (3)]];

   function From_Orthonormal
     (M : OM.Orthonormal_Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => M (J, K)]];

   function From_Symmetric
     (M : Symmetric_Matrix) return Matrix is
     [[M (a_11), M (a_12), M (a_13)],
      [M (a_12), M (a_22), M (a_23)],
      [M (a_13), M (a_23), M (a_33)]];

   function Frobenius_Norm_2 (Operand : Matrix) return Float is
     ([for Item of Operand => Item**2]'Reduce ("+", 0.0));

   function Frobenius_Norm (Operand : Matrix) return Float is
     (Tiny_Tensors.Float_Sqrt (Frobenius_Norm_2 (Operand)));

   function Identity return Matrix is
     (From_Diagonal (
        DM.Diagonal_Matrix'
          ([1 .. 3 => 1.0])));

   function Inverse (Operand : Matrix) return Matrix is
      Determinant_1 : constant Float := 1.0 / Determinant (Operand);
   begin
      return Determinant_1 * Adjugate (Operand);
   end Inverse;

   function LT_x_R
     (Left, Right : Float_Vector_Arrays.Vector_Array) return Matrix is
   begin
      return Result : Matrix := [others => [others => 0.0]] do
         for I in Left'Range loop
            for J in Index_1_3 loop
               for K in Index_1_3 loop
                  Result (J, K) := @ + Left (I) (J) * Right (I) (K);
               end loop;
            end loop;
         end loop;
      end return;
   end LT_x_R;

   function Skew (Vector : FV.Vector) return Matrix is
     [[0.0,         -Vector (3), +Vector (2)],
      [+Vector (3), 0.0,         -Vector (1)],
      [-Vector (2), +Vector (1), 0.0]];

   function Transpose (Operand : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Operand (K, J)]];

   function Zero return Matrix is
     (From_Diagonal (
        DM.Diagonal_Matrix'
          ([1 .. 3 => 0.0])));

   function From_Skew_Symmetric
     (M : KM.Skew_Symmetric_Matrix) return Matrix is
       [[0.0, M (KM.a_12), M (KM.a_13)],
        [-M (KM.a_12), 0.0, M (KM.a_23)],
        [-M (KM.a_13), -M (KM.a_23), 0.0]];

   function "+"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : Matrix) return Matrix is
       (From_Skew_Symmetric (Left) + Right);

   function "+"
     (Left : Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (Left + From_Skew_Symmetric (Right));

   function "+"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : DM.Diagonal_Matrix) return Matrix is
       (From_Skew_Symmetric (Left) + From_Diagonal (Right));

   function "+"
     (Left : DM.Diagonal_Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (From_Diagonal (Left) + From_Skew_Symmetric (Right));

   function "+"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : SM.Symmetric_Matrix) return Matrix is
       (From_Skew_Symmetric (Left) + From_Symmetric (Right));

   function "+"
     (Left : SM.Symmetric_Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (From_Symmetric (Left) + From_Skew_Symmetric (Right));

   function "+"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : OM.Orthonormal_Matrix) return Matrix is
       (From_Skew_Symmetric (Left) + From_Orthonormal (Right));

   function "+"
     (Left : OM.Orthonormal_Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (From_Orthonormal (Left) + From_Skew_Symmetric (Right));

   function "-"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : Matrix) return Matrix is
       (From_Skew_Symmetric (Left) - Right);

   function "-"
     (Left : Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (Left - From_Skew_Symmetric (Right));

   function "-"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : DM.Diagonal_Matrix) return Matrix is
       (From_Skew_Symmetric (Left) - From_Diagonal (Right));

   function "-"
     (Left : DM.Diagonal_Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (From_Diagonal (Left) - From_Skew_Symmetric (Right));

   function "-"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : SM.Symmetric_Matrix) return Matrix is
       (From_Skew_Symmetric (Left) - From_Symmetric (Right));

   function "-"
     (Left : SM.Symmetric_Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (From_Symmetric (Left) - From_Skew_Symmetric (Right));

   function "-"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : OM.Orthonormal_Matrix) return Matrix is
       (From_Skew_Symmetric (Left) - From_Orthonormal (Right));

   function "-"
     (Left : OM.Orthonormal_Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (From_Orthonormal (Left) - From_Skew_Symmetric (Right));

   function "*" (Left, Right : KM.Skew_Symmetric_Matrix)
     return Matrix is
       (From_Skew_Symmetric (Left) * From_Skew_Symmetric (Right));

   function "*"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : Matrix) return Matrix is
       (From_Skew_Symmetric (Left) * Right);

   function "*"
     (Left : Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (Left * From_Skew_Symmetric (Right));

   function "*"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : DM.Diagonal_Matrix) return Matrix is
       (From_Skew_Symmetric (Left) * From_Diagonal (Right));

   function "*"
     (Left : DM.Diagonal_Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (From_Diagonal (Left) * From_Skew_Symmetric (Right));

   function "*"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : SM.Symmetric_Matrix) return Matrix is
       (From_Skew_Symmetric (Left) * From_Symmetric (Right));

   function "*"
     (Left : SM.Symmetric_Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (From_Symmetric (Left) * From_Skew_Symmetric (Right));

   function "*"
     (Left : KM.Skew_Symmetric_Matrix;
      Right : OM.Orthonormal_Matrix) return Matrix is
       (From_Skew_Symmetric (Left) * From_Orthonormal (Right));

   function "*"
     (Left : OM.Orthonormal_Matrix;
      Right : KM.Skew_Symmetric_Matrix) return Matrix is
       (From_Orthonormal (Left) * From_Skew_Symmetric (Right));

end Tiny_Tensors.Float_Matrices;
