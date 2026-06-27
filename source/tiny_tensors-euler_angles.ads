--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Ada.Numerics.Elementary_Functions;

with Tiny_Tensors.Float_Matrices;

package Tiny_Tensors.Euler_Angles is

   subtype Unit_Interval is Float_Matrices.Unit_Interval;
   subtype Orthonormal_Matrix is Float_Matrices.Orthonormal_Matrix;

   function Euler_Angles_To_Matrix (Roll, Pitch, Yaw : Radian)
     return Orthonormal_Matrix;

   function Euler_Angles_To_Matrix (Roll, Pitch, Yaw : Arc_Degree)
     return Orthonormal_Matrix;

   function Euler_Angles_To_Matrix
     (Cos_1, Cos_2, Cos_3 : Unit_Interval;
      Sin_1, Sin_2, Sin_3 : Unit_Interval)
      return Orthonormal_Matrix;

   function Roll (Rotation : Orthonormal_Matrix) return Radian;
   function Roll (Rotation : Orthonormal_Matrix) return Arc_Degree;

   function Pitch (Rotation : Orthonormal_Matrix) return Radian;
   function Pitch (Rotation : Orthonormal_Matrix) return Arc_Degree;

   function Yaw (Rotation : Orthonormal_Matrix) return Radian;
   function Yaw (Rotation : Orthonormal_Matrix) return Arc_Degree;

private

   use Ada.Numerics.Elementary_Functions;

   function Euler_Angles_To_Matrix
     (Cos_1, Cos_2, Cos_3 : Unit_Interval;
      Sin_1, Sin_2, Sin_3 : Unit_Interval)
      return Orthonormal_Matrix is
     [1 =>
        [Cos_2 * Cos_3, Cos_2 * Sin_3, -Sin_2],
      2 =>
        [Cos_3 * Sin_2 * Sin_1 - Sin_3 * Cos_1,
         Cos_3 * Cos_1 + Sin_3 * Sin_2 * Sin_1,
         Cos_2 * Sin_1],
      3 =>
        [Cos_3 * Sin_2 * Cos_1 + Sin_3 * Sin_1,
         Sin_3 * Sin_2 * Cos_1 - Cos_3 * Sin_1,
         Cos_2 * Cos_1]];

   function Euler_Angles_To_Matrix (Roll, Pitch, Yaw : Radian)
     return Orthonormal_Matrix is
      (Euler_Angles_To_Matrix
        (Cos_1 => Cos (Float (Roll)),
         Sin_1 => Sin (Float (Roll)),
         Cos_2 => Cos (Float (Pitch)),
         Sin_2 => Sin (Float (Pitch)),
         Cos_3 => Cos (Float (Yaw)),
         Sin_3 => Sin (Float (Yaw))));

   function Euler_Angles_To_Matrix (Roll, Pitch, Yaw : Arc_Degree)
     return Orthonormal_Matrix is
      (Euler_Angles_To_Matrix
        (To_Radian (Roll), To_Radian (Pitch), To_Radian (Yaw)));

   function Roll (Rotation : Orthonormal_Matrix) return Radian is
     (Radian (Arctan (Rotation (2, 3), Rotation (3, 3))));

   function Pitch (Rotation : Orthonormal_Matrix) return Radian is
      (Radian (Arcsin (Rotation (1, 3))));

   function Yaw (Rotation : Orthonormal_Matrix) return Radian is
     (Radian (Arctan (Rotation (1, 2), Rotation (1, 1))));

   function Roll (Rotation : Orthonormal_Matrix) return Arc_Degree is
      (To_Degree (Roll (Rotation)));

   function Pitch (Rotation : Orthonormal_Matrix) return Arc_Degree is
     (To_Degree (Pitch (Rotation)));

   function Yaw (Rotation : Orthonormal_Matrix) return Arc_Degree is
     (To_Degree (Yaw (Rotation)));

end Tiny_Tensors.Euler_Angles;
