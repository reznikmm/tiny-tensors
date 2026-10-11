--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Test_Groups;

package Testsuite.Vectors is

   All_Tests : constant Slim_Test.Test_Groups.Test_Group;

private

   procedure Basic_Vector_Operations (T : in out Slim_Test.Results.Result);
   procedure Test_Triple_Product (T : in out Slim_Test.Results.Result);

   All_Tests : constant Slim_Test.Test_Groups.Test_Group :=
    ["Basic_Vector_Operations" => Basic_Vector_Operations'Access,
     "Test_Triple_Product" => Test_Triple_Product'Access];

end Testsuite.Vectors;
