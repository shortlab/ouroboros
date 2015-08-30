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

#include "ReactorHeatSource.h"

template<>
InputParameters validParams<ReactorHeatSource>()
{
  InputParameters params = validParams<Kernel>();

  params.addRequiredCoupledVar("wetted_perimeter", "The wetted perimeter field in meters.");
  params.addRequiredCoupledVar("wall_temp", "The AuxVar field giving the wall (clad or SG) temperature in Kelvin.");
  return params;
}

ReactorHeatSource::ReactorHeatSource(const InputParameters & parameters) :
    Kernel(parameters),
    _wetted_perimeter(coupledValue("wetted_perimeter")),
    _wall_temp(coupledValue("wall_temp"))
{}

Real ReactorHeatSource::computeQpResidual()
{
  return _test[_i][_qp]*(_wetted_perimeter[_qp] * (_u[_qp] - _wall_temp[_qp]) / 10000);
}

Real ReactorHeatSource::computeQpJacobian()
{
  return _test[_i][_qp]*(_wetted_perimeter[_qp] * (_phi[_j][_qp]) / 10000);
}
