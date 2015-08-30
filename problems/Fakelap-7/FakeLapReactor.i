[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 100
  xmax = 100
[]

[Variables]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 300
  [../]
[]

[AuxVariables]
  [./Ni-Soluble-Rate]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.1
  [../]

  [./Ni-deposition-rate]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.005
  [../]

  [./wetted_perimeter]
    order = FIRST
    family = LAGRANGE
  [../]

  [./wall_temp]
    order = FIRST
    family = LAGRANGE
  [../]

  [./tke]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.001
  [../]

  [./boiling-rate]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.01
  [../]

  [./Ni-Soluble]
    order = FIRST
    family = SCALAR
  [../]
[]

[Kernels]
  [./temp-time]
    type = TimeDerivative
    variable = temp
  [../]

  [./temperature]
    type = Diffusion
    variable = temp
  [../]

  [./heat-source]
    type = ReactorHeatSource
    variable = temp
    wall_temp = wall_temp
    wetted_perimeter = wetted_perimeter
  [../]

  [./heat-convection]
    type = Convection
    variable = temp
    x = 2.
    y = 0.
  [../]
[]

[AuxScalarKernels]
  [./crud_release]
    type = CRUD_ODE
    variable = Ni-Soluble

    deposition_fraction = 1
    erosion_fraction = 1
    tke_times_crud = pp_tke
    boiling_rate = pp_boiling
    product_release_rate = pp_dep_rate
    wetted_perimeter = pp_wetted_perimeter
  [../]
[]

[Postprocessors]
  [./pp_wetted_perimeter]
    type = AverageNodalVariableValue
    variable = wetted_perimeter
  [../]

  [./pp_tke]
    type = AverageNodalVariableValue
    variable = tke
  [../]

  [./pp_dep_rate]
    type = AverageNodalVariableValue
    variable = Ni-deposition-rate
  [../]

  [./pp_boiling]
    type = AverageNodalVariableValue
    variable = boiling-rate
  [../]
[]

[ICs]

## Here we need the wetted perimeter in meters, so when integrating, you get the actual area facing the coolant

  [./WettedPerimeterIC]
    type = FunctionIC
    variable = wetted_perimeter
    function = 'if(x<25,100,if(x>50&x<75,1000,1))'
  [../]

  [./wall_temp_IC]
    type = FunctionIC
    variable = wall_temp
    function = 'if(x<25,600+(25*sin(x*3.14159/25)),if(x>50&x<75,500,550))'
  [../]

[]

[BCs]
  [./Periodic]
    active = 'auto'

    # Can use auto_direction with Generated Meshes
    [./auto]
      variable = temp
      auto_direction = 'x'
    [../]
  [../]
[]

[Executioner]
  type = Transient

  num_steps = 1000
  dt = 1

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'
[]

[Outputs]
  file_base = Ouroboros
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  csv = true
[]

[MultiApps]
  [./phase_field_sub_app]
#    positions = '0 0 0   5 0 0   10 0 0   15 0 0   20 0 0   25 0 0   30 0 0   35 0 0   40 0 0   45 0 0   50 0 0   55 0 0   60 0 0   65 0 0   70 0 0   75 0 0   80 0 0   85 0 0   90 0 0   95 0 0   100 0 0'
    positions = '60 0 0'
    type = TransientMultiApp
    input_files = 'PhaseFieldSubApp.i'
    app_type = OuroborosApp
  [../]
[]

[Transfers]
  [./Ni_soluble_release_flux_transfer]
    direction = from_multiapp
    postprocessor = Ni_soluble_release_flux
    variable = Ni_soluble_rate
    type = MultiAppPostprocessorInterpolationTransfer
    multi_app = phase_field_sub_app
  [../]
[]

