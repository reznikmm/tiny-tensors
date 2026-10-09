--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

package body Tiny_Tensors.Float_Diagonal_Matrices is

   function "*" (Left : Diagonal_Matrix; Right : Float) return Diagonal_Matrix
     is [for J in 1 .. 3 => Left (J) * Right];

end Tiny_Tensors.Float_Diagonal_Matrices;
