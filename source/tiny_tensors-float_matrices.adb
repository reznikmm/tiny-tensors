--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

package body Tiny_Tensors.Float_Matrices is

   ------------
   -- LT_x_R --
   ------------

   function LT_x_R (Left, Right : Vector_Array) return Matrix is
   begin
      return Result : Matrix := [others => [others => 0.0]] do
         for I in Index_1_3 loop
            for J in Index_1_3 loop
               for K in Left'Range loop
                  Result (I, J) := @ + Left (K) (J) * Right (K) (I);
               end loop;
            end loop;
         end loop;
      end return;
   end LT_x_R;

end Tiny_Tensors.Float_Matrices;
