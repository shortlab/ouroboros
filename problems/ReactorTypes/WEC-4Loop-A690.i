## Units are in meters.

## Core End = 3.66
## Hot Leg End = 9.76
## SG End = 31.1
## Cold Leg End = 37.2

## These are TOTALS: You have to multiply HL, SG, CL by number of trains.
## Units are in meters.

## Core P_w = 1704.34
## Hot Leg P_w = 2.31
## SG P_w = 1110
## Cold Leg P_w = 2.31

## Oxide parameters, in meters

## D_0 units are in m^2/sec
## E_A units are in eV

## Spinel data directly from MD, scaled to ???
## Cr2O3 data from Sabioni papers on Ni & Fe diffusion through Cr2O3 polycrytsals

## Cr2O3 D_0 Ni = 
## Cr2O3 E_A Ni = 
## Spinel D_0 Ni = 1.59e-8
## Spinel E_A Ni = 1.84

## Cr2O3 D_0 Fe = 
## Cr2O3 E_A Fe = 1.87
## Spinel D_0 Fe = 6.14e-8
## Spinel E_A Fe = 1.87


[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 400
  ny = 1

## This should be the total length of the primary circuit in meters

  xmax = 37.2
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

  [./Thickness-Offset]
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

    value = 'if(x<3.66,2.16e-10,if(x>9.76&x<31.1,5.25e-9,2.16e-10))'
  [../]

  [./Thickness-Power-Function]
    type = ParsedFunction
    value = 'if(x<3.66,0.503,if(x>9.76&x<31.1,0.154,0.503))'
  [../]

  [./Thickness-Offset-Function]
    type = ParsedFunction
    value = 'if(x<3.66,10e-9,if(x>9.76&x<31.1,10e-9,10e-9))'
  [../]

  [./Oxide-Prefactor-Function-Ni]
    type = ParsedFunction

## The order of the numbers goes Core_Length, Core_PW, SG_Start, SG_End, SG_PW, Hot/Cold_Leg_PW
## Lengths are in meters, prefactors are in m^2/sec, powers are unitless

    value = 'if(x<3.66,1.59e-8,if(x>9.76&x<31.1,1.59e-8,1.59e-8))'
  [../]

  [./Oxide-Activation-Energy-Function-Ni]
    type = ParsedFunction
    value = 'if(x<3.66,1.84,if(x>9.76&x<31.1,1.84,1.84))'
  [../]

  [./Oxide-Prefactor-Function-Fe]
    type = ParsedFunction

## The order of the numbers goes Core_Length, Core_PW, SG_Start, SG_End, SG_PW, Hot/Cold_Leg_PW
## Lengths are in meters, prefactors are in m^2/sec, powers are unitless

    value = 'if(x<3.66,6.14e-8,if(x>9.76&x<31.1,6.14e-8,6.14e-8))'
  [../]

  [./Oxide-Activation-Energy-Function-Fe]
    type = ParsedFunction
    value = 'if(x<3.66,1.87,if(x>9.76&x<31.1,1.87,1.87))'
  [../]

  [./Metal-Function-Ni]
    type = ParsedFunction

## The order of the numbers goes Core_Length, Core_metal, SG_Start, SG_End, SG_metal, Hot/Cold_Leg_metal

    value = 'if(x<3.66,0.1,if(x>9.76&x<31.1,0.6,0.1))'
  [../]

  [./Metal-Function-Fe]
    type = ParsedFunction
    value = 'if(x<3.66,0.7,if(x>9.76&x<31.1,0.1,0.7))'
  [../]

  [./ND-Function]
    type = ParsedFunction
    value = 'if(x<3.66,8.49e28,if(x>9.76&x<31.1,9.14e28,8.49e28))'
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

  [./Thickness-Offset-Aux]
    type = FunctionAux
    variable = Thickness-Offset
    function = Thickness-Offset-Function
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
    offset = Thickness-Offset
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

    function = 'if(x<3.66,1704.34,if(x>9.76&x<31.1,1417.32,2.31))'
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

    function = 'if(x<3.66,565+(25*sin(x*3.14159/3.66))+34*(x/3.66),if(x>9.76&x<31.1,(599-34*((x-9.76)/21.34)),if(x>31.1,565,599)))'
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
