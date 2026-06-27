--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------
pragma Ada_2022;

with Ada.Numerics.Elementary_Functions;

with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Vectors;

package Tiny_Tensors.Rotations is

   subtype Orthonormal_Matrix is
     Tiny_Tensors.Float_Matrices.Orthonormal_Matrix;

   subtype Vector is Tiny_Tensors.Float_Vectors.Vector;

   function Rotation_Angle (Rotation : Orthonormal_Matrix) return Radian;

   function Rotation_Axis (Rotation : Orthonormal_Matrix) return Vector;

private

   function Rotation_Angle (Rotation : Orthonormal_Matrix) return Radian is
     (Radian
       (Ada.Numerics.Elementary_Functions.Arccos
         ((Rotation (1, 1) + Rotation (2, 2) + Rotation (3, 3) - 1.0) / 2.0)));

   use type Vector;

   function Rotation_Axis
     (Rotation : Orthonormal_Matrix;
      Angle    : Radian) return Vector is
     ((1.0 / (2.0 * Ada.Numerics.Elementary_Functions.Sin (Float (Angle)))) *
        Vector'[Rotation (3, 2) - Rotation (2, 3),
         Rotation (1, 3) - Rotation (3, 1),
         Rotation (2, 1) - Rotation (1, 2)]);

   function Rotation_Axis (Rotation : Orthonormal_Matrix) return Vector is
     (Rotation_Axis (Rotation, Rotation_Angle (Rotation)));

end Tiny_Tensors.Rotations;
