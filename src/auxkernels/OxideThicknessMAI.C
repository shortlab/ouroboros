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

#include "OxideThicknessMAI.h"

template<>
InputParameters validParams<OxideThicknessMAI>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addRequiredCoupledVar("temperature", "The temperature at this quadrature point");
  params.addParam<Real>("b_li_ratio", "The value of the oxide thickness prefactor for growth");
  params.addParam<Real>("pH", "The value of the oxide thickness prefactor for growth");
  params.addParam<Real>("H2", "The value of the oxide thickness prefactor for growth");
  params.addParam<Real>("ECP", "The value of the oxide thickness prefactor for growth");
  return params;
}


OxideThicknessMAI::OxideThicknessMAI(const InputParameters & parameters)
  :AuxKernel(parameters),
   _T(coupledValue("temperature")),
   _BLiRatio(getParam<Real>("b_li_ratio")),
   _pH(getParam<Real>("pH")),
   _H2(getParam<Real>("H2")),
   _ECP(getParam<Real>("ECP"))
{}

Real
OxideThicknessMAI::computeValue()
{

  Real alpha_0 = 5.3e-6;
  Real alpha = alpha_0 * _T[_qp] * (_BLiRatio) * _pH * std::log10(_H2);
  Real beta_0 = -1.4e-3;
  Real beta = beta_0 * _T[_qp] * _ECP / _pH;
  Real gamma = 1e-4;
  Real delta = 0.28;
  Real L0 = 1;
  Real thick = 1e-9 * (delta / beta) * std::log((alpha / gamma) * exp(-beta * L0) * (exp(beta * gamma * (_t / 3600)) - 1) + 1);
  return thick;
}
