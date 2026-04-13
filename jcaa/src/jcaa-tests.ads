pragma Ada_2022;

with Trendy_Test;

package JCAA.Tests is

   All_Tests : constant Trendy_Test.Test_Group;

private

   procedure Noop (T : in out Trendy_Test.Operation'Class);
   procedure Shift (T : in out Trendy_Test.Operation'Class);
   procedure BMM (T : in out Trendy_Test.Operation'Class);

   All_Tests : constant Trendy_Test.Test_Group :=
     [  --  Noop'Access,
      --  Shift'Access,
      BMM'Access];

end JCAA.Tests;
