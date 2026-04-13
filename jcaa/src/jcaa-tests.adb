pragma Ada_2022;

with Ada.Float_Text_IO;
with Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
with JCAA.Calibrations;
with JCAA.Samples;
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Vectors;

package body JCAA.Tests is
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Vectors;

   function "abs" (M : Matrix) return Float renames Frobenius_Norm_2;
   function "abs" (M : Vector) return Float renames Length_2;

   ----------
   -- Noop --
   ----------

   procedure Noop (T : in out Trendy_Test.Operation'Class) is
      State : JCAA.Calibrations.Calibration_State
        (JCAA.Samples.Sample_Vector'Length);
   begin
      T.Register (Parallelize => False);

      declare
         Accl : JCAA.Samples.Sample_Vector;
         Mag  : JCAA.Samples.Sample_Vector;
      begin
         JCAA.Samples.Create (Accl, Mag);
         JCAA.Calibrations.Initialize (State, Accl, Mag);
         JCAA.Calibrations.Run (State, Accl, Mag);

         T.Assert (abs (JCAA.Calibrations.Rotation (State) - Identity) < 0.01);
         T.Assert (abs JCAA.Calibrations.Bias_Accl (State) < 0.01);
         T.Assert (abs JCAA.Calibrations.Bias_Mag (State) < 0.01);
      end;

   end Noop;

   ----------
   -- Real --
   ----------

   procedure BMM (T : in out Trendy_Test.Operation'Class) is
      State : JCAA.Calibrations.Calibration_State
        (JCAA.Samples.Sample_Vector'Length);
   begin
      T.Register (Parallelize => False);

      declare
         Accl : JCAA.Samples.Sample_Vector;
         Mag  : JCAA.Samples.Sample_Vector;
      begin
         JCAA.Samples.G_AK (Accl, Mag);
         JCAA.Calibrations.Initialize (State, Accl, Mag);
         JCAA.Calibrations.Run (State, Accl, Mag);

         for J in Accl'Range loop
            declare
               A : constant Vector :=
                 JCAA.Calibrations.Fix_Accl (State, Accl (J));
               M : constant Vector :=
                 JCAA.Calibrations.Fix_Mag (State, Mag (J));
               Dot : constant Float := Normalize (A) * Normalize (M);
            begin
               Ada.Float_Text_IO.Put
                 (Ada.Numerics.Elementary_Functions.Arcsin (Dot)
                  * 180.0 / Ada.Numerics.Pi, 4, 2, 0);
            end;
         end loop;

         T.Assert (abs (JCAA.Calibrations.Rotation (State) - Identity) < 0.01);
      end;
   end BMM;

   -----------
   -- Shift --
   -----------

   procedure Shift (T : in out Trendy_Test.Operation'Class) is
      State : JCAA.Calibrations.Calibration_State
        (JCAA.Samples.Sample_Vector'Length);
   begin
      T.Register (Parallelize => False);

      declare
         Accl : JCAA.Samples.Sample_Vector;
         Mag  : JCAA.Samples.Sample_Vector;
      begin
         JCAA.Samples.Create (Accl, Mag);
         JCAA.Calibrations.Initialize (State, Accl, Mag);
         JCAA.Calibrations.Shift (State, Accl => [0.2, 0.0, 0.0]);
         JCAA.Calibrations.Run (State, Accl, Mag);

         T.Assert (abs (JCAA.Calibrations.Rotation (State) - Identity) < 0.01);
         T.Assert (abs JCAA.Calibrations.Bias_Accl (State) < 0.01);
         T.Assert (abs JCAA.Calibrations.Bias_Mag (State) < 0.01);
      end;
   end Shift;
end JCAA.Tests;
