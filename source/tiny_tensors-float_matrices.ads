--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Vectors;
with Tiny_Tensors.Float_Vector_Arrays;
with Tiny_Tensors.Float_Sqrt;

package Tiny_Tensors.Float_Matrices is
   pragma Pure;

   type Matrix is array (1 .. 3, 1 .. 3) of Float;

   package FV renames Tiny_Tensors.Float_Vectors;

   subtype Vector_Array_3 is Float_Vector_Arrays.Vector_Array (1 .. 3);
   --  Array of 3 vectors

   function Rows (M : Matrix) return Vector_Array_3 is
     [for J in 1 .. 3 =>
       [M (J, 1), M (J, 2), M (J, 3)]];
   --  Return rows of matrix as array of vectors

   function Columns (M : Matrix) return Vector_Array_3 is
     [for K in 1 .. 3 =>
       [M (1, K), M (2, K), M (3, K)]];
   --  Return columns of matrix as array of vectors

   function From_Rows (M : Vector_Array_3) return Matrix is
     [for J in 1 .. 3 =>
       [for K in 1 .. 3 => M (J) (K)]];
   --  Convert array of 3 vectors to matrix (each vector is a row)

   function From_Columns (M : Vector_Array_3) return Matrix is
     [for J in 1 .. 3 =>
       [for K in 1 .. 3 => M (K) (J)]];
   --  Convert array of 3 vectors to matrix (each vector is a column)

   function Transpose (Left : Matrix) return Matrix;
   --  Return transpose of M

   --  function M̄ (M : Matrix) return Matrix renames Transpose;
   --  function Mᵀ (M : Matrix) return Matrix renames Transpose;

   function Determinant (Left : Matrix) return Float;
   --  Return determinant of matrix

   function "+" (Left, Right : Matrix) return Matrix;

   function "-" (Left, Right : Matrix) return Matrix;

   function "*" (Left, Right : Matrix) return Matrix;
   --  Return matrix multiplication

   function "*" (Left, Right : FV.Vector) return Matrix;
   --  Outer product of two vectors. AKA dyadic product xȳ.

   function "*" (L : Matrix; R : FV.Vector) return FV.Vector;
   --  Return matrix-vector multiplication

   function "*" (Left : Float; Right : Matrix) return Matrix;
   function "*" (Left : Matrix; Right : Float) return Matrix;
   --  Return scalar multiplication

   function Skew (Vector : FV.Vector) return Matrix;
   --  Return skew-symmetric form of Vector. So, A*B = Skew(A)*B

   function Frobenius_Norm (M : Matrix) return Float;
   function Frobenius_Norm_2 (M : Matrix) return Float;

   ---------------------
   -- Diagonal_Matrix --
   ---------------------

   type Diagonal_Matrix is array (1 .. 3) of Float;
   --  Diagonal matrix represented as vector of diagonal elements

   function From_Diagonal (Left : Diagonal_Matrix) return Matrix;
   --  Convert Diagonal_Matrix to Matrix

   function "*" (Left : Matrix; Right : Diagonal_Matrix) return Matrix;
   --  Return matrix multiplication

   function "*" (Left : Float; Right : Diagonal_Matrix) return Diagonal_Matrix;
   function "*" (Left : Diagonal_Matrix; Right : Float) return Diagonal_Matrix;
   --  Return scalar multiplication

   function "+" (Left : Matrix; Right : Diagonal_Matrix) return Matrix;
   function "-" (Left : Matrix; Right : Diagonal_Matrix) return Matrix;
   function "-" (Left : Diagonal_Matrix; Right : Matrix) return Matrix;

   function Zero return Matrix is
     (From_Diagonal ([1 .. 3 => 0.0]));

   function Identity return Matrix is
     (From_Diagonal ([1 .. 3 => 1.0]));

   ----------------------
   -- Symmetric_Matrix --
   ----------------------

   type Symmetric_Matrix_Index is (a_11, a_12, a_13, a_22, a_23, a_33);
   --  Index for compact form representation of symmetric matrix.

   function To_Index (Row, Column : Index_1_3) return Symmetric_Matrix_Index is
     (case Row is
        when 1 =>
           (case Column is when 1 => a_11, when 2 => a_12, when 3 => a_13),
        when 2 =>
           (case Column is when 1 => a_12, when 2 => a_22, when 3 => a_23),
        when 3 =>
           (case Column is when 1 => a_13, when 2 => a_23, when 3 => a_33))
      with Static;
   --
   --  Convert row and column indexes to symmetric matrix index type.

   function "&" (Row, Column : Index_1_3) return Symmetric_Matrix_Index
     renames To_Index;
   --
   --  A shortcut to use like this: M (1 & 3) = M (a_13)

   type Symmetric_Matrix is array (Symmetric_Matrix_Index) of Float;
   --  Symmetric matrix represented in compact form

   function From_Symmetric (Left : Symmetric_Matrix) return Matrix;
   --  Convert Symmetric_Matrix to Matrix

   function Determinant (M : Symmetric_Matrix) return Float;
   --  Return determinant of symmetric matrix

   function "*" (L : Symmetric_Matrix; R : FV.Vector) return FV.Vector;
   --  Return matrix-vector multiplication

   function "*" (Left, Right : Symmetric_Matrix) return Symmetric_Matrix;

   function "*" (Left : Matrix; Right : Symmetric_Matrix) return Matrix;
   function "*" (Left : Symmetric_Matrix; Right : Matrix) return Matrix;
   --  Return matrix multiplication

   function "*"
     (Left : Float; Right : Symmetric_Matrix) return Symmetric_Matrix;
   function "*"
     (Left : Symmetric_Matrix; Right : Float) return Symmetric_Matrix;
   --  Return scalar multiplication

   function "+" (Left, Right : Symmetric_Matrix) return Symmetric_Matrix;

   function "-" (Left, Right : Symmetric_Matrix) return Symmetric_Matrix;

   function "+"
     (Left  : Symmetric_Matrix;
      Right : Diagonal_Matrix) return Symmetric_Matrix;

   function "-"
     (Left  : Symmetric_Matrix;
      Right : Diagonal_Matrix) return Symmetric_Matrix;

   function "+" (Left : Matrix; Right : Symmetric_Matrix) return Matrix;
   function "-" (Left : Matrix; Right : Symmetric_Matrix) return Matrix;

   function LT_x_R
     (Left, Right : Float_Vector_Arrays.Vector_Array) return Matrix
       with Pre => Left'Length = Right'Length;
   --
   --  Return Left transpose times Right: Lᵀ x R

   function LT_x_L
     (Left : Float_Vector_Arrays.Vector_Array) return Symmetric_Matrix;
   --
   --  Return Left transpose times Left: Lᵀ x L

   function V_x_VT (Left : FV.Vector) return Symmetric_Matrix;
   --
   --  Return Left times Left transpose: L x Lᵀ

   function MT_x_M (M : Matrix) return Symmetric_Matrix;
   --  Return Mᵀ x M in compact form

   function MT_x_M (M : Symmetric_Matrix) return Symmetric_Matrix;
   --  Return Mᵀ x M in compact form

   function M_Plus_MT (M : Matrix) return Symmetric_Matrix;
   --  Return M + Mᵀ in compact form

   function Zero return Symmetric_Matrix is ([others => 0.0]);

   function Identity return Symmetric_Matrix is
     [a_11 | a_22 | a_33 => 1.0, others => 0.0];


   ------------------------
   -- Orthonormal_Matrix --
   ------------------------

   subtype Unit_Interval is Float range -1.0 .. 1.0;

   type Orthonormal_Matrix is array (1 .. 3, 1 .. 3) of Unit_Interval;
   --  Orthonormal matrix represented as 3x3 matrix with elements
   --  in -1.0 .. 1.0 range.

   function From_Orthonormal (Left : Orthonormal_Matrix) return Matrix;
   --  Convert Orthonormal_Matrix to Matrix

   function From_Diagonal (Left : Diagonal_Matrix) return Orthonormal_Matrix;
   --  Convert Diagonal_Matrix to Orthonormal_Matrix

   function Zero return Orthonormal_Matrix is
     (From_Diagonal ([1 .. 3 => 0.0]));

   function Identity return Orthonormal_Matrix is
     (From_Diagonal ([1 .. 3 => 1.0]));

   function Determinant (M : Orthonormal_Matrix) return Float;
   --  Return determinant of orthonormal matrix. Return -1 or 1

   function Transpose (Left : Orthonormal_Matrix) return Orthonormal_Matrix;

   function "*" (Left : Orthonormal_Matrix; Right : Matrix) return Matrix;
   --  Return matrix multiplication

   function "*"
     (Left : Orthonormal_Matrix; Right : Diagonal_Matrix) return Matrix;
   --  Return matrix multiplication

   function "*" (Left : Matrix; Right : Orthonormal_Matrix) return Matrix;
   --  Return matrix multiplication

   function "*"
     (Left : Symmetric_Matrix; Right : Orthonormal_Matrix) return Matrix;
   --  Return matrix multiplication

   function "*" (Left, Right : Orthonormal_Matrix) return Orthonormal_Matrix;
   --  Return matrix multiplication

   function "*" (L : Orthonormal_Matrix; R : FV.Vector) return FV.Vector;
   --  Return matrix-vector multiplication

   function Q_A_QT (A : Symmetric_Matrix; Q : Orthonormal_Matrix)
     return Symmetric_Matrix;
   --  Return QAQᵀ in compact form

   function Q_A_QT (A : Symmetric_Matrix; Q : Matrix) return Symmetric_Matrix;
   --  Return QAQᵀ in compact form

   function Q_A_QT (A : Diagonal_Matrix; Q : Matrix) return Symmetric_Matrix;
   --  Return QAQᵀ in compact form

private

   function "*" (L : Matrix; R : FV.Vector) return FV.Vector is
     [L (1, 1) * R (1) + L (1, 2) * R (2) + L (1, 3) * R (3),
      L (2, 1) * R (1) + L (2, 2) * R (2) + L (2, 3) * R (3),
      L (3, 1) * R (1) + L (3, 2) * R (2) + L (3, 3) * R (3)];

   function "*" (L : Orthonormal_Matrix; R : FV.Vector) return FV.Vector is
     (From_Orthonormal (L) * R);

   function "*" (L : Symmetric_Matrix; R : FV.Vector) return FV.Vector is
     [L (1 & 1) * R (1) + L (1 & 2) * R (2) + L (1 & 3) * R (3),
      L (2 & 1) * R (1) + L (2 & 2) * R (2) + L (2 & 3) * R (3),
      L (3 & 1) * R (1) + L (3 & 2) * R (2) + L (3 & 3) * R (3)];

   function "*" (Left : Matrix; Right : Symmetric_Matrix) return Matrix is
     (Left * From_Symmetric (Right));

   function "*" (Left : Symmetric_Matrix; Right : Matrix) return Matrix is
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

   function "*"
     (Left : Float; Right : Symmetric_Matrix) return Symmetric_Matrix is
       [for J in Right'Range => Left * Right (J)];

   function "*"
     (Left : Symmetric_Matrix; Right : Float) return Symmetric_Matrix is
       [for J in Left'Range => Left (J) * Right];

   function "*" (Left : Matrix; Right : Diagonal_Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K) * Right (K)]];

   function "*" (Left : Float; Right : Diagonal_Matrix) return Diagonal_Matrix
     is [for J in 1 .. 3 => Left * Right (J)];

   function "*" (Left : Diagonal_Matrix; Right : Float) return Diagonal_Matrix
     is [for J in 1 .. 3 => Left (J) * Right];

   function "*" (Left, Right : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 =>
           (Left (J, 1) * Right (1, K)) +
           (Left (J, 2) * Right (2, K)) +
           (Left (J, 3) * Right (3, K))]];

   function "*" (Left : Matrix; Right : Orthonormal_Matrix) return Matrix is
     (Left * From_Orthonormal (Right));

   function "*" (Left : Orthonormal_Matrix; Right : Matrix) return Matrix is
     (From_Orthonormal (Left) * Right);

   function "*"
    (Left : Orthonormal_Matrix; Right : Diagonal_Matrix) return Matrix is
      (From_Orthonormal (Left) * Right);

   function "*"
     (Left : Symmetric_Matrix; Right : Orthonormal_Matrix) return Matrix is
       [for I in 1 .. 3 =>
          [for J in 1 .. 3 =>
             Left (I & 1) * Right (1, J) +
             Left (I & 2) * Right (2, J) +
             Left (I & 3) * Right (3, J)]];

   function "+" (Left, Right : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K) + Right (J, K)]];

   function "-" (Left, Right : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K) - Right (J, K)]];

   function "+"
     (Left  : Symmetric_Matrix;
      Right : Diagonal_Matrix) return Symmetric_Matrix is
       [a_11 => Left (1 & 1) + Right (1),
        a_12 => Left (1 & 2),
        a_13 => Left (1 & 3),
        a_22 => Left (2 & 2) + Right (2),
        a_23 => Left (2 & 3),
        a_33 => Left (3 & 3) + Right (3)];

   function "-"
     (Left  : Symmetric_Matrix;
      Right : Diagonal_Matrix) return Symmetric_Matrix is
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

   function "+" (Left : Matrix; Right : Symmetric_Matrix) return Matrix is
      (Left + From_Symmetric (Right));
   function "-" (Left : Matrix; Right : Symmetric_Matrix) return Matrix is
      (Left - From_Symmetric (Right));

   function "+" (Left : Matrix; Right : Diagonal_Matrix) return Matrix is
      (Left + From_Diagonal (Right));
   function "-" (Left : Matrix; Right : Diagonal_Matrix) return Matrix is
      (Left - From_Diagonal (Right));
   function "-" (Left : Diagonal_Matrix; Right : Matrix) return Matrix is
      (From_Diagonal (Left) - Right);

   function Determinant (Left : Matrix) return Float is
     (Left (1, 1) * (Left (2, 2) * Left (3, 3) - Left (2, 3) * Left (3, 2)) -
      Left (1, 2) * (Left (2, 1) * Left (3, 3) - Left (2, 3) * Left (3, 1)) +
      Left (1, 3) * (Left (2, 1) * Left (3, 2) - Left (2, 2) * Left (3, 1)));

   function Determinant (M : Orthonormal_Matrix) return Float is
     (Determinant (From_Orthonormal (M)));

   function Determinant (M : Symmetric_Matrix) return Float is
     (M (1 & 1) * (M (2 & 2) * M (3 & 3) - M (2 & 3) * M (3 & 2)) -
      M (1 & 2) * (M (2 & 1) * M (3 & 3) - M (2 & 3) * M (3 & 1)) +
      M (1 & 3) * (M (2 & 1) * M (3 & 2) - M (2 & 2) * M (3 & 1)));

   function From_Diagonal (Left : Diagonal_Matrix) return Matrix is
     [[Left (1), 0.0, 0.0],
      [0.0, Left (2), 0.0],
      [0.0, 0.0, Left (3)]];

   function From_Diagonal (Left : Diagonal_Matrix) return Orthonormal_Matrix is
     [[Left (1), 0.0, 0.0],
      [0.0, Left (2), 0.0],
      [0.0, 0.0, Left (3)]];

   function From_Orthonormal (Left : Orthonormal_Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (J, K)]];

   function From_Symmetric (Left : Symmetric_Matrix) return Matrix is
     [[Left (a_11), Left (a_12), Left (a_13)],
      [Left (a_12), Left (a_22), Left (a_23)],
      [Left (a_13), Left (a_23), Left (a_33)]];

   function V_x_VT (Left : FV.Vector) return Symmetric_Matrix is
     [a_11 => Left (1) * Left (1),
      a_12 => Left (1) * Left (2),
      a_13 => Left (1) * Left (3),
      a_22 => Left (2) * Left (2),
      a_23 => Left (2) * Left (3),
      a_33 => Left (3) * Left (3)];

   function L_x_R (L, R : Symmetric_Matrix) return Symmetric_Matrix is
     [L (1 & 1) * R (1 & 1) + L (2 & 1) * R (2 & 1) + L (3 & 1) * R (3 & 1),
      L (1 & 1) * R (1 & 2) + L (2 & 1) * R (2 & 2) + L (3 & 1) * R (3 & 2),
      L (1 & 1) * R (1 & 3) + L (2 & 1) * R (2 & 3) + L (3 & 1) * R (3 & 3),
      L (1 & 2) * R (1 & 2) + L (2 & 2) * R (2 & 2) + L (3 & 2) * R (3 & 2),
      L (1 & 2) * R (1 & 3) + L (2 & 2) * R (2 & 3) + L (3 & 2) * R (3 & 3),
      L (1 & 3) * R (1 & 3) + L (2 & 3) * R (2 & 3) + L (3 & 3) * R (3 & 3)];

   function "*" (Left, Right : Symmetric_Matrix) return Symmetric_Matrix
     renames L_x_R;

   function MT_x_M (M : Matrix) return Symmetric_Matrix is
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

   function M_Plus_MT (M : Matrix) return Symmetric_Matrix is
     [a_11 => M (1, 1) + M (1, 1),
      a_12 => M (1, 2) + M (2, 1),
      a_13 => M (1, 3) + M (3, 1),
      a_22 => M (2, 2) + M (2, 2),
      a_23 => M (2, 3) + M (3, 2),
      a_33 => M (3, 3) + M (3, 3)];

   function Q_A_QT_Cell
     (A : Symmetric_Matrix;
      Q : Matrix;
      J, K : Positive) return Float
   is
     (Q (J, 1) *
      (A (1 & 1) * Q (K, 1) + A (1 & 2) * Q (K, 2) + A (1 & 3) * Q (K, 3)) +
       Q (J, 2) *
      (A (2 & 1) * Q (K, 1) + A (2 & 2) * Q (K, 2) + A (2 & 3) * Q (K, 3)) +
       Q (J, 3) *
      (A (3 & 1) * Q (K, 1) + A (3 & 2) * Q (K, 2) + A (3 & 3) * Q (K, 3)));

   function Q_A_QT (A : Symmetric_Matrix; Q : Matrix) return Symmetric_Matrix is
     [a_11 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_12 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_13 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_22 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_23 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_33 => Q_A_QT_Cell (A, Q, J => 1, K => 1)];

   function Q_A_QT (A : Symmetric_Matrix; Q : Orthonormal_Matrix)
     return Symmetric_Matrix is
       (Q_A_QT (A, From_Orthonormal (Q)));

   function Q_A_QT_Cell
     (A : Diagonal_Matrix;
      Q : Matrix;
      J, K : Positive) return Float
   is
     (Q (J, 1) * A (1) * Q (K, 1)
      + Q (J, 2) * A (2) * Q (K, 2)
      + Q (J, 3) * A (3) * Q (K, 3));

   function Q_A_QT (A : Diagonal_Matrix; Q : Matrix) return Symmetric_Matrix is
     [a_11 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_12 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_13 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_22 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_23 => Q_A_QT_Cell (A, Q, J => 1, K => 1),
      a_33 => Q_A_QT_Cell (A, Q, J => 1, K => 1)];

   function Skew (Vector : FV.Vector) return Matrix is
     [[0.0,         -Vector (3), +Vector (2)],
      [+Vector (3), 0.0,         -Vector (1)],
      [-Vector (2), +Vector (1), 0.0]];

   function Transpose (Left : Matrix) return Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (K, J)]];

   function Transpose (Left : Orthonormal_Matrix) return Orthonormal_Matrix is
     [for J in 1 .. 3 =>
        [for K in 1 .. 3 => Left (K, J)]];

   function Frobenius_Norm_2 (M : Matrix) return Float is
     ([for Item of M => Item**2]'Reduce ("+", 0.0));

   function Frobenius_Norm (M : Matrix) return Float is
     (Tiny_Tensors.Float_Sqrt (Frobenius_Norm_2 (M)));

end Tiny_Tensors.Float_Matrices;
