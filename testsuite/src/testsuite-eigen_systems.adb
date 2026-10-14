--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Symmetric_Matrices;
with Tiny_Tensors.Float_Eigen_System;
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Vectors;

package body Testsuite.Eigen_Systems is
   use Slim_Test.Results;
   use Tiny_Tensors.Float_Eigen_System;
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Diagonal_Matrices;
   use Tiny_Tensors.Float_Symmetric_Matrices;
   use Tiny_Tensors.Float_Vectors;

   ----------------------------------
   -- Basic_Eigen_System_Operations --
   ----------------------------------

   procedure Basic_Eigen_System
     (T : in out Slim_Test.Results.Result)
   is
      --  Simple symmetric matrix
      M : constant Symmetric_Matrix :=
        [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];

      Values  : Diagonal_Matrix;
      Vectors : Vector_Array_3;
   begin
      --  Compute eigen system
      Get_Eigen_System (M, Values, Vectors);

      --  Eigenvectors should be unit vectors (length = 1)
      Assert (T, (for all Vector of Vectors => Length (Vector) rem 1.0));

      --  Should be sorted in descending order
      Assert (T, Values (1) >= Values (2));
      Assert (T, Values (2) >= Values (3));

      --  Verify that M * v = λ * v
      for J in 1 .. 3 loop
         Assert (T, (M * Vectors (J)) rem (Values (J) * Vectors (J)));
      end loop;
   end Basic_Eigen_System;

   ----------------------------------
   -- Diagonal_Matrix_Eigen_System --
   ----------------------------------

   procedure Diagonal_Matrix_Eigen_System
     (T : in out Slim_Test.Results.Result)
   is
      M : constant Symmetric_Matrix :=
        [a_11 => 5.0,
         a_22 => 3.0,
         a_33 => 1.0,
         others => 0.0];

      Values  : Diagonal_Matrix;
      Vectors : Vector_Array_3;
   begin
      Get_Eigen_System (M, Values, Vectors);

      Assert (T, Values rem [5.0, 3.0, 1.0]);

      Assert
        (T, Vectors rem [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]);

      --  Verify that M * v = λ * v
      for J in 1 .. 3 loop
         Assert (T, (M * Vectors (J)) rem (Values (J) * Vectors (J)));
      end loop;
   end Diagonal_Matrix_Eigen_System;

   ----------------------------------
   -- Identity_Matrix_Eigen_System --
   ----------------------------------

   procedure Identity_Matrix_Eigen_System
     (T : in out Slim_Test.Results.Result)
   is
      --  Identity matrix: all eigenvalues should be 1.0
      M : constant Symmetric_Matrix := Identity;
      Values  : Diagonal_Matrix;
      Vectors : Vector_Array_3;
   begin
      Get_Eigen_System (M, Values, Vectors);

      --  All eigenvalues should be 1.0
      Assert (T, (for all Value of Values => Value rem 1.0));

      --  Eigenvectors should form an orthonormal basis
      --  Check orthogonality (dot products should be ~0)
      Assert (T, Vectors (1) * Vectors (2) rem 0.0);
      Assert (T, Vectors (1) * Vectors (3) rem 0.0);
      Assert (T, Vectors (2) * Vectors (3) rem 0.0);

      --  Check that each vector is unit length
      Assert (T, (for all Vector of Vectors => Length (Vector) rem 1.0));
   end Identity_Matrix_Eigen_System;

   ---------------------------
   -- Sample_Eigen_System_1 --
   ---------------------------

   procedure Sample_Eigen_System_1 (T : in out Slim_Test.Results.Result) is
      --  Simple symmetric matrix
      M : constant Symmetric_Matrix :=
        [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];

      Values  : Diagonal_Matrix;
      Vectors : Vector_Array_3;
   begin
      --  Compute eigen system
      Get_Eigen_System (M, Values, Vectors);

      Assert (T, Values rem [11.3448, 0.1709, -0.5157]);

      Assert
        (T,
         Vectors rem
           [[0.3279, 0.5910, 0.7369],
            [0.5910, -0.7370, 0.3280],
            [0.7370, 0.3280, -0.5910]]);
   end Sample_Eigen_System_1;

   ---------------------------
   -- Sample_Eigen_System_2 --
   ---------------------------

   procedure Sample_Eigen_System_2 (T : in out Slim_Test.Results.Result) is
      M : constant Symmetric_Matrix :=
        [2.0, 0.0, 0.0,
              3.0, 4.0,
                   9.0];

      Values  : Diagonal_Matrix;
      Vectors : Vector_Array_3;
   begin
      --  Compute eigen system
      Get_Eigen_System (M, Values, Vectors);

      Assert (T, Values rem [11.0, 2.0, 1.0]);

      Assert
        (T,
         Vectors rem
           [[0.0, 0.4472, 0.8944], [1.0, 0.0, 0.0], [0.0, 0.8944, -0.4472]]);
   end Sample_Eigen_System_2;

end Testsuite.Eigen_Systems;
