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

#include "Soluble_ODE.h"

template<>
InputParameters validParams<Soluble_ODE>()
{
  InputParameters params = validParams<AuxScalarKernel>();
   params.addParam<std::string>("product_release_rate", "The postprocessor name that integrates the soluble release rate");
   params.addParam<std::string>("wetted_perimeter", "The total wetted_perimeter of this section");
  return params;
}

Soluble_ODE::Soluble_ODE(const InputParameters & parameters) :
    AuxScalarKernel(parameters),
    _product_release_rate(getPostprocessorValueByName(getParam<std::string>("product_release_rate"))),
    _wetted_perimeter(getPostprocessorValueByName(getParam<std::string>("wetted_perimeter")))
{
}

Soluble_ODE::~Soluble_ODE()
{
}

Real
Soluble_ODE::computeValue()
{
// Release comes from diffusional transport of soluble species through the oxide
  Real _release = _product_release_rate;

// Deposition comes through growth of the "outer oxide" crystal layer
  Real _deposition = _u_old[_i];

  return _u_old[_i] + _dt * (_release);
}
