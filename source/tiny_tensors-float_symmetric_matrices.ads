--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

limited with Tiny_Tensors.Float_Matrices;
limited with Tiny_Tensors.Float_Diagonal_Matrices;
limited with Tiny_Tensors.Float_Orthonormal_Matrices;
with Tiny_Tensors.Float_Sqrt;
with Tiny_Tensors.Float_Vectors;
with Tiny_Tensors.Float_Vector_Arrays;

package Tiny_Tensors.Float_Symmetric_Matrices is
   pragma Pure;

   package FV renames Tiny_Tensors.Float_Vectors;
   package DM renames Tiny_Tensors.Float_Diagonal_Matrices;

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

   function Zero return Symmetric_Matrix;
   --  Return a zero matrix or null matrix (all of whose entries are 0.0).

   function Identity return Symmetric_Matrix;
   --  Return an identity matrix or unit matrix. It has ones on the main
   --  diagonal and zeros elsewhere.

   function Determinant (Operand : Symmetric_Matrix) return Float
     with Inline;
   --  Return determinant of symmetric matrix

   function Adjugate (Operand : Symmetric_Matrix) return Symmetric_Matrix
     with Inline;
   --  Return the adjugate (classical adjoint) of Operand, the transposed
   --  matrix of cofactors.

   function Frobenius_Norm (Operand : Symmetric_Matrix) return Float;

   function Frobenius_Norm_2 (Operand : Symmetric_Matrix) return Float;
   --  Return Frobenius_Norm (Operand)**2

   function "+" (Left, Right : Symmetric_Matrix) return Symmetric_Matrix;

   function "-" (Left, Right : Symmetric_Matrix) return Symmetric_Matrix;

   function "-" (Right : Symmetric_Matrix) return Symmetric_Matrix;

   function "*"
     (Left : Float; Right : Symmetric_Matrix) return Symmetric_Matrix;
   --  Return scalar multiplication

   function "*"
     (Left : Symmetric_Matrix; Right : Float) return Symmetric_Matrix;
   --  Return scalar multiplication

   function "*" (L : Symmetric_Matrix; R : FV.Vector) return FV.Vector;
   --  Return matrix-vector multiplication

   function "+"
     (Left  : Symmetric_Matrix;
      Right : DM.Diagonal_Matrix) return Symmetric_Matrix;

   function "+"
     (Left  : DM.Diagonal_Matrix;
      Right : Symmetric_Matrix) return Symmetric_Matrix;

   function "-"
     (Left  : Symmetric_Matrix;
      Right : DM.Diagonal_Matrix) return Symmetric_Matrix;

   function "-"
     (Left  : DM.Diagonal_Matrix;
      Right : Symmetric_Matrix) return Symmetric_Matrix;

   function LT_x_L
     (Left : Float_Vector_Arrays.Vector_Array) return Symmetric_Matrix;
   --
   --  Return Left transpose times Left: Lᵀ x L

   function V_x_VT (Left : FV.Vector) return Symmetric_Matrix;
   --
   --  Return Left times Left transpose: L x Lᵀ

   function Gramian (M : Float_Matrices.Matrix) return Symmetric_Matrix;
   --  Return Mᵀ x M in compact form

   function Gramian (M : Symmetric_Matrix) return Symmetric_Matrix;
   --  Return Mᵀ x M in compact form

   function M_Plus_MT (M : Float_Matrices.Matrix) return Symmetric_Matrix;
   --  Return M + Mᵀ in compact form

   function Q_A_QT
     (A : Symmetric_Matrix;
      Q : Float_Orthonormal_Matrices.Orthonormal_Matrix)
      return Symmetric_Matrix;
   --  Return QAQᵀ in compact form

   function Q_A_QT
     (A : Symmetric_Matrix;
      Q : Float_Matrices.Matrix) return Symmetric_Matrix;
   --  Return QAQᵀ in compact form

   function Q_A_QT
     (A : DM.Diagonal_Matrix;
      Q : Float_Matrices.Matrix) return Symmetric_Matrix;
   --  Return QAQᵀ in compact form

   function Inverse (Operand : Symmetric_Matrix) return Symmetric_Matrix
     with Pre => Determinant (Operand) /= 0.0;

private

   function Zero return Symmetric_Matrix is ([others => 0.0]);

   function Identity return Symmetric_Matrix is
     [a_11 | a_22 | a_33 => 1.0, others => 0.0];

   function "-" (Right : Symmetric_Matrix) return Symmetric_Matrix is
     [for Item of Right => -Item];

   function Frobenius_Norm_2 (Operand : Symmetric_Matrix) return Float is
     ([for Item of Operand => Item**2]'Reduce ("+", 0.0));

   function Frobenius_Norm (Operand : Symmetric_Matrix) return Float is
     (Tiny_Tensors.Float_Sqrt (Frobenius_Norm_2 (Operand)));

end Tiny_Tensors.Float_Symmetric_Matrices;
