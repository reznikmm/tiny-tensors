--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

with System;

with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Orthonormal_Matrices;
with Tiny_Tensors.Float_Symmetric_Matrices;
with Tiny_Tensors.Float_Vector_Arrays;
with Tiny_Tensors.Float_Vectors;

package Testsuite is
   pragma Pure;

   Epsilon : constant := 0.0001;

   --  Redefine "rem" operator as "almost equal" function to use in asserts

   function "rem" (Left, Right : Float) return Boolean is
     (abs (Left - Right) < Epsilon);

   function "rem"
     (Left, Right : Tiny_Tensors.Float_Vectors.Vector) return Boolean is
       (for all J in 1 .. 3 => Left (J) rem Right (J));

   function "rem"
     (Left, Right : Tiny_Tensors.Float_Matrices.Matrix) return Boolean is
       (for all J in 1 .. 3 =>
         (for all K in 1 .. 3 => Left (J, K) rem Right (J, K)));

   function "rem"
     (Left, Right : Tiny_Tensors.Float_Orthonormal_Matrices.Orthonormal_Matrix)
       return Boolean is
         (for all J in 1 .. 3 =>
           (for all K in 1 .. 3 => Left (J, K) rem Right (J, K)));

   function "rem"
     (Left, Right : Tiny_Tensors.Float_Diagonal_Matrices.Diagonal_Matrix)
       return Boolean is
         (for all J in 1 .. 3 => Left (J) rem Right (J));

   function "rem"
     (Left, Right : Tiny_Tensors.Float_Symmetric_Matrices.Symmetric_Matrix)
       return Boolean is
         (for all J in Left'Range => Left (J) rem Right (J));

   function "rem"
     (Left, Right : Tiny_Tensors.Float_Vector_Arrays.Vector_Array)
       return Boolean is
         (Left'Length = Right'Length
            and (for all J in Left'Range => Left (J) rem Right (J)));

   procedure Sink (Discard : System.Address) is null
     with Export, External_Name => "sink_value";
   --  Some tests measure execution time without verifying the result.
   --  Pass the result's address to Sink to prevent the compiler from
   --  optimizing away its computation.

end Testsuite;
