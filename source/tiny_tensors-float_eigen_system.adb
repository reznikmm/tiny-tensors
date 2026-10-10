--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Sqrt;
with Tiny_Tensors.Float_Vectors;

package body Tiny_Tensors.Float_Eigen_System is

   ----------------------
   -- Get_Eigen_System --
   ----------------------

   procedure Get_Eigen_System
     (Matrix  : Float_Symmetric_Matrices.Symmetric_Matrix;
      Values  : out Float_Diagonal_Matrices.Diagonal_Matrix;
      Vectors : out Float_Matrices.Vector_Array_3)
   is
      use Tiny_Tensors.Float_Matrices;
      use Tiny_Tensors.Float_Symmetric_Matrices;
      use type Tiny_Tensors.Float_Vectors.Vector;

      Maximum_Sweeps : constant := 16;

      Work     : Symmetric_Matrix := Matrix;
      Rotation : Float_Matrices.Matrix := Float_Matrices.Identity;
   begin
      for Sweep in 1 .. Maximum_Sweeps loop
         exit when
           Work (1 & 2) = 0.0 and Work (1 & 3) = 0.0 and Work (2 & 3) = 0.0;

         for P in 1 .. 2 loop
            for Q in P + 1 .. 3 loop
               if abs Work (P & Q) <= Float'Model_Epsilon
                 * Float'Max (abs Work (P & P), abs Work (Q & Q))
               then
                  --  Ignore roundoff before forming Theta and Theta ** 2.
                  Work (P & Q) := 0.0;
               elsif Work (P & Q) /= 0.0 then
                  declare
                     Theta : constant Float :=
                       (Work (Q & Q) - Work (P & P)) / (2.0 * Work (P & Q));
                     Tangent : constant Float :=
                       (if Theta >= 0.0 then 1.0 else -1.0)
                       / (abs Theta + Float_Sqrt (Theta ** 2 + 1.0));
                     Cosine : constant Float :=
                       1.0 / Float_Sqrt (Tangent ** 2 + 1.0);
                     Sine : constant Float := Tangent * Cosine;
                     Step : Float_Matrices.Matrix := Float_Matrices.Identity;
                  begin
                     Step (P, P) := Cosine;
                     Step (Q, Q) := Cosine;
                     Step (P, Q) := Sine;
                     Step (Q, P) := -Sine;

                     --  Work := Transpose (Step) * Work * Step;
                     Work := Q_A_QT (Q => Transpose (Step), A => Work);
                     Work (P & Q) := 0.0;  --  прибрати залишок округлення
                     Rotation := Rotation * Step;
                  end;
               end if;
            end loop;
         end loop;
      end loop;

      Vectors := Columns (Rotation);
      Values := [Work (1 & 1), Work (2 & 2), Work (3 & 3)];

      --  Sort Values (and Vectors, change the last vector to keep det>0)

      if Values (1) < Values (2) then
         if Values (1) < Values (3) then
            if Values (2) < Values (3) then
               Values := [Values (3), Values (2), Values (1)];
               Vectors := [Vectors (3), Vectors (2), -Vectors (1)];
            else
               Values := [Values (2), Values (3), Values (1)];
               Vectors := [Vectors (2), Vectors (3), Vectors (1)];
            end if;
         else
            Values (1 .. 2) := [Values (2), Values (1)];
            Vectors (1 .. 2) := [Vectors (2), -Vectors (1)];
         end if;
      elsif Values (2) < Values (3) then
         if Values (1) < Values (3) then
            Values := [Values (3), Values (1), Values (2)];
            Vectors := [Vectors (3), Vectors (1), Vectors (2)];
         else
            Values (2 .. 3) := [Values (3), Values (2)];
            Vectors (2 .. 3) := [Vectors (3), -Vectors (2)];
         end if;
      end if;
   end Get_Eigen_System;

end Tiny_Tensors.Float_Eigen_System;
