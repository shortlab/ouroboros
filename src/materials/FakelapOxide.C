/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#include "FakelapOxide.h"

template<>
InputParameters validParams<FakelapOxide>()
{
  InputParameters params = validParams<Material>();

  // Many material properties scale with temperature (to be implemented later)
  params.addRequiredCoupledVar("temperature", "Temperature of the current location)");
  params.addRequiredCoupledVar("prefactor-Ni", "Ni Diffusivity prefactor, which partially determines oxide phase)");
  params.addRequiredCoupledVar("activation_energy-Ni", "Ni Activation energy, which partially determines oxide phase");
  params.addRequiredCoupledVar("prefactor-Fe", "Fe Diffusivity prefactor, which partially determines oxide phase)");
  params.addRequiredCoupledVar("activation_energy-Fe", "Fe Activation energy, which partially determines oxide phase");

  return params;
}

FakelapOxide::FakelapOxide(const InputParameters & parameters)
    :Material(parameters),

     // Bring in any coupled variables needed to calculate material properties
     _T(coupledValue("temperature")),
     _D_0_Ni(coupledValue("prefactor-Ni")),
     _E_A_Ni(coupledValue("activation_energy-Ni")),
     _D_0_Fe(coupledValue("prefactor-Fe")),
     _E_A_Fe(coupledValue("activation_energy-Fe")),

     // Declare material properties that kernels can use
     _Ni_diffusivity_matprop(declareProperty<Real>("OxideDiffusivity-Ni")),
     _Fe_diffusivity_matprop(declareProperty<Real>("OxideDiffusivity-Fe")),
     _rho_h2o(declareProperty<Real>("WaterDensity"))

{
}

void
FakelapOxide::computeQpProperties()
{
  Real _boltzmann_constant = 8.62e-5;  // In eV-K units

  Real _N_avogadro = 6.02e23;  // Number of atoms per mole

  _Ni_diffusivity_matprop[_qp] = _D_0_Ni[_qp] *
    std::exp((-_E_A_Ni[_qp])
     / (_boltzmann_constant * _T[_qp]));

  _Fe_diffusivity_matprop[_qp] = _D_0_Fe[_qp] *
    std::exp((-_E_A_Fe[_qp])
     / (_boltzmann_constant * _T[_qp]));

  // From Gierszewski, Mikic & Todreas (PFC-RR-80-12)

  _rho_h2o[_qp] =
      -4276
    + (53.24 * _T[_qp])
    - (0.1953 * std::pow(_T[_qp], 2))
    + (3.097e-4 * std::pow(_T[_qp], 3))
    - (1.824e-7 * std::pow(_T[_qp], 4));
}
