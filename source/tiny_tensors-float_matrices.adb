--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

package body Tiny_Tensors.Float_Matrices is

   ---------
   -- "*" --
   ---------

   function "*" (Left, Right : Orthonormal_Matrix) return Orthonormal_Matrix is
      Result : constant Matrix :=
        From_Orthonormal (Left) * From_Orthonormal (Right);
   begin
      return
        [for J in 1 .. 3 =>
           [for K in 1 .. 3 => Result (J, K)]];
   end "*";

   ------------
   -- LT_x_R --
   ------------

   function LT_x_R
     (Left, Right : Float_Vector_Arrays.Vector_Array) return Matrix is
   begin
      return Result : Matrix := [others => [others => 0.0]] do
         for J in Index_1_3 loop
            for K in Index_1_3 loop
               for I in Left'Range loop
                  Result (J, K) := @ + Left (I) (J) * Right (I) (K);
               end loop;
            end loop;
         end loop;
      end return;
   end LT_x_R;

end Tiny_Tensors.Float_Matrices;
