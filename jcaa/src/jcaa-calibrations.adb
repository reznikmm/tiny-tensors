with Ada.Numerics.Real_Arrays;
with Ada.Float_Text_IO;
with Ada.Text_IO;

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

   λa  : constant := 1.0;
   λm  : constant := 1.0;
   λal : constant := 1.0;
   λan : constant := 1.0;
   λmn : constant := 1.0;
   λr  : constant := 10.0;

   procedure Assign (Left : out Calibration_State; Right : Calibration_State);

   ------------
   -- Adjust --
   ------------

   procedure Run
     (State : in out Calibration_State;
      Accl  : Tiny_Tensors.Float_Vector_Arrays.Vector_Array;
      Mag   : Tiny_Tensors.Float_Vector_Arrays.Vector_Array)
   is

      subtype S is Positive range Accl'Range;
      subtype Vector_List is Vector_Array (S);

      function Adj (Left : Matrix) return Matrix;

      function Dot (Left, Right : Vector) return Float renames "*";

      function "*" (L : Float; R : Vector_Array) return Vector_Array is
        [for Item of R => L * Item];

      function "-" (L, R : Vector_Array) return Vector_Array is
        [for J in S => L (J) - R (J)];

      subtype State_Value is Calibration_State (State.Size);

      function "*" (L : Float; R : State_Value) return State_Value is
         (Size => R.Size,
          Ha => L * R.Ha,
          Va => L * R.Va,
          Fa => L * R.Fa,
          Hm => L * R.Hm,
          Vm => L * R.Vm,
          Fm => L * R.Fm,
          R  => L * R.R,
          D  => L * R.D);

      function "-" (L, R : State_Value) return State_Value is
         (Size => R.Size,
          Ha => L.Ha - R.Ha,
          Va => L.Va - R.Va,
          Fa => L.Fa - R.Fa,
          Hm => L.Hm - R.Hm,
          Vm => L.Vm - R.Vm,
          Fm => L.Fm - R.Fm,
          R  => L.R - R.R,
          D  => L.D - R.D);

      function Frobenius_Norm (M : Symmetric_Matrix) return Float is
        (Frobenius_Norm (From_Symmetric (M)));

      function "*" (L : Integer; R : Float) return Float is
         (Float (L) * R) with Static;

      --  function "*" (L, R : Vector) return Matrix is
      --    (From_Rows ([L (1) * R, L (2) * R, L (3) * R]));
      --  Kronecker product of two vectors

      type Float_Array is array (Positive range <>) of Float;
      type Matrix_Array is array (Positive range <>) of Matrix;

      --  function Zero return Matrix is [1 .. 3 => [1 .. 3 => 0.0]];

      function Sum (List : Matrix_Array) return Matrix is
         (List'Reduce ("+", Zero));

      function Sum (List : Vector_Array) return Vector is
         (List'Reduce ("+", [0.0, 0.0, 0.0]));

      function Sum (List : Float_Array) return Float is
         (List'Reduce ("+", 0.0));

      function FJ (A : State_Value) return Float;

      procedure Check_dJ_dR (State : Calibration_State; dj_dR : Matrix);

      procedure Check_dJ_dR (State : Calibration_State; dj_dR : Matrix) is
         d : constant := 0.001;
         FL, FR : Float;
         S      : Calibration_State (State.Size);
         Result : Matrix;
      begin
         for J in 1 .. 3 loop
            for K in 1 .. 3 loop
               Assign (S, State);
               S.R (J, K) := @ - d;
               FL := FJ (S);
               S.R (J, K) := @ + 2 * d;
               FR := FJ (S);

               Result (J, K) := (FR - FL) / (2 * d);
            end loop;
         end loop;

         for J in 1 .. 3 loop
            for K in 1 .. 3 loop
               pragma Assert (abs (Result (J, K) - dj_dR (J, K)) < 0.0001);
            end loop;
         end loop;
      end Check_dJ_dR;


      function Adj (Left : Matrix) return Matrix is
         use Ada.Numerics.Real_Arrays;
         D : constant Float := Determinant (Left);
         M : constant Real_Matrix := Inverse (Real_Matrix (Left));
      begin
         return 1.0 / D * Matrix (M);
      end Adj;

      function FJ (A : State_Value) return Float is
         function FM (M : Symmetric_Matrix) return Float renames
           Frobenius_Norm;

         function Minus_I (M : Symmetric_Matrix) return Symmetric_Matrix is
           (M - Diagonal_Matrix'[1.0, 1.0, 1.0]);

         Sa, Sm, Sal, Sr : Float := 0.0;
      begin
         --  Ada.Text_IO.Put_Line ("Start FJ");

         for J in S loop
            Sa := @ + Length_2 (A.Fa (J) - A.Ha * Accl (J) + A.Va)
              + λan * (Length_2 (A.Fa (J)) - 1.0)**2;

            --  Ada.Float_Text_IO.Put
            --    (Length_2 (A.Fa (J) - A.Ha * Accl (J) + A.Va), 2, 3, 0);
            --
            --  Ada.Float_Text_IO.Put ((Length_2 (A.Fa (J)) - 1.0)**2, 2, 3, 0);

            Sm := @ + Length_2 (A.Fm (J) - A.Hm * Mag (J) + A.Vm)
              + λmn * (Length_2 (A.Fm (J)) - 1.0)**2;

            --  Ada.Float_Text_IO.Put
            --    (Length_2 (A.Fm (J) - A.Hm * Mag (J) + A.Vm), 2, 3, 0);
            --
            --  Ada.Float_Text_IO.Put ((Length_2 (A.Fm (J)) - 1.0)**2, 2, 3, 0);

            Sal := @ + (A.D - Dot (A.Fa (J), A.R * A.Fm (J)))**2;

            --  Ada.Float_Text_IO.Put
            --    ((A.D - Dot (A.Fa (J), A.R * A.Fm (J)))**2, 2, 3, 0);
            --
            --  Ada.Text_IO.New_Line;
         end loop;

         Sr := FM (Minus_I (MT_x_M (A.R)))**2 + (Determinant (A.R) - 1.0)**2;

         --  Ada.Text_IO.Put_Line ("S:");
         --  Ada.Float_Text_IO.Put (Sa, 2, 3, 0);
         --  Ada.Float_Text_IO.Put (Sm, 2, 3, 0);
         --  Ada.Float_Text_IO.Put (Sal, 2, 3, 0);
         --  Ada.Float_Text_IO.Put (Sr, 2, 3, 0);
         --  Ada.Float_Text_IO.Put
         --    (λa * Sa + λm * Sm + λal * Sal + λr * Sr, 2, 3, 0);
         --  Ada.Text_IO.New_Line;

         return λa * Sa + λm * Sm + λal * Sal + λr * Sr;
      end FJ;

      function dJ_dHa (A : State_Value) return Matrix is
        (2 * λa * Sum
          ([for J in S => (A.Ha * Accl (J) - A.Fa (J) - A.Va) * Accl (J)]));

      function dJ_dVa (A : State_Value) return Vector is
        (2 * λa * Sum ([for J in S => -A.Ha * Accl (J) + A.Va + A.Fa (J)]));

      function dJ_dFa (A : State_Value) return Vector_List is
        [for J in S =>
          -2 * λa * (A.Ha * Accl (J) + A.Fa (J) - A.Va)
          + 4 * λan * Length_2 (A.Fa (J)) * A.Fa (J)
          - 2 * λal * (A.D - Dot (A.Fa (J), A.R * A.Fm (J))) * A.R * A.Fm (J)];

      function dJ_dHm (A : State_Value) return Matrix is
        (2 * λm * Sum
          ([for J in S => (A.Hm * Mag (J) - A.Fm (J) - A.Vm) * Mag (J)]));

      function dJ_dVm (A : State_Value) return Vector is
        (2 * λm * Sum ([for J in S => -A.Hm * Mag (J) + A.Vm + A.Fm (J)]));

      function dJ_dFm (A : State_Value) return Vector_List is
        [for J in S =>
          -2 * λm * (A.Hm * Mag (J) + A.Fm (J) - A.Vm)
          + 4 * λmn * Length_2 (A.Fm (J)) * A.Fm (J)
          - 2 * λal * (A.D - Dot (A.Fa (J), A.R * A.Fm (J))) * A.R * A.Fa (J)];

      function dJ_dR (A : State_Value) return Matrix is
        (Sum
           ([for J in S =>
              (-2.0 * λal)
               * (A.D - Dot (A.Fa (J), A.R * A.Fm (J)))
               * (A.Fa (J) * A.Fm (J))
             + 4 * λr * (A.R * From_Symmetric (MT_x_M (A.R)) - A.R)
             + 2 * λr * (Determinant (A.R) - 1.0) * Transpose (Adj (A.R))
            ]));

      function dJ_dd (A : State_Value) return Float is
        (2.0 * λal * Sum
           ([for J in S => A.D - Dot (A.Fa (J), A.R * A.Fm (J))]));

      Min   : Float := FJ (State);
      Count : Natural := 0;
   begin
      loop
         declare
            Value : Float;
            Next  : State_Value;
            λ     : Float := 1.0;
            dJ    : constant State_Value :=
              (Size => State.Size,
               Ha => dJ_dHa (State),
               Va => dJ_dVa (State),
               Fa => dJ_dFa (State),
               Hm => dJ_dHm (State),
               Vm => dJ_dVm (State),
               Fm => dJ_dFm (State),
               R  => dJ_dR (State),
               D  => dJ_dd (State));
         begin
            --  Check_dJ_dR (State, dJ.R);
            Count := @ + 1;

            for J in reverse 1 .. 40 loop
               Assign (Next, State - λ * dJ);

               --  Ada.Text_IO.Put ("Lambda:");
               --  Ada.Float_Text_IO.Put (λ, 2, 3, 0);
               --  Ada.Text_IO.New_Line;

               Value := FJ (Next);
               exit when J = 1 or else Value < Min;

               λ := 0.5 * λ;
            end loop;

            if Value < Min then
               Assign (State, Next);
               Min := Value;
            else
               exit;
            end if;
         end;
      end loop;
   end Run;

   ------------
   -- Assign --
   ------------

   procedure Assign
     (Left  : out Calibration_State;
      Right : Calibration_State) is
   begin
      Left.Ha := Right.Ha;
      Left.Va := Right.Va;
      Left.Fa := Right.Fa;
      Left.Hm := Right.Hm;
      Left.Vm := Right.Vm;
      Left.Fm := Right.Fm;
      Left.R  := Right.R;
      Left.D  := Right.D;
   end Assign;

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

   -----------
   -- Shift --
   -----------

   procedure Shift
     (State : in out Calibration_State;
      Accl  : Vector := Zero;
      Mag   : Vector := Zero) is
   begin
      State.Va := @ + Accl;
      State.Vm := @ + Mag;
   end Shift;

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
