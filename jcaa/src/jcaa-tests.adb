with JCAA.Calibrations;
with JCAA.Samples;

package body JCAA.Tests is

   procedure Noop (T : in out Trendy_Test.Operation'Class) is
      State : JCAA.Calibrations.Calibration_State
        (JCAA.Samples.Sample_Vector'Length);
   begin
      T.Register;

      declare
         Accl : JCAA.Samples.Sample_Vector;
         Mag  : JCAA.Samples.Sample_Vector;
      begin
         JCAA.Samples.Create (Accl, Mag);
         JCAA.Calibrations.Initialize (State, Accl, Mag);
      end;

   end Noop;

end JCAA.Tests;
