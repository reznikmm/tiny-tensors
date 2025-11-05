--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Matrices;

package Tiny_Tensors.Float_Eigen_System is
   pragma Pure;

   procedure Get_Eigen_System
     (Matrix  : Tiny_Tensors.Float_Matrices.Symmetric_Matrix;
      Values  : out Tiny_Tensors.Float_Matrices.Diagonal_Matrix;
      Vectors : out Tiny_Tensors.Float_Matrices.Vector_Array_3);
   --  Compute eigen values and eigen vectors of symmetric matrix M

end Tiny_Tensors.Float_Eigen_System;
