--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Numerics;

package Tiny_Tensors is
   pragma Pure;

   subtype Index_1_3 is Positive range 1 .. 3;
   --  Component index for 3D vecors and matrices

   type Arc_Degree is new Float;

   type Radian is new Float;

   function To_Degree (Value : Radian) return Arc_Degree;

   function To_Radian (Value : Arc_Degree) return Radian;

private

   function To_Degree (Value : Radian) return Arc_Degree is
     (180.0 / Ada.Numerics.Pi * Arc_Degree (Value));

   function To_Radian (Value : Arc_Degree) return Radian is
     (Ada.Numerics.Pi / 180.0 * Radian (Value));

end Tiny_Tensors;
