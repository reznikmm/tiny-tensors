--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Eigen_System;
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Vectors;

package body Testsuite.Eigen_Systems is
   use Tiny_Tensors.Float_Eigen_System;
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Vectors;

   ----------------------------------
   -- Basic_Eigen_System_Operations --
   ----------------------------------

   procedure Basic_Eigen_System_Operations
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
         --  Simple symmetric matrix
         M : constant Symmetric_Matrix :=
           [a_11 => 4.0, a_12 => 1.0, a_13 => 0.0,
            a_22 => 1.0, a_23 => 0.0,
            a_33 => 1.0];
         Values  : Diagonal_Matrix;
         Vectors : Vector_Array_3;
      begin
         --  Compute eigen system
         Get_Eigen_System (M, Values, Vectors);

         --  Basic checks: eigenvalues should be real numbers
         T.Assert (Values (1) /= Float'First);
         T.Assert (Values (2) /= Float'First);
         T.Assert (Values (3) /= Float'First);

         --  Eigenvectors should be unit vectors (length = 1)
         T.Assert (abs (abs (Vectors (1)) - 1.0) < 0.001);
         T.Assert (abs (abs (Vectors (2)) - 1.0) < 0.001);
         T.Assert (abs (abs (Vectors (3)) - 1.0) < 0.001);

         --  For symmetric matrices, eigenvalues should be sorted in descending
         --  order
         T.Assert (Values (1) >= Values (2));
         T.Assert (Values (2) >= Values (3));

         --  Verify that M * v = λ * v
         for J in 1 .. 3 loop
            declare
               Left  : constant Vector := M * Vectors (J);
               Right : constant Vector := Values (J) * Vectors (J);
            begin
               T.Assert (Length (Left - Right) < 0.001);
            end;
         end loop;
      end;
   end Basic_Eigen_System_Operations;

   ------------------------------------
   -- Test_Diagonal_Matrix_Eigen_System --
   ------------------------------------

   procedure Test_Diagonal_Matrix_Eigen_System
     (T : in out Trendy_Test.Operation'Class)
   is
      function Abs_Max_Item (V : Vector) return Float is
        (Float'Max (Float'Max (abs V (1), abs V (2)), abs V (3)));
   begin
      T.Register;

      declare
         --  Diagonal matrix: eigenvalues should be the diagonal elements
         M : constant Symmetric_Matrix :=
           [a_11 => 5.0, a_12 => 0.0, a_13 => 0.0,
            a_22 => 3.0, a_23 => 0.0,
            a_33 => 1.0];
         Values  : Diagonal_Matrix;
         Vectors : Vector_Array_3;
      begin
         Get_Eigen_System (M, Values, Vectors);

         --  For diagonal matrix, eigenvalues should be diagonal elements
         T.Assert (abs (Values (1) - 5.0) < 0.001);  -- Largest eigenvalue
         T.Assert (abs (Values (2) - 3.0) < 0.001);  -- Middle eigenvalue
         T.Assert (abs (Values (3) - 1.0) < 0.001);  -- Smallest eigenvalue

         --  Eigenvectors should be standard basis vectors (up to sign)
         --  Check that each eigenvector has one dominant component
         declare
            V1_Max : constant Float := Abs_Max_Item (Vectors (1));
            V2_Max : constant Float := Abs_Max_Item (Vectors (2));
            V3_Max : constant Float := Abs_Max_Item (Vectors (3));
         begin
            --  Each eigenvector should have one component close to 1.0
            T.Assert (abs (V1_Max - 1.0) < 0.001);
            T.Assert (abs (V2_Max - 1.0) < 0.001);
            T.Assert (abs (V3_Max - 1.0) < 0.001);
         end;

         --  Verify that M * v = λ * v
         for J in 1 .. 3 loop
            declare
               Left  : constant Vector := M * Vectors (J);
               Right : constant Vector := Values (J) * Vectors (J);
            begin
               T.Assert (Length (Left - Right) < 0.001);
            end;
         end loop;
      end;
   end Test_Diagonal_Matrix_Eigen_System;

   ------------------------------------
   -- Test_Identity_Matrix_Eigen_System --
   ------------------------------------

   procedure Test_Identity_Matrix_Eigen_System
     (T : in out Trendy_Test.Operation'Class) is
   begin
      T.Register;

      declare
         --  Identity matrix: all eigenvalues should be 1.0
         M : constant Symmetric_Matrix :=
           [a_11 => 1.0, a_12 => 0.0, a_13 => 0.0,
            a_22 => 1.0, a_23 => 0.0,
            a_33 => 1.0];
         Values  : Diagonal_Matrix;
         Vectors : Vector_Array_3;
      begin
         Get_Eigen_System (M, Values, Vectors);

         --  All eigenvalues should be 1.0
         T.Assert (abs (Values (1) - 1.0) < 0.001);
         T.Assert (abs (Values (2) - 1.0) < 0.001);
         T.Assert (abs (Values (3) - 1.0) < 0.001);

         --  Eigenvectors should form an orthonormal basis
         --  Check orthogonality (dot products should be ~0)
         T.Assert (abs Float'(Vectors (1) * Vectors (2)) < 0.001);
         T.Assert (abs Float'(Vectors (1) * Vectors (3)) < 0.001);
         T.Assert (abs Float'(Vectors (2) * Vectors (3)) < 0.001);

         --  Check that each vector is unit length
         T.Assert (abs (abs (Vectors (1)) - 1.0) < 0.001);
         T.Assert (abs (abs (Vectors (2)) - 1.0) < 0.001);
         T.Assert (abs (abs (Vectors (3)) - 1.0) < 0.001);
      end;
   end Test_Identity_Matrix_Eigen_System;

end Testsuite.Eigen_Systems;
