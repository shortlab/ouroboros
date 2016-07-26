[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 1

## This should be the total length of the primary circuit in meters

  xmax = 37.1856
[]

[Variables]
  [./temp]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 300
  [../]
[]

[AuxVariables]
  [./Ni-Release-Rate]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.1
  [../]

  [./Fe-Release-Rate]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.1
  [../]

  [./Ni-deposition-rate]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./wetted_perimeter]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./wall_temp]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./tke]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.001
  [../]

  [./boiling-rate]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.01
  [../]

  [./Ni-Soluble]
    order = FIRST
    family = SCALAR
  [../]

  [./Fe-Soluble]
    order = FIRST
    family = SCALAR
  [../]

  [./Oxide-Thickness]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1.0
  [../]

  [./Thickness-Prefactor]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1
  [../]

  [./Thickness-Power]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.5
  [../]

  [./Oxide-Prefactor-Ni]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1
  [../]

  [./Oxide-Activation-Energy-Ni]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1
  [../]

  [./Oxide-Prefactor-Fe]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1
  [../]

  [./Oxide-Activation-Energy-Fe]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1
  [../]

  [./Ni-Diffusivity]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.1
  [../]

  [./Fe-Diffusivity]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.1
  [../]

  [./Ni-Metal]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.1
  [../]

  [./Fe-Metal]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.1
  [../]

  [./NumberDensity]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.1
  [../]
[]

[Functions]
  [./Thickness-Prefactor-Function]
    type = ParsedFunction

## The order of the numbers goes Core_Length, Core_PW, SG_Start, SG_End, SG_PW, Hot/Cold_Leg_PW
## Lengths are in meters, prefactors are in m/sec, powers are unitless

    value = 'if(x<3.6576,1,if(x>9.7536&x<31.0896,5.137e-12,3.683e-12))'
  [../]

  [./Thickness-Power-Function]
    type = ParsedFunction
    value = 'if(x<3.6576,0,if(x>9.7536&x<31.0896,0.153692,0.502595))'
  [../]

  [./Oxide-Prefactor-Function-Ni]
    type = ParsedFunction

## The order of the numbers goes Core_Length, Core_PW, SG_Start, SG_End, SG_PW, Hot/Cold_Leg_PW
## Lengths are in meters, prefactors are in mm^2/sec, powers are unitless

    value = 'if(x<3.6576,1,if(x>9.7536&x<31.0896,1.5e-3,1e-3))'
  [../]

  [./Oxide-Activation-Energy-Function-Ni]
    type = ParsedFunction
#    value = 'if(x<3.6576,0,if(x>9.7536&x<31.0896,4.28,3.32))'
    value = 'if(x<3.6576,0,if(x>9.7536&x<31.0896,2.14,1.66))'
  [../]

  [./Oxide-Prefactor-Function-Fe]
    type = ParsedFunction

## The order of the numbers goes Core_Length, Core_PW, SG_Start, SG_End, SG_PW, Hot/Cold_Leg_PW
## Lengths are in meters, prefactors are in mm^2/sec, powers are unitless

    value = 'if(x<3.6576,1e-10,if(x>9.7536&x<31.0896,1.51e-4,6.1e-3))'
  [../]

  [./Oxide-Activation-Energy-Function-Fe]
    type = ParsedFunction
#    value = 'if(x<3.6576,1e-10,if(x>9.7536&x<31.0896,4.02,3.39))'
    value = 'if(x<3.6576,1e-10,if(x>9.7536&x<31.0896,2.01,1.695))'
  [../]

  [./Metal-Function-Ni]
    type = ParsedFunction

## The order of the numbers goes Core_Length, Core_metal, SG_Start, SG_End, SG_metal, Hot/Cold_Leg_metal

    value = 'if(x<3.6576,0,if(x>9.7536&x<31.0896,0.6,0.1))'
  [../]

  [./Metal-Function-Fe]
    type = ParsedFunction
    value = 'if(x<3.6576,0,if(x>9.7536&x<31.0896,0.1,0.7))'
  [../]

  [./ND-Function]
    type = ParsedFunction
    value = 'if(x<3.6576,0.1,if(x>9.7536&x<31.0896,9.14e28,8.49e28))'
  [../]
[]


[AuxKernels]
  [./Thickness-Prefactor-Aux]
    type = FunctionAux
    variable = Thickness-Prefactor
    function = Thickness-Prefactor-Function
  [../]

  [./Thickness-Power-Aux]
    type = FunctionAux
    variable = Thickness-Power
    function = Thickness-Power-Function
  [../]

  [./Oxide-Prefactor-Aux-Ni]
    type = FunctionAux
    variable = Oxide-Prefactor-Ni
    function = Oxide-Prefactor-Function-Ni
  [../]

  [./Oxide-Activation-Energy-Aux-Ni]
    type = FunctionAux
    variable = Oxide-Activation-Energy-Ni
    function = Oxide-Activation-Energy-Function-Ni
  [../]

  [./Oxide-Prefactor-Aux-Fe]
    type = FunctionAux
    variable = Oxide-Prefactor-Fe
    function = Oxide-Prefactor-Function-Fe
  [../]

  [./Oxide-Activation-Energy-Aux-Fe]
    type = FunctionAux
    variable = Oxide-Activation-Energy-Fe
    function = Oxide-Activation-Energy-Function-Fe
  [../]

  [./Ni-Diffusivity-Aux]
    type = MaterialRealAux
    variable = Ni-Diffusivity
    property = OxideDiffusivity-Ni
  [../]

  [./Fe-Diffusivity-Aux]
    type = MaterialRealAux
    variable = Fe-Diffusivity
    property = OxideDiffusivity-Fe
  [../]

  [./Ni-Metal-Aux]
    type = FunctionAux
    variable = Ni-Metal
    function = Metal-Function-Ni
  [../]

  [./Fe-Metal-Aux]
    type = FunctionAux
    variable = Fe-Metal
    function = Metal-Function-Fe
  [../]

  [./NumberDensity-Aux]
    type = FunctionAux
    variable = NumberDensity
    function = ND-Function
  [../]

  [./Ni_Soluble_Aux]
    type = MetalRelease
    variable = Ni-Release-Rate
    diffusivity = Ni-Diffusivity
    concentration = Ni-Metal
    thickness = Oxide-Thickness
    perimeter = wetted_perimeter
    number_density = NumberDensity
  [../]

  [./Fe_Soluble_Aux]
    type = MetalRelease
    variable = Fe-Release-Rate
    diffusivity = Fe-Diffusivity
    concentration = Fe-Metal
    thickness = Oxide-Thickness
    perimeter = wetted_perimeter
    number_density = NumberDensity
  [../]

  [./Oxide_Thickness]
    type = OxideThickness
    variable = Oxide-Thickness
    prefactor = Thickness-Prefactor
    power = Thickness-Power
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
[]

[AuxScalarKernels]
active = 'Ni_Soluble_ODE Fe_Soluble_ODE'

  [./Ni_Soluble_ODE]
    type = Soluble_ODE
    variable = Ni-Soluble

    product_release_rate = pp_release_rate-Ni
    wetted_perimeter = pp_wetted_perimeter
  [../]

  [./Fe_Soluble_ODE]
    type = Soluble_ODE
    variable = Fe-Soluble

    product_release_rate = pp_release_rate-Fe
    wetted_perimeter = pp_wetted_perimeter
  [../]

  [./crud_release_ODE]
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

[Materials]
  [./Oxide]
    type = FakelapOxide
    block = 0 

    temperature = wall_temp
    prefactor-Ni = Oxide-Prefactor-Ni
    activation_energy-Ni = Oxide-Activation-Energy-Ni
    prefactor-Fe = Oxide-Prefactor-Fe
    activation_energy-Fe = Oxide-Activation-Energy-Fe
  [../]
[]

[Postprocessors]
  [./pp_release_rate-Ni]
    type = ElementAverageValue
    variable = Ni-Release-Rate
  [../]

  [./pp_release_rate-Fe]
    type = ElementAverageValue
    variable = Fe-Release-Rate
  [../]

  [./pp_wetted_perimeter]
    type = ElementAverageValue
    variable = wetted_perimeter
  [../]

  [./pp_tke]
    type = ElementAverageValue
    variable = tke
  [../]

  [./pp_dep_rate]
    type = ElementAverageValue
    variable = Ni-deposition-rate
  [../]

  [./pp_boiling]
    type = ElementAverageValue
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

    function = 'if(x<3.6576,565+(25*sin(x*3.14159/3.6576))+34*(x/3.6576),if(x>9.7536&x<31.0896,(599-34*((x-9.7536)/21.336)),if(x>31.0896,565,599)))'
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
  scheme = 'bdf2'

  # Automatic differentiation provedes a _full_ Jacobian in this example
  # so we can safely use NEWTON for a fast solve
  solve_type = 'NEWTON'

  l_max_its = 15
  l_tol = 1.0e-6

  nl_max_its = 50
  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-6

  start_time = 0.0
  end_time   = 31536000

  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = 0.1
  [../]

[]

[Outputs]
  file_base = Ouroboros
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  csv = true
[]
