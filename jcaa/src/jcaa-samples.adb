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

end JCAA.Samples;
