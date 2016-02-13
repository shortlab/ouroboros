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
  return params;
}


OxideThickness::OxideThickness(const InputParameters & parameters)
  :AuxKernel(parameters),
   _power(getParam<Real>("power")),
   _prefactor(getParam<Real>("prefactor"))
{}

Real
OxideThickness::computeValue()
{

  Real thick = _prefactor * std::pow(_t,_power);
  return thick;
}
