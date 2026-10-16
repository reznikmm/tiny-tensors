--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package body Testsuite.No_Operation is

   procedure Test (T : in out Slim_Test.Results.Result) is
      pragma Unreferenced (T);

      procedure Sink_Value (Discard : System.Address)
        with Import, External_Name => "sink_value";

      Value : constant Natural := 0;
   begin
      Sink_Value (Value'Address);
   end Test;

end Testsuite.No_Operation;
