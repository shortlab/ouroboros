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

#include "OxideThickness.h"

template<>
InputParameters validParams<OxideThickness>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addRequiredCoupledVar("offset", "The starting value of the oxide thickness for growth");
  params.addRequiredCoupledVar("prefactor", "The value of the oxide thickness prefactor for growth");
  params.addRequiredCoupledVar("power", "The value of the oxide thickness power for growth");
  return params;
}


OxideThickness::OxideThickness(const InputParameters & parameters)
  :AuxKernel(parameters),
   _offset(coupledValue("offset")),
   _power(coupledValue("power")),
   _prefactor(coupledValue("prefactor"))
{}

Real
OxideThickness::computeValue()
{
  
  Real thick = _offset[_qp] + (_prefactor[_qp] * std::pow(_t,_power[_qp]));
  return thick;
}
