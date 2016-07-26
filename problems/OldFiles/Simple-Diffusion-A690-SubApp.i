[Mesh]

## This makes a simple 1D diffusion file with 1000 elements

## UNITS IN MICRONS and seconds

  type = GeneratedMesh
  dim = 2
  nx = 1000
  ny = 1
  xmin = 0
  xmax = 1
  ymin = -1
  ymax = 1
  displacements = 'x_disp y_disp'
  elem_type = QUAD4
[]

[Variables]
  [./Ni]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0
  [../]
[]

[AuxVariables]
  [./x_disp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.0
  [../]

  [./y_disp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.0
  [../]
[]

[Kernels]
  active = 'diff-Ni'

  [./diff-Ni]
    type = MatPropDiffusion
    variable = Ni
    diffusivity = Ni-Diffusivity
    use_displaced_mesh = true
  [../]
[]

[AuxKernels]
  [./x_disp_aux]
    type = FunctionAux
    variable = x_disp
    function = x_disp_func
  [../]
[]

[Functions]

## Put the Ni D_0 and E_A in ev, microns, seconds here

  [./Ni_diff_func]
    type = ParsedFunction
    value = '(1e-10)*exp(-1/0.0000861733*T)'
    vals = Temperature_Transferred
    vars = T    
  [../]

  [./x_disp_func]
    type = ParsedFunction
    value = 'x*thick'
    vals = Thickness_Transferred
    vars = thick
  [../]
[]

[Materials]

## Define a Ni-Diffusivity, which will be a function of temperature and local composition

  [./Ni-Diffusivity]
    type = GenericFunctionMaterial
    block = 0
    prop_names = 'Ni-Diffusivity'
    prop_values = Ni_diff_func
  [../]                  
[]

[BCs]
  [./metal-Ni]
    type = DirichletBC
    variable = Ni
    boundary = 'left'
    value = 1
  [../]

  [./fluid-Ni]
    type = DirichletBC
    variable = Ni
    boundary = 'right'
    value = 0
  [../]
[]


[Postprocessors]

## Postprocessor to get an an area-independent nickel flux leaving the oxide

  [./Ni-Dissolution-Rate]
   type = SideFluxIntegral
   variable = Ni
   diffusivity = Ni-Diffusivity
   boundary = 'right'
  [../]

  [./Temperature_Transferred]
    type = Receiver
  [../]

  [./Thickness_Transferred]
    type = Receiver
  [../]
[]

[Preconditioning]
  # This preconditioner makes sure the Jacobian Matrix is fully populated. Our
  # kernels compute all Jacobian matrix entries.
  # This allows us to use the Newton solver below.
  [./SMP]
    type = SMP
    full = true
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
  dt = 0.1
  end_time   = 86400.0
[]

[Outputs]
  file_base = A690
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  csv = true
[]
