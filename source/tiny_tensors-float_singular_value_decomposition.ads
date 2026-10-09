--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Symmetric_Matrices;
with Tiny_Tensors.Float_Orthonormal_Matrices;
with Tiny_Tensors.Float_Matrices;

package Tiny_Tensors.Float_Singular_Value_Decomposition is
   pragma Pure;

   procedure SVD
     (Input : Float_Matrices.Matrix;
      U     : out Float_Orthonormal_Matrices.Orthonormal_Matrix;
      S     : out Float_Diagonal_Matrices.Diagonal_Matrix;
      V     : out Float_Orthonormal_Matrices.Orthonormal_Matrix);
   --  Perform singular value decomposition of 3x3 matrix:
   --  Find U, S, V for B = USV⟙, where U and V - rotation matris and S -
   --  diagonal matrix. Note, V is returned not transposed, so to reconstruct
   --  use Input = U * S * Transpose (V)

   procedure SVD
     (Input : Float_Symmetric_Matrices.Symmetric_Matrix;
      U     : out Float_Orthonormal_Matrices.Orthonormal_Matrix;
      S     : out Float_Diagonal_Matrices.Diagonal_Matrix;
      V     : out Float_Orthonormal_Matrices.Orthonormal_Matrix);
   --  Perform singular value decomposition of 3x3 matrix:
   --  Find U, S, V for B = USV⟙, where U and V - rotation matris and S -
   --  diagonal matrix. Note, V is returned not transposed, so to reconstruct
   --  use Input = U * S * Transpose (V)

end Tiny_Tensors.Float_Singular_Value_Decomposition;
