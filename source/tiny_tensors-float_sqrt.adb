--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Numerics.Elementary_Functions;

function Tiny_Tensors.Float_Sqrt (X : Float) return Float is
begin
   return Ada.Numerics.Elementary_Functions.Sqrt (X);
end Tiny_Tensors.Float_Sqrt;
