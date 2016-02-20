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

#include "MetalRelease.h"

template<>
InputParameters validParams<MetalRelease>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addRequiredCoupledVar("diffusivity", "The value of the diffusivity for this oxide and metal");
  params.addRequiredCoupledVar("concentration", "The value of this metal's concentration");
  params.addRequiredCoupledVar("thickness", "The value of the oxide thickness");
  params.addRequiredCoupledVar("perimeter", "The value of the wetted perimeter");
  params.addRequiredCoupledVar("number_density", "The value of the number density");
  return params;
}


MetalRelease::MetalRelease(const InputParameters & parameters)
  :AuxKernel(parameters),
   _diffusivity(coupledValue("diffusivity")),
   _concentration(coupledValue("concentration")),
   _thickness(coupledValue("thickness")),
   _perimeter(coupledValue("perimeter")),
   _ND(coupledValue("number_density"))
{}

Real
MetalRelease::computeValue()
{

  Real release = (_diffusivity[_qp] * _concentration[_qp] * _perimeter[_qp] * _ND[_qp]) / (_thickness[_qp] * 6.02e23);
  return release;
}
