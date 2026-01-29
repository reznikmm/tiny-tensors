with Trendy_Test;

package JCAA.Tests is

   All_Tests : constant Trendy_Test.Test_Group;

private

   procedure Noop (T : in out Trendy_Test.Operation'Class);
   procedure Shift (T : in out Trendy_Test.Operation'Class);
   procedure Real (T : in out Trendy_Test.Operation'Class);

   All_Tests : constant Trendy_Test.Test_Group :=
     [  --  Noop'Access,
      --  Shift'Access,
      Real'Access];

end JCAA.Tests;
