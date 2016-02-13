[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 100

## This should be the total length of the primary circuit in meters

  xmax = 37.1856
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

## The order of the numbers goes Core_Length, Core_PW, SG_Start, SG_End, SG_PW, Hot/Cold_Leg_PW
## All length and wetted perimeters should be in meters

    function = 'if(x<3.6576,1704.34,if(x>9.7536&x<31.0896,354.33,2.3114))'
  [../]

  [./wall_temp_IC]
    type = FunctionIC
    variable = wall_temp

## Here we are assuming a simple sinusoidal cladding temperature profile, with a linear increase superimposed
## for the core temperature. We also assume that the hot & cold legs have constant temperature, while
## the steam generator has a linear heat decrease along its length.

## Cold leg temperature is assumed at the inlet (292C, 565K, 558F)
## Hot leg temperature is assumed at the outlet (326C, 599K, 619F)
## Values taken from Westinghouse 4-loop PWR, at http://www4.ncsu.edu/~doster/NE405/Manuals/PWR_Manual.pdf

## The order of the numbers goes Core_Length, Core_temp_func, SG_Start, SG_End, SG_func, Cold_Leg_start, Cold_leg_temp, Hot_leg_temp
## All temperatures are in Kelvin

    function = 'if(x<3.6576,565+(25*sin(x*3.14159/3.6576))+34*(x/3.6576),if(x>9.7536&x<31.0896,(599-34*((x-9.7536)/21.336)),if(x>=31.0896,565,599)))'
  [../]

[]

## *** NOTE SOMEWHERE: The reactor coolant volume is about 138 cubic meters in the vessel.
## What else in the primary system?

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

active = 'diffusion_sub_app'

  [./diffusion_sub_app]
    positions = '25 0 0 28 0 0'
    type = TransientMultiApp
    input_files = 'Simple-Diffusion-A690-SubApp.i'
    app_type = OuroborosApp
  [../]

  [./PhaseField_sub_app]
    positions = '28 0 0'
    type = TransientMultiApp
    input_files = 'PhaseFieldSubApp.i'
    app_type = OuroborosApp
  [../]
[]

[Transfers]
  [./Ni_soluble_release_flux_transfer]
    direction = from_multiapp
<<<<<<< HEAD
    postprocessor = Ni-Dissolution-Rate
    variable = Ni_Soluble_Rate
=======
    postprocessor = Ni_soluble_release_flux
    variable = Ni-Soluble-Rate
>>>>>>> 141f2c3a49d20966298a30240cb2f61301572e1d
    type = MultiAppPostprocessorInterpolationTransfer
    multi_app = diffusion_sub_app
  [../]

  [./temperature_transfer]
    source_variable = wall_temp
    direction = to_multiapp
    postprocessor = Temperature_Transferred
    type = MultiAppVariableValueSamplePostprocessorTransfer
    multi_app = diffusion_sub_app
  [../]
[]

