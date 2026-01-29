with Ada.Numerics.Elementary_Functions;
with Tiny_Tensors.Float_Vectors;

package body JCAA.Samples is

   procedure Create (Accl, Mag : out Sample_Vector) is
      Inclination : constant Float :=
        60.0 * Ada.Numerics.Pi / 180.0;

      Sin_I : constant Float :=
        Ada.Numerics.Elementary_Functions.Sin (Inclination);

      Cos_I : constant Float :=
        Ada.Numerics.Elementary_Functions.Cos (Inclination);

      Part : constant Float :=
        Ada.Numerics.Elementary_Functions.Sqrt (2.0) / 2.0;

   begin
      Accl :=
        [[0.0, 0.0, 1.0],    --  Z up
         [0.0, 0.0, -1.0],
         [1.0, 0.0, 0.0],
         [-1.0, 0.0, 0.0],
         [0.0, 1.0, 0.0],
         [0.0, -1.0, 0.0],
         [+Part, +Part, 0.0],
         [-Part, -Part, 0.0],
         [+Part, 0.0, +Part],
         [-Part, 0.0, -Part],
         [0.0, +Part, +Part],
         [0.0, -Part, -Part]];

      Mag :=
        [[Cos_I, 0.0, -Sin_I],   --  Z down, X north
         [Cos_I, 0.0, +Sin_I],
         [-Sin_I, 0.0, Cos_I],
         [+Sin_I, 0.0, Cos_I],
         [0.0, -Sin_I, Cos_I],
         [0.0, +Sin_I, Cos_I],
         [-Part * Sin_I, -Part * Sin_I, +Cos_I],
         [+Part * Sin_I, +Part * Sin_I, -Cos_I],
         [-Part * Sin_I, +Cos_I, -Part * Sin_I],
         [+Part * Sin_I, -Cos_I, +Part * Sin_I],
         [+Cos_I, -Part * Sin_I, -Part * Sin_I],
         [-Cos_I, +Part * Sin_I, +Part * Sin_I]];

      --  Check angle between accelerometer and magnetometer
      for J in Accl'Range loop
         declare
            use Tiny_Tensors.Float_Vectors;
            Dot : constant Float := Accl (J) * Mag (J);
            Angle : constant Float :=
              Ada.Numerics.Elementary_Functions.Arccos (Dot)
                - 90.0 / 180.0 * Ada.Numerics.Pi;
         begin
            --  Should be close to 60 degrees
            pragma Assert (Length (Accl (J)) in 0.99 .. 1.01);
            pragma Assert (Length (Mag (J)) in 0.99 .. 1.01);
            pragma Assert (abs (Angle - Inclination) <= 0.01);
         end;
      end loop;
   end Create;

   procedure Real (Accl, Mag : out Sample_Vector) is
      use Tiny_Tensors.Float_Vectors;

      A : constant Tiny_Tensors.Float_Vector_Arrays.Vector_Array :=
        [[-13133.0, -483.5, -1031.4],
         [14665.2, -1375.6, 1492.0],
         [-46.8, -13428.5, -329.8],
         [-396.1, 14491.2, -1437.5],
         [1130.2, -15.2, -13057.8],
         [-2732.1, 196.7, 14619.7],
         [-13129.9, -454.4, -1165.5],
         [14520.1, 1036.7, 2987.7],
         [-923.4, 537.8, 13131.2],
         [1140.5, 1846.4, -14647.7],
         [-66.1, 12824.8, 366.3],
         [521.6, -15924.7, -1527.7]];

      B  : constant Tiny_Tensors.Float_Vector_Arrays.Vector_Array :=
        [[468.0625, -249.875, 13.0],
         [-227.375, -297.625, 81.1875],
         [-63.625, 137.1875, 116.5],
         [17.75, -532.4375, 93.125],
         [18.625, -368.375, 502.75],
         [27.125, -271.625, -165.6875],
         [458.125, -343.625, 97.9375],
         [-234.25, -368.0, 257.625],
         [91.25, -381.125, -111.9375],
         [180.875, -392.375, 518.3125],
         [216.5625, -474.5625, -12.0625],
         [22.4375, 191.9375, 61.1875]];
   begin
      Accl := [for Item of A => 1.0 / 16_000.0 * Item];
      Mag := [for Item of B => 1.0 / 500.0 * Item];
   end Real;

end JCAA.Samples;
