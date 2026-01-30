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

   ----------
   -- G_AK --
   ----------

   procedure G_AK (Accl, Mag : out Sample_Vector) is
      use Tiny_Tensors.Float_Vectors;

      A : constant Tiny_Tensors.Float_Vector_Arrays.Vector_Array :=
        [[-16349.3, -1387.9, -1358.0],
         [16235.7, 1932.0, 981.7],
         [362.0, -16690.2, -44.9],
         [-847.5, 16090.5, 967.9],
         [-2047.6, -792.8, 16298.8],
         [1678.0, -64.4, -16323.9],
         [-16371.9, -401.8, -1584.4],
         [16267.8, 468.2, 2041.3],
         [-1298.4, 16044.1, 1157.7],
         [1058.7, -16657.9, -524.2],
         [-1126.7, -430.4, 16404.4],
         [1224.1, 469.2, -16341.2]];

      B  : constant Tiny_Tensors.Float_Vector_Arrays.Vector_Array :=
        [[-67.38, 361.020004, -493.650006],
         [-866.730009, 80.38, -584.690013],
         [-516.780017, 628.280011, -584.590008],
         [-380.430004, -126.69, -570.960004],
         [-326.070003, 438.000006, -734.020001],
         [-654.300011, 402.710009, -2.86],
         [-109.82, 287.560007, -113.99],
         [-917.24002, 419.800011, -381.780005],
         [-545.960014, -132.310002, -593.18001],
         [-724.050007, 614.630024, -457.560007],
         [-673.260009, 199.150003, -791.750018],
         [-646.590008, 21.22, -13.54]];
   begin
      Accl := [for Item of A => 1.0 / 16_000.0 * Item];
      Mag := [for Item of B => 1.0 / 500.0 * Item];
   end G_AK;

   -----------
   -- G_BMM --
   -----------

   procedure G_BMM (Accl, Mag : out Sample_Vector) is
      use Tiny_Tensors.Float_Vectors;
      A : constant Tiny_Tensors.Float_Vector_Arrays.Vector_Array :=
        [[-16349.3, -1387.9, -1358.0],
         [16235.7, 1932.0, 981.7],
         [362.0, -16690.2, -44.9],
         [-847.5, 16090.5, 967.9],
         [-2047.6, -792.8, 16298.8],
         [1678.0, -64.4, -16323.9],
         [-16371.9, -401.8, -1584.4],
         [16267.8, 468.2, 2041.3],
         [-1298.4, 16044.1, 1157.7],
         [1058.7, -16657.9, -524.2],
         [-1126.7, -430.4, 16404.4],
         [1224.1, 469.2, -16341.2]];

      B  : constant Tiny_Tensors.Float_Vector_Arrays.Vector_Array :=
        [[532.00, -63.50, 16.50],
         [-227.50, -333.75, 12.75],
         [85.63, 204.25, -13.13],
         [254.50, -545.50, -36.38],
         [275.31, 3.63, -189.75],
         [-50.00, 1.63, 585.25],
         [484.63, -122.00, 409.00],
         [-299.88, 10.63, 234.88],
         [91.25, -552.88, -37.13],
         [-114.50, 200.13, 145.00],
         [-47.75, -227.88, -206.63],
         [-25.63, -375.75, 567.13]];
   begin
      Accl := [for Item of A => 1.0 / 16_000.0 * Item];
      Mag := [for Item of B => 1.0 / 500.0 * Item];
   end G_BMM;

end JCAA.Samples;
