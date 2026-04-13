with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Vector_Arrays;
with Tiny_Tensors.Float_Vectors;

package JCAA.Calibrations is

   type Calibration_State (Size : Positive) is private;

   procedure Initialize
     (State : out Calibration_State;
      Accl  : Tiny_Tensors.Float_Vector_Arrays.Vector_Array;
      Mag   : Tiny_Tensors.Float_Vector_Arrays.Vector_Array);

   procedure Shift
     (State : in out Calibration_State;
      Accl  : Tiny_Tensors.Float_Vectors.Vector :=
        Tiny_Tensors.Float_Vectors.Zero;
      Mag   : Tiny_Tensors.Float_Vectors.Vector :=
        Tiny_Tensors.Float_Vectors.Zero);

   procedure Run
     (State : in out Calibration_State;
      Accl  : Tiny_Tensors.Float_Vector_Arrays.Vector_Array;
      Mag   : Tiny_Tensors.Float_Vector_Arrays.Vector_Array);

   function Rotation
     (State : Calibration_State) return Tiny_Tensors.Float_Matrices.Matrix;

   function Bias_Accl
     (State : Calibration_State) return Tiny_Tensors.Float_Vectors.Vector;

   function Bias_Mag
     (State : Calibration_State) return Tiny_Tensors.Float_Vectors.Vector;

   function M_Accl
     (State : Calibration_State) return Tiny_Tensors.Float_Matrices.Matrix;

   function M_Mag
     (State : Calibration_State) return Tiny_Tensors.Float_Matrices.Matrix;

   function Fix_Accl
     (State : Calibration_State;
      Value : Tiny_Tensors.Float_Vectors.Vector)
        return Tiny_Tensors.Float_Vectors.Vector;
   --  Apply acceleromenter bias and matrix

   function Fix_Mag
     (State : Calibration_State;
      Value : Tiny_Tensors.Float_Vectors.Vector)
        return Tiny_Tensors.Float_Vectors.Vector;
   --  Apply magnetometer bias, matrix and rotation

private

   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Vector_Arrays;
   use Tiny_Tensors.Float_Vectors;

   type Calibration_State (Size : Positive) is record
      Ha : Matrix;  --  accl Ta⁻¹
      Va : Vector;  --  accl offset
      Fa : Vector_Array (1 .. Size);  --  True a(k)
      Hm : Matrix;  --  mag Ta⁻¹
      Vm : Vector;  --  mag offset
      Fm : Vector_Array (1 .. Size);  --  True m(k)
      R  : Matrix;  --  rotation mag->accl
      D  : Float;  --  sin (Inclination)
   end record;

   function Rotation (State : Calibration_State) return Matrix is (State.R);

   function Bias_Accl (State : Calibration_State) return Vector is (State.Va);

   function Bias_Mag (State : Calibration_State) return Vector is (State.Vm);

   function M_Accl (State : Calibration_State) return Matrix is (State.Ha);

   function M_Mag (State : Calibration_State) return Matrix is (State.Hm);

   function Fix_Accl
     (State : Calibration_State;
      Value : Tiny_Tensors.Float_Vectors.Vector)
        return Tiny_Tensors.Float_Vectors.Vector is
          (State.Ha * Value - State.Va);

   function Fix_Mag
     (State : Calibration_State;
      Value : Tiny_Tensors.Float_Vectors.Vector)
        return Tiny_Tensors.Float_Vectors.Vector is
          (State.R * (State.Hm * Value - State.Vm));

end JCAA.Calibrations;
