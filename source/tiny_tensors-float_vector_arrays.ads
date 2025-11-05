--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Vectors;

package Tiny_Tensors.Float_Vector_Arrays is
   pragma Pure;

   package FV renames Tiny_Tensors.Float_Vectors;

   type Vector_Array is array (Positive range <>) of FV.Vector;

   function Normalize (V : Vector_Array) return Vector_Array is
     [for I in V'Range => FV.Normalize (V (I))];

end Tiny_Tensors.Float_Vector_Arrays;
