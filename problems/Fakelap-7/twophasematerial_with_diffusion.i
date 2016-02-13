#energy in eV, length in microm
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 4000
  ny = 1
  nz = 0
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  elem_type = QUAD4
  
  #dim = 1
  #nx = 10000
  #xmin = 0
  #xmax = 1
[]

#[GlobalParams]
  # Output all material properties to the exodus file:
#  outputs = exodus
#[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = FunctionIC
	  variable = c
	  function = '0.42-0.2*tanh(30*x-2.5)'
	  #function = 'if(x<10,0,0)'
	  #function = 'if(x<0.084,0.68-0.24*x,if(x<0.154,-6.29*(x-0.084)+0.66,0.22))' #oxide layer 0.084, interface 0.07
    [../]
  [../]

  [./eta]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = FunctionIC
	  variable = eta
	  function = '-0.5*tanh(30*x-3)+0.5'
	  #function = 'if(x<10,1,1)'
	  #function = 'if(x<0.084,2,if(x<0.154,2-14.28*(x-0.084),1))'
    [../]
  [../]
  
  [./Cr]
	order = FIRST
	family = LAGRANGE
  [../]
[]

[Kernels]
  [./detadt]
    type = TimeDerivative
    variable = eta
  [../]
  [./ACBulk]
    type = ACParsed
    variable = eta
    args = c
    f_name = F
  [../]
  [./ACInterface]
    type = ACInterface
    variable = eta
    kappa_name = kappa_eta
  [../]
  
  [./c_dot]
    type = TimeDerivative
    variable = c
  [../]
  [./CH_Parsed]
    type = CahnHilliard
    variable = c
    f_name = F
    mob_name = M
	args = 'eta'
  [../]
  [./CHint]
    type = CHInterface
    variable = c
    mob_name = M
    kappa_name = kappa_c
  [../]
  
#diffusion Kernels  
  [./td_Cr]
    type = TimeDerivative
    variable = Cr
  [../]
  [./diff_Cr]
    type = MatDiffusion
    variable = Cr
    prop_name = d_cr
  [../]
[]

[BCs]
  active = 'c-left Cr-left Cr-right'  
 
  [./c-left]
    type = DirichletBC
    variable = c
    boundary = 'left'
    value = 0.6173
  [../]
  
  [./Cr-left]
    type = DirichletBC
    variable = Cr
    boundary = 'left'
    value = 0.00
  [../]
  
  [./Cr-right]
    type = DirichletBC
    variable = Cr
    boundary = 'right'
    value = 1.00
  [../]
  
  [./c-right]
    type = NeumannBC
    variable = c
    boundary = 'left'
    value = 0.0
  [../]
  
  [./eta-left]
    type = DirichletBC
    variable = eta
    boundary = 'left'
    value = 2
  [../]
  
  [./eta-right]
    type = DirichletBC
    variable = eta
    boundary = 'right'
    value = 1
  [../]
  
  #Need set right flux =0, flux of  eta = 0  at both right and left??
[]

[Materials]
  [./consts]
    type = GenericConstantMaterial
    block = 0
    prop_names  = 'L kappa_eta kappa_c'   #reduce L to make diffusion control mechanism
    prop_values = '9e-7 4.45e4 4.45e4'   #4.45e4 L=9e-7
  [../]
  
  [./mobility-expression]
    type = DerivativeParsedMaterial
    block = 0
    f_name = M
    args = 'eta'
    #function = '(3*eta*eta-2*eta*eta*eta)*1.02e-17+(1-3*eta*eta+2*eta*eta*eta)*2.76e-15'
    function = '(3*eta*eta-2*eta*eta*eta)*1.02e-11+(1-3*eta*eta+2*eta*eta*eta)*2.76e-14'
	outputs = exodus
    derivative_order = 2
  [../]
  
  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = F
	args = 'c eta'
	function = '(3*eta^2-2*eta^3)*0.5*6.24e5*(c-0.60)^2 + (1-3*eta^2+2*eta^3)*0.5*6.24e5*(c-0.24)^2+1.56e8*(eta^2-2*eta^3+eta^4)'
    derivative_order = 2
    enable_jit = true
  [../]  
  
  [./CrDiffusivity]
  	type = GenericFunctionMaterial
	block = 0
	prop_names = 'd_cr'
	prop_values =  '(1-eta)*1e-15 + eta*1e-13'  #diffusivity profile
    #type = GenericConstantMaterial
    #block = 0
    #prop_names = 'd_cr'
    #prop_values = '0.1'
  [../]
[]

[Postprocessors]
  [./avg_flux_Cr_left]
    type = SideFluxAverage
    variable = Cr
    boundary = 'left'
    diffusivity = d_cr
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  l_max_its = 30
  l_tol = 1e-6
  nl_max_its = 50
  nl_abs_tol = 1e-9
  end_time = 1800000   # 1 day. We only need to run this long enough to verify
                     # the model is working properly.
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm      31                  preonly      ilu          1'
  
  #dt = 1e-6
  dtmax = 1e3
  [./TimeStepper]
    # Turn on time stepping
    type = IterationAdaptiveDT
    dt = 1e-6
    cutback_factor = 0.8
    growth_factor = 1.5
    optimal_iterations = 7
  [../]
[]

[Outputs]
  exodus = true
[]
