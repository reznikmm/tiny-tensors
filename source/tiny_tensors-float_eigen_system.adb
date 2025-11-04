--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Numerics.Real_Arrays;

package body Tiny_Tensors.Float_Eigen_System is

   ----------------------
   -- Get_Eigen_System --
   ----------------------

   procedure Get_Eigen_System
     (Matrix  : Tiny_Tensors.Float_Matrices.Symmetric_Matrix;
      Values  : out Tiny_Tensors.Float_Matrices.Diagonal_Matrix;
      Vectors : out Vector_Array_3)
   is
      use type Tiny_Tensors.Float_Matrices.Symmetric_Matrix_Index;

      Input : constant Ada.Numerics.Real_Arrays.Real_Matrix :=
        [[Matrix (1 & 1), Matrix (1 & 2), Matrix (1 & 3)],
         [Matrix (2 & 1), Matrix (2 & 2), Matrix (2 & 3)],
         [Matrix (3 & 1), Matrix (3 & 2), Matrix (3 & 3)]];

      Output : Ada.Numerics.Real_Arrays.Real_Matrix (1 .. 3, 1 .. 3);
      Value  : Ada.Numerics.Real_Arrays.Real_Vector (1 .. 3);
   begin
      Ada.Numerics.Real_Arrays.Eigensystem (Input, Value, Output);

      Values := Tiny_Tensors.Float_Matrices.Diagonal_Matrix (Value);

      Vectors :=
        [[Output (1, 1), Output (1, 2), Output (1, 3)],
         [Output (2, 1), Output (2, 2), Output (2, 3)],
         [Output (3, 1), Output (3, 2), Output (3, 3)]];
   end Get_Eigen_System;

end Tiny_Tensors.Float_Eigen_System;
