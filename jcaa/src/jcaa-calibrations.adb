with Ada.Numerics.Real_Arrays;
with Conic_Fit.Sphere;

package body JCAA.Calibrations is

   function Get_Inclination
     (Mag      : Tiny_Tensors.Float_Vector_Arrays.Vector_Array;
      Accl     : Tiny_Tensors.Float_Vector_Arrays.Vector_Array;
      Center_M : Tiny_Tensors.Float_Vectors.Vector;
      Center_A : Tiny_Tensors.Float_Vectors.Vector) return Float;

   procedure Sphere_Fit
     (List   : Tiny_Tensors.Float_Vector_Arrays.Vector_Array;
      Sphere : out Conic_Fit.Sphere.Parameters);

   ---------------------
   -- Get_Inclination --
   ---------------------

   function Get_Inclination
     (Mag      : Tiny_Tensors.Float_Vector_Arrays.Vector_Array;
      Accl     : Tiny_Tensors.Float_Vector_Arrays.Vector_Array;
      Center_M : Tiny_Tensors.Float_Vectors.Vector;
      Center_A : Tiny_Tensors.Float_Vectors.Vector)
      return Float
   is
      function Dot (Left, Right : Vector) return Float renames "*";

      Result : Float := 0.0;
   begin
      for J in Mag'Range loop
         Result := @ +
           Dot
             (Normalize (Mag (J) - Center_M),
              Normalize (Accl (J) - Center_A));
      end loop;

      return Result / Float (Mag'Length);
   end Get_Inclination;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (State : out Calibration_State;
      Accl  : Tiny_Tensors.Float_Vector_Arrays.Vector_Array;
      Mag   : Tiny_Tensors.Float_Vector_Arrays.Vector_Array)
   is
      use all type Conic_Fit.Sphere_Geometric_Parameter_Index;

      subtype S is Positive range 1 .. State.Size;

      Sphere          : Conic_Fit.Sphere.Parameters;
      Center_M        : Vector;
      Center_A        : Vector;
      Inclination_Sin : Float renames State.D;

   begin
      State.R := Identity;
      Sphere_Fit (Mag, Sphere);

      Center_M := [Sphere (Center_X), Sphere (Center_Y), Sphere (Center_Z)];
      State.Hm := From_Diagonal ([1 .. 3 => 1.0 / Sphere (Radius)]);
      State.Vm := State.Hm * Center_M;

      Sphere_Fit (Accl, Sphere);

      Center_A := [Sphere (Center_X), Sphere (Center_Y), Sphere (Center_Z)];
      State.Ha := From_Diagonal ([1 .. 3 => 1.0 / Sphere (Radius)]);
      State.Va := State.Ha * Center_A;

      Inclination_Sin := Get_Inclination (Mag, Accl, Center_M, Center_A);

      for J in S loop
         State.Fm (J) := Normalize (Mag (J) - Center_M);
         State.Fa (J) := Normalize (Accl (J) - Center_A);
      end loop;
   end Initialize;

   ----------------
   -- Sphere_Fit --
   ----------------

   procedure Sphere_Fit
     (List   : Tiny_Tensors.Float_Vector_Arrays.Vector_Array;
      Sphere : out Conic_Fit.Sphere.Parameters) is
   begin
      Conic_Fit.Sphere.Sphere_Fit
        (Sphere,
         [for Item of List => Ada.Numerics.Real_Arrays.Real_Vector (Item)]);
   end Sphere_Fit;

end JCAA.Calibrations;
