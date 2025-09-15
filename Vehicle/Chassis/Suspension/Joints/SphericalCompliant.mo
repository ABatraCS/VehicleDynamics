within Vehicle.Chassis.Suspension.Joints;

model SphericalCompliant
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Math.Vectors.normalize;
  import Modelica.Math.Vectors.norm;
  import Modelica.Units.SI;
  // Kinematic elements
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;
  // User parameters
  parameter Boolean animation = true "Show sphere in animation";
  parameter SI.TranslationalSpringConstant radial_stiffness = 1e9 "Radial stiffness";
  parameter SI.TranslationalDampingConstant radial_damping = 1e9 "Radial damping";
  parameter SI.Length diameter = 0.825*0.0254 "Diameter of bearing";
  parameter SI.Mass mass = 2.48e-3 "Mass of bearing";
  // Internal force and torque
  Modelica.Blocks.Sources.RealExpression forceExpression[3](y = -forceInternal) annotation(
    Placement(transformation(origin = {-16, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression torqueExpression[3](y = -torqueInternal) annotation(
    Placement(transformation(origin = {24, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Mechanics.MultiBody.Forces.Internal.BasicForce basicForce(resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameAB.world)  annotation(
    Placement(transformation(origin = {-10, -20}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Mechanics.MultiBody.Forces.Internal.BasicTorque basicTorque(resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameAB.world)  annotation(
    Placement(transformation(origin = {30, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));

// Visualization
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape shape_a(shapeType = "sphere", length = diameter, width = diameter, height = diameter, animation = animation, r_shape = {-diameter/2, 0, 0}) annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape shape_b(animation = animation, height = diameter, length = diameter, r_shape = {-diameter/2, 0, 0}, shapeType = "sphere", width = diameter) annotation(
    Placement(transformation(origin = {70, 20}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));

// Force and torque variables
  SI.Force forceInternal[3];
  SI.Torque torqueInternal[3];
  
  SI.Position r_rel[3](start = {0, 0, 0}) "Spring elongation vector (state)";
  SI.Position v_rel[3](start = {0, 0, 0}) "Derivative of spring elongation vector";
  Modelica.Mechanics.MultiBody.Parts.Body body(r_CM = {0, 0, 0}, m = mass, animation = false)  annotation(
    Placement(transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Interfaces.ZeroPosition zeroPosition annotation(
    Placement(transformation(origin = {50, -70}, extent = {{-10, -10}, {10, 10}})));
equation
  r_rel = frame_b.r_0 - frame_a.r_0;
  v_rel = der(r_rel);
  forceInternal = radial_stiffness*r_rel + radial_damping * v_rel;
// No torque applied in spherical joint
  torqueInternal = {0, 0, 0};
  connect(shape_a.frame_a, frame_a) annotation(
    Line(points = {{-80, 20}, {-80, 19.5}, {-100, 19.5}, {-100, 0}}, color = {95, 95, 95}));
  connect(shape_b.frame_a, frame_b) annotation(
    Line(points = {{80, 20}, {100, 20}, {100, 0}}, color = {95, 95, 95}));
  connect(frame_a, basicForce.frame_a) annotation(
    Line(points = {{-100, 0}, {-60, 0}, {-60, -20}, {-20, -20}}));
  connect(basicForce.frame_b, frame_b) annotation(
    Line(points = {{0, -20}, {60, -20}, {60, 0}, {100, 0}}, color = {95, 95, 95}));
  connect(frame_a, basicTorque.frame_a) annotation(
    Line(points = {{-100, 0}, {20, 0}}));
  connect(basicTorque.frame_b, frame_b) annotation(
    Line(points = {{40, 0}, {100, 0}}, color = {95, 95, 95}));
  connect(forceExpression.y, basicForce.force) annotation(
    Line(points = {{-16, -38}, {-16, -32}}, color = {0, 0, 127}, thickness = 0.5));
  connect(torqueExpression.y, basicTorque.torque) annotation(
    Line(points = {{24, -38}, {24, -12}}, color = {0, 0, 127}, thickness = 0.5));
  connect(body.frame_a, frame_a) annotation(
    Line(points = {{-80, -50}, {-100, -50}, {-100, 0}}, color = {95, 95, 95}));
  connect(zeroPosition.frame_resolve, basicTorque.frame_resolve) annotation(
    Line(points = {{40, -70}, {34, -70}, {34, -10}}, color = {95, 95, 95}));
  connect(zeroPosition.frame_resolve, basicForce.frame_resolve) annotation(
    Line(points = {{40, -70}, {-6, -70}, {-6, -30}}, color = {95, 95, 95}));
  annotation(
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,10},{100,-10}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Ellipse(
          extent={{-60,-60},{60,60}},
          fillPattern=FillPattern.Solid,
          fillColor={192,192,192},
          lineColor={0,0,0},
          closure=EllipseClosure.Radial,
          startAngle=60,
          endAngle=300),
        Ellipse(
          extent={{-44,-44},{44,44}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          closure=EllipseClosure.Radial,
          startAngle=55,
          endAngle=305),
        Ellipse(
          extent={{-44,-44},{44,44}},
          startAngle=60,
          endAngle=300,
          lineColor={0,0,0},
          closure=EllipseClosure.None),
        Ellipse(
          extent={{-26,26},{26,-26}},
          fillPattern=FillPattern.Sphere,
          fillColor={192,192,192},
          lineColor={0,0,0}),
        Line(
          points={{-100,0},{-58,0},{-43,-30},{-13,30},{17,-30},{47,30},{62,0},
              {100,0}},
          color={255, 0, 0}),
        Text(
          extent={{-150,110},{150,70}},
          textString="%name",
          textColor={0,0,255})}));
end SphericalCompliant;
