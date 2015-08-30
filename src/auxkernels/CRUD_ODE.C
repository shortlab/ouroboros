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

#include "CRUD_ODE.h"

template<>
InputParameters validParams<CRUD_ODE>()
{
  InputParameters params = validParams<AuxScalarKernel>();
   params.addParam<Real>("deposition_fraction", 1, "Factor for deposition efficiency");
   params.addParam<Real>("erosion_fraction", 1, "Factor for erosion efficiency");
   params.addParam<std::string>("tke_times_crud", "The postprocessor name that integrates the TKE times the deposit thickness");
   params.addParam<std::string>("boiling_rate", "The postprocessor name that integrates the boiling (steaming) rate");
   params.addParam<std::string>("product_release_rate", "The postprocessor name that integrates the microscale simulation calculated crud release rate");
   params.addParam<std::string>("wetted_perimeter", "The total wetted_perimeter of this section");
  return params;
}

CRUD_ODE::CRUD_ODE(const InputParameters & parameters) :
    AuxScalarKernel(parameters),
    _deposition_fraction(getParam<Real>("deposition_fraction")),
    _erosion_fraction(getParam<Real>("erosion_fraction")),
    _tke_times_crud(getPostprocessorValueByName(getParam<std::string>("tke_times_crud"))),
    _boiling_rate(getPostprocessorValueByName(getParam<std::string>("boiling_rate"))),
    _product_release_rate(getPostprocessorValueByName(getParam<std::string>("product_release_rate"))),
    _wetted_perimeter(getPostprocessorValueByName(getParam<std::string>("wetted_perimeter")))
{
}

CRUD_ODE::~CRUD_ODE()
{
}

Real
CRUD_ODE::computeValue()
{
  Real _release = _product_release_rate * _wetted_perimeter;
  Real _erosion = _tke_times_crud * _wetted_perimeter * _erosion_fraction;
  Real _deposition = _u_old[_i] * _boiling_rate * _deposition_fraction;

  return _u_old[_i] + _dt * (_release + _erosion - _deposition);
}
